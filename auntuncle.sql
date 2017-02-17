SET SQL_BIG_SELECTS=1;

CREATE TEMPORARY TABLE IF NOT EXISTS temp_aunt_uncle AS (
SELECT
-- p.PersonId,
-- p.spouseid, p.motherid, p.fatherid,
UPPER(p.fullname) AS person
,IF (spouse.sinai, spouse.fullname, '') AS spouse
,IF (mother.sinai, mother.fullname, '') AS mother
,IF (father.sinai, father.fullname, '') AS father
,GROUP_CONCAT(DISTINCT IF (mat_auncle.sinai,mat_auncle.fullname,'') SEPARATOR ', ') as mat_auncles
,GROUP_CONCAT(DISTINCT IF (pat_auncle.sinai,pat_auncle.fullname,'') SEPARATOR ', ') as pat_auncles
,GROUP_CONCAT(DISTINCT IF (pat_aunclespouse.sinai,pat_aunclespouse.fullname,'') SEPARATOR ', ') as pat_auncles_
,GROUP_CONCAT(DISTINCT IF (mat_aunclespouse.sinai,mat_aunclespouse.fullname,'') SEPARATOR ', ') as mat_auncles_
,GROUP_CONCAT(DISTINCT IF (mat_nibling.sinai,mat_nibling.fullname,'') SEPARATOR ', ') as mat_niblings
,GROUP_CONCAT(DISTINCT IF (pat_nibling.sinai,pat_nibling.fullname,'') SEPARATOR ', ') as pat_niblings
,GROUP_CONCAT(DISTINCT IF (mat_niblingspouse.sinai,mat_niblingspouse.fullname,'') SEPARATOR ', ') as mat_niblings_
,GROUP_CONCAT(DISTINCT IF (pat_niblingspouse.sinai,pat_niblingspouse.fullname,'') SEPARATOR ', ') as pat_niblings_
from
(
    (
        JewishMeNames AS p
        JOIN JewishMeNames AS spouse
        ON p.spouseid = spouse.PersonId
    )
    LEFT JOIN JewishMeNames AS mother
    ON (p.motherid = mother.PersonId)

    -- uncles, aunts, and niblings on mother's side
    LEFT JOIN Relationships AS mother2sibling
    ON (mother.PersonId = mother2sibling.PersonId
        AND mother2sibling.Relationship_1 IN ("sister of", "brother of"))
    LEFT JOIN JewishMeNames AS mat_auncle
    ON (mother2sibling.RelRecId2 = mat_auncle.PersonId)
    LEFT JOIN JewishMeNames AS mat_aunclespouse
    ON (mat_aunclespouse.PersonId = mat_auncle.spouseid)
    LEFT JOIN JewishMeNames AS mat_nibling
    ON (mat_auncle.PersonId IN (mat_nibling.motherid, mat_nibling.fatherid))
    LEFT JOIN JewishMeNames AS mat_niblingspouse
    ON (mat_niblingspouse.PersonId = mat_nibling.spouseid)

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
LEFT JOIN JewishMeNames AS pat_niblingspouse
ON (pat_niblingspouse.PersonId = pat_nibling.spouseid)

WHERE TRUE
-- AND p.sinai
AND (p.AASurname = "Tarr")

GROUP BY person, spouse, mother, father
);

SELECT * FROM temp_aunt_uncle\G;
