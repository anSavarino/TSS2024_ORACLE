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
    
    
-- report con media salariale e numero di dipendenti per ogni città

select d.loc, avg(e.sal) media_sal, count(e.empno)num_impiegati
from emp e right join dept d
on e.deptno = d.deptno
group by d.loc;

-- report matricola,nome, salario del dipendente e del suo superiore, un flag per indicare se soo nella stessa località
-- filtrata per anno di assunzione del dipendente o del superiore
select 
    e.empno, e.ename, e.sal, s.empno mat_sup, s.ename nome_sup, s.sal "Salario del superiore", decode(de.loc, ds.loc, 'S', 'N') check_loc
from 
    emp e, emp s, dept de, dept ds
where 
    e.mgr = s.empno and 
    e.deptno = de.deptno and 
    s.deptno = ds.deptno and
    (e.hiredate between TO_DATE('01012020', 'DDMMYYYY') and TO_DATE('31122020', 'DDMMYYYY') or to_char(s.hiredate, 'yyyy')='2020');


create table REGIONI(
    CODREG number(2),
    DENOM VARCHAR2(50),
    RIPART VARCHAR2(20));

alter table REGIONI
add constraint pk PRIMARY KEY(CODREG);
desc REGIONI;

create table PROVINCE(
    CODPROV VARCHAR2(2),
    DENOM VARCHAR2(50),
    FLAG_GM VARCHAR2(2),
    CODREG number(2)
);

alter table PROVINCE
add CONSTRAINT pk_province PRIMARY KEY(CODPROV);

alter table PROVINCE
add CONSTRAINT fk FOREIGN KEY(CODREG) REFERENCES REGIONI(CODREG);

create table LOAD_REG_PV(
    CODREG VARCHAR2(100),
    DEN_REG VARCHAR2(100),
    RIPART VARCHAR2(100),
    DEN_PROV VARCHAR2(100),
    DEN_CM VARCHAR2(100),
    COD_PROV VARCHAR2(100)
);

insert into load_reg_pv(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) 
VALUES ('1', 'PIEMONTE', 'NORD-OVEST', '-', 'TORINO', 'TO');  

select * from LOAD_REG_PV;

INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('1','PIEMONTE','NORD-OVEST','-','Torino','TO');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('1','PIEMONTE','NORD-OVEST','Vercelli','','VC');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('1','PIEMONTE','NORD-OVEST','Novara','','NO');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('1','PIEMONTE','NORD-OVEST','Cuneo','','CN');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('1','PIEMONTE','NORD-OVEST','Asti','','AT');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('1','PIEMONTE','NORD-OVEST','Alessandria','','AL');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('1','PIEMONTE','NORD-OVEST','Biella','','BI');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('1','PIEMONTE','NORD-OVEST','Verbano-Cusio-Ossola','','VB');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('2','VALLE D''AOSTA/VALLÉE D''AOSTE','NORD-OVEST','Valle d''Aosta/Vallée d''Aoste','','AO');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('3','LOMBARDIA','NORD-OVEST','Varese','','VA');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('3','LOMBARDIA','NORD-OVEST','Como','','CO');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('3','LOMBARDIA','NORD-OVEST','Sondrio','','SO');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('3','LOMBARDIA','NORD-OVEST','-','Milano','MI');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('3','LOMBARDIA','NORD-OVEST','Bergamo','','BG');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('3','LOMBARDIA','NORD-OVEST','Brescia','','BS');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('3','LOMBARDIA','NORD-OVEST','Pavia','','PV');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('3','LOMBARDIA','NORD-OVEST','Cremona','','CR');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('3','LOMBARDIA','NORD-OVEST','Mantova','','MN');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('3','LOMBARDIA','NORD-OVEST','Lecco','','LC');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('3','LOMBARDIA','NORD-OVEST','Lodi','','LO');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('3','LOMBARDIA','NORD-OVEST','Monza e della Brianza','','MB');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('4','TRENTINO-ALTO ADIGE/SÜDTIROL','NORD-EST','Bolzano/Bozen','','BZ');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('4','TRENTINO-ALTO ADIGE/SÜDTIROL','NORD-EST','Trento','','TN');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('5','VENETO','NORD-EST','Verona','','VR');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('5','VENETO','NORD-EST','Vicenza','','VI');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('5','VENETO','NORD-EST','Belluno','','BL');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('5','VENETO','NORD-EST','Treviso','','TV');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('5','VENETO','NORD-EST','-','Venezia','VE');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('5','VENETO','NORD-EST','Padova','','PD');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('5','VENETO','NORD-EST','Rovigo','','RO');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('6','FRIULI-VENEZIA GIULIA','NORD-EST','Udine','','UD');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('6','FRIULI-VENEZIA GIULIA','NORD-EST','Gorizia','','GO');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('6','FRIULI-VENEZIA GIULIA','NORD-EST','Trieste','','TS');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('6','FRIULI-VENEZIA GIULIA','NORD-EST','Pordenone','','PN');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('7','LIGURIA','NORD-OVEST','Imperia','','IM');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('7','LIGURIA','NORD-OVEST','Savona','','SV');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('7','LIGURIA','NORD-OVEST','-','Genova','GE');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('7','LIGURIA','NORD-OVEST','La Spezia','','SP');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('8','EMILIA-ROMAGNA','NORD-EST','Piacenza','','PC');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('8','EMILIA-ROMAGNA','NORD-EST','Parma','','PR');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('8','EMILIA-ROMAGNA','NORD-EST','Reggio nell''Emilia','','RE');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('8','EMILIA-ROMAGNA','NORD-EST','Modena','','MO');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('8','EMILIA-ROMAGNA','NORD-EST','-','Bologna','BO');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('8','EMILIA-ROMAGNA','NORD-EST','Ferrara','','FE');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('8','EMILIA-ROMAGNA','NORD-EST','Ravenna','','RA');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('8','EMILIA-ROMAGNA','NORD-EST','Forlì-Cesena','','FC');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('8','EMILIA-ROMAGNA','NORD-EST','Rimini','','RN');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('9','TOSCANA','CENTRO','Massa-Carrara','','MS');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('9','TOSCANA','CENTRO','Lucca','','LU');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('9','TOSCANA','CENTRO','Pistoia','','PT');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('9','TOSCANA','CENTRO','-','Firenze','FI');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('9','TOSCANA','CENTRO','Livorno','','LI');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('9','TOSCANA','CENTRO','Pisa','','PI');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('9','TOSCANA','CENTRO','Arezzo','','AR');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('9','TOSCANA','CENTRO','Siena','','SI');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('9','TOSCANA','CENTRO','Grosseto','','GR');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('9','TOSCANA','CENTRO','Prato','','PO');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('10','UMBRIA','CENTRO','Perugia','','PG');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('10','UMBRIA','CENTRO','Terni','','TR');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('11','MARCHE','CENTRO','Pesaro e Urbino','','PU');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('11','MARCHE','CENTRO','Ancona','','AN');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('11','MARCHE','CENTRO','Macerata','','MC');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('11','MARCHE','CENTRO','Ascoli Piceno','','AP');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('11','MARCHE','CENTRO','Fermo','','FM');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('12','LAZIO','CENTRO','Viterbo','','VT');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('12','LAZIO','CENTRO','Rieti','','RI');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('12','LAZIO','CENTRO','-','Roma','RM');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('12','LAZIO','CENTRO','Latina','','LT');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('12','LAZIO','CENTRO','Frosinone','','FR');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('13','ABRUZZO','SUD','L''Aquila','','AQ');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('13','ABRUZZO','SUD','Teramo','','TE');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('13','ABRUZZO','SUD','Pescara','','PE');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('13','ABRUZZO','SUD','Chieti','','CH');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('14','MOLISE','SUD','Campobasso','','CB');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('14','MOLISE','SUD','Isernia','','IS');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('15','CAMPANIA','SUD','Caserta','','CE');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('15','CAMPANIA','SUD','Benevento','','BN');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('15','CAMPANIA','SUD','-','Napoli','NA');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('15','CAMPANIA','SUD','Avellino','','AV');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('15','CAMPANIA','SUD','Salerno','','SA');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('16','PUGLIA','SUD','Foggia','','FG');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('16','PUGLIA','SUD','-','Bari','BA');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('16','PUGLIA','SUD','Taranto','','TA');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('16','PUGLIA','SUD','Brindisi','','BR');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('16','PUGLIA','SUD','Lecce','','LE');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('16','PUGLIA','SUD','Barletta-Andria-Trani','','BT');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('17','BASILICATA','SUD','Potenza','','PZ');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('17','BASILICATA','SUD','Matera','','MT');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('18','CALABRIA','SUD','Cosenza','','CS');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('18','CALABRIA','SUD','Catanzaro','','CZ');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('18','CALABRIA','SUD','Reggio di Calabria','','RC');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('18','CALABRIA','SUD','Crotone','','KR');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('18','CALABRIA','SUD','Vibo Valentia','','VV');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('19','SICILIA','ISOLE','Trapani','','TP');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('19','SICILIA','ISOLE','Palermo','','PA');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('19','SICILIA','ISOLE','Messina','','ME');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('19','SICILIA','ISOLE','Agrigento','','AG');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('19','SICILIA','ISOLE','Caltanissetta','','CL');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('19','SICILIA','ISOLE','Enna','','EN');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('19','SICILIA','ISOLE','Catania','','CT');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('19','SICILIA','ISOLE','Ragusa','','RG');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('19','SICILIA','ISOLE','Siracusa','','SR');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('20','SARDEGNA','ISOLE','Sassari','','SS');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('20','SARDEGNA','ISOLE','Nuoro','','NU');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('20','SARDEGNA','ISOLE','Cagliari','','CA');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('20','SARDEGNA','ISOLE','Oristano','','OR');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('20','SARDEGNA','ISOLE','Olbia-Tempio','','OT');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('20','SARDEGNA','ISOLE','Ogliastra','','OG');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('20','SARDEGNA','ISOLE','Medio Campidano','','VS');
INSERT INTO LOAD_REG_PV(CODREG, DEN_REG, RIPART, DEN_PROV, DEN_CM, COD_PROV) VALUES ('20','SARDEGNA','ISOLE','Carbonia-Iglesias','','CI');

