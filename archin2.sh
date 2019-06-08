# Setting timezone
read -p "Press ENTER to set timezone."
ln -sf /usr/share/zoneinfo/Canada/Toronto /etc/localtime #set timezone
hwclock --systohc # generate /etc/adjtime

# Please uncomment your prefered locale (e.g., uncomment en_CA.utf-8 UTF-8)
read -p "Please uncomment your prefered locale (e.g., en_CA.utf-8 UTF8)"
nano /etc/locale.gen # Uncomment #en_CA.UTF-8 UTF-8
locale-gen # Generate what you just uncommented

# Please type the locale you just chose (e.g., LANG=en_CA.UTF-8)
read -p "Please type the locale you just chose (e.g., LANG=en_CA.UTF-8)"
nano /etc/locale.conf # Write   LANG=en_CA.UTF-8

# Hostname stuff
read -p "Hosts stuff, see readme"
nano /etc/hostname # Write the computer's hostname, for example "arch"
nano /etc/hosts # Add the matching entries to the hosts file
# 127.0.0.1   localhost
# ::1         localhost
# 127.0.0.1   myhostname.localdomain  myhostname

# Generating mkinitcpio
read -p "Press ENTER to mkinitcpio"
mkinitcpio -p linux # Create initramfs

# Accounts
read -p "Press ENTER to set password"
passwd # Set the root password (archin)

# Getting grub and installing it
read -p "Press ENTER to get grub and efibootmgr"
pacman -S grub efibootmgr # Install grub and efibootmgr

read -p "Press enter to continue"
mkdir /boot/grub
grub-mkconfig -o /boot/grub/grub.cfg

read -p "Press enter to continue"
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

#exit

#reboot
read -p "Finished."