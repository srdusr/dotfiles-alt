#!/usr/bin/env bash

#======================================
# Variables
#======================================

# Color definitions
NOCOLOR='\033[0m'
RED='\033[00;31m'
GREEN='\033[00;32m'

# Dotfiles
dotfiles_url='https://github.com/srdusr/dotfiles.git'

# Log file
LOG_FILE="dotfiles.log"
TRASH_DIR="$HOME/.local/share/Trash"

# Ensure Trash directory exists
if [ ! -d "$TRASH_DIR" ]; then
    mkdir -p "$TRASH_DIR"
    if [ $? -ne 0 ]; then
        echo "Failed to create Trash directory. Exiting..."
        exit 1
    fi
fi

# Move log file to Trash directory
mv -f "$LOG_FILE" "$TRASH_DIR/"

# Redirect stderr to both stderr and log file
exec 2> >(tee -a "$LOG_FILE")

# Function to log errors
log_error() {
    local message="$1"
    echo "[ERROR] $(date +'%Y-%m-%d %H:%M:%S') - $message" | tee -a "$LOG_FILE" >&2
}

# Function to handle errors
handle_error() {
    local message="$1"
    log_error "$message"
    exit 1
}

# Function to log completion messages
log_complete() {
    local message="$1"
    echo "[COMPLETE] $(date +'%Y-%m-%d %H:%M:%S') - $message" | tee -a "$LOG_FILE"
}

# Function to handle completion
handle_complete() {
    local message="$1"
    log_complete "$message"
}

# Function to prompt the user
prompt_user() {
    local prompt="$1 [Y/n] "
    local default_response="${2:-Y}"
    local response

    read -p "$prompt" -n 1 -r -e -i "$default_response" response
    echo

    case "${response^^}" in
        Y) return 0 ;;
        N) return 1 ;;
        *) handle_error "Invalid choice. Exiting..." && exit ;;
    esac
}

# Function to temporarily unset GIT_WORK_TREE
function git_without_work_tree() {
    # Check if the current directory is a Git repository
    if [ -d "$PWD/.git" ]; then
        # Check if the current directory is inside the work tree
        if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]; then
            # If it's a Git repository and inside the work tree, proceed with unsetting GIT_WORK_TREE
            GIT_WORK_TREE_OLD="$GIT_WORK_TREE"
            unset GIT_WORK_TREE
            "$@"
            export GIT_WORK_TREE="$GIT_WORK_TREE_OLD"
        else
            # If it's a Git repository but not inside the work tree, call git command directly
            git "$@"
        fi
    else
        # If it's not a Git repository, call git command directly
        git "$@"
    fi
}

# Set alias conditionally
alias git='git_without_work_tree'

# Check for privilege escalation tools
#--------------------------------------
check_privilege_tools() {
    if [ -x "$(command -v sudo)" ]; then
        PRIVILEGE_TOOL="sudo"
    elif [ -x "$(command -v doas)" ]; then
        PRIVILEGE_TOOL="doas"
    elif [ -x "$(command -v pkexec)" ]; then
        PRIVILEGE_TOOL="pkexec"
    elif [ -x "$(command -v dzdo)" ]; then
        PRIVILEGE_TOOL="dzdo"
    elif [ "$(id -u)" -eq 0 ]; then
        PRIVILEGE_TOOL="" # root
    else
        PRIVILEGE_TOOL="" # No privilege escalation mechanism found
        printf "\n${RED}Error: No privilege escalation tool (sudo, doas, pkexec, dzdo, or root privileges) found. You may not have sufficient permissions to run this script.${NOCOLOR}\n"
        printf "\nAttempt to continue Installation (might fail without a privilege escalation tool)? [yes/no] "
        read continue_choice
        case $continue_choice in
            [Yy] | [Yy][Ee][Ss]) ;;
            [Nn] | [Nn][Oo]) exit ;;
            *) handle_error "Invalid choice. Exiting..." && exit ;;
        esac
    fi
}