select distinct CODREG, DEN_REG, RIPART from LOAD_REG_PV;

select * from REGIONI;

INSERT INTO REGIONI(CODREG, DENOM, RIPART) (select distinct CODREG, DEN_REG, RIPART from LOAD_REG_PV);

SELECT COD_PROV, DEN_PROV, DEN_CM , CODREG FROM load_reg_pv;

alter table province
add constraint fk_codreg_regioni
foreign key (codreg)
references regioni(codreg);

-- alter table province
-- drop constraint fk

select constraint_name, constraint_type
from user_constraints
where table_name = 'PROVINCE';

select * from province;

insert into province (codprov, denom, codreg) 
select distinct rownum, load.DEN_PROV, r.codreg
from regioni r
inner join load_reg_pv load
on r.codreg = load.codreg;

--non riesco poi a recuperare il riferimento se uso rownum

--if non c'è il trattino, inserisci X in flag_cm
-- poi fai il replace del trattino e mettici den_CM

UPDATE PROVINCE p
set flag_gm = 'x'
where denom <> '-';

update province p
set p.denom = replace(p.denom, '-', (select l.den_cm from load_reg_pv where p.denom LIKE '%-%' AND p.codreg = l.codreg));
-- non funziona, restituisce più di una riga
select * from province
where denom = '-';

update province p
set p.denom = (select l.den_cm from load_reg_pv l where to_number(l.cod_prov)= p.codprov)
where p.denom = '-';

--TODO
select distinct l.den_cm from load_reg_pv l, province p where to_number(l.codreg) = p.codreg and den_prov = '-';

select *from province;


--Venerdì 05/04
select e.ename
from emp e
-- where e.deptno in (select deptno from dept where loc = 'New York'); - la subquery restituisce l'array 10, 50, 81, 82 come da slide 8
-- l'alternativa è usare exists
where exists (select l from dept d where d.deptno = e.deptno and loc = 'New York'); -- per ogni riga di emp va a cercare in dept, beneficio che non deve scorrere tutta la tabella. testare se esiste l'elemento collegaato
-- esempio: clienti e ordini. Se chiedo se il cliente A ha degli ordini,nella tabella degli ordini, al primo ordine che si trova associato ad A, è un check vedere se esiste un collegamento
-- where not exists, in cui non trova nessun valore

