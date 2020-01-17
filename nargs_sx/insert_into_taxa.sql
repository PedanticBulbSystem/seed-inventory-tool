insert into nargs.taxa
 select taxon, split_part(taxon,' ',1) as genus
 from nargs.sx_items
 group by taxon
 ;
