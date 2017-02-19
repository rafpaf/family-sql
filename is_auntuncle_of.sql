set sql_big_selects=1;

-- if x is_child_of y and z is_child_of y then x is_sibling_of z
-- this includes half siblings

-- rename table is_auntuncle_of to is_auntuncle_of__20170219_0910;

-- create table if not exists is_auntuncle_of like is_child_of;
-- 
-- insert ignore into is_auntuncle_of (person_id, person_fullname, relation_id, relation_fullname)
-- select
-- 
-- distinct
-- rs.person_id as person_id,
-- rs.person_fullname as person_fullname,
-- rc.person_id as relation_id,
-- rc.person_fullname as relation_fullname
-- -- rs.person_fullname as rs_person,
-- -- rs.relation_fullname as rs_relation,
-- -- rc.person_fullname as rc_person,
-- -- rc.relation_fullname as rc_relation
-- 
-- from join is_sibling_of as rs
-- join is_child_of as rc
-- 
-- where rs.relation_id = rc.relation_id
-- 
-- union

-- inferred from Relationships table, rows marked 'mother of', 'father of'
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
where r.Relationship_1 in ("aunt","uncle")

union

select
p.id as person_id,
p.fullname as person_fullname,
p2.id as relation_id,
p2.fullname as relation_fullname
from JewishMeNames as p
join Relationships r
on p.id = r.PersonId
join JewishMeNames as p2
on p2.id = r.RelRecId2
where r.Relationship_1 in ("niece","nephew")

\G;
