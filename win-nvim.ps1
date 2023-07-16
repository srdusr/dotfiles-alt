# Install Git (if not already present on the system)
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    winget install Git.Git
}

# Install NeoVim with winget, if not already present on the system
if (!(Get-Command nvim -ErrorAction SilentlyContinue)) {
    winget install Neovim.Neovim
}

# Clone my dotfiles repo
$dotFilesRoot = Join-Path $HOME "dotfiles"

if (!(Test-Path $dotFilesRoot -PathType Container)) {
    git clone https://github.com/srdusr/dotfiles.git $dotFilesRoot
}

# Link NeoVim configuration
$localConfiguration = Join-Path $env:LOCALAPPDATA "nvim"
$dotfilesConfiguration = Join-Path (Join-Path $dotFilesRoot ".config") "nvim"

if (!(Test-Path $localConfiguration -PathType Container)) { 
    cmd /c "mklink /D `"$localConfiguration`" `"$dotfilesConfiguration`"" | Out-Null
}

# Clone Packer.nvim, if not already present on the system
$localPacker = Join-Path $env:LOCALAPPDATA "nvim" "pack" "packer" "start" "packer.nvim"

if (!(Test-Path $localPacker -PathType Container)) { 
    git clone https://github.com/wbthomason/packer.nvim $localPacker
}

# To allow script execution, run the following command in PowerShell as an administrator:
# Set-ExecutionPolicy RemoteSigned
# Then run the script by using this command in the same existing directory:
# ./win-nvim.ps1
# To allow script execution, run the following command in PowerShell as an administrator:
# Set-ExecutionPolicy RemoteSigned
# Then run the script by using this command in the same existing directory:
# ./win-nvim.ps1
#curl -o winget-cli.appxbundle https://aka.ms/winget-cli-appxbundle
#powershell Add-AppxPackage -Path  "winget-cli.appxbundle"
#Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
#use `-y` or consider: choco feature enable -n allowGlobalConfirmation
#choco install git
#- Refresh the environment
#Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
#refreshenv
#
#
#here is the error
#At C:\Users\grayt\scripts\win-nvim.ps1:37 char:2
#+ - Refresh the environment
#+ ~
#Missing expression after unary operator '-'
#At C:\Users\grayt\scripts\win-nvim.ps1:37 char:3
#+ - Refresh the environment
#+ ~~~~~~~~
#Unexpected token 'Refresh' in expression or statement.
#  + CategoryInfo : ParserError: (:) [], ParseException
#  + FullyQualifiedErrorId : MissingExpressionAfterOperator
