select d.dive_date, count(distinct f.taxon) as n_taxa --cumulative_richness
from scratch.dives d
join scratch.fish f on d.dive_id >= f.dive_id --d.dive_id=f.dive_id
group by d.dive_date
order by d.dive_date;
