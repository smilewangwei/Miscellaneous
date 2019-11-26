--创建学生表
--CREATE TABLE dbo.Student
--(
--    s_id int,
--    s_name varchar(20) not NULL default '',
--	s_biryh varchar(20) not null default '',
--	s_sex varchar(20) not null default '',
--	primary key(s_id)
--);
--插入学生表测试数据
--insert into Student values('01' , '赵雷' , '1990-01-01' , '男');
--insert into Student values('02' , '钱电' , '1990-12-21' , '男');
--insert into Student values('03' , '孙风' , '1990-05-20' , '男');
--insert into Student values('04' , '李云' , '1990-08-06' , '男');
--insert into Student values('05' , '周梅' , '1991-12-01' , '女');
--insert into Student values('06' , '吴兰' , '1992-03-01' , '女');
--insert into Student values('07' , '郑竹' , '1989-07-01' , '女');
--insert into Student values('08' , '王菊' , '1990-01-20' , '女');

--创建课程表
--create table dbo.Course
--(
--	c_id varchar(20),
--	c_name varchar(20) not null default '',
--	t_id varchar(20) not null default ''
--	primary key(c_id)
--)
----课程表测试数据
--insert into Course values('01' , '语文' , '02');
--insert into Course values('02' , '数学' , '01');
--insert into Course values('03' , '英语' , '03');

----创建教师表
--create table dbo.Teacher
--(
--	t_id varchar(20),
--	t_name varchar(20) not null default '',
--	primary key(t_id)
--)
----教师表测试数据
--insert into Teacher values('01' , '张三');
--insert into Teacher values('02' , '李四');
--insert into Teacher values('03' , '王五');
----创建成绩表
--create table dbo.Score
--(
--	s_id varchar(20),
--	t_id varchar(20),
--	s_score int,
--	primary key (s_id,t_id)
--)

----成绩表测试数据
--insert into Score values('01' , '01' , 80);
--insert into Score values('01' , '02' , 90);
--insert into Score values('01' , '03' , 99);
--insert into Score values('02' , '01' , 70);
--insert into Score values('02' , '02' , 60);
--insert into Score values('02' , '03' , 80);
--insert into Score values('03' , '01' , 80);
--insert into Score values('03' , '02' , 80);
--insert into Score values('03' , '03' , 80);
--insert into Score values('04' , '01' , 50);
--insert into Score values('04' , '02' , 30);
--insert into Score values('04' , '03' , 20);
--insert into Score values('05' , '01' , 76);
--insert into Score values('05' , '02' , 87);
--insert into Score values('06' , '01' , 31);
--insert into Score values('06' , '03' , 34);
--insert into Score values('07' , '02' , 89);
--insert into Score values('07' , '03' , 98);




-- 1、查询"01"课程比"02"课程成绩高的学生的信息及课程分数
----表关联,单独找到所有学生的01课程和02课程的数据,再判断01课程的大于02课程的数据
SELECT  A.* ,
        B.s_score AS [01] ,
        C.s_score AS [02]
FROM    [test].[dbo].[Student] A ,
        [test].[dbo].[Score] B ,
        [test].[dbo].[Score] C
WHERE   A.s_id = B.s_id
        AND B.s_id = C.s_id
        AND B.c_id = '01'
        AND C.c_id = '02'
        AND B.s_score > C.s_score;
----实现思路 先找到所有学生的01课程,再找到所有学生的02课程,对齐其学生的课程进行大小判断的出结论,使用join关联表的方式
SELECT  a.* ,b.s_score AS [01] , c.s_score AS [02]
FROM dbo.Student a LEFT JOIN dbo.Score b ON a.s_id = b.s_id AND b.c_id = '01' LEFT JOIN dbo.Score c ON a.s_id = c.s_id AND c.c_id = '02' WHERE   b.s_score > c.s_score;

-- 2、查询"01"课程比"02"课程成绩低的学生的信息及课程分数

--方法一
SELECT  a.* ,
        b.s_score AS [01] ,
        c.s_score AS [02]
FROM    dbo.Student a ,
        dbo.Score b ,
        dbo.Score c
