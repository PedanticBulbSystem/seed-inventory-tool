-- View: bx.vw_date_open_n_items_for_graph

 --DROP VIEW bx.vw_date_open_n_items_for_graph;

--CREATE OR REPLACE VIEW bx.vw_date_open_n_items_for_graph
 --AS
 SELECT d.bx_id,
    d.date_open,
    max(i.item) AS max_item, count(*) AS n_items
   FROM bx.bx_dates d
     LEFT JOIN bx.bx_items i ON d.bx_id::text = i.bx_id::text
  WHERE d.bx_id::text !~~ 'SX%'::text
  GROUP BY d.date_open, d.bx_id
  having max(i.item) <> count(*) OR max(i.item) is null
  ORDER BY d.bx_id;

