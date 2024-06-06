# bloatware.ps1

# Check if Registry key exists
function Check-RegistryKeyExists {
    param(
        [Parameter(Mandatory = $true)]
        [string]$KeyPath
    )

    if (Test-Path $KeyPath) {
        Write-Host "Registry key exists: $KeyPath"
        return $true
    } else {
        Write-Host "Registry key does not exist: $KeyPath"
        return $false
    }
}

# Helper functions ------------------------
function force-mkdir($path) {
    if (!(Test-Path $path)) {
        Write-Host "-- Creating full path to: " $path -ForegroundColor White -BackgroundColor DarkGreen
        New-Item -ItemType Directory -Force -Path $path
    }
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
    #"Gaming"    # Breaks Xbox Live Account Login
    #"Holo"
    #"InternetExplorer"
    "Maps"
    #"MiracastView"
    "OneDrive"
    #"SecHealthUI"
    "Wallet"
    #"Xbox"     # Causes a bootloop since upgrade 1511?
)

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
if (Check-RegistryKeyExists -KeyPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Cloud Content") {
    Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Cloud Content" "DisableWindowsConsumerFeatures" 1
}

# Disable Microsoft Edge sidebar
$RegistryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Edge'
$Name = 'HubsSidebarEnabled'
$Value = '00000000'
# Create the key if it does not exist
If (-NOT (Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType DWORD -Force

# Disable Microsoft Edge first-run Welcome screen
$RegistryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Edge'
$Name = 'HideFirstRunExperience'
$Value = '00000001'
# Create the key if it does not exist
If (-NOT (Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType DWORD -Force

# Remove Microsoft Edge ------------------------
$ErrorActionPreference = "Stop"
$regView = [Microsoft.Win32.RegistryView]::Registry32
$microsoft = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $regView).
OpenSubKey('SOFTWARE\Microsoft', $true)
$edgeUWP = "$env:SystemRoot\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe"
$uninstallRegKey = $microsoft.OpenSubKey('Windows\CurrentVersion\Uninstall\Microsoft Edge')
$uninstallString = $uninstallRegKey.GetValue('UninstallString') + ' --force-uninstall'

$edgeClient = $microsoft.OpenSubKey('EdgeUpdate\ClientState\{56EB18F8-B008-4CBD-B6D2-8C97FE7E9062}', $true)
if ($null -ne $edgeClient.GetValue('experiment_control_labels')) {
	$edgeClient.DeleteValue('experiment_control_labels')
}
$microsoft.CreateSubKey('EdgeUpdateDev').SetValue('AllowUninstall', '')
[void](New-Item $edgeUWP -ItemType Directory -ErrorVariable fail -ErrorAction SilentlyContinue)
[void](New-Item "$edgeUWP\MicrosoftEdge.exe" -ErrorAction Continue)
Start-Process cmd.exe "/c $uninstallString" -WindowStyle Hidden -Wait
[void](Remove-Item "$edgeUWP\MicrosoftEdge.exe" -ErrorAction Continue)

if (-not $fail) {
	[void](Remove-Item "$edgeUWP")
}

Write-Output "Edge should now be uninstalled!"

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

# Remove OneDrive directory
Write-Host "Removing OneDrive directory"
cd $HOME
rm OneDrive -r -force

# Prevents "Suggested Applications" returning
if (Check-RegistryKeyExists -KeyPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Cloud Content") {
    Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Cloud Content" "DisableWindowsConsumerFeatures" 1
}
