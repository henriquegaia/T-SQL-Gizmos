--playground

set statistics io on

-- 1/5
use foo
--set statistics io on
--set statistics time on

-- pages used by table
--dbcc ind('foo', Users, -1 )

-- see contents of page 
--dbcc traceon(3604)
--dbcc page('foo', 1, 4 , 3)
--dbcc traceoff(3604)

--select * from Users
--where id = 3

-- see cols used by all indexes on table
--alter table users
--add [Guid] UNIQUEIDENTIFIER primary key default NEWID()

--------------------------------------------------------------------------------
-- 1
--select id from users
--2
select id from Users
where guid like '%a%'
--3
select id from Users
where guid like '%a%'
order by id
--4
select * from dbo.Users
--where guid like N'%a%'
order by id

--dbcc show_statistics('dbo.users', 'id')

select * from sys.objects where name like 'users%'

drop table if exists dbo.Users2;
select * into dbo.Users2 from dbo.Users
--------------------------------------------------------------------------------
--set statistics io on
set statistics time on
declare @t table (Id int ,Val varchar(100))
insert into @t values (1,'brent'), (2,'hrm'), (3,'kendra')
select * from @t option(recompile)
go
--------------------------------------------------------------------------------
drop table #t2
create table #t2 (Id int ,Val varchar(100))
insert into #t2 values (1,'brent'), (2,'hrm'), (3,'kendra')
select * from #t2 
go
--------------------------------------------------------------------------------
drop index if exists IX_DateLog_Id on Users
set statistics io on
select id, name from dbo.Users
where datelog > '20170101'
order by datelog
--0.014677
--------------------------------------------------------------------------------
create index IX_DateLog_Id on Users(DateLog, Id)
set statistics io on
select id, [name] from dbo.Users
where datelog > '20170101'
order by datelog
--0.014677
--------------------------------------------------------------------------------
--declare @n int = 462
--declare @name char(2) 
--while @n <> 1000 
--begin
--	set @name = char((rand()*25 + 65))+char((rand()*25 + 65))
--	insert into Users(Id, Name, Guid, DateLog) values
--	(@n, @name, newid(), getdate())
--	set @n = @n + 1
--end
--------------------------------------------------------------------------------
--declare @FromDate date = '01/01/2017'
--declare @ToDate date = '30/11/2019'

select convert(	datetime2,
				dateadd(day, 
					rand(checksum(newid()))*(1+datediff(day, @FromDate, @ToDate)), 
					@FromDate),
				103);

--update users
--set DateLog = convert(	datetime2,
--						dateadd(day, 
--						   rand(checksum(newid()))*(1+datediff(day, @FromDate, @ToDate)), 
--						   @FromDate),
--						103);
--------------------------------------------------------------------------------
create index IX_DateLog_Id_Name on Users(DateLog, Id) include ([Name])
--set statistics io on
select id, [name] from dbo.Users
where datelog > '20170101'
order by datelog
--------------------------------------------------------------------------------
select id from dbo.Users
where datelog > '20170101'
order by datelog



