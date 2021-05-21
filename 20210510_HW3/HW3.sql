--1. 說明: 請修改 [作業1]資料庫建立與維護中[交易紀錄]資料表的欄位[交易ID]的Schema, 規則說明如下:
-- 1.1 每筆交易紀錄的[交易ID]前8碼為以系統日期命名，後6碼為交易紀錄序號，格式: 系統日期(8碼)_序號(6碼)。 (10)
-- 1.2 流水號由1開始編碼，流水號不足則左邊補0。(10)
-- 1.3 參考範例: 20190507_000001
use BANK_HW3;

select * from Trans;
--exec sp_helpconstraint @objname=Trans;
alter table Trans drop constraint if exists PK__Trans__specified_contraintName;
alter table Trans alter column TranID varchar(36) not null;
--原先定義ID為int先將其資料型態改為varchar才能儲存字元_

declare @newTID int = 1;

declare @accID varchar(10) = '00000001';
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

set @accID = '00000006';
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
VALUES('00000001', @trID, GETDATE(), 'A01', 'D05', N'Cool~\^o^/╰(*°▽°*)╯', GETDATE(), '001');

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
	insert into Trans VALUES('00000006', @todayFirstID, GETDATE(), 'A03', 'D66', N'QQㄋㄟㄋㄟ好喝到咩噗茶', GETDATE(), '006');
	--使用者新增資料區域結束
	update LOG_SEQ set LOG_COUNT = 1 where SDATE = @formattedDate;
end;
else begin
	declare @newID int = (select LOG_COUNT from LOG_SEQ where SDATE = @formattedDate) + 1;
	declare @id2wrtie varchar(36) = @formattedDate + '_' + (select RIGHT('000000' + cast(@newID as varchar), 6));
	--使用者新增資料區域開始
	insert into Trans VALUES('00000006', @id2wrtie, GETDATE(), 'D33', 'G05', N'爆爆水果茶', GETDATE(), '006');
	--使用者新增資料區域結束
	update LOG_SEQ set LOG_COUNT = @newID where SDATE = @formattedDate;
end;






--4. 請修改[個人資訊]資料表，並新增[個人密碼]欄位，使用變數宣告方式撰寫SQL Script輸入帳號與密碼，若帳密正確，顯示"密碼正確"；密碼錯誤顯示"密碼錯誤" (20)
alter table Customer add PWD varbinary(600);

update Customer set PWD = HASHBYTES('SHA2_512', 'pwd01912') where ID = '0';
update Customer set PWD = HASHBYTES('SHA2_512', 'pwd0011998') where ID = '001';
update Customer set PWD = HASHBYTES('SHA2_512', 'pwd0021998') where ID = '002';
update Customer set PWD = HASHBYTES('SHA2_512', 'pwd0031998') where ID = '003';
update Customer set PWD = HASHBYTES('SHA2_512', 'pwd0062003') where ID = '006';
--個人資料參考
	--Customer (ID,Lname,FName,BDate,Sex,Address,City,Country,UP_Date,UP_User)
	--('0', 'CY', 'Lien', '19120101', 'M', 'Neihu', 'Taipei', 'Taiwan', GETDATE(), '0'),
	--('001', 'LJ', 'KUO', '19981002', 'F', 'Neihu', 'Taipei', 'Taiwan', GETDATE(), '0'),
	--('002', 'CW', 'Lin', '19981002', 'F', 'Tianmu', 'Taipei', 'Taiwan', GETDATE(), '0'),
	--('003', 'DW', 'Wang', '19981002', 'M', 'Beitou', 'Taipei', 'Taiwan', GETDATE(), '0'),
	--('006', 'OwO', 'YA', '20030331', 'F', 'Tianmu', 'Taipei', 'Taiwan', GETDATE(), '0');
--個人資料參考




use master -- release database