# Function to set locale to en_US.UTF-8
set_locale() {
    echo "Setting locale to en_US.UTF-8..."
    if ! "$PRIVILEGE_TOOL" localectl set-locale LANG=en_US.UTF-8; then
        handle_error "Failed to set locale to en_US.UTF-8"
    fi
}

# Install Zsh plugins
install_zsh_plugins() {
    local zsh_plugins_dir="$HOME/.config/zsh/plugins"

    if [ ! -d "$zsh_plugins_dir/zsh-you-should-use" ]; then
        echo "Installing zsh-you-should-use..."
        git clone https://github.com/MichaelAquilina/zsh-you-should-use.git "$zsh_plugins_dir/zsh-you-should-use"
    else
        echo "zsh-you-should-use is already installed."
    fi

    if [ ! -d "$zsh_plugins_dir/zsh-syntax-highlighting" ]; then
        echo "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$zsh_plugins_dir/zsh-syntax-highlighting"
    else
        echo "zsh-syntax-highlighting is already installed."
    fi

    if [ ! -d "$zsh_plugins_dir/zsh-autosuggestions" ]; then
        echo "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "$zsh_plugins_dir/zsh-autosuggestions"
    else
        echo "zsh-autosuggestions is already installed."
    fi
}

#==============================================================================

#======================================
# Common Sources/Dependencies
#======================================
echo ".cfg" >>.gitignore
echo ".install.sh" >>.gitignore

# Dotfiles
git clone --bare "$dotfiles_url" "$HOME"/.cfg

function config {
    git --git-dir="$HOME"/.cfg/ --work-tree="$HOME" "$@"
}

std_err_output=$(config checkout 2>&1 >/dev/null) || true

if [[ $std_err_output == *"following untracked working tree files would be overwritten"* ]]; then
    echo "Backing up pre-existing dot files."
    config checkout 2>&1 |
    egrep "\s+\." |
    awk {'print $1'} |
    xargs -I% sh -c "mkdir -p '.cfg-backup/%';  mv % .cfg-backup/%"
fi

config config status.showUntrackedFiles no
git config --global include.path "~/.gitconfig.aliases"

# Prompt the user if they want to overwrite existing files
if prompt_user "Do you want to overwrite existing files and continue with the dotfiles setup?"; then
    # Fetch the latest changes from the remote repository
    config fetch origin main:main

    # Reset the local branch to match the main branch in the remote repository
    config reset --hard main
    # Proceed with the dotfiles setup
    config checkout -f
    if [ $? == 0 ]; then
        echo "Successfully backed up conflicting dotfiles in .cfg-backup/. and imported.cfg.\n"
    else
        handle_error "Mission failed.\n"
    fi
else
    # User chose not to overwrite existing files
    handle_error "Aborted by user. Exiting..."
fi

# Check if necessary dependencies are installed
#--------------------------------------
# Download dependencies (wget/curl)
check_download_dependencies() {
    if [ -x "$(command -v wget)" ]; then
        DOWNLOAD_COMMAND="wget"
    elif [ -x "$(command -v curl)" ]; then
        DOWNLOAD_COMMAND="curl"
    else
        handle_error "Neither wget nor curl found. Please install one of them to continue!"
    fi
}

#------------------------------------------------------------------------------

#==============================================================================

#======================================
# Check Operating System
#======================================
check_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "Linux OS detected."
        # Implement Linux-specific checks
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "MacOS detected."
        # Implement MacOS-specific checks
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        echo "Windows-like environment detected."
        # Implement Windows-specific checks
    else
        handle_error "Unsupported operating system."
    fi
}

#==============================================================================

#======================================
# Linux
#======================================

# Check Distro
#--------------------------------------

# Detect package type from /etc/issue
_found_arch() {
    local _ostype="$1"
    shift
    grep -qis "$*" /etc/issue && _distro="$_ostype"
}

