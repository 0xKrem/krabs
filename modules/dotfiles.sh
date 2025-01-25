#!/bin/bash

function dotfiles() {
	local config="$HOME/.config"
	local dotfiles="https://github.com/clementdlg/dotfiles.git"

	if [[ -d "$config" ]]; then
		cloneDotfiles
		[[ $? -ne 0 ]]; return 1
	else
		mergeDotfiles
		[[ $? -ne 0 ]]; return 1
	fi
	return 0
}
function cloneDotfiles() {
    asUser silent mkdir "$config"
	asUser silent git clone "$dotfiles" "$config"
	return $?
}

function mergeDotfiles() {
	# define place to clone dotfiles
	local path="$workdir/dotfiles"

	asUser silent mkdir -p "$path"
	[[ $? -ne 0 ]]; return 1

	asUser silent git clone "$dotfiles" "$path"
	# not finished

	return 0
}
