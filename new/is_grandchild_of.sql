-- Grandparents

set sql_big_selects=1;

rename table is_grandchild_of to is_grandchild_of__20170219_1017;

create table is_grandchild_of like is_child_of;

insert is_grandchild_of
select
distinct
rc.person_id as person_id,
rc.person_fullname as person_fullname,
rc2.relation_id as relation_id,
rc2.relation_fullname as relation_fullname
from is_child_of as rc
join is_child_of as rc2
where rc.relation_id = rc2.person_id
LIMIT 999999
\G;

-- anyone who stands within two degrees of separation.
-- problems with this: sometimes someone is listed as a brother but there is no other information.