WHERE   a.s_id = b.s_id
        AND a.s_id = c.s_id
        AND b.c_id = '01'
        AND c.c_id = '02'
        AND b.s_score < c.s_score;
--方法二
SELECT  a.* ,
        b.s_score AS [01] ,
        c.s_score AS [02]
FROM    dbo.Student a
        LEFT JOIN dbo.Score b ON a.s_id = b.s_id
                                 AND b.c_id = '01'
        LEFT JOIN dbo.Score c ON a.s_id = c.s_id
                                 AND c.c_id = '02'
WHERE   b.s_score < c.s_score;

-- 3、查询平均成绩大于等于60分的同学的学生编号和学生姓名和平均成绩
SELECT b.s_id,c.s_name, AVG(b.s_score) AS avg_score FROM dbo.[Course] a,dbo.[Score] b,dbo.[Student] c
WHERE a.c_id=b.c_id AND b.s_id=c.s_id GROUP BY b.s_id,c.s_name HAVING AVG(b.s_score)>=60 ORDER BY b.s_id
--GROUP>HAVING>UNION>ORDER
SELECT c.s_id,c.s_name,AVG(a.s_score) AS avg_score FROM	 dbo.Score a LEFT JOIN dbo.Score b ON a.c_id=b.c_id LEFT JOIN  dbo.Student c ON c.s_id=a.s_id  GROUP BY c.s_id,c.s_name HAVING AVG(a.s_score)>=60 ORDER BY c.s_id 

-- 4,查询平均成绩小于60分的同学的学生编号和学生姓名和平均成绩
		-- (包括有成绩的和无成绩的)
SELECT b.s_id,c.s_name,AVG(b.s_score) AS avg_score FROM dbo.Course a,dbo.Score b,dbo.Student c
WHERE	a.c_id=b.c_id AND b.s_id=c.s_id GROUP BY b.s_id,c.s_name HAVING AVG(b.s_score)<60 
UNION --链接两句sql
SELECT s_id,s_name,0 AS avg_score  FROM	dbo.Student WHERE s_id NOT IN (SELECT s_id FROM dbo.Score)

-- 5、查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩
SELECT  a.s_id,a.s_name,COUNT(b.c_id)AS  sum_course,SUM(b.s_score) AS sum_score FROM dbo.Student a LEFT JOIN dbo.Score b
on a.s_id=b.s_id GROUP BY a.s_id,a.s_name


-- 6、查询"李"姓老师的数量 
SELECT COUNT(*) AS [COUNT] FROM dbo.Teacher where t_name like '李%'
-- 7、查询学过"张三"老师授课的同学的信息 
SELECT c.s_name,c.s_biryh,c.s_sex FROM dbo.Teacher a,dbo.Course b,dbo.Student c,dbo.Score d
WHERE a.t_id=b.t_id AND b.c_id =d.c_id AND c.s_id=d.s_id AND a.t_name='张三'

SELECT c.s_id,c.s_score,d.s_name,d.s_biryh,d.s_sex FROM dbo.Teacher a LEFT JOIN dbo.Course b ON b.t_id = a.t_id LEFT JOIN dbo.Score c ON c.c_id = b.c_id LEFT JOIN dbo.Student d ON d.s_id = c.s_id WHERE a.t_name='张三'


-- 8、查询没学过"张三"老师授课的同学的信息 ----------------------------------------------------

SELECT a.t_id, a.t_name, c.s_id,d.s_name,d.s_biryh,d.s_sex FROM dbo.Teacher a,dbo.Course b,dbo.Score c,dbo.Student d
WHERE a.t_id=b.t_id AND b.c_id=c.c_id AND c.s_id=d.s_id AND a.t_name!= '张三'

select * from 
    student c 
    where c.s_id not in(
        select a.s_id from student a join score b on a.s_id=b.s_id where b.c_id in(
        select a.c_id from course a join teacher b on a.t_id = b.t_id where t_name ='张三'));


