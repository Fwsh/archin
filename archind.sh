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


mainMenu3() {
  clear
  echo "- - archin: Part 3 (optional) - -"
  echo "!!! NOTICE !!!"
  echo "!!! NOTICE !!!"
  echo "!!! NOTICE !!!"
  echo "!!! NOTICE !!! - To install 'yay' (an Arch User Repository tool), please log in as a normal user first."
  echo "!!! NOTICE !!!"
  echo "!!! NOTICE !!!"
  echo "!!! NOTICE !!!"
  PS3='Choice (ENTER to confirm): '
  options=("Setup Network" "Update" "Install Drivers" "Install a Desktop Environment" "Install a Login Manager [lxdm]" "Install SUDO" "Install WGET" "Install NEOFETCH" "Install YAY [AUR]" "Reboot")
  select opt in "${options[@]}"
  do
      case $opt in
          "Setup Network")
			  clear
			  read -p "Press ENTER to do step 1 of 3."
			  systemctl start dhcpcd
			  read -p "Press ENTER to do step 2 of 3."
			  systemctl enable dhcpcd
			  read -p "Press ENTER to do step 3 of 3."
			  dhcpcd
			  read -p "Done. Press ENTER to continue."
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
			              pacman -S lxterminal
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