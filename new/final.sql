-- I use the oldfashioned abbreviation 'et ux' to mean 'and their spouses'

select
concat(Cemetery, ' ', Section, ' ', Subsection, ' ', Plot2) as plot,
AAFirstName as first_name,
AASurname as last_name,
group_concat(distinct concat(spouse.fullname)) as spouses,
concat(
    group_concat(distinct concat(parent.fullname))
    -- ,',',group_concat(distinct concat(spouse_of_parent.fullname)), ','
) as parents_et_ux,
concat(
    group_concat(distinct concat(nibling.fullname))
    -- ,',',group_concat(distinct concat(spouse_of_nibling.fullname))
) as aunts_and_uncles_et_ux,
concat(
    group_concat(distinct concat(sibling.fullname))
    -- ,',',group_concat(distinct concat(spouse_of_sibling.fullname))
) as siblings_et_ux,
concat(
    group_concat(distinct concat(grandchild.fullname))
    -- ,',',group_concat(distinct concat(spouse_of_grandchild.fullname))
) as grandchildren_et_ux,
concat(
    group_concat(distinct concat(grandnibling.fullname))
    -- ,',',group_concat(distinct concat(spouse_of_grandnibling.fullname)), ','
) as grandnieces_and_grandnephews_et_ux,
concat(
    group_concat(distinct concat(firstcousin.fullname))
    ,',',group_concat(distinct concat(spouse_of_firstcousin.fullname))
) as first_cousins_et_ux
from
JewishMeNames p
join is_grandparent_of grandchild
-- join is_grandparent_of_spouse_of spouse_of_grandchild
join is_auntuncle_of nibling
join is_auntuncle_of_spouse_of spouse_of_nibling
join is_firstcousin_of firstcousin
join is_firstcousin_of_spouse_of spouse_of_firstcousin
LIMIT 99999999
