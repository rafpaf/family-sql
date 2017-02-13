SET SQL_BIG_SELECTS=1;

select
-- p.PersonId,
-- p.spouseid, p.motherid, p.fatherid,
UPPER(concat(p.AAFirstName, ' ', p.AASurname)) as person,
if (spouse.Cemetery LIKE '%Sinai%', concat('spouse: ', spouse.AAFirstName, ' ', spouse.AASurname), '') as spouse,
if (mother.Cemetery LIKE '%Sinai%', concat('mother: ', mother.AAFirstName, ' ', mother.AASurname), '') as mother,
if (father.Cemetery LIKE '%Sinai%', concat('father: ', father.AAFirstName, ' ', father.AASurname), '') as father,
concat(
    if (maternalgrandma.Cemetery LIKE '%Sinai%',
        concat(maternalgrandma.AAFirstName, ' ', maternalgrandma.AASurname, ', '), ''),
    if (maternalgrandpa.Cemetery LIKE '%Sinai%',
        concat(maternalgrandpa.AAFirstName, ' ', maternalgrandpa.AASurname, ', '), ''),
    if (paternalgrandma.Cemetery LIKE '%Sinai%',
        concat(paternalgrandma.AAFirstName, ' ', paternalgrandma.AASurname, ', '), ''),
    if (paternalgrandpa.Cemetery LIKE '%Sinai%',
        concat(paternalgrandpa.AAFirstName, ' ', paternalgrandpa.AASurname), '')
    ) as grandparents,
-- concat('aunt/uncle:', auntuncle.AAFirstName, ' ', auntuncle.AASurname) as auntuncle,
concat('children: ', GROUP_CONCAT(DISTINCT IF (child.Cemetery LIKE '%Sinai',concat(child.AAFirstName,' ',child.AASurname),'') SEPARATOR ', ')) as child,
concat('grandchildren: ', GROUP_CONCAT(DISTINCT IF (grandchild.Cemetery LIKE '%Sinai',concat(grandchild.AAFirstName,' ',grandchild.AASurname),'') SEPARATOR ', ')) as grandchild
-- concat('grandparents: ', GROUP_CONCAT(DISTINCT IF (grandparent.Cemetery LIKE '%Sinai',concat(grandparent.AAFirstName,' ',grandparent.AASurname),'') SEPARATOR ', ')) as grandparent
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
                    JOIN
                    JewishMeNames as mother
                    on (p.motherid = mother.PersonId)
                    JOIN
                    JewishMeNames as maternalgrandma
                    on (maternalgrandma.PersonId = mother.motherid)
                    JOIN
                    JewishMeNames as maternalgrandpa
                    on (maternalgrandpa.PersonId = mother.fatherid)
                    -- JOIN
                    -- Relationships as mother2sibling
                    -- ON (mother.PersonId = mother2sibling.PersonId)
                    -- JOIN
                    -- JewishMeNames as auntuncle
                    -- ON (mother2sibling.RelRecId2 = auntuncle.PersonId
                    --     OR mother2sibling.RelRecId2 IS NULL)
                )
                JOIN
                JewishMeNames as father
                on (p.fatherid = father.PersonId)
                JOIN
                JewishMeNames as paternalgrandma
                on (paternalgrandma.PersonId = father.motherid)
                JOIN
                JewishMeNames as paternalgrandpa
                on (paternalgrandpa.PersonId = father.fatherid)
            )
            JOIN
            Relationships as r
            on p.PersonId = r.PersonId
        )
        JOIN
        JewishMeNames as child
        on (r.RelRecId2 = child.PersonId AND r.Relationship_1 IN ('father of', 'mother of'))
    )
    JOIN
    Relationships as child2grandchild
    on (child2grandchild.PersonId = child.PersonId OR child2grandchild.PersonId IS NULL)
)
JOIN
JewishMeNames as grandchild
on (child2grandchild.RelRecId2 = grandchild.PersonId OR child2grandchild.RelRecId2 IS NULL)
-- JOIN
-- JewishMeNames as sibling
-- on p.PersonId = p2sibling.PersonId

where true
-- AND p2child.rel = 'family'
-- AND (r.Relationship_1 IN ('father of', 'mother of') OR r.Relationship_1 IS NULL)
AND (child2grandchild.Relationship_1 IN ('father of', 'mother of') OR child2grandchild.Relationship_1 IS NULL)
-- AND (mother2sibling.Relationship_1 IN ('sister of', 'brother of') OR mother2sibling.Relationship_1 IS NULL)
-- AND r2.rel = 'family'

AND p.PersonId = 2163

group by person, spouse, mother, father, grandparents
limit 200;
