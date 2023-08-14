#!/bin/bash

# Created By: srdusr
# Created On: Sat 12 Aug 2023 13:11:39 CAT
# Project: Install/update/downgrade/change version/uninstall Neovim script, primarily for Linux but may work in other platforms

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to handle errors
handle_error() {
    local message="$1"
    printf "${RED}Error: $message${NC}\n"
}

# Check if necessary dependencies are installed
check_dependencies() {
    if [ -x "$(command -v wget)" ]; then
        DOWNLOAD_COMMAND="wget"
    elif [ -x "$(command -v curl)" ]; then
        DOWNLOAD_COMMAND="curl"
    else
        printf "${RED}Error: Neither wget nor curl found. Please install one of them to continue!${NC}\n"
        exit 1
    fi
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

# Check if Neovim is already installed
check_neovim_installed() {
    if [ -x "$(command -v nvim)" ]; then
        return 0 # Neovim is installed
    else
        return 1 # Neovim is not installed
    fi
}

version_id=""
action=""

# Nightly version
nightly_version() {
    local url="https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage"
    install_neovim "$url"
    version_id=$(echo "$url" | grep -oP 'v\d+\.\d+\.\d+')
}

# Stable version
stable_version() {
    local url="https://github.com/neovim/neovim/releases/download/stable/nvim.appimage"
    install_neovim "$url"
    version_id=$(echo "$url" | grep -oP 'v\d+\.\d+\.\d+')
}

# Specific version
specific_version() {
    local version="$1"
    local url="https://github.com/neovim/neovim/releases/download/$version/nvim.appimage"
    install_neovim "$url"
    version_id=$(echo "$url" | grep -oP 'v\d+\.\d+\.\d+')
}

# Function to download a file using wget or curl
download_file() {
    local url="$1"
    local output="$2"

    if [ "$DOWNLOAD_COMMAND" = "wget" ]; then
        "$DOWNLOAD_COMMAND" -q --show-progress -O "$output" "$url"
    elif [ "$DOWNLOAD_COMMAND" = "curl" ]; then
        "$DOWNLOAD_COMMAND" --progress-bar -# -o "$output" "$url"
    else
        echo "Unsupported download command: $DOWNLOAD_COMMAND"
        exit 1
    fi
}

# Check if a specific version of Neovim exists
version_exists() {
    local version="$1"
    if [[ $version != v* ]]; then
        version="v$version"
    fi
    local url="https://github.com/neovim/neovim/releases/tag/$version"

    # Send a HEAD request and check the response status using wget or curl
    if "$DOWNLOAD_COMMAND" /dev/null "$url" 2>/dev/null; then
        return 0 # Version exists
    else
        return 1 # Version does not exist
    fi
}

# Choose Version
choose_version() {
    printf "${GREEN}Choose what version to install...${NC}\n"

    valid_choice=false
    while [ "$valid_choice" = false ]; do
        # Ask user for version preference
        printf "Installation options:\n"
        printf "  1. Nightly version (default)\n"
        printf "  2. Stable version\n"
        printf "  3. Specific version\n"
        printf "Enter the number corresponding to your choice (1/2/3): "
        read -r version_choice

        case $version_choice in
        1)
            nightly_version
            valid_choice=true
            ;;
        2)
            stable_version
            valid_choice=true
            ;;
        3)
            # Ask user for specific version
            read -p "Enter the specific version (e.g., v0.1.0): " specific_version
            # Check if the specific version exists on GitHub releases
            if version_exists "$specific_version"; then
                # Install specific version
                specific_version "$specific_version"
                valid_choice=true
            else
                printf "${RED}The specified version $specific_version does not exist.${NC}\n"
            fi
            ;;
        *)
            handle_error "Invalid choice. Please enter a valid option (1, 2, or 3)."
            ;;
        esac
    done
}