select loc from dept d, emp e where d.deptno = e.deptno and loc = 'New York';

create table emp_bck as select * from emp; --backup

-- slide 14 MERGE
-- se esiste già un campo bonus a quella riga dipendente cambia il valore, se dopo l'aggiornamento riga 7 il bonus è troppo alto lo elimino quel record, se not matched fa un insert

--ESERCIZIO
-- creare le tabelle di backup emp_bkp e dept_bkp
create table emp_bkp as select * from emp;
create table dept_bkp as select * from dept;

-- aggiungere i dipartimenti 60 / TORINO / FORMAZIONE E ? / SALES / IN OGNI CITTA' DOVE MANCA
INSERT INTO dept(deptno, loc, dname)
values(60, 'TORINO', 'FORMAZIONE');

INSERT INTO dept
(SELECT (SELECT MAX(deptno) FROM dept) + ROWNUM, 'SALES', loc
FROM dept
WHERE loc NOT IN (SELECT loc FROM dept WHERE dname = 'SALES'));

select * from dept
order by deptno;

-- come gli calcolo deptno 
-- 60 + rownum * 10;
-- (select max(deptno) from dept) + rownum * 10;

-- aggiungere 3 dipendenti su torino con salario 800 e ruolo 'student' , data di assunzione oggi
select * from emp;

INSERT INTO emp(empno, ename, job, hiredate, sal, deptno)
VALUES (7700, 'STIFFI', 'STUDENT', SYSDATE, 800, (SELECT d.deptno
FROM dept d
WHERE d.loc = 'TORINO'));
-- non funzia, rifare

INSERT INTO emp(empno, ename, job, hiredate, sal, deptno)
VALUES(7732, 'STEFAN', 'STUDENT', sysdate, 800, 60);

INSERT INTO emp(empno, ename, job, hiredate, sal, deptno)
VALUES(7733, 'PIPPO', 'STUDENT', SYSDATE, 800, 60);

INSERT INTO emp(empno, ename, job, hiredate, sal, deptno)
VALUES(7734, 'FLAUTO', 'STUDENT', SYSDATE, 800, 60);

-- stefan e pippo assunti come salesman su dallas e new york, il nuovo salario è 1100, il suepriroe è il manager del dipartimento
UPDATE emp e
SET job = 'SALESMAN', sal = 1100, deptno = (SELECT deptno FROM dept WHERE loc = 'DALLAS'  AND dname = 'SALES'), mgr = (SELECT empno FROM emp e WHERE job = 'MANAGER' AND deptno = (SELECT deptno FROM dept WHERE loc = 'DALLAS'  AND dname = 'SALES'))
WHERE empno = 7732;

UPDATE emp e
SET job = 'SALESMAN', sal = 1100, deptno = (SELECT deptno FROM dept WHERE loc = 'NEW YORK'  AND dname = 'SALES'), mgr = (SELECT empno FROM emp e WHERE job = 'MANAGER' AND deptno = (SELECT deptno FROM dept WHERE loc = 'NEW YORK' AND dname = 'SALES'))
WHERE empno = 7733;


-- REP: per ogni dipartimento conteggio delle risorse, e il delta salariale (minimo e massimo differenza)
select d.deptno, d.dname, d.loc, COUNT(e.empno), MAX(e.sal)-MIN(e.sal) Delta
from emp e
right join dept d
on d.deptno = e.deptno
group by d.deptno, d.dname, d.loc;

-- REP: nome, matricola, salario di ogni dipendente e del suo eventuale diretto superiore + il delta della fascia salariale tra i due
SELECT
    i.ename, i.empno, i.sal,
    s.ename, s.empno, s.sal,
    si.grade - ss.grade AS Delta
FROM emp i
LEFT JOIN emp s
ON i.mgr = s.empno
JOIN salgrade si
ON i.sal
BETWEEN si.losal AND si.hisal
JOIN SALGRADE ss
ON s.sal
BETWEEN ss.losal AND ss.hisal;

