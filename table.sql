select
-- p.PersonId,
-- p.spouseid, p.motherid, p.fatherid,
">",
concat(substring_index(p.AAFirstName, " ", 1), ' ', p.AASurname) as person,
concat('spouse: ', substring_index(spouses.AAFirstName, " ", 1), ' ', spouses.AASurname) as spouse,
concat('mother:' , substring_index(mothers.AAFirstName, " ", 1), ' ', mothers.AASurname) as mother,
concat('father: ', substring_index(fathers.AAFirstName, " ", 1), ' ', fathers.AASurname) as father,
-- concat('child: ', substring_index(children.AAFirstName, " ", 1), ' ', children.AASurname) as 'child',
concat('children: ', GROUP_CONCAT(DISTINCT substring_index(children.AAFirstName, " ", 1) SEPARATOR ', ')) as children,
concat('grandchildren: ', GROUP_CONCAT(substring_index(grandchildren.AAFirstName, " ", 1) SEPARATOR ', ')) as grandchildren
from
(
    (
        (
            (
                (
                    (
                        JewishMeNames as p
                        JOIN JewishMeNames as spouses
                        on p.spouseid = spouses.PersonId
                    )
                    JOIN
                    JewishMeNames as mothers
                    on p.motherid = mothers.PersonId
                )
                JOIN
                JewishMeNames as fathers
                on p.fatherid = fathers.PersonId
            )
            JOIN
            Relationships as r
            on r.PersonId = p.PersonId
        )
        JOIN
        JewishMeNames as children
        on r.RelRecId2 = children.PersonId
    )
    JOIN
    Relationships as r2
    on r2.PersonId = children.PersonId
)
JOIN
JewishMeNames as grandchildren
on r2.RelRecId2 = grandchildren.PersonId

where true
-- AND r.rel = 'family'
AND (r.Relationship_1 IN ('father of', 'mother of') OR r.Relationship_1 IS NULL)
AND (r2.Relationship_1 IN ('father of', 'mother of') OR r2.Relationship_1 IS NULL)
-- AND r2.rel = 'family'

AND p.AASurname = "Gleckman"

group by person, spouse, mother, father
limit 200;
