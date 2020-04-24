# Linux_Configuration
My general setup is a tiling window-manager on an existing Desktop-Environment (DE) like KDE or Xfce. I started with i3-wm on top of KDE but couldn't fix the issue of notifications popping up at the center of the screen. I then shifted to BSPWM which needed minimum configuration changes to replace KWin in Plasma.

In KDE Plasma, the environment variable $KDEWM needs to be changed before initialising the DE. It can be done using the instructions given below. 

https://userbase.kde.org/Tutorials/Using_Other_Window_Managers_with_Plasma#Using_Another_Window_Manager_with_Plasma

My current setup is an edited version of the Arco-linux repository config files. It also includes all the settings needed for compton and power-manager.

I have included all the configuration files I used in the past in this repository. Each folder is named accordingly.  

## Suspend-Sedation for Power Saving

I use a systemd-unit file to use the suspend-sedation to hibernate the laptop after a fixed time it has suspended. This makes sure that the battery is not completely drained if the laptop screen is shut, which suspends the machine. 

The systemd file is given in the above repository, which is put in /etc/systemd/system/ and enabled using systemctl. 

Source: https://wiki.debian.org/SystemdSuspendSedation

## List of Applications

- Xfce-power-manager
- Alacritty: Terminal Emulator
- Ranger: CLI file manager
- Neovim and Vim: CLI text editors
- Nautilus: GUI file manager
- Blueman: bluetooth manager
- Joplin: note-taking application
- Dropbox: to sync with cloud
- Compton or Picom: Compositor
- KDE-Connect: share files and notifications with my android device
- Polybar: to make the bar housing the workspaces, systray and sys-information
- BSPWM: Tiling window manager
- Xfce Notification Daemon
- Gnome-screensaver: screen locking tool
- Gedit: Text-editor
- Rofi: application menu
- Pulseeffects: Sound filter and amplifier

