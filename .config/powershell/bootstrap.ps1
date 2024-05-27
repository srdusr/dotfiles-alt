#Requires -RunAsAdministrator

# Write-Host Set PowerShell Execution Policy
# Write-Host ----------------------------------------
# Set-ExecutionPolicy Unrestricted


# Install NVM
Write-Host Configuring NVM
Write-Host ----------------------------------------
$installPath = "C:\Users\%USERPROFILE%\AppData\Roaming\nvm"
if (-not (Test-Path -Path $installPath))
{
	$nvmUrl =  "https://github.com/coreybutler/nvm-windows/releases/latest/download/nvm-setup.zip"
	$extractPath = "C:\Temp\nvm\"
	$downloadZipFile = $extractPath + $(Split-Path -Path $nvmUrl -Leaf)
	mkdir $extractPath
	Invoke-WebRequest -Uri $nvmUrl -OutFile $downloadZipFile
	$extractShell = New-Object -ComObject Shell.Application
	$extractFiles = $extractShell.Namespace($downloadZipFile).Items()
	$extractShell.NameSpace($extractPath).CopyHere($extractFiles)
	pushd $extractPath
	Start-Process .\nvm-setup.exe -Wait
	popd
	Read-Host -Prompt "Setup done, now close the command window, and run this script again in a new elevated window. Press any key to continue"
	Exit
}
else
{
	Write-Host Detected that NVM is already installed, so now using it to install NodeJS LTS
	pushd $installPath
	.\nvm.exe install lts
	.\nvm.exe use lts
	popd
}


# WSL
Write-Host Configuring WSL
wsl --install -d Ubuntu


# Install Chocolatey
Write-Host Install Chocolatey
Write-Host ----------------------------------------
Set-ExecutionPolicy Bypass -Scope Process -Force;
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))


# Install Applications
Write-Host Install Applications
Write-Host ----------------------------------------
choco install ripgrep # https://github.com/BurntSushi/ripgrep
choco install fd # https://github.com/sharkdp/fd
choco install sudo # ALLOWS USING sudo IN POWERSHELL!
choco install win32yank # Neovim clipboard support in WSL, FROM: https://stackoverflow.com/a/67229362/182888


# Configure Neovim
Write-Host Configuring Neovim
Write-Host ----------------------------------------
New-Item -ItemType Junction -Force `
	-Path "$home\AppData\Local\nvim" `
	-Target "$home\.config\nvim"


# Install Windows Terminal
Write-Host Install Windows Terminal, and configure
Write-Host ----------------------------------------
Move-Item -Force "$home\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" "$home\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json.old"
New-Item -ItemType HardLink -Force `
	-Path "$home\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" `
	-Target "$home\.config\windows-terminal\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"


# Configure Powershell
Write-Host Configuring PowerShell
Write-Host ----------------------------------------
New-Item -ItemType HardLink -Force `
	-Path "$home\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" `
	-Target "$home\.config\powershell\Microsoft.PowerShell_profile.ps1"


# Registry Tweaks
Write-Host Registry Tweaks
Write-Host ----------------------------------------

# Show hidden files
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Hidden 1

# Show file extensions for known file types
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt 0

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
