#!/bin/bash
# archin2 by github.com/Fwsh


setupLocale() {
	PS3='Choice (ENTER to confirm): '
	options=("Automatically" "Manually")
	select opt in "${options[@]}"
	do
	  case $opt in
	      "Automatically")
	          echo "Automatically"
	          ln -sf /usr/share/zoneinfo/Canada/Toronto /etc/localtime #set timezone
			  hwclock --systohc # generate /etc/adjtime
			  echo "en_CA.UTF-8 UTF-8" > /etc/locale.gen
			  locale-gen
			  echo "LANG=en_CA.UTF-8" > /etc/locale.conf
			  clear
			  mainMenu2
	          ;;
	      "Manually")
			  # Setting timezone
			  clear
			  read -p "Press ENTER to set the timezone to Canada/Toronto (custom options coming soon)."
			  ln -sf /usr/share/zoneinfo/Canada/Toronto /etc/localtime #set timezone
			  hwclock --systohc # generate /etc/adjtime
			  # Please uncomment your prefered locale (e.g., uncomment en_CA.UTF-8 UTF-8)
			  clear
			  read -p "Please uncomment your prefered locale (e.g., en_CA.UTF-8 UTF-8). Press ENTER to proceed."
			  nano /etc/locale.gen # Uncomment #en_CA.UTF-8 UTF-8
			  locale-gen # Generate what you just uncommented
			  # Please type the locale you just chose (e.g., LANG=en_CA.UTF-8)
			  clear
			  read -p "Please type the locale you just chose (e.g., LANG=en_CA.UTF-8). Press ENTER to proceed."
			  nano /etc/locale.conf # Write   LANG=en_CA.UTF-8
			  clear
			  mainMenu2
	          ;;
	      *) echo "invalid option $REPLY";;
	  esac
	done
}


setupHostname() {
	# Hostname stuff
	clear
	echo "Please type in your hostname (aka your computer's name)."
	read -p "Hostname: " myhostname
	echo $myhostname > /etc/hostname # Write the computer's hostname, for example "arch"
	cp hosts /etc/hosts
	clear
	#read -p "Please replace 'arch' with the hostname you just chose. Press ENTER to proceed."
	#nano /etc/hosts # Add the matching entries to the hosts file
	# 127.0.0.1   localhost
	# ::1         localhost
	# 127.0.0.1   myhostname.localdomain  myhostname
	sed -i "s|arch|$myhostname|g" /etc/hosts
	rm hosts
	clear
	mainMenu2
}


mkinitcpioGeneration() {
	# Generating mkinitcpio
	clear
	echo "Generating mkinitcpio"
	mkinitcpio -p linux # Create initramfs
	clear
	mainMenu2
}


setRootPassword() {
	# Accounts
	clear
	echo "Setting up 'root' user."
	passwd # Set the root password
	clear
	#echo "Setting up user account."
	#read -p "Username (lowercase only): " thenewuser
	#echo "Adding user $thenewuser."
	#useradd $thenewuser
	#passwd $thenewuser
	#clear
	#echo "Do you want to install 'sudo'?"
	#echo "This will also add your normal account to the sudoers group."
	#echo "By doing so, it will have the ability to run root commands."
	#PS3='Choice (ENTER to confirm): '
	#options=("Yes" "No")
	#select opt in "${options[@]}"
	#do
	#  case $opt in
	#      "Yes")
	#          pacman -Syu
	#          pacman -S sudo
	#          gpasswd -a $thenewuser sudoers
	#          echo '$thenewuser has been added to the sudoers group.'
	#          clear
	#		   mainMenu2
	#          ;;
	#      "No")
	#         clear
	#		  mainMenu2
	#          ;;
	#      *) echo "invalid option $REPLY";;
	#  esac
	#done
	clear
	mainMenu2
}


installingGrub() {
	# Getting grub and installing it
	clear
	echo "Installing GRUB."
	pacman -S grub efibootmgr # Install grub and efibootmgr
	# Processing grub
	mkdir /boot/grub
	grub-mkconfig -o /boot/grub/grub.cfg
	clear
	echo "GRUB may only be installed in one mode. Which mode are you in?"
	PS3='Choice (ENTER to confirm): '
	options=("Normal" "UEFI (Untested)")
	select opt in "${options[@]}"
	do
	  case $opt in
	      "Normal")
			  clear
			  readarray -t lines < <(lsblk --nodeps -no name | grep "sd")
			  echo "IMPORTANT - Please select your boot drive."
			  select choice in "${lines[@]}"; do
			    [[ -n $choice ]] || { echo "Invalid choice. Please try again." >&2; continue; }
			    break # valid, proceed
			  done
			  read -p "Choice (ENTER to confirm): " -r thebootdisk <<<"$choice"
			  echo "We will be using the drive ' /dev/$thebootdisk '."
			  bootdrive="/dev/$thebootdisk"
			  grub-install --force --target=i386-pc --recheck $bootdrive
			  clear
			  mainMenu2
	          ;;
	      "UEFI (Untested)")
			  clear
			  readarray -t lines < <(lsblk --nodeps -no name | grep "sd")
			  echo "IMPORTANT - Please select your boot drive."
			  select choice in "${lines[@]}"; do
			    [[ -n $choice ]] || { echo "Invalid choice. Please try again." >&2; continue; }
			    break # valid, proceed
			  done
			  read -p "Choice (ENTER to confirm): " -r thebootdisk <<<"$choice"
			  echo "We will be using the drive ' /dev/$thebootdisk '."
			  bootdrive="/dev/$thebootdisk"
			  grub-install --target=x86_64-efi --efi-directory=/boot --recheck $bootdrive
			  clear
			  mainMenu2			  
	          ;;
	      *) echo "invalid option $REPLY";;
	  esac
	done
	# Only either one of the following:
	#clear
	#read -p "IMPORTANT - What is your boot drive? (e.g. /dev/sda) = " bootdrive
	#grub-install --force --target=i386-pc --recheck $bootdrive
	#grub-install --target=x86_64-efi --efi-directory=/boot --recheck
	clear
	mainMenu2
}


finalize() {
	clear
	echo "Finished."
	echo "The base system is now installed. However, you may still want to install extra tools."
	echo "If you want help with enabling your ethernet port as well as installing"
	echo "a Desktop Environment, you can run 'bash /archind.sh' after booting."
	echo "If not, simply delete it and never think about it again."
	read -p "[Press ENTER to continue.]"
	clear
	echo "- - -"
	echo "We are now back to the previous menu."
	echo "To exit and be able to reboot, use the 'Quit' option (5),"
	echo "at which point you can eject the installation media and reboot."
	echo "- - -"
	echo ""
	exit
}


mainMenu2() {
  echo "- - archin: Part 2 - -"
  PS3='Choice (ENTER to confirm): '
  options=("Setup Locale" "Setup Hostname" "Generate mkinitcpio" "Create root account" "Install GRUB" "Finalize")
  select opt in "${options[@]}"
  do
      case $opt in
          "Setup Locale")
              setupLocale
              ;;
          "Setup Hostname")
              setupHostname
              ;;
          "Generate mkinitcpio")
              mkinitcpioGeneration
              ;;
          "Create root account")
              setRootPassword
              ;;
          "Install GRUB")
              installingGrub
              ;;
          "Finalize")
              finalize
			  ;;
          *) echo "invalid option $REPLY";;
      esac
  done
}


clear
mainMenu2