
setupLocale() {
	# Setting timezone
	clear
	read -p "Press ENTER to set timezone."
	ln -sf /usr/share/zoneinfo/Canada/Toronto /etc/localtime #set timezone
	hwclock --systohc # generate /etc/adjtime


	# Please uncomment your prefered locale (e.g., uncomment en_CA.utf-8 UTF-8)
	clear
	read -p "Please uncomment your prefered locale (e.g., en_CA.utf-8 UTF8). Press ENTER to proceed."
	nano /etc/locale.gen # Uncomment #en_CA.UTF-8 UTF-8
	locale-gen # Generate what you just uncommented


	# Please type the locale you just chose (e.g., LANG=en_CA.UTF-8)
	clear
	read -p "Please type the locale you just chose (e.g., LANG=en_CA.UTF-8). Press ENTER to proceed."
	nano /etc/locale.conf # Write   LANG=en_CA.UTF-8
}

setupHostname() {
	# Hostname stuff
	clear
	read -p "Please type in your hostname (aka your computer's name). Press ENTER to proceed."
	nano /etc/hostname # Write the computer's hostname, for example "arch"
	cp hosts /etc/hosts
	clear
	read -p "Please replace 'arch' with the hostname you just chose. Press ENTER to proceed."
	nano /etc/hosts # Add the matching entries to the hosts file
	# 127.0.0.1   localhost
	# ::1         localhost
	# 127.0.0.1   myhostname.localdomain  myhostname
}

mkinitcpioGeneration() {
	# Generating mkinitcpio
	clear
	echo "Generating mkinitcpio"
	mkinitcpio -p linux # Create initramfs
}

setRootPassword() {
	# Accounts
	clear
	passwd # Set the root password (archin)
}

installingGrub() {
	# Getting grub and installing it
	clear
	read -p "Press ENTER to install grub."
	pacman -S grub efibootmgr # Install grub and efibootmgr

	# Processing grub
	mkdir /boot/grub
	grub-mkconfig -o /boot/grub/grub.cfg

	# Only either one of the following:
	clear
	read -p "IMPORTANT - What is your boot drive? (e.g. /dev/sda) = " bootdrive
	grub-install --force --target=i386-pc --recheck $bootdrive
	# grub-install --target=x86_64-efi --efi-directory=/boot --recheck
}

finalize() {
clear
	echo "Finished."
	echo "The base system is now installed. However, you may still want to install extra tools."
	echo "If you want help with enabling your ethernet port as well as installing"
	echo "a Desktop Environment, you can run 'sh /archind.sh' after booting."
	echo "If not, simply delete it and never think about it again."
	read -p "You may now eject your installation media and reboot. Press ENTER to continue."
}

mainMenu2() {
  PS3='Choice (ENTER to confirm): '
  options=("setupLocale" "setupHostname" "mkinitcpioGeneration" "setRootPassword" "installingGrub" "finalize" "Quit")
  select opt in "${options[@]}"
  do
      case $opt in
          "setupLocale")
              setupLocale
              ;;
          "setupHostname")
              setupHostname
              ;;
          "mkinitcpioGeneration")
              mkinitcpioGeneration
              ;;
          "setRootPassword")
              setRootPassword
              ;;
          "installingGrub")
              installingGrub
              ;;
          "finalize")
              finalize
              ;;
          "Quit")
              break
              ;;
          *) echo "invalid option $REPLY";;
      esac
  done
}

clear
mainMenu2