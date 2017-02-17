SET SQL_BIG_SELECTS=1;

select
-- p.PersonId,
-- p.spouseid, p.motherid, p.fatherid,
UPPER(p.fullname) AS person
,IF (spouse.sinai, concat('spouse: ', spouse.fullname), '') AS spouse
,IF (mother.sinai, concat('mother: ', mother.fullname), '') AS mother
,IF (father.sinai, concat('father: ', father.fullname), '') AS father
,concat('children: '
    , GROUP_CONCAT(DISTINCT IF (child.sinai,child.fullname,'') SEPARATOR ', ')
    ) AS child
,concat('grandchildren: '
    ,GROUP_CONCAT(DISTINCT IF (grandchild.sinai,grandchild.fullname,'') SEPARATOR ', ')
    ) AS grandchild
from
(
    (
        (
            (
                (
                    (
                        JewishMeNames AS p
                        JOIN JewishMeNames AS spouse
                        ON p.spouseid = spouse.PersonId
                    )
                    LEFT JOIN JewishMeNames AS mother
                    ON (p.motherid = mother.PersonId)
                    LEFT JOIN JewishMeNames AS mbubbe
                    ON (mbubbe.PersonId = mother.motherid)
                    LEFT JOIN JewishMeNames AS mbubbespouse
                    ON (mbubbespouse.PersonId = mbubbe.spouseid)
                    -- FIXME: Include former spouses.
                    LEFT JOIN JewishMeNames AS mzayde
                    ON (mzayde.PersonId = mother.fatherid)
                    LEFT JOIN JewishMeNames AS mzaydespouse
                    ON (mzaydespouse.PersonId = mzayde.spouseid)

                )
                LEFT JOIN JewishMeNames AS father
                ON (p.fatherid = father.PersonId)

                -- uncles, aunts, and niblings on father's side
                LEFT JOIN Relationships AS father2sibling
                ON (father.PersonId = father2sibling.PersonId
                    AND father2sibling.Relationship_1 IN ("sister of", "brother of"))
                LEFT JOIN JewishMeNames AS pat_auncle
                ON (father2sibling.RelRecId2 = pat_auncle.PersonId)
                LEFT JOIN JewishMeNames AS pat_aunclespouse
                ON (pat_aunclespouse.PersonId = pat_auncle.spouseid)
                LEFT JOIN JewishMeNames AS pat_nibling
                ON (pat_auncle.PersonId IN (pat_nibling.motherid, pat_nibling.fatherid))

                -- paternal bubbe and zayde
                LEFT JOIN JewishMeNames AS pbubbe
                ON (pbubbe.PersonId = father.motherid)
                LEFT JOIN JewishMeNames AS pbubbespouse
                ON (pbubbespouse.PersonId = pbubbe.spouseid)
                LEFT JOIN JewishMeNames AS pzayde
                ON (pzayde.PersonId = father.fatherid)
                LEFT JOIN JewishMeNames AS pzaydespouse
                ON (pzaydespouse.PersonId = pzayde.spouseid)
            )
            LEFT JOIN
            Relationships AS r
            ON p.PersonId = r.PersonId
        )
        LEFT JOIN
        JewishMeNames AS child
        ON (r.RelRecId2 = child.PersonId AND r.Relationship_1 IN ('father of', 'mother of'))
    )
    LEFT JOIN
    Relationships AS child2grandchild
    ON (child2grandchild.PersonId = child.PersonId OR child2grandchild.PersonId IS NULL)
)
LEFT JOIN
JewishMeNames AS grandchild
ON (child2grandchild.RelRecId2 = grandchild.PersonId OR child2grandchild.RelRecId2 IS NULL)
-- JOIN
-- JewishMeNames AS sibling
-- ON p.PersonId = p2sibling.PersonId

WHERE TRUE
-- AND p2child.rel = 'family'
-- AND (r.Relationship_1 IN ('father of', 'mother of') OR r.Relationship_1 IS NULL)
AND (
    child2grandchild.Relationship_1 IN ('father of', 'mother of')
    OR child2grandchild.Relationship_1 IS NULL)
-- AND (mother2sibling.Relationship_1 IN ('sister of', 'brother of') OR mother2sibling.Relationship_1 IS NULL)
-- AND r2.rel = 'family'

AND (p.AASurname = "Tarr")
-- AND (p.AAFirstName LIKE 'Harris%' AND p.AASurname = "Gleckman")
-- AND (p.AAFirstName LIKE '%Jeffrey%' AND p.AASurname = "Tarr")
-- AND (p.PersonID = 2163)

GROUP BY person, spouse, mother, father, grandparents
LIMIT 200;
