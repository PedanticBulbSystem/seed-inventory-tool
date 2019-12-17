select 
case item::text 
	when '1' then d.bx_id::text
	else null 
end as bx_id, 
case item::text when '1' then d.date_open::text
else null end as date_open, 
item, taxon, donor
, substring(notes from 1 for 20) as notes
from bx.bx_items i join bx.bx_dates d
on i.bx_id=d.bx_id

order by d.bx_id, item
;
