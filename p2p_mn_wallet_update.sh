COIN_TGZ=`curl https://raw.githubusercontent.com/p2pcoinspro/p2p-master/master/p2pdwlink`

TMP_FOLDER=$(mktemp -d)
CONFIG_FILE='p2p.conf'
CONFIGFOLDER='/root/.p2p'
COIN_DAEMON='p2pd'
COIN_CLI='p2p-cli'
COIN_PATH='/usr/local/bin/'
COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
COIN_NAME='p2p'
COIN_PORT=24513
RPC_PORT=24514

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

function download_node() {
  cd $TMP_FOLDER >/dev/null 2>&1
  wget -q $COIN_TGZ
  compile_error
  tar -xvf $COIN_ZIP >/dev/null 2>&1
  compile_error
  #rm $COIN_PATH/p2p*
  cp p2pcoin*/* $COIN_PATH
  cd - >/dev/null 2>&1
  rm -rf $TMP_FOLDER >/dev/null 2>&1
  chmod +x $COIN_PATH$COIN_DAEMON $COIN_PATH$COIN_CLI
}

function compile_error() {
if [ "$?" -gt "0" ];
 then
  echo -e "${RED}Failed to compile $COIN_NAME. Please investigate.${NC}"
  exit 1
fi
}

function wallet_stop() {
  systemctl stop $COIN_NAME.service
  sleep 10
  killall -9 $COIN_DAEMON >/dev/null 2>&1
}

function wallet_start() {
  systemctl start $COIN_NAME.service
}

clear
echo -e "Prepare to download ${GREEN}$COIN_NAME${NC}."
wallet_stop
download_node
wallet_start
sleep 10
p2p-cli getinfo | grep '"version":'
echo -e "${GREEN}If no error and you see the corect wallet version in the lines above then the update is succesufull ${NC}."



