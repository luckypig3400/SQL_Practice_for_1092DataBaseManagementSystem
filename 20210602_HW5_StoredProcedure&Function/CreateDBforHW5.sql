use master;

if DB_ID('BankHW5')IS NOT NULL begin
  drop database BankHW5;
end;--sql語法中的begin與end就如同C或JAVA的{}把判斷式成立後要執行的多個程式碼框起來
create database BankHW5
	ON PRIMARY(
		name='BankHW5',
		filename='D:\MSSQL_DB\BankHW5.mdf',
		SIZE=4MB,
		MAXSIZE=12MB,
		FILEGROWTH=1MB
	)
	LOG ON(
		NAME='BankHW5_log',
		FILENAME='D:\MSSQL_DB\BankHW5.ldf',
		SIZE=1MB,
		MAXSIZE=12MB,
		FILEGROWTH=1MB
	);
GO
use BankHW5;
CREATE TABLE Customer
(
  ID int primary key identity(100000,2),
  LName varchar(20),
  FName varchar(20),
  BDate date check(FLOOR(DATEDIFF(DY,BDate,GETDATE())/365.25) >= 18),
  Sex char(1) default 'U',--直接在建立表單時新增預設值
  Address varchar(50),
  City varchar(20),
  Country varchar(50),
  UP_Date datetime,
  UP_User int
);
set identity_insert Customer on;
DECLARE @CURRENT_TS datetimeoffset = GETDATE()
INSERT INTO Customer
		(ID,Lname,FName,BDate,Sex,Address,City,Country,UP_Date,UP_User)
Values
		('0', 'CY', 'Lien', '19120101', 'M', 'Neihu', 'Taipei', 'Taiwan', @CURRENT_TS, '0'),
		('001', 'LJ', 'KUO', '19981002', 'F', 'Neihu', 'Taipei', 'Taiwan', @CURRENT_TS, '0'),
		('002', 'CW', 'Lin', '19981002', 'F', 'Tianmu', 'Taipei', 'Taiwan', @CURRENT_TS, '0'),
		('003', 'DW', 'Wang', '19981002', 'M', 'Beitou', 'Taipei', 'Taiwan', @CURRENT_TS, '0'),
		('006', 'OwO', 'YA', '20030331', 'F', 'Tianmu', 'Taipei', 'Taiwan', @CURRENT_TS, '0');
GO

CREATE TABLE Account
(
  ID int,
  AccID varchar(10) PRIMARY KEY,
  Balance int,
  BranchID int,
  AccType varchar(3),
  UP_Date datetime,
  UP_User int,
  foreign key(ID) references Customer(ID)
);

DECLARE @CURRENT_TS datetimeoffset = GETDATE()
INSERT INTO ACCOUNT
  (ID, AccID, Balance, BranchID, AccType, UP_Date, UP_User)
VALUES('001', '00000001', '5000', '010', 'B01', @CURRENT_TS, '0');
GO

CREATE TABLE Trans
(
  AccID varchar(10) not null,
  TranID int not null,
  TranTime datetime,
  AtmID varchar(3),
  TranType varchar(3),
  TranNote nvarchar(100),
  UP_DATETIME datetime,
  UP_USR int
);
alter table Trans add constraint PK__Trans__specified_contraintName primary key(AccID, TranID);
GO

DECLARE @CURRENT_TS datetimeoffset = GETDATE()
INSERT INTO Trans
  (AccID, TranID, TranTime, AtmID, TranType, TranNote, UP_DATETIME, UP_USR)
VALUES('00000001', '001', @CURRENT_TS, 'A01', 'A00', 'I love writing SQL because it makes me happy', @CURRENT_TS, '001');
INSERT INTO Trans
  (AccID, TranID, TranTime, AtmID, TranType, TranNote, UP_DATETIME, UP_USR)
VALUES('00000001', '002', @CURRENT_TS, 'A01', 'B01', 'I love writing Java because it makes me AAAAAA', @CURRENT_TS, '001');
INSERT INTO Trans
  (AccID, TranID, TranTime, AtmID, TranType, TranNote, UP_DATETIME, UP_USR)
