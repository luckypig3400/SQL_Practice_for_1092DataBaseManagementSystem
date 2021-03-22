if db_id('practiceDB') is not null begin
	drop database practiceDB;
end
create database practiceDB;
use practiceDB;

--1. ������Ʈw
use master;--�������L��Ʈw���A����
EXEC sp_detach_db practiceDB;

--2. ���[��Ʈw
CREATE DATABASE practiceDB
ON PRIMARY
  ( NAME='practiceDB',
    FILENAME=
       'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\practiceDB.mdf',
    SIZE=4MB,
    MAXSIZE=10MB,
    FILEGROWTH=1MB)
--�i�H��log�ɮפ]���[�W�h
--LOG ON
--  ( NAME='practiceDB_log',
--    FILENAME =
--        'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\practiceDB_log.ldf'
--)
FOR ATTACH;

--3. �ƥ���Ʈw
BACKUP DATABASE practiceDB TO DISK = 'C:\DB_backups\practiceDB.bak';

--4. �٭��Ʈw
RESTORE DATABASE practiceDB FROM DISK = 'C:\DB_backups\practiceDB.bak';

--5. �s�ظ�Ʈw�P�]�w�ѼơA�]�t: �ɮ׸s��(filegroup)�H�ΰO����(log)
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