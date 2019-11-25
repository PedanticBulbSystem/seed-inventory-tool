create schema bx;

--"BX_ID","category","item","taxon","donor","comment","photo_link","growing_season"
create table bx.bx_items (
    bx_id varchar(6) not null,
    category char(5),
	item decimal not null,
	taxon varchar(100) not null,
	donor varchar(100),
	notes text,
	photo_link varchar(200),
	season char(1),
	constraint bx_item_pk primary key (bx_id,item)
);
/*
integer	string	string	integer Excel date number	dateTime	string
BX_ID_int	date_opened_string	date_opened_regex_formula	date_opened	date_opened_YYYY_MM_DD	closing_date
*/
create table bx.bx_dates (
	bx_id varchar(6) not null,
	date_open date,
	date_close date,
	director_initials varchar(10),
	constraint bx_dates_pk primary key (bx_id)
);