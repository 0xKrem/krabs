# KRem's Auto Bootstrap Scripts
- this set of scripts is used to deploy a fully operational linux desktop environnement focused on maximum efficiency and productivity
- this bootstrap script provide modularity and error handling
- it is developped to be run many time without side effects

# How to deploy
## Getting the ISO
- Get the iso from the official 'Alternative Download page' [here](https://alt.fedoraproject.org/)
- Chose 'Network Installer'

## Install the lastest version of Fedora (current = 41)
- Follow the [official documentation](https://docs.fedoraproject.org/en-US/fedora/f36/install-guide/install/Installing_Using_Anaconda/) for the Anaconda Installer
- **Careful** : At the software selection step, select the first option
- Finish the installation. The number of installed packages should be nearly 400 at this point

## Running the script
- Once you are logged in and you have network connection, run this command

```
curl -s https://raw.githubusercontent.com/clementdlg/KRABS/main/krabs.sh | sudo bash
```

# Major Components
## Awesome
- the Awesome window manager is a dynamic tiling window manager configured in lua and originally forked from suckless's DWM
- it is the major compenent of this build since it provides window management and a ton of shortcuts
## XFCE
- xfce is stripped out to provide only background services like policy kit, lockscreen, multimedia-keys, panel

## Obsidian + Syncthing
- Obsidian is an extensible personal knowledge manager using markdown
- Syncthing is a peer-to-peer file sharing protocol
- together they provide seemless note synchronization on many devices

## Neovim
- neovim is a fork of Vim with a great Lua api, making easier and more reliable to develop a plugin ecosystem
- neovim is my IDE. All coding is done here
