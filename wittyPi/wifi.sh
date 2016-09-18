#! /bin/bash
ssid=$1
pass=$2
wpa_passphrase $ssid $pass >> /etc/wpa_supplicant/wpa_supplicant.conf
echo "$ssid added to wpa_supplicant.conf, run wpa_cli to connect"

