set sql_big_selects=1;

SET @t = 'is_generic_cousin_of';

create table if not exists is_generic_cousin_of like is_child_of;

SELECT @query := CONCAT('RENAME TABLE `', @t, '` TO `backup:',
   @t, '_', CURDATE(), '_', CURTIME(), '`'); PREPARE STMT FROM @query; EXECUTE STMT;

create table if not exists is_generic_cousin_of like is_child_of;

insert ignore into is_generic_cousin_of (person_id, person_fullname,
    relation_id, relation_fullname)

-- inferred from Relationships table
select
p2.id as person_id,
p2.fullname as person_fullname,
p.id as relation_id,
p.fullname as relation_fullname
from JewishMeNames as p
join Relationships r
on p.id = r.PersonId
join JewishMeNames as p2
on p2.id = r.RelRecId2
where r.Relationship_1 = "cousin"
\G;
