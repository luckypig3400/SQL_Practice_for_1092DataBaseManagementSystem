/*
### 1. 新增資料表(insert)
- 隨堂練習1:請將[出貨記錄].[編號]IDENTITY關閉，並手動新增一筆資料 (10)
- 隨堂練習2:請新增[員工]中，職位為 "辦事員"的資料至[圖書室借用記錄] (10)
- 隨堂練習3:請將SQL中定義的資料型態int, smallint, char, vchar的TYPE_NAME, PRECISION, DATA_TYPE的資訊放到自訂暫存資料表，並顯示結果 (10)
  -- 提示1：使用　sp_datatype_info
  -- 提示2：自訂暫存表的資料型態需與sp_datatype_info查詢結果的欄位資料型態相符
- 隨堂練習4:顯示[出貨記錄]與[客戶]資料表中所有的資料表，顯示不能重複欄位，將聯絡人的姓氏為'陳'的聯絡人顯示出來 (10)
- 隨堂練習5:請將隨堂練習4的結果放到新增資料表[詳細借用記錄]中 (10)

### 2. 修改資料表(update)
- 隨堂練習6 圖書館員發現之前經理借的所有書籍都少紀錄一本，請將結果更新至[圖書室借用記錄] (10)
- 隨堂練習7 請刪除[應徵者]未繳交自傳的資料 (10)

### 綜合練習
- 隨堂練習8 (30)
 - 1. 經理借了書籍中所有人沒有借過的書，請將記錄此資訊新增至[圖書室借用記錄]
 - 2. 將更動的紀錄的所有欄位記錄在一個新增暫存資料表
*/

if DB_ID('練習08') is not null begin
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

