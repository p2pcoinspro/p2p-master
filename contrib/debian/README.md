
Debian
====================
This directory contains files used to package p2pd/p2p-qt
for Debian-based Linux systems. If you compile p2pd/p2p-qt yourself, there are some useful files here.

## p2p: URI support ##


p2p-qt.desktop  (Gnome / Open Desktop)
To install:

	sudo desktop-file-install p2p-qt.desktop
	sudo update-desktop-database

If you build yourself, you will either need to modify the paths in
the .desktop file or copy or symlink your p2pqt binary to `/usr/bin`
and the `../../share/pixmaps/p2p128.png` to `/usr/share/pixmaps`

p2p-qt.protocol (KDE)

