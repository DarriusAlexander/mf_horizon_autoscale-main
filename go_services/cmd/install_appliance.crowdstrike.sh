#!/bin/bash

# aws ec2 describe-instances --filters "Name=tag:Environment,Values=QA" --query 'Reservations[].Instances[].[PublicIpAddress]'
#
# if falcon agent fails to install b/c of some underpinning dependency. Run this cmd: sudo apt --fix-broken install
Array=(
    #=======    QA     ========
    "34.202.219.151"
    "34.200.154.192"
    "54.85.46.25"
    "3.208.188.138"
    "34.192.111.16"
    "3.219.9.90"
    "3.233.55.30"
    "54.92.173.107"
    #=======    DEV     ========
    "3.220.184.41"
    "34.194.129.201"
    "34.192.9.90"
    "34.206.104.46"
    "34.200.166.110"
    "3.231.97.140"
    #=======  STAGING   ========
    "34.225.197.255"
    "54.210.48.25"
    "34.226.44.172"
    "54.85.11.74"
    "52.202.104.80"
    "18.207.71.134"
    "34.225.223.4"
    #======= PRODUCTION ========
    "52.45.184.8"
    "34.225.234.8"
    "34.226.31.139"
    "52.0.27.34"
    "3.214.127.23"
    "3.212.190.2"
    "3.229.85.209"
    "3.213.137.19"
    "34.204.236.135"
    "34.225.153.255"
    "34.198.201.28"
    "34.201.208.5"
    "34.225.118.10"
)

for i in "${Array[@]}"
do
    # ssh -i 'marinerfinance-us-1-east.pem' ubuntu@<dns-name>

    echo -e "\033[1;34m installing CrowdStrike Agent on: \033[0m \033[1;33m $i \033[0m"
    #scp ~/Downloads/falcon-sensor_5.27.0-9104_amd64.deb $i:~
    # Add path to executable
    # scp $HOME/some_path/*.deb $i:~

    ssh -o "StrictHostKeyChecking no"-i ~/.ssh/marinerfinance-us-east-1.pem ubuntu@$i << EOF
        sudo dpkg -i falcon-sensor_6.24.0-12104_amd64.deb
        sudo /opt/CrowdStrike/falconctl -s --cid=48952D12ED02429C803267E8D06F9405-3E
        sudo service falcon-sensor start
        ps -e | grep --color 'falcon-sensor'
EOF
     echo -e "\033[1;32m completed installation for the CrowdStrike Agent on: \033[0m \033[1;33m $i \033[0m"
done
