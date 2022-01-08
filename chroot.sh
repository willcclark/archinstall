#!/bin/sh

echo "
 ██████╗██╗  ██╗██████╗  ██████╗  ██████╗ ████████╗    ███████╗███████╗████████╗██╗   ██╗██████╗ 
██╔════╝██║  ██║██╔══██╗██╔═══██╗██╔═══██╗╚══██╔══╝    ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
██║     ███████║██████╔╝██║   ██║██║   ██║   ██║       ███████╗█████╗     ██║   ██║   ██║██████╔╝
██║     ██╔══██║██╔══██╗██║   ██║██║   ██║   ██║       ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
╚██████╗██║  ██║██║  ██║╚██████╔╝╚██████╔╝   ██║       ███████║███████╗   ██║   ╚██████╔╝██║     
 ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝    ╚═╝       ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝     
"

ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=us" >> /etc/vconsole.conf
echo "Hostname: "
read hostname
echo $hostname > /etc/hostname
echo "127.0.0.1       localhost" >> /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       $hostname.localdomain $hostname" >> /etc/hosts

pacman -S --noconfirm networkmanager

passwd

pacman -S --noconfirm intel-ucode
bootctl install
echo "default  arch.conf" >> /boot/loader/loader.conf
echo "editor   no" >> /boot/loader/loader.conf
echo "title   Arch Linux" >> /boot/loader/entries/arch.conf
echo "linux   /vmlinuz-linux" >> /boot/loader/entries/arch.conf
echo "initrd  /intel-ucode.img" >> /boot/loader/entries/arch.conf
echo "initrd  /initramfs-linux.img" >> /boot/loader/entries/arch.conf
echo 'options root="/dev/sda2" rw quiet vga=current' >> /boot/loader/entries/arch.conf

echo "title   Arch Linux (fallback initramfs)" >> /boot/loader/entries/arch-fallback.conf
echo "linux   /vmlinuz-linux" >> /boot/loader/entries/arch-fallback.conf
echo "initrd  /intel-ucode.img" >> /boot/loader/entries/arch-fallback.conf
echo "initrd  /initramfs-linux-fallback.img" >> /boot/loader/entries/arch-fallback.conf
echo 'options root="/dev/sda2" rw' >> /boot/loader/entries/arch-fallback.conf

echo "Boot Loader installed. Please continue to post-installation steps"
# Post-install
pacman -S --noconfirm dosfstools exfatprogs exfat-utils ntfs-3g neovim man-db man-pages texinfo \
                      xf86-video-intel mesa xorg-xserver xorg-xinit xorg-xbacklight xdg-utils xdg-user-dirs \
                      noto-fonts noto-fonts-emoji noto-fonts-extra noto-fonts-cjk ttf-jetbrains-mono
                      
                      
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
echo "Enter Username: "
read username
useradd -m -G wheel -s /bin/bash $username
