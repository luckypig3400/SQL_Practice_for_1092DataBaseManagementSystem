/*
##問題1 - CREATE TABLE
修改[隨堂測驗1]產生的資料庫以及所屬的三個資料表 ([帳號], [個人資訊]以及[交易紀錄])語法，
完成以下新建資料表語法，並分別儲存成一個sql執行檔，規格說明如下:

1. CreateDB.sql: CREATE TABLE規格: (合計共80分)
 - 1.1. 新增資料庫，需包含用指定特定資料檔的方式(附加資料庫FOR ATTACH) ，須提供bank.mdf(15分,bank.mdf 15分，合計30分)
  * 提示: 需先將資料庫bank.mdf檔建立起來，再用FOR ATTACH載入MDF檔。bank.mdf 。路徑請指定為 D:\MSSQL_DB\bank.mdf
 - 1.2. 每個資料表需建立個別的PRIMARY KEY (每個表各5分，共15分)
 - 1.3  將[帳號], [個人資訊]這兩個資料表以[個人帳號ID]欄位進行Foreigen Key 關聯(每個表各10分，共20分)
 - 1.4  在 [個人資訊]資料表中加入限制開戶應超過18歲才能開戶(才能建檔) (5分)
 - 1.5  在[個人資訊]的[性別]欄位中，設定預設值為'U'  (5分)
 - 1.6  在[個人資訊]的ID設定資料型態為int,且為PRIMARY KEY，且預設初始值為100000, 當新增資料時，每次數值自動加2 (5分)
*/
use master;

if DB_ID('BANK')IS NOT NULL begin
	drop database BANK;
end
--sql語法中的begin與end就如同C或JAVA的{}把判斷式成立後要執行的多個程式碼框起來
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

drop table if exists Customer;--SQL Server2016開始支援 刪除已存在的資料
create table Customer
(--在練習中稱為個人資料
	userID char(66) primary key,--個人帳號似乎和銀行帳號式不同的
	--應該是指這個人在這間店的顧客編號
	--客戶編號應為主鍵(如身分證字號不可重複)
	AccID char(69),
	FirstName char(32),
	LastName char(32),
	Birthdate date,
	Gender char(3),
	PostalAddress char(255),
	City char(30),
	Country char(30),
	UpdateDate date,
	ChangedPersonnel char(60),--異動人
);

if OBJECT_ID('Bank')IS NOT NULL begin
	drop table Bank;
end
create table Bank
(
	BankID char(6),
	BankName char(66),
	BankAddress char(255),
	PRIMARY KEY(BankID),
);

if OBJECT_ID('Account')IS NOT NULL begin
	drop table Account;
end
create table Account
(
	BankID char(6),
	AccID char(69),
	Balance int,
	BranchAccID char(60),
	AccType char(30),
	UpdateDate date,
	ChangedPersonnel char(60),--異動人
	cID char(66),--要進行關聯，資料格式與長度必須與要關聯的欄位相同
	--customerID記錄這隻銀行帳戶是誰開的連結到Customer表單
	PRIMARY KEY(AccID),
	foreign key(cID) references Customer(userID),
	Foreign Key(BankID) References Bank(BankID)
);

if OBJECT_ID('TransactionLog')IS NOT NULL begin
	drop table TransactionLog;
end
create table TransactionLog
(
	AccID char(69),
	traID char(60),
	traDate date,
	ATM_ID char(60),
	traType char(32),
	traDetail char(255),
	UpdateDate date,
	ChangedPersonnel char(60),--異動人
	traAccID char(69),--轉帳對象的銀行帳號
	PRIMARY KEY(AccID,traID),
	Foreign Key(AccID) references Account(AccID)
);



--使用修改資料表的語法(alter)，將性別欄為設定限制條件，並新增預設值為U
alter table Customer drop column Gender;--刪除欄位
alter table Customer add Gender char(1);--新增欄位
alter table Customer add constraint Gender DEFAULT 'U' FOR Gender;--在欄位新增約束並加入預設值



insert into Customer
	(userID,AccID,FirstName,LastName,Birthdate,Gender,PostalAddress,City,Country,UpdateDate,ChangedPersonnel)
values
	('yaocheng0822', '082214226', '曜承', '楊', '2000/07/13', 'M', '地址範例1', '台北', '台灣', GETDATE(), '楊曜承');
