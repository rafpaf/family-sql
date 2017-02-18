set sql_big_selects=1;

create table if not exists is_niecenephew_of like is_child_of;

insert into is_niecenephew_of (person_id, person_fullname, relation_id, relation_fullname)
select

distinct
p.id as person_id,
p.fullname as person_fullname,
p2.id as relation_id,
p2.fullname as relation_fullname

from JewishMeNames as p
join is_child_of as rc
join is_sibling_of as rs
join JewishMeNames as p2

where
    p.id = rc.person_id
AND rc.relation_id = rs.person_id
AND rs.relation_id = p2.id
-- AND p.AASurname = "Gleckman"
LIMIT 0, 999999

\G;
