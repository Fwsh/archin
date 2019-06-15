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
#systemctl enable dhcpcd
#systemctl start dhcpcd
#dhcpcd
#echo "Done."

# Ping it
#ping 8.8.8.8

# Confirm
#echo "Press ENTER to install the following:"
#echo "[sudo, neofetch, xfce4, lxdm]"
#echo "Installing lxdm will also enable it."
#echo "Everything will install automatically and your system will reboot."
#echo "DON'T FORGET TO SELECT 'Xfce Session' AT THE BOTTOM LEFT OF THE LOGIN MANAGER!"
#read -p "Press ENTER to proceed, or CTRL+C to cancel."

# Update everything
#pacman -Syu

# Install sudo
#pacman -S sudo

# Install neofetch
#pacman -S neofetch

# Install xfce4
#pacman -S xfce4

# Install lxdm
#pacman -S lxdm

# Enable lxdm
#systemctl enable lxdm

#read -p "Done. Press ENTER to reboot."
#reboot


mainMenu3() {
  clear
  echo "- - archin: Part 3 (optional) - -"
  echo "!!! NOTICE !!! - To install 'yay' (an Arch User Repository tool), please log in as a normal user first."
  PS3='Choice (ENTER to confirm): '
  options=("Setup Network" "Update" "Install Drivers" "Install a Desktop Environment" "Install a Login Manager [lxdm]" "Install SUDO" "Install WGET" "Install NEOFETCH" "Install YAY [AUR]" "Reboot")
  select opt in "${options[@]}"
  do
      case $opt in
          "Setup Network")
			  clear
			  systemctl start dhcpcd
			  systemctl enable dhcpcd
			  dhcpcd
			  systemctl start dhcpcd
			  systemctl enable dhcpcd
			  dhcpcd
			  echo "Done."
			  mainMenu3
              ;;
          "Update")
			  clear
			  pacman -Syu
			  mainMenu3
              ;;
          "Install Drivers")
			  clear
			  PS3='Choice (ENTER to confirm): '
			  options=("PulseAudio")
			  select opt in "${options[@]}"
			  do
			      case $opt in
			          "PulseAudio")
			              pacman -S pulseaudio
			              mainMenu3
			              ;;
			          *) echo "invalid option $REPLY";;
			      esac
			  done
			  mainMenu3
              ;;
          "Install a Desktop Environment")
			  clear
			  echo "Only LXDE and XFCE4 have been tested yet."
			  PS3='Choice (ENTER to confirm): '
			  options=("xfce4" "lxde" "cinnamon" "plasma" "i3-wm")
			  select opt in "${options[@]}"
			  do
			      case $opt in
			          "lxde")
			              pacman -S lxde
			              mainMenu3
			              ;;
			          "xfce4")
			              pacman -S xfce4
			              pacman -S xfce4-goodies
			              mainMenu3
			              ;;
			          "cinnamon")
			              pacman -S cinnamon
			              mainMenu3
			              ;;
			          "plasma")
			              pacman -S plasma
			              mainMenu3
			              ;;
			          "i3-wm")
			              pacman -S i3-wm
			              mainMenu3
			              ;;
			          *) echo "invalid option $REPLY";;
			      esac
			  done
              ;;
          "Install a Login Manager [lxdm]")
			  clear
			  pacman -S lxdm
			  systemctl enable lxdm
			  mainMenu3
              ;;
          "Install SUDO")
			  clear
			  pacman -S sudo
			  mainMenu3
              ;;
          "Install WGET")
			  clear
			  pacman -S wget
			  mainMenu3
              ;;
          "Install NEOFETCH")
			  clear
			  pacman -S neofetch
			  mainMenu3
              ;;
          "Install YAY [AUR]")
			  clear
			  sudo pacman -Syu
			  sudo pacman -S git
			  git clone https://aur.archlinux.org/yay.git
			  cd yay
			  makepkg -si
			  mainMenu3
              ;;
          "Reboot")
			  clear
			  reboot
              ;;
          *) echo "invalid option $REPLY";;
      esac
  done
}


mainMenu3