SET SQL_BIG_SELECTS=1;

SELECT

p.PersonId as id
,UPPER(p.fullname) AS person
,IF (spouse.sinai OR TRUE,spouse.fullname, '') AS spouse

FROM

JewishMeNames AS p

LEFT JOIN JewishMeNames AS spouse
ON p.spouseid = spouse.PersonId

WHERE TRUE

AND (p.AASurname = "Tarr");
