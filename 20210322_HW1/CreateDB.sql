/*
##問題1 - CREATE TABLE
修改[隨堂測驗1]產生的資料庫以及所屬的三個資料表 ([帳號], [個人資訊]以及[交易紀錄])語法，
完成以下新建資料表語法，並分別儲存成一個sql執行檔，規格說明如下:

1. CreateDB.sql: CREATE TABLE規格: (合計共80分)
 - 1.1. 新增資料庫，需包含用指定特定資料檔的方式(附加資料庫FOR ATTACH) ，須提供bank.mdf(15分,bank.mdf 15分，合計30分)
  * 提示: 需先將資料庫bank.mdf檔建立起來，再用FOR ATTACH載入MDF檔。bank.mdf 。路徑請指定為 D:\MSSQL_DB\bank.mdf
*/
use master;

if DB_ID('BANK')IS NOT NULL begin
  drop database BANK;
end--sql語法中的begin與end就如同C或JAVA的{}把判斷式成立後要執行的多個程式碼框起來

--以下建立指定路徑儲存及其他參數設定的資料庫
create database BANK
	ON PRIMARY(
		name='BANK',
		filename='D:\MSSQL_DB\BANK.mdf',
		SIZE=4MB,
		MAXSIZE=12MB,
		FILEGROWTH=1MB
	),
	FILEGROUP Bank_FG1(
		NAME='Bank_FG1_Dat1',
		FILENAME='D:\MSSQL_DB\MyDB_FG1_1.ndf',
		SIZE=1MB,
		MAXSIZE=9MB,
		FILEGROWTH=1MB),
		(NAME='Bank_FG1_Dat2',
		FILENAME='D:\MSSQL_DB\MyDB_FG1_2.ndf',
		SIZE=1MB,
		MAXSIZE=9MB,
		FILEGROWTH=1MB
	)
	LOG ON(
		NAME='BANK_log',
		FILENAME='D:\MSSQL_DB\BANK.ldf',
		SIZE=1MB,
		MAXSIZE=12MB,
		FILEGROWTH=1MB
	);

use BANK;

-- 1.2. 每個資料表需建立個別的PRIMARY KEY (每個表各5分，共15分)

-- 新增用戶資料Table: Customer 
CREATE TABLE Customer
(
  ID int primary key identity(100000,2),
  -- 1.6 在[個人資訊]的ID設定資料型態為int,且為PRIMARY KEY，且預設初始值為100000, 當新增資料時，每次數值自動加2 (5分)
  --https://www.w3schools.com/sql/sql_autoincrement.asp
  LName varchar(20),
  FName varchar(20),
  BDate date check(cast(format(getdate(),'yyyyMMdd') as int) - cast(format(BDate,'yyyyMMdd') as int) >= 180000),
  -- 1.4  在 [個人資訊]資料表中加入限制開戶應超過18歲才能開戶(才能建檔) (5分)
  -- solution1:https://dba.stackexchange.com/questions/106898/convert-date-yyyy-mm-dd-to-integer-yyyymm/106901

  Sex char(1) default 'U',--直接在建立表單時新增預設值
  -- 1.5  在[個人資訊]的[性別]欄位中，設定預設值為'U'  (5分)
  Address varchar(50),
  City varchar(20),
  Country varchar(50),
  UP_Date datetime,
  UP_User int
);

set identity_insert Customer on;
--當自動識別欄位需要Insert資料時應該怎麼辦 ?
--https://exfast.me/2016/09/mssql-automatic-identification-field-when-required-insert-when-information-should-be-how-do/

--alter table Customer add Sex char(1) default 'U';
-- 亦可於後續表單建好後再修該表單設定預設值為'U'

DECLARE @CURRENT_TS datetimeoffset = GETDATE()
INSERT INTO Customer
  (ID,Lname,FName,BDate,Sex,Address,City,Country,UP_Date,UP_User)
VALUES('0', 'CY', 'Lien', '19120101', 'M', 'Neihu', 'Taipei', 'Taiwan', @CURRENT_TS, '0');
INSERT INTO Customer
  (ID,Lname,FName,BDate,Sex,Address,City,Country,UP_Date,UP_User)
VALUES('001', 'LJ', 'KUO', '19981002', 'F', 'Neihu', 'Taipei', 'Taiwan', @CURRENT_TS, '0');
INSERT INTO Customer
  (ID,Lname,FName,BDate,Sex,Address,City,Country,UP_Date,UP_User)
VALUES('002', 'CW', 'Lin', '19981002', 'F', 'Tianmu', 'Taipei', 'Taiwan', @CURRENT_TS, '0');
INSERT INTO Customer
  (ID,Lname,FName,BDate,Sex,Address,City,Country,UP_Date,UP_User)
VALUES('003', 'DW', 'Wang', '19981002', 'M', 'Beitou', 'Taipei', 'Taiwan', @CURRENT_TS, '0');
GO

-- 新增銀行帳戶Table: Account 
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
  -- 1.3  將[帳號], [個人資訊]這兩個資料表以[個人帳號ID]欄位進行Foreigen Key 關聯(每個表各10分，共20分)
) ON BANK_FG1;

-- 插入測試資料
DECLARE @CURRENT_TS datetimeoffset = GETDATE()
INSERT INTO ACCOUNT
  (ID, AccID, Balance, BranchID, AccType, UP_Date, UP_User)
VALUES('001', '00000001', '5000', '010', 'B01', @CURRENT_TS, '0');
GO

-- 新增交易紀錄Table: Trans 
CREATE TABLE Trans
(
  AccID varchar(10),
  TranID int,
  TranTime datetime,
  AtmID varchar(3),
  TranType varchar(3),
  TranNote nvarchar(100),
  UP_DATETIME datetime,
  UP_USR int
  foreign key(AccID) references Account(AccID),
  -- 1.3  將[帳號], [個人資訊]這兩個資料表以[個人帳號ID]欄位進行Foreigen Key 關聯(每個表各10分，共20分)
  primary key(AccID, TranID)
) ON BANK_FG1;
GO

-- 插入測試資料
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