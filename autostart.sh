#!/bin/bash

# Set the environment variable
export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -u $LOGNAME gnome-session)/environ | tr '\0' '\n' | cut -d= -f2-)

# Load custom dconf settings
/usr/bin/dconf load / <$HOME/.config/dconf-custom/settings.dconf
