SET SQL_BIG_SELECTS=1;

select
-- p.PersonId,
-- p.spouseid, p.motherid, p.fatherid,
UPPER(p.fullname) as person,
if (spouse.sinai, concat('spouse: ', spouse.fullname), '') as spouse,
if (mother.sinai, concat('mother: ', mother.fullname), '') as mother,
if (father.sinai, concat('father: ', father.fullname), '') as father,
concat('grandparents: ',
    -- maternal bubbe and zayde
    if (mbubbe.sinai, mbubbe.fullname, ''),
    if (mzayde.sinai, mzayde.fullname, ''),
    -- if maternal bubbe's spouse is different from maternal zayde:
    if (mbubbespouse.PersonId <> mzayde.PersonId
        AND mbubbespouse.sinai, mbubbespouse.fullname, ''),
    -- if maternal zayde's spouse is different from maternal bubbe:
    if (mzaydespouse.PersonId <> mbubbe.PersonId
        AND mzaydespouse.sinai, mzaydespouse.fullname, ''),
    -- paternal bubbe and zayde
    if (pbubbe.sinai, pbubbe.fullname, ''),
    if (pzayde.sinai, pzayde.fullname, ''),
    -- if paternal bubbe's spouse is different from paternal zayde:
    if (pbubbespouse.PersonId <> pzayde.PersonId
        AND pbubbespouse.sinai, pbubbespouse.fullname, ''),
    -- if paternal zayde's spouse is different from paternal bubbe:
    if (pzaydespouse.PersonId <> pbubbe.PersonId
        AND pzaydespouse.sinai, pzaydespouse.fullname, '')
    ) as grandparents,
concat('auncles:', auntuncle.fullname) as auncle,
concat('children: ', GROUP_CONCAT(DISTINCT IF (child.Cemetery LIKE '%Sinai',child.fullname,'') SEPARATOR ', ')) as child,
concat('grandchildren: ', GROUP_CONCAT(DISTINCT IF (grandchild.Cemetery LIKE '%Sinai',grandchild.fullname,'') SEPARATOR ', ')) as grandchild
from
(
    (
        (
            (
                (
                    (
                        JewishMeNames as p
                        JOIN JewishMeNames as spouse
                        on p.spouseid = spouse.PersonId
                    )
                    LEFT JOIN JewishMeNames as mother
                    on (p.motherid = mother.PersonId)
                    LEFT JOIN JewishMeNames as mbubbe
                    on (mbubbe.PersonId = mother.motherid)
                        LEFT JOIN JewishMeNames as mbubbespouse
                        on (mbubbespouse.PersonId = mbubbe.spouseid)
                    -- FIXME: Include former spouses.
                    LEFT JOIN JewishMeNames as mzayde
                    on (mzayde.PersonId = mother.fatherid)
                        LEFT JOIN JewishMeNames as mzaydespouse
                        on (mzaydespouse.PersonId = mzayde.spouseid)
                    LEFT JOIN Relationships as mother2sibling
                    ON (mother.PersonId = mother2sibling.PersonId
                        AND mother2sibling.Relationship_1 IN ("sister of", "brother of"))
                    LEFT JOIN JewishMeNames as auntuncle
                    ON (mother2sibling.RelRecId2 = auntuncle.PersonId)
                )
                LEFT JOIN JewishMeNames as father
                on (p.fatherid = father.PersonId)
                LEFT JOIN JewishMeNames as pbubbe
                on (pbubbe.PersonId = father.motherid)
                LEFT JOIN JewishMeNames as pbubbespouse
                on (pbubbespouse.PersonId = pbubbe.spouseid)
                LEFT JOIN JewishMeNames as pzayde
                on (pzayde.PersonId = father.fatherid)
                LEFT JOIN JewishMeNames as pzaydespouse
                on (pzaydespouse.PersonId = pzayde.spouseid)
            )
            LEFT JOIN
            Relationships as r
            on p.PersonId = r.PersonId
        )
        LEFT JOIN
        JewishMeNames as child
        on (r.RelRecId2 = child.PersonId AND r.Relationship_1 IN ('father of', 'mother of'))
    )
    LEFT JOIN
    Relationships as child2grandchild
    on (child2grandchild.PersonId = child.PersonId OR child2grandchild.PersonId IS NULL)
)
LEFT JOIN
JewishMeNames as grandchild
on (child2grandchild.RelRecId2 = grandchild.PersonId OR child2grandchild.RelRecId2 IS NULL)
-- JOIN
-- JewishMeNames as sibling
-- on p.PersonId = p2sibling.PersonId

WHERE TRUE
-- AND p2child.rel = 'family'
-- AND (r.Relationship_1 IN ('father of', 'mother of') OR r.Relationship_1 IS NULL)
AND (
    child2grandchild.Relationship_1 IN ('father of', 'mother of')
    OR child2grandchild.Relationship_1 IS NULL)
-- AND (mother2sibling.Relationship_1 IN ('sister of', 'brother of') OR mother2sibling.Relationship_1 IS NULL)
-- AND r2.rel = 'family'

AND (p.AASurname = "Gleckman")

GROUP BY person, spouse, mother, father, grandparents
LIMIT 200;
