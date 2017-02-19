
set sql_big_selects=1;

-- if x is_child_of y and z is_child_of y then x is_sibling_of z
-- this includes half siblings

SET @t = 'is_sibling_of';

create table if not exists is_sibling_of like is_child_of;


SELECT @query := CONCAT('RENAME TABLE `', @t, '` TO `backup:',
   @t, '_', CURDATE(), '_', CURTIME(), '`'); PREPARE STMT FROM @query; EXECUTE STMT;

create table if not exists is_sibling_of like is_child_of;

insert ignore into is_sibling_of (person_id, person_fullname, relation_id, relation_fullname)
select

-- Infer from data (children of the same person are siblings)
distinct
c1.person_id,
c1.person_fullname,
c2.person_id,
c2.person_fullname

from is_child_of c1
join is_child_of c2
where c1.relation_id = c2.relation_id
and c1.person_id <> c2.person_id -- important: the people must be distinct
LIMIT 0, 999999

\G;
