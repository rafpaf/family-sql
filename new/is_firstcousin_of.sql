set sql_big_selects=1;

-- drop table is_firstcousin_of;
-- 
-- create table if not exists is_firstcousin_of like is_child_of;
-- 
-- insert into is_firstcousin_of (person_id, person_fullname, relation_id, relation_fullname)
select
distinct
nn.person_id as person_id,
nn.person_fullname as person_fullname,
c.person_id as relation_id,
c.person_fullname as relation_fullname
from is_niecenephew_of as nn
join is_child_of as c
where nn.relation_id = c.relation_id
AND nn.person_fullname like "Frances%Gleckman"
limit 999999
\G;
