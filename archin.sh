#!/bin/bash
# archin by github.com/Fwsh

pacman -Sy # Initialize pacman just in case

## Let's create partitions.
## You will need a boot partition, a swap partition and a root partition.
## Please use "Linux Filesystem" for everything except swap (use Linux Swap)

cfdisk # 100M (Boot / Linux Filesystem) /// 1G-4G (Linux Swap) /// Rest (root / Linux Filesystem)
##(User creates partitons)

## What is your boot partition? e.g. sda1
##(answer)
## What is your swap partition? e.g. sda2 / Leave empty if none
##(answer)
## What is your root partition? e.g. sda3
##(answer)

## We will now be formatting everything you selected. Proceed?

mkfs.ext2 /dev/sda1 #boot
mkswap /dev/sda2 #swap
mkfs.ext4 /dev/sda3 #root
swapon /dev/sda2 #activate swap if exists

## We will now mount the root partition.

mount /dev/sda3 /mnt # Mount root on /mnt
mount /dev/sda1 /mnt/boot # Mount boot or efi

# Installing pacstrap base

pacstrap /mnt base # install the "base" package group to the mounted partition

# Generating fstab

genfstab -U /mnt >> /mnt/etc/fstab # Generate fstab

# chrooting into the new system

arch-chroot /mnt # Root into the new system

# Setting timezone

ln -sf /usr/share/zoneinfo/Canada/Toronto /etc/localtime #set timezone
hwclock --systohc # generate /etc/adjtime

# Please uncomment your prefered locale (e.g., uncomment en_CA.utf-8 UTF-8)

nano /etc/locale.gen # Uncomment #en_CA.UTF-8 UTF-8
locale-gen # Generate what you just uncommented

# Please type the locale you just chose (e.g., LANG-en_CA.UTF-8)

nano /etc/locale.conf # Write   LANG=en_CA.UTF-8

# Hostname stuff

nano /etc/hostname # Write the computer's hostname, for example "arch"
nano /etc/hosts # Add the matching entries to the hosts file
# 127.0.0.1   localhost
# ::1         localhost
# 127.0.0.1   myhostname.localdomain  myhostname

# Generating mkinitcpio

mkinitcpio -p linux # Create initramfs

# Accounts

passwd # Set the root password (archin)

# Getting grub and installing it

pacman -S grub efibootmgr # Install grub and efibootmgr

mkdir /boot/grub
grub-mkconfig -o /boot/grub/grub.cfg

# Only either one of the following:
grub-install --force --target=i386-pc --recheck /dev/sda
# grub-install --target=x86_64-efi --efi-directory=/boot --recheck

# Finished
# Do you want to configure more things, such as your network and install a Desktop Environment?
# If so, reboot into your new installation and run "sh archind".
# WARNING: In its current form, it will automatically do everything after the network part.
# You will end up with
# [sudo, neofetch, xfce4, lxdm]
# along with most of their dependancies.

# wget archind from github

exit

reboot