-- 9、查询学过编号为"01"并且也学过编号为"02"的课程的同学的信息
SELECT c.* FROM dbo.Score a,dbo.Score b,dbo.Student c
WHERE A.s_id=C.s_id AND B.s_id=C.s_id AND a.c_id='01'AND b.c_id='02'
-- 10、查询学过编号为"01"但是没有学过编号为"02"的课程的同学的信息
SELECT * FROM dbo.Student a WHERE a.s_id IN (SELECT s_id FROM dbo.Score WHERE c_id='01') AND a.s_id NOT IN (SELECT s_id FROM dbo.Score WHERE c_id='02')

-- 11、查询没有学全所有课程的同学的信息 
SELECT  c.s_name FROM dbo.Course a join dbo.Score b ON b.c_id = a.c_id RIGHT join dbo.Student c ON c.s_id = b.s_id
 GROUP BY c.s_name HAVING COUNT(a.c_id)<(SELECT COUNT(DISTINCT c_id) FROM dbo.Course)

select *
from student
where s_id not in(
select s_id from score t1  
group by s_id having count(*) =(select count(distinct c_id)  from course)) 


-- 12、查询至少有一门课与学号为"01"的同学所学相同的同学的信息 
SELECT * FROM dbo.Student a WHERE a.s_id IN (SELECT DISTINCT a.s_id FROM dbo.score a WHERE a.c_id IN(
 SELECT a.c_id FROM dbo.Score a WHERE a.s_id='01'))


-- 13、查询和"01"号的同学学习的课程完全相同的其他同学的信息 
SELECT  *
FROM    dbo.Student
WHERE   s_id IN ( SELECT    s_id
                  FROM      dbo.Score
                  WHERE     c_id IN ( SELECT    a.c_id
                                      FROM      dbo.Score a
                                      WHERE     a.s_id = '01' )
                  GROUP BY  s_id
                  HAVING    COUNT(c_id) = ( SELECT  COUNT(a.c_id)
                                            FROM    dbo.Score a
                                            WHERE   a.s_id = '01'
                                          ) )
        AND s_id NOT IN ( '01' )
	

-- 14、查询没学过"张三"老师讲授的任一门课程的学生姓名
SELECT * FROM dbo.Student WHERE s_id NOT IN (
SELECT s_id FROM dbo.Score WHERE c_id IN (
SELECT c_id FROM dbo.Course WHERE t_id IN (
SELECT t_id FROM dbo.Teacher WHERE t_name='张三')))


-- 15、查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩 
SELECT * FROM dbo.Student a RIGHT JOIN (SELECT s_id,AVG(s_score)AS avg_score FROM dbo.Score WHERE s_score<60 GROUP BY s_id HAVING COUNT(c_id)>=2) b ON b.s_id = a.s_id

-- 16、检索"01"课程分数小于60，按分数降序排列的学生信息
SELECT * FROM dbo.Student a RIGHT JOIN (SELECT * FROM dbo.Score WHERE s_score<60 AND c_id='01') b  ON b.s_id = a.s_id ORDER BY b.s_score DESC

-- 17、按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
SELECT a.s_id,b.s_name,
(SELECT s_score FROM dbo.Score WHERE c_id='01' AND s_id=a.s_id) AS '语文',
(SELECT s_score FROM dbo.Score WHERE s_id=a.s_id AND c_id='02') AS '数学',
(SELECT s_score FROM dbo.Score WHERE s_id=a.s_id AND c_id='03') AS '英语' ,
ISNULL(AVG(a.s_score),0)AS '平均分'
FROM dbo.Score a RIGHT	JOIN dbo.Student b ON b.s_id = a.s_id GROUP BY a.s_id,b.s_name ORDER BY AVG(a.s_score) desc

ROUND(100*(SUM(case when a.s_score>=70 and a.s_score<=80 then 1 else 0 end)/SUM(case when a.s_score then 1 else 0 end)),2) as 中等率,

