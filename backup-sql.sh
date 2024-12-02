#!/bin/bash

# Define variables
CONTAINER_NAME="sql-server" # Replace with your container name if it's different
BACKUP_PATH="/var/opt/mssql/backup.bak"
HOST_BACKUP_PATH="backup.bak"

# Step 1: Back up the database inside the Docker container
echo "Starting database backup..."
docker exec -it $CONTAINER_NAME /opt/mssql-tools18/bin/sqlcmd -C -S localhost -U sa -P $(<../documents/overflow/sql_password.txt)  -Q "BACKUP DATABASE OverflowDB TO DISK = N'$BACKUP_PATH'"

# Check if the backup was successful
if [ $? -eq 0 ]; then
    echo "Backup created successfully inside the container."
else
    echo "Backup failed!"
    exit 1
fi

# Step 2: Copy the backup file from the container to the host machine
echo "Copying backup to host machine..."
docker cp $CONTAINER_NAME:$BACKUP_PATH $HOST_BACKUP_PATH

# Check if the file was copied successfully
if [ $? -eq 0 ]; then
    echo "Backup file copied to host: $HOST_BACKUP_PATH"
else
    echo "Failed to copy the backup file to the host machine!"
    exit 1
fi

echo "Changing file permissions to -rw-r--r--..."
chmod 644 $HOST_BACKUP_PATH

# Check if the chmod was successful
if [ $? -eq 0 ]; then
    echo "File permissions changed successfully."
else
    echo "Failed to change file permissions."
    exit 1
fi