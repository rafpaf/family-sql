SET SQL_BIG_SELECTS=1;

select
-- p.PersonId,
-- p.spouseid, p.motherid, p.fatherid,
UPPER(concat(p.AAFirstName, ' ', p.AASurname)) as person,
if (spouse.Cemetery LIKE '%Sinai%', concat('spouse: ', spouse.AAFirstName, ' ', spouse.AASurname), '') as spouse,
if (mother.Cemetery LIKE '%Sinai%', concat('mother: ', mother.AAFirstName, ' ', mother.AASurname), '') as mother,
if (father.Cemetery LIKE '%Sinai%', concat('father: ', father.AAFirstName, ' ', father.AASurname), '') as father,
concat('grandparents: ',
    -- maternal bubbe and zayde
    if (mbubbe.Cemetery LIKE '%Sinai%',
        concat(mbubbe.AAFirstName, ' ', mbubbe.AASurname, ', '), ''),
    if (mzayde.Cemetery LIKE '%Sinai%',
        concat(mzayde.AAFirstName, ' ', mzayde.AASurname, ', '), ''),
    -- if maternal bubbe's spouse is different from maternal zayde:
    if (mbubbespouse.PersonId <> mzayde.PersonId
        AND mbubbespouse.Cemetery LIKE '%Sinai%',
        concat(mbubbespouse.AAFirstName, ' ', mbubbespouse.AASurname, ', '), ''),
    -- if maternal zayde's spouse is different from maternal bubbe:
    if (mzaydespouse.PersonId <> mbubbe.PersonId
        AND mzaydespouse.Cemetery LIKE '%Sinai%',
        concat(mzaydespouse.AAFirstName, ' ', mzaydespouse.AASurname, ', '), ''),
    -- paternal bubbe and zayde
    if (pbubbe.Cemetery LIKE '%Sinai%',
        concat(pbubbe.AAFirstName, ' ', pbubbe.AASurname, ', '), ''),
    if (pzayde.Cemetery LIKE '%Sinai%',
        concat(pzayde.AAFirstName, ' ', pzayde.AASurname, ', '), ''),
    -- if paternal bubbe's spouse is different from paternal zayde:
    if (pbubbespouse.PersonId <> pzayde.PersonId
        AND pbubbespouse.Cemetery LIKE '%Sinai%',
        concat(pbubbespouse.AAFirstName, ' ', pbubbespouse.AASurname, ', '), ''),
    -- if paternal zayde's spouse is different from paternal bubbe:
    if (pzaydespouse.PersonId <> pbubbe.PersonId
        AND pzaydespouse.Cemetery LIKE '%Sinai%',
        concat(pzaydespouse.AAFirstName, ' ', pzaydespouse.AASurname, ', '), ''),
    ) as grandparents,
concat('auncles:', auntuncle.AAFirstName, ' ', auntuncle.AASurname) as auncle,
concat('children: ', GROUP_CONCAT(DISTINCT IF (child.Cemetery LIKE '%Sinai',concat(child.AAFirstName,' ',child.AASurname),'') SEPARATOR ', ')) as child,
concat('grandchildren: ', GROUP_CONCAT(DISTINCT IF (grandchild.Cemetery LIKE '%Sinai',concat(grandchild.AAFirstName,' ',grandchild.AASurname),'') SEPARATOR ', ')) as grandchild
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
sinai as grandchild
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

AND p.AASurname = "Tarr"

GROUP BY person, spouse, mother, father, grandparents
LIMIT 200;
