#!/bin/bash

# Update system
echo "!- INSTALL PACKAGES -!"
sudo apt update && sudo apt install -y \
    git \
    curl \
    tar \
    samba \
    python3 \
    python3-pip \
    gnupg \
    dirmngr \
    zip \
    ufw

sudo apt-get update -y
sudo apt update -y
sudo apt upgrade -y

# Install fastfetch CLI
echo "!- INSTALLING FASTFETCH -!"
sudo apt-get install curl
# Create directory, download .deb file, and install
mkdir -p fastfetch
cd fastfetch
curl -LO https://github.com/fastfetch-cli/fastfetch/releases/download/2.29.0/fastfetch-linux-aarch64.deb
# Install the dow nloaded .deb package
chmod +x ./fastfetch-linux-aarch64.deb
sudo apt install -y ./fastfetch-linux-aarch64.deb
# Clean up
cd ..
rm -rf fastfetch

# Install Speedtest CLI
echo "!- INSTALL SPEEDTEST -!"
sudo apt-get install curl
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
sudo apt-get install speedtest

# Install Docker and Docker Compose
echo "!- INSTALL DOCKER -!"
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
# Add Docker's official GPG key:
sudo apt-get update -y
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings -y
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo service docker enable
sudo service docker start
sudo groupadd docker
sudo gpasswd -a $USER docker

# Pull the portainer agent inage
sudo docker pull portainer/agent:2.21.4

# Clone first repository, build with Docker Compose, then return to home directory
echo "!- INSTALL TOASTBOT -!"
git clone https://github.com/toastedden/toastbot.git
cd toastbot
sudo docker compose pull
cd ~

# Set up Cloudflare tunnel
echo "!- INSTALL CLOUDFLARED -!"
mkdir ~/cloudflared
cd ~/cloudflared
curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64.deb && sudo dpkg -i cloudflared.deb && sudo cloudflared service install TOKEN
cd ~

# Set aliases
echo "!- SET ALIASES -!"
touch ~/.bashrc
echo "alias plz='sudo'" >> ~/.bashrc
echo "alias doupdate='sudo apt-get update && sudo apt update && sudo apt upgrade -y'" >> ~/.bashrc
echo "alias temp='/usr/bin/vcgencmd measure_temp'" >> ~/.bashrc
source ~/.bashrc

# Set firewall rules
echo "!- SET FIREWALL RULES -!"
sudo ufw allow ssh
sudo ufw allow samba
sudo ufw allow 9001/tcp # portainer agent
sudo ufw allow 3001 # HTTP logs server
sudo ufw delete 5 -y
sudo ufw delete 5 -y
sudo ufw delete 5 -y
sudo ufw delete 5 -y
sudo ufw enable
sudo ufw reload
sudo ufw status

# Set swappiness to 10 to reduce SD card writes
echo "!- SET SWAPPINESS TO 10 -!"
sudo sysctl -w vm.swappiness=10
# Make the change permanent by adding it to /etc/sysctl.conf
grep -q '^vm.swappiness' /etc/sysctl.conf || echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
# Apply the changes
sudo sysctl -p

echo "!- GET FINAL UPDATES -!"
sudo apt-get update -y
sudo apt update -y
sudo apt upgrade -y

fastfetch

# Optional: Remind user to log out and back in for group changes to apply
echo "Setup complete! Log out and back in for Docker group changes to take effect."
# Ask the user if they want to reboot the system
read -p "Would you like to reboot now? (yes/no): " response
# Check the user's response
if [[ "$response" == "yes" || "$response" == "y" ]]; then
    echo "Rebooting the system now..."
    sudo reboot
else
    echo "You can reboot later manually."
    newgrp docker
fi