# Detect package type
_distro_detect() {
    # Check if /etc/os-release exists and extract information
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        case "$ID" in
            "arch")
                _distro="PACMAN"
                return
                ;;
            "debian")
                _distro="DPKG"
                return
                ;;
            "ubuntu")
                _distro="DPKG"
                return
                ;;
            "centos")
                _distro="YUM"
                return
                ;;
            "fedora")
                _distro="YUM"
                return
                ;;
            "opensuse" | "suse")
                _distro="ZYPPER"
                return
                ;;
            "gentoo")
                _distro="PORTAGE"
                return
                ;;
        esac
    fi

    # Fallback method if /etc/os-release doesn't provide the information
    if [ -f /etc/issue ]; then
        _found_arch PACMAN "Arch Linux" && return
        _found_arch DPKG "Debian GNU/Linux" && return
        _found_arch DPKG "Ubuntu" && return
        _found_arch YUM "CentOS" && return
        _found_arch YUM "Red Hat" && return
        _found_arch YUM "Fedora" && return
        _found_arch ZYPPER "SUSE" && return
        _found_arch PORTAGE "Gentoo" && return
    fi

    # Check for package managers and prompt the user if none found
    local available_package_managers=("apt" "pacman" "portage" "yum" "zypper")
    for manager in "${available_package_managers[@]}"; do
        if command -v "$manager" &>/dev/null; then
            _distro="$manager"
            return
        fi
    done

    # If none of the above methods work, prompt the user to specify the package manager
    printf "Unable to detect the package manager. Please specify the package manager (e.g., apt, pacman, portage, yum, zypper): "
    read -r user_package_manager
    if [ -x "$(command -v "$user_package_manager")" ]; then
        _distro="$user_package_manager"
        return
    else
        _error "Specified package manager '$user_package_manager' not found. Exiting..."
        exit 1
    fi
}

#------------------------------------------------------------------------------

# Define directories to create
directories=('.cache' '.config' '.scripts')

