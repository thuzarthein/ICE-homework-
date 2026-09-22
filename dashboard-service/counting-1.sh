#!/bin/bash
# Send script outputs to logs so you can debug at /var/log/user-data.log
exec > /var/log/user-data.log 2>&1

# 1. Download and extract the application
cd /tmp
curl -LO https://github.com/hashicorp/demo-consul-101/releases/download/v0.0.5/counting-service_linux_amd64.zip
apt-get update && apt-get install unzip -y
unzip counting-service_linux_amd64.zip

# 2. Create the system user
useradd -m -s /bin/bash counting-admin

# 3. Move the binary to the correct home directory and set permissions
mv counting-service_linux_amd64 /home/counting-admin/
chown counting-admin:counting-admin /home/counting-admin/counting-service_linux_amd64
chmod +x /home/counting-admin/counting-service_linux_amd64
# 4. Create the Systemd service file automatically (No manual 'vi' needed)
cat << 'EOF' > /etc/systemd/system/counting.service
[Unit]
Description=HashiCorp demo counting-service 
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=counting-admin
Group=counting-admin
Environment=PORT=9003
ExecStart=/home/counting-admin/counting-service_linux_amd64
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
EOF

# 5. Reload systemd, enable on boot, and start the service
systemctl daemon-reload
systemctl enable counting.service
systemctl start counting.service