SELECT
(SELECT concat(grandchild.AAFirstName, grandchild.AALastName)
    FROM JewishMeNames person
    JOIN JewishMeNames parent
    ON parent.PersonID = person.motherid OR parent.PersonId = person.fatherid)
FROM JewishMeNames
