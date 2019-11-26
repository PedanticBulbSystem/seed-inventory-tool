select bx_id, count(*) as n_items, count(distinct taxon) as n_taxa, count(distinct donor) as n_donors
from bx.bx_items
group by bx_id
order by bx_id