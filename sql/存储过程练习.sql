--�洢����

USE test
SELECT * FROM dbo.Student

----ȫ�ֱ���д��
 --ɾ���洢����
DROP PROC StuProc

--�ⲿ����
go
CREATE PROC StuProc 
@s_name varchar(100)
AS
    BEGIN
        SELECT  *FROM dbo.Student WHERE s_name=@s_name
    END
 GO
--EXEC �ؼ��ִ����洢����
EXEC StuProc '����'

--ɾ���洢����
DROP PROC StudentProc
--�ڲ�����д��
CREATE PROC StudentProc
@s_name varchar(100)='Ǯ��'
AS
BEGIN
SELECT * FROM dbo.Student WHERE s_name=@s_name
END
GO

EXEC StudentProc

--�����������
CREATE	PROC StudentProc1
@s_name varchar(100),
@Is_Right int output
AS 
BEGIN	
IF EXISTS(SELECT * FROM dbo.Student WHERE s_name=@s_name)
SET @Is_Right=1
ELSE
SET @Is_Right=0
END
GO 

DECLARE @Is_Right INT
EXEC StudentProc1 '����',@Is_Right OUTPUT
SELECT @Is_Right


----�ֲ�����
CREATE PROC StudentProc
AS 
DECLARE @s_name VARCHAR(100)
SET @s_name='����'
BEGIN 
SELECT * FROM student WHERE s_name=@s_name
END
GO

EXEC StudentProc


--��ʾ�ֲ������
CREATE PROC StudentProc
AS 
BEGIN 
DECLARE @s_name varchar(100)
SET @s_name=(SELECT s_name FROM student WHERE s_id IN (01))
SELECT @s_name
END
GO

EXEC StudentProc


----��ϸ��ϰ

DROP PROC StudentProc


IF EXISTS ( SELECT  name
            FROM    sysobjects
            WHERE   name = 'Proc_InsertEmployee'
                    AND type = 'p' )
    DROP PROCEDURE Proc_InsertEmployee
GO 
CREATE	PROCEDURE Proc_InsertEmployee
    @name NVARCHAR(10) ,
    @sex VARCHAR(10) ,
    @biryh DATE
AS
    BEGIN 
        DECLARE @S_ID INT
        SELECT  @S_ID = MAX(s_id)
        FROM    dbo.Student
        IF ( @S_ID IS NULL )
            SET @S_ID = 1
        ELSE
            SET @S_ID = ( SELECT    MAX(s_id) + 1
                          FROM      dbo.Student
                        )
        BEGIN
            INSERT  INTO dbo.Student
                    ( s_id ,
                      s_name ,
                      s_biryh ,
                      s_sex
                    )
            VALUES  ( @S_ID , -- s_id - int
                      @name , -- s_name - varchar(20)
                      CAST(@biryh AS DATE) , -- s_biryh - varchar(20)
                      @sex  -- s_sex - varchar(20)
                    )
        END
    END 
GO 

EXEC dbo.Proc_InsertEmployee @name = N'���', -- nvarchar(10)
    @sex = 'Ů', -- varchar(10)
    @biryh = '1989-07-01' -- datetime

select * FROM dbo.Student


EXEC sys.sp_databases	


--1.�����洢����
IF EXISTS(SELECT * FROM sysobjects WHERE name='proc_stud' AND type='p')
	DROP PROCEDURE proc_stud
GO
CREATE PROC proc_stud
AS
    BEGIN 
        SELECT  * FROM    dbo.Student
    END 
GO

EXEC dbo.proc_stud
--2.������ͬ�汾�Ĵ洢����
IF EXISTS(SELECT * FROM sysobjects WHERE name='proc_stud'AND type='p')
	DROP PROC proc_stud
GO
CREATE PROC proc_stud;1
AS 
BEGIN 
	SELECT * FROM dbo.Student WHERE s_sex='��'
END
GO
CREATE	 PROC proc_stud;2
AS
BEGIN 
	SELECT * FROM dbo.Student WHERE s_sex='Ů'
END
GO 

EXEC dbo.proc_stud;1
EXEC dbo.proc_stud;2
EXEC dbo.proc_stud


