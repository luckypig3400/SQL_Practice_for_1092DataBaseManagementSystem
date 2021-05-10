USE �m��10

GO
����-- P10-5a

SELECT �p���H AS �ܽЦW��, �a�}
FROM �X�@�t��
UNION
SELECT �p���H, �a�}
FROM �Ȥ�
ORDER BY �p���H

GO
����-- P10-5b

SELECT �p���H AS �ܽЦW��, �a�}
FROM �X�@�t��
UNION ALL
SELECT �p���H, �a�}
FROM �Ȥ�
ORDER BY �p���H

GO
����-- P10-6

SELECT �p���H AS �ܽЦW��, �a�}
FROM �X�@�t��
UNION
SELECT �p���H, �a�}
FROM �Ȥ�
UNION 
SELECT '���j��', '�x�_���n�ʪF���T�q34��5��'
ORDER BY �p���H

GO
����-- P10-7

SELECT �q��s��, �U����, 
       �`�ƶq = (SELECT SUM(�ƶq) 
                 FROM  �q�ʶ��� 
                 WHERE �q��s�� = �q��.�q��s��)
FROM   �q��

GO
����-- P10-8

SELECT ���~�W��, 
       �ʤ��� = ���� * 100 / ( SELECT SUM (����) FROM �мФ��q ) 
FROM �мФ��q

GO
����-- P10-9a

SELECT ���~�W��, ���� 
FROM    �X�X���q 
WHERE ���� > ( SELECT MAX(����) FROM  �мФ��q ) 

GO
����-- P10-9b

SELECT * 
FROM �мФ��q 
WHERE ���~�W�� IN ( SELECT ���~�W�� 
                    FROM �X�X���q ) 

GO
����-- P10-10a

SELECT ���� 
FROM �мФ��q 
WHERE ���� <= ALL ( SELECT ����   
                    FROM  �X�X���q 
                    WHERE ���� > 410)

GO
����-- P10-10b

SELECT ���� 
FROM �мФ��q 
WHERE ���� <= ANY ( SELECT ����
                    FROM �X�X���q 
                    WHERE ���� > 410 ) 

GO
����-- P10-11a

SELECT * 
FROM �мФ��q 
WHERE EXISTS ( SELECT * 
               FROM �X�X���q 
               WHERE ���~�W�� = �мФ��q.���~�W��
                     AND ���� > 495) 

GO
����-- P10-11b

SELECT �мФ��q.* 
FROM �мФ��q JOIN �X�X���q 
          ON �мФ��q.���~�W�� = �X�X���q.���~�W��
WHERE �X�X���q.���� > 495

GO
����-- P10-11c

SELECT * 
FROM �мФ��q 
WHERE ���~�W�� IN (SELECT ���~�W�� 
                   FROM �X�X���q 
                   WHERE ���� > 495)

GO
����--P10-12a

SELECT *
FROM �мФ��q
WHERE ���~�W�� IN (SELECT ���~�W��
                   FROM �X�X���q)

GO
����-- P10-12b

SELECT * 
FROM �X�X���q 
WHERE ���~�W�� IN (SELECT ���~�W��   
                   FROM �мФ��q  
                   WHERE �X�X���q.���� > �мФ��q.����) 

GO
����-- P10-35a

UPDATE  ���y
SET ���� = 400
WHERE ���y�W�� = 'Windows Server �t�ι��'

GOU
����-- P10-35b

DECLARE @number int
DECLARE @string char(20) 
SET @number = 100
SET @string = '�ѤѮѧ�'
SELECT @number AS �Ʀr, @string AS �r��

GO
����-- P10-36a

SELECT ���y�W��, ���� * 0.75 AS �S�f��
FROM ���y

GO
����-- P10-36b

PRINT CAST('2/20/2016' AS DATETIME) - 1 
PRINT CAST('2/20/2016' AS DATETIME) + 3.25 

GO
����-- P10-37a

SELECT ���y�W��, ����
FROM ���y
WHERE ���� >= 390

GO
����-- P10-37b

SELECT ���y�W��, ����
FROM ���y 
WHERE ���y�W�� = 'AutoCAD �q��ø�ϻP�Ͼ�'

GO
����-- P10-38a

SELECT * 
FROM �X�X���q 
WHERE (���� > 450 AND ���� < 500) OR ���� < 430

GO
����-- P10-48b

SELECT * 
FROM �X�X���q 
WHERE ���� BETWEEN 420 AND 510 

GO
����--P10-38c

SELECT * 
FROM �мФ��q 
WHERE ���~�W�� IN ( 'SQL ���O�_��', 'AutoCAD �о�', 'Linux ��U' ) 

GO
����-- P10-39

SELECT * 
FROM �мФ��q 
WHERE ���~�W�� LIKE '%SQL%'

GO
����-- P10-40a

SELECT  * 
FROM  �мФ��q
WHERE  NOT EXISTS ( SELECT  *  
                    FROM  �X�X���q 
                    WHERE  ���~�W�� = �мФ��q.���~�W��)

GO
����-- P10-40b

PRINT 59 & 12 
PRINT 59 | 12 
PRINT 59 ^ 12 

GO
����-- P10-41a

SELECT 'Linux �[����Ȫ�����O ' + CONVERT(varchar, ����) + ' ��' 
FROM �мФ��q 
WHERE ���~�W�� = 'Linux �[�����' 

GO
����-- P10-41b

SELECT -���� 
FROM �мФ��q 
WHERE ���~�W�� = 'Linux �[�����' 

GO
����-- P10-41c

PRINT ~ CAST(1 AS tinyint) 

GO
����-- P10-42

UPDATE ���y
SET ���� += 100 
WHERE ���y�W�� = 'Windows Server �t�ι��'


GO
����-- P10-43

SET ANSI_NULLS OFF
SELECT * 
FROM ���u 
WHERE �D�޽s�� = NULL

GO
����-- P10-44

SELECT �m�W,
       ISNULL(CAST(�D�޽s�� AS VARCHAR), '�L') AS �D��
FROM ���u

GO
����-- P10-45a

SELECT * 
FROM ���u
WHERE �D�޽s�� IS NULL 

GO
����-- P10-45b

UPDATE ���u
SET �D�޽s�� = 0
WHERE �D�޽s�� IS NULL 

GO
����-- P10-45c

SELECT *
FROM ���u
WHERE �D�޽s�� IS NOT NULL

GO
����-- P10-46

SELECT IIF(�ʧO=0, '�k��', '�k��') AS �ʧO, ���N��, COUNT(*) AS �H��
FROM �ݨ�
GROUP BY �ʧO, ���N��  -- �̩ʧO�κ��N�פ��խp��
ORDER BY �ʧO, ���N��

GO
����-- P10-47a

SELECT IIF(���N��=3, '���N', IIF(���N��=2, '�|�i', '�t�l')) ����, COUNT(*) �H��
FROM �ݨ�
GROUP BY ���N��  -- �̺��N�פ��խp��
ORDER BY ���N�� DESC

GO
����-- P10-47b

SELECT CHOOSE(���N��, '�t�l', '�|�i', '���N') ����, COUNT(*) �H��
FROM �ݨ�
GROUP BY ���N��  -- �̺��N�פ��խp��
ORDER BY ���N�� DESC

GO
����-- P10-48

SELECT ���y�s��, ���y�W��, ����, �X�����q,
       ROW_NUMBER() OVER(ORDER BY ����) AS ����ƦW
FROM ���y

GO
����-- P10-49

SELECT ���y�s��, ���y�W��, ����, �X�����q,
   RANK() OVER(ORDER BY ����) AS ����ƦW
FROM ���y

GO
����-- P10-50a

SELECT ���y�s��, ���y�W��, ����, �X�����q,
  DENSE_RANK() OVER(ORDER BY ����) AS ����ƦW
FROM ���y

GO
����-- P10-50b

SELECT ���y�s��, ���y�W��, ����, �X�����q,
ROW_NUMBER() OVER(ORDER BY ����) AS ����ƦW
FROM ���y
ORDER BY ����ƦW                        -- �ϥ� ORDER BY...OFFSET...
OFFSET 4 ROWS FETCH NEXT 4 ROWS ONLY     --   ���w�Ǧ^�� 5~8 ���O��

GO
����-- P10-51

SELECT ���y�s��, ���y�W��, ����, �X�����q,
ROW_NUMBER() OVER(PARTITION BY �X�����q ORDER BY ����) AS ����ƦW
FROM ���y

