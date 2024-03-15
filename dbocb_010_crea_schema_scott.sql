connect sys/manager as sysdba

alter session set "_ORACLE_SCRIPT"=true;

CREATE USER scott IDENTIFIED BY tiger;

CREATE USER scott_app IDENTIFIED BY app;

GRANT create session TO scott;
GRANT create table TO scott;
GRANT create view TO scott;
GRANT create any trigger TO scott;
GRANT create any procedure TO scott;
GRANT create sequence TO scott;
GRANT create synonym TO scott;

GRANT create session TO scott_app;
GRANT create synonym TO scott_app;

CREATE ROLE operatore;

CREATE USER scott_ro IDENTIFIED BY ro;

GRANT create session TO operatore;

GRANT operatore TO scott_ro;

ALTER USER scott QUOTA 100M ON users;
ALTER USER scott_app QUOTA 100M ON users;
ALTER USER scott_ro QUOTA 100M ON users;
 
GRANT UNLIMITED TABLESPACE TO scott;

