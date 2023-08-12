#!/bin/bash

# Launch the dconf command with dbus-launch and load custom dconf settings
dbus-launch /usr/bin/dconf load / <"$HOME"/.config/dconf-custom/settings.dconf
