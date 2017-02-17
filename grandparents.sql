select
-- p.PersonId,
-- p.spouseid, p.motherid, p.fatherid,
UPPER(p.fullname) AS person
,IF (mother.sinai, mother.fullname, '') AS mother
,IF (father.sinai, father.fullname, '') AS father

-- Maternal bubbe and zayde
,IF (mbubbe.sinai, mbubbe.fullname, '') as mbubbe
,IF (mzayde.sinai, mzayde.fullname, '') as mzayde

-- final underscore means spouse

-- If maternal bubbe's spouse is different from maternal zayde:
,IF (mbubbespouse.PersonId <> mzayde.PersonId
    AND mbubbespouse.sinai, mbubbespouse.fullname, '') as mbubbe_

-- If maternal zayde's spouse is different from maternal bubbe:
,IF (mzaydespouse.PersonId <> mbubbe.PersonId
    AND mzaydespouse.sinai, mzaydespouse.fullname, '') as mzayde_

-- Paternal bubbe and zayde
,IF (pbubbe.sinai, pbubbe.fullname, '') as pbubbe
,IF (pzayde.sinai, pzayde.fullname, '') as pzayde

-- If paternal bubbe's spouse is different from paternal zayde:
,IF (pbubbespouse.PersonId <> pzayde.PersonId
    AND pbubbespouse.sinai, pbubbespouse.fullname, '') as pbubbe_

-- if paternal zayde's spouse is different from paternal bubbe:
,IF (pzaydespouse.PersonId <> pbubbe.PersonId
    AND pzaydespouse.sinai, pzaydespouse.fullname, '') as pzayde_
FROM
JewishMeNames AS p

-- Mother's side
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

-- Father's side
LEFT JOIN JewishMeNames AS father
ON (p.fatherid = father.PersonId)
LEFT JOIN JewishMeNames AS pbubbe
ON (pbubbe.PersonId = father.motherid)
LEFT JOIN JewishMeNames AS pbubbespouse
ON (pbubbespouse.PersonId = pbubbe.spouseid)
LEFT JOIN JewishMeNames AS pzayde
ON (pzayde.PersonId = father.fatherid)
LEFT JOIN JewishMeNames AS pzaydespouse
ON (pzaydespouse.PersonId = pzayde.spouseid)

WHERE TRUE

AND (p.AASurname = "Gleckman")

LIMIT 200\G;