insert into Customer
	(userID,AccID,FirstName,LastName,Birthdate,Gender,PostalAddress,City,Country,UpdateDate,ChangedPersonnel)
values
	('test1userID', '07876467', '一', '測試', '1990/06/03', 'M', '地址範例2', '台北', '台灣', GETDATE(), '測試一');
insert into Customer
	(userID,AccID,FirstName,LastName,Birthdate,Gender,PostalAddress,City,Country,UpdateDate,ChangedPersonnel)
values
	('conan8967', '896787653', '柯南', '江戶川', '1999/06/9', 'M', 'Tokyo Hot Street 69', '東京', '日本', GETDATE(), '江戶川柯南');

insert into Bank
	(BankID,BankName,BankAddress)
values
	('012', '北護銀行', '台北市北投區明德路365號');
insert into Bank
	(BankID,BankName,BankAddress)
values
	('013', '地球銀行', '地球的每個角落');

insert into Account
	(BankID,AccID,Balance,BranchAccID,AccType,UpdateDate,ChangedPersonnel,cID)
values
	('012', '082214226', 60000, '00333', '活期存款戶', GETDATE(), '楊曜承', 'yaocheng0822');
insert into Account
	(BankID,AccID,Balance,BranchAccID,AccType,UpdateDate,ChangedPersonnel,cID)
values
	('013', '082214226666', 3000000, '00333', '定期存款戶', GETDATE(), '楊曜承', 'yaocheng0822');
insert into Account
	(BankID,AccID,Balance,BranchAccID,AccType,UpdateDate,ChangedPersonnel,cID)
values
	('012', '07876467', 60000, '00412', '活期存款戶', GETDATE(), '測試一', 'test1userID');
insert into Account
	(BankID,AccID,Balance,BranchAccID,AccType,UpdateDate,ChangedPersonnel,cID)
values
	('013', '08435162776', 30000, '00412', '定期存款戶', GETDATE(), '測試一', 'test1userID');
insert into Account
	(BankID,AccID,Balance,BranchAccID,AccType,UpdateDate,ChangedPersonnel,cID)
values
	('013', '896787653', 660000, '00412', '活期存款戶', GETDATE(), '江戶川柯南', 'conan8967');

insert into TransactionLog
	(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values
	('082214226', '1', GETDATE(), '3', '存款', '開戶存款', GETDATE(), '楊曜承');
insert into TransactionLog
	(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values
	('082214226', '2', GETDATE(), '3', '提款', '測試提款', GETDATE(), '楊曜承');
insert into TransactionLog
	(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values
	('082214226', '3', GETDATE(), '3', '存款', '購屋頭款預備金', GETDATE(), '楊曜承');
insert into TransactionLog
	(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values
	('07876467', '1', GETDATE(), '3', '存款', '開戶存款', GETDATE(), '測試一');
insert into TransactionLog
	(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values
	('07876467', '2', GETDATE(), '3', '存款', 'dwfesgtrgtrh', GETDATE(), '測試一');
insert into TransactionLog
	(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values
	('07876467', '3', GETDATE(), '3', '存款', 'etwretrdwfesgtrgtrh', GETDATE(), '測試一');
insert into TransactionLog
	(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values
	('07876467', '4', GETDATE(), '3', '提款', 'hgfhrhgfhytdh', GETDATE(), '測試一');
insert into TransactionLog
	(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values
	('07876467', '5', GETDATE(), '3', '提款', 'yjuyj', GETDATE(), '測試一');
insert into TransactionLog
	(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values
	('07876467', '6', GETDATE(), '6', '提款', 'otho', GETDATE(), '測試一');
insert into TransactionLog
	(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values
	('07876467', '7', GETDATE(), '6', '提款', '???what???', GETDATE(), '測試一');
insert into TransactionLog
	(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values
	('07876467', '8', GETDATE(), '6', '存款', 'QwQ OuO', GETDATE(), '測試一');
insert into TransactionLog
	(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values
	('896787653', '1', GETDATE(), '33', '存款', '開戶存款', GETDATE(), '江戶川柯南');
insert into TransactionLog
	(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values
	('896787653', '2', GETDATE(), '67431', '提款', '偵查工具數件', GETDATE(), '江戶川柯南');
insert into TransactionLog
	(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values
	('896787653', '3', GETDATE(), '69696', '存款', '破案報酬', GETDATE(), '江戶川柯南');
