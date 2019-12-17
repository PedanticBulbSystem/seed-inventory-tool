select d.bx_id, d.date_open, n_items*r.factor as n_items
from bx.pad_rows r
join bx.vw_date_open_n_items_for_graph d -- d for dates
on r.category like 'B'
where r.category like 'B'
order by bx_id, r.sorter
;
