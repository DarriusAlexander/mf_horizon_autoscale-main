#!/bin/bash

sudo apt-get update
sudo apt upgrade -y 
wget https://scc.alertlogic.net/software/al-agent_LATEST_amd64.deb
sudo dpkg -i al-agent_LATEST_amd64.deb
sudo /etc/init.d/al-agent start
echo '
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# ALERT LOGIC
*.* @@127.0.0.1:1514;RSYSLOG_FileFormat
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
' >> /etc/rsyslog.conf
sudo systemctl restart syslog
# sudo systemctl status syslog
# sudo /etc/init.d/al-agent status
