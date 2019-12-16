create view bx.vw_donor_stats 
as
select donor, count(*) as N_items, 
count(distinct bx_id) as N_BXs, 
count(distinct taxon) as N_taxa, 
count(distinct category) as n_categories
from bx.bx_items 
group by donor
order by donor
;