--�������Ĵ洢����
IF EXISTS(SELECT * FROM sys.objects WHERE name='proc_stud' AND type='p')
DROP PROC proc_stud
GO	
CREATE PROC proc_stud
@name varchar(10)='Ĭ��',
@birht DATE='2019-01-01',
@sex VARCHAR(10)='��'
AS 
BEGIN 

INSERT INTO dbo.Student
        ( s_id, s_name, s_biryh, s_sex )
VALUES  ( (SELECT MAX(s_id)+1 FROM dbo.Student), -- s_id - int
          @name, -- s_name - varchar(20)
          @birht, -- s_biryh - varchar(20)
          @sex  -- s_sex - varchar(20)
          )
END 
GO

EXEC dbo.proc_stud	@name='dada',@birht='1991-01-11',@sex='Ů'
EXEC dbo.proc_stud



--����������Ĵ洢����
IF EXISTS(SELECT * FROM sys.objects WHERE name='proc_stud' AND type='p')
DROP PROC proc_stud
GO	
CREATE PROC proc_stud
@s_sex VARCHAR(10),
@count INT OUTPUT
AS 
BEGIN 
	SELECT @count= COUNT(1) FROM dbo.Student WHERE s_sex=@s_sex
END
GO 

DECLARE	@count int 
EXEC dbo.proc_stud '��',@count OUTPUT
SELECT @count AS �Ա�Ϊ�е�����

SELECT * FROM dbo.Student
DELETE FROM dbo.Student WHERE s_id>8



--�洢���̵ķ���״̬
IF EXISTS(SELECT * FROM sys.objects WHERE name='proc_stud' AND type='p')
DROP PROC proc_stud
GO	
CREATE PROC proc_stud
@s_id INT,
@sum INT OUTPUT
AS
BEGIN 
 SELECT @sum= SUM(s_score) FROM dbo.Score where s_id=@s_id
 IF(@sum<180)
 RETURN	2
 ELSE	
 RETURN 3
END
GO 

DECLARE	@sum INT,@status INT
EXEC dbo.proc_stud 2, @sum OUTPUT
SELECT @sum



--�޸Ĵ洢����

go
--����sql serverʱ�Զ�ִ�д洢����
CREATE PROC procStud
AS
BEGIN 
	SELECT * FROM dbo.Student
END
GO

--��Ϣ 15398������ 11��״̬ 1������ sp_procoption���� 73 ��
--ֻ�� dbo ӵ�е� master ���ݿ��еĶ�����ܸ����������á�
DECLARE @n INT 
EXEC @n=sys.sp_procoption @ProcName = N'procStud', -- nvarchar(776)
    @OptionName = 'startup', -- varchar(35)
    @OptionValue = 'TRUE' -- varchar(12)
	IF @n=0
	PRINT 'procedure proc_stud will autoexec when starting up'
GO

DECLARE @n INT
EXEC @n=sys.sp_procoption @ProcName = N'procStud', -- nvarchar(776)
    @OptionName = 'startup', -- varchar(35)
    @OptionValue = 'FALSE' -- varchar(12)
	IF @n=0
	PRINT 'procedure proc_stud will not execute when starting up'
GO 






























--��ϰ:
--����һ���洢���̣���ѯѧ������������Ϣ������ӡѧ������,ƽ������
IF EXISTS(SELECT * FROM sys.objects WHERE name='proc_test1'AND TYPE='p')
DROP PROC proc_test1
go
CREATE PROC proc_test1
@count INT OUTPUT,@avg INT OUTPUT
AS
BEGIN 
SELECT * FROM dbo.Student
--DECLARE @count INT,@avg INT
SELECT @count= COUNT(1),@avg= AVG(a.age) FROM (SELECT distinct s_name,s_biryh,DATEDIFF(DAY,s_biryh,GETDATE())/365 AS age FROM dbo.Student) a
END
GO 
DECLARE @count INT,@avg INT
EXEC dbo.proc_test1 @count OUTPUT,@avg OUTPUT
select(CAST(@count AS VARCHAR(10))+','+CAST(@avg AS VARCHAR(10)))


