# Requires -RunAsAdministrator

# Variables
$newUsername = "srdusr"
$dotfiles_url = 'https://github.com/srdusr/dotfiles.git'
$dotfiles_dir = "$HOME\.cfg"
$oldUsername = $env:USERNAME

# Function to handle errors
function handle_error {
    param ($message)
    Write-Host $message -ForegroundColor Red
    #exit 1
}

# Install Chocolatey
Write-Host "Installing Chocolatey"
Write-Host "----------------------------------------"
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install Applications
Write-Host "Installing Applications"
Write-Host "----------------------------------------"
$apps = @("ripgrep", "fd", "sudo", "win32yank", "neovim")
foreach ($app in $apps) {
    choco install $app -y
}

# Define the `config` alias in the current session
function global:config {
    git --git-dir="$env:USERPROFILE\.cfg" --work-tree="$env:USERPROFILE" $args
}

# Add .gitignore entries
Add-Content -Path "$HOME\.gitignore" -Value ".cfg"
Add-Content -Path "$HOME\.gitignore" -Value "install.bat"
Add-Content -Path "$HOME\.gitignore" -Value ".config/powershell/bootstrap.ps1"

Set-ExecutionPolicy RemoteSigned

# Check if the profile exists, otherwise create it
if (!(Test-Path -Path $PROFILE)) {
    New-Item -Type File -Path $PROFILE -Force
}
Add-Content -Path $PROFILE -Value "`nfunction config { git --git-dir=`$env:USERPROFILE/.cfg/ --work-tree=`$env:USERPROFILE @args }"
Add-Content -Path $PROFILE -Value "`n. $PROFILE"

# Source the profile immediately to make the alias available
. $PROFILE

# Function to install dotfiles
function install_dotfiles {
    if (Test-Path -Path $dotfiles_dir) {
        config pull | Out-Null
        $update = $true
    } else {
        git clone --bare $dotfiles_url $dotfiles_dir | Out-Null
        $update = $false
    }

    $std_err_output = config checkout 2>&1

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

# Function to install SSH
function install_ssh {
    Write-Host "Setting Up SSH"
    Start-Service ssh-agent
    Start-Service sshd
    Set-Service -Name ssh-agent -StartupType 'Automatic'
    Set-Service -Name sshd -StartupType 'Automatic'

    #Generate SSH key if not exists
    if (-not (Test-Path -Path "$env:USERPROFILE\.ssh\id_rsa.pub")) {
        ssh-keygen -t rsa -b 4096 -C "$newUsername@$(hostname)" -f "$env:USERPROFILE\.ssh\id_rsa" -N ""
    }

    # Start ssh-agent and add key
    eval $(ssh-agent -s)
    ssh-add "$env:USERPROFILE\.ssh\id_rsa"

    # Display the SSH key
    $sshKey = Get-Content "$env:USERPROFILE\.ssh\id_rsa.pub"
    Write-Host "Add the following SSH key to your GitHub account:"
    Write-Host $sshKey
}

install_ssh

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
    -Target "$home\.config\terminal\settings.json"

# Registry Tweaks
Write-Host "Registry Tweaks"
Write-Host "----------------------------------------"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSuperHidden" -Value 1
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "AutoEndTasks" -Value 1

# Disable Windows Key
function Disable-WindowsKey {
    $key = "HKLM:\System\CurrentControlSet\Control\Keyboard Layout"
    $name = "Scancode Map"
    $value = [byte[]](0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x00,0x00,0x5B,0xE0,0x00,0x00,0x5C,0xE0,0x00,0x00,0x00,0x00)
    Set-ItemProperty -Path $key -Name $name -Value $value
    Write-Host "Windows key disabled. Reboot to apply changes."
}

# Optional: Disable Windows Key
Disable-WindowsKey

# Restart to apply changes
Write-Host "Restarting system to apply changes..."
#Restart-Computer -Force
