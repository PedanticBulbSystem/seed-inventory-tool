--create table srgc.bulb_families (f character varying (100) primary key);
insert into srgc.bulb_families
select srgc_family
from srgc.vw_seedex_join_wiki_genera
group by srgc_family
