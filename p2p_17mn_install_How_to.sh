#!/bin/bash
#by ybv
COIN_TGZ='https://github.com/p2pcoinspro/p2p-master/releases/download/v1.0.1.5/p2pcoin-v1.0.1.5-linux-x32x64.tar.xz'
COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
BLOCKCHAIN="https://github.com/p2pcoinspro/p2p-master/releases/download/v1.0.1.5/blockchain_14.04.19.tar.gz"
BLOCKCHAIN_ZIP=$(echo $BLOCKCHAIN | awk -F'/' '{print $NF}')

TMP_FOLDER=$(mktemp -d)
CONFIG_FILE='p2p.conf'
CONFIGFOLDER='/root/.p2p'
COIN_DAEMON='p2pd'
COIN_CLI='p2p-cli'
COIN_PATH='/usr/local/bin/'
COIN_NAME='p2p'
COIN_PORT=24513
RPC_PORT=24514

NODEIP=$(curl -s4 api.ipify.org)
NODEIPV6=$(curl ip6.seeip.org)

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'


function checks() {
if [[ $(lsb_release -d) != *16.04* ]]; then
  echo -e "${RED}You are not running Ubuntu 16.04. Installation is cancelled.${NC}"
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}$0 must be run as root.${NC}"
   exit 1
fi

if [ -n "$(pidof $COIN_DAEMON)" ] || [ -e "$COIN_DAEMOM" ] ; then
  echo -e "${RED}$COIN_NAME is already installed.${NC}"
  exit 1
fi
}


function prepare_system() {
echo -e "Prepare the system to install ${GREEN}$COIN_NAME${NC} master node."
apt-get update >/dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get update > /dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y -qq upgrade >/dev/null 2>&1
apt install -y software-properties-common >/dev/null 2>&1
echo -e "${GREEN}Adding bitcoin PPA repository"
apt-add-repository -y ppa:bitcoin/bitcoin >/dev/null 2>&1
echo -e "Installing required packages, it may take some time to finish.${NC}"
apt-get update >/dev/null 2>&1
apt-get install libdb4.8-dev libdb4.8++-dev -y >/dev/null 2>&1
apt-get install software-properties-common nano libboost-all-dev libminiupnpc10 htop \
libzmq3-dev libminiupnpc-dev libssl-dev libevent-dev build-essential libtool autotools-dev automake pkg-config \
libboost-all-dev python-virtualenv virtualenv rpl mc htop unzip -y >/dev/null 2>&1
if [ "$?" -gt "0" ];
  then
    echo -e "${RED}Not all required packages were installed properly. Try to install them manually by running the following commands:${NC}\n"
    echo "apt-get update"
    echo "apt -y install software-properties-common"
    echo "apt-add-repository -y ppa:bitcoin/bitcoin"
    echo "apt-get update"
    echo "apt-get install libdb4.8-dev libdb4.8++-dev -y"
    echo "apt-get install software-properties-common nano libboost-all-dev libminiupnpc10 htop \
libzmq3-dev libminiupnpc-dev libssl-dev libevent-dev build-essential libtool autotools-dev automake pkg-config \
libboost-all-dev python-virtualenv virtualenv rpl mc htop unzip -y "
 exit 1
fi
clear
}