# Install Neovim
install_neovim() {
    local url="$1"
    local install_action="$2"
    version_id="$3"
    printf "Downloading and installing Neovim $version_id...\n"
    # Determine the platform-specific installation steps
    case "$(uname -s)" in
    Linux)
        printf "Detected Linux OS.\n"
        if [ -x "$(command -v fusermount)" ]; then
            printf "FUSE is available. Downloading and running the AppImage...\n"
            download_file "$url" "nvim.appimage"
            chmod u+x nvim.appimage
            "$PRIVILEGE_TOOL" cp nvim.appimage /usr/local/bin/nvim
            "$PRIVILEGE_TOOL" mv nvim.appimage /usr/bin/nvim
        else
            printf "FUSE is not available. Downloading and extracting the AppImage...\n"
            download_file "$url" "nvim.appimage"
            chmod u+x nvim.appimage
            ./nvim.appimage --appimage-extract
            "$PRIVILEGE_TOOL" cp squashfs-root/usr/bin/nvim /usr/local/bin
            "$PRIVILEGE_TOOL" mv squashfs-root/usr/bin/nvim /usr/bin
        fi
        ;;

    Darwin)
        printf "Detected macOS.\n"
        download_file "$url" "nvim-macos.tar.gz"
        xattr -c ./nvim-macos.tar.gz
        tar xzvf nvim-macos.tar.gz
        "$PRIVILEGE_TOOL" cp nvim-macos/bin/nvim /usr/local/bin
        "$PRIVILEGE_TOOL" mv nvim-macos/bin/nvim /usr/bin/nvim
        ;;

    MINGW*)
        printf "Detected Windows.\n"
        download_file "$url" "nvim.appimage"
        chmod +x nvim.appimage
        if [ "$PRIVILEGE_TOOL" = "sudo" ]; then
            "$PRIVILEGE_TOOL" cp nvim.appimage /usr/local/bin/nvim
            "$PRIVILEGE_TOOL" mv /usr/local/bin/nvim /usr/bin
        elif [ "$PRIVILEGE_TOOL" = "" ]; then
            cp nvim.appimage /usr/local/bin/nvim
            mv /usr/local/bin/nvim /usr/bin
        else
            printf "No privilege escalation tool found. Cannot install Neovim on Windows.\n"
        fi
        ;;

    *)
        printf "Unsupported operating system.\n"
        exit 1
        ;;
    esac

    if [ "$install_action" = "installed" ]; then
        printf "${GREEN}Neovim $version_id has been installed successfully!${NC}\n"
    fi
}

# Update Neovim to the latest version (nightly/stable)
update_version() {
    printf "${GREEN}Updating Neovim to the latest version...${NC}\n"

    valid_choice=false
    while [ "$valid_choice" = false ]; do
        # Determine which version to update to (nightly/stable)
        printf "Select version to update to:\n"
        printf "  1. Nightly\n"
        printf "  2. Stable\n"
        printf "Enter the number corresponding to your choice (1/2): "
        read update_choice

        case $update_choice in
        1)
            nightly_version
            action="updated"
            valid_choice=true
            ;;
        2)
            stable_version
            action="updated"
            valid_choice=true
            ;;
        *)
            handle_error "Invalid choice. Please enter a valid option (1 or 2)."
            ;;
        esac
    done

    if [ "$action" = "updated" ]; then
        printf "${GREEN}Neovim has been updated successfully to $version_id!${NC}\n"
    fi
}

# Uninstall Neovim
uninstall_neovim() {
    printf "${RED}Uninstalling Neovim...${NC}\n"

    # Detect the operating system to determine the appropriate uninstallation method
    case "$(uname -s)" in
    Linux)
        printf "Detected Linux OS.\n"
        "$PRIVILEGE_TOOL" rm /usr/local/bin/nvim
        "$PRIVILEGE_TOOL" rm /usr/bin/nvim
        ;;

    Darwin)
        printf "Detected macOS.\n"
        "$PRIVILEGE_TOOL" rm /usr/local/bin/nvim
        "$PRIVILEGE_TOOL" rm /usr/bin/nvim
        ;;

    MINGW*)
        printf "Detected Windows.\n"
        if [ "$PRIVILEGE_TOOL" = "sudo" ]; then
            "$PRIVILEGE_TOOL" rm /usr/local/bin/nvim
            "$PRIVILEGE_TOOL" rm /usr/bin/nvim
        else
            [ "$PRIVILEGE_TOOL" = "" ]
            rm /usr/local/bin/nvim
            rm /usr/bin/nvim
        fi
        ;;
    *)
        printf "Unsupported operating system.\n"
        ;;
    esac

    printf "${GREEN}Neovim has been uninstalled successfully!${NC}\n"
}

