#!/bin/bash

# Created By: srdusr
# Created On: Sat 12 Aug 2023 13:11:39 CAT
# Project: Install/update/downgrade/change version/uninstall Neovim script, primarily for Linux but may work in other platforms

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

# Check if necessary applications are installed
check_dependencies() {
    missing_dependencies=()

    for cmd in wget curl xmllint datediff; do
        if ! [ -x "$(command -v "$cmd")" ]; then
            missing_dependencies+=("$cmd")
        fi
    done

    if [ ${#missing_dependencies[@]} -gt 0 ]; then
        printf "\n${RED}Missing dependencies: ${missing_dependencies[*]}. Please install them to continue!${NC}\n"
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
        *) echo "Invalid choice. Exiting..." && exit ;;
        esac
    fi
}

check_privilege_tools

# Install Neovim
install_neovim() {
    printf "${GREEN}Installing Neovim...${NC}\n"

    # Detect the operating system to determine the appropriate installation method
    case "$(uname -s)" in
    Linux)
        printf "Detected Linux OS.\n"
        # Check if FUSE is available
        if [ -x "$(command -v fusermount)" ]; then
            printf "FUSE is available. Downloading and running the AppImage...\n"
            wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -q -O nvim.appimage
            chmod u+x nvim.appimage
            "$PRIVILEGE_TOOL" cp nvim.appimage /usr/local/bin/nvim
            "$PRIVILEGE_TOOL" mv nvim.appimage /usr/bin/nvim
            nvim
        else
            printf "FUSE is not available. Downloading and extracting the AppImage...\n"
            wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -q -O nvim.appimage
            chmod u+x nvim.appimage
            ./nvim.appimage --appimage-extract
            "$PRIVILEGE_TOOL" cp squashfs-root/usr/bin/nvim /usr/local/bin
            "$PRIVILEGE_TOOL" mv squashfs-root/usr/bin/nvim /usr/bin
            nvim
        fi
        ;;

    Darwin)
        printf "Detected macOS.\n"
        wget https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz -q -O nvim-macos.tar.gz
        xattr -c ./nvim-macos.tar.gz
        tar xzvf nvim-macos.tar.gz
        "$PRIVILEGE_TOOL" cp nvim-macos/bin/nvim /usr/local/bin
        "$PRIVILEGE_TOOL" mv nvim-macos/bin/nvim /usr/bin
        nvim
        ;;

    MINGW*)
        printf "Detected Windows.\n"
        if [ "$PRIVILEGE_TOOL" = "sudo" ]; then
            curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage && chmod +x nvim.appimage
            "$PRIVILEGE_TOOL" cp nvim.appimage /usr/local/bin/nvim
            "$PRIVILEGE_TOOL" mv /usr/local/bin/nvim /usr/bin
            nvim
        elif [ "$PRIVILEGE_TOOL" = "" ]; then
            curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage && chmod +x nvim.appimage
            cp nvim.appimage /usr/local/bin/nvim
            mv /usr/local/bin/nvim /usr/bin
            nvim
        else
            printf "No privilege escalation tool found. Cannot install Neovim on Windows.\n"
        fi
        ;;
    *)
        printf "Unsupported operating system.\n"
        ;;
    esac

    printf "${GREEN}Neovim has been installed successfully!${NC}\n"
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

# Check if Neovim is already installed
check_neovim_installed() {
    if [ -x "$(command -v nvim)" ]; then
        return 0 # Neovim is installed
    else
        return 1 # Neovim is not installed
    fi
}

# Define the variable to control the prompt
SHOW_PROMPT=1

# Check if necessary dependencies are installed
check_dependencies

# Check if Neovim is already installed
if check_neovim_installed; then
    printf "${GREEN}Neovim is already installed!${NC}\n"
else
    # Prompt user for initial installation
    read -p "Neovim is not installed. Do you want to install it? [yes/no] " install_choice
    case $install_choice in
    [Yy]*) install_neovim ;;
    [Nn]*) ;;
    *) echo "Please answer yes or no." ;;
    esac
fi

