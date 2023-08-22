#!/usr/bin/env bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to handle errors
handle_error() {
    local message="$1"
    printf "${RED}Error: $message${NC}\n"
}

if [[ $EUID -eq 0 ]]; then
    echo "This script must not be run as root"
    exit 1
fi

# Check if necessary dependencies are installed
check_download_dependencies() {
    if [ -x "$(command -v wget)" ]; then
        DOWNLOAD_COMMAND="wget"
    elif [ -x "$(command -v curl)" ]; then
        DOWNLOAD_COMMAND="curl"
    else
        printf "${RED}Error: Neither wget nor curl found. Please install one of them to continue!${NC}\n"
        exit 1
    fi
}

function get_or_update_dotfiles() {
    if [ -d "$HOME/.cfg" ]; then
        set MY_CWD = "$PWD"
        cd "$HOME"/.cfg
        git pull
        cd "$(echo "$MY_CWD")"
    else
        git clone --bare https://github.com/srdusr/dotfiles.git "$HOME"/.cfg
    fi
}

function config() {
    /usr/bin/git --git-dir="$HOME"/.cfg/ --work-tree="$HOME" "$@"
}

function checkout_config() {
    echo "Checking out config files..."
    config checkout

    if [ $? = 0 ]; then
        echo "Checked out config."
    else
        echo "Backing up pre-existing dot files."
        FILES=$(config checkout 2>&1 | egrep "\s+\." | awk {'print $1'})
        for file in "${FILES[@]}"; do
            echo "Backing up $file"
            mkdir -p .config-backup/"$(dirname "$file")"
            mv "$file" .config-backup/"$file"
        done
        echo "Finished Backup"
    fi

    echo "Verifying checkout..."
    config checkout
    config config status.showUntrackedFiles no
}

# Check for privilege escalation tools
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
        printf "\n${RED}Error: No privilege escalation tool (sudo, doas, pkexec, dzdo, or root privileges) found. You may not have sufficient permissions to run this script.${NC}\n"
        printf "\nAttempt to continue Installation (might fail without a privilege escalation tool)? [yes/no] "
        read continue_choice
        case $continue_choice in
        [Yy] | [Yy][Ee][Ss]) ;;
        [Nn] | [Nn][Oo]) exit ;;
        *) handle_error "Invalid choice. Exiting..." && exit ;;
        esac
    fi
}

# Create needed dirs and set proper permissions
for d in .cache .config .local; do
    d="$HOME/$d"
    if [ ! -d "$d" ]; then
        mkdir -p "$d"
        "$PRIVILEGE_TOOL" chown -R "$USER" "$d"
        echo "Created $d"
    fi
done

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

# Check if a command is available
check_command() {
    command -v "$1" >/dev/null 2>&1
}

# Check for required dependencies
check_dependencies() {
    local dependencies=("git" "clang" "gcc" "make" "ninja" "cmake" "wmctrl" "xdo" "xdotool" "ripgrep" "fd" "tmux" "tree-sitter" "vim" "zsh")
    local missing_dependencies=()

    for dep in "${dependencies[@]}"; do
        if ! check_command "$dep"; then
            missing_dependencies+=("$dep")
        fi
    done

    if [ ${#missing_dependencies[@]} -gt 0 ]; then
        echo "Error: The following dependencies are missing: ${missing_dependencies[*]}"
        exit 1
    fi
}

# Install Fzf
install_fzf() {
    if ! check_command "fzf"; then
        echo "Installing Fzf..."
        local INSTALL_CMD="git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install"
        if [ "$PRIVILEGE_TOOL" != "" ]; then
            "$PRIVILEGE_TOOL" bash -c "$INSTALL_CMD"
        else
            bash -c "$INSTALL_CMD"
        fi
    else
        echo "Fzf is already installed."
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

# Install Rust using rustup
install_rust() {
    if ! check_command "rustup"; then
        echo "Installing Rust using rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    else
        echo "Rust is already installed."
    fi
}

# Install Wezterm
install_wezterm() {
    if ! check_command "wezterm"; then
        echo "Installing Wezterm..."
        git clone --depth=1 --branch=main --recursive https://github.com/wez/wezterm.git ~/wezterm
        cd ~/wezterm || exit
        git submodule update --init --recursive
        ./get-deps
        cargo build --release
        cargo run --release --bin wezterm -- start
    else
        echo "Wezterm is already installed."
    fi
}

function install_font() {
    FONT=$1
    ZIPFILE_NAME="${FONT}.zip"
    DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v${NERDFONTS_LATEST_VERSION}/${ZIPFILE_NAME}"
    echo "Downloading $DOWNLOAD_URL"
    wget "$DOWNLOAD_URL"
    unzip -u "$ZIPFILE_NAME" -d "$FONTS_DIR" -x "*.txt/*" -x "*.md/*"
    rm "$ZIPFILE_NAME"
}

function install_nerd_fonts() {
    echo "Installing Nerd fonts"

    declare -a fonts=(
        AnonymousPro
        CascadiaCode
        FiraCode
        FiraMono
        Hack
        Iosevka
        LiberationMono
        Noto
        Overpass
        RobotoMono
        Terminus
        Ubuntu
        UbuntuMono
    )

    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew tap homebrew/cask-fonts
        for FONT in "${fonts[@]}"; do
            brew install "font-$(sed --expression 's/\([A-Z]\)/-\L\1/g' --expression 's/^-//' <<<"$FONT")-nerd-font"
        done
    else
        NERDFONTS_LATEST_VERSION="$(gh release list \
            --exclude-drafts \
            --exclude-pre-releases \
            --limit 1 \
            --repo ryanoasis/nerd-fonts |
            grep Latest |
            awk '{print substr($1, 2);}')" # take the first word of the line and remove the first char

        FONTS_DIR="${HOME}/.local/share/fonts"

        if [[ ! -d "$FONTS_DIR" ]]; then
            mkdir -p "$FONTS_DIR"
        fi

        for FONT in "${fonts[@]}"; do
            confirm "Install $FONT?" && install_font "$FONT"
        done

        find "$FONTS_DIR" -name '*Windows Compatible*' -delete

        fc-cache -fv
    fi
}
# Main installation function
install() {
    check_privilege_tool

    echo "This script will install and configure various tools and settings on your system."
    read -p "Do you want to continue (y/n)? " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi

    # Ask for privilege right away
    "$PRIVILEGE_TOOL" echo -n
    current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    check_dependencies
    change_dir_names
    install_fzf
    install_zsh_plugins
    configure_zshrc
    install_rust
    install_wezterm
    install_nerd_fonts

    echo "Installation completed."
}

# Run the installation process
install
