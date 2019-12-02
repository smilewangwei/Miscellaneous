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

--insert into Student (Sno,Sname,Ssex,Sbirthday,Class) values('108',N'����',N'��','1977-09-01','95033');
--insert into Student (Sno,Sname,Ssex,Sbirthday,Class) values('105',N'����',N'��','1975-10-02','95031');
--insert into Student (Sno,Sname,Ssex,Sbirthday,Class) values('107',N'����',N'Ů','1976-01-23','95033');
--insert into Student (Sno,Sname,Ssex,Sbirthday,Class) values('101',N'���',N'��','1976-02-20','95033');
--insert into Student (Sno,Sname,Ssex,Sbirthday,Class) values('109',N'����',N'Ů','1975-02-10','95031');
--insert into Student (Sno,Sname,Ssex,Sbirthday,Class) values('103',N'½��',N'��','1974-06-03','95031');
--insert into Course values('3-105',N'���������','825');
--insert into Course values('3-245',N'����ϵͳ','804');
--insert into Course values('6-166',N'���ֵ�·','856');
--insert into Course values('9-888',N'�ߵ���ѧ','831');
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
--insert into Teacher values('804',N'���',N'��','1958-12-02',N'������',N'�����ϵ');
--insert into Teacher values('856',N'����',N'��','1969-03-12',N'��ʦ',N'���ӹ���ϵ');
--insert into Teacher values('825',N'��Ƽ',N'Ů','1972-05-05',N'����',N'�����ϵ');
--insert into Teacher values('831',N'����',N'Ů','1977-08-14',N'����',N'���ӹ���ϵ');



--1. ��ѯStudent���е����м�¼��Sname.Ssex��Class�С�
select sname,ssex,class from [dbo].[student]
--2. ��ѯ��ʦ���еĵ�λ�����ظ���Depart�С�
select distinct depart from teacher
--3. ��ѯStudent������м�¼��
select * from student
--4. ��ѯScore���гɼ���60��80֮������м�¼��
select * from score where degree>60 and degree<80
--5. ��ѯScore���гɼ�Ϊ85��86��88�ļ�¼��
select * from (select sno,cno,cast(degree as int) as degree from score) a where a.degree in (86,85) or a.degree=88 
--6. ��ѯStudent���С�95031������Ա�Ϊ��Ů����ͬѧ��¼��
select * from student where class=95031 or ssex='Ů'
--7. ��Class�����ѯStudent������м�¼��
SELECT * FROM student ORDER BY class desc
--8. ��Cno����.Degree�����ѯScore������м�¼��
SELECT * FROM score ORDER BY cno ASC,degree desc
--9. ��ѯ��95031�����ѧ��������
SELECT COUNT(1) AS [95031] FROM student WHERE class=95031
--10. ��ѯScore���е���߷ֵ�ѧ��ѧ�źͿγ̺š����Ӳ�ѯ��������
--�Ӳ�ѯ
SELECT * from score WHERE degree=(SELECT MAX(degree) from score)
--����
SELECT * FROM (SELECT *,DENSE_RANK()OVER(ORDER BY degree desc) AS rank FROM score ) a where a.rank=1
--11. ��ѯÿ�ſε�ƽ���ɼ���
select cno,cast(avg(degree) as int) as avg from score group by cno
--12.��ѯScore����������5��ѧ��ѡ�޵Ĳ���3��ͷ�Ŀγ̵�ƽ��������
select cno,cast(avg(degree) as int) as avg from score WHERE cno LIKE '3%' group by cno HAVING COUNT(1)>5
--13.��ѯ��������70��С��90��Sno�С�
SELECT distinct sno FROM score WHERE degree>70 AND degree<90
--14.��ѯ����ѧ����Sname.Cno��Degree�С�
SELECT sname, cno,degree FROM score a RIGHT JOIN student b ON a.sno=b.sno 
--15.��ѯ����ѧ����Sno.Cname��Degree�С�
SELECT sno,cname,degree FROM score a JOIN course b ON a.cno=b.cno
--16.��ѯ����ѧ����Sname.Cname��Degree�С�
SELECT sname,cname,degree FROM student a LEFT JOIN score b ON a.sno=b.sno LEFT JOIN course c ON b.cno=c.cno
--17. ��ѯ��95033����ѧ����ƽ���֡�
SELECT CAST(AVG(degree) AS INt) AS avg FROM student a LEFT JOIN score b ON a.sno=b.sno WHERE class=95033
--18. ����ʹ�������������һ��grade��
--create table grade(low  int,upp  int,rank  char(1))
--insert into grade values(90,100,'A')
--insert into grade values(80,89,'B')
--insert into grade values(70,79,'C')
--insert into grade values(60,69,'D')
--insert into grade values(0,59,'E')
--�ֲ�ѯ����ͬѧ��Sno.Cno��rank�С�
SELECT sno,cno,rank FROM score a,grade b WHERE  degree BETWEEN LOW AND upp
--19.  ��ѯѡ�ޡ�3-105���γ̵ĳɼ����ڡ�109����ͬѧ�ɼ�������ͬѧ�ļ�¼��
SELECT * FROM score WHERE cno='3-105' AND degree>(SELECT degree FROM score WHERE sno=109 AND cno='3-105')
--20.��ѯscore��ѡѧ���ſγ̵�ͬѧ�з���Ϊ����߷ֳɼ��ļ�¼��
SELECT * FROM score WHERE sno IN (SELECT sno FROM score where degree<(SELECT MAX(degree) FROM score) GROUP BY sno HAVING COUNT(1)>1)
 
