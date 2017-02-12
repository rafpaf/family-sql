select p.PersonId,
p.spouseid, p.motherid, p.fatherid,
p.AAFirstName, p.AASurname,
spouses.AAFirstName, spouses.AASurname,
mothers.AAFirstName, mothers.AASurname,
fathers.AAFirstName, fathers.AASurname
from
(
    (
        (
            JewishMeNames as p
            LEFT JOIN JewishMeNames as spouses
            on p.spouseid = spouses.PersonId
        )
        LEFT JOIN
        JewishMeNames as mothers
        on p.motherid = mothers.PersonId
    )
    LEFT JOIN
    JewishMeNames as fathers
    on p.fatherid = fathers.PersonId
)
where p.AASurname = "Gleckman"
limit 20;
