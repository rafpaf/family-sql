
set sql_big_selects=1;

-- if x is_child_of y and z is_child_of y then x is_sibling_of z

-- insert into relations (person_id, person_fullname, relation_type, relation_id, relation_fullname)
select

-- ignore these
p.PersonId as person_id,
p.fullname as person_fullname,
'is_sibling_of' as relation_type,
sib.PersonId as relation_id,
sib.fullname as relation_fullname

from JewishMeNames as p
join relations as r
on p.PersonId = r.person_id
join relations as r2
on (r.relation_id = r2.relation_id
    and r.relation_type = 'is_child_of'
    and r2.relation_type = 'is_child_of')
join JewishMeNames as sib
on sib.PersonId = r2.relation_id
where r.relation_id <> 0
and p.AASurname in ("Gleckman", "Tarr")
and p.PersonId <> sib.PersonId
\G;
