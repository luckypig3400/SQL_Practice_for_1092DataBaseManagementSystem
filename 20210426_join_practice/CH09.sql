USE  �m��09

GO
-- P9-4a

SELECT * 
FROM ���y 

GO
-- P9-4b

SELECT ���y�W��, CAST(���� * 0.8 AS numeric(4, 0) )  AS  �馩��
FROM ���y 

GO
-- P9-5a

SELECT '�j�a�n' , 3+5 , LOWER('ABC')

GO
-- P9-5b

SELECT �X�����q 
FROM  ���y 

GO
-- P9-6a

SELECT DISTINCT �X�����q
FROM ���y 

GO
-- P9-6b

SELECT TOP 2 * 
FROM ���y

GO
-- P9-7a

SELECT TOP 30 PERCENT * 
FROM ���y

GO
-- P9-7b

SELECT TOP 3*
FROM  ���y
ORDER BY ����

GO
-- P9-8

SELECT TOP 3   WITH TIES *
FROM ���y
ORDER BY ����

GO
-- P9-10a

SELECT IDENTITYCOL, ROWGUIDCOL 
FROM ���y 

GO
-- P9-10b

SELECT ���y�W�� AS �q�����y�W�� 
FROM ���y 

GO
-- P9-11

SELECT ��.�Ȥ�W��, ��.�p���H, �ƶq, �ѦW
FROM   �Ȥ� AS �� JOIN �X�f�O�� AS �X
       ON ��.�Ȥ�W�� = �X.�Ȥ�W��

GO
-- P9-12

SELECT �������y.�s��, �W��, ����
FROM   �������y JOIN �������y�w�w��
       ON �������y.�s�� = �������y�w�w��.�s�� 

GO
-- P9-13             

SELECT �������y.�s��, �W��, ����
FROM  �������y, �������y�w�w��
WHERE �������y.�s�� = �������y�w�w��.�s��
 

GO
-- P9-14a

SELECT �X.���~�W�� AS �X�X���q���~�W��, �X.���� , 
             ��.���~�W�� AS �мФ��q���~�W��, ��.���� 
FROM    �X�X���q AS �X  JOIN  �мФ��q AS �� 
             ON  �X.���~�W�� = ��.���~�W��

GO
-- P9-14b

SELECT �X.���~�W�� AS �X�X���q���~�W��, �X.���� , 
             ��.���~�W�� AS �мФ��q���~�W��, ��.����
FROM   �X�X���q AS �X  LEFT JOIN  �мФ��q AS �� 
             ON  �X.���~�W�� = ��.���~�W��

GO
-- P9-15a

SELECT �X.���~�W�� AS �X�X���q���~�W��, �X.���� ,
             ��.���~�W�� AS �мФ��q���~�W��, ��.���� 
FROM    �X�X���q AS �X  RIGHT JOIN  �мФ��q AS ��
            ON  �X.���~�W�� = ��.���~�W��

GO
-- P9-15b

SELECT �X.���~�W�� AS �X�X���q���~�W��, �X.���� , 
             ��.���~�W�� AS �мФ��q���~�W��, ��.���� 
FROM   �X�X���q AS �X  FULL JOIN  �мФ��q AS �� 
            ON �X.���~�W�� = ��.���~�W�� 

GO
-- P9-15c

SELECT �X.���~�W�� AS �X�X���q���~�W��, �X.���� ,
             ��.���~�W�� AS �мФ��q���~�W��, ��.���� 
FROM   �X�X���q AS �X  CROSS JOIN  �мФ��q AS �� 

GO
-- P9-17a

SELECT ���u.�m�W, ���u.¾��, 
             ���x.�m�W AS �D��
FROM    ���u  LEFT JOIN  ���u AS ���x
             ON  ���u.�D�޽s�� = ���x.�s��

GO
-- P9-17b

SELECT  *
FROM    ���u
WHERE   �ʧO = '�k' 

GO
-- P9-19a

SELECT  �Ȥ�W��, SUM(�ƶq) AS �X�f�ƶq 
FROM     �X�f�O��
GROUP BY  �Ȥ�W�� 

GO
-- P9-19b

SELECT �Ȥ�W�� , 
              DATEPART(MONTH, ���) AS ��� ,
              SUM(�ƶq) AS �X�f�ƶq
FROM   �X�f�O��
GROUP BY �Ȥ�W��, DATEPART(MONTH, ���)
ORDER BY �Ȥ�W��, DATEPART(MONTH, ���)

GO
-- P9-20

SELECT  �Ȥ�W��, �ѦW, SUM(�ƶq) AS �`�ƶq 
FROM     �X�f�O�� 
GROUP BY  CUBE (�ѦW, �Ȥ�W��)

GO
-- P9-21a

SELECT �Ȥ�W��, �ѦW, SUM(�ƶq) AS �`�ƶq 
FROM  �X�f�O��
GROUP BY ROLLUP(�Ȥ�W��, �ѦW)

GO
-- P9-21b

SELECT  �Ȥ�W��, �ѦW, SUM(�ƶq) AS �`�ƶq 
FROM    �X�f�O��
GROUP BY ROLLUP(�ѦW, �Ȥ�W��) 

GO
-- P9-23a

SELECT   �Ȥ�W��, �ѦW, SUM(�ƶq) AS �`�ƶq 
FROM      �X�f�O��
GROUP BY  �Ȥ�W��, �ѦW 
HAVING SUM(�ƶq) >= 6 

GO
-- P9-23b

SELECT  �Ȥ�W��, �ѦW, COUNT(*) AS ���� 
FROM     �X�f�O��
GROUP BY  �Ȥ�W��, �ѦW 
HAVING COUNT(*) > 1 

GO
-- P9-25a

SELECT * 
FROM   �X�f�O�� 
ORDER BY  �Ȥ�W�� DESC,  �ƶq ASC 

GO

-- P9-25b

SELECT *
FROM �X�f�O��
ORDER BY �Ȥ�W�� DESC, �ƶq ASC
OFFSET 3 ROWS

GO
-- P9-26

SELECT *
FROM �X�f�O��
ORDER BY �Ȥ�W�� DESC, �ƶq ASC
OFFSET 3 ROWS FETCH NEXT 4 ROWS ONLY