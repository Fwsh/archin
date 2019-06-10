
setupLocale() {
	PS3='Choice (ENTER to confirm): '
	options=("Automatically" "Manually" "Quit")
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
	      "Quit")
	          break
	          ;;
	      *) echo "invalid option $REPLY";;
	  esac
	done
}

setupHostname() {
	# Hostname stuff
	clear
	read -p "Please type in your hostname (aka your computer's name). Press ENTER to proceed: " myhostname
	echo $myhostname > /etc/hostname # Write the computer's hostname, for example "arch"
	cp hosts /etc/hosts
	clear
	#read -p "Please replace 'arch' with the hostname you just chose. Press ENTER to proceed."
	#nano /etc/hosts # Add the matching entries to the hosts file
	# 127.0.0.1   localhost
	# ::1         localhost
	# 127.0.0.1   myhostname.localdomain  myhostname
	sed -i "s|arch|$myhostname|g" /etc/hosts
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
	passwd # Set the root password (archin)
	clear
	echo "Setting up user account."
	read -p "Username (lowercase only): " $thenewuser
	useradd $thenewuser
	passwd $thenewuser
	clear
	echo "Do you want to install 'sudo'?"
	echo "This will also add your normal account to the sudoers group."
	echo "By doing so, it will have the ability to run root commands."
	PS3='Choice (ENTER to confirm): '
	options=("Yes" "No")
	select opt in "${options[@]}"
	do
	  case $opt in
	      "Yes")
	          pacman -Sy
	          pacman -S sudo
	          gpasswd -a $thenewuser sudoers
	          clear
	          echo '$thenewuser has been added to the sudoers group.'
	          ;;
	      "No")
			  mainMenu2
	          ;;
	      *) echo "invalid option $REPLY";;
	  esac
	done
	mainMenu2
}

installingGrub() {
	# Getting grub and installing it
	clear
	read -p "Press ENTER to install grub."
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
			  read -p "IMPORTANT - What is your boot drive? ( e.g. /dev/sda ) = " bootdrive
			  grub-install --force --target=i386-pc --recheck $bootdrive
	          ;;
	      "UEFI (Untested)")
			  clear
			  read -p "IMPORTANT - What is your boot drive? ( e.g. /dev/sda ) = " bootdrive
			  grub-install --target=x86_64-efi --efi-directory=/boot --recheck $bootdrive
	          ;;
	      *) echo "invalid option $REPLY";;
	  esac
	done

	# Only either one of the following:
	#clear
	#read -p "IMPORTANT - What is your boot drive? (e.g. /dev/sda) = " bootdrive
	#grub-install --force --target=i386-pc --recheck $bootdrive
	# grub-install --target=x86_64-efi --efi-directory=/boot --recheck
	clear
	mainMenu2
}

finalize() {
clear
	echo "Finished."
	echo "The base system is now installed. However, you may still want to install extra tools."
	echo "If you want help with enabling your ethernet port as well as installing"
	echo "a Desktop Environment, you can run 'sh /archind.sh' after booting."
	echo "If not, simply delete it and never think about it again."
	read -p "You may now eject your installation media and reboot. Press ENTER to continue."
	clear
	mainMenu2
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