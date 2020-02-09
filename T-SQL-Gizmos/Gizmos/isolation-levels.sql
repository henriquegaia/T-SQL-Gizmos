-- isolation-levels
/*
( From lowest to highest )
1 read uncommitted
2 read committed 
3 repeatable read
4 serializable
5 snapshot
6 read committed snapshot
*/

/* ?? At the start each connection if no other isolation level is set, it's 
assummed the use of READ COMMITTED. */

--------------------------------------------------------------------------------
-- 1 read uncommitted
--------------------------------------------------------------------------------
-- conn1
begin tran
	update users set name = 'ZZ' where id = 1
	select * from users where id = 1

-- conn2
set transaction isolation level read uncommitted

select * from users where id = 1

/* ?? Notice we get the uncommited version of the row. */

-- conn1
rollback tran

--------------------------------------------------------------------------------
-- 2 read committed
--------------------------------------------------------------------------------
-- conn1
begin tran
	update users set name = 'ZZ' where id = 1
	select * from users where id = 1

-- conn2
set transaction isolation level read committed

select * from users where id = 1

/* ?? BLOCKED */

--conn 3
exec sp_WhoIsActive @get_locks = 1

-- conn1
commit tran

-- conn2 
/* ?? UNBLOCKED */

--------------------------------------------------------------------------------
-- 3 repeatable read
--------------------------------------------------------------------------------
-- conn1
set transaction isolation level repeatable read

begin tran
	select * from users where id = 1

-- conn2
	update users set name = 'ZZ' where id = 1

/* ?? BLOCKED */

--conn 3
exec sp_WhoIsActive @get_locks = 1

-- conn1
	select * from users where id = 1 -- same result as in 1st select
commit tran

-- conn2
/* ?? UNBLOCKED */

--------------------------------------------------------------------------------
-- 4 serializable
--------------------------------------------------------------------------------
-- conn1
