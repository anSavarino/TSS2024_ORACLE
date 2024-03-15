OPTIONS (errors = 1, skip=1)
LOAD DATA

INTO TABLE SCOTT.PROVA
TRUNCATE
FIELDS TERMINATED BY ';' Optionally enclosed by '"'
(
N "to_number(:N    ,'9999999999D9999','NLS_NUMERIC_CHARACTERS='',.''')",
T,
D "to_date(:D,'dd/mm/yyyy')"
)
