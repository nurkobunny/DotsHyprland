#!/bin/bash

CONNECTION=$(nmcli -t -f NAME,TYPE,STATE connection show --active | grep -E "ethernet|wireless" | cut -d: -f1 | head -n1)

GOOGLE_DNS="8.8.8.8,8.8.4.4"
XBOX_DNS="176.99.11.77,80.78.247.254"

CURRENT_DNS=$(nmcli -g ipv4.dns connection show "$CONNECTION")

if [ "$CURRENT_DNS" = "$XBOX_DNS" ]; then
    nmcli connection modify "$CONNECTION" ipv4.dns "$GOOGLE_DNS"
    nmcli connection modify "$CONNECTION" ipv4.ignore-auto-dns yes
    nmcli connection up "$CONNECTION"
    notify-send "DNS Switched" "Now using Google DNS"
else
    nmcli connection modify "$CONNECTION" ipv4.dns "$XBOX_DNS"
    nmcli connection modify "$CONNECTION" ipv4.ignore-auto-dns yes
    nmcli connection up "$CONNECTION"
    notify-send "DNS Switched" "Now using Xbox DNS (DNS.watch/Comss)"
fi
