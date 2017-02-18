insert into relations
select
p.PersonId as person_id,
p.fullname as person_fullname,
'is_grandparent_of' as relation_type,
grandchild.PersonId as relation_id,
grandchild.fullname as relation_fullname
from JewishMeNames as p
join person2ancestor as p2a1
on p.PersonId = p2a1.person_id
join person2ancestor as p2a2
on p2a1.ancestor_id = p2a2.person_id
join JewishMeNames as grandchild
on p2a2.ancestor_id = grandchild.PersonId
where p.AASurname = 'Gleckman'
and grandchild.PersonId <> 0
\G;