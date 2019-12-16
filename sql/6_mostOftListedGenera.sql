select split_part(taxon,' ',1) as genus, count(*), count(distinct bx_id),
'BULBS' as category -- 'SEEDS' as category
from bx.bx_items where category like 'BULBS' -- 'SEEDS'
group by split_part(taxon,' ',1)
order by count(*) desc
limit 20;
-- Use this query to report the genera most commonly listed
-- counting how many items and how many BXs
-- Run separately for SEEDS and BULBS rather than a group-by of that.
