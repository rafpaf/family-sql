
set sql_big_selects=1;

-- if x is_child_of y and z is_child_of y then x is_sibling_of z

insert into relations (person_id, person_fullname, relation_type, relation_id, relation_fullname)
select
p.PersonId as person_id,
p.fullname as person_fullname,
'is_parent_of' as relation_type,
child.PersonId as relation_id,
child.fullname as relation_fullname
from JewishMeNames as p
join relations as r
on (PersonId = relation_id and relation_type = "is_child_of")
join JewishMeNames as child
on child.PersonId = r.person_id
where relation_id <> 0
\G;
