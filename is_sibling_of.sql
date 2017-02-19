
set sql_big_selects=1;

-- if x is_child_of y and z is_child_of y then x is_sibling_of z
-- this includes half siblings

insert ignore into is_sibling_of (person_id, person_fullname, relation_id, relation_fullname)
select

-- Infer from data (children of the same person are siblings)
distinct
c1.person_id,
c1.person_fullname,
c2.person_id,
c2.person_fullname

from is_child_of c1
join is_child_of c2

where c1.relation_id = c2.relation_id
LIMIT 0, 999999

\G;
