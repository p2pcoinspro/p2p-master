#Use this commands to update the wallet to the new version.
#Insert them in VPS line by line or all lines at once by selecting all lines , copy  and paste to vps console

rm p2p_mn_wallet_update.sh >/dev/null 2>&1
wget -q -N https://raw.githubusercontent.com/p2pcoinspro/p2p-master/master/p2p_mn_wallet_update.sh
chmod 777 p2p_mn_wallet_update.sh
bash p2p_mn_wallet_update.sh
rm p2p_mn_wallet_update.sh
