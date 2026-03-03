#!/bin/bash

VPN_NAME="vpnbook-pl134-tcp80"

if nmcli connection show --active | grep -q "$VPN_NAME"; then
    nmcli connection down "$VPN_NAME"
    notify-send "VPN" "Turning OFF"
else
    nmcli connection up "$VPN_NAME"
    notify-send "VPN" "Turning ON"
fi

pkill -RTMIN+8 waybar
