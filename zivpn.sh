#!/bin/bash
# ZIVPN UDP Install Script

# Config
ZIVPN_DIR="/opt/zivpn"
ZIVPN_SERVICE="zivpn.service"
USER_CONFIG_FILE="$ZIVPN_DIR/users.conf"
SERVER_IP=$(curl -s ifconfig.me)
UDP_PASSWORD="your_udp_password" # Set your UDP password here
ZIVPN_PORT=51443 # Working port

# Check if root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Installation message
echo -e "\033[1;34m"
echo "***********************************************"
echo "*                                             *"
echo "*   \033[1;31mOPUDP Management Panel Installation\033[0m\033[1;34m   *"
echo "*                                             *"
echo "***********************************************"
echo -e "\033[0m"
echo "This script is provided by OfficialOnePesewa"
echo "Installing OPUDP Management Panel..."
echo "----------------------------------------"

# Install required packages
echo "Installing required packages..."
apt update -y
apt install -y wget curl jq

# Create ZIVPN directory
mkdir -p $ZIVPN_DIR

# Copy script to ZIVPN directory
cp $0 $ZIVPN_DIR/zivpn.sh
chmod +x $ZIVPN_DIR/zivpn.sh

# Create systemd service file
echo "[Unit]
Description=ZIVPN Service
After=network.target

[Service]
Type=simple
ExecStart=/bin/bash $ZIVPN_DIR/zivpn.sh start
Restart=always

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/$ZIVPN_SERVICE

# Reload systemd daemon
systemctl daemon-reload

# Enable ZIVPN service
systemctl enable $ZIVPN_SERVICE

# Start ZIVPN service
systemctl start $ZIVPN_SERVICE

# Set up opudp command
echo "alias opudp='bash $ZIVPN_DIR/zivpn.sh'" >> /etc/bash.bashrc
source /etc/bash.bashrc

echo "OPUDP Management Panel installed successfully!"
echo "Run 'opudp' to access the management panel."
