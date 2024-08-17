# SCOPE :
# - only for fedora
# - only what i already have
# - modular and error handling
# - can be ran multiple time without sideeffects


# exit if a command fails
set -ex

# check if running as root
if [[ $EUID -ne 0 || -z $SUDO_USER ]]; then
    echo "Error: Run this script using sudo"
    exit 1
fi


user="$SUDO_USER"
home="/home/$user"
PWD="$home"
dnf="/etc/dnf/dnf.conf"
dotfiles="https://github.com/0xKrem/dotfiles.git"
dotconf="$home/.config"
theme_dir="/usr/share/themes"
lockscreen_bg="$dotconf/awesome/theme/lockscreen-bg-fhd.png"
gtk_theme="https://github.com/daniruiz/skeuos-gtk.git"
awesome_session="/usr/share/xsessions/awesome.desktop"
date=$(date +%Y%m%d-%M%H)


# edit dnf config
if ! grep 'max_parallel_downloads=20' $dnf; then

    if grep -E 'max_parallel_downloads=[0-9]+$' $dnf; then
	sed -i -E 's/max_parallel_downloads=[0-9]+$/max_parallel_downloads=20/' $dnf
    else
	echo "max_parallel_downloads=20" >> $dnf
    fi
fi


# install packets
./KRABS/modules/pkg_installer.sh


# dotfiles
    # creating .config if needed
if [[ ! -d "$dotconf" ]]; then
    sudo -u $user mkdir $dotconf
fi

    # if not empty, backup
if [[ -n "$(find $dotconf -mindepth 1 -print -quit)" ]]; then
    sudo -u $user mv $dotconf "$dotconf-$date"
    sudo -u $user mkdir $dotconf
fi
    # clone
echo "Cloning dotfiles"
sudo -u $user git clone $dotfiles $dotconf >/dev/null


# setup lightdm
./KRABS/modules/lightdm_conf.sh $lockscreen_bg


# create awesome session
if [[ ! -f $awesome_session ]]; then
    echo "[Desktop Entry]
    Name=awesome
    Comment=Highly configurable framework window manager
    TryExec=awesome
    Exec=awesome
    Type=Application" > $awesome_session 
fi


# symlinks
# TODO: create backup function instead

if [[ -f "$home/.bashrc" ]];then
    sudo -u $user mv $home/.bashrc{,-$date} 
fi

if [[ -f "$home/.bash_profile" ]];then
    sudo -u $user mv $home/.bash_profile{,-$date}
fi

sudo -u $user ln -s $dotconf/bash/bashrc $home/.bashrc
sudo -u $user ln -s $dotconf/bash/bash_profile $home/.bash_profile

# configure theme and fonts
workdir="/tmp/theme"
mkdir $workdir

echo "Installing theme"
git clone --branch master --depth 1 $gtk_theme $workdir >/dev/null
if [[ $? -ne 0 ]]; then
    echo "Error: Can not clone $gtk_theme"
    exit 1
fi
mv "$workdir/themes/Skeuos-Blue-Dark" "$theme_dir"

# install fonts
sudo -u $user bash $home/KRABS/modules/font_installer.sh "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/DejaVuSansMono.zip"

# firewall
    # syncthing
firewall-cmd --add-port=22000/udp --permanent
firewall-cmd --add-port=22000/tcp --permanent

reboot

# missing 
# - better bootstap command using curl
# - disable SELinux
# - flatpaks
# - mozilla user.js
# - syncthing daemon
# later
# - flatpak overrides
# - mounting my ssd as home
# - btrfs snapper
