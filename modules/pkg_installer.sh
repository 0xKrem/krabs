# check privileges
if [[ $EUID -ne 0 ]]; then
    echo "Error: Run this script with root privileges"
    exit 1
fi

echo "Installing system packages"

packages=(
    "@xfce-desktop-environment"
    "vim"
    "git"
    "awesome"
    "tmux"
    "picom"
    "htop"
    "wget"
    "unzip"
    "tar"
    "lightdm"
    "lightdm-gtk"
    "rofi"
    "neovim"
    "flatpak"
    "syncthing"
    "firefox"
    "default-fonts-core-emoji"
    "alacritty"
    "vlc"
    "btop"
    "timeshift"
    "flameshot"
    "thunar"
    "NetworkManager"
    "ripgrep"
    "flameshot"
    "virt-manager"
    "libvirt-client-qemu"
    "libvirt-daemon-qemu"
    "qemu-kvm"
    "network-manager-applet"
    "blueman"
    "epapirus-icon-theme"
    "xfce4-genmon-plugin"
    "distrobox"
    "podman"
    "telnet"
    "ncdu"
    "cargo"
)

 for pkg in "${packages[@]}"; do
     echo "Installing $pkg"
     dnf install $pkg -y >/dev/null

     if [[ $? -ne 0 ]];then
	 echo "Error while trying to install $pkg" >&2
     fi
 done

echo "System packages are successfully installed"

# flatpaks
flatpak_repo="https://dl.flathub.org/repo/flathub.flatpakrepo"
flatpak remote-add --if-not-exists flathub $flatpak_repo &>/dev/null

flatpaks=(
    "com.bitwarden.desktop"
    "com.brave.Browser"
    "com.discordapp.Discord"
    "com.github.johnfactotum.Foliate"
    "com.github.wwmm.easyeffects"
    "com.vscodium.codium"
    "md.obsidian.Obsidian"
    "org.gnome.Evince"
    "org.signal.Signal"
    "org.gnome.Loupe"
    "org.gnome.clocks"
    "org.kde.ark"
    "org.libreoffice.LibreOffice"
    "org.qbittorrent.qBittorrent"
    "com.usebottles.bottles"
    "org.mozilla.Thunderbird"
    "org.wireshark.Wireshark"
    "com.slack.Slack"
)

for flatpak in "${flatpaks[@]}" ; do
    echo "Installing $flatpak"
    flatpak install flathub --noninteractive $flatpak &>/dev/null

    if [[ $? -ne 0 ]];then
	echo "Error while trying to install $flatpak" >&2
    fi
done
