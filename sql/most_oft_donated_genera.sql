select split_part(taxon,' ',1) as genus_or_1st_word, 
count(distinct taxon) as taxa_starting_with_that_1st_word, 
count(*) as n_items, count(distinct bx_id) as n_bx, count(distinct donor) as n_donor
from bx.bx_items
group by split_part(taxon,' ',1)
order by count(distinct taxon) desc, count(*) desc, split_part(taxon,' ',1)
;
