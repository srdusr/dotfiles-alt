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
        #Write-Host "-- Creating full path to: " $path -ForegroundColor White -BackgroundColor DarkGreen
        New-Item -ItemType Directory -Force -Path $path
    }
}

function Takeown-Registry($key) {
    # TODO does not work for all root keys yet
    switch ($key.split('\')[0]) {
        "HKEY_CLASSES_ROOT" {
            $reg = [Microsoft.Win32.Registry]::ClassesRoot
            $key = $key.substring(18)
        }
        "HKEY_CURRENT_USER" {
            $reg = [Microsoft.Win32.Registry]::CurrentUser
            $key = $key.substring(18)
        }
        "HKEY_LOCAL_MACHINE" {
            $reg = [Microsoft.Win32.Registry]::LocalMachine
            $key = $key.substring(19)
        }
    }

    # get administraor group
    $admins = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-544")
    $admins = $admins.Translate([System.Security.Principal.NTAccount])

    # set owner
    $key = $reg.OpenSubKey($key, "ReadWriteSubTree", "TakeOwnership")
    $acl = $key.GetAccessControl()
    $acl.SetOwner($admins)
    $key.SetAccessControl($acl)

    # set FullControl
    $acl = $key.GetAccessControl()
    $rule = New-Object System.Security.AccessControl.RegistryAccessRule($admins, "FullControl", "Allow")
    $acl.SetAccessRule($rule)
    $key.SetAccessControl($acl)
}

function Takeown-File($path) {
    takeown.exe /A /F $path
    $acl = Get-Acl $path

    # get administraor group
    $admins = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-544")
    $admins = $admins.Translate([System.Security.Principal.NTAccount])

    # add NT Authority\SYSTEM
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($admins, "FullControl", "None", "None", "Allow")
    $acl.AddAccessRule($rule)

    Set-Acl -Path $path -AclObject $acl
}

function Takeown-Folder($path) {
    Takeown-File $path
    foreach ($item in Get-ChildItem $path) {
        if (Test-Path $item -PathType Container) {
            Takeown-Folder $item.FullName
        }
        else {
            Takeown-File $item.FullName
        }
    }
}

function Elevate-Privileges {
    param($Privilege)
    $Definition = @"
    using System;
    using System.Runtime.InteropServices;

    public class AdjPriv {
        [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
            internal static extern bool AdjustTokenPrivileges(IntPtr htok, bool disall, ref TokPriv1Luid newst, int len, IntPtr prev, IntPtr rele);

        [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
            internal static extern bool OpenProcessToken(IntPtr h, int acc, ref IntPtr phtok);

        [DllImport("advapi32.dll", SetLastError = true)]
            internal static extern bool LookupPrivilegeValue(string host, string name, ref long pluid);

        [StructLayout(LayoutKind.Sequential, Pack = 1)]
            internal struct TokPriv1Luid {
                public int Count;
                public long Luid;
                public int Attr;
            }

        internal const int SE_PRIVILEGE_ENABLED = 0x00000002;
        internal const int TOKEN_QUERY = 0x00000008;
        internal const int TOKEN_ADJUST_PRIVILEGES = 0x00000020;

        public static bool EnablePrivilege(long processHandle, string privilege) {
            bool retVal;
            TokPriv1Luid tp;
            IntPtr hproc = new IntPtr(processHandle);
            IntPtr htok = IntPtr.Zero;
            retVal = OpenProcessToken(hproc, TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, ref htok);
            tp.Count = 1;
            tp.Luid = 0;
            tp.Attr = SE_PRIVILEGE_ENABLED;
            retVal = LookupPrivilegeValue(null, privilege, ref tp.Luid);
            retVal = AdjustTokenPrivileges(htok, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero);
            return retVal;
        }
    }
"@
    $ProcessHandle = (Get-Process -id $pid).Handle
    $type = Add-Type $definition -PassThru
    $type[0]::EnablePrivilege($processHandle, $Privilege)
}

# Elevate so I can run everything ------------------------
Write-Output "Elevating priviledges for this process"
do { } until (Elevate-Privileges SeTakeOwnershipPrivilege)

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

# Kill OneDrive with fire ------------------------
Write-Output "Kill OneDrive process"
taskkill.exe /F /IM "OneDrive.exe"
taskkill.exe /F /IM "explorer.exe"

Write-Output "Remove OneDrive"
if (Test-Path "$env:systemroot\System32\OneDriveSetup.exe") {
    & "$env:systemroot\System32\OneDriveSetup.exe" /uninstall
}
if (Test-Path "$env:systemroot\SysWOW64\OneDriveSetup.exe") {
    & "$env:systemroot\SysWOW64\OneDriveSetup.exe" /uninstall
}

Write-Output "Removing OneDrive leftovers"
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:localappdata\Microsoft\OneDrive"
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:programdata\Microsoft OneDrive"
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:systemdrive\OneDriveTemp"
# check if directory is empty before removing:
If ((Get-ChildItem "$env:userprofile\OneDrive" -Recurse | Measure-Object).Count -eq 0) {
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:userprofile\OneDrive"
}

Write-Output "Disable OneDrive via Group Policies"
force-mkdir "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive"
Set-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive" "DisableFileSyncNGSC" 1

Write-Output "Remove Onedrive from explorer sidebar"
New-PSDrive -PSProvider "Registry" -Root "HKEY_CLASSES_ROOT" -Name "HKCR"
force-mkdir "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
Set-ItemProperty "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 0
force-mkdir "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
Set-ItemProperty "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 0
Remove-PSDrive "HKCR"

# Thank you Matthew Israelsson
Write-Output "Removing run hook for new users"
reg load "hku\Default" "C:\Users\Default\NTUSER.DAT"
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f
reg unload "hku\Default"

Write-Output "Removing startmenu entry"
Remove-Item -Force -ErrorAction SilentlyContinue "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"

Write-Output "Removing scheduled task"
Get-ScheduledTask -TaskPath '\' -TaskName 'OneDrive*' -ea SilentlyContinue | Unregister-ScheduledTask -Confirm:$false

Write-Output "Restarting explorer"
Start-Process "explorer.exe"

Write-Output "Waiting for explorer to complete loading"
Start-Sleep 10

Write-Output "Removing additional OneDrive leftovers"
foreach ($item in (Get-ChildItem "$env:WinDir\WinSxS\*onedrive*")) {
    Takeown-Folder $item.FullName
    Remove-Item -Recurse -Force $item.FullName
}

# As a last step, disable UAC ------------------------
New-ItemProperty -Path HKLM:Software\Microsoft\Windows\CurrentVersion\policies\system -Name EnableLUA -PropertyType DWord -Value 0 -Force

# Gets the "MyDocuments" path for the current user since it can be local or remote
$UserMyDocumentsPath = [Environment]::GetFolderPath('MyDocuments')

$PowerShellProfileDirectory = "$UserMyDocumentsPath\PowerShell"
$PowerShellLegacySymlink = "$UserMyDocumentsPath\WindowsPowerShell"
#$WindowsTerminalSettingsDirectory = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

$PowerShellProfileTemplate = "$PSScriptRoot\$USERNAME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
#$PowerShellThemeTemplate = "$PSScriptRoot\windows_terminal\theme.omp.json"
#$WindowsTerminalSettingsTemplate = "$PSScriptRoot\windows_terminal\settings.json"

# Remove OneDrive directory
Write-Host "Removing OneDrive directory"
#Remove-Item "$env:USERPROFILE\OneDrive" -Recurse -Force
cd $HOME
rm OneDrive -r -force

# Configure PowerShell
Write-Host "Configuring PowerShell"
Write-Host "----------------------------------------"

# Set documents path to user's local Documents folder
$documentsPath = "$env:USERPROFILE\Documents"
$powerShellProfileDir = "$documentsPath\PowerShell"

# Output the chosen PowerShell profile directory
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
Add-Content -Path $PROFILE -Value "`nfunction config { git --git-dir=`$env:USERPROFILE/.cfg/ --work-tree=`$env:USERPROFILE @args }"
Add-Content -Path $PROFILE -Value "`n. $PROFILE"

# Source the profile immediately to make the alias available
. $PROFILE

#echo '. "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"' >> $PROFILE

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

. $PROFILE

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

# Define the list of applications to install
$apps = @("ripgrep", "fd", "sudo", "win32yank", "neovim", "microsoft-windows-terminal")

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

## WSL
#Write-Host "Configuring WSL"
#wsl --install -d Ubuntu

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
New-Item -ItemType Junction -Force `
    -Path "$home\AppData\Local\nvim" `
    -Target "$home\.config\nvim"

# Install Windows Terminal, and configure
Write-Host "Install Windows Terminal, and configure"
Write-Host "----------------------------------------"
Move-Item -Force "$home\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" "$home\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json.old"
New-Item -ItemType HardLink -Force `
    -Path "$home\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" `
    -Target "$home\.config\windows-terminal\settings.json"

# Registry Tweaks
Write-Host "Registry Tweaks"
Write-Host "----------------------------------------"

## Show hidden files
#Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Hidden -Value 1
#
## Show file extensions for known file types
#Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt -Value 0
#
## Never Combine taskbar buttons when the taskbar is full
#Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarGlomLevel -Value 2
#
## Taskbar small icons
#Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarSmallIcons -Value 1
#
## Set Windows to use UTC time instead of local time for system clock
#Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name RealTimeIsUniversal -Value 1

## Function to disable the Windows key
#function Disable-WindowsKey {
#    $scancodeMap = @(
#        0x00000000, 0x00000000, 0x00000003, 0xE05B0000, 0xE05C0000, 0x00000000
#    )
#
#    $binaryValue = New-Object byte[] ($scancodeMap.Length * 4)
#    [System.Buffer]::BlockCopy($scancodeMap, 0, $binaryValue, 0, $binaryValue.Length)
#
#    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout" -Name "Scancode Map" -Value $binaryValue
#
#    Write-Output "Windows key has been disabled. Please restart your computer for the changes to take effect."
#}
#
## Check if running as Administrator and call the function
#if (Test-IsAdmin) {
#    Disable-WindowsKey
#} else {
#    Write-Output "You need to run this script as Administrator to disable the Windows key."
#}
## Restart to apply changes
#Write-Host "Restarting system to apply changes..."
#Restart-Computer -Force
