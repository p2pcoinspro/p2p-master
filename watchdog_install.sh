  cat << 'EOF' > /root/watch.dog
#!/bin/bash
user=root
daemon=p2pd
cli_full_path=/usr/local/bin/p2p-cli
  functie_check_start_wallet () {
        status=`ps -ax | grep $daemon | sed '/grep/d' | wc -l`
        #echo $status
        if [ $status -gt 0 ]; then
                echo `date` "$daemon started"
        else
                echo `date` "$daemon stoped" >> watch.dog.log
                killall -9 $daemon
                sleep 10
                systemctl start p2p.service
        fi
}


functie_check_stuck_wallet () {
  timeout 60 $cli_full_path getinfo
  exit_status=$?
  if [[ $exit_status -eq 124 ]]; then
        echo `date` "$daemon stuck" >> watch.dog.log
        killall -9 $daemon
        sleep 10
  fi
}

functie_check_stuck_wallet
functie_check_start_wallet
EOF

chmod 700 /root/watch.dog

crontab -l >> tempcron
echo "*/10 * * * * /root/watch.dog 2>&1" >> tempcron
crontab tempcron >/dev/null 2>&1
rm tempcron