--21. ��ѯ�ɼ�����ѧ��Ϊ��109��.�γ̺�Ϊ��3-105���ĳɼ������м�¼��
SELECT * FROM dbo.Student a LEFT JOIN dbo.Score b ON b.Sno = a.Sno WHERE b.Degree>(SELECT Degree FROM dbo.Score WHERE Sno=109 AND Cno='3-105')
--22.��ѯ��ѧ��Ϊ107��ͬѧͬ�����������ѧ����Sno.Sname��Sbirthday�С�
select * FROM student WHERE YEAR(Sbirthday)=(SELECT YEAR(Sbirthday) FROM dbo.Student WHERE Sno=107)
--23.��ѯ�����񡰽�ʦ�οε�ѧ���ɼ���
SELECT c.Tname,a.Degree,a.Sno FROM dbo.Score a JOIN dbo.Course b ON b.Cno = a.Cno RIGHT JOIN dbo.Teacher c ON c.Tno = b.Tno WHERE c.Tname='����'
--24.��ѯѡ��ĳ�γ̵�ͬѧ��������5�˵Ľ�ʦ������
SELECT c.Tname,COUNT(1) FROM dbo.Score a JOIN dbo.Course b ON b.Cno = a.Cno JOIN dbo.Teacher c ON c.Tno = b.Tno GROUP  BY c.Tname HAVING COUNT(1)>5
--25.��ѯ95033���95031��ȫ��ѧ���ļ�¼��
SELECT * FROM dbo.Student WHERE Class IN (95033,95031)
--26.  ��ѯ������85�����ϳɼ��Ŀγ�Cno.
SELECT DISTINCT Cno FROM dbo.Score WHERE Degree>85
--27.��ѯ���������ϵ����ʦ���̿γ̵ĳɼ���
SELECT c.Tname,c.Depart,a.Degree FROM dbo.Score a JOIN dbo.Course b ON b.Cno = a.Cno JOIN dbo.Teacher c ON c.Tno = b.Tno WHERE c.Depart ='�����ϵ'
--28.��ѯ�������ϵ���롰���ӹ���ϵ����ְͬ�ƵĽ�ʦ��Tname��Prof��
SELECT b.Tname,b.Prof FROM dbo.Course a JOIN dbo.Teacher b ON b.Tno = a.Tno WHERE b.Depart IN ('�����ϵ','���ӹ���ϵ')
--29.��ѯѡ�ޱ��Ϊ��3-105���γ��ҳɼ����ٸ���ѡ�ޱ��Ϊ��3-245����ͬѧ��Cno.Sno��Degree,����Degree�Ӹߵ��ʹ�������
SELECT * FROM dbo.Score WHERE Degree>any(SELECT Degree FROM dbo.Score WHERE Cno='3-245') AND Cno='3-105' ORDER BY Degree desc
--30.��ѯѡ�ޱ��Ϊ��3-105���ҳɼ�����ѡ�ޱ��Ϊ��3-245���γ̵�ͬѧ��Cno.Sno��Degree.
SELECT * FROM dbo.Score WHERE Degree>(SELECT MAX(Degree) FROM dbo.Score WHERE Cno='3-245') AND Cno='3-105'
--31. ��ѯ���н�ʦ��ͬѧ��name.sex��birthday.
select distinct d.tname,d.tsex,d.tbirthday,c.sname,c.ssex,c.sbirthday from dbo.score a join dbo.course b on b.cno = a.cno join dbo.student c on c.sno = a.sno join dbo.teacher d on d.tno = b.tno
--32.��ѯ���С�Ů����ʦ�͡�Ů��ͬѧ��name.sex��birthday.
select distinct d.tname,d.tsex,d.tbirthday,c.sname,c.ssex,c.sbirthday from dbo.score a join dbo.course b on b.cno = a.cno join dbo.student c on c.sno = a.sno join dbo.teacher d on d.tno = b.tno where d.tsex='Ů' and c.ssex='Ů'
--33. ��ѯ�ɼ��ȸÿγ�ƽ���ɼ��͵�ͬѧ�ĳɼ���
SELECT * FROM dbo.Score a WHERE a.Degree<(SELECT AVG(Degree) FROM dbo.Score WHERE a.Cno=Cno)
--34. ��ѯ�����ον�ʦ��Tname��Depart.
SELECT Tname,Depart FROM dbo.Teacher WHERE Tno IN (SELECT Tno FROM dbo.Course WHERE Cno IN (SELECT DISTINCT Cno FROM dbo.Score))
--35 . ��ѯ����δ���εĽ�ʦ��Tname��Depart. 
SELECT Tname,Depart FROM dbo.Teacher WHERE Tno IN (SELECT Tno FROM dbo.Course WHERE Cno not IN (SELECT DISTINCT Cno FROM dbo.Score))
--36.��ѯ������2�������İ�š�
SELECT Class FROM dbo.Student WHERE Ssex='��' GROUP BY Class HAVING COUNT(1)>1
--37.��ѯStudent���в��ա�������ͬѧ��¼��
SELECT * FROM dbo.Student WHERE Sname not LIKE '��%'
--38.��ѯStudent����ÿ��ѧ�������������䡣
SELECT *,DATEDIFF(YEAR,Sbirthday,GETDATE()) FROM student --Ϊ�β����ô˷���,������������������������Ͻ�
SELECT *,DATEDIFF(DAY,Sbirthday,GETDATE())/365 AS age FROM dbo.Student 
--39.��ѯStudent����������С��Sbirthday����ֵ��
SELECT MAX(Sbirthday) AS max,MIN(Sbirthday) AS min FROM dbo.Student
--40.�԰�ź�����Ӵ�С��˳���ѯStudent���е�ȫ����¼��
SELECT * FROM (SELECT *,DATEDIFF(DAY,Sbirthday,GETDATE())/365 AS age FROM dbo.Student) a ORDER BY a.Class desc,a.age desc
--41.��ѯ���С���ʦ�������ϵĿγ̡�
SELECT a.Tname,a.Depart,b.Cname FROM dbo.Teacher a JOIN dbo.Course b ON b.Tno = a.Tno WHERE a.Tsex='��'
--42.��ѯ��߷�ͬѧ��Sno.Cno��Degree�С�
SELECT * FROM (SELECT a.Cno,a.Degree,DENSE_RANK()OVER(ORDER BY a.Degree desc) AS rank FROM dbo.Score a JOIN dbo.Course b ON b.Cno = a.Cno) a WHERE a.rank=1
--43.��ѯ�͡������ͬ�Ա������ͬѧ��Sname.
SELECT * FROM dbo.Student WHERE Ssex=(SELECT Ssex FROM dbo.Student WHERE Sname='���')
--44.��ѯ�͡������ͬ�Ա�ͬ���ͬѧSname.
SELECT b.* FROM dbo.Student a,dbo.Student b WHERE a.Class=b.Class AND a.Ssex=b.Ssex AND a.Sname='���'
SELECT b.* FROM dbo.Teacher a ,dbo.Teacher b WHERE a.Tname='��Ƽ' AND a.Tsex=b.Tsex AND a.Prof=b.Prof
--45.��ѯ����ѡ�ޡ���������ۡ��γ̵ġ��С�ͬѧ�ĳɼ���
SELECT b.Cname,c.Ssex,c.Sname,a.Degree FROM dbo.Score a JOIN dbo.Course b ON	b.Cno = a.Cno JOIN dbo.Student c ON c.Sno = a.Sno WHERE b.Cname='���������' AND c.Ssex='��'


SELECT * FROM dbo.Student a,dbo.Student b WHERE  a.Ssex='��' AND b.Ssex='Ů'