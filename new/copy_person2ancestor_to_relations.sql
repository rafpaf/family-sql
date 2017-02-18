insert into relations (person_id, person_fullname, relation_type, relation_id, relation_fullname)
select
person2ancestor.person_id as person_id,
person.fullname,
'is_child_of' as relation_type,
person2ancestor.ancestor_id as relation_id,
ancestor.fullname
from person2ancestor
join JewishMeNames person
on person.PersonId = person2ancestor.Person_id
join JewishMeNames ancestor
on ancestor.PersonId = person2ancestor.ancestor_id
where ancestor.PersonId <> 0
