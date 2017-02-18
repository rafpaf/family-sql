set sql_big_selects=1;

create table is_child_of like is_sibling_of;

insert into is_child_of (person_id, person_fullname, relation_id, relation_fullname)
select
p.PersonId as person_id,
p.fullname as person_fullname,
p2.PersonId as relation_id,
p2.fullname as relation_fullname
from JewishMeNames as p
join JewishMeNames as p2
where
p.PersonId <> 0
and p2.PersonId <> 0
and p2.PersonId in (p.motherid, p.fatherid)
limit 0,999999
\G;
