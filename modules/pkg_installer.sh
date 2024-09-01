# check privileges
if [[ $EUID -ne 0 ]]; then
    echo "Error: Run this script with root privileges"
    exit 1
fi

echo "Installing system packages"

packages=(
    "@xfce-desktop-environment"
    "vim"
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
    "qbittorrent"
    "virt-manager"
    "libvirt-client-qemu"
    "libvirt-daemon-qemu"
    "qemu-kvm"
    "light"
    "network-manager-applet"
    "blueman"
    "battray"
    "volumeicon"
    "epapirus-icon-theme"
    "libreoffice"
    "xfce4-genmon-plugin"
)

# for pkg in "${packages[@]}"; do
#     echo "Installing $pkg"
#     dnf install $pkg -y >/dev/null
# done

echo "System packages are successfully installed"

# flatpaks
flatpak_repo="flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo"
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
    "flathub org.gnome.Loupe"
)

for flatpak in "${flatpaks[@]}" ; do
    echo "Installing $flatpak"
    flatpak install flathub --noninteractive $flatpak &>/dev/null
done
