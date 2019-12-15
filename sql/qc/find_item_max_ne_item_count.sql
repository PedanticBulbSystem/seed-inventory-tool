SELECT * FROM bx.vw_date_open_n_items_for_graph
where n_items <> max_item  or max_item is null 
order by bx_id