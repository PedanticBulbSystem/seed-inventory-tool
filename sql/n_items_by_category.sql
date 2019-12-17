SELECT a.bx_id, a.date_open, a.n_items, s.category, s.n_items, b.category, b.n_items
FROM 
(
SELECT d.bx_id, d.date_open, count(*) as n_items
FROM
	bx.bx_dates d
	join bx.bx_items i
	on d.bx_id=i.bx_id
	group by d.bx_id
	) as a
INNER JOIN
(
select i.category, d.bx_id, d.date_open, count(*) as n_items
	from bx.bx_dates d
	left join bx.bx_items i
	on d.bx_id::text = i.bx_id::text
	where i.category like 'SEEDS'
	group by d.bx_id, d.date_open, i.category
) as s
ON a.bx_id=s.bx_id
INNER JOIN
(
select i.category, d.bx_id, d.date_open, count(*) as n_items
	from bx.bx_dates d
	left join bx.bx_items i
	on d.bx_id::text = i.bx_id::text
	where i.category like 'BULBS'
	group by d.bx_id, d.date_open, i.category
) as b
ON a.bx_id=b.bx_id
ORDER BY a.bx_id
