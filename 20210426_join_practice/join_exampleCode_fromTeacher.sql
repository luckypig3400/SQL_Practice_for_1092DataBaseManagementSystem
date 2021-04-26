-- 多條件查詢
DECLARE @BookName nvarchar(30)
DECLARE @SearchCond nvarchar(50)
SET @BookName='Windows'
SET @SearchCond='%' + @BookName + '%'
select @SearchCond

SELECT 訂單.訂單編號, 訂單.下單日期, 書籍.書籍名稱, 訂購項目.數量, 客戶.客戶名稱, 客戶.聯絡人, 客戶.地址, 客戶.電話
FROM 訂單 LEFT JOIN 客戶 ON 客戶.客戶編號=訂單.客戶編號 
          LEFT JOIN 訂購項目 ON 訂購項目.訂單編號=訂單.訂單編號
          LEFT JOIN 書籍 ON 書籍.書籍編號 = 訂購項目.書籍編號
--WHERE 書籍.書籍名稱='Windows Server 系統實務' --精準搜尋
--WHERE 書籍.書籍名稱 like '%W%' -- keyword搜尋
--WHERE 書籍.書籍名稱 IN('Windows Server 系統實務', 'Outlook 快學快用')
--WHERE 書籍.書籍名稱 like @SearchCond
--WHERE 書籍.書籍名稱 like '%Photoshop%'



-- 使用IFF範例
SELECT IIF(書名 LIKE '%LINUX%', 'Linux', 'Windows') 類別,  本數 into #Result2
FROM   借閱清單
WHERE 書名 LIKE '%LINUX%' OR 書名 LIKE '%Windows%'

SELECT 類別, SUM(本數) AS 借閱數量 
FROM #Result2
GROUP BY 類別



-- 分多次查詢範例程式
SELECT 訂單.訂單編號, 訂單.下單日期, 書籍.書籍名稱, 訂購項目.數量, 客戶.客戶名稱, 客戶.聯絡人, 客戶.地址, 客戶.電話
FROM 訂單 LEFT JOIN 客戶   ON 客戶.客戶編號=訂單.客戶編號 
          LEFT JOIN 訂購項目 ON 訂購項目.訂單編號=訂單.訂單編號
          LEFT JOIN 書籍 ON 書籍.書籍編號 = 訂購項目.書籍編號

drop table #temp1
drop table #temp2
SELECT 訂單.訂單編號, 訂單.下單日期, 客戶.客戶名稱, 客戶.聯絡人, 客戶.地址, 客戶.電話  INTO #temp1
FROM 訂單 LEFT JOIN 客戶   ON 客戶.客戶編號=訂單.客戶編號 

SELECT * from #temp1

SELECT #temp1.*, 訂購項目.數量, 訂購項目.書籍編號  INTO #temp2
FROM #temp1 LEFT JOIN 訂購項目 ON 訂購項目.訂單編號=#temp1.訂單編號

SELECT * from #temp2

SELECT #temp2.*, 書籍.書籍名稱
FROM   #temp2 LEFT JOIN 書籍 ON 書籍.書籍編號 = #temp2.書籍編號