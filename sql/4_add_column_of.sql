ALTER TABLE bx.bx_items
    ADD COLUMN of character varying(100);

COMMENT ON COLUMN bx.bx_items.of
    IS 'ie Small cormlets of, Seedlings of, Tubers of, Offsets of, Leaf bulbils of,...';

