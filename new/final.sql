set sql_big_selects=1;

-- I use the oldfashioned abbreviation 'et ux' to mean 'and their spouses'

select 'plot', 'first_name', 'last_name', 'spouses', 'parents_and_their_spouses', 'aunts_and_uncles_and_their_spouses','grandchildren_and_their_spouses','first_cousins_and_their_spouses'
union
select
concat(Cemetery, ' ', Section, ' ', Subsection, ' ', Plot2) as plot
,AAFirstName as first_name
,AASurname as last_name
,group_concat(distinct concat(spouse.relation_fullname)) as spouses
,concat(
    group_concat(distinct concat(parent.relation_fullname))
    -- ,',',group_concat(distinct concat(spouse_of_parent.relation_fullname)), ','
) as parents_et_ux
,concat(
    group_concat(distinct concat(nibling.relation_fullname))
    -- ,',',group_concat(distinct concat(spouse_of_nibling.relation_fullname))
) as aunts_and_uncles_et_ux
-- ,concat(
--     group_concat(distinct concat(sibling.relation_fullname))
--     -- ,',',group_concat(distinct concat(spouse_of_sibling.relation_fullname))
-- ) as siblings_et_ux
,concat(
    group_concat(distinct concat(grandchild.relation_fullname))
    -- ,',',group_concat(distinct concat(spouse_of_grandchild.relation_fullname))
) as grandchildren_et_ux
-- ,concat(
--     group_concat(distinct concat(grandnibling.relation_fullname))
--     -- ,',',group_concat(distinct concat(spouse_of_grandnibling.relation_fullname)), ','
-- ) as grandnieces_and_grandnephews_et_ux,
,concat(
    group_concat(distinct concat(firstcousin.relation_fullname))
    -- ,',',group_concat(distinct concat(spouse_of_firstcousin.relation_fullname))
) as first_cousins_et_ux
from
JewishMeNames p
join is_child_of parent
on p.id = parent.person_id
-- join is_sibling_of sibling

join has_been_married_to spouse
on p.id = spouse.person_id

left join is_grandparent_of grandchild
on p.id = grandchild.person_id

-- -- join is_grandparent_of_spouse_of spouse_of_grandchild

left join is_auntuncle_of nibling
on p.id = nibling.person_id

-- -- join is_auntuncle_of_spouse_of spouse_of_nibling

left join is_firstcousin_of firstcousin
on p.id = firstcousin.person_id

-- join is_firstcousin_of_spouse_of spouse_of_firstcousin
where p.sinai
group by first_name, last_name
LIMIT 99999999
into outfile '/tmp/final.csv' fields terminated by '\t' enclosed by '' lines terminated by '\n';