# Fetch the latest Neovim Nightly release information from GitHub
wget https://github.com/neovim/neovim/releases/tag/nightly -q -O - >/tmp/nvim_release_info
RESPONSE=$(wget https://github.com/neovim/neovim/releases/tag/nightly --save-headers -O - 2>&1)

# Check if the release exists
if [[ "$RESPONSE" =~ 404\ Not\ Found ]]; then
    printf "${RED}Unable to fetch latest Neovim Nightly info. Exiting...${NC}\n"
    exit
fi

# Initialize variables
should_prompt=0
current_version=$(nvim --version | head -n 1)
new_version=$(xmllint --html --xpath "//pre//code/node()" /tmp/nvim_release_info 2>/dev/null | grep NVIM)
current_datetime_iso=$(date --iso-8601=ns)
new_release_datetime_iso=$(xmllint --html --xpath "string(//relative-time/@datetime)" /tmp/nvim_release_info 2>/dev/null)
time_since_release=$(datediff "$new_release_datetime_iso" "$current_datetime_iso" -f "%H hours %M minutes ago")

# Check if the new Neovim version is available
if [[ "$new_version" == "" ]]; then
    printf "\n${RED}Failed to retrieve latest Neovim Nightly version from the repository. Aborting...${NC}\n"
    exit
fi

# Check if the current version is already the latest
if [[ "$current_version" == "$new_version" ]]; then
    printf "\n${RED}No new ${BOLD}Neovim Nightly${NORMAL}${RED} version found!\n${NC}Last release: ${time_since_release}\nExiting...\n"
    exit
fi

# If a newer version is found, prompt the user
if [[ "$current_version" != "$new_version" ]]; then
    printf "\n${GREEN}New ${BOLD}Neovim Nightly${NORMAL}${GREEN} version available!${NC}\n${current_version} -> ${BOLD}${new_version}${NORMAL}\nReleased: ${time_since_release}\n\n"
    should_prompt=1
fi

# Function to update Neovim Nightly
update_neovim() {
    printf "${RED}Updating Neovim Nightly...${NC}\n"
    download_url="https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage"
    curl_command="curl -L -w http_code=%{http_code}"
    curl_output=$("$curl_command" "$download_url" -o /tmp/nvim)
    http_code=$(echo "$curl_output" | sed -e 's/.*\http_code=//')
    error_message=$(echo "$curl_output" | sed -e 's/http_code.*//')

    if [[ $http_code == 200 ]]; then
        chmod +x /tmp/nvim
        "$PRIVILEGE_TOOL" cp /tmp/nvim /usr/local/bin
        "$PRIVILEGE_TOOL" mv /tmp/nvim /usr/bin
        printf "${GREEN}Neovim Nightly updated successfully!${NC}\n"
    else
        printf "${RED}Failed to update Neovim Nightly! ERROR: ${error_message}${NC}\n"
    fi
}

rm /tmp/nvim_release_info

downgrade_neovim() {
    # Fetch all the release tags from GitHub
    ALL_TAGS=$(curl -s "https://api.github.com/repos/neovim/neovim/tags" | grep '"name":' | cut -d '"' -f 4)

    # Filter out major version tags (assumes version tag format is "vx.y.z")
    MAJOR_VERSIONS=$(echo "$ALL_TAGS" | grep -E "^v[0-9]+\.[0-9]+\.0$")

    # Show available major versions to the user
    echo "Available major versions:"
    echo "$MAJOR_VERSIONS"

    # Ask user to choose a version
    read -p "Enter the major version to downgrade to (e.g., v0.1, v0.2, ...): " DESIRED_MAJOR_VERSION

    # Construct the desired version tag
    DESIRED_VERSION=$(echo "$MAJOR_VERSIONS" | grep "$DESIRED_MAJOR_VERSION")

    if [ "$DESIRED_VERSION" = "" ]; then
        echo "Invalid major version. Exiting..."
        exit 1
    fi

    printf "${RED}Downgrading Neovim to version $DESIRED_VERSION...${NC}\n"

    # Construct the URL for the desired version's release page on GitHub
    RELEASE_URL="https://github.com/neovim/neovim/releases/tag/$DESIRED_VERSION"

    # Download the release page HTML
    wget "$RELEASE_URL" -q -O /tmp/neovim_release.html

    # Find the download URL for the desired version's binary
    DOWNLOAD_URL=$(grep -o "https://github.com/neovim/neovim/releases/download/$DESIRED_VERSION/nvim.appimage" /tmp/neovim_release.html)

    # Download the desired version of Neovim
    wget "$DOWNLOAD_URL" -q -O /tmp/nvim

    # Make the downloaded binary executable
    chmod +x /tmp/nvim

    # Install the downloaded binary to appropriate locations
    "$PRIVILEGE_TOOL" cp /tmp/nvim /usr/local/bin
    "$PRIVILEGE_TOOL" mv /tmp/nvim /usr/bin

    # Clean up temporary files
    rm /tmp/neovim_release.html

    printf "${GREEN}Neovim has been downgraded to version $DESIRED_VERSION successfully!${NC}\n"
}

use_stable_neovim() {
    # Fetch the latest stable version tag from GitHub releases
    STABLE_NVIM_VERSION=$(curl -s "https://api.github.com/repos/neovim/neovim/releases/latest" | grep '"tag_name":' | cut -d '"' -f 4)

    printf "${RED}Using Latest Stable Neovim version $STABLE_NVIM_VERSION...${NC}\n"

    # Construct the URL for the latest stable version's release page on GitHub
    RELEASE_URL="https://github.com/neovim/neovim/releases/tag/$STABLE_NVIM_VERSION"

    # Download the release page HTML
    wget "$RELEASE_URL" -q -O /tmp/neovim_release.html

    # Find the download URL for the latest stable version's binary
    DOWNLOAD_URL=$(grep -o "https://github.com/neovim/neovim/releases/download/$STABLE_NVIM_VERSION/nvim.appimage" /tmp/neovim_release.html)

    # Download the latest stable version of Neovim
    wget "$DOWNLOAD_URL" -q -O /tmp/nvim

    # Make the downloaded binary executable
    chmod +x /tmp/nvim

    # Install the downloaded binary to appropriate locations
    "$PRIVILEGE_TOOL" cp /tmp/nvim /usr/local/bin
    "$PRIVILEGE_TOOL" mv /tmp/nvim /usr/bin

    # Clean up temporary files
    rm /tmp/neovim_release.html

    printf "${GREEN}Latest Stable Neovim version $STABLE_NVIM_VERSION has been set up successfully!${NC}\n"
}

while [ "$SHOW_PROMPT" -gt 0 ]; do
    read -p "Do you wish to update, downgrade, or use stable Neovim? [update/downgrade/stable/no] " choice
    case $choice in
    [Uu]*)
        update_neovim
        break
        ;;
    [Dd]*)
        downgrade_neovim
        break
        ;;
    [Ss]*)
        use_stable_neovim
        break
        ;;
    [Nn]*) exit ;;
    *) echo "Please choose update, downgrade, stable, or no." ;;
    esac
done
