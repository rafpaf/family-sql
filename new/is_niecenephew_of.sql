set sql_big_selects=1;

-- if x is_child_of y and z is_child_of y then x is_sibling_of z
-- this includes half siblings

insert into is_auntuncle_of (person_id, person_fullname, relation_id, relation_fullname)
select

distinct
p.PersonId as person_id,
p.fullname as person_fullname,
aunt.PersonId as relation_id,
aunt.fullname as relation_fullname

from JewishMeNames as p
join is_child_of as rc
join is_sibling_of as rs
join JewishMeNames as aunt

where
    p.PersonId = rc.person_id
AND rc.relation_id = rs.person_id
AND rs.relation_id = aunt.PersonId
-- AND p.AASurname = "Gleckman"
LIMIT 0, 999999

\G;
