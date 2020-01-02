create table scratch.fish (
	dive_id char(4),
	obs_id integer,
	taxon char(1),
	constraint fish_pk primary key (dive_id,obs_id)
	);
create table scratch.dives (
	dive_id char(4),
	dive_date date,
	constraint dives_pk primary key (dive_id)	
	);
