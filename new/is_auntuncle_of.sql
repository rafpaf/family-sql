set sql_big_selects=1;

-- if x is_child_of y and z is_child_of y then x is_sibling_of z
-- this includes half siblings

-- rename table is_auntuncle_of to is_auntuncle_of__20170219_0910;

create table if not exists is_auntuncle_of like is_child_of;

insert into is_auntuncle_of (person_id, person_fullname, relation_id, relation_fullname)
select

distinct
p.id as person_id,
p.fullname as person_fullname,
p2.id as relation_id,
p2.fullname as relation_fullname
-- rs.person_fullname as rs_person,
-- rs.relation_fullname as rs_relation,
-- rc.person_fullname as rc_person,
-- rc.relation_fullname as rc_relation

from JewishMeNames as p
join is_sibling_of as rs
join is_child_of as rc
join JewishMeNames as p2

where
    p.id = rs.person_id
AND rs.relation_id = rc.relation_id
AND rc.person_id = p2.id
AND p2.id <> rc.relation_id
AND p.id <> p2.id
LIMIT 0, 999999

\G;
