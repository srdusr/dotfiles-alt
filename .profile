#!/bin/sh

#. ~/.env

#if [ -n "$DISPLAY" ] && [ -n "$XAUTHORITY" ] && [ "$SHLVL" -eq '1' ]; then
#    /usr/bin/dunst &
#fi

# Default session to be executed
unset DISPLAY XAUTHORITY
session=""

#pgrep bspwm || startx "$HOME"/.config/X11/.xinitrc
#startx "$HOME"/.config/X11/.xinitrc

# Function to display and start the selected session
display() {
    # Default list of sessions in priority order
    default_sessions=("Hyprland" "bspwm" "sway")

    # Check conditions and set session command
    if [ "$DISPLAY" = "" ] && [ "$XDG_VTNR" -eq 1 ]; then
        if [ -f ~/.session ]; then
            session=$(cat ~/.session)
            rm ~/.session  # Remove the session file after reading
        fi

        if [ "$session" != "" ]; then
            case "$session" in
                bspwm )
                    export XDG_SESSION_TYPE="x11"
                    session="startx /usr/bin/bspwm"
                    #session="pgrep bspwm || startx $HOME/.config/X11/.xinitrc"
                    #session="pgrep bspwm || (unset DISPLAY XAUTHORITY; startx $HOME/.config/X11/.xinitrc)"
                    #session="startx /home/srdusr/.config/X11/.xinitrc"
                    #session="exec bspwm -name login"
                    ;;
                Hyprland | sway)
                    session="exec $session"
                    ;;
                *)
                    echo "Session $session is not supported."
                    session=""
                    ;;
            esac
        else
            # Iterate through default sessions to find a suitable one
            for wm in "${default_sessions[@]}"; do
                if command -v "$wm" >/dev/null 2>&1; then
                    case "$wm" in
                        bspwm )
                            export XDG_SESSION_TYPE="x11"
                            session="startx /usr/bin/$wm"
                            #session="pgrep bspwm || startx $HOME/.config/X11/.xinitrc"
                            #session="pgrep bspwm || (unset DISPLAY XAUTHORITY; startx $HOME/.config/X11/.xinitrc)"
                            #session="startx /home/srdusr/.config/X11/.xinitrc"
                            #session="exec bspwm -name login"
                            break
                            ;;
                        Hyprland | sway)
                            session="exec $wm"
                            break
                            ;;
                    esac
                fi
            done
        fi

        # Execute the session command if session is set
        if [ "$session" != "" ]; then
            echo "Starting session: $session"
            eval "$session"
        else
            echo "No suitable window manager found or conditions not met."
        fi
    fi
}

# Zsh
zsh() {
    if [ "$ZSH_VERSION" != "" ]; then
        # Source zsh environment if it exists
        if [ -f ~/.config/zsh/.zshenv ]; then
            . ~/.config/zsh/.zshenv
        fi
    fi
}

# GnuPG
gnupg() {
    if ! systemctl --quiet --user is-active gpg-agent.socket && command -v gpg-agent >/dev/null 2>&1; then
        echo 'Launching GPG agent...'
        eval "$(gpg-agent --daemon)"
    fi
}

# D-Bus
dbus() {
    if [ "$DBUS_SESSION_BUS_ADDRESS" = "" ]; then
        if command -v dbus-launch >/dev/null 2>&1; then
            echo 'Launching D-BUS per-session daemon...'
            eval "$(dbus-launch --sh-syntax --exit-with-session)"
            echo "D-BUS per-session daemon address: ${DBUS_SESSION_BUS_ADDRESS}"
        fi
    fi
    dbus-update-activation-environment --systemd --all
}

# Gnome Keyring Daemon
gnome_keyring() {
    if command -v gnome-keyring-daemon >/dev/null 2>&1; then
        echo 'Launching/reinitializing Gnome keyring daemon...'
        eval "$(gnome-keyring-daemon --daemonize --start --components=ssh,secrets,pkcs11)"
        echo
        export SSH_AUTH_SOCK
    fi
}

# PolKit
polkit() {
    if [ -x /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 ]; then
        echo 'Launching PolicyKit agent...'
        /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
    fi
}

# Main
main() {
    zsh
    gnupg
    dbus
    gnome_keyring
    polkit
    display
}

main "$@"
