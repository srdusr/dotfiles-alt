#!/bin/sh

country=$(protonvpn s | grep Country)
connection=$(pgrep -a openvpn$ | head -n 1 | awk '{print $NF }' | cut -d '.' -f 1)

if [ "$connection" != "" ]; then
    echo " vpn" #"$country"
else
    echo " vpn"
fi
#
#proton_status=$(protonvpn s)
#current_status=$(protonvpn s | wc -l)
#current_server=$(protonvpn s | awk '/Server:/ {print "VPN "$2}')
#
#if [ "$current_status" -gt 2 ]; then
#    echo "$current_server"
#else
#    echo "%{F#bf616a}NO VPN"
#fi
