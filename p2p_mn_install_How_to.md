
Shell script to install a [P2P Masternode](https://p2pcoin.network/) on a Linux server running Ubuntu 16.04. Use it on your own risk.
***

## Installation
```
wget -q -N https://github.com/p2pcoinspro/p2p-master/raw/master/p2p_mn_install.sh
chmod 777 p2p_mn_install.sh
bash p2p_mn_install.sh
```
***

## Desktop wallet setup  

After the MN is up and running, you need to configure the desktop wallet accordingly. Here are the steps:  
1. Open the P2P Desktop Wallet.  
2. Go to RECEIVE and create a New Address: **MN01**  
3. Send **1000** P2P to **MN01**. You need to send all 1000 coins in one single transaction.
4. Wait for 15 confirmations.  
5. Go to **Help -> "Debug Window - Console"**  
6. Type the following command: **masternode outputs**  
7. Go to  **Tools -> "Open Masternode Configuration File"**
8. Add the following entry:
```
Alias Address Privkey TxHash TxIndex
ex : mn01 123.123.123.123:24513 2sEUTVEXpo98wZof3naQBwCMkWCiEXRjQmbMFWist32bFJA5yA2o bbeef4a45772ec4a8a1f6e2c56ae132929efb97c20afcf5b7367a05f16f2c2b8P 0

* Alias: **MN1**
* Address: **VPS_IP:PORT**
* Privkey: **Masternode Private Key**
* TxHash: **First value from Step 6**
* TxIndex:  **Second value from Step 6**
9. Save and close the file.
10. Go to **Masternode Tab**. If you tab is not shown, please enable it from: **Settings - Options - Wallet - Show Masternodes Tab**
11. Click **Update status** to see your node. If it is not shown, close the wallet and start it again. Make sure the wallet is un
12. Select your MN and click **Start Alias** to start it.
13. Alternatively, open **Debug Console** and type:
```
masternode start-alias false MN01
```
***

## Usage:
```
p2p-cli mnsync status
p2p-cli masternode status  
p2p-cli getinfo
```
Also, if you want to check/start/stop **p2p**, run one of the following commands as **root**:

```
systemctl status p2p #To check if p2p service is running  
systemctl start p2p #To start p2p service  
systemctl stop p2p #To stop p2p service  
systemctl is-enabled p2p #To check if p2p service is enabled on boot  
```  
***


