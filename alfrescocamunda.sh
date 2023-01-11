#!/bin/bash

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

echo "###############################################"

echo "*************Install containerd**********"

echo "###############################################"
sleep 5

chmod a+r /etc/apt/keyrings/docker.gpg
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sleep 90
apt-get install -y docker-compose
sleep 90


echo "###############################################"

echo "*************downloading and Install alfresco**********"

echo "###############################################"
sleep 5

git clone https://github.com/Alfresco/acs-deployment.git
cd acs-deployment/docker-compose
docker-compose -f community-docker-compose.yml up -d
Sleep 500

echo "###############################################"

echo "*************downloading and Install camunda-8**********"

echo "###############################################"
sleep 5

cd /root/
wget https://github.com/aalamsoft/script_files/raw/main/camunda_8.yaml
docker compose -f camunda_8.yaml up -d
Sleep 500
