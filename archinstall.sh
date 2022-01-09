#!/bin/sh

echo "\ 
 █████╗ ██████╗  ██████╗██╗  ██╗    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     
██╔══██╗██╔══██╗██╔════╝██║  ██║    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     
███████║██████╔╝██║     ███████║    ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     
██╔══██║██╔══██╗██║     ██╔══██║    ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     
██║  ██║██║  ██║╚██████╗██║  ██║    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗
╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝
"

loadkeys us

sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf

reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

timedatectl set-ntp true

lsblk
echo "Select the drive for the install: "
read drive
cfdisk $drive 
echo "Enter the linux partition: "
read partition
mkfs.ext4 $partition 
read -p "Did you also create efi partition? [y/n]" answer
if [[ $answer = y ]] ; then
  echo "Enter EFI partition: "
  read efipartition
  mkfs.fat -F 32 $efipartition
fi
mount $partition /mnt
mkdir -p /mnt/boot
mount $efipartition /mnt/boot

#swap
head -c 3G /dev/zero >/mnt/swapfile
chmod 600 /mnt/swapfile
mkswap /mnt/swapfile
swapon /mnt/swapfile

pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
cp chroot.sh /mnt/usr/local/bin/chroot
cp usersetup.sh /mnt/usr/local/bin/user_setup
blkid -s UUID -o value $partition > /mnt/root-uuid
arch-chroot /mnt /usr/local/bin/chroot
