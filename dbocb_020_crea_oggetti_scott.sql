-- --------------------------------------
connect scott/tiger


begin
    execute immediate 'DROP TABLE SALE CASCADE CONSTRAINTS';
exception
        when others then
            null;
end;            
/

begin
    execute immediate 'DROP TABLE EMP_BACKUP CASCADE CONSTRAINTS';
exception
        when others then
            null;
end;            
/

begin
    execute immediate 'DROP TABLE BONUS CASCADE CONSTRAINTS';
exception
        when others then
            null;
end;            
/

begin
    execute immediate 'DROP TABLE EMP CASCADE CONSTRAINTS';
exception
        when others then
            null;
end;            
/

begin
    execute immediate 'DROP TABLE DEPT CASCADE CONSTRAINTS';
exception
        when others then
            null;
end;            
/

begin
    execute immediate 'DROP TABLE SALGRADE CASCADE CONSTRAINTS';
exception
        when others then
            null;
end;            
/

begin
    execute immediate 'DROP SEQUENCE EMP_SEQ';
exception
        when others then
            null;
end;            
/

begin
    execute immediate 'DROP SEQUENCE DEPT_SEQ';
exception
        when others then
            null;
end;            
/

begin
    execute immediate 'DROP TABLE PROVA CASCADE CONSTRAINTS';
exception
        when others then
            null;
end;            
/

CREATE TABLE DEPT
(
  DEPTNO  NUMBER(2),
  DNAME   VARCHAR2(14 BYTE),
  LOC     VARCHAR2(13 BYTE)
)
/

CREATE SEQUENCE dept_seq INCREMENT BY 1
/

CREATE SEQUENCE emp_seq INCREMENT BY 1
/

CREATE OR REPLACE TRIGGER dept_trg1
              before insert ON DEPT
              for each row
begin
                  if :new.deptno is null then
                      select dept_seq.nextval into :new.deptno from sys.dual;
                 end if;
end;
/

ALTER TABLE DEPT ADD (
  PRIMARY KEY
  (DEPTNO))
/

CREATE TABLE EMP
(
  EMPNO     NUMBER(4)                           NOT NULL,
  ENAME     VARCHAR2(10 BYTE),
  JOB       VARCHAR2(9 BYTE),
  MGR       NUMBER(4),
  HIREDATE  DATE,
  SAL       NUMBER(7,2),
  COMM      NUMBER(7,2),
  DEPTNO    NUMBER(2)
)
/

CREATE OR REPLACE TRIGGER emp_trg1
              before insert ON EMP
              for each row
begin
                  if :new.empno is null then
                      select emp_seq.nextval into :new.empno from sys.dual;
                 end if;
end;
/

ALTER TABLE EMP ADD (
  PRIMARY KEY
  (EMPNO))
/  

ALTER TABLE EMP ADD (
  FOREIGN KEY (MGR)
  REFERENCES EMP (EMPNO)
  ENABLE VALIDATE,
  FOREIGN KEY (DEPTNO)
  REFERENCES DEPT (DEPTNO)
  ENABLE VALIDATE)
/  

CREATE TABLE SALGRADE
(
  GRADE     NUMBER(2)                           NOT NULL,
  LOSAL     NUMBER(7,2),
  HISAL     NUMBER(7,2)
)
/

CREATE TABLE BONUS
(
  EMPNO     NUMBER(4)                           NOT NULL,
  BONUS       NUMBER(7,2)
)
/

ALTER TABLE BONUS ADD (
  PRIMARY KEY
  (EMPNO))
/  

ALTER TABLE BONUS ADD (
  FOREIGN KEY (EMPNO)
  REFERENCES EMP (EMPNO)
  ENABLE VALIDATE)
/  


insert into dept values (10,'ACCOUNTING','NEW YORK');
insert into dept values (20,'RESEARCH','DALLAS');
insert into dept values (30,'SALES','CHICAGO');
insert into dept values (40,'OPERATIONS','BOSTON');

Insert into EMP
   (EMPNO, ENAME, JOB, HIREDATE, SAL,
    DEPTNO)
 Values
   (7839, 'KING', 'PRESIDENT', TO_DATE('17/11/1981', 'DD/MM/YYYY'), 8857.81,
    10);
Insert into EMP
   (EMPNO, ENAME, JOB, MGR, HIREDATE,
    SAL, DEPTNO)
 Values
   (7698, 'BLAKE', 'MANAGER', 7839, TO_DATE('01/05/1981', 'DD/MM/YYYY'),
    5048.96, 30);
Insert into EMP
   (EMPNO, ENAME, JOB, MGR, HIREDATE,
    SAL, DEPTNO)
 Values
   (7782, 'CLARK', 'MANAGER', 7839, TO_DATE('09/06/1981', 'DD/MM/YYYY'),
    4340.34, 10);
