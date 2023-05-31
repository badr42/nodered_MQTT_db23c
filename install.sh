#!/bin/bash
export DB_PASSWORD=$1

echo "***Installing Dependencies***" 

sudo -s
dnf install -y oraclelinux-developer-release-el8

dnf config-manager --set-enabled ol8_developer 
dnf -y install oracle-database-preinstall-23c

echo "***Downloading DB RPM***" 

wget https://download.oracle.com/otn-pub/otn_software/db-free/oracle-database-free-23c-1.0-1.el8.x86_64.rpm



echo "***Installing DB 23c free***" 

dnf -y localinstall oracle-database-free-23c-1.0-1.el8.x86_64.rpm


#Configure the Database
echo "***Configuring DB***" 

export DB_PASSWORD=Tiger$tr0ng2023
(echo "${DB_PASSWORD}"; echo "${DB_PASSWORD}";) | /etc/init.d/oracle-free-23c configure

echo "***DB INSTALLED***" 


#Install nodered
echo "**Installing NODERED**"



sudo dnf install -y npm
sudo npm install -g --unsafe-perm node-red

echo "**adding firewall rules**"

sudo firewall-cmd --zone=public --add-port=1880/tcp --permanent
sudo firewall-cmd --reload


echo "**Adding mods to NodeRed**"
sudo npm install -g node-red-contrib-oracledb-mod


echo "***availaing tnsnames.ora***"

chmod 666 /opt/oracle/product/23c/dbhomeFree/network/admin/tnsnames.ora



echo " create the service "


sudo mv nodered.service /etc/systemd/system/
sudo systemctl daemon-reload


sudo npm install -g pm2
pm2 start /usr/bin/node-red -- -v


pm2 startup systemd
