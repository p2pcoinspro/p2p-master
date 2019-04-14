Install 10VPSx17 masternodes for free for 2 months.
The script only works on DigitalOcean VPS.

```Use this link https://m.do.co/c/184552fce5fe ```

to make new account and you get credit of 100$ free that will help you set up 10VPSx17masternodes of p2p for 2 months.
You will be asked to insert pay method.  No money will be taken until the credit you have earned will expire. 
You need to destroy the VPS and the account before credit expire so no money to be taken from you. 

```
After account creation follow this steps:
Create Droplets
Choose an image -> ubuntu 16.04.6 x64
Choose a plan -> Strandard $5 /mo vps
Choose a datacenter region closer to your home
Select additional options IPv6
Create
```
```
Check your e-mail
You got  email with ip user pass for the vps you just created

Find and press Access console from the droplets options
A new black window will start where you need to setup the vps
Login with the user and password you receive on e-mail
You will be prompted to change the password so you follow the steps.
Once done copy paste the next lines in order for you to install 17 masternode on that vps
```
```
wget -q -N https://github.com/p2pcoinspro/p2p-master/raw/master/p2p_17mn_install_How_to.sh
chmod 777 p2p_17mn_install_How_to.sh
bash p2p_17mn_install_How_to.sh
```
Wait until the script end.

At the end of the script you will receive informations about how to monitor, start, stop and restart the cold wallets.
The last 17 lines are masternode.conf lines that you need to copy paste and edit in your masternode.conf file from your pc wallet. 
Please  copy all the info so you can access it when you need it.

Now you have 17 cold wallets installed that can hold 17 masternodes .  You just need to prepare the coins, send to masternode addreses and put the txid and output in masternode.conf [TXID 0] location (you need to edit the masternode.conf file). Resterat pc wallet, wait 15 confirmation then start the masternode.

Enjoy 
