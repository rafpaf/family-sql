set sql_big_selects=1;

-- drop table is_firstcousin_of;
-- 
-- create table if not exists is_firstcousin_of like is_child_of;
-- 
-- insert into is_firstcousin_of (person_id, person_fullname, relation_id, relation_fullname)
select
distinct
c.person_id as person_id,
c.person_fullname as person_fullname,
nn.relation_id as relation_id,
nn.relation_fullname as relation_fullname
from is_child_of as c
join is_niecenephew_of as nn
where c.relation_id = nn.person_id
limit 999999
\G;
