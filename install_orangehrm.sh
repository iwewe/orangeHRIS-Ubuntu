#!/bin/bash

# OrangeHRM version
ORANGEHRM_VERSION="5.5"

# MySQL database credentials
DB_NAME="orangehrm"
DB_USER="orangehrm"
DB_PASSWORD="your_database_password"

# Update package lists
sudo apt-get update

# Install required packages
sudo apt-get install -y unzip apache2 mysql-server php libapache2-mod-php php-mysql php-xml php-mbstring

# Download OrangeHRM
wget https://github.com/orangehrm/orangehrm/releases/download/release-${ORANGEHRM_VERSION}/orangehrm-${ORANGEHRM_VERSION}.zip

# Unzip OrangeHRM
unzip orangehrm-${ORANGEHRM_VERSION}.zip -d /var/www/html/

# Configure MySQL database
mysql -u root -p -e "CREATE DATABASE ${DB_NAME};"
mysql -u root -p -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';"
mysql -u root -p -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
mysql -u root -p -e "FLUSH PRIVILEGES;"

# Configure OrangeHRM
cp /var/www/html/orangehrm-${ORANGEHRM_VERSION}/Configurations/OrangeHRM/config-database.php /var/www/html/orangehrm-${ORANGEHRM_VERSION}/Configurations/OrangeHRM/config.php
sed -i "s/'database_name_here'/'${DB_NAME}'/" /var/www/html/orangehrm-${ORANGEHRM_VERSION}/Configurations/OrangeHRM/config.php
sed -i "s/'username_here'/'${DB_USER}'/" /var/www/html/orangehrm-${ORANGEHRM_VERSION}/Configurations/OrangeHRM/config.php
sed -i "s/'password_here'/'${DB_PASSWORD}'/" /var/www/html/orangehrm-${ORANGEHRM_VERSION}/Configurations/OrangeHRM/config.php

# Set permissions
sudo chown -R www-data:www-data /var/www/html/orangehrm-${ORANGEHRM_VERSION}/
sudo chmod -R 755 /var/www/html/orangehrm-${ORANGEHRM_VERSION}/

# Enable Apache modules
sudo a2enmod rewrite
sudo systemctl restart apache2

# Clean up
rm orangehrm-${ORANGEHRM_VERSION}.zip

echo "OrangeHRM version ${ORANGEHRM_VERSION} has been successfully installed. Open your browser and navigate to http://your_server_ip/orangehrm-${ORANGEHRM_VERSION} to complete the installation."
