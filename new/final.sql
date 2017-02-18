select 'Cemetery', 'Section', 'Subsection', 'last name', 'short first name', 'full first name', 'relationship', 'converse relationship', 'gendered relationship', 'gendered converse relationship', 'relation last name', 'relation first name', 'sentence', 'person id', 'relation id'
union
select p.Cemetery, p.Section, p.Subsection, p.lastname, SUBSTRING_INDEX(p.firstname, ' ', 1), p.firstname, 'is a child of', 'parent', 'is a child of', if(p2.Gender like '%f%','mother','father'), p2.lastname, p2.firstname, concat(p.fullname, ' is a child of ', p2.fullname), p.id, p2.id
from is_child_of i
join JewishMeNames p
join JewishMeNames p2
where p.id = i.person_id and p.sinai
AND p2.id = i.relation_id
AND p.lastname = 'Gleckman'
limit 50
\G
-- union
-- select p.firstname from is_child_of i join JewishMeNames p where p.id = i.person_id and p.sinai
;
