#!/bin/bash

function lightdmMain() {
	checkArgs "$@"

	local img="$1"
	local img_name="$(basename $img)"
	local img_path="/usr/share/backgrounds/$img_name"

	fInstall "lightdm"
	[[ $? -ne 0 ]] && return 1

	fInstall "lightdm-gtk-greeter"
	[[ $? -ne 0 ]] && return 1

	fInstall "epapirus-icon-theme"
	[[ $? -ne 0 ]] && return 1

	# configure services
	systemctl enable lightdm.service >/dev/null
	[[ $? -ne 0 ]] && return 1

	systemctl set-default graphical.target >/dev/null
	[[ $? -ne 0 ]] && return 1

	# background image
	cp "$img" /usr/share/backgrounds/
	chmod 644 "/usr/share/backgrounds/$img_name"

	writeConfigs
	[[ $? -ne 0 ]] && return 1

	# rename override background
	if [[ -f "/usr/share/backgrounds/xfce/xfce-shapes.svg" ]]; then
		mv /usr/share/backgrounds/xfce/{,_}xfce-shapes.svg
	fi

	return 0
}

function checkArgs() {
	# help
	if [[ ! -n "$1" ]]; then
		echo "Error : you must provide an image
		Example : ./script '/path/to/image.png'"
		return 1
	fi

	# arg checking
	if [[ ! -f "$1" ]]; then
		echo "Error : '$1' invalid image path'"
		return 1
	fi

	# extension checking
	local ext=$(echo "$1" | sed 's/.*\.//')
	if [[ $ext != "png" && $ext != "jpg" ]] ;then
		echo "Error : .$ext file is invalid"
		return 1
	fi
}

function fInstall() {
	if [[ -z "$1" ]]; then
		return 1
	fi

	if ! rpm -q "$1" &>/dev/null; then
		echo "Installing $1"
		dnf install --quiet -assumeyes "$1"
		return $?
	fi

	echo "$1 is already installed"
	return 0
}

function writeConfigs() {
	echo "[Seat:*]
	autologin-user=$user
	autologin-session=xfce
	greeter-session=lightdm-gtk-greeter" > /etc/lightdm/lightdm.conf
	[[ $? -ne 0 ]] && return 1

	echo "[greeter]
	theme-name = Adwaita-dark
	icon-theme-name = ePapirus-Dark
	font-name = Sans 12
	background = $img_path
	clock-format = %H:%M
	indicators = ~host;~spacer;~clock;~spacer;~layout;~separator;~session;~power" > /etc/lightdm/lightdm-gtk-greeter.conf
	return $?
}
