CREATE OR REPLACE VIEW bx.vw_date_open_n_items_for_graph
 AS
 SELECT substring(d.bx_id from 1 for 6)::character varying(7) as bx_id,
    d.date_open,
    max(i.item) AS max_item,
    count(*) AS n_items
   FROM bx.bx_dates d
     LEFT JOIN bx.bx_items i ON d.bx_id::text = i.bx_id::text
  WHERE d.bx_id::text !~~ 'SX%'::text
  GROUP BY d.date_open, substring(d.bx_id from 1 for 6)
  ORDER BY substring(d.bx_id from 1 for 6);


