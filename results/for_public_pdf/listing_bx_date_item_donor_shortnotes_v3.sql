--CREATE OR REPLACE VIEW bx.vw_listing_format_d  AS
 SELECT
        CASE i.item::text
            WHEN '1'::text THEN d.bx_id::text
			WHEN '2'::text THEN d.date_open::text
            ELSE NULL::text
        END AS "BX_and_date",
		"substring"(i.category::text, 1, 1) AS "B/S",
		i.of||' of' AS "Material",
    i.item as "Item",
    i.taxon as "Taxon",    
	-- donor
	(("substring"(split_part(i.donor::text, ' '::text, 1), 1, 1) || '.'::text) || split_part(i.donor::text, ' '::text, 2)) || split_part(i.donor::text, ' '::text, 3) AS donor
	,
	case i.notes
		when i."of" then ''
		when i."of"||' of %' then replace(notes,"of"||' of ','')
		when lower(i."of")||' of %' then replace(notes,lower("of")||' of ','')
		when lower(i."of") then replace(notes,lower("of"),'')
		--when length(notes) > 100 then substring(i.notes from 1 for 100)||'...'
		else substring(i.notes from 1 for 100)
	end as "Notes"
	--substring(i.notes from 1 for 40) as "Notes"
       
   FROM bx.bx_items i
     JOIN bx.bx_dates d ON i.bx_id::text = d.bx_id::text
  ORDER BY d.bx_id, i.item
;

