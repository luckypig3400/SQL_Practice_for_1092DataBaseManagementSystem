USE 練習10

-- 子查詢
-- (1) 直接取值 - 子查詢回傳為數值
-- (2) 比對清單 - 子查詢回傳為清單(欄位)
-- (3) 測試存在 - 使用運算子判斷式子查詢回傳是否有存在: True or False

-- (1) 直接取值 - 子查詢回傳為數值，搭配SUM函數
-- P10-7
SELECT 訂單編號, 下單日期, 
       總數量 = (SELECT SUM(數量) 
                 FROM  訂購項目 
                 WHERE 訂單編號 = 訂單.訂單編號)
FROM   訂單
GO
-- P10-8
SELECT 產品名稱, 
       百分比 = 價格 * 100 / ( SELECT SUM (價格) FROM 標標公司 ) 
FROM 標標公司
--子查詢結果
SELECT SUM (價格) FROM 標標公司
GO
-- (1) 直接取值 - 子查詢回傳為數值，搭配MAX函數
-- P10-9a
SELECT 產品名稱, 價格 
FROM    旗旗公司 
WHERE 價格 > ( 443 ) 
--子查詢結果
SELECT AVG(價格) FROM  標標公司
GO

--------------------------------------
-- (2) 比對清單 - 子查詢回傳為清單(欄位) - 使用IN
-- P10-9b
SELECT * 
FROM 標標公司 
WHERE 產品名稱 IN ( SELECT *
                    FROM 旗旗公司 ) 
SELECT * 
FROM 標標公司 
WHERE 產品名稱 IN ('Windows 使用手冊','Linux 架站實務','JAVA 程式語言')
--子查詢結果
SELECT * FROM 旗旗公司
GO

-- (2) 比對清單 - 子查詢回傳為清單(欄位) - 使用ALL 
-- P10-10a
SELECT 價格 
FROM 標標公司 
WHERE 價格 <= ALL ( SELECT 價格   
                    FROM  旗旗公司 
                    WHERE 價格 > 410)
--子查詢結果
SELECT 價格
FROM  旗旗公司
WHERE 價格 > 410
GO

-- (2) 比對清單 - 子查詢回傳為清單(欄位) - 使用ANY
-- P10-10b
SELECT 價格 
FROM 標標公司 
WHERE 價格 <= SOME ( SELECT 價格
                    FROM 旗旗公司 
                    WHERE 價格 > 410 ) 
--子查詢結果
SELECT *
FROM 旗旗公司 
WHERE 價格 > 410 
GO

-- P10-11a
SELECT * 
FROM 標標公司 
WHERE EXISTS ( SELECT * 
               FROM 旗旗公司 
               WHERE 產品名稱 = 標標公司.產品名稱 AND 價格 > 495) 
SELECT * 
FROM 標標公司 
WHERE 產品名稱 = 'Linux 架站實務'

--子查詢結果
SELECT * 
FROM 旗旗公司
WHERE 價格 > 495 

--相同功能的不同查詢方式
-- P10-11b

SELECT 標標公司.* 
FROM 標標公司 JOIN 旗旗公司 ON 標標公司.產品名稱 = 旗旗公司.產品名稱
WHERE 旗旗公司.價格 <401 

SELECT 標標公司.*, 旗旗公司.*
FROM 標標公司 JOIN 旗旗公司 ON 標標公司.產品名稱 = 旗旗公司.產品名稱
GO

-- P10-11c
SELECT * 
FROM 標標公司 
WHERE 產品名稱 IN (SELECT 產品名稱 
                   FROM 旗旗公司 
                   WHERE 價格 > 495)
SELECT * 
FROM 標標公司 
WHERE 產品名稱 IN ('Windows 使用手冊')

--子查詢結果
SELECT 產品名稱
FROM 旗旗公司 
WHERE 價格 > 495

--說明
-- 標標公司 JOIN 旗旗公司 ON 標標公司.產品名稱 = 旗旗公司.產品名稱 
-- 等於 
-- WHERE 標標公司.產品名稱 = 旗旗公司.產品名稱

GO

--P10-12a
SELECT *
FROM 標標公司
WHERE 產品名稱 IN (SELECT 產品名稱
                   FROM 旗旗公司)
GO
-- P10-12b
SELECT * 
FROM 旗旗公司 
WHERE 產品名稱 IN (SELECT 產品名稱   
                   FROM 標標公司  
                   WHERE 旗旗公司.價格 > (SELECT COUNT(書名) 
										  FROM 借閱清單
										  WHERE 本數>1)
			       ) 

GO

-- T-SQL 運算子
-- (1) 指定運算子: = 
-- (2) 算數運算子
   --  加、減、乘、除
-- (3) 比較運算子
 -- 等於    =,
 -- 不等於  !=, <>
 -- 大於    >, >=,  --- => ????
 -- 小於    <. <=,  --- =< ????
-- (4) 邏輯運算子
 -- ALL, ANY, SOME, 
 -- EXISTS
 -- AND, OR
 -- BETWEEN 
 -- IN
 -- LIKE
  -- 補充表格:
   -- _底線
   -- [ ], [^] -- 指定範圍 
 -- NOT
