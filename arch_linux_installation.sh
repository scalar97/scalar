DUAL BOOT ARCH-LINUX WITH WINDOWS.
UEFI MODE + WIFII INSTALLATION


PART 1 PRE-INSTALLATION
bios
====
#- turn off secure boot
#- set arch-linux priority boot higher than windows' if not done already.
# (this will eneble the grub menu access and stop windows from overtaking the boot process)

bootable usb 1GB or more
========================
# downlowd the latest arch linux iso from arch website
# format this usb fat32, then right click and unmount the it.
# open the terminal in to burn the downloaded iso to the disk.
# first list all the disks to avoid mistakes
lsblk
#then run the folowing comand, where sdx is the path to your usb in under /dev/sdb, and NOT one of its partitions such as /dev/sbd1
dd bs=4M if=/path/to/archlinux.iso of=/dev/sdx status=progress && sync



PART 2. BOOT INTO THE USB, THEN SELECT UEFI 64BITS

#2. Partitioning the ssd
# list hard drives
fdisk -l
#. select the drive for partitioning
cfdisk /dev/sda
# create partitions are wanted,
# add boot flag where necessary
# add file type, swap, linux file system..
# when done, write, type yes, and quit. see help for help.

#verify if the partitions were done as wanted.
fdisk -l
# in my case swap was already created in ubuntu on /dev/sda5
# arch will be installed on /dev/sda7


# 3. format the newly created partition prior installation
mkfs.ext4 /dev/sda7


#4. mounting the created partitions to the /mnt folder to isolate them
mount /dev/sda7 /mnt
#set /dev/sda5 as a swap area
mkswap /dev/sda5

#eneble the swap on this disk
swapon /dev/sda5

#check if enebled. if eneble it will display the disk. else, it fill output nothing
swap --show


PART 4. SYSTEM INSTALLATION

#0. check for internet
#wifi
wifi-menu
#then check if connected
ping -c 3 google.com


#0. Update pacman database
pacman -Syy

#1. installing the base system and base libraries on the root drive using pacstrap
# pacstrap installs packages to a spefied root directory.
pacstap /mnt base base-devel


#===> change root to customise the installation.
# chroot isolates the mounted partitions. in this case /dev/sda7.
# this is so that all the next operations be performed on this partition only
arch-chroot /mnt

# 1. create the root password for the installed system. (enter and confirm)
passwd

# 2. specify zone info for the new system by editing this file
#nano is the text editor that i am using, and the file to edit is the argument passed to nano
#if you have a favorite text editor make sure it is installed first by entering "which my_editor_name"

nano /etc/locale.gen
# in this file uncoment your local language.
# in my case i uncomented en_IE.UTF-8 UTF-8, and en_IE ISO-8859-1
# Because i live in Ireland.

# to exit and save press <ctrl>+o <enter> <ctrl>+x

#---> generating the locale file based on the selection made
locale-gen

#---> specifying the time zone
cd /usr/share/zoneinfo && ls

#cd to the one closest to your place. this might match the uncomented language done earlier in this step
cd /usr/share/zoneinfo/GB-Eire && ls
# if an error occur saying it's not a directory, then this is the actual file you were looking for.
# go to next step. else, keep selecting the one that is closest to your current location and continue
# until it's no longer a directory. by adding it to the cd steps

#create a symbolic link to your timezone file located in /etc/localtime.
# -f: force, makes sure the default is overwritten to your selected one.
# to view was was the default, enter: cat /etc/localtime
ln -s -f /usr/share/zoneinfo/GB-Eire /etc/localtime

#create the root hostname. i prefer to use root.
echo "root" > /etc/hostname

#====> bootloader installation.

#to download the files needed to install grub
pacman -S grub-bios
#to install grub, on the ssd where sdx is the name of the harddrive. in my case /dev/sda, uncoment below
grub-install /dev/sdx

#generate an init file to store hardware information
mkinitcpio -p linux

#generate the grub config file specific to arch
grub-mkconfig -o /boot/grub/grub.cfg

#exit the chroot session
exit

#===> generate an fstab file based on the mounted partitions

# to view the initial content of this fstab file, enter
cat /mnt/etc/fstab

#now generate a new one and APPEND the output at the end of this one
genfstab /mnt >> /mnt/etc/fstab

#view the changes
cat /mnt/etc/fstab


#unmount the partitions created. in this case only /dev/sda7
umount /dev/sda7

#REBOOT
reboot



-PART 4. POST INSTALLATION

#boot into arch. if no wifi connection is detected, do the following

REBOOT INTO THE ARCH INSTALLATION USB, THEN
#1. Mount back the arch linux partitions in my case /dev/sda7 only

mount /dev/sda7 /mnt

#connect to wifi
wifi-menu

# change root to the mounted partition
arch-chroot /mnt

#update pacman database
pacman -Syy

#installn dialog
pacman -S dialog

#install wpa_supplicant
pacman -S wpa_supplicant

#exit chroot
exit

#unmount the mounted partitions then reboot
umount /dev/sda7
reboot

#login into arch then enter
wifi-menu
ping -c 3 google.com #checking

# create a new user
# -m home as /home/tati
# -g as regular user's group
# -s bash as default login shell
useradd -m -g users -s /bin/bash tati

#create user's password
passwd

#add the user to user's group
EDITOR=vi visudo
#scroll down to root and add
new_user_s_username ALL=(ALL) ALL

#scroll down to root and add
%new_user_s_usergroup_name ALL=(ALL) ALL

#to delete a user and his files
#userdel -r username

#INTALLING THE GUI

#install xorg display server
pacman -S xorg-server xorg-xinit

#install graphic card drivers
#in my case xf86-video-amddgpu
pacman -S xf86-video-intel mesa

#install a display manager
pacman -S gdm

#install . desktop environment
pacman -S gnome

#eneble display manager ar boot
systemctl enable gdm


Sent from my iPad
