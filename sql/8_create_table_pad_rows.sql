CREATE TABLE bx.pad_rows
(
    sorter "char" NOT NULL,
    category character varying(7) NOT NULL,
    factor integer,
    CONSTRAINT padrows_pk PRIMARY KEY (category, sorter)
);