# Prompt the user if they want to use user-dirs.dirs
if prompt_user "Do you want to use the directories specified in user-dirs.dirs?"; then
    # Check if ~/.config/user-dirs.dirs exists
    config_dirs_file="$HOME/.config/user-dirs.dirs"
    if [ -f "$config_dirs_file" ]; then
        echo "Config file $config_dirs_file exists. Proceeding...\n"
    else
        echo "Error: Config file $config_dirs_file not found. Please check your configuration."
        exit 1
    fi

    # Prompt the user if they want to change directory names
    if prompt_user "Do you want to change the directory names to lowercase?"; then
        # Function to change directory names from uppercase to lowercase
        change_dir_names() {
            local config_file="$HOME/.config/user-dirs.dirs"

            # Check if the system is not macOS
            if [[ ! "$OSTYPE" == "darwin"* ]]; then
                # Check if the config file exists
                if [ -f "$config_file" ]; then
                    echo "Changing directory names from uppercase to lowercase..."

                    # Read the lines from the config file and process them
                    while read -r line; do
                        # Extract variable name and path from each line
                        if [[ $line =~ ^[[:space:]]*([A-Z_]+)=\"(.+)\" ]]; then
                            var_name="${BASH_REMATCH[1]}"
                            var_path="${BASH_REMATCH[2]}"

                            # Convert the variable name to lowercase
                            var_name_lowercase="$(echo "$var_name" | tr '[:upper:]' '[:lower:]')"

                            # Check if the directory exists
                            if [ -d "$var_path" ]; then
                                # Rename the directory to lowercase
                                new_var_path="$HOME/${var_name_lowercase}"
                                mv "$var_path" "$new_var_path"
                                echo "Renamed $var_path to $new_var_path"
                            fi
                        fi
                    done <"$config_file"

                    echo "Directory names changed successfully."
                else
                    echo "The config file $config_file does not exist. Skipping directory name changes."
                fi
            else
                echo "macOS detected. Skipping directory name changes."
            fi
        }

        # Run the function to change directory names
        change_dir_names
    elif prompt_user "Do you want to change the directory names to uppercase?"; then
        # Function to change directory names from lowercase to uppercase
        change_dir_names() {
            local config_file="$HOME/.config/user-dirs.dirs"

            # Check if the system is not macOS
            if [[ ! "$OSTYPE" == "darwin"* ]]; then
                # Check if the config file exists
                if [ -f "$config_file" ]; then
                    echo "Changing directory names from lowercase to uppercase..."

                    # Read the lines from the config file and process them
                    while read -r line; do
                        # Extract variable name and path from each line
                        if [[ $line =~ ^[[:space:]]*([A-Z_]+)=\"(.+)\" ]]; then
                            var_name="${BASH_REMATCH[1]}"
                            var_path="${BASH_REMATCH[2]}"

                            # Convert the variable name to uppercase
                            var_name_uppercase="$(echo "$var_name" | tr '[:lower:]' '[:upper:]')"

                            # Check if the directory exists
                            if [ -d "$var_path" ]; then
                                # Rename the directory to uppercase
                                new_var_path="$HOME/${var_name_uppercase}"
                                mv "$var_path" "$new_var_path"
                                echo "Renamed $var_path to $new_var_path"
                            fi
                        fi
                    done <"$config_file"

                    echo "Directory names changed successfully."
                else
                    echo "The config file $config_file does not exist. Skipping directory name changes."
                fi
            else
                echo "macOS detected. Skipping directory name changes."
            fi
        }

        # Run the function to change directory names
        change_dir_names
        #xdg-user-dirs-update
    fi
fi

# Create needed dirs and set proper permissions
for d in "${directories[@]}"; do
    full_path="$HOME/$d"
    if [ ! -d "$full_path" ]; then
        mkdir -p "$full_path"
        # Assuming $USER is defined or replace it with the desired user
        chown -R "$USER" "$full_path"
        echo "Created $full_path"
    fi
done

#------------------------------------------------------------------------------

# Update system
linux_update_system() {
    case "$_distro" in
        "PACMAN")
            "$PRIVILEGE_TOOL" pacman -Syyy && "$PRIVILEGE_TOOL" pacman -Syu --noconfirm
            ;;
        "DPKG")
            "$PRIVILEGE_TOOL" apt-get update && "$PRIVILEGE_TOOL" apt-get upgrade -y
            ;;
        "YUM")
            "$PRIVILEGE_TOOL" yum update -y
            ;;
        "ZYPPER")
            "$PRIVILEGE_TOOL" zypper --non-interactive update
            ;;
        "PORTAGE")
            "$PRIVILEGE_TOOL" emerge --sync && "$PRIVILEGE_TOOL" emerge --ask --update --deep --newuse @world
            ;;
        *)
            echo "Package manager not supported."
            ;;
    esac
}

#------------------------------------------------------------------------------

