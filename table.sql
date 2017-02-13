SET SQL_BIG_SELECTS=1;

select
-- p.PersonId,
-- p.spouseid, p.motherid, p.fatherid,
">",
concat(p.AAFirstName, ' ', p.AASurname) as person,
if (spouse.Cemetery LIKE '%Sinai%', concat('spouse: ', spouse.AAFirstName, ' ', spouse.AASurname), '') as spouse,
if (mother.Cemetery LIKE '%Sinai%', concat('mother: ', mother.AAFirstName, ' ', mother.AASurname), '') as mother,
if (father.Cemetery LIKE '%Sinai%', concat('father: ', father.AAFirstName, ' ', father.AASurname), '') as father,
if (maternalgrandma.Cemetery LIKE '%Sinai%', concat('maternal grandma: ',
    maternalgrandma.AAFirstName, ' ', maternalgrandma.AASurname), '') as
    maternalgrandma,
if (maternalgrandpa.Cemetery LIKE '%Sinai%', concat('maternal grandpa: ',
    maternalgrandpa.AAFirstName, ' ', maternalgrandpa.AASurname), '') as
    maternalgrandpa,
if (paternalgrandma.Cemetery LIKE '%Sinai%', concat('paternal grandma: ',
    paternalgrandma.AAFirstName, ' ', paternalgrandma.AASurname), '') as
    paternalgrandma,
if (paternalgrandpa.Cemetery LIKE '%Sinai%', concat('paternal grandpa: ',
    paternalgrandpa.AAFirstName, ' ', paternalgrandpa.AASurname), '') as
    paternalgrandpa,

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
            Relationships as p2child
            on p2child.PersonId = p2child.PersonId
        )
        JOIN
        JewishMeNames as child
        on (p2child.RelRecId2 = child.PersonId)
    )
    JOIN
    Relationships as child2grandchild
    on (child2grandchild.PersonId = child.PersonId OR child2grandchild.PersonId IS NULL)
)
JOIN
JewishMeNames as grandchild
on (child2grandchild.RelRecId2 = grandchild.PersonId OR child2grandchild.RelRecId2 IS NULL)

where true
-- AND r.rel = 'family'
AND (p2child.Relationship_1 IN ('father of', 'mother of') OR p2child.Relationship_1 IS NULL)
AND (child2grandchild.Relationship_1 IN ('father of', 'mother of') OR child2grandchild.Relationship_1 IS NULL)
-- AND r2.rel = 'family'

-- AND p.AASurname = "Tarr" OR
AND p.AASurname = "Tarr"

group by person, spouse, mother, father,
maternalgrandma, maternalgrandpa,
paternalgrandma, paternalgrandpa
limit 200;
