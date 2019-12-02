--存储过程

USE test
SELECT * FROM dbo.Student

----全局变量写法
 --删除存储过程
DROP PROC StuProc

--外部变量
go
CREATE PROC StuProc 
@s_name varchar(100)
AS
    BEGIN
        SELECT  *FROM dbo.Student WHERE s_name=@s_name
    END
 GO
--EXEC 关键字触发存储过程
EXEC StuProc '赵雷'

--删除存储过程
DROP PROC StudentProc
--内部变量写法
CREATE PROC StudentProc
@s_name varchar(100)='钱电'
AS
BEGIN
SELECT * FROM dbo.Student WHERE s_name=@s_name
END
GO

EXEC StudentProc

--输出变量内容
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
EXEC StudentProc1 '赵雷',@Is_Right OUTPUT
SELECT @Is_Right


----局部变量
CREATE PROC StudentProc
AS 
DECLARE @s_name VARCHAR(100)
SET @s_name='赵雷'
BEGIN 
SELECT * FROM student WHERE s_name=@s_name
END
GO

EXEC StudentProc


--显示局部便变量
CREATE PROC StudentProc
AS 
BEGIN 
DECLARE @s_name varchar(100)
SET @s_name=(SELECT s_name FROM student WHERE s_id IN (01))
SELECT @s_name
END
GO

EXEC StudentProc


----详细练习

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

EXEC dbo.Proc_InsertEmployee @name = N'大大', -- nvarchar(10)
    @sex = '女', -- varchar(10)
    @biryh = '1989-07-01' -- datetime

select * FROM dbo.Student


EXEC sys.sp_databases	


--1.基本存储过程
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
--2.创建不同版本的存储过程
IF EXISTS(SELECT * FROM sysobjects WHERE name='proc_stud'AND type='p')
	DROP PROC proc_stud
GO
CREATE PROC proc_stud;1
AS 
BEGIN 
	SELECT * FROM dbo.Student WHERE s_sex='男'
END
GO
CREATE	 PROC proc_stud;2
AS
BEGIN 
	SELECT * FROM dbo.Student WHERE s_sex='女'
END
GO 

EXEC dbo.proc_stud;1
EXEC dbo.proc_stud;2
EXEC dbo.proc_stud


--带参数的存储过程
IF EXISTS(SELECT * FROM sys.objects WHERE name='proc_stud' AND type='p')
DROP PROC proc_stud
GO	
CREATE PROC proc_stud
@name varchar(10)='默认',
@birht DATE='2019-01-01',
@sex VARCHAR(10)='男'
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

EXEC dbo.proc_stud	@name='dada',@birht='1991-01-11',@sex='女'
EXEC dbo.proc_stud



--带输出参数的存储过程
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
EXEC dbo.proc_stud '男',@count OUTPUT
SELECT @count AS 性别为男的数量

SELECT * FROM dbo.Student
DELETE FROM dbo.Student WHERE s_id>8



--存储过程的返回状态
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



--修改存储过程

go
--启动sql server时自动执行存储过程
CREATE PROC procStud
AS
BEGIN 
	SELECT * FROM dbo.Student
END
GO

--消息 15398，级别 11，状态 1，过程 sp_procoption，第 73 行
--只有 dbo 拥有的 master 数据库中的对象才能更改启动设置。
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






























--练习:
--创建一个存储过程，查询学生表中所有信息，并打印学生总数,平均年龄
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


--创建一个存储过程，统计男生和女生的数量，以输出参数返回
GO
CREATE PROC proc_test3
@num1 INT OUT,
@num2 INT OUTPUT
AS
BEGIN 
	SELECT @num1= COUNT(1) FROM dbo.Student WHERE s_sex='男'
	SELECT @num2= COUNT(1) FROM dbo.Student WHERE s_sex='女'
END
GO 

DECLARE	@num1 INT ,@num2 INT 
EXEC dbo.proc_test3 @num1 OUT, -- int
    @num2 OUTPUT -- int
	PRINT '性别男的数量'+ CAST(@num1 AS VARCHAR(10))+',性别女的数量'+CAST(@num2 AS VARCHAR(10))



--创建一个存储过程，输入一个学生的学号和课程编号，查询学生的成绩
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

 


 --1创建一个存储过程，根据输入的学号查询这个学生是否参加考试，如果参加考试则打印出
--学生姓名、考试科目名称、对应成绩，如果没有参加考试则提示此学生未参加考试
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
SELECT '此学生未参加考试'
END 
GO 

EXEC proc_test5 1




--创建一个存储过程
--输入参数：每页显示的条数pageSize(m) 页码pageNum(n)
--输出参数：总页数
--查询出对应页码的结果集
--分页：每页显示三条数据
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
SELECT @pagecount AS 总页数



SELECT * FROM (SELECT *,DENSE_RANK()OVER(PARTITION BY a.c_name ORDER BY b.s_name) AS rank FROM dbo.Course a , dbo.Student b ) temp WHERE temp.rank=1 