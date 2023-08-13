#!/bin/bash

# Disable screen lock
gsettings set org.gnome.desktop.screensaver lock-enabled false

# Mutter Overlay Key
gsettings set org.gnome.mutter overlay-key ''

# Disable update notification
gsettings set org.gnome.software enable-receipts false

# Custom Keybinding Names
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybinding-names "['custom-keybinding']"

# Custom Keybinding 0
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybindings:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom-keybinding/ name "scratchpad"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybindings:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom-keybinding/ command "scratchpad"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybindings:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom-keybinding/ binding "<Primary><Alt>T"