linux_install_packages() {
    local failed_packages=()
    local any_failures=false # Flag to track if any packages failed to install

    # Read the package manager type detected by _distro_detect()
    case "$_distro" in
        "PACMAN")
            function install_yay {
                if [[ -x $(command -v yay) ]]; then
                    return
                fi
                git clone https://aur.archlinux.org/yay.git
                cd yay || exit
                makepkg -si
                cd ..
                rm -rf yay
            }
            install_yay

            # Installation using Pacman
            while IFS= read -r package; do
                # Skip empty lines
                if [[ -z "$package" ]]; then
                    continue
                fi

                if ! pacman -Q "$package" &>/dev/null; then
                    if ! "$PRIVILEGE_TOOL" pacman -S --noconfirm "$package"; then
                        failed_packages+=("$package")
                        any_failures=true # Set flag to true if any package fails to install
                    fi
                fi
            done <packages.txt

            if [[ "$any_failures" = "true" ]]; then
                echo "Failed to install the following packages:"
                for package in "${failed_packages[@]}"; do
                    if ! pacman -Q "$package" &>/dev/null && ! yay -Q "$package" &>/dev/null; then
                        if [[ -x "$(command -v yay)" ]]; then
                            echo "Trying to install $package from AUR using yay..."
                            if yay -S --noconfirm "$package"; then
                                echo "Successfully installed $package from AUR."
                            else
                                echo "Failed to install $package from AUR."
                            fi
                        else
                            echo "Failed to install $package using the default package manager."
                        fi
                    fi
                done
            else
                echo "All packages installed successfully."
            fi
            ;;
        "DPKG")
            # Try installing packages with dpkg
            while IFS= read -r package; do
                if ! dpkg-query -W "$package" &>/dev/null; then
                    if ! "$PRIVILEGE_TOOL" apt-get install -y "$package"; then
                        failed_packages+=("$package")
                        any_failures=true # Set flag to true if any package fails to install
                    fi
                fi
            done <packages.txt

            if "$any_failures"; then
                echo "Failed to install the following packages:"
                printf '%s\n' "${failed_packages[@]}"
            else
                echo "All packages installed successfully."
            fi
            ;;
        "YUM")
            # Try installing packages with yum
            while IFS= read -r package; do
                if ! rpm -q "$package" &>/dev/null; then
                    if ! "$PRIVILEGE_TOOL" yum install -y "$package"; then
                        failed_packages+=("$package")
                        any_failures=true # Set flag to true if any package fails to install
                    fi
                fi
            done <packages.txt

            if "$any_failures"; then
                echo "Failed to install the following packages:"
                printf '%s\n' "${failed_packages[@]}"
            else
                echo "All packages installed successfully."
            fi
            ;;
        "ZYPPER")
            # Try installing packages with zypper
            while IFS= read -r package; do
                if ! rpm -q "$package" &>/dev/null; then
                    if ! "$PRIVILEGE_TOOL" zypper --non-interactive install "$package"; then
                        failed_packages+=("$package")
                        any_failures=true # Set flag to true if any package fails to install
                    fi
                fi
            done <packages.txt

            if "$any_failures"; then
                echo "Failed to install the following packages:"
                printf '%s\n' "${failed_packages[@]}"
            else
                echo "All packages installed successfully."
            fi
            ;;
        "PORTAGE")
            # Try installing packages with emerge
            while IFS= read -r package; do
                if ! equery list "$package" &>/dev/null; then
                    if ! "$PRIVILEGE_TOOL" emerge --ask "$package"; then
                        failed_packages+=("$package")
                        any_failures=true # Set flag to true if any package fails to install
                    fi
                fi
            done <packages.txt

            if "$any_failures"; then
                echo "Failed to install the following packages:"
                printf '%s\n' "${failed_packages[@]}"
            else
                echo "All packages installed successfully."
            fi
            ;;
        *)
            echo "Package manager not supported."
            ;;
    esac
}

# Install Rust using rustup
install_rust() {
    if command -v "rustup" &>/dev/null; then
        echo "Installing Rust using rustup..."
        #curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        #export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
        CARGO_HOME=${XDG_DATA_HOME:-$HOME/.local/share}/cargo RUSTUP_HOME=${XDG_DATA_HOME:-$HOME/.local/share}/rustup bash -c 'curl https://sh.rustup.rs -sSf | sh -s -- -y'
    else
        echo "Rust is already installed."
    fi
}

# Function to install Node Version Manager (NVM)
install_nvm() {
    # Set NVM_DIR environment variable
    export NVM_DIR="$HOME/.config/nvm"
    if [ ! -d "$NVM_DIR" ]; then
        mkdir -p "$NVM_DIR"
    fi
    # Download and install or update NVM script
    if command -v nvm &>/dev/null; then
        echo "Updating Node Version Manager (NVM)..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
    else
        echo "Installing Node Version Manager (NVM)..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
    fi
    # Source NVM script to enable it in the current shell
    if [ -s "$NVM_DIR/nvm.sh" ]; then
        echo "Sourcing NVM script..."
        . "$NVM_DIR/nvm.sh"
    else
        echo "NVM script not found. Make sure installation was successful."
        return 1
    fi

    # Verify installation
    if command -v nvm &>/dev/null; then
        echo "NVM installation completed successfully."
        export NVM_DIR="$HOME/.config/nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
    else
        echo "NVM installation failed."
        return 1
    fi
}

