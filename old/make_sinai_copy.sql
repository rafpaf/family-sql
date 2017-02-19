CREATE TABLE sinai LIKE JewishMeNames;
INSERT INTO sinai SELECT * FROM JewishMeNames where Cemetery LIKE '%Sinai%';
