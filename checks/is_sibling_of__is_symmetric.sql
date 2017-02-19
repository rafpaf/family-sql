-- If this returns anything, then the relation is not symmetric.

select * from is_sibling_of i where not exists (select * from is_sibling_of i2 where i.person_id = i2.relation_id and i.relation_id = i2.person_id);
