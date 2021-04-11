if DB_ID('練習08') is not null begin
	use master;
	exec sp_detach_db 練習08;
end

create database 練習08 on primary(
	name='練習08',
	filename='D:\MSSQL_DB\練習08.mdf',
	size=4MB,
	maxsize=10MB,
	filegrowth=1MB
	)
	log on(
	name=練習08_log,
	filename='D:\MSSQL_DB\練習08_log.ldf'
	)
for attach;
/*
[SQL] 發生 附加資料庫 失敗, 無法開啟實體檔案 “D:\xxx.mdf"。作業系統錯誤 5: “5(存取被拒。)"的訊息如何解決?
只要先關閉 SQL Server Management Studio，
(1)「以系統管理員身分執行」 SQL Server Management Studio
(2) 用windows驗證登入，接著再附加資料庫即可解決此問題
http://dev.brucelulu.com/topics/208
*/
go

use 練習08;
--### 1. 新增資料表(insert)
--- 隨堂練習1:請將[出貨記錄].[編號]IDENTITY關閉，並手動新增一筆資料 (10)
set IDENTITY_INSERT [出貨記錄] on;
declare @dataCount as int = cast( (select COUNT(*) from [出貨記錄]) as int);
--https://stackoverflow.com/questions/28916917/sql-count-rows-in-a-table
print @dataCount;
select * from [出貨記錄];
set @dataCount += 1;
INSERT INTO 出貨記錄([編號],[日期],[客戶名稱],[書名],[數量])
VALUES(@dataCount,GETDATE(),'大雄書局','回復術士的重啟人生7 即死魔法與複製技能的極致回復術',36)
GO
select * from [出貨記錄];

--- 隨堂練習2:請新增[員工]中，職位為 "辦事員"的資料至[圖書室借用記錄] (10)
select * from [員工];
select * from [圖書室借用記錄];
select T.* ,S.職位 as '員工職位' from [員工] as S ,[圖書室借用記錄] as T
where S.編號=T.員工編號 and S.職位='辦事員';

--- 隨堂練習3:請將SQL中定義的資料型態int, smallint, char, vchar的TYPE_NAME, PRECISION, DATA_TYPE的資訊放到自訂暫存資料表，並顯示結果 (10)
--  -- 提示1：使用　sp_datatype_info
--  -- 提示2：自訂暫存表的資料型態需與sp_datatype_info查詢結果的欄位資料型態相符
exec sp_datatype_info;
drop table if exists #tempInfo;
create table #tempInfo(--先按照exec執行的輸出結果建立資料型態相符的暫存表
	TYPE_NAME varchar(30),
	DATA_TYPE int,
	PRECISION int,
	drop1 varchar(30),drop2 varchar(30),drop3 varchar(30),drop4 varchar(30),drop5 varchar(30),drop6 varchar(30),
	drop7 varchar(30),drop8 varchar(30),drop9 varchar(30),drop10 varchar(30),drop11 varchar(30),drop12 varchar(30),
	drop13 varchar(30),drop14 varchar(30),drop15 varchar(30),drop16 varchar(30),drop17 varchar(30),
);

insert #tempInfo exec sp_datatype_info;--將exec查詢結果插入暫存表

select T.TYPE_NAME, T.DATA_TYPE, T.PRECISION 
from #tempInfo as T where T.TYPE_NAME in('int','smallint','char','varchar');
--https://www.w3schools.com/sql/trysql.asp?filename=trysql_op_in

--- 隨堂練習4:顯示[出貨記錄]與[客戶]資料表中所有的資料表，顯示不能重複欄位，將聯絡人的姓氏為'陳'的聯絡人顯示出來 (10)
select O.*, C.聯絡人 from [出貨記錄] as O, [客戶] as C 
where O.客戶名稱 = C.客戶名稱 and C.聯絡人 like '陳%';
--where like %表示萬用字元
--https://stackoverflow.com/questions/14290857/sql-select-where-field-contains-words

--- 隨堂練習5:請將隨堂練習4的結果放到新增資料表[詳細借用記錄]中 (10)
drop table if exists 詳細借用記錄;
update [客戶] set [聯絡人] = '陳鮭魚'
where [客戶名稱] = '天天書局';--update test data
--https://www.w3schools.com/sql/sql_update.asp
select O.*, C.聯絡人 into 詳細借用記錄
from [出貨記錄] as O, [客戶] as C 
where O.客戶名稱 = C.客戶名稱 and C.聯絡人 like '陳%';
--插入到新表單 https://www.w3schools.com/sql/sql_select_into.asp
--插入至現有表單 https://www.w3schools.com/sql/sql_insert_into_select.asp
select * from [詳細借用記錄];



--### 2. 修改資料表(update)
--- 隨堂練習6 圖書館員發現之前經理借的所有書籍都少紀錄一本，請將結果更新至[圖書室借用記錄] (10)
select * from [圖書室借用記錄];
update [圖書室借用記錄] set [數量] = [數量] + 1
where [員工編號] = 2;--經理的編號為2
--https://stackoverflow.com/questions/973380/sql-how-to-increase-or-decrease-one-for-a-int-column-in-one-command
select * from [圖書室借用記錄];

--- 隨堂練習7 請刪除[應徵者]未繳交自傳的資料 (10)
select * from [應徵者];
delete from [應徵者] where [自傳] is NULL;
--https://www.w3schools.com/sql/sql_delete.asp
select * from [應徵者];

--### 綜合練習
--- 隨堂練習8 (30)
-- - 1. 經理借了書籍中所有人沒有借過的書，請將記錄此資訊新增至[圖書室借用記錄]
-- - 2. 將更動的紀錄的所有欄位記錄在一個新增暫存資料表

