set sql_big_selects=1;

-- drop table if exists is_firstcousin_by_marriage_of;

-- create table is_firstcousin_by_marriage_of like is_firstcousin_of;

-- insert into is_firstcousin_by_marriage_of (person_id, person_fullname, relation_id, relation_fullname)
select
distinct
p.id as person_id,
p.fullname as person_fullname,
p2.id as relation_id,
p2.fullname as relation_fullname,
coz.person_fullname as coz1,
coz.relation_fullname as coz2,
m.person_fullname as m1,
m.relation_fullname as m2
from JewishMeNames as p
join is_firstcousin_of as coz
join has_been_married_to as m
join JewishMeNames as p2
where
p.id = coz.person_id
AND coz.relation_id = m.person_id AND m.relation_id = p2.id
AND m.relation_id <> 0
AND p.lastname = 'Gleckman'
limit 999999
\G;
