drop table if exists smjca_relation;

create table smjca_relation (
cemetery varchar(60),
section varchar(10),
subsection varchar(10),
plot varchar(100),
p1_lastname varchar(255),
p1_firstname varchar(255),
relationship varchar(255),
relationship_more_specific varchar(255),
p2_lastname varchar(255),
p2_firstname varchar(255),
p1_id integer,
p2_id integer)
(
    select * -- cemetery, section, subsection, p1_lastname, p1_firstname, relationship, relationship_more_specific, p2_lastname, p2_firstname, p1_id, p2_id
    from (

select p.Cemetery as cemetery, p.Section as section, p.Subsection as subsection, p.Plot2 as plot,
p.lastname as p1_lastname,
p.firstname as p1_firstname,
'spouse of' as relationship,
if(p.Gender like '%f%','wife of','husband of') as relationship_more_specific,
p2.lastname as p2_lastname,
p2.firstname as p2_firstname,
p.id as p1_id, p2.id as p2_id
from has_been_married_to i
join JewishMeNames p
join JewishMeNames p2
where p.id = i.person_id and p.sinai
AND p2.id = i.relation_id

union

select p.Cemetery as cemetery, p.Section as section, p.Subsection as subsection, p.Plot2 as plot,
p.lastname as p1_lastname,
p.firstname as p1_firstname,
'child of' as relationship,
if(p.Gender like '%f%','daughter of','son of') as relationship_more_specific,
p2.lastname as p2_lastname, p2.firstname as p2_firstname,
p.id as p1_id, p2.id as p2_id
from is_child_of i
join JewishMeNames p
join JewishMeNames p2
where p.id = i.person_id and p.sinai
AND p2.id = i.relation_id

union

select p.Cemetery as cemetery, p.Section as section, p.Subsection as subsection, p.Plot2 as plot,
p.lastname as p1_lastname, p.firstname as p1_firstname,
'sibling of' as relationship,
if(p.Gender like '%f%','sister of','brother of') as relationship_more_specific,
p2.lastname as p2_lastname, p2.firstname as p2_firstname,
p.id as p1_id, p2.id as p2_id
from is_sibling_of i
join JewishMeNames p
join JewishMeNames p2
where p.id = i.person_id and p.sinai
AND p2.id = i.relation_id

union

select p.Cemetery as cemetery, p.Section as section, p.Subsection as subsection, p.Plot2 as plot,
p.lastname as p1_lastname, p.firstname as p1_firstname,
'parent of' as relationship,
if(p.Gender like '%f%','mother of','father of') as relationship_more_specific,
p2.lastname as p2_lastname, p2.firstname as p2_firstname,
p.id as p1_id, p2.id as p2_id
from is_child_of i
join JewishMeNames p
join JewishMeNames p2
where p.id = i.relation_id and p.sinai
AND p2.id = i.person_id

union

select p.Cemetery as cemetery, p.Section as section, p.Subsection as subsection, p.Plot2 as plot,
p.lastname as p1_lastname, p.firstname as p1_firstname,
'grandparent of' as relationship,
if(p.Gender like '%f%','grandmother of','grandfather of') as relationship_more_specific,
p2.lastname as p2_lastname, p2.firstname as p2_firstname,
p.id as p1_id, p2.id as p2_id
from is_grandparent_of i
join JewishMeNames p
join JewishMeNames p2
where p.id = i.person_id and p.sinai
AND p2.id = i.relation_id

union

select p.Cemetery as cemetery, p.Section as section, p.Subsection as subsection, p.Plot2 as plot,
p.lastname as p1_lastname, p.firstname as p1_firstname,
'aunt/uncle of' as relationship,
if(p.Gender like '%f%','aunt of','uncle of') as relationship_more_specific,
p2.lastname as p2_lastname, p2.firstname as p2_firstname,
p.id as p1_id, p2.id as p2_id
from is_auntuncle_of i
join JewishMeNames p
join JewishMeNames p2
where p.id = i.person_id and p.sinai
AND p2.id = i.relation_id

union

select p.Cemetery as cemetery, p.Section as section, p.Subsection as subsection, p.Plot2 as plot,
p.lastname as p1_lastname, p.firstname as p1_firstname,
'niece/nephew of' as relationship,
if(p.Gender like '%f%','niece of','nephew of') as relationship_more_specific,
p2.lastname as p2_lastname, p2.firstname as p2_firstname,
p.id as p1_id, p2.id as p2_id
from is_niecenephew_of i
join JewishMeNames p
join JewishMeNames p2
where p.id = i.person_id and p.sinai
AND p2.id = i.relation_id

union

select p.Cemetery as cemetery, p.Section as section, p.Subsection as subsection, p.Plot2 as plot,
p.lastname as p1_lastname, p.firstname as p1_firstname,
'first cousin of' as relationship,
'first cousin of',
p2.lastname as p2_lastname, p2.firstname as p2_firstname,
p.id as p1_id, p2.id as p2_id
from is_firstcousin_of i
join JewishMeNames p
join JewishMeNames p2
where p.id = i.person_id and p.sinai
AND p2.id = i.relation_id

union

select p.Cemetery as cemetery, p.Section as section, p.Subsection as subsection, p.Plot2 as plot,
p.lastname as p1_lastname, p.firstname as p1_firstname,
'greataunt/greatuncle of' as relationship,
if(p.Gender like '%f%','greataunt of','greatuncle of') as relationship_more_specific,
p2.lastname as p2_lastname, p2.firstname as p2_firstname,
p.id as p1_id, p2.id as p2_id
from is_grandniecenephew_of i
join JewishMeNames p
join JewishMeNames p2
where p.id = i.relation_id and p.sinai
AND p2.id = i.person_id

union

select p.Cemetery as cemetery, p.Section as section, p.Subsection as subsection, p.Plot2 as plot,
p.lastname as p1_lastname, p.firstname as p1_firstname,
'grandniece/grandnephew of' as relationship,
if(p.Gender like '%f%','grandniece of','grandnephew of') as relationship_more_specific,
p2.lastname as p2_lastname, p2.firstname as p2_firstname,
p.id as p1_id, p2.id as p2_id
from is_grandniecenephew_of i
join JewishMeNames p
join JewishMeNames p2
where p.id = i.person_id and p.sinai
AND p2.id = i.relation_id

) as list
)
order by 1, 2, 3, 4
;

select * from
(
    select
    'cemetery',
    'section',
    'subsection',
    'plot',
    'p1_lastname',
    'p1_firstname',
    'relationship',
    'relationship_more_specific',
    'p2_lastname',
    'p2_firstname',
    'p1_id',
    'p2_id'
    union
    select * from smjca_relation
) as list
LIMIT 99999999
into outfile '/Users/raf/code/smjca/final.csv'
fields terminated by ';' enclosed by '"' lines terminated by '\n';
;
