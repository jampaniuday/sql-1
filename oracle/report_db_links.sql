set linesize 140
set pagesize 999
column owner format a20
column db_link format a20
column username format a20
column host format a80
BREAK ON owner
SET HEADING OFF
SELECT ' ----------- DB Links for '|| db_unique_name ||' database ------------ ' FROM v$database;
SET HEADING ON
SELECT owner, db_link, username, host FROM dba_db_links ORDER by 1,2;
