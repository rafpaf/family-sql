set sql_big_selects=1;

drop table if exists is_child_in_law_of;

create table if not exists is_child_in_law_of like is_child_of;

insert into is_child_in_law_of (person_id, person_fullname, relation_id, relation_fullname)
select

-- Inferred from data
distinct
m.person_id as person_id,
m.person_fullname as person_fullname,
c.relation_id as relation_id,
c.relation_fullname as relation_fullname

from has_been_married_to m
join is_child_of c
where m.relation_id = c.person_id  -- the person is married to the child of relation

union

-- extracted from relationships table where the relationship is "son in law" etc.
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
where r.Relationship_1 in ("Son in law","Daughter in law","son in law of","daughter in law of")

union

-- extracted from relationships table where the relationship is "mother in law" etc.
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
where r.Relationship_1 in ("father in law","mother in law","father in law of","mother in law of")
