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
echo "export ORACLE_SID=FREE" >>/home/opc/.bashrc
echo "export ORAENV_ASK=NO" >> /home/opc/.bashrc
# echo "export ORACLE_HOME=/home/oracle" >> /home/opc/.bashrc
# echo "export ORACLE_BASE=/home/oracle" >> /home/opc/.bashrc
echo ". /opt/oracle/product/23c/dbhomeFree/bin/oraenv" >> /home/opc/.bashrc




echo "***availaing tnsnames.ora***"

sudo chmod 666 /opt/oracle/product/23c/dbhomeFree/network/admin/tnsnames.ora

sudo cp /opt/oracle/product/23c/dbhomeFree/lib/libclntsh.so /opt/oracle/product/23c/dbhomeFree/instantclient/

echo "***DB INSTALLED***" 




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
exit;
