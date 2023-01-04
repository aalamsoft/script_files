#!/bin/bash

echo "###############################################"

echo "*************Setting up hostname**********"

echo "###############################################"
sleep 5

hostnamectl set-hostname "k8swn1.pgens.com"

sleep 5

echo "###############################################"

echo "*************Update hostname**********"

echo "###############################################"
sleep 5

cat >>/etc/hosts<<EOF
172.31.4.131   k8smn.pgens.com     k8smasternode
172.31.8.51   k8swn1.pgens.com    k8sworkernode1
172.31.12.5   k8swn2.pgens.com    k8sworkernode2
EOF

echo "###############################################"

echo "******************swapoff**********************"

echo "###############################################"
sleep 5

sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)/#\1/g' /etc/fstab
sleep 5

echo "###############################################"

echo "***********setup kernal modules***************"

echo "###############################################"
sleep 5

sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter
sleep 5

echo "###############################################"

echo "*************setup kernal parameters**********"

echo "###############################################"
sleep 5

tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF


echo "###############################################"

echo "*************Reloding the changes**********"

echo "###############################################"
sleep 5

sysctl --system
sleep 10


echo "###############################################"

echo "*************Install containerd run time**********"

echo "###############################################"
sleep 5

apt-get update
apt install -y curl gnupg gnupg2 lsb-release software-properties-common apt-transport-https ca-certificates
sleep 10


echo "###############################################"

echo "*************enable docker repos**********"

echo "###############################################"
sleep 5

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


##curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
##sleep 10
##add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu (lsb_release -cs) stable"
sleep 20

echo "###############################################"

echo "*************Install containerd**********"

echo "###############################################"
sleep 5

apt update
apt install -y containerd.io
sleep 30

echo "###############################################"

echo "*************configure containerd**********"

echo "###############################################"
sleep 5

containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

echo "###############################################"

echo "*************Restart containerd**********"

echo "###############################################"
sleep 5

sudo systemctl restart containerd
sleep 10

sudo systemctl enable containerd
sleep 5

echo "###############################################"

echo "*************Add repos for k8s**********"

echo "###############################################"
sleep 5

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sleep 10
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sleep 30

echo "###############################################"

echo "*************Install K8s**********"

echo "###############################################"
sleep 5

sudo apt update -y
sudo apt install -y kubelet kubeadm kubectl
sleep 80
sudo apt-mark hold kubelet kubeadm kubectl
sleep 10

echo "###############################################"

echo "*************Installation completed**********"

echo "###############################################"
sleep 5


echo "###############################################"

echo "*************Please add the hostname and check the ping response of each servers**********"

echo "###############################################"
sleep 5