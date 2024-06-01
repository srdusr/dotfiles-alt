# THIS IS NEEDED FOR GIT TAB COMPLETION
Import-Module posh-git

# Set-PoshPrompt -Theme Paradox
# Set-PoshPrompt -Theme ~/.mytheme.tokyonight.omp.yaml
# Set-PoshPrompt -Theme ~/.omp/themes/tokyonight.omp.yaml
oh-my-posh init pwsh --config ~/.omp/themes/tokyonight.omp.yaml | Invoke-Expression

# Dotfiles special git command
function global:config {
    git --git-dir="$env:USERPROFILE\.cfg" --work-tree="$env:USERPROFILE" $args
}

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path $ChocolateyProfile) {
    Import-Module "$ChocolateyProfile"
}

# PSReadLine extension to provide VI keybindings
Set-PSReadlineOption -EditMode vi
Set-PSReadLineKeyHandler -Key Tab -Function Complete
Set-PSReadLineKeyHandler -Key Ctrl+r -Function ReverseSearchHistory

# Remove gl, gp, gm aliases for git commands
Remove-Alias -Force -Name gl
Remove-Alias -Force -Name gp
Remove-Alias -Force -Name gm

# Custom git functions
function gs { git status }
function gf { git fetch }
function gl { git pull }
function gp { git push }
function gpt { git push --tags }
function gP { git push --force-with-lease }
function ga { git add }
function gcam { git commit -am }
function gd { git diff }
function gw { git diff --word-diff }
function glog { git log }
function gdog { git log --graph --oneline --all }
function gadog { git log --graph --decorate --all }
function gb { git branch }
function gba { git branch --all }
function gco { git checkout }
function gm { git merge }

# For zoxide v0.8.0+
Invoke-Expression (& {
    $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell | Out-String)
})
