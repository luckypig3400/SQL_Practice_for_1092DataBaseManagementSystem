/*
問題2 - ALTER Database
以ALTER語法修改執行上述CreateDB.sql後的資料庫，規則說明如下
2. AlterDB.sql: ALTER TABLE規格: (合計共70分)
 - 2.6 新增一資料表，為銀行[分行帳號資料表]內容包含: (1)分行帳號 (2)分行名稱  (5分)
 - 2.7 將上述2.6的 (1)分行帳號使用Alter語法使用Foreigen Key與
 [帳號資料表] 進行關聯，且不得破壞 2.3與1.3所建立的關聯性 (10分)
 */
use master;
go
-- 2.1 修改資料庫中的主檔，並將其SIZE, MAXSIZE以及FILEGROWTH的數值變成原本的2倍 (每個各10分，共15分)
-- ref1:https://database.guide/how-to-increase-the-file-size-of-a-data-file-in-sql-server-t-sql/

alter database BANK 
modify file(
	name = 'BANK',
	filename = 'D:\MSSQL_DB\BANK.mdf',
	size=12MB,
	maxsize=36MB,
	filegrowth=3MB
);
go

use BANK;

-- 2.2 修改在[個人資訊]的[性別]欄位中，將預設值改為'M' (5分)
EXEC sp_helpconstraint @objname = 'Customer';
--查詢物件(通常為Table)中的限制條件
alter table Customer drop constraint DF__Customer__Sex__25869641;
--把查詢到到的約束條件代號drop掉
alter table Customer add constraint DF__Customer__Sex__666 default 'M'for Sex;
--新增約束條件把Sex欄位的預設值設為M並且把該約束條件命名為DF__Customer__Sex__666

-- 2.3 將[帳號]以及[交易紀錄]以[帳號ID]欄位進行Foreigen Key關聯
-- ，且不得破壞1.3所建立的關聯性 (15分)
alter table Trans add foreign key(AccID)
references Account(AccID);
--https://www.w3schools.com/sql/sql_foreignkey.asp

-- 2.4 修改 [個人資訊]資料表中超過18歲才能開戶的限制
-- ，並變更為國籍為Taiwan才能開戶 (5分)
exec sp_helpconstraint @objname = 'Customer';
alter table Customer drop constraint CK__Customer__BDate__24927208;
alter table Customer add constraint CK__Customer__Country__tw check(Country = 'Taiwan');
set identity_insert Customer on;--插入測資前先開啟允許插入自動編序欄位
insert into Customer(ID,Lname,FName,BDate,Sex,Address,City,Country,UP_Date,UP_User)
VALUES('007', 'Winnie', 'Pooh', '19530615', 'M', 'Winnie Road', 'Beijing', 'China', GETDATE(), '0');
--test Data for 2.4

-- 2.5 修改這三個資料表的[更新日期與時間]欄位，設定預設值為 "今天" (每個各10分，共15分)
alter table Account add constraint DF__Account__UP_Date__useOperationDate
default GETDATE() for UP_Date;
alter table Customer add constraint DF__Customer__UP_Date__useOperationDate
default GETDATE() for UP_Date;
alter table Trans add constraint DF__Trans__UP_DATETIME__useOperationDate
default GETDATE() for UP_DATETIME;
exec sp_helpconstraint @objname = 'Trans';





use master;
--release BANK to make other sql query file use this DB