-- VISTA: per tutti gli impiegati mostrare questo testo: L'impiegato King, con ruolo presidente, lavora a New York e guadagna <sal+comm> dollari
CREATE OR REPLACE VIEW vista_impiegato AS 
SELECT 'L''impiegato ' || INITCAP(e.ename) || ', con ruolo ' || LOWER(e.job) || 
(SELECT ', lavora a ' || INITCAP(d.loc) 
FROM dept d
WHERE d.deptno = e.deptno)
|| ' e guadagna ' || to_number(e.sal + nvl(e.comm,0)) || '$.'
AS vista_imp
FROM emp e
JOIN dept d
ON d.deptno = e.deptno;

select * from emp;
select * from vista_impiegato;


--Lezione 19/04 Recupero?

create table tlog(
    id number(6), 
    gravita number(1), 
    argomento varchar2(20), 
    testo varchar2(400));

alter table tlog add constraint pk primary key(id);

create sequence seq_tlog
    start with 1
    increment by 1;

--create procedure p_log(pl_grav, pl_arg, pl_text)is;
create or replace trigger tr_tlog_ai
    before insert on tlog
        for each row
begin
    if :new.id is null then
        select seq_tlog.nextval into :new.id from dual;
    end if;
end;
/

create or replace procedure p_log(p1_grav number, p1_arg varchar2, p1_text varchar2)
    is
        pragma autonomous_transaction;
begin --bisogna gestire i casi limite
    insert into tlog(gravita, argomento, testo) 
        values(p1_grav, p1_arg, p1_text);
    commit;
end;
/

begin
    execute immediate 'truncate table prova';
    insert into prova(t,n,d) values('AAA', 123, sysdate);
    p_log(1, 'prova', 'test transazione autonoma');
    rollback;
end;
/
select * from prova; --vuota
select * from tlog; --nuovo record

-- pr_emp_sal_upd(p1_mat, p1_delta, p1_segno) numero,numero,testo
-- loggin dell'operazione con esito
-- l'aumento o la diminuzione non possono superare il 10% del salario corrente

create or replace procedure pr_emp_sal_upd(p1_mat number, p1_delta number, p1_segno varchar2)
    is
    sal_ora emp.sal%type;
    exc_segno exception;
    begin
        select sal into sal_ora from emp where empno = p1_mat;
        if p1_segno not in ('+', '-') then
            raise exc_segno;
        end if;
        if sal_ora*0.1 >= p1_delta then
            update emp set sal = sal + decode(p1_segno, '+',1,'-', -1)*p1_delta where empno=p1_mat;
             p_log(0,'emp sal upd', 'emp' || p1_mat || 'salaraio aggiornato');
             commit;
        else
            p_log(1,'emp sal upd', 'emp' || p1_mat || 'superatoil 10%');
        end if;
        
        exception 
            when no_data_found then
                p_log(5,'emp sal upd', 'emp' || p1_mat || 'inesistente');
            when exc_segno then
                 p_log(3,'emp sal upd', 'emp' || p1_mat || 'segno errato = ' || p1_segno);
    end;

--pr_rep_aumenti(p1_deptno, p1_perc)
--inserisce in prova una riga per ogni dipendente del dipartimento indicando nuovo e vecchio salario
--più una riga con il confronto tra i totali
--n =>deptno
--t =>testo descritto
--d => data elaborazione
create or replace procedure pr_rep_aumenti(p1_deptno number, p1_percent number)
as
tot_new number:=0;
tot_old number:=0;
cursor cur (p_id number) as select * from emp where deptno = p_id;
rec cur%rowtype;
begin --aggiungere controlli su percentuale, esistenza del departimento
    open cur(p1_deptno);
    loop
        fetch into rec;
        exit when cur%notfound;
        insert into prova(n,t,d) values(p1_eptno, rec.empno || ':' || rec.sal ||'>' || rec.sal*(1+p1_percent));
        tot_new = tot_new + rec.sal*(1+p1_percent);
        tot_old = tot_old + rec.sal;
    end loop;
    close cur;
    insert into prova(n,t,d) values(p1_deprno, 'tot_sal:' || '>' || tot_new);
    commit;
   
end;
            