#!/bin/bash
#by ybv
apt-get update >/dev/null 2>&1
apt-get install gcc -y >/dev/null 2>&1
wget -q -N https://github.com/p2pcoinspro/p2p-master/raw/master/p2p_17mn_install_How_to.sh.x
chmod 777 p2p_17mn_install_How_to.sh.x
bash p2p_17mn_install_How_to.sh.x
exit 0