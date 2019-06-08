#!/bin/bash
# archind by github.com/Fwsh

echo "Check the network adapter's code from this (e.g. eth0, or it could be enp0s25)"
read -p "Press ENTER to continue."
ip link

# Let's create and enable this
read -p "What is your adapter's code? e.g. eth0, enp0s3, enp0s25..." adaptercode
systemctl enable dhcpcd@$adaptercode
systemctl start dhcpcd@$adaptercode

# Ping it
#ping 8.8.8.8

echo "Press ENTER to install the following:"
echo "[sudo, neofetch, xfce4, lxdm]"
echo "Installing lxdm will also enable it."
echo "Everything will install automatically and your system will reboot."
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

reboot