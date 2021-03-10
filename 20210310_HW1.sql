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
	BankCodename char(6),
	AccountID char(60),
	Balance int,
	BranchAccount char(60),
	AccountType int,
	PRIMARY KEY(AccountID)
);

if OBJECT_ID('Customer')IS NOT NULL begin
	drop table Customer;
end
create table Customer(
	AccountID char(69),
	FirstName char(32),
	LastName char(32),
	Birthdate date,
	Gender char(3),
	PostalAddress char(255),
	PRIMARY KEY(AccountID)
);

if OBJECT_ID('TransactionLog')IS NOT NULL begin
	drop table TransactionLog;
end
create table TransactionLog(
	AccountID char(69),
	TransactionID char(60),
	TransactionDate date,
	ATM_ID char(60),
	TransactionType char(32),
	TransactionDetail char(255),
	PRIMARY KEY(AccountID,TransactionID)
);

if OBJECT_ID('Bank')IS NOT NULL begin
	drop table Bank;
end
create table Bank(
	BankCodename char(6),
	BankName char(66),
	PRIMARY KEY(BankCodename)
);


--使用修改資料表的語法(alter)，將性別欄為設定限制條件，並新增預設值為U
alter table Customer drop column Gender;--刪除欄位
alter table Customer add Gender char(1);--新增欄位
alter table Customer add constraint Gender DEFAULT 'U' FOR Gender;--在欄位新增約束並加入預設值

insert into Account(BankCodename,AccountID,Balance,BranchAccount,AccountType)
values ('012','082214226',60000,'00412',1);
insert into Account(BankCodename,AccountID,Balance,BranchAccount,AccountType)
values ('012','082214266',50000,'00412',1);
insert into Customer(AccountID,FirstName,LastName,Birthdate,Gender,PostalAddress)
values ('082214226','曜承','楊','2000/07/13','M','地址範例1');
insert into Customer(AccountID,FirstName,LastName,Birthdate,Gender,PostalAddress)
values ('082214266','測試','洪','1996/06/06','M','地址範例2');
insert into TransactionLog(AccountID,TransactionID,TransactionDate,ATM_ID,TransactionType,TransactionDetail)
values ('082214226','1',GETDATE(),'1','1','開戶存款');
insert into TransactionLog(AccountID,TransactionID,TransactionDate,ATM_ID,TransactionType,TransactionDetail)
values ('082214266','1',GETDATE(),'1','1','開戶存款');
insert into Bank(BankCodename,BankName)
values ('012','北護銀行');
insert into Bank(BankCodename,BankName)
values ('013','北科銀行');

select * from Account As A, Customer AS C WHERE A.AccountID = C.AccountID;