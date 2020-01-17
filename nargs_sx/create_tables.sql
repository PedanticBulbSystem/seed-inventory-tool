/* Example data
Seed #  Genus/species   Description     Origin
1       Abies koreana   purple-blue cones 10-18m 58     G
2       Acantholimon hohenackeri        pink flr/blue-grey lvs 5-10cm 156       G
3       Acantholimon sp  156    G
*/

create table nargs.sx_items (
item integer primary key,
taxon character varying(100) not null,
description text,
origin character);

create table nargs.taxa 
(taxon character varying (100)primary key, 
 genus character varying(100));
