create table if not exists smjca_relation (
cemetery varchar(60),
section varchar(10),
subsection varchar(10),
p1_lastname varchar(255),
p2_firstname varchar(255),
relationship varchar(255),
relationship_more_specific varchar(255),
p2_lastname varchar(255),
p2_firstname varchar(255),
p1_id integer,
p2_id integer)
(

select p.Cemetery, p.Section, p.Subsection,
p.lastname, p.firstname,
'spouse of',
if(p.Gender like '%f%','wife of','husband of'),
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
'child of',
if(p.Gender like '%f%','daughter of','son of'),
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
'sibling of',
if(p.Gender like '%f%','sister of','brother of'),
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
'parent of',
if(p.Gender like '%f%','mother of','father of'),
p2.lastname, p2.firstname,
p.id, p2.id
from is_child_of i
join JewishMeNames p
join JewishMeNames p2
where p.id = i.relation_id and p.sinai
AND p2.id = i.person_id

union

select p.Cemetery, p.Section, p.Subsection,
p.lastname, p.firstname,
'grandparent of',
if(p.Gender like '%f%','grandmother of','grandfather of'),
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
'aunt/uncle of',
if(p.Gender like '%f%','aunt of','uncle of'),
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
if(p.Gender like '%f%','niece of','nephew of'),
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
'first cousin of',
'first cousin of',
p2.lastname, p2.firstname,
p.id, p2.id
from is_firstcousin_of i
join JewishMeNames p
join JewishMeNames p2
where p.id = i.person_id and p.sinai
AND p2.id = i.relation_id

union

select p.Cemetery, p.Section, p.Subsection,
p.lastname, p.firstname,
'greataunt/greatuncle of',
if(p.Gender like '%f%','greataunt of','greatuncle of'),
p2.lastname, p2.firstname,
p.id, p2.id
from is_grandniecenephew_of i
join JewishMeNames p
join JewishMeNames p2
where p.id = i.relation_id and p.sinai
AND p2.id = i.person_id

union

select p.Cemetery, p.Section, p.Subsection,
p.lastname, p.firstname,
'grandniece/grandnephew of',
if(p.Gender like '%f%','grandniece of','grandnephew of'),
p2.lastname, p2.firstname,
p.id, p2.id
from is_grandniecenephew_of i
join JewishMeNames p
join JewishMeNames p2
where p.id = i.person_id and p.sinai
AND p2.id = i.relation_id

);

select * from
(
    'cemetery',
    'section',
    'subsection',
    'p1_lastname',
    'p2_firstname',
    'relationship',
    'relationship_more_specific',
    'p2_lastname',
    'p2_firstname',
    'p1_id',
    'p2_id'
    union
    select * from smjca_relation
)
order by 1, 2, 3, 4
LIMIT 99999999
into outfile '/Users/raf/code/smjca/final.csv'
fields terminated by ';' enclosed by '"' lines terminated by '\n';
;
