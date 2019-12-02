--CREATE	DATABASE test2
--USE test2
--CREATE TABLE Student
--(
--Sno nvarchar(3) not null primary key,
--Sname nvarchar(8) not null,
--Ssex nvarchar(2) not null,
--Sbirthday datetime,
--Class nvarchar(5) 
--)

--CREATE	TABLE Score
--(
--Sno nvarchar(3) not null references Student(Sno),
--Cno nvarchar(5) not null references Course(Cno),
--Degree Decimal(4,1)
--)

--CREATE TABLE Course
--(
--Cno nvarchar(5) not null primary key,
--Cname nvarchar(10) not null,
--Tno nvarchar(3) not null
--)

--CREATE TABLE Teacher
--(
--Tno nvarchar(3) not null primary key,
--Tname nvarchar(4) not null,
--Tsex nvarchar(2) NOT NULL,
--Tbirthday datetime,
--Prof nvarchar(6),
--Depart nvarchar(10) not null
--)

--insert into Student (Sno,Sname,Ssex,Sbirthday,Class) values('108',N'曾华',N'男','1977-09-01','95033');
--insert into Student (Sno,Sname,Ssex,Sbirthday,Class) values('105',N'匡明',N'男','1975-10-02','95031');
--insert into Student (Sno,Sname,Ssex,Sbirthday,Class) values('107',N'王丽',N'女','1976-01-23','95033');
--insert into Student (Sno,Sname,Ssex,Sbirthday,Class) values('101',N'李军',N'男','1976-02-20','95033');
--insert into Student (Sno,Sname,Ssex,Sbirthday,Class) values('109',N'王芳',N'女','1975-02-10','95031');
--insert into Student (Sno,Sname,Ssex,Sbirthday,Class) values('103',N'陆君',N'男','1974-06-03','95031');
--insert into Course values('3-105',N'计算机导论','825');
--insert into Course values('3-245',N'操作系统','804');
--insert into Course values('6-166',N'数字电路','856');
--insert into Course values('9-888',N'高等数学','831');
--insert into Score values('103','3-245','86');
--insert into Score values('105','3-245','75');
--insert into Score values('109','3-245','68');
--insert into Score values('103','3-105','92');
--insert into Score values('105','3-105','88');
--insert into Score values('109','3-105','76');
--insert into Score values('101','3-105','64');
--insert into Score values('107','3-105','91');
--insert into Score values('108','3-105','78');
--insert into Score values('101','6-166','85');
--insert into Score values('107','6-166','79');
--insert into Score values('108','6-166','81');
--insert into Teacher values('804',N'李诚',N'男','1958-12-02',N'副教授',N'计算机系');
--insert into Teacher values('856',N'张旭',N'男','1969-03-12',N'讲师',N'电子工程系');
--insert into Teacher values('825',N'王萍',N'女','1972-05-05',N'助教',N'计算机系');
--insert into Teacher values('831',N'刘冰',N'女','1977-08-14',N'助教',N'电子工程系');



