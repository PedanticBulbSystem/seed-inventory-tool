-- only works because on localhost where pg can see filesystem
--
copy bx.bx_items (bx_id, category, donor, item, taxon, notes, photo_link, season) FROM '/Users/gastil/Documents/git/git_pbs/seed-inventory-tool/data/tabular_data/no_quotes_bx341thru350_pipe.csv' DELIMITER '|' CSV HEADER QUOTE '"' NULL 'NA' ESCAPE '"';