-- 18.查询各科成绩最高分、最低分和平均分：以如下形式显示：课程ID，课程name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率
--及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90
select a.c_id,a.c_name,max(b.s_score) as 最高分,
min(b.s_score) as 最低分,
avg(b.s_score) as 平均分,
sum(case when b.s_score>=60 then 1 else 0 end )*100,
count(1),
cast(100.0*sum(case when b.s_score>=60 then 1 else 0 end)/count(1) as float) as 及格率,
cast(100.0*sum(case when b.s_score>=70 and b.s_score<=80 then 1  else 0 end )/count(1) as float) as 中等率,
cast(100.0* sum(case when b.s_score>=80 and b.s_score<=90 then 1 else 0 end)/count(1) as float) as 优良率,
cast(100.0*sum(case when b.s_score>=90 then 1 else 0 end)/count(1) as float) as 优秀率
from dbo.course a left join dbo.score b on b.c_id = a.c_id group by a.c_id,a.c_name
--方法二
select a.c_id,b.c_name,MAX(s_score),MIN(s_score),ROUND(AVG(s_score),2),
	CAST(CAST(100.0*SUM(case when a.s_score>=60 then 1 else 0 end)/count(1) AS DECIMAL(18,2)) AS NVARCHAR(20))+'%' as 及格率,
	CAST(CAST(100.0*SUM(case when a.s_score>=70 and a.s_score<=80 then 1 else 0 end)/count(1) AS DECIMAL(18,2)) AS NVARCHAR(20))+'%' as 中等率,
	CAST(CAST(100.0*SUM(case when a.s_score>=80 and a.s_score<=90 then 1 else 0 end)/count(1) AS DECIMAL(18,2)) AS NVARCHAR(20))+'%' as 优良率,
	CAST(CAST(100.0*SUM(case when a.s_score>=90 then 1 else 0 end)/count(1) AS DECIMAL(18,2)) AS NVARCHAR(20))+'%' as 优秀率
from score a left join course b on a.c_id = b.c_id GROUP BY a.c_id,b.c_name

-- 19、按各科成绩进行排序，并显示排名
select  b.c_name,s_score,rank()over( partition by b.c_name order by a.s_score desc) as ro from dbo.score a left join dbo.course b on b.c_id = a.c_id group  by b.c_name,a.s_score

-- 20、查询学生的总成绩并进行排名
SELECT *,RANK()OVER(ORDER BY c.sum_score desc) AS 排名 FROM (SELECT a.s_name,ISNULL(SUM(b.s_score),0) AS sum_score FROM dbo.Student a LEFT JOIN dbo.Score b ON a.s_id=b.s_id GROUP BY a.s_name) c 

-- 21、查询不同老师所教不同课程平均分从高到低显示 
SELECT c.t_name,b.c_name,AVG(a.s_score) AS 平均分 FROM dbo.Score a RIGHT JOIN dbo.Course b ON a.c_id=b.c_id RIGHT JOIN teacher c ON c.t_id=b.t_id GROUP BY c.t_name,b.c_name ORDER BY 平均分 DESC

-- 22、查询所有课程的成绩第2名到第3名的学生信息及该课程成绩
SELECT * FROM (
SELECT *,RANK()OVER(PARTITION BY d.c_name ORDER BY d.Score DESC	) AS rownumber FROM (SELECT a.s_name,c.c_name,SUM(b.s_score) AS Score FROM dbo.Student a LEFT JOIN dbo.Score b ON a.s_id=b.s_id LEFT JOIN dbo.Course c ON c.c_id=b.c_id
GROUP BY a.s_name,c.c_name) d ) e WHERE e.rownumber IN (2,3) ORDER BY e.c_name


-- 23、统计各科成绩各分数段人数：课程编号,课程名称,[100-85],[85-70],[70-60],[0-60]及所占百分比
SELECT DISTINCT a.c_id, a.c_name,
SUM(CASE WHEN b.s_score<=100 AND b.s_score>85 THEN 1 ELSE 0 END ) AS [100-85数量],
100.0*SUM(CASE WHEN b.s_score<=100 AND b.s_score>85 THEN 1 ELSE 0 END)/COUNT(1) AS [100-85],
SUM(CASE WHEN b.s_score<=85 AND b.s_score>70 THEN 1 ELSE 0 END ) AS [85-70数量],
100.0*SUM(CASE WHEN b.s_score<=85 AND b.s_score>70 THEN 1 ELSE 0 END)/COUNT(1) AS [85-70],
SUM(CASE WHEN b.s_score<=70 AND b.s_score>60 THEN 1 ELSE 0 END ) AS [70-60数量],
100.0*SUM(CASE WHEN b.s_score<=70 AND b.s_score>60 THEN 1 ELSE 0 END)/COUNT(1) AS [70-60],
SUM(CASE WHEN b.s_score<=60 AND b.s_score>0 THEN 1 ELSE 0 END ) AS [0-60数量],
100.0*SUM(CASE WHEN b.s_score<=60 AND b.s_score>0 THEN 1 ELSE 0 END)/COUNT(1) AS [0-60],
COUNT(1) AS 总数量
 FROM dbo.Course a LEFT JOIN dbo.Score b ON b.c_id = a.c_id
