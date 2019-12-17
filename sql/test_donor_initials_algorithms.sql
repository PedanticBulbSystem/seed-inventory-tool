select donor, 
substring(split_part(donor,' ',1) from 1 for 1)  || '.' ||
substring(split_part(donor,' ',2) from 1 for 1)  || '.' ||
substring(split_part(donor,' ',3) from 1 for 1) as inits,

substring(split_part(donor,' ',1) from 1 for 3)  ||
substring(split_part(donor,' ',2) from 1 for 3)  ||
substring(split_part(donor,' ',3) from 1 for 3) as abbrev,
substring(split_part(donor,' ',1) from 1 for 1)  || '.' || split_part(donor,' ',2) || split_part(donor,' ',3) as FLast

from bx.vw_donor_stats
order by donor
;