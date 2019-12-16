select taxon, count(*) as n_items, count(distinct donor) as n_donors
, count(distinct bx_id) as n_bx
from bx.bx_items
group by taxon
order by count(distinct donor) desc, count(*) desc, taxon
limit 200;
