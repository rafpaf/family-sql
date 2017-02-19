set sql_big_selects=1;

-- Backup existing table
SET @tablename = 'is_parent_of';

SELECT @query := CONCAT('RENAME TABLE `', @tablename, '` TO `backup:',
    @tablename, '_', CURDATE(), '_', CURTIME(), '`'); PREPARE STMT FROM @query; EXECUTE STMT;

create table if not exists is_parent_of like is_child_of;

insert into is_parent_of (person_id, person_fullname, relation_id,
    relation_fullname)
select

distinct
i.relation_id as person_id,
i.relation_fullname as person_fullname,
i.person_id as relation_id,
i.person_fullname as relation_fullname

from is_child_of i

LIMIT 0, 999999

\G;
