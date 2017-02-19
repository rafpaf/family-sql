select * from
(
select 'Cemetery', 'Section', 'Subsection',
'last name', 'full first name',
'relationship',
'relation last name', 'relation first name',
'person id', 'relation id'

union

select p.Cemetery, p.Section, p.Subsection,
p.lastname, p.firstname,
'is a current or former spouse of',
p2.lastname, p2.firstname,
p.id, p2.id
from has_been_married_to i
join JewishMeNames p
join JewishMeNames p2
where p.id = i.person_id and p.sinai
AND p2.id = i.relation_id

union

select p.Cemetery, p.Section, p.Subsection,
p.lastname, p.firstname,
'is a child of',
p2.lastname, p2.firstname,
p.id, p2.id
from is_child_of i
join JewishMeNames p
join JewishMeNames p2
where p.id = i.person_id and p.sinai
AND p2.id = i.relation_id

union

select p.Cemetery, p.Section, p.Subsection,
p.lastname, p.firstname,
'is a sibling of',
p2.lastname, p2.firstname,
p.id, p2.id
from is_sibling_of i
join JewishMeNames p
join JewishMeNames p2
where p.id = i.person_id and p.sinai
AND p2.id = i.relation_id

union

select p.Cemetery, p.Section, p.Subsection,
p.lastname, p.firstname,
'is a grandparent of',
p2.lastname, p2.firstname,
p.id, p2.id
from is_grandparent_of i
join JewishMeNames p
join JewishMeNames p2
where p.id = i.person_id and p.sinai
AND p2.id = i.relation_id

union

select p.Cemetery, p.Section, p.Subsection,
p.lastname, p.firstname,
'is an aunt/uncle of',
p2.lastname, p2.firstname,
p.id, p2.id
from is_auntuncle_of i
join JewishMeNames p
join JewishMeNames p2
where p.id = i.person_id and p.sinai
AND p2.id = i.relation_id

union

select p.Cemetery, p.Section, p.Subsection,
p.lastname, p.firstname,
'is an niece/nephew of',
p2.lastname, p2.firstname,
p.id, p2.id
from is_niecenephew_of i
join JewishMeNames p
join JewishMeNames p2
where p.id = i.person_id and p.sinai
AND p2.id = i.relation_id

union

select p.Cemetery, p.Section, p.Subsection,
p.lastname, p.firstname,
'has a first cousin married to',
p2.lastname, p2.firstname,
p.id, p2.id
from is_firstcousin_of_spouse_of i
join JewishMeNames p
join JewishMeNames p2
where p.id = i.person_id and p.sinai
AND p2.id = i.relation_id

) as list

order by 1, 2, 3, 4
LIMIT 99999999
into outfile '/Users/raf/code/smjca/final.csv' fields terminated by ';' enclosed by '|' lines terminated by '\n';
;
