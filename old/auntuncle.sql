-- underscore is short for spouse

SET SQL_BIG_SELECTS=1;

CREATE TEMPORARY TABLE IF NOT EXISTS temp_aunt_uncle AS (
SELECT

p.PersonId as id
,UPPER(p.fullname) AS person
,IF (mother.sinai,mother.fullname,'') as mother
,IF (father.sinai,father.fullname,'') as father
,GROUP_CONCAT(DISTINCT IF (mat_auncle.sinai,mat_auncle.fullname,'') SEPARATOR ', ') as mat_auncles
,GROUP_CONCAT(DISTINCT IF (pat_auncle.sinai,pat_auncle.fullname,'') SEPARATOR ', ') as pat_auncles
,GROUP_CONCAT(DISTINCT IF (pat_auncle_.sinai,pat_auncle_.fullname,'') SEPARATOR ', ') as pat_auncles_
,GROUP_CONCAT(DISTINCT IF (mat_auncle_.sinai,mat_auncle_.fullname,'') SEPARATOR ', ') as mat_auncles_
,GROUP_CONCAT(DISTINCT IF (mat_nibling.sinai,mat_nibling.fullname,'') SEPARATOR ', ') as mat_niblings
,GROUP_CONCAT(DISTINCT IF (pat_nibling.sinai,pat_nibling.fullname,'') SEPARATOR ', ') as pat_niblings
,GROUP_CONCAT(DISTINCT IF (mat_nibling_.sinai,mat_nibling_.fullname,'') SEPARATOR ', ') as mat_niblings_
,GROUP_CONCAT(DISTINCT IF (pat_nibling_.sinai,pat_nibling_.fullname,'') SEPARATOR ', ') as pat_niblings_
,GROUP_CONCAT(DISTINCT IF (firstcousin.sinai OR TRUE,firstcousin.fullname,'') SEPARATOR ', ') as firstcousin

FROM

JewishMeNames AS p

LEFT JOIN JewishMeNames AS mother
ON (p.motherid = mother.PersonId)

-- uncles, aunts, and niblings on mother's side
LEFT JOIN Relationships AS mother2sibling
ON (mother.PersonId = mother2sibling.PersonId
    AND mother2sibling.Relationship_1 IN ("sister of", "brother of"))
LEFT JOIN JewishMeNames AS mat_auncle
ON (mother2sibling.RelRecId2 = mat_auncle.PersonId)
LEFT JOIN JewishMeNames AS mat_auncle_
ON (mat_auncle_.PersonId = mat_auncle.spouseid)
LEFT JOIN JewishMeNames AS mat_nibling
ON (mat_auncle.PersonId IN (mat_nibling.motherid, mat_nibling.fatherid))
LEFT JOIN JewishMeNames AS mat_nibling_
ON (mat_nibling_.PersonId = mat_nibling.spouseid)

LEFT JOIN JewishMeNames AS father
ON (p.fatherid = father.PersonId)

-- uncles, aunts, and niblings on father's side
LEFT JOIN Relationships AS father2sibling
ON (father.PersonId = father2sibling.PersonId
    AND father2sibling.Relationship_1 IN ("sister of", "brother of"))
LEFT JOIN JewishMeNames AS pat_auncle
ON (father2sibling.RelRecId2 = pat_auncle.PersonId)
LEFT JOIN JewishMeNames AS pat_auncle_
ON (pat_auncle_.PersonId = pat_auncle.spouseid)
LEFT JOIN JewishMeNames AS pat_nibling
ON (pat_auncle.PersonId IN (pat_nibling.motherid, pat_nibling.fatherid))
LEFT JOIN JewishMeNames AS pat_nibling_
ON (pat_nibling_.PersonId = pat_nibling.spouseid)

-- first cousins
LEFT JOIN JewishMeNames AS firstcousin
ON (
       firstcousin.motherid = mat_auncle.PersonId
    OR firstcousin.fatherid = mat_auncle.PersonId

    OR firstcousin.motherid = mat_auncle_.PersonId
    OR firstcousin.fatherid = mat_auncle_.PersonId

    OR firstcousin.motherid = pat_auncle.PersonId
    OR firstcousin.fatherid = pat_auncle.PersonId

    OR firstcousin.motherid = pat_auncle_.PersonId
    OR firstcousin.fatherid = pat_auncle_.PersonId
)

WHERE TRUE

AND (p.AASurname = "Tarr")

GROUP BY person, mother, father
);

SELECT * FROM temp_aunt_uncle\G;
