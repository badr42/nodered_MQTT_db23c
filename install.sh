#!/bin/bash
export DB_PASSWORD=$1

echo "***DB Password=*** $DB_PASSWORD"

echo "***Installing Dependencies***" 

sudo yum update -y
sudo dnf install -y oraclelinux-developer-release-el8
sudo dnf config-manager --set-enabled ol8_developer 
sudo dnf -y install oracle-database-preinstall-23c



echo "***Downloading DB RPM***" 
sudo wget https://download.oracle.com/otn-pub/otn_software/db-free/oracle-database-free-23c-1.0-1.el8.x86_64.rpm




echo "***Installing DB 23c free***" 
sudo dnf -y localinstall oracle-database-free-23c-1.0-1.el8.x86_64.rpm


#Configure the Database
echo "***Configuring DB***" 
export DB_PASSWORD=Tiger$tr0ng2023
(echo "${DB_PASSWORD}"; echo "${DB_PASSWORD}";) | sudo /etc/init.d/oracle-free-23c configure

echo "**** set up environment ****"
echo "export ORACLE_SID=FREE" >> ~/.bashrc
echo "export ORAENV_ASK=NO" >> ~/.bashrc
echo ". /opt/oracle/product/23c/dbhomeFree/bin/oraenv" >> ~/.bashrc


echo "***DB INSTALLED***" 





#Install nodered
echo "**Installing NODERED**"
sudo yum remove nodejs -y
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.bashrc
nvm install node

# sudo dnf install -y npm
sudo npm install -g --unsafe-perm node-red


echo "**adding firewall rules**"

sudo firewall-cmd --zone=public --add-port=1880/tcp --permanent
sudo firewall-cmd --reload


echo "**Adding mods to NodeRed**"
sudo npm install -g node-red-contrib-oracledb-mod


echo "***availaing tnsnames.ora***"

chmod 666 /opt/oracle/product/23c/dbhomeFree/network/admin/tnsnames.ora


echo "*** installing instant client**"

npm install oracledb




echo "*** create the service ***"

sudo npm install -g pm2

sleep 15



sudo cp /opt/oracle/product/23c/dbhomeFree/lib/libclntsh.so /opt/oracle/product/23c/dbhomeFree/instantclient/






# create user for nodered on db

echo " **** create user for nodered **** " 

sudo su - oracle 
# **set the environment variables**
export ORACLE_SID=FREE 
export ORAENV_ASK=NO 
. /opt/oracle/product/23c/dbhomeFree/bin/oraenv
cd $ORACLE_HOME/bin

wget https://raw.githubusercontent.com/badr42/nodered_MQTT_db23c/main/createuser.sql

# lsnrctl status
./sqlplus -S / as sysdba @createuser.sql


#start nodered

# pm2 start /usr/local/bin/node-red -- -v
# pm2 startup systemd