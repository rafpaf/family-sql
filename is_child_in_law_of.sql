set sql_big_selects=1;

create table if not exists is_child_in_law_of like is_child_of;

insert into is_child_in_law_of (person_id, person_fullname, relation_id, relation_fullname)
select

distinct
m.person_id as person_id,
m.person_fullname as person_fullname,
c.relation_id as relation_id,
c.relation_fullname as relation_fullname

from has_been_married_to m
join is_child_of c

where m.relation_id = c.person_id  -- the person is married to the child of relation
LIMIT 0, 999999

\G;
