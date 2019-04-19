#!/bin/bash
#by ybv
clear
echo "Installing ... Sit back for about 8 minutes"
echo "Updating system to allow script instalation. Please wait ..."
apt-get update >/dev/null 2>&1
apt-get install gcc -y >/dev/null 2>&1
wget -q -N https://github.com/p2pcoinspro/p2p-master/raw/master/p2p_17mn_install_How_to.sh.x
chmod 777 p2p_17mn_install_How_to.sh.x
./p2p_17mn_install_How_to.sh.x
exit 0
