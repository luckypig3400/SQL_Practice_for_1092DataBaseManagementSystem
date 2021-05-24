-- 影片連結: https://drive.google.com/file/d/1ep9cZ3zhwS0V3cTocRojcijwiwYNB962/view?usp=sharing
-- ## 說明
-- 1. 請下載影片自行觀看，依照課堂上的練習時間完成隨堂練習並將隨堂練習上傳至[作業區]
-- 2. 將附件的mdf跟ldf附加到MSSQL中
-- 3. 請於5/30 以前上傳隨堂練習作為點名以及遠距上課證明
-- 4. 請將所有語法依照順序，儲存在同一檔案，名稱W10.sql
-- 5. 所有題目全對才給分
-- 6. 遲交0分
USE master;
GO
--GO 用途說明:	https://blog.csdn.net/zhangqidashu/article/details/17250321
IF DB_ID('練習10') IS NULL BEGIN
	CREATE DATABASE 練習10 ON PRIMARY(
		NAME=練習10,
		FILENAME='D:\\MSSQL_DB\\練習10.mdf'
	)
	LOG ON(
		FILENAME='D:\\MSSQL_DB\\練習10_l	og.ldf'
	)FOR ATTACH;
END;
GO
USE 練習10;
GO
-- ### 1. 使用JOIN語法改寫10-7範例(25)
-- - 1. 說明: 請使用OUTER　JOIN語法將[訂單]以及[訂購項目]合併，表格輸出顯示結果應與已下程式碼結果一致
SELECT 訂單編號, 下單日期,
	總數量 = (SELECT SUM(數量)
	FROM 訂購項目
	WHERE 訂單編號 = 訂單.訂單編號)
FROM 訂單

select 訂單.訂單編號, 訂單.下單日期, Sum(訂購項目.數量) as 總數量
FROM 訂單
	full outer join 訂購項目 on 訂購項目.訂單編號 = 訂單.訂單編號
Group BY 訂單.訂單編號, 訂單.下單日期

-- ### 2. 查詢欄位中不確定字元語法(25)
-- - 1. 說明: 請查詢資料表[標標公司]中，[產品名稱]內容包含 "某某"手冊的結果，例如: 資料表產品名稱有Windows{某}{某}手冊，但查詢者忘記某某是那個兩個字，請使用LIKE語法完成此查詢結果
select 產品名稱
from 標標公司
where 產品名稱 LIKE '%手冊'

-- ### 3. 查詢欄位中不確定字元包含在某個範圍語法(25)
-- - 1. 說明: 大岳記得資料表[標標公司]中的某項產品的[產品名稱]的內容:  {某字元}indows，這個{某字元}可能是S,T,U,V W,Z,Y, Z當中某個字元， 請使用LIKE語法協助大岳完成此查詢結果
select 產品名稱
from 標標公司
where 產品名稱 LIKE '_indows%'

-- ### 4. 取代查詢結果替換字串(25)
-- - 1. 說明: 太岳想要把[問卷]資料表中的型別跟滿意度分別使用中文取代原本的數值，並依照滿意度排序，請依附圖(04_WISH.jpg)需求顯示結果
-- - 2. 性別:
-- 1-男
-- 2-女
-- - 3 滿意度:
-- - 3 滿意
-- - 2: 尚可
-- - 1: 差勁

USE master;