-- P10-36a

-- (2) 算數運算子
   --  加、減、乘、除
SELECT 書籍名稱, 價格, 價格 AS Price, 價格 * 0.75 AS 特惠價
FROM 書籍

SELECT *
FROM 書籍
GO

-- 範例: 日期計算
 -- 重點: CAST - 主要型態轉換
 -- 重點: CONVERT - 通常用在時間格式轉換 字串<--->時間

-- P10-36b
PRINT CAST('2/20/2016' AS DATETIME) +1 
PRINT CAST('2/20/2016' AS DATETIME) + 3.25 

-- 補充
DECLARE @data1 varchar(30)='123';
DECLARE @data2 varchar(30)='456';
SELECT @data1+@data2;

SELECT cast(@data1 AS int) + cast(@data2 AS int);

--原文網址：https://kknews.cc/code/ga46yp8.html

GO
-- P10-37a

SELECT 書籍名稱, 價格
FROM 書籍
WHERE 價格 >= 390

GO
-- P10-37b

SELECT 書籍名稱, 價格
FROM 書籍 
WHERE 書籍名稱 = 'AutoCAD 電腦繪圖與圖學'

GO
-- P10-38a

SELECT * 
FROM 旗旗公司 
WHERE (價格 > 450 AND 價格 < 500) OR 價格 < 430

GO
-- P10-48b

SELECT * 
FROM 旗旗公司 
WHERE 價格 BETWEEN 420 AND 510
 
SELECT * 
FROM 旗旗公司 
WHERE 價格 >=420 AND 價格 <=510 

GO
--P10-38c

SELECT * 
FROM 標標公司 
WHERE 產品名稱 IN ( 'SQL 指令寶典', 'AutoCAD 教學', 'Linux 手冊' ) 

 -- LIKE
  -- 補充表格:
   -- _底線 - 不明確字
   -- [ ], [^] -- 指定範圍 
-- P10-39
SELECT * 
FROM 標標公司 
WHERE 產品名稱 LIKE '[a-z]indows'

GO
-- P10-40a

SELECT  * 
FROM  標標公司
WHERE  NOT EXISTS ( SELECT  *  
                    FROM  旗旗公司 
                    WHERE  產品名稱 = 標標公司.產品名稱)

GO
-- P10-40b

PRINT 59 & 12 
PRINT 59 | 12 
PRINT 59 ^ 12 

GO
-- P10-41a
-- CONVERT varchar style: 
--- cast vs convert????
SELECT 'Linux 架站實務的價格是 ' + CONVERT(varchar, 價格,0) + ' 元' 
FROM 標標公司 
WHERE 產品名稱 = 'Linux 架站實務' 

SELECT 'Linux 架站實務的價格是 ' + CONVERT(varchar, 價格,1) + ' 元' 
FROM 標標公司 
WHERE 產品名稱 = 'Linux 架站實務' 

SELECT 'Linux 架站實務的價格是 ' + CONVERT(varchar, 價格,2) + ' 元' 
FROM 標標公司 
WHERE 產品名稱 = 'Linux 架站實務' 

SELECT * FROM 標標公司 

UPDATE 標標公司
SET 價格 = 115432 
WHERE 產品名稱 = 'Linux 架站實務'

-- 參考資料https://www.w3schools.com/sql/func_sqlserver_convert.asp

GO

UPDATE 書籍
SET 價格 += 100 
WHERE 書籍名稱 = 'Windows Server 系統實務'


GO

-- P10-43
SET ANSI_NULLS OFF
SELECT * 
FROM 員工 
WHERE 主管編號 = NULL

GO

-- P10-44
SELECT 姓名,
       ISNULL(CAST(主管編號 AS VARCHAR), 'Nono') AS 主管
FROM 員工

SELECT *
FROM 員工
WHERE 主管編號 IS NULL
GO
-- P10-45a

SELECT * 
FROM 員工
WHERE 主管編號 IS NULL 

GO

-- P10-45b
UPDATE 員工
SET 主管編號 = 0
WHERE 主管編號 IS NULL 

GO
-- P10-45c

SELECT *
FROM 員工
WHERE 主管編號 IS NOT NULL

GO

-------------------------------------------------------------
-- P10-46

SELECT IIF(性別=0, '女', '男') AS 性別, 滿意度, COUNT(*) AS 人數
FROM 問卷
GROUP BY 性別, 滿意度  -- 依性別及滿意度分組計數
ORDER BY 性別, 滿意度

SELECT *
FROM 問卷
GO
-- P10-47a

SELECT IIF(滿意度=3, '滿意', IIF(滿意度=2, '尚可', '差勁')) 評價, COUNT(*) 人數
FROM 問卷
GROUP BY 滿意度  -- 依滿意度分組計數
ORDER BY 滿意度 DESC

GO
-- P10-47b

SELECT CHOOSE(滿意度, '差勁', '尚可', '滿意') 評價, COUNT(*) 人數
FROM 問卷
GROUP BY 滿意度  -- 依滿意度分組計數
ORDER BY 滿意度 DESC

GO