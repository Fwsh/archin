# archin

- Step 1: Boot the Arch Linux iso.

- Step 2: pacman -Sy wget

[Step 2 is a temporary measure since Arch has removed "wget" from the base .iso in favour of "curl".
I will eventually update the script to use "curl" instead.
https://gitlab.archlinux.org/archlinux/archiso/-/commit/9b49621f78465cf912f853e1884e3f7446497229]

- Step 3: wget fwsh.github.io/archin/archin.sh

- Step 4: bash archin.sh


Currently, menus are being implemented. This is a beta.

##### DO NOT USE THIS ON YOUR ACTUAL SYSTEM FOR NOW! IT IS UNFINISHED AND UPDATED OFTEN; SOMETHING MIGHT BREAK! Please only use this on a Virtual Machine for the time being.
