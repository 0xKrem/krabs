#!/bin/env bash

function main() {
	# check if running as root
	if [[ $EUID -ne 0 || -z $SUDO_USER ]]; then
		echo "Error: Run this script using sudo"
		exit 1
	fi

	date=$(date +%H%M%S%d)
	local workdir="/tmp/krabs-$date"

	# function prerequisits that checks the distro and internet connection

	importModules
	if [[ $? -ne 0 ]]; then
		echo "Error: Cannot import modules"
		exit 1
	fi

	getPackageLists
	if [[ $? -ne 0 ]]; then
		echo "Error: Cannot get package lists"
		exit 1
	fi
	

	# install packets
	parallelDownload
	sysInstall "$workdir/packages/fedora-xfce"
	flatpakInstall "$workdir/packages/flatpaks"

}

function downloader() {
	dir=$(dirname "$1")
	if [[ ! -d "$dir" ]]; then
		echo "error: $dir is not a directory"
		return 1
	fi
	local file="$1"

	if [[ -z "$2" ]]; then
		echo "error: $2 is empty"
		return 1
	fi
	local url="$2"

	echo "Downloading $name"
	local response=$(curl -s -o "$file" -w "%{http_code}" "$url")

	if [[ "$response" == "404" ]]; then
		echo "Error : download 404"
		return 1
	fi

	echo "Download success"
	return 0
}

function getPackageLists() {

	local baseUrl="https://raw.githubusercontent.com/clementdlg/KRABS/refs/heads/dev/packages"
	# modules
	local packages=(
		"$baseUrl/fedora-xfce"
		"$baseUrl/flatpaks"
	)

	local path="$workdir/packages"
	mkdir -p "$path"

	for list in "${packages[@]}"; do
		local name=$(basename "$list")
		local filePath="$path/$name"

		downloader "$filePath" "$list"
		[[ $? -ne 0 ]] && return 1
	done
	return 0
}

function importModules() {
	local baseUrl="https://raw.githubusercontent.com/clementdlg/KRABS/refs/heads/dev/modules"
	# modules
	local modules=(
		"$baseUrl/pkg_installer.sh"
		# "$baseUrl/lightdm_conf.sh"
		# "$baseUrl/font_installer.sh"
	)

	local path="$workdir/modules"
	mkdir -p "$path"

	for module in "${modules[@]}"; do
		local name=$(basename "$module")
		local filePath="$path/$name"

		downloader "$filePath" "$module"
		[[ $? -ne 0 ]] && return 1

		source "$filePath"
		if [[ $? -ne 0 ]]; then
			echo "Error: Cannot source $filePath"
			return 1
		fi
	done
	return 0
}
main
# user="$SUDO_USER"
# 
# # main paths
# home="/home/$user"
# PWD="$home"
# dotconf="$home/.config"
# theme_dir="/usr/share/themes"
# 
# # other paths
# awesome_session="/usr/share/xsessions/awesome.desktop"
# 
# # links
# dotfiles="https://github.com/clementdlg/dotfiles.git"
# scripts="https://github.com/clementdlg/scripts.git"
# lockscreen_bg="$dotconf/awesome/theme/lockscreen-bg-fhd.png"
# gtk_theme="https://github.com/daniruiz/skeuos-gtk.git"
# font="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/DejaVuSansMono.zip"
# 

# # dotfiles
    # # creating .config if needed
# if [[ ! -d "$dotconf" ]]; then
    # sudo -u $user mkdir $dotconf
# fi
# 
    # # if not empty, backup
# if [[ -n "$(find $dotconf -mindepth 1 -print -quit)" ]]; then
    # sudo -u $user mv $dotconf "$dotconf-$date"
    # sudo -u $user mkdir $dotconf
# fi
    # # clone
# echo "Cloning dotfiles"
# sudo -u $user git clone $dotfiles $dotconf >/dev/null
# 
# 
# # setup lightdm
# bash "$workdir/modules/lightdm_conf.sh" $lockscreen_bg
# 
# # create awesome session
# if [[ ! -f $awesome_session ]]; then
    # echo "[Desktop Entry]
    # Name=awesome
    # Comment=Highly configurable framework window manager
    # TryExec=awesome
    # Exec=awesome
    # Type=Application" > $awesome_session 
# fi
# 
# # symlinks
# if [[ -f "$home/.bashrc" ]];then
    # sudo -u $user mv $home/.bashrc{,-$date} 
# fi
# 
# if [[ -f "$home/.bash_profile" ]];then
    # sudo -u $user mv $home/.bash_profile{,-$date}
# fi
# 
# sudo -u $user ln -s $dotconf/bash/bashrc $home/.bashrc
# sudo -u $user ln -s $dotconf/bash/bash_profile $home/.bash_profile
# sudo -u $user ln -s $dotconf/bash/bash_aliases $home/.bash_aliases
# sudo -u $user ln -s $dotconf/bash/bash_functions $home/.bash_functions
# 
# # configure theme and fonts
# mkdir -p  $workdir/git_theme
# 
# echo "Installing theme"
# git clone --branch master --depth 1 $gtk_theme $workdir/git_theme >/dev/null
# if [[ $? -ne 0 ]]; then
    # echo "Error: Can not clone $gtk_theme"
    # exit 1
# fi
# mv "$workdir/git_theme/themes/Skeuos-Blue-Dark" "$theme_dir"
# 
# # install fonts
# sudo -u $user bash "$workdir/modules/font_installer.sh" "$font"
# 
# # syncthing
# systemctl enable cockpit
# sudo -u $user systemctl --user enable syncthing.service
# 
# # fw
# firewall-cmd --add-service=syncthing --permanent
# firewall-cmd --reload
# 
# xfconf-query -c xfce4-screensaver -p /saver/fullscreen-inhibit -s true

# missing 
# - add user to libvirt qemu groups
# - crontab (shutdown puter)
# - dnf installonly limit 5
# - flatpak overrides (signal, discord, brave)
# - clone script repo
# - dont just clone dotfiles repo, check every files / folder and copy them to .config while renaming old files when conflict
# - refactor script with a functions, text files for packages and create wrapper functions for simple tasks
# - update the bash files placement (create less symlinks)
# - 'wk' check if 
# - run upgrade at the beginning
# - replace vlc by its flatpak
# - replace flameshot (uses qt)
# - replace wireshark (uses qt)
# - no virtu, install in distrobox instead
# sudo dnf install @xfce-desktop --exclude="initial-setup-gui,abrt-desktop,dnfdragora-updater,xfce4-screensaver,xfdesktop,xfwm4-themes,greybird-xfwm4-theme,xfwm4,xfce4-terminal,xfce4-about,xfce4-appfinder"

# reboot
