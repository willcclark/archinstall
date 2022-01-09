#!/bin/sh
cd $HOME

mkdir -p ~/.local/{share,src}

git clone --separate-git-dir=$HOME/.local/share/dotfiles https://github.com/willcclark/dotfiles.git tmpdotfiles
rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
rm -rf tmpdotfiles

curl -O https://dl.suckless.org/dwm/dwm-6.3.tar.gz
tar xf dwm-6.3.tar.gz -C ~/.local/src/
rm dwm-6.3.tar.gz
mv .local/src/dwm{-6.3,}
sudo make -C ~/.local/src/dwm install

git clone --depth=1 https://github.com/lukesmithxyz/st.git ~/.local/src/st
sudo make -C ~/.local/src/st install

curl -O https://dl.suckless.org/tools/dmenu-5.0.tar.gz
tar xf dmenu-5.0.tar.gz -C ~/.local/src
mv ~/.local/src/dmenu{-5.0,}
sudo make -C ~/.local/src/dmenu install

git clone --depth=1 https://github.com/PandaFoss/baph.git ~/.local/src/baph
sudo make -C ~/.local/src/baph install

baph -inN libxft-bgra-git


mkdir -p ~/dl ~/vids ~/music ~/dox ~/code ~/pix/
alias dots='/usr/bin/git --git-dir=$HOME/.local/share/dotfiles --work-tree=$HOME'
dots config --local status.showUntrackedFiles no

echo "Exiting..."
sleep 1
echo "Please reboot"
exit
