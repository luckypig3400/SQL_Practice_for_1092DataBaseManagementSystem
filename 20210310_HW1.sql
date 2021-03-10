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
if OBJECT_ID('Account')IS NOT NULL begin
	drop table Account;
end
create table Account(
	BankID char(6),
	AccID char(60),
	Balance int,
	BranchAccID char(60),
	AccType char(30),
	UpdateDate date,
	ChangedPersonnel char(60),--異動人
	PRIMARY KEY(AccID)
);

if OBJECT_ID('Customer')IS NOT NULL begin
	drop table Customer;
end
create table Customer(
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
	PRIMARY KEY(AccID)
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
	PRIMARY KEY(AccID,traID)
);

if OBJECT_ID('Bank')IS NOT NULL begin
	drop table Bank;
end
create table Bank(
	BankID char(6),
	BankName char(66),
	BankAddress char(255),
	PRIMARY KEY(BankID)
);


--使用修改資料表的語法(alter)，將性別欄為設定限制條件，並新增預設值為U
alter table Customer drop column Gender;--刪除欄位
alter table Customer add Gender char(1);--新增欄位
alter table Customer add constraint Gender DEFAULT 'U' FOR Gender;--在欄位新增約束並加入預設值

insert into Account(BankID,AccID,Balance,BranchAccID,AccType,UpdateDate,ChangedPersonnel)
values ('012','082214226',60000,'00333','活期存款戶',GETDATE(),'楊曜承');
insert into Account(BankID,AccID,Balance,BranchAccID,AccType,UpdateDate,ChangedPersonnel)
values ('013','082214226666',3000000,'00333','定期存款戶',GETDATE(),'楊曜承');
insert into Account(BankID,AccID,Balance,BranchAccID,AccType,UpdateDate,ChangedPersonnel)
values ('012','07876467',60000,'00412','活期存款戶',GETDATE(),'測試一');
insert into Account(BankID,AccID,Balance,BranchAccID,AccType,UpdateDate,ChangedPersonnel)
values ('013','08435162776',30000,'00412','定期存款戶',GETDATE(),'測試一');
insert into Account(BankID,AccID,Balance,BranchAccID,AccType,UpdateDate,ChangedPersonnel)
values ('013','896787653',660000,'00412','活期存款戶',GETDATE(),'江戶川柯南');

insert into Customer(AccID,FirstName,LastName,Birthdate,Gender,PostalAddress,City,Country,UpdateDate,ChangedPersonnel)
values ('082214226','曜承','楊','2000/07/13','M','地址範例1','台北','台灣',GETDATE(),'楊曜承');
insert into Customer(AccID,FirstName,LastName,Birthdate,Gender,PostalAddress,City,Country,UpdateDate,ChangedPersonnel)
values ('07876467','一','測試','1990/06/03','M','地址範例2','台北','台灣',GETDATE(),'測試一');
insert into Customer(AccID,FirstName,LastName,Birthdate,Gender,PostalAddress,City,Country,UpdateDate,ChangedPersonnel)
values ('896787653','柯南','江戶川','1999/06/9','M','Tokyo Hot Street 69','東京','日本',GETDATE(),'江戶川柯南');

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

insert into Bank(BankID,BankName,BankAddress)
values ('012','北護銀行','台北市北投區明德路365號');
insert into Bank(BankID,BankName,BankAddress)
values ('013','地球銀行','地球的每個角落');


select * from Account As A, Customer AS C WHERE A.AccID = C.AccID;