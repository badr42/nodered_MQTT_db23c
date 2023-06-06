#!/bin/bash

#Install nodered
echo "**Installing NODERED**"
sudo yum remove nodejs -y
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.bashrc
nvm install node

sudo dnf install -y npm
sudo npm install -g --unsafe-perm node-red


echo "**adding firewall rules**"

sudo firewall-cmd --zone=public --add-port=1880/tcp --permanent
sudo firewall-cmd --zone=public --add-port=1883/tcp --permanent

sudo firewall-cmd --reload



echo "**Adding mods to NodeRed**"
sudo npm install -g -y node-red-contrib-oracledb-mod



echo "*** installing instant client**"

sudo npm install -g -y oracledb



echo "*** create the service ***"

sudo npm install -g pm2

sleep 15



#start nodered

pm2 start /usr/local/bin/node-red -- -v
pm2 startup systemd


echo "*** installing MQTT ***" 
wget https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/installMosquitto.sh
sudo chmod 777 installMosquitto.sh
sudo bash -s installMosquitto.sh

echo "*** Starting the Service ***" 
sudo systemctl start mosquitto
sudo systemctl enable mosquitto


echo "*************** INSTALLATION COMPLETE ***************"


#sudo cp /opt/oracle/product/23c/dbhomeFree/lib/libclntsh.so /opt/oracle/product/23c/dbhomeFree/instantclient/

#https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-the-mosquitto-mqtt-messaging-broker-on-centos-7