#!/bin/bash

# Enable automatic security updates
sudo apt-get install -y unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades

# Firewall configuration (UFW)
sudo apt-get install -y ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw enable

# Install and configure Fail2Ban
sudo apt-get install -y fail2ban
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo systemctl restart fail2ban

# Enable and configure a strong password policy
sudo apt-get install -y libpam-cracklib
sudo cp /etc/pam.d/common-password /etc/pam.d/common-password.backup
echo "password requisite pam_cracklib.so retry=3 minlen=10 difok=3 ucredit=-1 dcredit=-1 ocredit=-1 lcredit=-1" | sudo tee -a /etc/pam.d/common-password

# Secure SSH configuration
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart ssh

# Set up automatic security checks with Lynis
sudo apt-get install -y lynis
sudo lynis audit system

# Enable automatic updates for other software packages
sudo apt-get install -y unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades

# Install and configure a basic intrusion detection system (AIDE)
sudo apt-get install -y aide
sudo aideinit

# Harden user accounts and privileges
# (Review each change carefully, as it may affect your specific use case)
# Example: Lock accounts without passwords
# sudo passwd -l <username>

# Disable unnecessary services
# (Review each service and disable if not needed)
# Example: sudo systemctl disable <service-name>

# Monitor system logs for suspicious activity
# (Implement log monitoring solutions based on your specific requirements)

# Regularly update and patch the system
sudo apt-get update && sudo apt-get upgrade -y

echo "Hardening complete. Please review each change to ensure it aligns with your requirements."
