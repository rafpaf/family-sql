
set sql_big_selects=1;

-- if x is_child_of y and z is_child_of y then x is_sibling_of z
-- this includes half siblings

insert into relations (person_id, person_fullname, relation_type, relation_id, relation_fullname)
select

distinct
p.PersonId as person_id,
p.fullname as person_fullname,
'is_sibling_of' as relation_type,
sib.PersonId as relation_id,
sib.fullname as relation_fullname

from JewishMeNames as p
join relations as r
join relations as r2
join JewishMeNames as sib

where r.relation_type = 'is_child_of'
AND r2.relation_type = 'is_child_of'
AND p.PersonId = r.person_id
AND r.relation_id = r2.relation_id
AND r2.person_id = sib.PersonId
AND p.PersonId <> sib.PersonId
LIMIT 0, 999999

\G;
