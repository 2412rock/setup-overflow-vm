$containerName = "overflow-sql"
$databaseName = "OverflowDB"
$backupFile = "$env:USERPROFILE\Desktop\sql.bak"
$containerBackupPath = "/var/opt/mssql/backup.bak"

# Copy the backup file to the SQL container
docker cp "$backupFile" "$containerName:$containerBackupPath"

# Restore the database inside the container
docker exec -i $containerName /opt/mssql-tools18/bin/sqlcmd -C -S localhost -U SA -P "YourStrongPassword" -Q @"
RESTORE DATABASE $databaseName
FROM DISK = '$containerBackupPath'
WITH MOVE '$databaseName' TO '/var/opt/mssql/data/OverflowDB.mdf',
     MOVE '${databaseName}_log' TO '/var/opt/mssql/data/OverflowDB_log.ldf',
     RECOVERY;
"@
