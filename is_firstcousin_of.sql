set sql_big_selects=1;

SET @t = 'is_firstcousin_of';

create table if not exists is_firstcousin_of like is_child_of;

SELECT @query := CONCAT('RENAME TABLE `', @t, '` TO `backup:',
   @t, '_', CURDATE(), '_', CURTIME(), '`'); PREPARE STMT FROM @query; EXECUTE STMT;

create table if not exists is_firstcousin_of like is_child_of;

insert into is_firstcousin_of (person_id, person_fullname, relation_id, relation_fullname)
select
distinct
nn.person_id as person_id,
nn.person_fullname as person_fullname,
c.person_id as relation_id,
c.person_fullname as relation_fullname
from is_niecenephew_of as nn
join is_child_of as c
where nn.relation_id = c.relation_id
limit 999999

union

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
where (r.Relationship_1 like "%first cousin%" or r.Relationship_1 like '%1st cousin%')
\G;
