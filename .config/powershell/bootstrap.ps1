# Requires -RunAsAdministrator

# Variables
#$newUsername = "srdusr"
$dotfiles_url = 'https://github.com/srdusr/dotfiles.git'
$dotfiles_dir = "$HOME\.cfg"
$oldUsername = $env:USERNAME

# Function to handle errors
function handle_error {
    param ($message)
    Write-Host $message -ForegroundColor Red
    exit 1
}

# Function to check if the current session is elevated
function Test-IsAdmin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Ensure the script is run as administrator
if (-not (Test-IsAdmin)) {
    handle_error "This script must be run as an administrator."
}

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

# Set environment variable
[System.Environment]::SetEnvironmentVariable('PowerShellProfileDir', $powerShellProfileDir, [System.EnvironmentVariableTarget]::User)

Write-Host "PowerShell profile directory set to: $powerShellProfileDir"
Write-Host "Environment variable 'PowerShellProfileDir' set to: $powerShellProfileDir"

# Verify profile sourcing
if (!(Test-Path -Path "$home\.config\powershell\Microsoft.PowerShell_profile.ps1")) {
    handle_error "PowerShell profile does not exist. Please create it at $home\.config\powershell\Microsoft.PowerShell_profile.ps1"
}

# Install Chocolatey
Write-Host "Installing Chocolatey"
Write-Host "----------------------------------------"
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Check if Chocolatey installed successfully
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    handle_error "Chocolatey installation failed."
}

# Install Applications
Write-Host "Installing Applications"
Write-Host "----------------------------------------"
$apps = @("ripgrep", "fd", "sudo", "win32yank", "neovim", "microsoft-windows-terminal")
foreach ($app in $apps) {
    choco install $app -y
    if ($LASTEXITCODE -ne 0) {
        handle_error "Installation of $app failed."
    }
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

echo '. "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"' >> $PROFILE

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

    # Generate SSH key if not exists
    if (-not (Test-Path -Path "$env:USERPROFILE\.ssh\id_rsa.pub")) {
        ssh-keygen -t rsa -b 4096 -C "$env:USERNAME@$(hostname)" -f "$env:USERPROFILE\.ssh\id_rsa" -N ""
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
# Restart to apply changes
Write-Host "Restarting system to apply changes..."
Restart-Computer -Force
