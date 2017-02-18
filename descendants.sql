SET SQL_BIG_SELECTS=1;

select
-- p.PersonId,
-- p.spouseid, p.motherid, p.fatherid,
UPPER(p.fullname) AS person
,IF (spouse.sinai OR TRUE,spouse.fullname, '') AS spouse
,GROUP_CONCAT(DISTINCT IF (child.sinai OR TRUE,child.fullname,'') SEPARATOR ', ') as children
,GROUP_CONCAT(DISTINCT IF (grandchild.sinai OR TRUE,grandchild.fullname,'') SEPARATOR ', ') as grandchildren
from

JewishMeNames AS p

LEFT JOIN JewishMeNames AS spouse
ON p.spouseid = spouse.PersonId

LEFT JOIN
Relationships AS r
ON p.PersonId = r.PersonId

LEFT JOIN
JewishMeNames AS child
ON (r.RelRecId2 = child.PersonId AND r.Relationship_1 IN ('father of', 'mother of'))

LEFT JOIN
Relationships AS child2grandchild
ON (child2grandchild.PersonId = child.PersonId OR child2grandchild.PersonId IS NULL)

LEFT JOIN
JewishMeNames AS grandchild
ON (child2grandchild.RelRecId2 = grandchild.PersonId OR child2grandchild.RelRecId2 IS NULL)

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

GROUP BY person, spouse
LIMIT 200;