function download_node() {
  echo -e "Prepare to download ${GREEN}$COIN_NAME${NC}."
  cd $TMP_FOLDER >/dev/null 2>&1
  wget -q $COIN_TGZ
  compile_error
  wget -q $BLOCKCHAIN
  compile_error
  tar -xvf $COIN_ZIP >/dev/null 2>&1
  compile_error
  tar -xvf $BLOCKCHAIN_ZIP >/dev/null 2>&1
  compile_error
  cp p2pcoin*/* $COIN_PATH
  cd - >/dev/null 2>&1
  #rm -rf $TMP_FOLDER >/dev/null 2>&1
  chmod +x $COIN_PATH$COIN_DAEMON $COIN_PATH$COIN_CLI



  clear
}


function create_config() {
  mkdir $CONFIGFOLDER$1 >/dev/null 2>&1
  RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
  RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $CONFIGFOLDER$1/$CONFIG_FILE
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcport=$RPC_PORT
listen=1
server=1
daemon=1
port=$COIN_PORT
rpcallowip=$2
rpcbind=$2:24514
rpcconnect=$2
bind=$2:24513
EOF
cp $TMP_FOLDER/{blocks,chainstate} $CONFIGFOLDER$1 -R
}

function create_config1() {
  mkdir $CONFIGFOLDER$1 >/dev/null 2>&1
  RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
  RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $CONFIGFOLDER$1/$CONFIG_FILE
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcport=$RPC_PORT
listen=1
server=1
daemon=1
port=$COIN_PORT
rpcallowip=$2
rpcbind=[$2]:24514
rpcconnect=$2
bind=[$2]:24513
EOF
cp $TMP_FOLDER/{blocks,chainstate} $CONFIGFOLDER$1 -R
}

function create_key() {
  $COIN_PATH$COIN_DAEMON -daemon -conf=/root/.p2p_1/p2p.conf -datadir=/root/.p2p_1
  sleep 30
  if [ -z "$(ps axo cmd:100 | grep $COIN_DAEMON)" ]; then
   echo -e "${RED}$COIN_NAME server couldn not start. Check /var/log/syslog for errors.{$NC}"
   exit 1
  fi
  COINKEY_1=$($COIN_PATH$COIN_CLI -conf=/root/.p2p_1/p2p.conf -datadir=/root/.p2p_1 masternode genkey)
  if [ "$?" -gt "0" ];
    then
    echo -e "${RED}Wallet not fully loaded. Let us wait and try again to generate the Private Key${NC}"
    sleep 30
    COINKEY_1=$($COIN_PATH$COIN_CLI -conf=/root/.p2p_1/p2p.conf -datadir=/root/.p2p_1 masternode genkey)
  fi
  COINKEY_2=$($COIN_PATH$COIN_CLI -conf=/root/.p2p_1/p2p.conf -datadir=/root/.p2p_1 masternode genkey)
  COINKEY_3=$($COIN_PATH$COIN_CLI -conf=/root/.p2p_1/p2p.conf -datadir=/root/.p2p_1 masternode genkey)
  COINKEY_4=$($COIN_PATH$COIN_CLI -conf=/root/.p2p_1/p2p.conf -datadir=/root/.p2p_1 masternode genkey)
  COINKEY_5=$($COIN_PATH$COIN_CLI -conf=/root/.p2p_1/p2p.conf -datadir=/root/.p2p_1 masternode genkey)
  COINKEY_6=$($COIN_PATH$COIN_CLI -conf=/root/.p2p_1/p2p.conf -datadir=/root/.p2p_1 masternode genkey)
  COINKEY_7=$($COIN_PATH$COIN_CLI -conf=/root/.p2p_1/p2p.conf -datadir=/root/.p2p_1 masternode genkey)
  COINKEY_8=$($COIN_PATH$COIN_CLI -conf=/root/.p2p_1/p2p.conf -datadir=/root/.p2p_1 masternode genkey)
  COINKEY_9=$($COIN_PATH$COIN_CLI -conf=/root/.p2p_1/p2p.conf -datadir=/root/.p2p_1 masternode genkey)
  COINKEY_10=$($COIN_PATH$COIN_CLI -conf=/root/.p2p_1/p2p.conf -datadir=/root/.p2p_1 masternode genkey)
  COINKEY_11=$($COIN_PATH$COIN_CLI -conf=/root/.p2p_1/p2p.conf -datadir=/root/.p2p_1 masternode genkey)
  COINKEY_12=$($COIN_PATH$COIN_CLI -conf=/root/.p2p_1/p2p.conf -datadir=/root/.p2p_1 masternode genkey)
  COINKEY_13=$($COIN_PATH$COIN_CLI -conf=/root/.p2p_1/p2p.conf -datadir=/root/.p2p_1 masternode genkey)
  COINKEY_14=$($COIN_PATH$COIN_CLI -conf=/root/.p2p_1/p2p.conf -datadir=/root/.p2p_1 masternode genkey)
  COINKEY_15=$($COIN_PATH$COIN_CLI -conf=/root/.p2p_1/p2p.conf -datadir=/root/.p2p_1 masternode genkey)
  COINKEY_16=$($COIN_PATH$COIN_CLI -conf=/root/.p2p_1/p2p.conf -datadir=/root/.p2p_1 masternode genkey)
  COINKEY_17=$($COIN_PATH$COIN_CLI -conf=/root/.p2p_1/p2p.conf -datadir=/root/.p2p_1 masternode genkey)

  $COIN_PATH$COIN_CLI -conf=/root/.p2p_1/p2p.conf -datadir=/root/.p2p_1 stop
  clear
}

function update_config() {
  sed -i 's/daemon=1/daemon=0/' $CONFIGFOLDER$1/$CONFIG_FILE
  local COINKEY="COINKEY$1"
  cat << EOF >> $CONFIGFOLDER$1/$CONFIG_FILE
logintimestamps=1
maxconnections=256
masternode=1
masternodeaddr=$2:$COIN_PORT
masternodeprivkey=${!COINKEY}
EOF
}





function enable_firewall() {
  echo -e "Installing and setting up firewall to allow ingress on port ${GREEN}$COIN_PORT${NC}"
  ufw allow $COIN_PORT/tcp comment "$COIN_NAME MN port" >/dev/null
  ufw allow ssh comment "SSH" >/dev/null 2>&1
  ufw limit ssh/tcp >/dev/null 2>&1
  ufw default allow outgoing >/dev/null 2>&1
  echo "y" | ufw enable >/dev/null 2>&1
}


function get_ip() {
NODEIP=$(curl -s4 api.ipify.org)
sleep 2
NODEIPV6=$(curl ip6.seeip.org)
sleep 2
}


function compile_error() {
if [ "$?" -gt "0" ];
 then
  echo -e "${RED}Failed to compile $COIN_NAME. Please investigate.${NC}"
  exit 1
fi
}

function ram() {

dd if=/dev/zero of=/var/mnode_swap.img bs=1024k count=4000
chmod 0600 /var/mnode_swap.img
mkswap /var/mnode_swap.img
swapon /var/mnode_swap.img
echo '/var/mnode_swap.img none swap sw 0 0' | tee -a /etc/fstab
echo 'vm.swappiness=10' | tee -a /etc/sysctl.conf
echo 'vm.vfs_cache_pressure=50' | tee -a /etc/sysctl.conf
}


function configure_systemd() {

cat << EOF > /etc/systemd/system/$COIN_NAME$1.service
[Unit]
Description=$COIN_NAME$1 service
After=network.target

[Service]
User=root
Group=root

Type=forking
#PIDFile=$CONFIGFOLDER$1/$COIN_NAME.pid

ExecStart=$COIN_PATH$COIN_DAEMON -daemon -conf=$CONFIGFOLDER$1/$CONFIG_FILE -datadir=$CONFIGFOLDER$1
ExecStop=-$COIN_PATH$COIN_CLI -conf=$CONFIGFOLDER$1/$CONFIG_FILE -datadir=$CONFIGFOLDER$1 stop

Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=5

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
     echo -e "${GREEN}Installing $COIN_NAME$1 serivice.....${NC}"
  sleep 3
  systemctl start $COIN_NAME$1.service
  systemctl enable $COIN_NAME$1.service #>/dev/null 2>&1
  sleep 3
  systemctl status $COIN_NAME$1.service >/dev/null 2>&1
  sleep 10
  $COIN_CLI -conf=$CONFIGFOLDER$1/$CONFIG_FILE -datadir=$CONFIGFOLDER$1 getinfo
  sleep 10
  if [[ -z "$(ps axo cmd:100 | egrep $CONFIGFOLDER$1)" ]]; then
    echo -e "${RED}$COIN_NAME$1 is not running${NC}, please investigate. You should start by running the following commands as root:"
    echo -e "${GREEN}systemctl start $COIN_NAME$1.service"
    echo -e "systemctl status $COIN_NAME$1.service"
    echo -e "less /var/log/syslog${NC}"
    exit 1
  fi
}


function configure_ipv6_network() {

cat << EOF > /etc/network/interfaces

# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

source /etc/network/interfaces.d/*


iface eth0 inet6 static
    address ${NODEIPV6::-1}0/64
iface eth0 inet6 static
    address ${NODEIPV6::-1}2/64
iface eth0 inet6 static
    address ${NODEIPV6::-1}3/64
iface eth0 inet6 static
    address ${NODEIPV6::-1}4/64
iface eth0 inet6 static
    address ${NODEIPV6::-1}5/64
iface eth0 inet6 static
    address ${NODEIPV6::-1}6/64
iface eth0 inet6 static
    address ${NODEIPV6::-1}7/64
iface eth0 inet6 static
    address ${NODEIPV6::-1}8/64
iface eth0 inet6 static
    address ${NODEIPV6::-1}9/64
iface eth0 inet6 static
    address ${NODEIPV6::-1}a/64
iface eth0 inet6 static
    address ${NODEIPV6::-1}b/64
iface eth0 inet6 static
    address ${NODEIPV6::-1}c/64
iface eth0 inet6 static
    address ${NODEIPV6::-1}d/64
iface eth0 inet6 static
    address ${NODEIPV6::-1}e/64
iface eth0 inet6 static
    address ${NODEIPV6::-1}f/64
EOF
  systemctl restart networking.service
  sleep 20

}


function important_information() {
clear
 echo -e "================================================================================================================================"
 echo -e "Restart: ${RED}systemctl restart $COIN_NAME[_XX].service${NC}"
 echo -e "Please check ${RED}$COIN_NAME${NC} daemon is running with the following command: ${RED}systemctl status $COIN_NAME[_XX].service${NC}"
 echo -e "Use this commands to check you installed wallets :"
 echo -e "	${RED}$COIN_CLI -conf=${CONFIGFOLDER}_1/$CONFIG_FILE -datadir=${CONFIGFOLDER}_1 getinfo${NC}"
 echo -e "	${RED}$COIN_CLI -conf=${CONFIGFOLDER}_2/$CONFIG_FILE -datadir=${CONFIGFOLDER}_2 getinfo${NC}"
 echo -e "	${RED}$COIN_CLI -conf=${CONFIGFOLDER}_3/$CONFIG_FILE -datadir=${CONFIGFOLDER}_3 getinfo${NC}"
 echo -e "	..."
 echo -e "	${RED}$COIN_CLI -conf=${CONFIGFOLDER}_17/$CONFIG_FILE -datadir=${CONFIGFOLDER}_17 getinfo${NC}"
 echo -e " "
 echo -e "	${RED}$COIN_CLI -conf=${CONFIGFOLDER}_1/$CONFIG_FILE -datadir=${CONFIGFOLDER}_1 masternode status${NC}"
 echo -e "	${RED}$COIN_CLI -conf=${CONFIGFOLDER}_2/$CONFIG_FILE -datadir=${CONFIGFOLDER}_2 masternode status${NC}"
 echo -e "	${RED}$COIN_CLI -conf=${CONFIGFOLDER}_3/$CONFIG_FILE -datadir=${CONFIGFOLDER}_3 masternode status${NC}"
 echo -e "	..."
 echo -e "	${RED}$COIN_CLI -conf=${CONFIGFOLDER}_17/$CONFIG_FILE -datadir=${CONFIGFOLDER}_17 masternode status${NC}"
 echo -e " "
 echo -e "This is your masternode.conf file. Please copy paste to your pc wallet. When you want to start a new masternode just edit the [TXID 0] section then restart the wallet, wait 15 confirmation and start mn"
 echo -e "${GREEN}mn01 $NODEIP:24513 $COINKEY TXID 0${NC}"
 echo -e "${GREEN}mn02 [${NODEIPV6::-1}0]:24513 $COINKEY_2 TXID 0${NC}"
 echo -e "${GREEN}mn03 [${NODEIPV6::-1}1]:24513 $COINKEY_3 TXID 0${NC}"
 echo -e "${GREEN}mn04 [${NODEIPV6::-1}2]:24513 $COINKEY_4 TXID 0${NC}"
 echo -e "${GREEN}mn05 [${NODEIPV6::-1}3]:24513 $COINKEY_5 TXID 0${NC}"
 echo -e "${GREEN}mn06 [${NODEIPV6::-1}4]:24513 $COINKEY_6 TXID 0${NC}"
 echo -e "${GREEN}mn07 [${NODEIPV6::-1}5]:24513 $COINKEY_7 TXID 0${NC}"
 echo -e "${GREEN}mn08 [${NODEIPV6::-1}6]:24513 $COINKEY_8 TXID 0${NC}"
 echo -e "${GREEN}mn09 [${NODEIPV6::-1}7]:24513 $COINKEY_9 TXID 0${NC}"
 echo -e "${GREEN}mn10 [${NODEIPV6::-1}8]:24513 $COINKEY_10 TXID 0${NC}"
 echo -e "${GREEN}mn11 [${NODEIPV6::-1}9]:24513 $COINKEY_11 TXID 0${NC}"
 echo -e "${GREEN}mn12 [${NODEIPV6::-1}a]:24513 $COINKEY_12 TXID 0${NC}"
 echo -e "${GREEN}mn13 [${NODEIPV6::-1}b]:24513 $COINKEY_13 TXID 0${NC}"
 echo -e "${GREEN}mn14 [${NODEIPV6::-1}c]:24513 $COINKEY_14 TXID 0${NC}"
 echo -e "${GREEN}mn15 [${NODEIPV6::-1}d]:24513 $COINKEY_15 TXID 0${NC}"
 echo -e "${GREEN}mn16 [${NODEIPV6::-1}e]:24513 $COINKEY_16 TXID 0${NC}"
 echo -e "${GREEN}mn17 [${NODEIPV6::-1}f]:24513 $COINKEY_17 TXID 0${NC}"
 echo -e "================================================================================================================================"
}

function setup_node() {
  get_ip
  create_config "_1" "$NODEIP"
  create_config1 "_2" "${NODEIPV6::-1}0"
  create_config1 "_3" "${NODEIPV6::-1}1"
  create_config1 "_4" "${NODEIPV6::-1}2"
  create_config1 "_5" "${NODEIPV6::-1}3"
  create_config1 "_6" "${NODEIPV6::-1}4"
  create_config1 "_7" "${NODEIPV6::-1}5"
  create_config1 "_8" "${NODEIPV6::-1}6"
  create_config1 "_9" "${NODEIPV6::-1}7"
  create_config1 "_10" "${NODEIPV6::-1}8"
  create_config1 "_11" "${NODEIPV6::-1}9"
  create_config1 "_12" "${NODEIPV6::-1}a"
  create_config1 "_13" "${NODEIPV6::-1}b"
  create_config1 "_14" "${NODEIPV6::-1}c"
  create_config1 "_15" "${NODEIPV6::-1}d"
  create_config1 "_16" "${NODEIPV6::-1}e"
  create_config1 "_17" "${NODEIPV6::-1}f"

  create_key

  update_config "_1" "$NODEIP"
  update_config "_2" "[${NODEIPV6::-1}0]"
  update_config "_3" "[${NODEIPV6::-1}1]"
  update_config "_4" "[${NODEIPV6::-1}2]"
  update_config "_5" "[${NODEIPV6::-1}3]"
  update_config "_6" "[${NODEIPV6::-1}4]"
  update_config "_7" "[${NODEIPV6::-1}5]"
  update_config "_8" "[${NODEIPV6::-1}6]"
  update_config "_9" "[${NODEIPV6::-1}7]"
  update_config "_10" "[${NODEIPV6::-1}8]"
  update_config "_11" "[${NODEIPV6::-1}9]"
  update_config "_12" "[${NODEIPV6::-1}a]"
  update_config "_13" "[${NODEIPV6::-1}b]"
  update_config "_14" "[${NODEIPV6::-1}c]"
  update_config "_15" "[${NODEIPV6::-1}d]"
  update_config "_16" "[${NODEIPV6::-1}e]"
  update_config "_17" "[${NODEIPV6::-1}f]"

  configure_systemd "_1"
  configure_systemd "_2"
  configure_systemd "_3"
  configure_systemd "_4"
  configure_systemd "_5"
  configure_systemd "_6"
  configure_systemd "_7"
  configure_systemd "_8"
  configure_systemd "_9"
  configure_systemd "_10"
  configure_systemd "_11"
  configure_systemd "_12"
  configure_systemd "_13"
  configure_systemd "_14"
  configure_systemd "_15"
  configure_systemd "_16"
  configure_systemd "_17"

  enable_firewall
  important_information
  rm -rf $TMP_FOLDER >/dev/null 2>&1
}


##### Main #####
clear

checks
ram
#prepare_system
download_node
configure_ipv6_network
setup_node



