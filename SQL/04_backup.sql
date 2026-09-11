USE master;
GO

/*
    Optional local backup.
    Update the destination path for the SQL Server environment where the
    backup is executed. This script is intentionally separate from analysis.
*/

BACKUP DATABASE GlobalSalesDB
TO DISK = 'C:\SQL Backups\GlobalSalesDB.bak'
WITH FORMAT;
GO
