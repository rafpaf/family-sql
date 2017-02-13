-- ALTER TABLE JewishMeNames ADD COLUMN (sinai BOOLEAN, fullname VARCHAR(255));
SET SQL_SAFE_UPDATES=0;
-- UPDATE JewishMeNames set fullname = concat(AAFirstName, ' ', AASurname);
UPDATE JewishMeNames set sinai = (Cemetery LIKE '%Sinai%');