Insert into EMP
   (EMPNO, ENAME, JOB, MGR, HIREDATE,
    SAL, DEPTNO)
 Values
   (7566, 'JONES', 'MANAGER', 7839, TO_DATE('02/04/1981', 'DD/MM/YYYY'),
    5270.4, 20);
Insert into EMP
   (EMPNO, ENAME, JOB, MGR, HIREDATE,
    SAL, DEPTNO)
 Values
   (7788, 'SCOTT', 'ANALYST', 7566, TO_DATE('09/12/1982', 'DD/MM/YYYY'),
    5314.68, 20);
Insert into EMP
   (EMPNO, ENAME, JOB, MGR, HIREDATE,
    SAL, DEPTNO)
 Values
   (7902, 'FORD', 'ANALYST', 7566, TO_DATE('03/12/1981', 'DD/MM/YYYY'),
    5314.68, 20);
Insert into EMP
   (EMPNO, ENAME, JOB, MGR, HIREDATE,
    SAL, DEPTNO)
 Values
   (7369, 'SMITH', 'CLERK', 7902, TO_DATE('17/12/1980', 'DD/MM/YYYY'),
    1714.88, 20);
Insert into EMP
   (EMPNO, ENAME, JOB, MGR, HIREDATE,
    SAL, COMM, DEPTNO)
 Values
   (7499, 'ALLEN', 'SALESMAN', 7698, TO_DATE('20/02/1981', 'DD/MM/YYYY'),
    2834.5, 300, 30);
Insert into EMP
   (EMPNO, ENAME, JOB, MGR, HIREDATE,
    SAL, COMM, DEPTNO)
 Values
   (7521, 'WARD', 'SALESMAN', 7698, TO_DATE('22/02/1981', 'DD/MM/YYYY'),
    2214.45, 500, 30);
Insert into EMP
   (EMPNO, ENAME, JOB, MGR, HIREDATE,
    SAL, COMM, DEPTNO)
 Values
   (7654, 'MARTIN', 'SALESMAN', 7698, TO_DATE('28/09/1981', 'DD/MM/YYYY'),
    2214.45, 1400, 30);
Insert into EMP
   (EMPNO, ENAME, JOB, MGR, HIREDATE,
    SAL, COMM, DEPTNO)
 Values
   (7844, 'TURNER', 'SALESMAN', 7698, TO_DATE('08/09/1981', 'DD/MM/YYYY'),
    2657.35, 0, 30);
Insert into EMP
   (EMPNO, ENAME, JOB, MGR, HIREDATE,
    SAL, DEPTNO)
 Values
   (7876, 'ADAMS', 'CLERK', 7788, TO_DATE('12/01/1983', 'DD/MM/YYYY'),
    1948.72, 20);
Insert into EMP
   (EMPNO, ENAME, JOB, MGR, HIREDATE,
    SAL, DEPTNO)
 Values
   (7900, 'JAMES', 'CLERK', 7698, TO_DATE('03/12/1981', 'DD/MM/YYYY'),
    1682.99, 30);
Insert into EMP
   (EMPNO, ENAME, JOB, MGR, HIREDATE,
    SAL, DEPTNO)
 Values
   (7934, 'MILLER', 'CLERK', 7782, TO_DATE('23/01/1982', 'DD/MM/YYYY'),
    2303.03, 10);

insert into salgrade values (1, 0, 1000);
insert into salgrade values (2, 1000.01, 2000);
insert into salgrade values (3, 2000.01, 3000);
insert into salgrade values (4, 3000.01, 4000);
insert into salgrade values (5, 4000.01, 5000);
insert into salgrade values (6, 5000.01, 6000);
insert into salgrade values (7, 6000.01, 7000);
insert into salgrade values (8, 7000.01, 8000);
insert into salgrade values (9, 8000.01, 9000);
insert into salgrade values (10, 9000.01, 99999.99);

commit;

CREATE TABLE PROVA
(
  N  NUMBER(10,4),
  T  VARCHAR2(50 BYTE),
  D  DATE
)
/

CREATE OR REPLACE PROCEDURE pr_prova_ins (pi_n NUMBER)
AS
BEGIN
	insert into prova (n, t, d)
	values (pi_n, user, sysdate);
	Commit;
END; 
/


GRANT SELECT ON prova TO scott_app WITH GRANT OPTION;

GRANT EXECUTE ON pr_prova_ins TO scott_app;

connect scott_app/app

GRANT SELECT ON scott.prova TO scott_ro;

connect sys/manager as sysdba

GRANT ALL ON scott.prova TO scott_ro;