GROUP BY a.c_id,a.c_name

-- 24、查询学生平均成绩及其名次 
SELECT *,RANK()OVER(ORDER BY c.Score desc) AS 名次 FROM (SELECT a.s_name,ISNULL(AVG(b.s_score),0) AS Score FROM dbo.Student a LEFT JOIN dbo.Score b ON b.s_id = a.s_id  GROUP BY a.s_name) c

-- 25、查询各科成绩前三名的记录
SELECT * FROM (SELECT *,RANK()OVER(PARTITION BY c.c_name ORDER BY c.Score desc) AS rank FROM (SELECT a.[s_id],b.c_name,SUM(a.s_score) AS Score FROM dbo.Score a LEFT JOIN dbo.Course b ON b.c_id = a.c_id
GROUP BY a.[s_id],b.c_name) c  ) d LEFT JOIN dbo.Student e ON e.s_id = d.s_id WHERE d.rank <=3

-- 26、查询每门课程被选修的学生数 
SELECT c_name, COUNT(1) FROM dbo.Score a LEFT JOIN dbo.Course b ON a.c_id=b.c_id GROUP BY c_name

-- 27、查询出只有两门课程的全部学生的学号和姓名 
SELECT * FROM (SELECT a.s_id FROM dbo.Score a LEFT JOIN course b ON b.c_id = a.c_id GROUP BY a.s_id HAVING COUNT(1)=2) c LEFT JOIN dbo.Student d ON d.s_id = c.s_id

-- 28、查询男生、女生人数 
SELECT s_sex,COUNT(1) AS 人数 FROM dbo.Student GROUP BY s_sex

-- 29、查询名字中含有"风"字的学生信息
SELECT * FROM student WHERE s_name LIKE  N'%风%'

-- 30、查询同名同性学生名单，并统计同名人数 
SELECT s_name,COUNT(s_id) AS 同名人数  FROM dbo.Student GROUP BY s_name HAVING COUNT(s_id)>1 

-- 31、查询1990年出生的学生名单
SELECT * FROM dbo.Student WHERE YEAR(s_biryh)=1990

-- 32、查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列 
SELECT b.c_name,a.c_id,AVG(a.s_score) AS avg FROM dbo.Score a LEFT JOIN dbo.Course b ON b.c_id = a.c_id GROUP BY b.c_name,a.c_id ORDER BY AVG(a.s_score) DESC, a.c_id asc

-- 33、查询平均成绩大于等于85的所有学生的学号、姓名和平均成绩 
SELECT a.s_name,a.s_id,AVG(b.s_score) AS avg FROM dbo.Student a LEFT JOIN dbo.Score b ON b.s_id = a.s_id GROUP BY a.s_name,a.s_id HAVING AVG(b.s_score)>85

-- 34、查询课程名称为"数学"，且分数低于60的学生姓名和分数 
select c.s_name,a.s_score from dbo.score a left join  course b on a.c_id=b.c_id LEFT JOIN dbo.Student c ON c.s_id = a.s_id where b.c_name=N'数学' and a.s_score<60

