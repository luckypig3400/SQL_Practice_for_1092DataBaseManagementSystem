--第二部分、上機考 (總分70)
--說明:『北護學生會』期望製作一套『北護卡儲值系統』，請寫出系統資料庫之T-SQL:
--題目1：請使用T-SQL語法撰寫建立資料庫語法，規格如下：
--1.1 新增資料庫，包含指定資料檔路徑，資料檔需包含(1)主要儲存檔以及(2) log檔 (5分)
use master;
if DB_ID('NTUNHS_PayDB') is not null begin
	drop DATABASE NTUNHS_PayDB;
end

create database NTUNHS_PayDB
on Primary(
	name='NTUNHS_PayDB',
	filename='D:\\MSSQL_DB\\NTUNHS_PayDB.mdf'

)log on(
	name='NTUNHS_PayDB_log',
	FILENAME='D:\\MSSQL_DB\\NTUNHS_PayDB_log.ldf'
);

--題目2：請設計三個資料表，並使用卡號與學號進行跨資料表關聯 (1) 卡片資訊、(2) 個人資料以及 (3)交易紀錄，各項資料限制如下：
--2.1卡片資訊須包含以下欄位: 卡號、UID、餘額、系所、帳戶類型、開通狀態、更新時間日期、異動人 (5分)
use NTUNHS_PayDB;
-- Create a new table called 'CardInfo' in schema 'NTUNHS_PayDB'
-- Drop the table if it already exists
IF OBJECT_ID('NTUNHS_PayDB.CardInfo', 'U') IS NOT NULL
DROP TABLE NTUNHS_PayDB.CardInfo
GO
-- Create the table in the specified schema
CREATE TABLE CardInfo
(
	CardNumber INT NOT NULL PRIMARY KEY, -- primary key column卡號
	UID int NOT NULL,--UID
	Balance int,--餘額
	Department NVARCHAR(60),--系所
	AccType NVARCHAR(30),--帳戶類型
	AccStatus NVARCHAR(30),--開通狀態
	UP_date date,--更新時間日期
	UP_user NVARCHAR(60)--異動人
);
GO

--2.2 個人資料須包含以下欄位: 學號、身份證字號、姓氏、名字、生日、性別、在學狀態、通訊地址、更新時間日期、異動人 (5分)
-- Create a new table called 'PersonalInfo' in schema 'NTUNHS_PayDB'
-- Drop the table if it already exists
IF OBJECT_ID('NTUNHS_PayDB.PersonalInfo', 'U') IS NOT NULL
DROP TABLE NTUNHS_PayDB.PersonalInfo
GO
-- Create the table in the specified schema
CREATE TABLE PersonalInfo
(
	StudentID NVARCHAR(36) not null,--學號
	PersonalID NVARCHAR(36) not null,--身份證字號
	FirstName NVARCHAR(30) not null,--姓氏
	LastName NVARCHAR(30) not null,--名字
	Birthdate date,--生日
	Gender varchar(3),--性別
	SchoolStatus NVARCHAR(60),--在學狀態
	ContactAddress NVARCHAR(60),--通訊地址
	UP_date DATE,--更新時間日期
	UP_user NVARCHAR(36)--異動人
);
GO

--2.3 交易資訊須包含以下欄位: 卡號、交易編號、簽約店家、讀卡機號碼、交易類型、交易內容、更新時間日期、異動人 (5分)
-- Create a new table called 'TransactionLog' in schema 'NTUNHS_PayDB'
-- Drop the table if it already exists
IF OBJECT_ID('NTUNHS_PayDB.TransactionLog', 'U') IS NOT NULL
DROP TABLE NTUNHS_PayDB.TransactionLog
GO
-- Create the table in the specified schema
CREATE TABLE TransactionLog
(
	CardNumber int not null,--卡號
	TransId INT NOT NULL,--交易編號
	CooperateStore NVARCHAR(60),--簽約店家
	CardReaderID int,--讀卡機號碼
	TransType NVARCHAR(30),--交易類型
	TransDetailed NVARCHAR(99),--交易內容
	UP_date DATE,--更新時間日期
	UP_user NVARCHAR(36)--異動人
);
GO

--2.4 在[個人資訊]的[性別]欄位中，設定預設值為'F' (5分)
--2.5 在[個人資訊]資料表中[身份證字號]加入數值不得為空且需唯一的限制條件 (5分)
--2.6 每個資料表要有主鍵(Primary Key)，並用適當的Foreign Key與其他資料表關聯 (5分)

--題目3：使用Insert語法插入資料，規格說明如下:
--3.1 [個人資訊]: 至少有3筆資料；[帳號]: 每人至少要1筆資料 (5分)
--3.2 [交易紀錄] :至少15筆資料，每個帳號須包含至少1筆交易紀錄 (5分)

--題目4：請使用Update語法任意修改 [個人資訊]中的一筆資料，並有異動結果顯示出來，例如:原在學狀態VS 異動後在學狀態或原地址VS 更新後地址 (5分)

--題目5：使用SELECT查詢語法進行跨資料表查詢，並顯示輸出結果。
--5.1 查詢條件為: 「所有非鎖卡的帳號之所有交易結果」。結果需顯示以下欄位: (1)所有[交易紀錄]欄位、(2)卡號、(3) 顯示名稱為 「姓名」，並以"姓氏 + 名字"組合，兩個欄位間使用空白符號間隔 (4) 顯示名稱為「基本資訊」，內容以「學號/生日/性別」格式組合顯示，欄位間使用「/」符號間隔，並顯示輸出結果 (5分)
--5.2 請撰寫複合式SQL語法，使用SELECT INTO與其他語法組合，將上題「不重複的查詢結果」，寫入至一個新增暫存資料表(名稱為#LOCK_CARDS)，並顯示輸出結果 (5分)

--題目6：請將上述題目1-5合併並儲存同一個sql檔(檔名: runMe.sql)將此SQL檔上傳至iLMS作為上機考的答案卷。執行此sql時，中間不得發生錯誤，並將所有題目的結果完成，最後應顯示題目4與題目5的三個輸出結果 (10%)