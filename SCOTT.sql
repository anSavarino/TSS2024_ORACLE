select * FROM dept;

BEGIN
    dbms_output.put_line('ciao');
END;
/

CREATE TABLE prova2(n number(2));

create or replace trigger tr_prova2_ai
    before insert on prova2
    for each row
begin
    insert into prova(t, n, d) values ('inserimento', :new.n, sysdate);
end;
/

insert into prova2 (n) values (4);

select * from emp;


select 
    lpad(deptno, 2, 0) || --compensa il valore con 0
    rpad(upper(translate(ename, 'XAEIOU','X')), 4, 'X') ||
    to_char(hiredate, 'YY')||
    decode(job, 'MANAGER', 1, 'PRESIDENTE', 1,0)
    AS Matricola_Aziendale
from emp;

select
    e.ename, 
    (NVL(e.sal, 0) + NVL(e.comm,0)) guadagno, 
    TO_CHAR(e.hiredate,'YYYY-MM-DD') assunzione, 
    e.deptno dipartimento
from emp e, dept d
where 
    e.deptno = d.deptno 
    and 
    d.loc IN ('DALLAS','NEW YORK');

--Per ogni dipartimento esporre minimo,masimoe media salariale, la località,il codice dipartimento e il nmero di dipendenti
select 
    d.deptno Num_Dip,
    d.loc Località, 
    e.job,
    min(e.sal) Minimo, 
    max(e.sal) Massimo, 
    avg(e.sal) Media, 
    count(e.empno) Num_Impiegati
from emp e, dept d 
where e.deptno = d.deptno (+)
group by e.job, d.deptno, d.loc;

--per ogni dipendente il salario e la differenza tra il suo salario e la media salariale del suo ruolo
select e.empno, e.sal, e.job, (e.sal - SQ1.media) diff
from 
    emp e,
    (select 
        avg(sal) media, 
        job 
    from emp 
    group by job) SQ1
where 
    e.job = SQ1.job;

select 
    e.empno, 
    e.sal, 
    e.sal - (select avg(sal)from emp SQ1 where e.job=SQ1.job) delta
from emp e;

--matricola e nome del dipendente e del superiore per i dipartimenti in cui è presente almeno un salesman
select 
    dip.empno, 
    dip.ename, 
    sup.empno, 
    sup.ename 
from emp dip, emp sup
where 
    dip.mgr = sup.empno (+)
    and
    dip.deptno in(select deptno from emp where job='SALESMAN');
    
select 
    dip.empno, 
    dip.ename, 
    sup.empno, 
    sup.ename,
    gd.grade - gs.grade grade_diff
from emp dip, emp sup, salgrade gd, salgrade gs
where 
    dip.mgr = sup.empno (+)
    and
    dip.sal between gd.losal and gd.hisal
    and
    sup.sal between gs.losal and gs.hisal;
    