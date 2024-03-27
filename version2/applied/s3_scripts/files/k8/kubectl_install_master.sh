#!/bin/bash

# File : kubectl_install_master.sh
# Linux Distro: Ubuntu 22.04 

# update the distro
sudo apt update
sudo apt upgrade -y 


# To enhance Kubernetes performance, disable swap and set essential kernel parameters. Run the following commands on all nodes to disable all swaps:
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter

# Configure the critical kernel parameters for Kubernetes using the following:
sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# reload the changes
sudo sysctl --system

# Install dependencies with the following commands:
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificateso

# enable docker
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# update system
sudo apt update
sudo apt install -y containerd.io

# configure containerd to start using systemd as cgroup:
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

# restart and enable the containerd service:
sudo systemctl restart containerd
sudo systemctl enable containerd

# add Apt Repository for Kubernetes 
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/kubernetes-xenial.gpg
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

# Install Kubectl, Kubeadm, and Kubelet 
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
