set sql_big_selects=1;

-- I use the oldfashioned abbreviation 'et ux' to mean 'and their spouses'

select 'cemetery', 'section','subsection','plot',
'first name', 'last name', 'spouses',
'parents and their spouses',
'siblings and their spouses',
'nieces and nephews and their spouses',
'grandchildren and their spouses',
'grandnieces, grandnephews, and their spouses',
'first cousins and their spouses'
union
select
Cemetery
,Section
,Subsection
,Plot2
,AAFirstName as first_name
,AASurname as last_name
,group_concat(distinct spouse.relation_fullname separator ', ') as spouses
,concat(
    group_concat(distinct parent.relation_fullname separator ', ')
    -- ,',',group_concat(distinct concat(spouse_of_parent.relation_fullname)), ','
) as parents_et_ux
,concat(
    group_concat(distinct sibling.relation_fullname separator ', ')
    -- ,',',group_concat(distinct concat(spouse_of_sibling.relation_fullname))
) as siblings_et_ux
,concat(
    group_concat(distinct nibling.person_fullname separator ', ')
    -- ,',',group_concat(distinct concat(spouse_of_nibling.relation_fullname))
) as niblings_et_ux
,concat(
    group_concat(distinct grandchild.relation_fullname separator ', ')
    -- ,',',group_concat(distinct concat(spouse_of_grandchild.relation_fullname))
) as grandchildren_et_ux
-- ,concat(
--     group_concat(distinct concat(grandnibling.relation_fullname))
--     -- ,',',group_concat(distinct concat(spouse_of_grandnibling.relation_fullname)), ','
-- )
,'' as grandnieces_and_grandnephews_et_ux
,concat(
    group_concat(distinct firstcousin.relation_fullname separator ', ')
    ,', ',group_concat(distinct spouse_of_firstcousin.relation_fullname separator ', ')
) as first_cousins_et_ux
from
JewishMeNames p

left join is_child_of parent
on p.id = parent.person_id

left join is_child_of child
on p.id = parent.relation_id

left join is_sibling_of sibling
on p.id = sibling.person_id

left join has_been_married_to spouse
on p.id = spouse.person_id

left join is_grandparent_of grandchild
on p.id = grandchild.person_id

-- -- join is_grandparent_of_spouse_of spouse_of_grandchild

left join is_niecenephew_of nibling
on p.id = nibling.relation_id

-- -- join is_auntuncle_of_spouse_of spouse_of_nibling

left join is_firstcousin_of firstcousin
on p.id = firstcousin.person_id

left join is_firstcousin_of_spouse_of spouse_of_firstcousin
on p.id = spouse_of_firstcousin.person_id

where p.sinai
group by first_name, last_name
LIMIT 99999999
into outfile '/tmp/final.csv' fields terminated by '\t' enclosed by '' lines terminated by '\n';
