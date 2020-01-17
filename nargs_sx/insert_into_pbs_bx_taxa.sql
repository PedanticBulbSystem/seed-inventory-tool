create table bx.taxa
(taxon character varying (100) primary key,
 genus character varying(100)
);

insert into bx.taxa
 select taxon, split_part(taxon,' ',1) as genus
 from bx.bx_items
 group by taxon
 order by taxon
;
