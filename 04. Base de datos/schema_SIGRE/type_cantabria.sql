-------------------------------------------------------
-- Export file for user CANTABRIA@HADES              --
-- Created by jramirez on 15/05/2026, 08:07:49 p. m. --
-------------------------------------------------------

set define off
spool type_cantabria.log

prompt
prompt Creating type SPLIT_TBL
prompt =======================
prompt
CREATE OR REPLACE TYPE CANTABRIA."SPLIT_TBL"                                                                                                                                                                                                                                                                                                     as TABLE OF VARCHAR2(32767)
/


spool off
