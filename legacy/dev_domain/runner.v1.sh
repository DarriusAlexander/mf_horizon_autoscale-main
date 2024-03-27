#!/bin/bash

currentYear=$(date +'%Y')
# Install Docker 
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt-cache policy docker-ce
sudo apt install docker-ce -y
# sudo systemctl status docker
sudo usermod -aG docker ubuntu

# Install appliances
sudo aws s3 cp s3://ops-s3-scripts/3rd_party_resources/crowdstrike/crowdstrike_ec2_install.sh ~/crowdstrike_ec2_install.sh
sudo aws s3 cp s3://ops-s3-scripts/3rd_party_resources/alert_logic_ec2_install.sh ~/alert_logic_ec2_install.sh
# This is install in PSA PROD 4
sudo aws s3 cp s3://ops-s3-scripts/3rd_party_resources/crowdstrike/falcon-sensor_6.24.0-12104_amd64.deb ~/falcon-sensor_6.24.0-12104_amd64.deb
sudo aws s3 cp s3://ops-s3-scripts/3rd_party_resources/crowdstrike/falcon-sensor_kernel-5.4.0-1045-aws-ubuntu-20.04.6lts_amd64.deb ~/falcon-sensor_kernel-5.4.0-1045-aws-ubuntu-20.04.6lts_amd64.deb

sudo chmod +x ~/alert_logic_ec2_install.sh
sudo chmod +x ~/crowdstrike_ec2_install.sh

./alert_logic_ec2_install.sh
./crowdstrike_ec2_install.sh

# Get Secrets for GitHub Access
sudo aws s3 cp s3://ops-s3-scripts/certs/git/config ~/.ssh/config
sudo aws s3 cp s3://ops-s3-scripts/certs/git/id_rsa ~/.ssh/id_rsa
sudo aws s3 cp s3://ops-s3-scripts/certs/git/id_rsa.pub ~/.ssh/id_rsa.pub

sudo chmod 600 ~/.ssh/id_rsa
sudo chmod 600 ~/.ssh/id_rsa.pub

ssh -T git
ssh -o StrictHostKeyChecking=no -T git
# sudo aws secretsmanager get-secret-value --secret-id git_rsa  --query SecretString --output text | python3 -c 'import json, sys; print(json.load(sys.stdin)["id_rsa"])' >> ~/.ssh/id_rsa
# sudo aws secretsmanager get-secret-value --secret-id git_rsa  --query SecretString --output text | python3 -c 'import json, sys; print(json.load(sys.stdin)["id_rsa.pub"])' >> ~/.ssh/id_rsa.pub

# Download all the *.conf files
sudo rm /etc/nginx/sites-available/*
sudo rm /etc/nginx/nginx.conf

sudo aws s3 cp s3://ops-s3-scripts/nginx/dev/nginx.conf /etc/nginx/nginx.conf
sudo aws s3 cp s3://ops-s3-scripts/nginx/dev/cac-s3.dev.conf /etc/nginx/conf.d/cac-s3.dev.conf
sudo aws s3 cp s3://ops-s3-scripts/nginx/dev/cac.dev.conf /etc/nginx/conf.d/cac.dev.conf
sudo aws s3 cp s3://ops-s3-scripts/nginx/dev/msa.dev.conf /etc/nginx/conf.d/msa.dev.conf
sudo aws s3 cp s3://ops-s3-scripts/nginx/dev/esa.dev.conf /etc/nginx/conf.d/esa.dev.conf
sudo aws s3 cp s3://ops-s3-scripts/nginx/dev/psa.dev.conf /etc/nginx/conf.d/psa.dev.conf
sudo aws s3 cp s3://ops-s3-scripts/nginx/dev/jsa.dev.conf /etc/nginx/conf.d/jsa.dev.conf
sudo aws s3 cp s3://ops-s3-scripts/nginx/dev/dsa.dev.conf /etc/nginx/conf.d/dsa.dev.conf
sudo aws s3 cp s3://ops-s3-scripts/nginx/dev/dcp.dev.conf /etc/nginx/conf.d/dcp.dev.conf
# sudo mkdir -p /etc/nginx/certs/${currentYear}
sudo mkdir -p /etc/nginx/certs/2023

sudo aws s3 cp s3://ops-s3-scripts/certs/io/2023/marinerfinance.chained.crt /etc/nginx/certs/2023/marinerfinance.chained.crt
sudo aws s3 cp s3://ops-s3-scripts/certs/io/2023/star_marinerfinance.key /etc/nginx/certs/2023/star_marinerfinance.key

sudo chmod 400 /etc/nginx/certs/2023/marinerfinance.chained.crt
sudo chmod 400 /etc/nginx/certs/2023/star_marinerfinance.key

#Download Git repositories: PSA, DSA, JSA, ESA, DCP, DSA
sudo git clone --branch dev git@github.com:marinerfinance/psa.git /var/www/psa.integration.dev.marinerfinance.io
sudo git clone --branch dev git@github.com:marinerfinance/esa.git /var/www/esa.integration.dev.marinerfinance.io
sudo git clone --branch dev git@github.com:marinerfinance/jsa.git /var/www/jsa.integration.dev.marinerfinance.io
sudo git clone --branch dev git@github.com:marinerfinance/dsa.git /var/www/dsa.integration.dev.marinerfinance.io
sudo git clone --branch dev git@github.com:marinerfinance/dcp.git /var/www/dcp.integration.dev.marinerfinance.io

sudo chown -R ubuntu:ubuntu /var/www/*
# Login into AWS Docker Registry 
sudo aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 625524351863.dkr.ecr.us-east-1.amazonaws.com
# sudo touch /etc/nginx/certs/${currentYear}/marinerfinance.chained.crt
sudo curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash 

source .bashrc
nvm install v14.21.3
nvm use v14.21.3
npm i pm2 periodic-cli@1.1.4 nodemon -g


