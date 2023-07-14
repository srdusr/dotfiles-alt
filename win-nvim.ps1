# Install NeoVim with winget, if not already present on the system
if (!(Get-Command nvim -ErrorAction SilentlyContinue)) {
    winget install Neovim.Neovim
}

# Clone my dotfiles repo
$dotFilesRoot = Join-Path $HOME "dotfiles"

if (!(Test-Path $dotFilesRoot -PathType Container)) {
    git clone git@github.com:srdusr/dotfiles.git $dotFilesRoot
}

# Link NeoVim configuration
$localConfiguration = Join-Path $env:LOCALAPPDATA "nvim"
$dotfilesConfiguration = Join-Path $dotFilesRoot ".config" "nvim"

if (!(Test-Path $localConfiguration -PathType Container)) { 
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c mklink /D $localConfiguration $dotfilesConfiguration" -Verb runas
}

# Clone Packer.nvim, if not already present on the system
$localPacker = Join-Path $env:LOCALAPPDATA "nvim-data" "site" "pack" "packer" "start" "packer.nvim"

if (!(Test-Path $localPacker -PathType Container)) { 
    git clone https://github.com/wbthomason/packer.nvim $localPacker
}

# To allow script execution, run the following command in PowerShell as an administrator:
# Set-ExecutionPolicy RemoteSigned
# Then run the script by using this command in the same existing directory:
# ./win-nvim.ps1
