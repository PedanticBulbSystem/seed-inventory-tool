create table deno.taxa (
taxon character varying (100) primary key
);
CREATE SEQUENCE deno.row_num_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;
	
create table deno.book_index (
	autoinc integer NOT NULL DEFAULT nextval('deno.row_num_seq'::regclass),
	taxon character varying (100) not null,
	book character varying (10),
	sup1 character varying (10),
	sup2 character varying (10),
	germ character varying (100),
	constraint deno_index_row_pk primary key (autoinc),
	constraint deno_index_taxon_fk foreign key (taxon) references deno.taxa(taxon)
);
