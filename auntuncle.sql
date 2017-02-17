SET SQL_BIG_SELECTS=1;

SELECT
-- p.PersonId,
-- p.spouseid, p.motherid, p.fatherid,
UPPER(p.fullname) AS person
,IF (spouse.sinai, concat('spouse: ', spouse.fullname), '') AS spouse
,IF (mother.sinai, concat('mother: ', mother.fullname), '') AS mother
,IF (father.sinai, concat('father: ', father.fullname), '') AS father
,concat('auncles:'
    ,GROUP_CONCAT(DISTINCT IF (mat_auncle.sinai,mat_auncle.fullname,'') SEPARATOR ', ')
    ,GROUP_CONCAT(DISTINCT IF (pat_auncle.sinai,pat_auncle.fullname,'') SEPARATOR ', ')
    ,GROUP_CONCAT(DISTINCT IF (pat_aunclespouse.sinai,pat_aunclespouse.fullname,'') SEPARATOR ', ')
    ,GROUP_CONCAT(DISTINCT IF (mat_aunclespouse.sinai,mat_aunclespouse.fullname,'') SEPARATOR ', ')
    ) AS auncle
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

WHERE TRUE
AND (p.AASurname = "Gleckman")
OR (p.AASurname = "Tarr")

GROUP BY person, spouse, mother, father
;