--1. 查询Student表中的所有记录的Sname.Ssex和Class列。
select sname,ssex,class from [dbo].[student]
--2. 查询教师所有的单位即不重复的Depart列。
select distinct depart from teacher
--3. 查询Student表的所有记录。
select * from student
--4. 查询Score表中成绩在60到80之间的所有记录。
select * from score where degree>60 and degree<80
--5. 查询Score表中成绩为85，86或88的记录。
select * from (select sno,cno,cast(degree as int) as degree from score) a where a.degree in (86,85) or a.degree=88 
--6. 查询Student表中“95031”班或性别为“女”的同学记录。
select * from student where class=95031 or ssex='女'
--7. 以Class降序查询Student表的所有记录。
SELECT * FROM student ORDER BY class desc
--8. 以Cno升序.Degree降序查询Score表的所有记录。
SELECT * FROM score ORDER BY cno ASC,degree desc
--9. 查询“95031”班的学生人数。
SELECT COUNT(1) AS [95031] FROM student WHERE class=95031
--10. 查询Score表中的最高分的学生学号和课程号。（子查询或者排序）
--子查询
SELECT * from score WHERE degree=(SELECT MAX(degree) from score)
--排序
SELECT * FROM (SELECT *,DENSE_RANK()OVER(ORDER BY degree desc) AS rank FROM score ) a where a.rank=1
--11. 查询每门课的平均成绩。
select cno,cast(avg(degree) as int) as avg from score group by cno
--12.查询Score表中至少有5名学生选修的并以3开头的课程的平均分数。
select cno,cast(avg(degree) as int) as avg from score WHERE cno LIKE '3%' group by cno HAVING COUNT(1)>5
--13.查询分数大于70，小于90的Sno列。
SELECT distinct sno FROM score WHERE degree>70 AND degree<90
--14.查询所有学生的Sname.Cno和Degree列。
SELECT sname, cno,degree FROM score a RIGHT JOIN student b ON a.sno=b.sno 
--15.查询所有学生的Sno.Cname和Degree列。
SELECT sno,cname,degree FROM score a JOIN course b ON a.cno=b.cno
--16.查询所有学生的Sname.Cname和Degree列。
SELECT sname,cname,degree FROM student a LEFT JOIN score b ON a.sno=b.sno LEFT JOIN course c ON b.cno=c.cno
--17. 查询“95033”班学生的平均分。
SELECT CAST(AVG(degree) AS INt) AS avg FROM student a LEFT JOIN score b ON a.sno=b.sno WHERE class=95033
--18. 假设使用如下命令建立了一个grade表：
--create table grade(low  int,upp  int,rank  char(1))
--insert into grade values(90,100,'A')
--insert into grade values(80,89,'B')
--insert into grade values(70,79,'C')
--insert into grade values(60,69,'D')
--insert into grade values(0,59,'E')
--现查询所有同学的Sno.Cno和rank列。
SELECT sno,cno,rank FROM score a,grade b WHERE  degree BETWEEN LOW AND upp
--19.  查询选修“3-105”课程的成绩高于“109”号同学成绩的所有同学的记录。
SELECT * FROM score WHERE cno='3-105' AND degree>(SELECT degree FROM score WHERE sno=109 AND cno='3-105')
--20.查询score中选学多门课程的同学中分数为非最高分成绩的记录。
SELECT * FROM score WHERE sno IN (SELECT sno FROM score where degree<(SELECT MAX(degree) FROM score) GROUP BY sno HAVING COUNT(1)>1)
 
