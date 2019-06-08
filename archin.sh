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