# Check if Neovim is running
check_neovim_running() {
    if pgrep nvim >/dev/null; then
        printf "${RED}Error: Neovim is currently running. Please close Neovim before proceeding.${NC}\n"
        read -p "Do you want to forcefully terminate Neovim and continue? [yes/no] " terminate_choice

        case $terminate_choice in
        [Yy] | [Yy][Ee][Ss])
            pkill nvim # Forcefully terminate Neovim
            ;;
        [Nn] | [Nn][Oo])
            echo "Exiting..."
            exit 1
            ;;
        *)
            handle_error "Invalid choice."
            ;;
        esac
    fi
}

check_neovim_running

# Define the variable to control the prompt
SHOW_PROMPT=1

# Check if necessary dependencies are installed
check_dependencies

# Check for privilege escalation tools
check_privilege_tools

# Check if Neovim is already installed
if check_neovim_installed; then
    printf "${GREEN}Neovim is already installed!${NC}\n"
else
    choose_version
fi

# Function to check for updates and display breaking changes
check_version_updates() {
    local latest_version_url="https://api.github.com/repos/neovim/neovim/releases/latest"
    local latest_version=""

    if [ -x "$(command -v curl)" ]; then
        latest_version=$(curl -sSL "$latest_version_url" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    elif [ -x "$(command -v wget)" ]; then
        latest_version=$(wget -qO - "$latest_version_url" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    else
        printf "${RED}Error: Neither curl nor wget found. Please install one of them to continue!${NC}\n"
        exit 1
    fi

    if version_exists "$latest_version"; then
        printf "${GREEN}An update is available!${NC}\n"
        display_breaking_changes "$latest_version"
    else
        printf "You have the latest version of Neovim.\n"
    fi
}

# Function to display breaking changes for a specific version
display_breaking_changes() {
    local version="$1"
    local changelog_url="https://github.com/neovim/neovim/releases/tag/$version"
    local changelog=""

    if [ -x "$(command -v curl)" ]; then
        changelog=$(curl -sSL "$changelog_url" | grep -oE '<h1>Breaking Changes.*?</ul>' | sed 's/<[^>]*>//g')
    elif [ -x "$(command -v wget)" ]; then
        changelog=$(wget -qO - "$changelog_url" | grep -oE '<h1>Breaking Changes.*?</ul>' | sed 's/<[^>]*>//g')
    else
        printf "${RED}Error: Neither curl nor wget found. Please install one of them to continue!${NC}\n"
        exit 1
    fi

    printf "\nBreaking Changes in Neovim $version:\n"
    printf "$changelog\n"
}

# Main loop
while [ "$SHOW_PROMPT" -gt 0 ]; do
    printf "Select an action:\n"
    printf "  1. Update Neovim\n"
    printf "  2. Check for updates\n"
    printf "  3. Change to a specific version\n"
    printf "  4. Uninstall Neovim\n"
    printf "  5. Run Neovim\n"
    printf "  6. Exit\n"
    read -p "Enter the number or 'q' to exit: " choice

    case $choice in
    1)
        update_version
        ;;
    2)
        check_version_updates
        ;;
    3)
        choose_version
        ;;
    4)
        uninstall_neovim
        ;;
    5)
        nvim
        ;;
    6 | [Qq])
        echo "Exiting..."
        exit
        ;;
    *)
        handle_error "Invalid choice. Please choose a valid option by entering the corresponding number or 'q' to 'exit'."
        ;;
    esac
done
