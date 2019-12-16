select split_part(taxon,' ',1) as genus, 
count(distinct taxon) as n_genera, 
count(*) as n_items, count(distinct d.bx_id) as n_bx, count(distinct donor) as n_donor,
count(distinct date_part('month',date_open)) as n_months, 
min(date_part('month',date_open)) as first_month,
max(date_part('month',date_open)) as last_month,
count(distinct director_initials) as n_drs,
min(date_part('year',date_open)) as first_yr,
max(date_part('year',date_open)) as last_yr,
count(distinct date_part('year',date_open)) as n_yrs, 
case min(category)
	when 'BULBS' then 'B'
    when 'SEEDS' then null
	else 'error'
end as as_bulb,
case max(category)
	when 'SEEDS' then 'S'
    when 'BULBS' then null
	else 'error'
end as as_seed

from bx.bx_items i join bx.bx_dates d on i.bx_id=d.bx_id
group by split_part(taxon,' ',1)
order by count(distinct taxon) desc, count(*) desc, split_part(taxon,' ',1)
;