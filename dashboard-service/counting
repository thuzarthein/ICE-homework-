

#!/bin/bash
# Send script outputs to logs so you can debug at /var/log/user-data.log
exec > /var/log/user-data.log 2>&1

# 1. Download and extract the application
cd /tmp
curl -LO https://github.com/hashicorp/demo-consul-101/releases/download/v0.0.5/dashboard-service_linux_amd64.zip
apt-get update && apt-get install unzip -y
unzip dashboard-service_linux_amd64.zip

# 2. Create the system user
useradd -m -s /bin/bash dashboard-admin

# 3. Move the binary to the correct home directory and set permissions
mv dashboard-service_linux_amd64 /home/dashboard-admin/
chown dashboard-admin:dashboard-admin /home/dashboard-admin/dashboard-service_linux_amd64
chmod +x /home/dashboard-admin/dashboard-service_linux_amd64

# 4. Create the Systemd service file automatically (No manual 'vi' needed)
cat << 'EOF' > /etc/systemd/system/dashboard.service
[Unit]
Description=HashiCorp demo dashboard-service 
After=network-online.target
Wants=network-online.target
[Service]
Type=simple
User=dashboard-admin
Group=dashboard-admin
Environment=PORT=8888
Environment=COUNTING_SERVICE_URL=http://counting-LB-2339902.us-east-1.elb.amazonaws.com
ExecStart=/home/dashboard-admin/dashboard-service_linux_amd64
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
EOF

# 5. Reload systemd, enable on boot, and start the service
systemctl daemon-reload
systemctl enable dashboard.service
systemctl start dashboard.service