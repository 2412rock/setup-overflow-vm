$containerName = "overflow-sql"
$databaseName = "OverflowDB"
$backupFile = "$env:USERPROFILE\Desktop\overflow.bak"
$containerBackupPath = "/var/opt/mssql/overflow.bak"

# Copy the backup file to the SQL container
docker cp "$backupFile" "$containerName`:$containerBackupPath"

# Restore the database inside the container
docker exec -i $containerName /opt/mssql-tools18/bin/sqlcmd -C -S localhost,1435 -U SA -P "VeryArpeggioPASSWORD5432!!!" -Q @"
RESTORE DATABASE $databaseName
FROM DISK = '$containerBackupPath'
WITH MOVE '$databaseName' TO '/var/opt/mssql/data/OverflowDB.mdf',
     MOVE '${databaseName}_log' TO '/var/opt/mssql/data/OverflowDB_log.ldf',
     RECOVERY;
"@
