#create the certificate taken from the primary server on the secondary server
read -s -p "Enter the password for the private key to decrypt certificate: " PRIVATE_KEY_PASSWORD
read -s -p "Enter the password for the master key to create certificate: " MASTER_KEY_PASSWORD
read -s -p "Enter SQL Server password: " PASSWORD
read -p "Enter secondary server username: " SECONDARY_USER

sqlcmd -S "$SECONDARY_SERVER" \
       -U "$SECONDARY_USER" \
       -P "$PASSWORD" \
       -i sec_cert.sql \
       -C \
       -v MASTER_KEY_PASSWORD="$MASTER_KEY_PASSWORD" \
          PRIVATE_KEY_PASSWORD="$PRIVATE_KEY_PASSWORD"

#join the secondary server to the availability group
read -p "Enter the name of Availabilty group to join: " AG_NAME

sqlcmd -S "$SECONDARY_SERVER" \
       -U "$SECONDARY_USER" \
       -P "$PASSWORD" \
       -i join.sql \
       -C \
       -v AG_NAME="$AG_NAME"