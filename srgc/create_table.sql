--drop table srgc.seedex;
create table srgc.seedex (
n integer not null, -- Number
	f character varying (100), -- Family Name
	taxon character varying (100) not null, -- Name, usually GENUS species
	gw character varying (10), -- Garden/Wild either Garden or Wild
	live character varying (3), -- Live material either Yes or null
	y character (4) default '2019', -- year
	constraint seedex_pk primary key (n,y),
	constraint seedex_taxon_uq unique (taxon,gw,live,y)
);