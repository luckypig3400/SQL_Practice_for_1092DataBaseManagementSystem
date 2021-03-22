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
--可以把log檔案也附加上去
--LOG ON
--  ( NAME='practiceDB_log',
--    FILENAME =
--        'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\practiceDB_log.ldf'
--)
FOR ATTACH;

--3. 備份資料庫
BACKUP DATABASE practiceDB TO DISK = 'C:\DB_backups\practiceDB.bak';

--4. 還原資料庫
RESTORE DATABASE practiceDB FROM DISK = 'C:\DB_backups\practiceDB.bak';

--5. 新建資料庫與設定參數，包含: 檔案群組(filegroup)以及記錄檔(log)
CREATE DATABASE BANK
ON PRIMARY
  ( NAME='BANK_Primary',
    FILENAME=
       'D:\MSSQL_DB\Bank_Prm.mdf',
    SIZE=4MB,
    MAXSIZE=10MB,
    FILEGROWTH=1MB),
FILEGROUP Bank_FG1
  ( NAME = 'Bank_FG1_Dat1',
    FILENAME =
       'D:\MSSQL_DB\MyDB_FG1_1.ndf',
    SIZE = 1MB,
    MAXSIZE=10MB,
    FILEGROWTH=1MB),
  ( NAME = 'Bank_FG1_Dat2',
    FILENAME =
        'D:\MSSQL_DB\MyDB_FG1_2.ndf',
    SIZE = 1MB,
    MAXSIZE=10MB,
    FILEGROWTH=1MB)
LOG ON
  ( NAME='BANK_log',
    FILENAME =
        'D:\MSSQL_DB\BANK.ldf',
    SIZE=1MB,
    MAXSIZE=10MB,
    FILEGROWTH=1MB);
GO