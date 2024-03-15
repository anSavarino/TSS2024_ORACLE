options (errors = 0,skip=1)
LOAD DATA
into table scott.prova
truncate
(
  N	   position(1 : 13) "to_number(:N    ,'9999999999D9999','NLS_NUMERIC_CHARACTERS='',.''')",
  T	   position(14 : 28),
  D    position(29 : 38) "to_date(:D,'dd/mm/yyyy')"
)
