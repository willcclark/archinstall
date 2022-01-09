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

passwd

pacman -S --noconfirm intel-ucode
bootctl install

echo "default  arch.conf" >> /boot/loader/loader.conf
echo "console-mode max" >> /boot/loader/loader.conf
echo "editor   no" >> /boot/loader/loader.conf

echo "title   Arch Linux" >> /boot/loader/entries/arch.conf
echo "linux   /vmlinuz-linux" >> /boot/loader/entries/arch.conf
echo "initrd  /intel-ucode.img" >> /boot/loader/entries/arch.conf
echo "initrd  /initramfs-linux.img" >> /boot/loader/entries/arch.conf
echo 'options root="$(cat /root-uuid)" rw' >> /boot/loader/entries/arch.conf

echo "title   Arch Linux (fallback initramfs)" >> /boot/loader/entries/arch-fallback.conf
echo "linux   /vmlinuz-linux" >> /boot/loader/entries/arch-fallback.conf
echo "initrd  /intel-ucode.img" >> /boot/loader/entries/arch-fallback.conf
echo "initrd  /initramfs-linux-fallback.img" >> /boot/loader/entries/arch-fallback.conf
echo 'options root="$(cat /root-uuid)" rw' >> /boot/loader/entries/arch-fallback.conf

# Post-install
pacman -S --noconfirm  --needed dosfstools exfatprogs exfat-utils ntfs-3g pipewire-pulse \
                                networkmanager bluez bluez-utils man-db man-pages texinfo \
                                neovim xf86-video-intel mesa xorg-server base-devel \
                                xorg-xsetroot xorg-xinit xorg-xprop xdotool arandr \
                                noto-fonts noto-fonts-emoji ttf-joypixels \
                                noto-fonts-extra noto-fonts-cjk ttf-linux-libertine \
                                brightnessctl fish libnotify unzip zip xdg-utils \
                                xdg-user-dirs ttf-liberation libx11 libxinerama \
                                gnome-keyring polkit-gnome pipewire pipewire-pulse \
                                git neovim arc-gtk-theme papirus-icon-theme \
                                dunst sxiv mpv zathura zathura-pdf-mupdf unclutter \
                                maim rsync slock pulsemixer

systemctl enable NetworkManager bluetooth

sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
echo "Enter Username: "
read username
useradd -m -G wheel -s /bin/fish $username

echo "Boot Loader installed. Continuing to post-installation steps"
su $username -c user_setup
