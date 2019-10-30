## Install VPSx17 masternodes for free for 2 months.Up to 10 VPSx5$ one by one you can with 100$ to last 2 months
The script only tested to work on DigitalOcean VPS.

```Use this link https://m.do.co/c/184552fce5fe ```

to get free credit that will help you set up 10VPSx17masternodes for p2p for 1 month.
You will be asked to insert an payout method.  No money will be taken until the credit that you have will expire. 
You need to destroy the VPS and the account before credit expire so no money to be debited from your account. 


## After account creation follow this steps:
```
Create Droplets
Choose an image -> ubuntu 16.04.6 x64
Choose a plan -> Strandard $5 /mo vps
Choose a datacenter region closer to your home
Select additional options IPv6
Create

Check your e-mail
You got  email with ip user pass for the vps you just created

Use putty (https://the.earth.li/~sgtatham/putty/latest/w32/putty.exe) to login to VPS .
A new black window will start where you need to setup the vps
Login with the user and password you received on e-mail
You will be prompted to change the password so you follow the steps.
Once done copy paste the next lines in order for you to install 17 masternode on that vps
```
```
wget -q -N https://raw.githubusercontent.com/p2pcoinspro/p2p-master/master/p2p_17mn_install_How_to.sh
chmod 777 p2p_17mn_install_How_to.sh
bash p2p_17mn_install_How_to.sh
```
Wait until the script end.
You will need putty to make the final steps because i did not find a way to copy the text from the digitalocean console.
At the end of the script you will receive informations about how to monitor, start, stop and restart the cold wallets.
You can see the same info anytime with the command : ```cat p2p.commands```
Use the command :```cat masternode.conf```
and to copy paste and edit to your masternode.conf file from your pc wallet. 

Now you have 17 cold wallets installed that can hold 17 masternodes .  You just need to prepare the coins, send to masternode addreses and put the txid and output in masternode.conf [TXID 0] location (you need to edit the masternode.conf file). Resterat pc wallet, wait 15 confirmation then start the masternode anytime you want until you fill all the 17 cold wallets.

Use ```p2pinfo``` command to see all cold wallets status

Enjoy 
