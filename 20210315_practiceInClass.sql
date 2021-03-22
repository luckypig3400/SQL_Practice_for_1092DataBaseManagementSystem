if DB_ID('NTUNHS_IM')IS NOT NULL begin
	use master;
	drop database NTUNHS_IM;
	create database NTUNHS_IM;
end
--sql語法中的begin與end就如同C或JAVA的{}把判斷式成立後要執行的多個程式碼框起來
--https://stackoverflow.com/questions/36279671/how-to-set-multiple-values-inside-an-if-else-statement
else begin
	create database NTUNHS_IM;
end

use NTUNHS_IM;

drop table if exists Customer; --SQL Server2016開始支援 刪除已存在的資料
create table Customer(--在練習中稱為個人資料
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
create table Bank(
	BankID char(6),
	BankName char(66),
	BankAddress char(255),
	PRIMARY KEY(BankID),
);

if OBJECT_ID('Account')IS NOT NULL begin
	drop table Account;
end
create table Account(
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
create table TransactionLog(
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



insert into Customer(userID,AccID,FirstName,LastName,Birthdate,Gender,PostalAddress,City,Country,UpdateDate,ChangedPersonnel)
values ('yaocheng0822','082214226','曜承','楊','2000/07/13','M','地址範例1','台北','台灣',GETDATE(),'楊曜承');
insert into Customer(userID,AccID,FirstName,LastName,Birthdate,Gender,PostalAddress,City,Country,UpdateDate,ChangedPersonnel)
values ('test1userID','07876467','一','測試','1990/06/03','M','地址範例2','台北','台灣',GETDATE(),'測試一');
insert into Customer(userID,AccID,FirstName,LastName,Birthdate,Gender,PostalAddress,City,Country,UpdateDate,ChangedPersonnel)
values ('conan8967','896787653','柯南','江戶川','1999/06/9','M','Tokyo Hot Street 69','東京','日本',GETDATE(),'江戶川柯南');

insert into Bank(BankID,BankName,BankAddress)
values ('012','北護銀行','台北市北投區明德路365號');
insert into Bank(BankID,BankName,BankAddress)
values ('013','地球銀行','地球的每個角落');

insert into Account(BankID,AccID,Balance,BranchAccID,AccType,UpdateDate,ChangedPersonnel,cID)
values ('012','082214226',60000,'00333','活期存款戶',GETDATE(),'楊曜承','yaocheng0822');
insert into Account(BankID,AccID,Balance,BranchAccID,AccType,UpdateDate,ChangedPersonnel,cID)
values ('013','082214226666',3000000,'00333','定期存款戶',GETDATE(),'楊曜承','yaocheng0822');
insert into Account(BankID,AccID,Balance,BranchAccID,AccType,UpdateDate,ChangedPersonnel,cID)
values ('012','07876467',60000,'00412','活期存款戶',GETDATE(),'測試一','test1userID');
insert into Account(BankID,AccID,Balance,BranchAccID,AccType,UpdateDate,ChangedPersonnel,cID)
values ('013','08435162776',30000,'00412','定期存款戶',GETDATE(),'測試一','test1userID');
insert into Account(BankID,AccID,Balance,BranchAccID,AccType,UpdateDate,ChangedPersonnel,cID)
values ('013','896787653',660000,'00412','活期存款戶',GETDATE(),'江戶川柯南','conan8967');

insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('082214226','1',GETDATE(),'3','存款','開戶存款',GETDATE(),'楊曜承');
insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('082214226','2',GETDATE(),'3','提款','測試提款',GETDATE(),'楊曜承');
insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('082214226','3',GETDATE(),'3','存款','購屋頭款預備金',GETDATE(),'楊曜承');
insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('07876467','1',GETDATE(),'3','存款','開戶存款',GETDATE(),'測試一');
insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('07876467','2',GETDATE(),'3','存款','dwfesgtrgtrh',GETDATE(),'測試一');
insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('07876467','3',GETDATE(),'3','存款','etwretrdwfesgtrgtrh',GETDATE(),'測試一');
insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('07876467','4',GETDATE(),'3','提款','hgfhrhgfhytdh',GETDATE(),'測試一');
insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('07876467','5',GETDATE(),'3','提款','yjuyj',GETDATE(),'測試一');
insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('07876467','6',GETDATE(),'6','提款','otho',GETDATE(),'測試一');
insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('07876467','7',GETDATE(),'6','提款','???what???',GETDATE(),'測試一');
insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('07876467','8',GETDATE(),'6','存款','QwQ OuO',GETDATE(),'測試一');
insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('896787653','1',GETDATE(),'33','存款','開戶存款',GETDATE(),'江戶川柯南');
insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('896787653','2',GETDATE(),'67431','提款','偵查工具數件',GETDATE(),'江戶川柯南');
insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('896787653','3',GETDATE(),'69696','存款','破案報酬',GETDATE(),'江戶川柯南');



--3. 使用查詢(SELECT)語法查詢，某個帳戶的所有交易紀錄，交易紀錄須包含以下欄位 (查詢結果錯誤0分，每個欄位2分，合計14分)- 銀行代號、個人帳號、銀行帳號、交易編號、交易時間、交易類型、交易內容
select B.BankID,C.userID,C.AccID,T.traID,T.traDate,T.traType,T.traDetail 
from TransactionLog As T, Customer as C,Bank as B , Account as A 
where A.AccID = T.AccID and C.AccID = T.AccID and A.BankID = B.BankID;

select * from Account As A, Customer AS C WHERE A.AccID = C.AccID;