--21. 查询成绩高于学号为“109”.课程号为“3-105”的成绩的所有记录。
SELECT * FROM dbo.Student a LEFT JOIN dbo.Score b ON b.Sno = a.Sno WHERE b.Degree>(SELECT Degree FROM dbo.Score WHERE Sno=109 AND Cno='3-105')
--22.查询和学号为107的同学同年出生的所有学生的Sno.Sname和Sbirthday列。
select * FROM student WHERE YEAR(Sbirthday)=(SELECT YEAR(Sbirthday) FROM dbo.Student WHERE Sno=107)
--23.查询“张旭“教师任课的学生成绩。
SELECT c.Tname,a.Degree,a.Sno FROM dbo.Score a JOIN dbo.Course b ON b.Cno = a.Cno RIGHT JOIN dbo.Teacher c ON c.Tno = b.Tno WHERE c.Tname='张旭'
--24.查询选修某课程的同学人数多于5人的教师姓名。
SELECT c.Tname,COUNT(1) FROM dbo.Score a JOIN dbo.Course b ON b.Cno = a.Cno JOIN dbo.Teacher c ON c.Tno = b.Tno GROUP  BY c.Tname HAVING COUNT(1)>5
--25.查询95033班和95031班全体学生的记录。
SELECT * FROM dbo.Student WHERE Class IN (95033,95031)
--26.  查询存在有85分以上成绩的课程Cno.
SELECT DISTINCT Cno FROM dbo.Score WHERE Degree>85
--27.查询出“计算机系“教师所教课程的成绩表。
SELECT c.Tname,c.Depart,a.Degree FROM dbo.Score a JOIN dbo.Course b ON b.Cno = a.Cno JOIN dbo.Teacher c ON c.Tno = b.Tno WHERE c.Depart ='计算机系'
--28.查询“计算机系”与“电子工程系“不同职称的教师的Tname和Prof。
SELECT b.Tname,b.Prof FROM dbo.Course a JOIN dbo.Teacher b ON b.Tno = a.Tno WHERE b.Depart IN ('计算机系','电子工程系')
--29.查询选修编号为“3-105“课程且成绩至少高于选修编号为“3-245”的同学的Cno.Sno和Degree,并按Degree从高到低次序排序。
SELECT * FROM dbo.Score WHERE Degree>any(SELECT Degree FROM dbo.Score WHERE Cno='3-245') AND Cno='3-105' ORDER BY Degree desc
--30.查询选修编号为“3-105”且成绩高于选修编号为“3-245”课程的同学的Cno.Sno和Degree.
SELECT * FROM dbo.Score WHERE Degree>(SELECT MAX(Degree) FROM dbo.Score WHERE Cno='3-245') AND Cno='3-105'
--31. 查询所有教师和同学的name.sex和birthday.
select distinct d.tname,d.tsex,d.tbirthday,c.sname,c.ssex,c.sbirthday from dbo.score a join dbo.course b on b.cno = a.cno join dbo.student c on c.sno = a.sno join dbo.teacher d on d.tno = b.tno
--32.查询所有“女”教师和“女”同学的name.sex和birthday.
select distinct d.tname,d.tsex,d.tbirthday,c.sname,c.ssex,c.sbirthday from dbo.score a join dbo.course b on b.cno = a.cno join dbo.student c on c.sno = a.sno join dbo.teacher d on d.tno = b.tno where d.tsex='女' and c.ssex='女'
--33. 查询成绩比该课程平均成绩低的同学的成绩表。
SELECT * FROM dbo.Score a WHERE a.Degree<(SELECT AVG(Degree) FROM dbo.Score WHERE a.Cno=Cno)
--34. 查询所有任课教师的Tname和Depart.
SELECT Tname,Depart FROM dbo.Teacher WHERE Tno IN (SELECT Tno FROM dbo.Course WHERE Cno IN (SELECT DISTINCT Cno FROM dbo.Score))
--35 . 查询所有未讲课的教师的Tname和Depart. 
SELECT Tname,Depart FROM dbo.Teacher WHERE Tno IN (SELECT Tno FROM dbo.Course WHERE Cno not IN (SELECT DISTINCT Cno FROM dbo.Score))
--36.查询至少有2名男生的班号。
SELECT Class FROM dbo.Student WHERE Ssex='男' GROUP BY Class HAVING COUNT(1)>1
--37.查询Student表中不姓“王”的同学记录。
SELECT * FROM dbo.Student WHERE Sname not LIKE '王%'
--38.查询Student表中每个学生的姓名和年龄。
SELECT *,DATEDIFF(YEAR,Sbirthday,GETDATE()) FROM student --为何不采用此方法,如果单存生日上来讲还不够严谨
SELECT *,DATEDIFF(DAY,Sbirthday,GETDATE())/365 AS age FROM dbo.Student 
--39.查询Student表中最大和最小的Sbirthday日期值。
SELECT MAX(Sbirthday) AS max,MIN(Sbirthday) AS min FROM dbo.Student
--40.以班号和年龄从大到小的顺序查询Student表中的全部记录。
SELECT * FROM (SELECT *,DATEDIFF(DAY,Sbirthday,GETDATE())/365 AS age FROM dbo.Student) a ORDER BY a.Class desc,a.age desc
--41.查询“男”教师及其所上的课程。
SELECT a.Tname,a.Depart,b.Cname FROM dbo.Teacher a JOIN dbo.Course b ON b.Tno = a.Tno WHERE a.Tsex='男'
--42.查询最高分同学的Sno.Cno和Degree列。
SELECT * FROM (SELECT a.Cno,a.Degree,DENSE_RANK()OVER(ORDER BY a.Degree desc) AS rank FROM dbo.Score a JOIN dbo.Course b ON b.Cno = a.Cno) a WHERE a.rank=1
--43.查询和“李军”同性别的所有同学的Sname.
SELECT * FROM dbo.Student WHERE Ssex=(SELECT Ssex FROM dbo.Student WHERE Sname='李军')
--44.查询和“李军”同性别并同班的同学Sname.
SELECT b.* FROM dbo.Student a,dbo.Student b WHERE a.Class=b.Class AND a.Ssex=b.Ssex AND a.Sname='李军'
SELECT b.* FROM dbo.Teacher a ,dbo.Teacher b WHERE a.Tname='王萍' AND a.Tsex=b.Tsex AND a.Prof=b.Prof
--45.查询所有选修“计算机导论”课程的“男”同学的成绩表。
SELECT b.Cname,c.Ssex,c.Sname,a.Degree FROM dbo.Score a JOIN dbo.Course b ON	b.Cno = a.Cno JOIN dbo.Student c ON c.Sno = a.Sno WHERE b.Cname='计算机导论' AND c.Ssex='男'


SELECT * FROM dbo.Student a,dbo.Student b WHERE  a.Ssex='男' AND b.Ssex='女'