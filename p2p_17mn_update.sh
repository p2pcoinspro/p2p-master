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
  systemctl stop ${COIN_NAME}_1.service
  systemctl stop ${COIN_NAME}_2.service
  systemctl stop ${COIN_NAME}_3.service
  systemctl stop ${COIN_NAME}_4.service
  systemctl stop ${COIN_NAME}_5.service
  systemctl stop ${COIN_NAME}_6.service
  systemctl stop ${COIN_NAME}_7.service
  systemctl stop ${COIN_NAME}_8.service
  systemctl stop ${COIN_NAME}_9.service
  systemctl stop ${COIN_NAME}_10.service
  systemctl stop ${COIN_NAME}_11.service
  systemctl stop ${COIN_NAME}_12.service
  systemctl stop ${COIN_NAME}_13.service
  systemctl stop ${COIN_NAME}_14.service
  systemctl stop ${COIN_NAME}_15.service
  systemctl stop ${COIN_NAME}_16.service
  systemctl stop ${COIN_NAME}_17.service
  sleep 10
  killall -9 $COIN_DAEMON >/dev/null 2>&1
}

function wallet_start() {
  systemctl start ${COIN_NAME}_1.service
  systemctl start ${COIN_NAME}_2.service
  systemctl start ${COIN_NAME}_3.service
  systemctl start ${COIN_NAME}_4.service
  systemctl start ${COIN_NAME}_5.service
  systemctl start ${COIN_NAME}_6.service
  systemctl start ${COIN_NAME}_7.service
  systemctl start ${COIN_NAME}_8.service
  systemctl start ${COIN_NAME}_9.service
  systemctl start ${COIN_NAME}_10.service
  systemctl start ${COIN_NAME}_11.service
  systemctl start ${COIN_NAME}_12.service
  systemctl start ${COIN_NAME}_13.service
  systemctl start ${COIN_NAME}_14.service
  systemctl start ${COIN_NAME}_15.service
  #systemctl start ${COIN_NAME}_16.service
  #systemctl start ${COIN_NAME}_17.service
}

clear
echo -e "Prepare to download ${GREEN}$COIN_NAME${NC}."
wallet_stop
download_node
wallet_start
sleep 10
#p2pinfo
echo -e "${GREEN}If no error then the update is succesufull ${NC}."
echo -e "${GREEN}Use p2pinfo command to see the status off all. If p2pinfo does  not work then you need to destroy droplet and create another with the new mn17 script installer. ${NC}."
rm p2p_17mn_install_How_to.sh  >/dev/null 2>&1



