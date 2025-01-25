function parallelDownload() {
	local dnf="/etc/dnf/dnf.conf"

	if ! grep 'max_parallel_downloads=20' $dnf &>/dev/null; then
	  if grep -E 'max_parallel_downloads=[0-9]+$' $dnf &>/dev/null; then
		  sed -i -E 's/max_parallel_downloads=[0-9]+$/max_parallel_downloads=20/' $dnf &>/dev/null
	  else
		  echo "max_parallel_downloads=20" >> $dnf
	  fi
	fi
	return 0
}

function sysInstall() {
	local packages="$1"
	if [[ ! -f "$packages" ]]; then
		echo "Error: file $packages does not exist"
		return 1
	fi

	while IFS= read -r pkg; do
		if [[ -z "$pkg" || "$pkg" =~ ^# ]]; then
			continue
		fi
		echo "Installing $pkg"

		dnf install $pkg -y --quiet
		if [[ $? -ne 0 ]];then
			echo "Error while trying to install $pkg" >&2
			return 1
		fi
	done < $packages
	return 0
}

function flatpakInstall() {
	# flatpaks
	local flatpak_repo="https://dl.flathub.org/repo/flathub.flatpakrepo"
	flatpak remote-add --if-not-exists flathub $flatpak_repo &>/dev/null

	echo "flatpak install start"
	local packages="$1"
	if [[ ! -f "$packages" ]]; then
		echo "Error: file $packages does not exist"
		return 1
	fi

	while IFS= read -r pkg; do
		if [[ -z "$pkg" || "$pkg" =~ ^# ]]; then
			continue
		fi
		echo "Installing $pkg"
	
		# installing
		flatpak install flathub --noninteractive $flatpak &>/dev/null

		if [[ $? -ne 0 ]];then
			echo "Error while trying to install $pkg" >&2
			return 1
		fi
	done < $packages
	return 0
}