-- 35、查询所有学生的课程及分数情况
SELECT c.s_name,b.c_name,a.s_score FROM dbo.Score a LEFT JOIN course b ON b.c_id = a.c_id RIGHT JOIN dbo.Student c ON c.s_id = a.s_id  
--转置
SELECT  a.s_id,a.s_name,
SUM(CASE c_name  WHEN  '语文' THEN b.s_score ELSE 0 end) AS 语文,
SUM(CASE c.c_name WHEN '数学' THEN b.s_score ELSE 0 END ) AS 数学,
SUM(CASE c.c_name WHEN '英语' THEN b.s_score ELSE 0 END )AS 英语,
 SUM(b.s_score)  AS 总分 FROM dbo.Student a 
 LEFT JOIN dbo.Score b ON b.s_id = a.s_id 
 LEFT JOIN dbo.Course c ON  c.c_id = b.c_id 
 GROUP BY a.s_id,a.s_name

-- 36、查询任何一门课程成绩在70分以上的姓名、课程名称和分数；
SELECT a.s_name,c.c_name,b.s_score FROM dbo.Student a LEFT JOIN dbo.Score b ON b.s_id = a.s_id LEFT JOIN dbo.Course c ON c.c_id = b.c_id  WHERE b.s_score>=70

-- 37、查询不及格的课程
SELECT b.c_name,a.s_score FROM dbo.Score a LEFT JOIN dbo.Course b ON a.c_id=b.c_id WHERE a.s_score<60

-- 38、查询课程编号为01且课程成绩在80分以上的学生的学号和姓名； 
SELECT b.s_id,c.s_name FROM dbo.Course a LEFT JOIN dbo.Score b ON b.c_id = a.c_id RIGHT JOIN dbo.Student c ON c.s_id = b.s_id WHERE a.c_id='01' AND b.s_score>80

-- 39、求每门课程的学生人数 
SELECT a.c_name,a.c_id,COUNT(b.s_id) FROM dbo.Course a LEFT JOIN dbo.Score b ON b.c_id = a.c_id group BY a.c_name,a.c_id

-- 40、查询选修"张三"老师所授课程的学生中，成绩最高的学生信息及其成绩
--找到张三,找到张三老师最大的分数,通过关联所有信息找到张三,找到最大分数,可查询出相同分数的学生
select a.t_name,d.s_name,d.s_sex,d.s_biryh,c.s_score from teacher  a left join dbo.course b on b.t_id = a.t_id left join dbo.score c on c.c_id = b.c_id left join dbo.student d on d.s_id = c.s_id where a.t_name='张三' and c.s_score in (select max(s_score) as max from dbo.score where c_id=(select b.c_id from dbo.teacher a,dbo.course b where a.t_id=b.t_id and a.t_name='张三'))

-- 41、查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩 
--通过两张相同的成绩表,找到分数相同学生id不同的信息,去除重复后得出所有的信息
select distinct b.s_id,b.c_id,b.s_score from dbo.score a,dbo.score b where a.c_id!=b.c_id and a.s_score=b.s_score	
select distinct a.s_id,a.c_id,a.s_score from dbo.score a,dbo.score b where a.c_id!=b.c_id and a.s_score=b.s_score	

-- 42、查询每门功成绩最好的前两名 
SELECT * FROM (SELECT c.c_name,c.Score,d.s_name,d.s_biryh,d.s_sex,DENSE_RANK()OVER(PARTITION BY c.c_name ORDER BY c.Score desc) AS ro FROM (SELECT a.s_id,b.c_name,SUM(a.s_score) AS Score FROM dbo.Score a,dbo.Course b WHERE a.c_id=b.c_id GROUP BY a.s_id,b.c_name) c LEFT JOIN dbo.Student d ON d.s_id = c.s_id) e WHERE e.ro<3

-- 43、统计每门课程的学生选修人数（超过5人的课程才统计）。要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列 
select b.c_name,b.c_id,count(1) as 选修人数 from dbo.score a left join dbo.course b on b.c_id = a.c_id group by b.c_name,b.c_id having count(1)>5 order by 选修人数 desc,b.c_id asc

-- 44、检索至少选修两门课程的学生学号 
SELECT c.s_name ,c.s_id ,COUNT(1)AS 选修课程 FROM dbo.Score a LEFT JOIN dbo.Course b ON b.c_id = a.c_id LEFT JOIN dbo.Student c ON	c.s_id = a.s_id GROUP BY c.s_name,c.s_id  HAVING COUNT(1)>=2 

