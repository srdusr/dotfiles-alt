#Requires -RunAsAdministrator

# Variables
$newUsername = "srdusr"
$dotfiles_url = 'https://github.com/srdusr/dotfiles.git'
$dotfiles_dir = "$HOME\.cfg"
$oldUsername = $env:USERNAME

# Change current username
$userName = Get-WmiObject win32_userAccount -Filter "Name='$oldUsername'"
$result = $userName.Rename($newUsername)

# Set alias for git without work tree
function git_without_work_tree {
    if (Test-Path -Path ".git") {
        $isInsideWorkTree = git rev-parse --is-inside-work-tree 2>$null
        if ($isInsideWorkTree -eq "true") {
            $GIT_WORK_TREE_OLD = $env:GIT_WORK_TREE
            Remove-Item Env:\GIT_WORK_TREE
            & git @args
            $env:GIT_WORK_TREE = $GIT_WORK_TREE_OLD
        } else {
            & git @args
        }
    } else {
        & git @args
    }
}
Set-Alias git git_without_work_tree

# Add .gitignore entries
Add-Content -Path "$HOME\.gitignore" -Value ".cfg"
Add-Content -Path "$HOME\.gitignore" -Value "install.bat"
Add-Content -Path "$HOME\.gitignore" -Value ".config/powershell/bootstray.ps1"

# Check if the profile exists, otherwise create it
if (!(Test-Path -Path $PROFILE)) {
    New-Item -Type File -Path $PROFILE -Force
}
Add-Content -Path $PROFILE -Value "'$env:USERPROFILE\.cfg'"
Add-Content -Path $PROFILE -Value "function global:config { git --git-dir=$env:USERPROFILE/.cfg --work-tree=$env:USERPROFILE @args }"

# Function to handle errors
function handle_error {
    param ($message)
    Write-Host $message
    exit 1
}

# Function to install dotfiles
function install_dotfiles {
    if (Test-Path -Path $dotfiles_dir) {
        config pull | Out-Null
        $update = $true
    } else {
        git clone --bare $dotfiles_url $dotfiles_dir | Out-Null
        $update = $false
    }

    $std_err_output = config checkout 2>&1 | Out-Null

    if ($std_err_output -match "following untracked working tree files would be overwritten") {
        if (-not $update) {
            config checkout -- /dev/null | Out-Null
        }
    }
    config config status.showUntrackedFiles no

    git config --global include.path "$HOME\.gitconfig.aliases"

    if ($update -or (Read-Host "Do you want to overwrite existing files and continue with the dotfiles setup? [Y/n]" -eq "Y")) {
        config fetch origin main:main | Out-Null
        config reset --hard main | Out-Null
        config checkout -f
        if ($?) {
            Write-Host "Successfully imported $dotfiles_dir."
        } else {
            handle_error "Mission failed."
        }
    } else {
        handle_error "Aborted by user. Exiting..."
    }
}

install_dotfiles

# Function to check if NVM is installed
function Test-NVMInstalled {
    $nvmPath = "$env:USERPROFILE\AppData\Roaming\nvm\nvm.exe"
    return Test-Path -Path $nvmPath
}

# Install NVM if not installed
Write-Host "Configuring NVM"
Write-Host "----------------------------------------"
if (-not (Test-NVMInstalled)) {
    Write-Host "NVM is not installed. Proceeding with installation."
    $nvmUrl = "https://github.com/coreybutler/nvm-windows/releases/latest/download/nvm-setup.zip"
    $extractPath = "C:\Temp\nvm\"
    $downloadZipFile = $extractPath + (Split-Path -Path $nvmUrl -Leaf)
    New-Item -ItemType Directory -Path $extractPath -Force
    Invoke-WebRequest -Uri $nvmUrl -OutFile $downloadZipFile
    $extractShell = New-Object -ComObject Shell.Application
    $extractFiles = $extractShell.Namespace($downloadZipFile).Items()
    $extractShell.NameSpace($extractPath).CopyHere($extractFiles)
    Push-Location $extractPath
    Start-Process .\nvm-setup.exe -Wait
    Pop-Location
    Read-Host -Prompt "Setup done, now close the command window, and run this script again in a new elevated window. Press any key to continue"
    Exit
} else {
    Write-Host "Detected that NVM is already installed. Now using it to install NodeJS LTS."
    $nvmPath = "$env:USERPROFILE\AppData\Roaming\nvm"
    Push-Location $nvmPath
    .\nvm.exe install lts
    .\nvm.exe use lts
    Pop-Location
}

# WSL
Write-Host "Configuring WSL"
wsl --install -d Ubuntu

# Install Chocolatey
Write-Host "Installing Chocolatey"
Write-Host "----------------------------------------"
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install Applications
Write-Host "Installing Applications"
Write-Host "----------------------------------------"
choco install ripgrep -y
choco install fd -y
choco install sudo -y
choco install win32yank -y

# Configure Neovim
Write-Host "Configuring Neovim"
Write-Host "----------------------------------------"
New-Item -ItemType Junction -Force `
    -Path "$home\AppData\Local\nvim" `
    -Target "$home\.config\nvim"

# Install Windows Terminal, and configure
Write-Host "Install Windows Terminal, and configure"
Write-Host "----------------------------------------"
Move-Item -Force "$home\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" "$home\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json.old"
New-Item -ItemType HardLink -Force `
    -Path "$home\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" `
    -Target "$home\.config\windows-terminal\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# Configure PowerShell
Write-Host "Configuring PowerShell"
Write-Host "----------------------------------------"
$documentsPath = [Environment]::GetFolderPath('Personal') # Default Documents folder
if ($documentsPath -like "*OneDrive*") {
    $documentsPath = "$env:USERPROFILE\Documents"
}
$powerShellProfileDir = "$documentsPath\PowerShell"

if (-not (Test-Path -Path $powerShellProfileDir)) {
    New-Item -ItemType Directory -Path $powerShellProfileDir -Force
}
New-Item -ItemType HardLink -Force `
    -Path "$powerShellProfileDir\Microsoft.PowerShell_profile.ps1" `
    -Target "$home\.config\powershell\Microsoft.PowerShell_profile.ps1"

# Registry Tweaks
Write-Host "Registry Tweaks"
Write-Host "----------------------------------------"

# Show hidden files
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Hidden -Value 1

# Show file extensions for known file types
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt -Value 0

# Never Combine taskbar buttons when the taskbar is full
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarGlomLevel -Value 2

# Taskbar small icons
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarSmallIcons -Value 1

# Set Windows to use UTC time instead of local time for system clock
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name RealTimeIsUniversal -Value 1

# Function to check if the current session is elevated
function Test-IsAdmin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Function to disable the Windows key
function Disable-WindowsKey {
    $scancodeMap = @(
        0x00000000, 0x00000000, 0x00000003, 0xE05B0000, 0xE05C0000, 0x00000000
    )

    $binaryValue = New-Object byte[] ($scancodeMap.Length * 4)
    [System.Buffer]::BlockCopy($scancodeMap, 0, $binaryValue, 0, $binaryValue.Length)

    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout" -Name "Scancode Map" -Value $binaryValue

    Write-Output "Windows key has been disabled. Please restart your computer for the changes to take effect."
}

# Check if running as Administrator and call the function
if (Test-IsAdmin) {
    Disable-WindowsKey
} else {
    Write-Output "You need to run this script as Administrator to disable the Windows key."
}



