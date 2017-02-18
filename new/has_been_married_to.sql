set sql_big_selects=1;

-- create table has_been_married_to like is_child_of;

-- insert into has_been_married_to ( person_id, person_fullname, relation_id, relation_fullname)
select
p.id as person_id,
p.fullname as person_fullname,
p2.id as relation_id,
p2.fullname as relation_fullname
from JewishMeNames as p
join JewishMeNames as p2
where 1
AND p.spouseid = p2.id
limit 999999
\G;