install_node() {
    # Check if Node.js is already installed
    if ! command -v node &>/dev/null; then
        echo "Node.js is already installed."
        return
    fi

    echo "Installing Node.js..."
    # Set up environment variables for Node.js installation
    #export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node/
    #export NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node/

    # Install the latest stable version of Node.js using NVM
    nvm
    nvm install node
    nvm use node
    nvm install --lts
    nvm alias default lts/* # Set LTS version as default

    echo "Node.js installation completed successfully."
}

install_yarn() {
    # Check if Yarn is already installed
    if command -v yarn &>/dev/null; then
        echo "Yarn is already installed."
        return
    fi

    # Check if the .yarn directory exists
    if [ -d "$HOME/.yarn" ]; then
        echo "Removing existing .yarn directory..."
        rm -rf "$HOME/.yarn"
    fi

    echo "Installing Yarn..."
    # Install Yarn using npm
    curl -o- -L https://yarnpkg.com/install.sh | bash
    echo "Yarn installation completed successfully."
}

setup_tmux_plugins() {
    local tpm_dir="$HOME/.config/tmux/plugins/tpm"
    local plugins_dir="$HOME/.config/tmux/plugins"

    # Ensure the plugins directory exists
    if [ ! -d "$plugins_dir" ]; then
        mkdir -p "$plugins_dir"
    fi

    # Ensure the TPM directory exists
    if [ ! -d "$tpm_dir" ]; then
        mkdir -p "$tpm_dir"
    fi

    if [ "$(ls -A "$tpm_dir")" ]; then
        # TPM is already installed and directory is not empty, so we skip installation.
        echo "TPM has been installed...skipping"
    else
        # If TPM directory doesn't exist or is empty, we proceed with installation.
        if [ -d "$tpm_dir" ]; then
            rm -rf "$tpm_dir" # Remove existing directory if it exists
        fi
        echo "Installing TPM..."
        git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    fi
}

setup_ssh() {
    SSH_DIR="$HOME/.ssh"
    if ! [[ -f "$SSH_DIR/authorized_keys" ]]; then
        echo "Generating SSH keys"
        mkdir -p "$SSH_DIR"
        chmod 700 "$SSH_DIR"
        ssh-keygen -b 4096 -t rsa -f "$SSH_DIR"/id_rsa -N '' -C "$USER@$HOSTNAME"
        cat "$SSH_DIR"/id_rsa.pub >>"$SSH_DIR"/authorized_keys
    fi
}

linux_specific_steps() {
    _distro_detect
    check_privilege_tools
    set_locale
    change_dir_names
    linux_update_system
    install_rust
    install_nvm
    install_node
    install_yarn
    linux_install_packages
    install_zsh_plugins
    setup_tmux_plugins
    setup_ssh
}

#------------------------------------------------------------------------------

#------------------------------------------------------------------------------

#==============================================================================

#======================================
# MacOS
#======================================

macos_specific_steps() {
    set_locale
    macos_install_packages
    git_install_macos

}

#==============================================================================

#======================================
# Windows
#======================================

windows_specific_steps() {
    check_git_installed_windows
    install_dependencies_windows
    windows_install_packages
    git_install_windows
    symlink_configuration_files_windows
}
#------------------------------------------------------------------------------

#==============================================================================

#======================================
# Main Installation
#======================================

# Main Installation
main_installation() {
    echo "Starting main installation..."

    case "$OSTYPE" in
        linux-gnu*)
            linux_specific_steps
            ;;
        darwin*)
            macos_specific_steps
            ;;
        msys* | cygwin*)
            windows_specific_steps
            ;;
        *)
            handle_error "Unsupported operating system."
            ;;
    esac

    sleep 1
}

# Script entry point
main() {
    echo "Log File for Dotfiles Installation" >"$LOG_FILE"
    check_download_dependencies
    check_os
    main_installation

    handle_complete "Installation completed successfully."
}

main "$@"
