#!/bin/bash

# enable Always On Availability Groups
sudo /opt/mssql/bin/mssql-conf set hadr.hadrenabled 1
sudo systemctl restart mssql-server

set -o allexport
source config.env
set +o allexport



#input for sqlcmd variables
# read -p "Enter SQL Server name: " SERVER
# read -p "Enter SQL Server username: " USER
# read -s -p "Enter SQL Server password: " PASSWORD
# read -s -p "Enter Master Key password: " MASTER_KEY_PASSWORD
# read -s -p "Enter Private Key password for encryption: " PRIVATE_KEY_PASSWORD


# Run sqlcmd with variables
sqlcmd -S "$SERVER" \
       -U "$USER" \
       -P "$PASSWORD" \
       -i script.sql \
       -C \
       -v MASTER_KEY_PASSWORD="$MASTER_KEY_PASSWORD" \
          PRIVATE_KEY_PASSWORD="$PRIVATE_KEY_PASSWORD"

#transfer the certificate files to the secondary server
read -p "Enter secondary server username: " SECONDARY_USER
read -p "Enter secondary server hostname: " SECONDARY_SERVER
scp /var/opt/mssql/data/dbm_certificate.cer $SECONDARY_USER@$SECONDARY_SERVER:~


#create database mirroring endpoint
sqlcmd -S "$SERVER" \
       -U "$USER" \
       -P "$PASSWORD" \
       -i endpoint.sql \
       -C \

#create availability group
read -p "Enter the name of Availabilty group to be created: " AG_NAME
read -p "Enter the hostname of first node: " NODE1
read -p "Enter the hostname of second node: " NODE2


sqlcmd -S "$SERVER" \
       -U "$USER" \
       -P "$PASSWORD" \
       -i ag.sql \
       -C \
       -V AG_NAME="$AG_NAME" \
          NODE1="$NODE1" \
          NODE2="$NODE2"



#add database to availability group
read -p "Enter the name of database to be added to availability group: " DB_NAME
read -p "Enter the name of Availabilty group to add database to: " AG_NAME

sqlcmd -S "$SERVER" \
       -U "$USER" \
       -P "$PASSWORD" \
       -i add-db.sql \
       -C \
       -v AG_NAME="$AG_NAME" \
          DB_NAME="$DB_NAME"




