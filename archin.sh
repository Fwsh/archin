#!/bin/bash
# archin by github.com/Fwsh


launchPartitionManager() {
  echo "The partition manager will now launch. Make sure you have a boot, swap and root."
  echo "You can manually choose the drive you want to use."
  read -p "Press ENTER to list your drives."
  clear
  lsblk # List drives; could also be fdisk -l

  ## Detecting disks
  readarray -t lines < <(lsblk --nodeps -no name | grep "sd")
  echo "Please select a drive:"
  select choice in "${lines[@]}"; do
    [[ -n $choice ]] || { echo "Invalid choice. Please try again." >&2; continue; }
    break # valid, proceed
  done
  read -p "Choice (ENTER to confirm): " -r thedisk <<<"$choice"
  echo "We will be using the drive ' /dev/$thedisk '."
  drivetouse="/dev/$thedisk"
  ## Detecting disks

  #echo "Please enter the drive you want to use. (For example, /dev/sda)"
  #read -p "Drive: " drivetouse
  #clear
  #echo "We will be using the drive '$drivetouse'."

  echo "Please make sure to have a BOOT, a SWAP and a ROOT partition."
  echo "Example of sizes/filesystems:"
  echo "BOOT = 100M = Linux Filesystem."
  echo "SWAP = 4G = Linux Swap."
  echo "ROOT = 15G = Linux Filesystem.   //  You can set whatever size you want for ROOT."
  read -p "Press ENTER whenever you're ready."
  cfdisk $drivetouse
  clear
  mainMenu
}


continueToPart2() {
  # Copy the second script to the install itself
  cp archin2.sh /mnt/archin2.sh
  cp archind.sh /mnt/archind.sh
  cp hosts /mnt/hosts

  clear
  # chrooting into the new system
  echo "Please manually do 'arch-chroot /mnt' and 'bash archin2.sh' to continue."
  read -p "(Quit the script in order to do so)."
  arch-chroot /mnt ./archin2.sh # Root into the new system
}


launchInstallation() {
  read -p "What is your BOOT partition? (e.g. /dev/sda1) = " bootpartition
  read -p "What is your SWAP partition? (e.g. /dev/sda2) = " swappartition
  read -p "What is your ROOT partition? (e.g. /dev/sda3) = " rootpartition
  echo "BOOT = $bootpartition"
  echo "SWAP = $swappartition"
  echo "ROOT = $rootpartition"


  read -p "Press ENTER to continue if the above is correct."
  read -p "WARNING: This will format everything in the selected partitions. Press ENTER to proceed."
  mkfs.ext2 $bootpartition #boot
  mkswap $swappartition #swap
  mkfs.ext4 $rootpartition #root
  swapon $swappartition #activate swap if exists
  read -p "We will now mount the root partition. Press ENTER to proceed."
  clear

  mount $rootpartition /mnt
  mount $bootpartition /mnt/boot
  echo "It doesn't matter if /mnt/boot didn't mount."


  read -p "Press ENTER to install the base system."
  clear
  pacstrap /mnt base

  echo "Generating fstab..."
  genfstab -U /mnt >> /mnt/etc/fstab # Generate fstab
  continueToPart2
}

downloadRequiredScripts() {
  wget https://raw.githubusercontent.com/Fwsh/archin/master/archin2.sh
  wget https://raw.githubusercontent.com/Fwsh/archin/master/archind.sh
  wget https://raw.githubusercontent.com/Fwsh/archin/master/hosts
  clear
  mainMenu
}

mainMenu() {
  PS3='Choice (ENTER to confirm): '
  options=("Initialize (Required)" "Manage Partitions" "Launch Installation" "Continue to Part 2" "Quit")
  select opt in "${options[@]}"
  do
      case $opt in
          "Initialize (Required)")
              downloadRequiredScripts
              ;;
          "Manage Partitions")
              launchPartitionManager
              ;;
          "Launch Installation")
              launchInstallation
              ;;
          "Continue to Part 2")
              continueToPart2
              ;;
          "Quit")
              exit
              ;;
          *) echo "invalid option $REPLY";;
      esac
  done
}

clear
mainMenu