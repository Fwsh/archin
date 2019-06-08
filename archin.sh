#!/bin/bash
# archin by github.com/Fwsh

read -p "Press ENTER to start the installation process."
wget raw.githubusercontent.com/Fwsh/archin/master/archin2.sh
wget raw.githubusercontent.com/Fwsh/archin/master/archind.sh
wget raw.githubusercontent.com/Fwsh/archin/master/hosts

## Let's create partitions.
## You will need a boot partition, a swap partition and a root partition.
## Please use "Linux Filesystem" for everything except swap (use Linux Swap)

read -p "Currently, sda1 = boot, sda2 = swap, sda3 = root"
cfdisk # 100M (Boot / Linux Filesystem) /// 1G-4G (Linux Swap) /// Rest (root / Linux Filesystem)
##(User creates partitons)

## What is your boot partition? e.g. sda1
##(answer)
## What is your swap partition? e.g. sda2 / Leave empty if none
##(answer)
## What is your root partition? e.g. sda3
##(answer)

## We will now be formatting everything you selected. Proceed?
read -p "WARNING: This will format everything in sda1, sda2 and sda3. Press ENTER to proceed."
mkfs.ext2 /dev/sda1 #boot
mkswap /dev/sda2 #swap
mkfs.ext4 /dev/sda3 #root
swapon /dev/sda2 #activate swap if exists

## We will now mount the root partition.
read -p "We will now mount the root partition."
mount /dev/sda3 /mnt # Mount root on /mnt
mount /dev/sda1 /mnt/boot # Mount boot or efi

# Installing pacstrap base
read -p "Press ENTER to install pacstrap base."
pacstrap /mnt base # install the "base" package group to the mounted partition

# Copy the second script to the install itself
cp archin2.sh /mnt/archin2.sh
cp archind.sh /mnt/archind.sh
cp hosts /mnt/hosts

# Generating fstab

genfstab -U /mnt >> /mnt/etc/fstab # Generate fstab

# chrooting into the new system

read -p "Manually do 'arch-chroot /mnt' and 'sh archin2.sh'"
#arch-chroot /mnt ./archin2.sh # Root into the new system

