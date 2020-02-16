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

/* !! At the start each connection if no other isolation level is set, it's 
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

/* !! Notice we get the uncommited version of the row. */

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

/* !! BLOCKED */

--conn 3
exec sp_WhoIsActive @get_locks = 1

-- conn1
commit tran

-- conn2 
/* !! UNBLOCKED */

--------------------------------------------------------------------------------
-- 3 repeatable read
--------------------------------------------------------------------------------
-- conn1
set transaction isolation level repeatable read

begin tran
	select * from users where id = 1

-- conn2
	update users set name = 'ZZ' where id = 1

/* !! BLOCKED */

--conn 3
exec sp_WhoIsActive @get_locks = 1

-- conn1
	select * from users where id = 1 -- same result as in 1st select
commit tran

-- conn2
/* !! UNBLOCKED */

--------------------------------------------------------------------------------
-- 4 serializable
--------------------------------------------------------------------------------
-- conn1
set transaction isolation level serializable;

begin tran
	select * from users where id = 1

-- conn2
insert into Users 
	(Id, Name, Guid, DateLog, Reputation)
	values
	(1,'AA', newid(), '20190102', 3)

/* !! BLOCKED */
-- on lower isolation levels, the INSERT would not be blocked

-- conn1
-- gets the same result as in the 1st SELECT (no phantom reads)
	select * from users where id = 1
commit tran

-- conn2
/* !! UNBLOCKED */

--------------------------------------------------------------------------------
-- 5 snapshot
--------------------------------------------------------------------------------
alter database foo set allow_snapshot_isolation on
-- conn1
begin tran
	update users set name = 'ZZ' where id = 1
	select * from users where id = 1

-- conn2
set transaction isolation level snapshot
	
begin tran	
	select * from users where id = 1

/* !! NO BLOCKING */
-- the data retrieved is of the time the transaction started;

-- conn1
commit tran

-- conn2
	select * from users where id = 1

-- still getting old value

commit tran

	select * from users where id = 1

-- now we get the new value
set transaction isolation level read committed	
--------------------------------------------------------------------------------
-- 6 committed snapshot
--------------------------------------------------------------------------------
alter database foo set allow_snapshot_isolation on 
alter database foo set read_committed_snapshot on

-- conn1
begin tran
	update users set name = 'FF' where id = 1
	select * from users where id = 1

-- conn2
begin tran	
	select * from users where id = 1

/* !! NO BLOCKING */
-- the data retrieved is of the time the transaction started

-- conn1
commit tran

-- conn2
	select * from users where id = 1
commit tran

-- got new updated value

--------------------------------------------------------------------------------
-- appendix 1
-- isolation level of current session
--------------------------------------------------------------------------------
SELECT CASE transaction_isolation_level 
	WHEN 0 THEN 'Unspecified' 
	WHEN 1 THEN 'ReadUncommitted' 
	WHEN 2 THEN 'ReadCommitted' 
	WHEN 3 THEN 'Repeatable' 
	WHEN 4 THEN 'Serializable' 
	WHEN 5 THEN 'Snapshot' 
	END 
FROM sys.dm_exec_sessions 
WHERE session_id = @@SPID
