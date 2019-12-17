 --CREATE VIEW bx.vw_listing_format_c AS
  SELECT
         CASE (i.item)::text
             WHEN '1'::text THEN (d.date_open)::text
             ELSE NULL::text
         END AS date_open,
         CASE (i.item)::text
             WHEN '1'::text THEN (d.bx_id)::text
             ELSE NULL::text
         END AS bx_id,
     i.item,
     i.taxon,
     ((("substring"(split_part((i.donor)::text, ' '::text, 1), 1, 1) || '.'::text) || split_part((i.donor)::text, ' '::text, 2)) || split_part((i.donor)::text, ' '::text, 3)) AS donor,
     i.of AS material,
     "substring"((i.category)::text, 1, 1) AS "B/S"
    FROM (bx.bx_items i
      JOIN bx.bx_dates d ON (((i.bx_id)::text = (d.bx_id)::text)))
   ORDER BY d.bx_id, i.item;