--����һ���洢���̣�ͳ��������Ů�����������������������
GO
CREATE PROC proc_test3
@num1 INT OUT,
@num2 INT OUTPUT
AS
BEGIN 
	SELECT @num1= COUNT(1) FROM dbo.Student WHERE s_sex='��'
	SELECT @num2= COUNT(1) FROM dbo.Student WHERE s_sex='Ů'
END
GO 

DECLARE	@num1 INT ,@num2 INT 
EXEC dbo.proc_test3 @num1 OUT, -- int
    @num2 OUTPUT -- int
	PRINT '�Ա��е�����'+ CAST(@num1 AS VARCHAR(10))+',�Ա�Ů������'+CAST(@num2 AS VARCHAR(10))



--����һ���洢���̣�����һ��ѧ����ѧ�źͿγ̱�ţ���ѯѧ���ĳɼ�
IF EXISTS(SELECT * FROM sys.objects WHERE name='proc_test4'AND TYPE='p')
DROP PROC proc_test4
go
CREATE PROC proc_test4
@s_id INT=1 ,@c_id INT=1
AS 
BEGIN 
SELECT s_score FROM dbo.Score WHERE s_id=@s_id AND c_id=@c_id
END 
GO 
EXEC dbo.proc_test4 @s_id = 2, -- int
    @c_id = 2 -- int

 


 --1����һ���洢���̣����������ѧ�Ų�ѯ���ѧ���Ƿ�μӿ��ԣ�����μӿ������ӡ��
--ѧ�����������Կ�Ŀ���ơ���Ӧ�ɼ������û�вμӿ�������ʾ��ѧ��δ�μӿ���
IF EXISTS(SELECT * FROM sys.objects WHERE name='proc_test5'AND TYPE='p')
DROP PROC proc_test5
go
CREATE PROC proc_test5
@s_id int 
AS 
BEGIN 
IF EXISTS(SELECT a.s_name,c_name,s_score FROM dbo.Student a LEFT JOIN dbo.Score ON Score.s_id = a.s_id JOIN dbo.Course ON Course.c_id = Score.c_id WHERE Score.s_id=@s_id)
SELECT a.s_name,c_name,s_score FROM dbo.Student a LEFT JOIN dbo.Score ON Score.s_id = a.s_id JOIN dbo.Course ON Course.c_id = Score.c_id WHERE Score.s_id=@s_id
ELSE
SELECT '��ѧ��δ�μӿ���'
END 
GO 

EXEC proc_test5 1




--����һ���洢����
--���������ÿҳ��ʾ������pageSize(m) ҳ��pageNum(n)
--�����������ҳ��
--��ѯ����Ӧҳ��Ľ����
--��ҳ��ÿҳ��ʾ��������
IF EXISTS(SELECT * FROM sys.objects WHERE name='proc_test6'AND TYPE='p')
DROP PROC proc_test6
go
CREATE PROC proc_test6
@pageNum INT=1,@pageSize INT=3,@pagecount DECIMAL(18,2) output
AS 
BEGIN 
	SELECT * FROM(SELECT TOP (@pageNum*@pageSize) *,ROW_NUMBER()OVER(ORDER BY s_id) AS rownum FROM dbo.Student) temp WHERE temp.rownum BETWEEN	(@pageNum-@pageSize)*3+@pageSize AND @pageNum*@pageSize ORDER BY temp.rownum
	SELECT  @pagecount= COUNT(1)/(@pageSize*1.00 )FROM dbo.Student
	IF (SUBSTRING(CAST(@pagecount AS NVARCHAR(10)),CHARINDEX('.',@pagecount)+1,LEN(@pagecount))>0)
	set @pagecount=@pagecount+1 
END
GO	

DECLARE	@pagecount INT
EXEC dbo.proc_test6 1,3, @pagecount OUTPUT -- int
SELECT @pagecount AS ��ҳ��



SELECT * FROM (SELECT *,DENSE_RANK()OVER(PARTITION BY a.c_name ORDER BY b.s_name) AS rank FROM dbo.Course a , dbo.Student b ) temp WHERE temp.rank=1 