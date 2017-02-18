-- Grandparents

set sql_big_selects=1;

drop table if exists relations;

create table if not exists relations
(
    id int not null auto_increment,
    person_id int,
    person_fullname varchar(255),
    relation_type varchar(255),
    relation_id int,
    relation_fullname varchar(255),
    primary key (id)
)
select
p.PersonId as person_id,
p.fullname as person_fullname,
'is_grandchild_of' as relation_type,
grandparent.PersonId as relation_id,
grandparent.fullname as relation_fullname
from JewishMeNames as p
join person2ancestor as p2a1
on p.PersonId = p2a1.person_id
join person2ancestor as p2a2
on p2a1.ancestor_id = p2a2.person_id
join JewishMeNames as grandparent
on p2a2.ancestor_id = grandparent.PersonId
where grandparent.PersonId <> 0
\G;

-- anyone who stands within two degrees of separation.
-- problems with this: sometimes someone is listed as a brother but there is no other information.
