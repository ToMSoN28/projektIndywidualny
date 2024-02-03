#!/bin/sh
#podstawowa konfiguracja RPi4
#tkowa 05.2023

# Zmienne konfiguracyjne
interface="wlan0"
static_ip_address="192.168.0.3/24"
static_routers="192.168.0.1"
static_domain_name_servers="192.168.0.3 8.8.8.8"
ssid="StudPW-ubnRvpT-2.4G"
psk="hasloDoSieci"

cp /etc/dhcpcd.conf /etc/dhcpcd.conf.old

echo '' >> /etc/dhcpcd.conf
echo "# Konfiguracja statyczna dla interfejsu $interface" >> /etc/dhcpcd.conf
echo "interface $interface" >> /etc/dhcpcd.conf
echo "static ip_address=$static_ip_address" >> /etc/dhcpcd.conf
echo "static routers=$static_routers" >> /etc/dhcpcd.conf
echo "static domain_name_servers=$static_domain_name_servers" >> /etc/dhcpcd.conf

echo '' >> /etc/wpa_supplicant/wpa_supplicant.conf
echo "# Sieć $ssid" >> /etc/wpa_supplicant/wpa_supplicant.conf
echo "network={" >> /etc/wpa_supplicant/wpa_supplicant.conf
echo "    ssid=\"$ssid\"" >> /etc/wpa_supplicant/wpa_supplicant.conf
echo "    psk=\"$psk\"" >> /etc/wpa_supplicant/wpa_supplicant.conf
echo "}" >> /etc/wpa_supplicant/wpa_supplicant.conf

rfkill unblock 0
ifconfig $interface up

systemctl enable ssh
systemctl start ssh

reboot
