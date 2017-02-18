set sql_big_selects=1;

create table is_firstcousin_by_marriage_of like is_firstcousin_of;

insert into is_firstcousin_by_marriage_of (person_id, person_fullname, relation_id, relation_fullname)
select
p.id as person_id,
p.fullname as person_fullname,
p2.id as relation_id,
p2.fullname as relation_fullname
from JewishMeNames as p
join is_firstcousin_of as coz
join was_once_married_to as m
join JewishMeNames as p2
where
p.id = coz.person_id
AND coz.relation_id = m.person_id
AND m.relation_id = p2.id
limit 999999
\G;
