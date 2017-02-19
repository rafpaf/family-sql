set sql_big_selects=1;

-- rename table is_child_of to is_child_of__20170219_1013; -- crap version

-- rename table is_child_of__20170219__1010 to is_child_of; -- version that was good before

-- create table if not exists is_child_of like is_sibling_of;

insert ignore into is_child_of (person_id, person_fullname, relation_id, relation_fullname)
-- select
-- p.id as person_id,
-- p.fullname as person_fullname,
-- p2.id as relation_id,
-- p2.fullname as relation_fullname
-- from JewishMeNames as p
-- join JewishMeNames as p2
-- where
-- p.id <> 0
-- and p2.id <> 0
-- and p2.id in (p.motherid, p.fatherid)
-- 
-- union

select
p2.id as person_id,
p2.fullname as person_fullname,
p.id as relation_id,
p.fullname as relation_fullname
from JewishMeNames as p
join Relationships r
on p.id = r.PersonId
join JewishMeNames as p2
on p2.id = r.RelRecId2
where r.Relationship_1 in ("Son","Daughter","son","daughter")
\G;
