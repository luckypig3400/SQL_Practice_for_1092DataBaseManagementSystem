USE master
GO
IF NOT EXISTS (
    SELECT name
FROM sys.databases
WHERE name = N'whoPanda'
)
CREATE DATABASE whoPanda
GO
--使用GO 讓後續的相依程式碼可以正常執行(EX:USE whoPanda;)
USE whoPanda;

CREATE TABLE Member
(
    學號 CHAR(10) PRIMARY KEY,
    系所 CHAR(10),
    身分證字號 CHAR(10) UNIQUE,
    姓氏 CHAR(10) COLLATE Chinese_Taiwan_Stroke_CI_AS,
    名字 CHAR(10) COLLATE Chinese_Taiwan_Stroke_CI_AS,
    生日 CHAR(10),
    性別 CHAR(1) DEFAULT 'F',
    在學狀態 CHAR(10),
    連絡電話 CHAR(10),
    通訊地址 DATETIME
);

CREATE TABLE Payment
(
    卡號 CHAR(10) PRIMARY KEY,
    UID UNIQUEIDENTIFIER DEFAULT NEWID() ROWGUIDCOL,
    餘額 INT,
    付款類型 CHAR(10)
);

CREATE TABLE Product
(
    
);