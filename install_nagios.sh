#!/bin/bash

# youtube : https://www.youtube.com/@linuxnetworkinghelp
# PLEASE SUBSCRIBE

# Install required packages
sudo apt update
sudo apt install -y wget unzip curl openssl build-essential libgd-dev libssl-dev libapache2-mod-php php-gd php apache2

# Download and extract Nagios Core setup files
wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.6.tar.gz
sudo tar -zxvf nagios-4.4.6.tar.gz
cd nagios-4.4.6

# Run Nagios Core configure script
sudo ./configure

# Compile the main program and CGIs
sudo make all

# Make and install group and user
sudo make install-groups-users

# Add www-data directories user to the nagios group
sudo usermod -a -G nagios www-data

# Install Nagios
sudo make install

# Initialize installation configuration scripts
sudo make install-init

# Install and configure permissions on the configs' directory
sudo make install-commandmode

# Install sample config files
sudo make install-config

# Install apache files
sudo make install-webconf

# Enable apache rewrite mode
sudo a2enmod rewrite

# Enable CGI config
sudo a2enmod cgi

# Restart the Apache service
sudo systemctl restart apache2

# Create a user and set the password when prompted
sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users admin

# Download and extract Nagios Plugins
cd ~/
wget https://nagios-plugins.org/download/nagios-plugins-2.3.3.tar.gz
sudo tar -zxvf nagios-plugins-2.3.3.tar.gz
cd nagios-plugins-2.3.3/

# Run the plugin configure script
sudo ./configure --with-nagios-user=nagios --with-nagios-group=nagios

# Compile Nagios Core plugins
sudo make

# Install the plugins
sudo make install

# Verify Nagios Core configuration
sudo /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

# Start the Nagios service
sudo systemctl start nagios

# Enable Nagios service to run at system startup
sudo systemctl enable nagios

echo "Nagios installation and configuration completed successfully."
