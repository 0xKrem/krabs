# KRem's Auto Bootstrap Scripts
- this set of scripts is used to deploy a fully operational linux desktop environnement focused on maximum efficiency and productivity
- this bootstrap script provide modularity and error handling
- it is developped to be run many time without side effects

# Running the script
- use this command from a FRESH AND UPDATED FEDORA machine
```
sudo dnf install git -y && git clone https://github.com/0xKrem/KRABS.git $HOME/KRABS && sudo ./$HOME/KRABS/krabs.sh
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
