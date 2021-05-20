--1. 說明: 請修改 [作業1]資料庫建立與維護中[交易紀錄]資料表的欄位[交易ID]的Schema, 規則說明如下:
-- 1.1 每筆交易紀錄的[交易ID]前8碼為以系統日期命名，後6碼為交易紀錄序號，格式: 系統日期(8碼)_序號(6碼)。 (10)
-- 1.2 流水號由1開始編碼，流水號不足則左邊補0。(10)
-- 1.3 參考範例: 20190507_000001
use BANK_HW3;

select * from Trans;
exec sp_helpconstraint @objname=Trans;
alter table Trans drop constraint PK__Trans__1EBB4AFA98EA6895;
alter table Trans
alter column TranID varchar(36);
--原先定義ID為int先將其資料型態改為varchar才能儲存字元_

declare @newTID int = 1;

declare @accID varchar(10) = '00000001';
declare @accTID int = 1;
declare @accTotalTrans int = (select COUNT(TranID) from Trans where AccID = @accID);
while @accTID <= @accTotalTrans
begin
	declare @tranTime date = (select TranTime from Trans where TranID = cast(@accTID as varchar) and AccID = @accID);
	declare @tIDnewFormat varchar(36) = convert(varchar ,@tranTime ,112) + '_';
	--時間格式convert()代碼查詢:https://dotblogs.com.tw/kevinya/2014/09/05/146474
	--https://stackoverflow.com/questions/889629/how-to-get-a-date-in-yyyy-mm-dd-format-from-a-tsql-datetime-field/889660
	declare @idToMerge varchar(15) = (select RIGHT('000000' + cast(@newTID as varchar), 6));
	--[MS SQL] 產生數字前面補零的固定長度字串:https://felixhuang.pixnet.net/blog/post/26738193
	set @tIDnewFormat = @tIDnewFormat + @idToMerge;
	print(@tIDnewFormat);
	update Trans set TranID = @tIDnewFormat where TranID = @accTID and AccID = @accID;
	set @accTID = @accTID + 1;
	set @newTID = @newTID + 1;
end;

--2. 新增一個資料表LOG_SEQ，此資料表為記錄每天一共有多少筆log產生，以日期yyyymmdd作為primary key。 Schema規則如下
--CREATE TABLE LOG_SEQ(
--  SDATE varchar(8) NOT NULL PRIMARY KEY, -- 當天的log紀錄
--  LOG_COUNT varchar(6) NOT NULL --當天一共有多少筆log
--) 
-- 2.1 請撰寫SQL Script如果當天第一筆log產生時，且LOG_SEQ無資料時, 新增當天的紀錄，並給予初始化，SDATE數值指定為當天，且LOG_COUNT指定為0 (30)
-- 2.2 呈2.1, 若每新增一筆log時，LOG_COUNT自動加1 (10)
--提示: 2使用子查詢(Subquery)中的EXISTS語法

--3. 請整合1與2語法，並且將SDATE以及LOG_COUNT的結果帶入新增[交易紀錄]語法(INSERT)中 (20)

--4. 請修改[個人資訊]資料表，並新增[個人密碼]欄位，使用變數宣告方式撰寫SQL Script輸入帳號與密碼，若帳密正確，顯示"密碼正確"；密碼錯誤顯示"密碼錯誤" (20)