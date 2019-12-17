select d.bx_id, d.date_open, 
	n_items_all*r.factor as n_items_all,
	n_items_seed*r.factor as n_items_seed,
	n_items_bulb*r.factor as n_items_bulb
from bx.pad_rows r
join bx.vw_bx_date_Nitems_all_Nitems_seed_Nitems_bulb d -- d for dates
on r.category like 'B'
where r.category like 'B'
order by bx_id, r.sorter
limit 1000;
