if db_id('practiceDB') is not null begin
	drop database practiceDB;
end
create database practiceDB;
use practiceDB;

--1. 卸離資料庫
use master;--切換到其他資料庫中再執行
EXEC sp_detach_db practiceDB;

--2. 附加資料庫
CREATE DATABASE practiceDB
ON PRIMARY
  ( NAME='practiceDB',
    FILENAME=
       'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\practiceDB.mdf',
    SIZE=4MB,
    MAXSIZE=10MB,
    FILEGROWTH=1MB)
FOR ATTACH;

--3. 備份資料庫
BACKUP DATABASE practiceDB TO DISK = 'C:\DB_backups\practiceDB.bak';

--4. 還原資料庫
RESTORE DATABASE practiceDB FROM DISK = 'C:\DB_backups\practiceDB.bak';