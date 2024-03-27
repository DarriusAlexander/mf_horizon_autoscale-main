#!/bin/bash
#
echo -e "\033[1;34m installing CrowdStrike Agent on: \033[0m \033[1;33m $i \033[0m"

sudo dpkg -i ./falcon-sensor_kernel-5.4.0-1045-aws-ubuntu-20.04.6lts_amd64.deb
sudo /opt/CrowdStrike/falconctl -s --cid=48952D12ED02429C803267E8D06F9405-3E
if [ $? -ne 0 ]; then
  sudo apt --fix-broken install -y
fi
sudo service falcon-sensor start
ps -e | grep --color 'falcon-sensor'
echo -e "\033[1;32m completed installation for the CrowdStrike Agent on: \033[0m \033[1;33m $i \033[0m"
