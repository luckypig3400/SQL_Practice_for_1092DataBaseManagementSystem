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
VALUES	('001', 1, '5000', '010', 'B01', @CURRENT_TS, '0'),
		('002', 2, '3000', '010', 'B01', @CURRENT_TS, '0'),
		('003', 3, '6000', '010', 'B01', @CURRENT_TS, '0');
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
VALUES('1', '001', @CURRENT_TS, 'A01', 'A00', 'I love writing SQL because it makes me happy', @CURRENT_TS, '001');
INSERT INTO Trans
  (AccID, TranID, TranTime, AtmID, TranType, TranNote, UP_DATETIME, UP_USR)
VALUES('1', '002', @CURRENT_TS, 'A01', 'B01', 'I love writing Java because it makes me AAAAAA', @CURRENT_TS, '001');
INSERT INTO Trans
  (AccID, TranID, TranTime, AtmID, TranType, TranNote, UP_DATETIME, UP_USR)
VALUES('1', '003', @CURRENT_TS, 'A01', 'C01', 'B: Good night, Wellcome to Restaurant DATABASE may I help your ?', @CURRENT_TS, '001');
INSERT INTO Trans
  (AccID, TranID, TranTime, AtmID, TranType, TranNote, UP_DATETIME, UP_USR)
VALUES('1', '004', @CURRENT_TS, 'A01', 'C02', 'C: Hi, we have 4 persons and wanna to CREATE a TABLE', @CURRENT_TS, '001');
INSERT INTO Trans
  (AccID, TranID, TranTime, AtmID, TranType, TranNote, UP_DATETIME, UP_USR)
VALUES('1', '005', @CURRENT_TS, 'A01', 'C02', 'B: Sorry, there is no table available now.', @CURRENT_TS, '001');
INSERT INTO Trans
  (AccID, TranID, TranTime, AtmID, TranType, TranNote, UP_DATETIME, UP_USR)
VALUES('1', '006', @CURRENT_TS, 'A01', 'D05', N'C: COW~ DROP a TABLE  (ノ° ロ °)ノ彡┻━┻!.', @CURRENT_TS, '001');
INSERT INTO Trans
  (AccID, TranID, TranTime, AtmID, TranType, TranNote, UP_DATETIME, UP_USR)
VALUES('1', '007', @CURRENT_TS, 'A01', 'D05', N'B: AAA~~Now there is one TABLE available  ┬─┬ノ( º _ ºノ)....', @CURRENT_TS, '001');

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

INSERT INTO ACCOUNT(ID, AccID, Balance, BranchID, AccType, UP_Date, UP_User)
VALUES('006', '6', '3000', '010', 'B01', getdate(), '006');
INSERT INTO Trans(AccID, TranID, TranTime, AtmID, TranType, TranNote, UP_DATETIME, UP_USR)
VALUES('6', '001', getdate(), 'A01', 'A00', '1wow1', getdate(), '006');
INSERT INTO Trans(AccID, TranID, TranTime, AtmID, TranType, TranNote, UP_DATETIME, UP_USR)
VALUES('6', '002', getdate(), 'A01', 'A00', '2wow2', getdate(), '006');
INSERT INTO Trans(AccID, TranID, TranTime, AtmID, TranType, TranNote, UP_DATETIME, UP_USR)
VALUES('6', '003', getdate(), 'A01', 'A00', '3wow3', getdate(), '006');

alter table Trans drop constraint if exists PK__Trans__specified_contraintName;
alter table Trans alter column TranID varchar(36) not null;
--原先定義ID為int先將其資料型態改為varchar才能儲存字元_

declare @newTID int = 1;

declare @accID varchar(10) = '1';
declare @accTID int = 1;
declare @accTotalTrans int = (select COUNT(TranID) from Trans where AccID = @accID);
while @accTID <= @accTotalTrans
begin
	declare @tranTime date = (select TranTime from Trans where TranID = cast(@accTID as varchar) and AccID = @accID);
	--因為TranID的格式從原本的int被改成varchar了，因此在select的條件要轉成varchar才不會出錯
	declare @tIDnewFormat varchar(36) = convert(varchar ,@tranTime ,112) + '_';
	--時間格式convert()代碼查詢:https://dotblogs.com.tw/kevinya/2014/09/05/146474
	--https://stackoverflow.com/questions/889629/how-to-get-a-date-in-yyyy-mm-dd-format-from-a-tsql-datetime-field/889660
	declare @idToMerge varchar(15) = (select RIGHT('000000' + cast(@newTID as varchar), 6));
	--[MS SQL] 產生數字前面補零的固定長度字串:https://felixhuang.pixnet.net/blog/post/26738193
	set @tIDnewFormat = @tIDnewFormat + @idToMerge;
	print(@tIDnewFormat);
	update Trans set TranID = @tIDnewFormat where TranID = cast(@accTID as varchar) and AccID = @accID;
	set @accTID = @accTID + 1;
	set @newTID = @newTID + 1;
end;

