set sql_big_selects=1;

drop table is_firstcousin_of;

create table if not exists is_firstcousin_of like is_child_of;

insert into is_firstcousin_of (person_id, person_fullname, relation_id, relation_fullname)
select
distinct
p.id as person_id,
p.fullname as person_fullname,
p2.id as relation_id,
p2.fullname as relation_fullname
from JewishMeNames as p
join is_niecenephew_of as nn
join is_child_of as c
join JewishMeNames as p2
where
p.id = nn.person_id
AND nn.relation_id = c.relation_id
AND c.person_id = p2.id
limit 999999
\G;
