RESTORE DATABASE OverflowDB
FROM DISK = '/var/opt/mssql/backup.bak'
WITH MOVE 'OverflowDB' TO '/var/opt/mssql/data/OverflowDB.mdf',
     MOVE 'OverflowDB_log' TO '/var/opt/mssql/data/OverflowDB_log.ldf',
     RECOVERY;
GO