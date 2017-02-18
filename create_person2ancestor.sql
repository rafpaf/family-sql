SET SQL_BIG_SELECTS=1;

DROP TABLE IF EXISTS person2ancestor;

CREATE TABLE IF NOT EXISTS person2ancestor (
    id int not null auto_increment,
    person_id int not null,
    ancestor_id int not null,
    PRIMARY KEY (id)
);

