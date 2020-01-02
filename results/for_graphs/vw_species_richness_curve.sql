create view bx.vw_species_richness_curve as
select d.bx_id, d.date_open, count(distinct f.taxon) as n_taxa -- cumulative_richness
from bx.bx_dates d
join bx.bx_items f on d.bx_id >= f.bx_id -- these id must be date-sequential for this to work
group by d.date_open, d.bx_id
order by d.date_open;
--order by d.bx_id; -- this sorts the SX to the very end. SX data is not entered yet. Can filter out sx later.
