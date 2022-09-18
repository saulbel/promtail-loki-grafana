#!/bin/bash
#users
groupadd USERNAME
useradd -m USERNAME -g USERNAME
#software installation
apt update
#docker
apt install apt-transport-https ca-certificates curl gnupg lsb-release -y
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install docker-ce docker-ce-cli containerd.io -y
#docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
#Change docker & docker-compose permissions
usermod -aG docker USERNAME
chown docker:USERNAME /usr/local/bin/docker-compose
#install docker-plugin to collect logs from
docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions