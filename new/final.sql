set sql_big_selects=1;

-- I use the oldfashioned abbreviation 'et ux' to mean 'and their spouses'

select
concat(Cemetery, ' ', Section, ' ', Subsection, ' ', Plot2) as plot,
AAFirstName as first_name,
AASurname as last_name,
group_concat(distinct concat(spouse.relation_fullname)) as spouses,
concat(
    group_concat(distinct concat(parent.relation_fullname))
    -- ,',',group_concat(distinct concat(spouse_of_parent.relation_fullname)), ','
) as parents_et_ux,
concat(
    group_concat(distinct concat(nibling.relation_fullname))
    -- ,',',group_concat(distinct concat(spouse_of_nibling.relation_fullname))
) as aunts_and_uncles_et_ux,
concat(
    group_concat(distinct concat(sibling.relation_fullname))
    -- ,',',group_concat(distinct concat(spouse_of_sibling.relation_fullname))
) as siblings_et_ux,
concat(
    group_concat(distinct concat(grandchild.relation_fullname))
    -- ,',',group_concat(distinct concat(spouse_of_grandchild.relation_fullname))
) as grandchildren_et_ux
-- ,
-- concat(
--     group_concat(distinct concat(grandnibling.relation_fullname))
--     -- ,',',group_concat(distinct concat(spouse_of_grandnibling.relation_fullname)), ','
-- ) as grandnieces_and_grandnephews_et_ux,
-- concat(
--     group_concat(distinct concat(firstcousin.relation_fullname))
--     ,',',group_concat(distinct concat(spouse_of_firstcousin.relation_fullname))
-- ) as first_cousins_et_ux
from
JewishMeNames p
join is_child_of parent
join is_sibling_of sibling
join has_been_married_to spouse
join is_grandparent_of grandchild
-- join is_grandparent_of_spouse_of spouse_of_grandchild
join is_auntuncle_of nibling
-- join is_auntuncle_of_spouse_of spouse_of_nibling
join is_firstcousin_of firstcousin
join is_firstcousin_of_spouse_of spouse_of_firstcousin
where p.AASurname = "Gleckman"
group by first_name, last_name
-- LIMIT 99999999
