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
FOR ATTACH;