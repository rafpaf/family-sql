-- Grandparents

set sql_big_selects=1;

create table is_grandchild_of like is_child_of;

insert is_grandchild_of
select
distinct
p.id as person_id,
p.fullname as person_fullname,
p2.id as relation_id,
p2.fullname as relation_fullname
from JewishMeNames as p
join is_child_of as rc
join is_child_of as rc2
join JewishMeNames as p2
where p.id <> 0 AND p2.id <> 0
AND p.id = rc.person_id
AND rc.relation_id = rc2.person_id
AND rc2.relation_id = p2.id
LIMIT 999999
\G;

-- anyone who stands within two degrees of separation.
-- problems with this: sometimes someone is listed as a brother but there is no other information.
