#!/bin/bash
# archind by github.com/Fwsh

# Network check and start
#echo "Check the network adapter's code from this (e.g. eth0, or it could be enp0s25)"
#read -p "Press ENTER to continue."
#ip link
#echo "What is your adapter's code? (e.g. eth0, enp0s3, enp0s25...)"
#read -p "Code: " adaptercode
#systemctl enable dhcpcd@$adaptercode
#systemctl start dhcpcd@$adaptercode

# Using dhcpcd instead
systemctl enable dhcpcd
systemctl start dhcpcd
dhcpcd
echo "Done."

# Ping it
#ping 8.8.8.8

# Confirm
echo "Press ENTER to install the following:"
echo "[sudo, neofetch, xfce4, lxdm]"
echo "Installing lxdm will also enable it."
echo "Everything will install automatically and your system will reboot."
echo "DON'T FORGET TO SELECT 'Xfce Session' AT THE BOTTOM LEFT OF THE LOGIN MANAGER!"
read -p "Press ENTER to proceed, or CTRL+C to cancel."

# Update everything
pacman -Syu

# Install sudo
pacman -S sudo

# Install neofetch
pacman -S neofetch

# Install xfce4
pacman -S xfce4

# Install lxdm
pacman -S lxdm

# Enable lxdm
systemctl enable lxdm

read -p "Done. Press ENTER to reboot."
reboot