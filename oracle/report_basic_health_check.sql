set pagesize 999
set feedback off
set heading off
select '========== ACTIVE SERVICES ==========' from dual;
set heading on
column name format a30
select inst_id, name
from gv$active_services
where name not like 'SYS%'
order by 1;

set heading off
select '========== BLOCKING LOCKS ==========' from dual;
set heading on
column "BLOCKER COUNT" format 999999999
SELECT "BLOCKER COUNT" FROM(
select count(
   blocker.sid
) "BLOCKER COUNT"
from (select *
      from gv$lock
      where block != 0
      and type = 'TX') blocker
,    gv$lock            waiting
where waiting.type='TX' 
and waiting.block = 0
and waiting.id1 = blocker.id1
);

set heading off
select '========== BLOCKING SESSIONS ==========' from dual;
set heading on
select
   blocker.sid blocker_sid
,  waiting.sid waiting_sid
,  TRUNC(waiting.ctime/60) min_waiting
,  waiting.request
from (select *
      from gv$lock
      where block != 0
      and type = 'TX') blocker
,    gv$lock            waiting
where waiting.type='TX' 
and waiting.block = 0
and waiting.id1 = blocker.id1;

set heading off
select '========== SESSIONS COUNT ==========' from dual;
set heading on
select 'ACTIVE SESSIONS' "SESSIONS", count(1) "COUNT"
from v$session
where status='ACTIVE'
UNION ALL
select 'INACTIVE SESSIONS', count(1) "COUNT"
from v$session
where status='INACTIVE';

set heading off
select '========== INTERNAL SESSIONS COUNT ==========' from dual;
set heading on
select 'ACTIVE SESSIONS' "SESSIONS", count(1) "COUNT"
from v$session
where status='ACTIVE'
and username in ('SYS','SYSTEM','DBSNMP')
UNION ALL
select 'INACTIVE SESSIONS', count(1) "COUNT"
from v$session
where status='INACTIVE'
and username in ('SYS','SYSTEM','DBSNMP')
;
