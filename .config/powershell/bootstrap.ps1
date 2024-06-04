# Requires -RunAsAdministrator

# Set execution policy to remote signed
#Set-ExecutionPolicy RemoteSigned
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Set network category to private
Set-NetConnectionProfile -NetworkCategory Private

# Variables
$dotfiles_url = 'https://github.com/srdusr/dotfiles.git'
$dotfiles_dir = "$HOME\.cfg"

# Imports
. $HOME\.config\powershell\initialize.ps1
. $HOME\.config\powershell\ownership.ps1
. $HOME\.config\powershell\onedrive.ps1

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

$bloatware = @(
    #"Anytime"
    "BioEnrollment"
    #"Browser"
    "ContactSupport"
    "Cortana"
    #"Defender"
    "Feedback"
    "Flash"
    #"Gaming"	# Breaks Xbox Live Account Login
    #"Holo"
    #"InternetExplorer"
    "Maps"
    #"MiracastView"
    "OneDrive"
    #"SecHealthUI"
    "Wallet"
    #"Xbox"     # Causes a bootloop since upgrade 1511?
)

# Helper functions ------------------------
function force-mkdir($path) {
    if (!(Test-Path $path)) {
        Write-Host "-- Creating full path to: " $path -ForegroundColor White -BackgroundColor DarkGreen
        New-Item -ItemType Directory -Force -Path $path
    }
}

# Remove Features ------------------------
foreach ($bloat in $bloatware) {
   Write-Output "Removing packages containing $bloat"
   $pkgs = (Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages" |
       Where-Object Name -Like "*$bloat*")

   foreach ($pkg in $pkgs) {
       $pkgname = $pkg.Name.split('\')[-1]
       Takeown-Registry($pkg.Name)
       Takeown-Registry($pkg.Name + "\Owners")
       Set-ItemProperty -Path ("HKLM:" + $pkg.Name.Substring(18)) -Name Visibility -Value 1
       New-ItemProperty -Path ("HKLM:" + $pkg.Name.Substring(18)) -Name DefVis -PropertyType DWord -Value 2
       Remove-Item      -Path ("HKLM:" + $pkg.Name.Substring(18) + "\Owners")
       dism.exe /Online /Remove-Package /PackageName:$pkgname /NoRestart
   }
}

# Remove default apps and bloat ------------------------
Write-Output "Uninstalling default apps"
foreach ($app in $apps) {
   Write-Output "Trying to remove $app"
   Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -AllUsers
   Get-AppXProvisionedPackage -Online |
   Where-Object DisplayName -EQ $app |
   Remove-AppxProvisionedPackage -Online
}

# Prevents "Suggested Applications" returning
force-mkdir "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Cloud Content"
Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Cloud Content" "DisableWindowsConsumerFeatures" 1

# Configure PowerShell
Write-Host "Configuring PowerShell"
Write-Host "----------------------------------------"

# Get the "MyDocuments" path for the current user, excluding OneDrive
$UserMyDocumentsPath = [System.Environment]::GetFolderPath('MyDocuments').Replace("OneDrive", "") + "\Documents"

$PowerShellProfileDirectory = "$UserMyDocumentsPath\PowerShell"
$PowerShellLegacySymlink = "$UserMyDocumentsPath\WindowsPowerShell"

$PowerShellProfileTemplate = "$PSScriptRoot\$USERNAME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
$env:PSModulePath = $env:PSModulePath -replace "\\OneDrive\\Documents\\WindowsPowerShell\\","\.powershell\"

# Set documents path to user's local Documents folder
$documentsPath = "$UserMyDocumentsPath"
$powerShellProfileDir = "$documentsPath\PowerShell"

# Output the chosen PowerShell profile directory
$PROFILE = "$powerShellProfileDir\Microsoft.PowerShell_profile.ps1"
Write-Host "PowerShell profile directory set to: $powerShellProfileDir"

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

# Install Chocolatey if not installed
Write-Host "Installing Chocolatey"
Write-Host "----------------------------------------"

Set-ExecutionPolicy Bypass -Scope Process -Force

if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

    # Check if Chocolatey installed successfully
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        handle_error "Chocolatey installation failed."
    }
} else {
    Write-Host "Chocolatey is already installed."
}

# Install Applications
Write-Host "Installing Applications"
Write-Host "----------------------------------------"

# List of applications to install
$apps = @(
    "git",
    "ripgrep",
    "fd",
    "sudo",
    "win32yank",
    "neovim",
    "microsoft-windows-terminal",
    "wsl",
    "firefox",
    #"spotify",
    #"discord",
    #"vscode",
    "nodejs",
    "bat",
    #"coreutils",
    #"delta",
    #"fnm",
    #"gh",
    #"less",
    #"lua",
    #"make",
    #"tokei",
    #"zoxide"
)

