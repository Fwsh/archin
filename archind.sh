#!/bin/bash
# archind by github.com/Fwsh

# Check the network adapter's code from this (e.g. eth0, or it could be enp0s25)
ip link

# Let's create and enable this
systemctl enable dhcpcd@enp0s3
systemctl start dhcpcd@enp0s3

# Ping it
ping 8.8.8.8

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