VALUES('00000001', '003', @CURRENT_TS, 'A01', 'C01', 'B: Good night, Wellcome to Restaurant DATABASE may I help your ?', @CURRENT_TS, '001');
INSERT INTO Trans
  (AccID, TranID, TranTime, AtmID, TranType, TranNote, UP_DATETIME, UP_USR)
VALUES('00000001', '004', @CURRENT_TS, 'A01', 'C02', 'C: Hi, we have 4 persons and wanna to CREATE a TABLE', @CURRENT_TS, '001');
INSERT INTO Trans
  (AccID, TranID, TranTime, AtmID, TranType, TranNote, UP_DATETIME, UP_USR)
VALUES('00000001', '005', @CURRENT_TS, 'A01', 'C02', 'B: Sorry, there is no table available now.', @CURRENT_TS, '001');
INSERT INTO Trans
  (AccID, TranID, TranTime, AtmID, TranType, TranNote, UP_DATETIME, UP_USR)
VALUES('00000001', '006', @CURRENT_TS, 'A01', 'D05', N'C: COW~ DROP a TABLE  (ノ° ロ °)ノ彡┻━┻!.', @CURRENT_TS, '001');
INSERT INTO Trans
  (AccID, TranID, TranTime, AtmID, TranType, TranNote, UP_DATETIME, UP_USR)
VALUES('00000001', '007', @CURRENT_TS, 'A01', 'D05', N'B: AAA~~Now there is one TABLE available  ┬─┬ノ( º _ ºノ)....', @CURRENT_TS, '001');

SELECT *
FROM Customer
SELECT *
FROM Account
SELECT *
FROM Trans



use master;
go

alter database BankHW5 
modify file(
	name = 'BankHW5',
	filename = 'D:\MSSQL_DB\BankHW5.mdf',
	size=12MB,
	maxsize=36MB,
	filegrowth=3MB
);
go

use BankHW5;

EXEC sp_helpconstraint @objname = 'Customer';
alter table Customer drop constraint DF__Customer__Sex__25869641;
alter table Customer add constraint DF__Customer__Sex__666 default 'M'for Sex;
alter table Trans add foreign key(AccID)
references Account(AccID);
exec sp_helpconstraint @objname = 'Customer';
alter table Customer drop constraint CK__Customer__BDate__24927208;
alter table Customer add constraint CK__Customer__Country__tw check(Country = 'Taiwan');

alter table Account add constraint DF__Account__UP_Date__useOperationDate
default GETDATE() for UP_Date;
alter table Customer add constraint DF__Customer__UP_Date__useOperationDate
default GETDATE() for UP_Date;
alter table Trans add constraint DF__Trans__UP_DATETIME__useOperationDate
default GETDATE() for UP_DATETIME;

create table BankBranch(
	BranchID int primary key,--分行帳號
	BranchBankName nvarchar(30)
);
select BranchID from Account;
insert into BankBranch(BranchID,BranchBankName) values(10,'北護銀行');

alter table Account add constraint FK__Account__BranchID__123
Foreign Key(BranchID) references BankBranch(BranchID);



use BankHW5;
-- add few more test data for 3.2
INSERT INTO ACCOUNT(ID, AccID, Balance, BranchID, AccType, UP_Date, UP_User)
VALUES('006', '00000006', '3000', '010', 'B01', getdate(), '006');
INSERT INTO Trans(AccID, TranID, TranTime, AtmID, TranType, TranNote, UP_DATETIME, UP_USR)
VALUES('00000006', '001', getdate(), 'A01', 'A00', '1wow1', getdate(), '006');
INSERT INTO Trans(AccID, TranID, TranTime, AtmID, TranType, TranNote, UP_DATETIME, UP_USR)
VALUES('00000006', '002', getdate(), 'A01', 'A00', '2wow2', getdate(), '006');
INSERT INTO Trans(AccID, TranID, TranTime, AtmID, TranType, TranNote, UP_DATETIME, UP_USR)
VALUES('00000006', '003', getdate(), 'A01', 'A00', '3wow3', getdate(), '006');

use master;--release database BankHW5