SET SQL_BIG_SELECTS=1;
INSERT INTO person2ancestor (person_id, ancestor_id)
SELECT
p.PersonId as person_id,
p2.PersonId as ancestor_id
FROM person as p
LEFT JOIN person as p2
ON (
    p.motherid = p2.PersonId
    OR p.fatherid = p2.PersonId
    AND p2.PersonId <> 0
);