-- 45、查询选修了全部课程的学生信息 
SELECT c.s_name,c.s_id,COUNT(1) AS 选修课程 FROM dbo.Score a LEFT JOIN dbo.Course b ON a.c_id=b.c_id LEFT JOIN dbo.Student c ON	c.s_id = a.s_id GROUP BY c.s_name,c.s_id HAVING COUNT(1)=(SELECT distinct COUNT(1) FROM dbo.Course)

-- 46、查询各学生的年龄
--YEAR(GETDATE())-YEAR(s_biryh) AS age,不够严谨实际年龄会比正常年龄偏大
	-- 按照出生日期来算，当前月日 < 出生年月的月日则，年龄减一
SELECT *,DATEDIFF(DAY,s_biryh,GETDATE())/365 AS age FROM dbo.Student

-- 47、查询本周过生日的学生
--思路:本周开始时间,本周结束时间
SELECT * FROM ( SELECT *,FORMAT(CAST(s_biryh AS DATETIME),'MM-dd') AS monthday FROM dbo.Student) c WHERE c.monthday BETWEEN	FORMAT(DATEADD(WEEK,DATEDIFF(WEEK,0,GETDATE()),0),'MM-dd') AND FORMAT(DATEADD(WEEK,DATEDIFF(WEEK,0,GETDATE()),6),'MM-dd')
--本周开始时间,结束时间
SELECT DATEADD(WEEK,DATEDIFF(WEEK,0,GETDATE()),0),DATEADD(WEEK,DATEDIFF(WEEK,0,GETDATE()),6)
--本周开始时间是地几天,结束时间是地几天
SELECT DATEPART(DAYOFYEAR,DATEADD(WEEK,DATEDIFF(WEEK,0,GETDATE()),0)) AS 本周第一天,DATEPART(DAYOFYEAR,GETDATE()),DATEPART(DAYOFYEAR,DATEADD(WEEK,DATEDIFF(WEEK,0,GETDATE()),6))AS 本周最后一天

-- 48、查询下周过生日的学生
SELECT * FROM (SELECT *,FORMAT(CAST(s_biryh AS DATETIME),'MM-dd') AS monthday FROM dbo.Student) b WHERE b.monthday BETWEEN	FORMAT(DATEADD(WEEK,1,DATEADD(WEEK,DATEDIFF(WEEK,0,GETDATE()),0)),'MM-dd') AND FORMAT(DATEADD(WEEK,1,DATEADD(WEEK,DATEDIFF(WEEK,0,GETDATE()),6)),'MM-dd')
--下周开始时间，结束时间
SELECT DATEADD(WEEK,1,DATEADD(WEEK,DATEDIFF(WEEK,0,GETDATE()),0)),DATEADD(WEEK,1,DATEADD(WEEK,DATEDIFF(WEEK,0,GETDATE()),6))

-- 49、查询本月过生日的学生
SELECT * FROM (SELECT *,FORMAT(CAST(s_biryh AS DATETIME),'MM') AS month FROM dbo.Student) a WHERE a.month=(FORMAT(GETDATE(),'MM'))
--本月开始时间，结束时间
SELECT DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE()),0),DATEADD(DAY,-1,DATEADD(MONTH,1,DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE()),0)))

-- 50、查询下月过生日的学生
SELECT * FROM (SELECT *,FORMAT(CAST(s_biryh AS DATETIME),'MM') AS month FROM dbo.Student) a WHERE a.month=(FORMAT(DATEADD(MONTH,1,GETDATE()),'MM'))
--下个月开始时间，结束时间
SELECT DATEADD(MONTH,1,DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE()),0)),DATEADD(DAY,-1,DATEADD(MONTH,2,DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE()),0)))

USE test
SELECT  [c_id],[c_name],[t_id]FROM [test].[dbo].[Course] --课程表
SELECT  [s_id],[c_id],[s_score]FROM [test].[dbo].[Score] --成绩表
SELECT  [s_id],[s_name],[s_biryh],[s_sex]FROM [test].[dbo].[Student] --学生表
SELECT  [t_id],[t_name]FROM [test].[dbo].[Teacher] --老师表


--练习时间：2019-11-26 17:14