foreach ($app in $apps) {
    # Check if the application is already installed
    if (-not (choco list --local-only | Select-String -Pattern "^$app\s")) {
        Write-Host "Installing $app"
        choco install $app -y

        if ($LASTEXITCODE -ne 0) {
            handle_error "Installation of $app failed."
        } else {
            Write-Host "$app installed successfully."
        }
    } else {
        Write-Host "$app is already installed."
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

## Check if the profile exists, otherwise create it
#if (!(Test-Path -Path $PROFILE)) {
#    New-Item -Type File -Path $PROFILE -Force
#}
#Add-Content -Path $PROFILE -Value "`nfunction config { git --git-dir=`$env:USERPROFILE/.cfg/ --work-tree=`$env:USERPROFILE @args }"
#Add-Content -Path $PROFILE -Value "`n. $PROFILE"

# Source the profile immediately to make the alias available

#echo '. "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"' >> $PROFILE

# Create symbolik links
Write-Host "Create symbolik links"
Write-Host "----------------------------------------"

# Visual Studio Code settings.json
New-Item -Force -ItemType SymbolicLink $HOME\AppData\Roaming\Code\User\ -Name settings.json -Value $HOME\.config\Code\User\settings.json

# Visual Studio Code keybindings
New-Item -Force -ItemType SymbolicLink $HOME\AppData\Roaming\Code\User\ -Name keybindings.json -Value $HOME\.config\Code\User\keybindings.json


# Update the current session environment variables
Write-Host "Setting environment variables" -ForegroundColor Cyan
[Environment]::SetEnvironmentVariable("HOME", "$env:USERPROFILE", "User")
[Environment]::SetEnvironmentVariable("LC_ALL", "C.UTF-8", "User")
Update-SessionEnvironment

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
            config checkout | Out-Null
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

#. $PROFILE

# Install python
Write-Host "Updating python packages" -ForegroundColor Cyan
python -m pip install --upgrade pip
pip install --upgrade black flake8

# Enable WSL feature
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
Write-Host "Enable WSL feature"

# Enable Virtual Machine feature
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
Write-Host "Enable Virtual Machine feature"

# WSL
Write-Host "Configuring WSL"
#wsl --install -d Ubuntu
# setup wsl
wsl --set-default-version 2
wsl -s Ubuntu

## Function to install SSH
#function install_ssh {
#    Write-Host "Setting Up SSH"
#    Start-Service ssh-agent
#    Start-Service sshd
#    Set-Service -Name ssh-agent -StartupType 'Automatic'
#    Set-Service -Name sshd -StartupType 'Automatic'
#
#    # Generate SSH key if not exists
#    if (-not (Test-Path -Path "$env:USERPROFILE\.ssh\id_rsa.pub")) {
#        ssh-keygen -t rsa -b 4096 -C "$env:USERNAME@$(hostname)" -f "$env:USERPROFILE\.ssh\id_rsa" -N ""
#    }
#
#    # Start ssh-agent and add key
#    eval $(ssh-agent -s)
#    ssh-add "$env:USERPROFILE\.ssh\id_rsa"
#
#    # Display the SSH key
#    $sshKey = Get-Content "$env:USERPROFILE\.ssh\id_rsa.pub"
#    Write-Host "Add the following SSH key to your GitHub account:"
#    Write-Host $sshKey
#}
#
#install_ssh

# Configure Neovim
Write-Host "Configuring Neovim"
Write-Host "----------------------------------------"

$neovimLocalPath = "$home\AppData\Local\nvim"
$neovimConfigPath = "$home\.config\nvim"

# Check if nvim directory already exists in AppData\Local
if (-not (Test-Path -Path $neovimLocalPath)) {
    New-Item -ItemType Junction -Force -Path $neovimLocalPath -Target $neovimConfigPath
} else {
    Write-Host "Neovim directory ($neovimLocalPath) already exists."
}

# Install Windows Terminal, and configure
Write-Host "Install Windows Terminal, and configure"
Write-Host "----------------------------------------"

$windowsTerminalSettingsPath = "$home\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$windowsTerminalConfigPath = "$home\.config\windows-terminal\settings.json"

# Check if Windows Terminal settings.json already exists
if (Test-Path -Path $windowsTerminalSettingsPath) {
    # Backup existing settings.json
    Move-Item -Force $windowsTerminalSettingsPath "$windowsTerminalSettingsPath.old"
} else {
    Write-Host "Windows Terminal settings.json not found."
}

# Create a hard link to the settings.json file in .config\windows-terminal
New-Item -ItemType HardLink -Force -Path $windowsTerminalSettingsPath -Target $windowsTerminalConfigPath

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
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout"
    $regName = "Scancode Map"

    # Binary data to disable the Windows key
    $binaryValue = [byte[]](
        0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00,
        0x03, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x5B, 0xE0,
        0x00, 0x00, 0x5C, 0xE0,
        0x00, 0x00, 0x00, 0x00
    )

    # Create the registry key if it doesn't exist
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the Scancode Map value
    Set-ItemProperty -Path $regPath -Name $regName -Value $binaryValue

    Write-Output "Windows key has been disabled. Please restart your computer for the changes to take effect."
}

# Check if running as Administrator and call the function
if (Test-IsAdmin) {
    Disable-WindowsKey
} else {
    Write-Output "You need to run this script as Administrator to disable the Windows key."
}

Write-Host "Bootstrap script completed."

# Restart to apply changes
#Write-Host "Restarting system to apply changes..."
#Restart-Computer -Force
