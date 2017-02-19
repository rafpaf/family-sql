set sql_big_selects=1;

-- rename table is_child_of to is_child_of__20170219;

create table if not exists is_child_of like is_sibling_of;

insert into is_child_of (person_id, person_fullname, relation_id, relation_fullname)
select
p.id as person_id,
p.fullname as person_fullname,
p2.id as relation_id,
p2.fullname as relation_fullname
from JewishMeNames as p
join JewishMeNames as p2
where
p.id <> 0
and p2.id <> 0
and p2.id in (p.motherid, p.fatherid)
limit 0,999999
\G;
