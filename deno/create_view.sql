--create view deno.vw_taxon_book_germ_join_wiki as
select d.taxon as deno_taxon, --w.taxon as wiki_taxon, b.taxon as bx_taxon, 
coalesce(book,'')||coalesce(sup1,'')||coalesce(sup2,'') as book, germ
, b.taxon as bx_taxon
from deno.taxa d join deno.book_index i on d.taxon=i.taxon
join wiki.taxa w
on lower(d.taxon) like w.taxon
join 
(select taxon from bx.bx_items group by taxon) b
on d.taxon like b.taxon
order by d.taxon, w.taxon, b.taxon
limit 1000;