set @accID = '6';
set @accTID = 1;
set @accTotalTrans = (select COUNT(TranID) from Trans where AccID = @accID);
while @accTID <= @accTotalTrans
begin
	set @tranTime = (select TranTime from Trans where TranID = cast(@accTID as varchar) and AccID = @accID);
	set @tIDnewFormat = convert(varchar ,@tranTime ,112) + '_';
	set @idToMerge = (select RIGHT('000000' + cast(@newTID as varchar), 6));
	set @tIDnewFormat = @tIDnewFormat + @idToMerge;
	print(@tIDnewFormat);
	update Trans set TranID = @tIDnewFormat where TranID = cast(@accTID as varchar) and AccID = @accID;
	set @accTID = @accTID + 1;
	set @newTID = @newTID + 1;
end;

--2. 新增一個資料表LOG_SEQ，此資料表為記錄每天一共有多少筆log產生，以日期yyyymmdd作為primary key。 Schema規則如下
drop table if exists LOG_SEQ;
CREATE TABLE LOG_SEQ(
  SDATE varchar(8) NOT NULL PRIMARY KEY, -- 當天的log紀錄
  LOG_COUNT varchar(6) NOT NULL --當天一共有多少筆log
) 
-- 2.1 請撰寫SQL Script如果當天第一筆log產生時，且LOG_SEQ無資料時, 新增當天的紀錄，並給予初始化，SDATE數值指定為當天，且LOG_COUNT指定為0 (30)
declare @queryDate date = '2021-05-19';--也可替換為其他日期或getdate()
if (select SDATE from LOG_SEQ where SDATE = CONVERT(varchar, @queryDate,112)) is null
begin
	insert into LOG_SEQ values(CONVERT(varchar, @queryDate,112), '0');
	print('成功建立該日期的Log');
end;

-- 2.2 呈2.1, 若每新增一筆log時，LOG_COUNT自動加1 (10)
--提示: 2使用子查詢(Subquery)中的EXISTS語法
declare @todayTranCount int = (select COUNT(TranID) from Trans where cast(Trans.TranTime as date) = cast(GETDATE() as date));
declare @todayNewTID varchar(6) = cast( (@todayTranCount + 1) as varchar);
declare @trID varchar(36) = convert(varchar, getdate(), 112) + '_' + (select Right('000000' + @todayNewTID, 6));

INSERT INTO Trans (AccID, TranID, TranTime, AtmID, TranType, TranNote, UP_DATETIME, UP_USR)
VALUES('1', @trID, GETDATE(), 'A01', 'D05', N'Cool~\^o^/╰(*°▽°*)╯', GETDATE(), '001');

if (select SDATE from LOG_SEQ where SDATE = CONVERT(varchar, GETDATE(), 112)) is null
begin
	insert into LOG_SEQ values(CONVERT(varchar, GETDATE(),112), @todayNewTID);
end;
else begin
	update LOG_SEQ set LOG_COUNT = @todayNewTID where SDATE = CONVERT(varchar, GETDATE(), 112);
end;

--3. 請整合1與2語法，並且將SDATE以及LOG_COUNT的結果帶入新增[交易紀錄]語法(INSERT)中 (20)
declare @formattedDate varchar(30) = CONVERT(varchar, GETDATE(), 112);
if (select SDATE from LOG_SEQ where SDATE = @formattedDate) is null
begin
	insert into LOG_SEQ values (@formattedDate, '0');
	declare @todayFirstID varchar(36) = @formattedDate + '_' + (select RIGHT('000000'+ '1' ,6));
	--使用者新增資料區域開始
	insert into Trans VALUES('6', @todayFirstID, GETDATE(), 'A03', 'D66', N'QQㄋㄟㄋㄟ好喝到咩噗茶', GETDATE(), '006');
	--使用者新增資料區域結束
	update LOG_SEQ set LOG_COUNT = 1 where SDATE = @formattedDate;
end;
else begin
	declare @newID int = (select LOG_COUNT from LOG_SEQ where SDATE = @formattedDate) + 1;
	declare @id2wrtie varchar(36) = @formattedDate + '_' + (select RIGHT('000000' + cast(@newID as varchar), 6));
	--使用者新增資料區域開始
	insert into Trans VALUES('6', @id2wrtie, GETDATE(), 'D33', 'G05', N'爆爆水果茶', GETDATE(), '006');
	--使用者新增資料區域結束
	update LOG_SEQ set LOG_COUNT = @newID where SDATE = @formattedDate;
end;

go
alter table Customer drop column if exists PWD;
--https://stackoverflow.com/questions/173814/using-alter-to-drop-a-column-if-it-exists-in-mysql/173820
alter table Customer add PWD varbinary(600);
go

update Customer set PWD = HASHBYTES('SHA2_512', 'pwd01912') where ID = '0';
update Customer set PWD = HASHBYTES('SHA2_512', 'pwd0011998') where ID = '001';
update Customer set PWD = HASHBYTES('SHA2_512', 'pwd0021998') where ID = '002';
update Customer set PWD = HASHBYTES('SHA2_512', 'pwd0031998') where ID = '003';
update Customer set PWD = HASHBYTES('SHA2_512', 'pwd0062003') where ID = '006';

use master;--release database BankHW5