#!/usr/bin/env bash

# Install docker and docker compose
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

sudo usermod -aG docker ubuntu

echo '{ "live-restore" : true, "log-opts" : { "max-size" : "10m", "max-file" : "3" } }' | sudo tee /etc/docker/daemon.json
sudo systemctl restart docker

# Install fail2ban
sudo apt install fail2ban -y
sudo echo -e "maxretry = 3\nbantime = 72h" >> /etc/fail2ban/jail.d/defaults-debian.conf
sudo systemctl enable fail2ban.service
sudo systemctl restart fail2ban.service

# Aditional
echo "alias ll=\"ls -alFh\"" >> /home/ubuntu/.bash_aliases
echo "alias la=\"ls -A\"" >> /home/ubuntu/.bash_aliases
echo "alias l=\"ls -CF\"" >> /home/ubuntu/.bash_aliases
echo "alias python=\"python3\"" >> /home/ubuntu/.bash_aliases
echo "alias pip=\"pip3\"" >> /home/ubuntu/.bash_aliases
echo "alias d=\"docker\"" >> /home/ubuntu/.bash_aliases
echo "alias docker-compose=\"docker compose\"" >> /home/ubuntu/.bash_aliases
echo "alias dc=\"docker-compose\"" >> /home/ubuntu/.bash_aliases
echo "alias dcp=\"dc -f docker-compose.production.yml\"" >> /home/ubuntu/.bash_aliases
echo "alias dcpm=\"dcp run --rm django python manage.py\"" >> /home/ubuntu/.bash_aliases
echo "alias ggpull=\"git pull\"" >> /home/ubuntu/.bash_aliases
echo "alias gpull=\"ggpull origin\"" >> /home/ubuntu/.bash_aliases
