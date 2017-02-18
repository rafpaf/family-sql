SET SQL_BIG_SELECTS=1;

select
p.PersonId as id
,UPPER(p.fullname) AS person
,GROUP_CONCAT(DISTINCT IF (child.sinai OR TRUE,child.fullname,'') SEPARATOR ', ') as children
,GROUP_CONCAT(DISTINCT IF (grandchild.sinai OR TRUE,grandchild.fullname,'') SEPARATOR ', ') as grandchildren
from

JewishMeNames AS p

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
AND (
    child2grandchild.Relationship_1 IN ('father of', 'mother of')
    OR child2grandchild.Relationship_1 IS NULL)

AND (p.AASurname = "Tarr")

GROUP BY person
LIMIT 200;
