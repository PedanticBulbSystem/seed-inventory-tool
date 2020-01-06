--
-- PostgreSQL database dump
--

-- Dumped from database version 12.0
-- Dumped by pg_dump version 12.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: deno; Type: SCHEMA; Schema: -; Owner: gastil
--

CREATE SCHEMA deno;


ALTER SCHEMA deno OWNER TO gastil;

--
-- Name: row_num_seq; Type: SEQUENCE; Schema: deno; Owner: gastil
--

CREATE SEQUENCE deno.row_num_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE deno.row_num_seq OWNER TO gastil;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: book_index; Type: TABLE; Schema: deno; Owner: gastil
--

CREATE TABLE deno.book_index (
    autoinc integer DEFAULT nextval('deno.row_num_seq'::regclass) NOT NULL,
    taxon character varying(100) NOT NULL,
    book character varying(10),
    sup1 character varying(10),
    sup2 character varying(10),
    germ character varying(100)
);


ALTER TABLE deno.book_index OWNER TO gastil;

--
-- Name: taxa; Type: TABLE; Schema: deno; Owner: gastil
--

CREATE TABLE deno.taxa (
    taxon character varying(100) NOT NULL
);


ALTER TABLE deno.taxa OWNER TO gastil;

--
-- Name: vw_taxon_book_germ_join_wiki; Type: VIEW; Schema: deno; Owner: gastil
--

CREATE VIEW deno.vw_taxon_book_germ_join_wiki AS
 SELECT d.taxon AS deno_taxon,
    (((COALESCE(i.book, ''::character varying))::text || (COALESCE(i.sup1, ''::character varying))::text) || (COALESCE(i.sup2, ''::character varying))::text) AS book,
    i.germ,
    b.taxon AS bx_taxon
   FROM (((deno.taxa d
     JOIN deno.book_index i ON (((d.taxon)::text = (i.taxon)::text)))
     JOIN wiki.taxa w ON ((lower((d.taxon)::text) ~~ w.taxon)))
     LEFT JOIN ( SELECT bx_items.taxon
           FROM bx.bx_items
          GROUP BY bx_items.taxon) b ON (((d.taxon)::text ~~ (b.taxon)::text)))
  ORDER BY d.taxon, w.taxon, b.taxon
 LIMIT 1000;


ALTER TABLE deno.vw_taxon_book_germ_join_wiki OWNER TO gastil;

--
-- Data for Name: book_index; Type: TABLE DATA; Schema: deno; Owner: gastil
--

COPY deno.book_index (autoinc, taxon, book, sup1, sup2, germ) FROM stdin;
376	Abeliophyllum distichum	B	\N	\N	strip, 70
377	Abies alba	\N	\N	2	70D
378	Abies amabilis	B	\N	\N	40-70
379	Abies boris-regis	\N	\N	2	70D
380	Abies cephalonica	\N	\N	2	70D
381	Abies cilicica	\N	\N	2	70D
382	Abies equi-trojani	\N	\N	2	70L (6w)- 70D
383	Abies fabri	\N	\N	2	70L
384	Abies firma	\N	\N	2	70D
385	Abies holophylla	\N	\N	2	70D
386	Abies koreana	B	\N	\N	40-70D
387	Abies nephrolepsiis	\N	\N	2	70D
388	Abies nordmanniana	\N	\N	2	70D
389	Abies nordmanniana	B	\N	\N	70D
390	Abies pindrow	\N	\N	2	70D
391	Abies recurvata	\N	\N	2	70D
392	Abies religiosa	\N	\N	2	70D
393	Abies veitchii	\N	\N	2	70D
394	Abies veitchii	\N	1	\N	70D
395	Abies veitchii	B	\N	\N	70D
396	Abronia fragrans	B	\N	\N	70
397	Abronia villosa	B	\N	\N	70
398	Abutilon (hybrids)	\N	1	\N	70
399	Abutilon theophrasti	B	\N	\N	puncture, 70
400	Abutilon vitifolium	\N	\N	2	70D
401	Abutilon vitifolium	\N	1	\N	70
402	Acacia cyanophylla	\N	\N	2	puncture, 70D
403	Acacia cyanophylla	\N	1	\N	puncture, 70
404	Acacia dealbata	\N	\N	2	puncture, 70D
405	Acacia dealbata	\N	1	\N	puncture, 70
406	Acacia iteophylla	\N	\N	2	puncture, 70D
407	Acacia iteophylla	\N	1	\N	puncture, 70
408	Acacia iteophylla	B	\N	\N	puncture, 70
409	Acaena anserinifolia	B	\N	\N	70
410	Acaena caesiiglauca	\N	\N	2	DS 3 y = dead
411	Acaena inermis	B	\N	\N	70D-40-70D
412	Acaena microphylla	\N	\N	2	DS 3 y = dead
413	Acaena nova-zelandiae	\N	\N	2	DS 3 y = dead
414	Acaena saccaticupula	\N	\N	2	70D
415	Acaena splendens	B	\N	\N	70
416	Acanthocalycium peitscherianum	\N	1c	\N	70 GA-3
417	Acanthocalycium spiniflorum	\N	1c	\N	70 GA-3
418	Acanthocalycium violaceum	\N	1c	\N	70
419	Acantholimon araxanum	B	\N	\N	D-70
420	Acantholimon armenum	B	\N	\N	D-70
421	Acantholimon bracteatum	B	\N	\N	D-70
422	Acantholimon caryophyllaceum	B	\N	\N	D-70
423	Acantholimon diapensoides	B	\N	\N	D-70
424	Acantholimon glumaceum	B	\N	\N	D-70
425	Acantholimon hedinum	B	\N	\N	D-70
426	Acantholimon hilariae	B	\N	\N	D-70
427	Acantholimon litvinovii	B	\N	\N	D-70
428	Acantholimon pamiricum	B	\N	\N	D-70
429	Acantholimon parviflorum	B	\N	\N	D-70
430	Acantholimon pterostegium	B	\N	\N	D-70
431	Acantholimon puberulum	B	\N	\N	no germ
432	Acantholimon pulchellum	B	\N	\N	no germ
433	Acantholimon raddeanum	B	\N	\N	no germ
434	Acantholimon reflexifolium	B	\N	\N	D-70
435	Acantholimon spirizianum	B	\N	\N	D-70
436	Acantholimon ulcinum	B	\N	\N	no germ
437	Acantholimon vedicum	B	\N	\N	D-70
438	Acantholimon velutinum	B	\N	\N	no germ
439	Acantholimon venustum	B	\N	\N	D-70
440	Acanthophyllum glandulosum	B	\N	\N	no germ
441	Acanthophyllum gypsophiloides	B	\N	\N	40-70
442	Acanthophyllum macrocephalum	B	\N	\N	no germ
443	Acanthophyllum pungens	B	\N	\N	40-70
444	Acanthophyllum shugnanicum	B	\N	\N	OT
445	Acanthophyllum sordidum	B	\N	\N	no germ
446	Acanthus balcanicus	\N	1	\N	70D
447	Acanthus mollis	\N	1	\N	70D
448	Acer buergerianum	B	\N	\N	40
449	Acer crataegifolium	B	\N	\N	extract, 40-70
450	Acer ginnala	\N	\N	2	40-70
451	Acer ginnala v. aidzvense	B	\N	\N	40
452	Acer griseum	\N	1	\N	comment
453	Acer griseum	B	\N	\N	extract, 40-70
454	Acer heldreichii	B	\N	\N	rotted
455	Acer japonicum	B	\N	\N	40-crack-70
456	Acer negundo	B	\N	\N	puncture, 70
457	Acer nikoense	\N	1	\N	nick
458	Acer nikoense	B	\N	\N	soak, extract, 70
459	Acer pennsylvanicum	B	\N	\N	extract, 40
460	Acer platanoides	B	\N	\N	40-70
461	Acer pseudoplatanus	\N	1	\N	extract, nick
462	Acer pseudoplatanus 	B	\N	\N	soak, extract, 70
463	Acer pseudosieboldiana	\N	1	\N	extract, nick
464	Acer pseudosieboldiana	B	\N	\N	soak, extract, 70
465	Acer rubrum	\N	1	\N	comment
466	Acer rubrum	B	\N	\N	70
467	Acer saccharinum	\N	1	\N	40, 70
468	Acer saccharum	B	\N	\N	70
469	Acer semenovii	B	\N	\N	40
470	Acer spicatum 	B	\N	\N	extract, 70D-40-70D
471	Acer tataricum	B	\N	\N	40-extract-70
472	Acer truncatum	\N	1	\N	extract, peel
473	Achillea millefolium	B	\N	\N	D-70
474	Achlys triphylla 	\N	\N	2	40-70
475	Acidanthera bicolor	B	\N	\N	70
476	Acinos alpinus	\N	1	\N	70L
477	Aciphylla aurea	\N	1	\N	70D-40-70
478	Aciphylla aurea	B	\N	\N	70 GA-3
479	Aciphylla dobsonii	B	\N	\N	70 GA-3
480	Aciphylla hectori	B	\N	\N	70 GA-3
481	Aciphylla monroi	\N	1	\N	70-40-70-40-70
482	Ackama roseifolia	\N	\N	2	70L
483	Acnistus australis	\N	\N	2	70L
484	Aconitum ajanense	B	\N	\N	rotted
485	Aconitum apetalum	B	\N	\N	rotted
486	Aconitum ferox	B	\N	\N	40 4 w, 55 3 m
487	Aconitum firmum	B	\N	\N	rotted
488	Aconitum heterophyllum	B	\N	\N	70L
489	Aconitum lycoctorum	B	\N	\N	40 4 w, 55 3 m
490	Aconitum macrostynchium	B	\N	\N	rotted
491	Aconitum napellus	\N	1	\N	rotted
492	Aconitum napellus	B	\N	\N	rotted
493	Aconitum nasutum	B	\N	\N	rotted
494	Aconitum orientale	B	\N	\N	rotted
495	Aconitum pubiceps	B	\N	\N	rotted
496	Aconitum raddeanum	B	\N	\N	rotted
497	Aconitum variagatum	B	\N	\N	rotted
498	Aconitum volubile	B	\N	\N	rotted
499	Aconitum vulparia	\N	1	\N	comment
500	Aconitum vulparia	B	\N	\N	rotted
501	Aconitum wilsoni	B	\N	\N	40
502	Actaea erythrocarpa	B	\N	\N	WC 7 d, OT-70
503	Actaea pachypoda	B	\N	\N	WC 7 d, 40-70-40-40~70
504	Actaea rubra	B	\N	\N	WC 7 d, 40-70-40-40~70
505	Actaea spicata	B	\N	\N	WC 7 d, DS 6 m, 70-40-OT
506	Actinidia chinensis	B	\N	\N	WC 7 d, 70L
507	Actinomeris alternifolia	\N	\N	2	chaff
508	Actinotus helianthii	\N	\N	2	empty
509	Adenium obesum	B	\N	\N	70
510	Adenophora farreri	B	\N	\N	70D
511	Adenophora koreana	B	\N	\N	70L
512	Adenophora kurilensis	B	\N	\N	70D GA-3
513	Adenophora lilifolia	B	\N	\N	70D
514	Adenophora potanini	B	\N	\N	70D
515	Adenophora tashiroi	B	\N	\N	70D
516	Adenostoma facsiculatum	\N	1	\N	70 GA-3
517	Adlumia fungosa	B	\N	\N	70
518	Adonis aestivalis	B	\N	\N	D-70
519	Adonis amurensis	B	\N	\N	no germ
520	Adonis brevistylis	B	\N	\N	no germ
521	Adonis chrysocyathus	B	\N	\N	OT
522	Adonis pyrenaica	B	\N	\N	no germ
523	Adonis turkestanica	B	\N	\N	empty
524	Adonis vernalis	\N	\N	2	empty
525	Adonis vernalis	\N	1	\N	empty
526	Adonis vernalis	B	\N	\N	40
527	Aeniopsis cabolica	\N	1	\N	70D
528	Aeonium simsii	\N	1	\N	70L
529	Aeonium tabuliforme	\N	1	\N	70L
530	Aesculus discolor	\N	1	\N	70
531	Aesculus glabra	\N	1	\N	40-70
532	Aesculus hippocastanum	\N	1	\N	40-70
533	Aesculus hippocastanum	B	\N	\N	40-70
534	Aesculus octandra	\N	1	\N	40-70
535	Aesculus parviflora	\N	1	\N	70
536	Aesculus parviflora serotina	\N	1	\N	70
537	Aesculus pavia	\N	1	\N	40-70
538	Aesculus pavia	B	\N	\N	40-70
539	Aesculus sylvatica	\N	1	\N	70
540	Aesculus turbinata	\N	1	\N	40-70
541	Aesculus turbinata tomentosa (A. chinensis)	\N	1	\N	40-70
542	Aesculus x carnea	\N	1	\N	70
543	Aethephyllum pinnatifidum	\N	\N	2	70D or L
544	Aethephyllum pinnatifidum	\N	1	\N	70D
545	Aethionema grandiflorum	B	\N	\N	D-40
546	Aethiopsis cabolica	\N	\N	2	70D
547	Agalinis setacea	B	\N	\N	OT
548	Agapanthus africanus	B	\N	\N	70
549	Agastache anisata	B	\N	\N	70
550	Agastache foeniculum	\N	\N	2	OK after DS 6 m
551	Agastache foeniculum	B	\N	\N	40-70L
552	Agastache fragrans	B	\N	\N	70
553	Agastache nepetoides	\N	1	\N	70L
554	Agastache nepetoides	B	\N	\N	40-70L
555	Agastache occidentalis	\N	\N	2	70L
556	Agastache occidentalis	\N	1	\N	70L
557	Agastache scrophulariaefolia	\N	1	\N	70L
558	Agastache scrophulariaefolia	B	\N	\N	40-70L
559	Agastache urticifolium	B	\N	\N	70
560	Agathosma ovata	\N	\N	2	rotted
561	Agave (Manfreda) virginica	B	\N	\N	40-70D
562	Ageratina occidentale	\N	\N	2	70D
563	Ageratina occidentale	\N	1	\N	70D
564	Ageratum sp.	\N	\N	2	50-85DorL
565	Agrimonia eupatoria	\N	1	\N	40
566	Agrophyron pubiflorum	\N	\N	2	70DorL
567	Agrophyron scabrum	\N	\N	2	70DorL
568	Agrostemma githago	\N	\N	2	70D
569	Agrostemma tinicola	\N	\N	2	70D
570	Agrostemma tinicola	\N	1	\N	70D
571	Agrostocrinum scabrum	\N	1	\N	empty
572	Aichryson divaricatum	B	\N	\N	70D GA-3
573	Ailanthus altissima	B	\N	\N	70L
574	Ajania tibetica	B	\N	\N	70
575	Ajuga chamaepitys	B	\N	\N	70 GA-3
576	Akebia quinata	\N	1	\N	40-70
577	Alangium platanifolium	\N	1	\N	70 GA-3
578	Albizzia julibrissin	\N	\N	2	puncture, 70D
579	Albizzia julibrissin	B	\N	\N	comment
580	Albuca aurea	\N	\N	2	70DorL
581	Albuca aurea 	\N	1	\N	70
582	Albuca canadensis	\N	\N	2	70D
583	Albuca canadensis	\N	1	\N	70D
584	Albuca humilis	\N	\N	2	70D
585	Albuca humilis	\N	1	\N	70
586	Albuca longifolia	\N	\N	2	rotted
587	Albuca shawii	\N	\N	2	70D
588	Albuca sp.	\N	1	\N	70
589	Alcea ficifolia	\N	\N	2	70D
590	Alcea ficifolia	\N	1	\N	70D
591	Alcea rosea	\N	1	\N	D-70
592	Alchemilla alpina	\N	1	\N	70D-40-OS
593	Alchemilla faeronensis	\N	1	\N	OT
594	Alchemilla mollis	\N	1	\N	OT
595	Alchemilla mollis	B	\N	\N	70L
596	Alchemilla saxatilis	\N	1	\N	OT
597	Alchemilla saxatilis	B	\N	\N	40-70L
598	Alchemilla vulgaris	\N	1	\N	OT
599	Aletes humilis	\N	\N	2	40-70D
600	Aletris farinosa	B	\N	\N	70L
601	Alisma plantago-aquatica	\N	\N	2	70L-40-70D
602	Alisma plantago-aquatica	B	\N	\N	70L
603	Allardia tridactylites	\N	\N	2	chaff
604	Allium aff. farreri	\N	1	\N	40
605	Allium alba	\N	1	\N	70D
606	Allium alba	\N	\N	2	DS 2 y = dead
607	Allium albopilosum	\N	1	\N	40
608	Allium albopilosum	B	\N	\N	40
609	Allium azureum	B	\N	\N	70
610	Allium cernuum	B	\N	\N	70
611	Allium christophii	B	\N	\N	40
612	Allium falcifolium	B	\N	\N	70-40-70
613	Allium flavum	\N	\N	2	DS 4 y = dead
614	Allium giganteum	B	\N	\N	70-40
615	Allium goodingii	B	\N	\N	70D
616	Allium karataviense	\N	1	\N	OT
617	Allium karataviense	B	\N	\N	70-40-70-40-70-40-70
618	Allium moly	\N	1	\N	40-70
619	Allium moly	B	\N	\N	40
620	Allium pulchellum	\N	\N	2	DS 6 y = dead
621	Allium pulchellum 	B	\N	\N	40-70-40-70-40-70
622	Allium schubertii	\N	1	\N	70D
623	Allium tanguticum	B	\N	\N	70
624	Allium tricoccum	B	\N	\N	40-70
625	Allium unifolium	\N	\N	2	40
626	Allium vulgaris	\N	1	\N	70 GA-3
627	Alnus crispa	\N	1	\N	70L
628	Alnus glutinosa	\N	1	\N	70L
629	Alnus hirsuta v. hirsuta	\N	1	\N	70L
630	Alnus japonica	\N	1	\N	no germ
631	Alnus maritima	\N	1	\N	no germ
632	Alnus rugosa	\N	1	\N	OT
633	Alnus serrulata	\N	1	\N	40-70D
634	Alonsoa linearis	B	\N	\N	70
635	Alonsoa meridionalis	\N	\N	2	70L
636	Alonsoa warscewiczii	\N	\N	2	70L
637	Alonsoa warscewiczii	B	\N	\N	70D
638	Alophia drummondi	\N	\N	2	70L (8w)- 70D
639	Alophia drummondi	B	\N	\N	70-40-70
640	Alophia lahue	\N	\N	2	70L (8w)- 70D
641	Alstroemeria (hybrids)	B	\N	\N	70
642	Alstroemeria aurantiaca	B	\N	\N	70
643	Alstroemeria aurea	B	\N	\N	70 4 w, 40
644	Alstroemeria garaventae	\N	\N	2	70D (4w)-40
645	Alstroemeria haemantha	B	\N	\N	70
646	Alstroemeria ligtu	\N	\N	2	70D-40-70D-40
647	Alstroemeria pallida	B	\N	\N	70 4 w, 40
648	Alstroemeria sp.	B	\N	\N	70 4 w, 40
649	Alstroemeria umbellata	B	\N	\N	40
650	Althaea hirsuta	\N	\N	2	puncture, 70
651	Althaea hirsuta	\N	1	\N	puncture, 70
652	Althaea officinalis 	\N	1	\N	D-70
653	Althaea rosea	\N	\N	2	60
654	Alyssoides utriculata	B	\N	\N	70D
655	Alyssum saxatile	\N	\N	2	70D
656	Alyssum saxatile	B	\N	\N	D-70
657	Alyssum sp.	\N	\N	2	50-85DorL
658	Amaranthus caudatus	\N	\N	2	70L
659	Amaranthus cruentus	\N	1	\N	70
660	Amaranthus hypochondriacus	\N	1	\N	70
661	Ambrosia mexicana	\N	\N	2	70L
662	Amelanchier alnifolia 	B	\N	\N	comment
663	Amelanchier canadensis	B	\N	\N	comment
664	Amelanchier grandiflora	\N	\N	2	70D-40-70D-40-70D
665	Amelanchier grandiflora	\N	1	\N	WC 7 d, 40-70
666	Amelanchier laevis	\N	\N	2	70D-40-70D-40
667	Amelanchier laevis	\N	1	\N	WC 7 d, 70-40-70-40
668	Amelanchier sanguinea	\N	1	\N	WC 7 d, 40-70-40-70
669	Amelanchier stolonifera	\N	\N	2	70D-40-70D-40-70D
670	Amelanchier stolonifera	\N	1	\N	WC 7 d, 40-70
671	Amethystia caerulea	\N	1	\N	70D
672	Ammi majus	\N	1	\N	70D
673	Ammi visnaga	\N	1	\N	D-70
674	Amorpha fruticosa	\N	\N	2	DS 4 y = dead
675	Amorpha fruticosa	\N	1	\N	puncture, 70
676	Amsonia jonesii	\N	1	\N	40-70D
677	Amsonia montana	B	\N	\N	70
678	Amsonia tabernaemontana	B	\N	\N	40-70
679	Amsonia tomentosa	\N	\N	2	70D
680	Amsonia tomentosa	\N	1	\N	70D
681	Anacampseros ruffescens	\N	1	\N	70L
682	Anacyclus depressus	B	\N	\N	70
683	Anagallis arvensis	\N	1	\N	60-65
684	Anagallis linifolia	\N	\N	2	70D
685	Anagallis linifolia	\N	1	\N	70D
686	Anaphalis triplinervis	B	\N	\N	70
687	Anaphalis virgata	B	\N	\N	70
688	Anchusa angutissima	\N	1	\N	70L
689	Anchusa azurea	B	\N	\N	70L
690	Anchusa azurea 	\N	1	\N	70
691	Anchusa officinalis	\N	\N	2	70D
692	Anchusa officinalis	\N	1	\N	70D
693	Ancistrocactus brevinamatus	\N	1c	\N	70 GA-3
694	Ancistrocactus scheeri	\N	1c	\N	70
695	Androcymbium rechingeri	B	\N	\N	70-40
696	Androcymbium striatum	\N	\N	2	70D
697	Andropogon gerardii	Bg	\N	\N	D-70
698	Andropogon scoparia	Bg	\N	\N	D-70
699	Androsace alpina	B	\N	\N	70
700	Androsace armeniaca	B	\N	\N	70
701	Androsace barbulata	B	\N	\N	70
702	Androsace carnea	\N	\N	2	40
703	Androsace chamaejasme ssp. carinata	B	\N	\N	70
704	Androsace charpentieri	B	\N	\N	OT
705	Androsace cylindrica	B	\N	\N	OT
706	Androsace elongata	B	\N	\N	70
707	Androsace geraniifolia	B	\N	\N	70
708	Androsace hedreantha	B	\N	\N	OT
709	Androsace kochii ssp. tauricola	B	\N	\N	70
710	Androsace lactea	B	\N	\N	40-70-40-70
711	Androsace lanuginosa	B	\N	\N	70
712	Androsace mucronifolia	B	\N	\N	40-70
713	Androsace multiscapa	B	\N	\N	70L
714	Androsace muscoides	B	\N	\N	70
715	Androsace obtusifolia	B	\N	\N	40
716	Androsace rotundifolia	B	\N	\N	70
717	Androsace sempervivoides	B	\N	\N	70
718	Androsace septentrionalis	B	\N	\N	70
719	Androsace sericea	B	\N	\N	40-70
720	Androsace spinulifera	B	\N	\N	70
721	Androsace studiosorum	B	\N	\N	40-70
722	Androsace vandellii	B	\N	\N	70
723	Androsace villosa	B	\N	\N	70
724	Androsace villosa v. congesta	B	\N	\N	40-70
725	Androstephium breviflorum	B	\N	\N	40
726	Andryala agardhii	B	\N	\N	70
727	Anelsonia eurycarpa	\N	\N	2	rotted
728	Anemonastrum fasculatum v. roseum	B	\N	\N	40-70-40
729	Anemonastrum protractum	B	\N	\N	OT
730	Anemonastrum speciosum	B	\N	\N	rotted
731	Anemone altaica	B	\N	\N	70
732	Anemone baicalensis	B	\N	\N	70
733	Anemone baldensis	B	\N	\N	70
734	Anemone biamiensis	B	\N	\N	70
735	Anemone biflora	B	\N	\N	no germ
736	Anemone blanda	B	\N	\N	40-70-40
737	Anemone caucasica	B	\N	\N	rotted
738	Anemone crinita	B	\N	\N	D-70
739	Anemone cylindrica	B	\N	\N	D-70
740	Anemone demissa	B	\N	\N	70
741	Anemone drummondi	B	\N	\N	70
742	Anemone fasciculata	B	\N	\N	70
743	Anemone fasciculatum v. roseum	B	\N	\N	40-70-40
744	Anemone japonica	\N	1	\N	no germ
745	Anemone kurilensis	B	\N	\N	clean, 70
746	Anemone lesseri	B	\N	\N	70D
747	Anemone loesseri rubra	B	\N	\N	70
748	Anemone magellanica	\N	\N	2	DS 3 y = dead
749	Anemone multifida	\N	\N	2	70D
750	Anemone narcissiflora	B	\N	\N	OT
751	Anemone narcissiflora 'zephyra'	B	\N	\N	70
752	Anemone nemorosa	\N	\N	2	comment
753	Anemone nemorosa	\N	1	\N	70-40
754	Anemone nemorosa	B	\N	\N	rotted
755	Anemone obtusiloba	B	\N	\N	rotted
756	Anemone occidentalis	\N	\N	2	70D
757	Anemone occidentalis	B	\N	\N	70
758	Anemone palmata	B	\N	\N	70
759	Anemone pavoniana	B	\N	\N	70
760	Anemone polyanthes	B	\N	\N	rotted
761	Anemone ranunculoides	\N	\N	2	70D-40-70D-40
762	Anemone ranunculoides 	\N	1	\N	70-40-70-40
763	Anemone rivularis	B	\N	\N	40-70L
764	Anemone rupicola	B	\N	\N	70
765	Anemone sylvestris	B	\N	\N	70
766	Anemone tetonensis	B	\N	\N	rotted
767	Anemone tetrasepala	B	\N	\N	40-70
768	Anemone vitifolia	B	\N	\N	70
769	Anemonella thalictroides	B	\N	\N	70D-40-70L
770	Anemonopsis macrophylla	B	\N	\N	70-40-70-40-70
771	Anethum graveolens	B	\N	\N	70
772	Angelica archangelica	\N	1	\N	70L
773	Angelica gigas	B	\N	\N	70L
774	Angelica grayi	B	\N	\N	70L
775	Anigozanthos falvidus	\N	\N	2	70D
776	Anigozanthos flavidus	\N	1	\N	70D
777	Anigozanthos manglesii	\N	1	\N	70D
778	Anisodontea capensis 	\N	\N	2	40-70D
779	Anisotome aromatica	B	\N	\N	40-70
780	Anisotome haastii	B	\N	\N	40-70
781	Annona cherimola	\N	\N	2	WC 7 d, 70D
782	Annona cherimosa	\N	1	\N	no germ
783	Anoda sp.	\N	\N	2	rotted
784	Anthemis montana	B	\N	\N	70
785	Anthericum liliago	B	\N	\N	40-70
786	Anthericum racemosum	\N	1	\N	70 GA-3
787	Anthericum racemosum	B	\N	\N	40-70
788	Anthericum torreyi	B	\N	\N	70D
789	Anthriscus cerefolium	\N	1	\N	70
790	Anthriscus cerefolium	B	\N	\N	70L
791	Anthyllis montana	B	\N	\N	puncture, 70
792	Anthyllis vulneraria	B	\N	\N	puncture, 70
793	Antigon leptopus	\N	1	\N	70
794	Antirrhinum major	\N	\N	2	70D
795	Antirrhinum majus	B	\N	\N	D-70
796	Aphananthe aspersa	B	\N	\N	40
797	Apium graveolens	\N	\N	2	70D
798	Apium graveolens	\N	1	\N	70
799	Aquilegia akitensis	B	\N	\N	70
800	Aquilegia atravinosa	B	\N	\N	40-70-40
801	Aquilegia barnebyi	B	\N	\N	40-70
802	Aquilegia canadensis	\N	1	\N	comment
803	Aquilegia canadensis	B	\N	\N	70 GA-3
804	Aquilegia chrysantha	\N	\N	2	70 GA-3
805	Aquilegia coerulea	B	\N	\N	70 GA-3
806	Aquilegia discolor	\N	1	\N	70 GA-3
807	Aquilegia elegantula	B	\N	\N	70 GA-3
808	Aquilegia eximia	B	\N	\N	70D
809	Aquilegia flabellata nana	B	\N	\N	70 GA-3
810	Aquilegia flavescens	B	\N	\N	OT
811	Aquilegia formosa	\N	\N	2	40-70D
812	Aquilegia formosa	B	\N	\N	40-70
813	Aquilegia fragrans	\N	1	\N	70L
814	Aquilegia fragrans	B	\N	\N	70-40-70
815	Aquilegia japonica	\N	\N	2	70 GA-3
816	Aquilegia jonesii	B	\N	\N	70-40-70
817	Aquilegia jonesii x saximontana	B	\N	\N	40-70-40-70
818	Aquilegia jucunda	B	\N	\N	OT
819	Aquilegia laramiensis	B	\N	\N	70 GA-3
820	Aquilegia micrantha	B	\N	\N	70
821	Aquilegia olympica	B	\N	\N	OT
822	Aquilegia pyrenaica	B	\N	\N	70
823	Aquilegia saximontana	B	\N	\N	70 GA-3
824	Aquilegia scopulorum	\N	\N	2	70 GA-3
825	Aquilegia scopulorum	\N	1	\N	70 GA-3
826	Aquilegia scopulorum	B	\N	\N	70 GA-3
827	Aquilegia skinneri	B	\N	\N	70
828	Aquilegia sp. (Darwas)	B	\N	\N	70 GA-3
829	Aquilegia tridentata	B	\N	\N	40
830	Aquilegia vulgaris	\N	\N	2	comment
831	Aquilegia vulgaris	\N	1	\N	comment
832	Aquilegia vulgaris	B	\N	\N	70 GA-3
833	Arabis albida	B	\N	\N	70
834	Arabis alpina	B	\N	\N	70
835	Arabis bellidifolia	B	\N	\N	70
836	Arabis blepharophylla	B	\N	\N	70
837	Arabis petraea	B	\N	\N	70
838	Arabis pumila	B	\N	\N	70
839	Arabis purpurea	B	\N	\N	70
840	Aralia californica	\N	1	\N	70D-40-70D
841	Aralia elata	\N	1	\N	70 GA-3
842	Aralia hispida	B	\N	\N	40-70
843	Aralia nudicaulis	\N	\N	2	no germ
844	Aralia nudicaulis	\N	1	\N	no germ
845	Aralia racemosa	B	\N	\N	OT
846	Araujia seridifera	\N	\N	2	70L
847	Arbutus menziesii	\N	\N	2	70D
848	Arbutus menziesii	\N	1	\N	40
849	Arbutus menziesii	B	\N	\N	40-70
850	Arctium lappa	\N	1	\N	D-70
851	Arctomecon californica	\N	1	\N	70 GA-3
852	Arctomecon humilis	\N	1	\N	no germ
853	Arctostaphylos columbiana x uva-ursi	B	\N	\N	OT
854	Arctostaphylos crustacea	\N	\N	2	70 GA-3 40-70D-40-70D
855	Arctostaphylos crustacea	\N	1	\N	70 GA-3 40-70
856	Arctostaphylos nevadensis	B	\N	\N	70-40-70-40
857	Arctostaphylos patula	\N	1	\N	70 GA-3 40-70
858	Arctostaphylos pungens	\N	\N	2	70 GA-3
859	Arctostaphylos pungens	\N	1	\N	WC 14 d, 70 GA-3 40-70
860	Arctostaphylos pungens	B	\N	\N	70 GA-3
861	Arctostaphylos uva-ursi	\N	1	\N	70 GA-3 40
862	Arctostaphylos uva-ursi	B	\N	\N	70-40-70
863	Ardisia crenata	\N	\N	2	rotted
864	Ardisia crenata	\N	1	\N	no germ
865	Ardisia crispa	\N	\N	2	DS 1 y = dead
866	Arenaria caroliniana	B	\N	\N	OT
867	Arenaria hookeri	\N	1	\N	70D
868	Arenaria kingii	B	\N	\N	70
869	Arenaria norvegica	\N	1	\N	70 GA-3
870	Arenaria polaris	B	\N	\N	70
871	Arenaria procera	B	\N	\N	70
872	Arenaria pseudoacantholimon	B	\N	\N	70
873	Arenaria purpurescens	B	\N	\N	70
874	Arenaria saxosa	B	\N	\N	70
875	Arenaria stricta	B	\N	\N	70
876	Arenaria tmolea	B	\N	\N	70 GA-3
877	Arequipa erectocylindrica	\N	1c	\N	70 GA-3
878	Arequipa sp. 'tachna'	\N	1c	\N	70
879	Arequipa weingartiana	\N	1c	\N	70 GA-3
880	Arethusa bulbosa	Bo	\N	\N	comment
881	Argemone grandiflora	\N	1	\N	70D
882	Argemone hispida	\N	1	\N	70 GA-3
883	Argemone munita	\N	\N	2	70 GA-3
884	Argemone munita	\N	1	\N	70 GA-3
885	Argemone pleicantha	\N	1	\N	OT
886	Argemone pleicantha	B	\N	\N	OT
887	Argylia adscendens	B	\N	\N	70L
888	Argylia potentillifolia	B	\N	\N	70L
889	Argylia sp.	B	\N	\N	40-70D
890	Argyranthemum sp.	\N	\N	2	chaff
891	Argyreia nervosa	\N	1	\N	70D
892	Argyroderma congregatum	\N	1	\N	70
893	Ariocarpus agavoides	\N	1c	\N	70
894	Ariocarpus kotschoubeyanus	\N	1c	\N	70 GA-3
895	Ariocarpus retusus	\N	1c	\N	70 GA-3
896	Ariocarpus trigonus	\N	1c	\N	no germ
897	Arisaema amurense	\N	1	\N	70D
898	Arisaema consanguineum	B	\N	\N	70
899	Arisaema dracontium	B	\N	\N	OT, WC 14 d, 70
900	Arisaema flavum	B	\N	\N	70
901	Arisaema jacquemonti	B	\N	\N	70
902	Arisaema nepenthioides	B	\N	\N	40
903	Arisaema quinata	\N	1	\N	comment
904	Arisaema quinquifolium	\N	1	\N	misnamed, = A quinata
905	Arisaema quinquifolium	B	\N	\N	OT, WC 14 d, 70
906	Arisaema sikokianum	B	\N	\N	40
907	Arisaema thunbergii	B	\N	\N	70
908	Arisaema tortuosum	B	\N	\N	70
909	Arisaema triphyllum	B	\N	\N	OT, WC 14 d, 70
910	Aristea ecklonii	\N	\N	2	empty
911	Aristolochia baetica	B	\N	\N	40-70L
912	Aristolochia macrophylla	\N	1	\N	70L
913	Aristolochia serpentaria	B	\N	\N	40-70-40-70-40-70
914	Aristotelia fruticosa x serrata	\N	\N	2	empty
915	Armataocereus matulanensis	\N	1c	\N	70 GA-3
916	Armenaica sibirica	B	\N	\N	40
917	Armeria caespitosa	B	\N	\N	70
918	Armeria corsica	B	\N	\N	70
919	Armeria maritima	\N	\N	2	70D
920	Armeria maritima	\N	1	\N	70D
921	Armeria tweedyi	B	\N	\N	70
922	Arnebia echioides	B	\N	\N	70 GA-3
923	Arnebia euchroma	B	\N	\N	70
924	Arnica frigida	B	\N	\N	70
925	Arnica montana	B	\N	\N	70
926	Aronia arbutifolia	\N	\N	2	no germ
927	Aronia arbutifolia	\N	1	\N	no germ
928	Aronia melanocarpa	\N	1	\N	70L-40-70L
929	Artemesia pamirica	\N	\N	2	70D
930	Artemisia caucasica	B	\N	\N	D-70D
931	Artemisia frigida	B	\N	\N	D-70D
932	Artemisia pamirica	\N	1	\N	70D
933	Artemisia pamirica	B	\N	\N	D-70D
934	Arthropodium cirrhatum	\N	\N	2	70 GA-3
935	Arthropodium cirrhatum	B	\N	\N	70 GA-3
936	Arthropodium cirrhatum 	\N	1	\N	70 GA-3 40-70-40
937	Arum concinnatum	\N	\N	2	70D
938	Arum cyrenaicum	\N	\N	2	70D
939	Arum dioscoridis	\N	\N	2	70D
940	Arum italicum	\N	\N	2	70D-40-70D
941	Arum maculatum	B	\N	\N	40-70-40-70-40
942	Arum nigrum	\N	\N	2	70D-40-70D
943	Aruncus dioicus	\N	1	\N	70L
944	Aruncus dioicus	B	\N	\N	70L
945	Aruncus sylvestris	\N	1	\N	70L
946	Aruncus sylvestris	B	\N	\N	70L
947	Asarina barclaiana	\N	\N	2	70D
948	Asarina barclaiana	\N	1	\N	70L
949	Asarina procumbens	B	\N	\N	70L
950	Asarina purpusii	\N	\N	2	70D
951	Asarum canadensis	B	\N	\N	WC 14 d, 40-70
952	Asarum europaeus	B	\N	\N	WC 7 d, 70-40
953	Asclepias cordifolia	\N	\N	2	DS 20 y = dead
954	Asclepias cryptoceras	\N	1	\N	40-70
955	Asclepias erosa	\N	\N	2	DS 20 y = dead
956	Asclepias incarnata	B	\N	\N	40-70L
957	Asclepias phytolaccoides	B	\N	\N	70L
958	Asclepias quadrifolia	B	\N	\N	70L-40-70L
959	Asclepias speciosa	\N	\N	2	DS 20 y = dead
960	Asclepias syriacus	B	\N	\N	40-70L
961	Asclepias tuberosa	B	\N	\N	40-70
962	Asclepias viridiflorus	B	\N	\N	40-70
963	Asimina triloba	\N	1	\N	40-70
964	Asimina triloba	B	\N	\N	WC 14 d, 40-70
965	Asparagus officinalis	B	\N	\N	WC 4 d, 70
966	Asparagus sprengeri	\N	\N	2	70D
967	Asparagus sprengeri	\N	1	\N	WC 1 d, 70D
968	Asperula arvensis	B	\N	\N	40
969	Asperula orientalis	B	\N	\N	70
970	Asperula pontica	B	\N	\N	70
971	Asperula tinctoria	B	\N	\N	70
972	Asphodeline brevicaulis	\N	\N	2	70D
973	Asphodeline brevicaulis	\N	1	\N	70D
974	Asphodeline liburnica	\N	\N	2	70D
975	Asphodeline liburnica	\N	1	\N	70D
976	Asphodeline lutea	\N	\N	2	70D
977	Asphodeline lutea	\N	1	\N	70D
978	Asphodeline lutea	B	\N	\N	70
979	Asphodeline microcarpus	\N	\N	2	70D
980	Asphodelus aestivus	\N	\N	2	70D
981	Asphodelus albus	\N	\N	2	70D-40
982	Asphodelus albus	\N	1	\N	40-70D
983	Asphodelus cerasiferus	\N	\N	2	70D
984	Asphodelus fistulosus	\N	\N	2	70D
985	Asphodelus fistulosus	\N	1	\N	70D
986	Asphodelus fistulosus	B	\N	\N	40
987	Asphodelus luteus	\N	\N	2	70D
988	Asphodelus microcarpus	\N	\N	2	70D
989	Asphodelus ramosus	\N	\N	2	70D-40
990	Astelboides	B	\N	\N	see Rodgersia
991	Astelia nervosa	B	\N	\N	40-70-40-70
992	Aster alpellus	B	\N	\N	D-70
993	Aster alpigenus v haydenii	\N	\N	2	70D
994	Aster alpinus	\N	1	\N	70D
995	Aster alpinus	B	\N	\N	70
996	Aster bigelovii	B	\N	\N	70
997	Aster brachytrichus	B	\N	\N	D-70
998	Aster coloradoensis	B	\N	\N	D-70
999	Aster ericoides	B	\N	\N	70
1000	Aster farreri	B	\N	\N	D-70
1001	Aster himalaicus	B	\N	\N	D-70
1002	Aster likiangensis	B	\N	\N	D-70
1003	Aster nova-anglae	B	\N	\N	70
1004	Aster oblongifolius	B	\N	\N	70
1005	Aster sibirica	B	\N	\N	D-70
1006	Aster tibeticus	B	\N	\N	D-70
1007	Asteromoa mongolica	\N	\N	2	70D
1008	Asteromoa mongolica	\N	1	\N	70D
1009	Asteromoa mongolica	B	\N	\N	70
1010	Astilbe biternata	B	\N	\N	70L
1011	Astilbe chinensis	B	\N	\N	70L
1012	Astilboides tabularis	B	\N	\N	comment (Rodgersia)
1013	Astragalus glycyphyllos	\N	1	\N	puncture, 40-70
1014	Astragalus glycyphyllos	B	\N	\N	puncture, 70D
1015	Astragalus membranaceous	\N	1	\N	comment
1016	Astragalus sp.	B	\N	\N	70
1017	Astragalus whitneyi	B	\N	\N	70
1018	Astrantia carniolica rubra	\N	\N	2	70D-40
1019	Astrantia involucrata	\N	\N	2	70D-40
1020	Astrantia major	\N	\N	2	70D-40
1021	Astrantia major	B	\N	\N	40
1022	Astrantia major 	\N	1	\N	70-40
1023	Astrantia minor	\N	\N	2	40-70D-40
1024	Astrantia minor	\N	1	\N	70-40
1025	Astrophytum asterias	\N	1c	\N	70 GA-3
1026	Astrophytum capricorne crassispinum	\N	1c	\N	70 GA-3
1027	Astrophytum coahuilense	\N	1c	\N	70 GA-3
1028	Astrophytum x 'sen-as'	\N	1c	\N	70 GA-3
1029	Asyneuma limoniflium	\N	\N	2	70D
1030	Asyneuma limonifolium	\N	1	\N	70D
1031	Athamanta turbith	B	\N	\N	70
1032	Atractyloides japonica	\N	1	\N	chaff
1033	Atriplex canescens	\N	\N	2	70D GA-4 or GA-7
1034	Atriplex hymenolytra 	\N	1	\N	extract, 70D
1035	Atriplex longipes	\N	1	\N	OT
1036	Atropa belladonna	B	\N	\N	70 GA-3
1037	Aubrieta deltoides	B	\N	\N	70
1038	Aubrietia grandiflora	\N	1	\N	70D
1039	Aucuba japonica	B	\N	\N	70
1040	Aureolaria virginica	B	\N	\N	40-70
1041	Austrocactus bertinii	\N	1c	\N	70 GA-3
1042	Austrocactus bertinii 'patagonicus'	\N	1c	\N	no germ
1043	Austrocylindropuntia floccosa	\N	1c	\N	no germ
1044	Austrocylindropuntia haematacantha	\N	1c	\N	no germ
1045	Austrocylindropuntia inarmata	\N	1c	\N	no germ
1046	Austrocylindropuntia shaferi	\N	1c	\N	70 GA-3
1047	Austrocylindropuntia weingartiana	\N	1c	\N	no germ
1048	Averrhoa carambola	\N	\N	2	70L
1049	Azorina vidallii	\N	\N	2	70L
1050	Azorina vidallii	\N	1	\N	70L
1051	Aztekium ritteri	\N	1c	\N	70 GA-3
1052	Babiana dregei	\N	\N	2	70D
1053	Babiana tubulosa	\N	\N	2	70D
1054	Baeometra uniflora 	\N	\N	2	70L-40
1055	Ballota pseudodictamnus	B	\N	\N	70
1056	Balsamorhiza hookeri	B	\N	\N	70
1057	Balsamorhiza sagitatta	B	\N	\N	70 GA-3
1058	Bambusa arundinacea	\N	\N	2	70L
1059	Banksia integrifolia	\N	\N	2	comment
1060	Banksia prionotes	\N	\N	2	comment
1061	Banksia sp.	\N	1	\N	comment
1062	Baptisia australis	\N	\N	2	puncture, 70D
1063	Baptisia australis	\N	1	\N	puncture, 70D
1064	Baptisia australis	B	\N	\N	70
1065	Baptisia leucophaea	B	\N	\N	OT
1066	Baptisia viridis	\N	\N	2	puncture, 70D
1067	Baptisia viridis	\N	1	\N	puncture, 70D
1068	Barbarea rupicola	\N	\N	2	empty
1069	Barbarea sp.	\N	\N	2	70D
1070	Barbarea vulgaris	\N	1	\N	70L
1071	Barbarea vulgaris variegata	\N	\N	2	70L
1072	Barleria obtusa	\N	\N	2	empty
1073	Bartsia alpina 	\N	1	\N	70 GA-3
1074	Bauhinia monandra	B	\N	\N	70D
1075	Bauhinia purpurea	B	\N	\N	70D
1076	Baumea articulata	\N	\N	2	no germ
1077	Begonia dioica	B	\N	\N	D-70
1078	Begonia evansiana	B	\N	\N	D-70
1079	Begonia hirta	\N	\N	2	DS 3 y = dead
1080	Begonia picta	B	\N	\N	D-70
1081	Begonia semperflorens	\N	\N	2	70L
1082	Begonia suffruticosa	\N	\N	2	70D
1083	Begonia suffruticosa	\N	1	\N	70
1084	Begonia tuber hybrida	\N	\N	2	60L
1085	Belamcanda chinensis	\N	\N	2	DS 5 y = dead
1086	Belamcanda chinensis	B	\N	\N	70
1087	Bellevalia dubia	B	\N	\N	D-40
1088	Bellevalia pycnantha	B	\N	\N	D-40
1089	Bellevalia romana	B	\N	\N	D-40
1090	Bensoniella oregona	B	\N	\N	70L
1091	Berardia subacaulis	\N	\N	2	70D
1092	Berardia subacaulis	\N	1	\N	70D
1093	Berberis julianae	B	\N	\N	WC 7 d, 40
1094	Berberis sphaerocarpa	B	\N	\N	WC 7 d, 70
1095	Berberis thunbergii	B	\N	\N	WC 7 d, 40-70
1096	Bergenia ciliata	B	\N	\N	70
1097	Berlandiera lyrata	\N	\N	2	70
1098	Berlandiera lyrata	\N	1	\N	70D
1099	Bertholletia excelsa	\N	1	\N	comment
1100	Berzelia galpinii	\N	\N	2	70L
1101	Berzelia lanuginosa	\N	\N	2	70L
1102	Berzelia rubra	\N	\N	2	70L
1103	Beschorneria bracteata	\N	1	\N	70D
1104	Beschorneria yuccoides	\N	\N	2	70D-40
1105	Bessya alpina	\N	1	\N	70D-40-70D
1106	Beta vulgare	\N	\N	2	70
1107	Betula delavayi	B	\N	\N	70
1108	Betula ermanii	B	\N	\N	70L
1109	Betula glandulosa	\N	1	\N	40-70D
1110	Betula lenta	B	\N	\N	40-70
1111	Betula lutea	B	\N	\N	40-70
1112	Betula nana	\N	1	\N	70 GA-3
1113	Betula pendula	B	\N	\N	70
1114	Betula platyphylla japonica	\N	1	\N	70L
1115	Betula populifolia	\N	1	\N	70L
1116	Betula populifolia	B	\N	\N	70L
1117	Betula pubescens	\N	1	\N	70L
1118	Betula tianschanica	B	\N	\N	40-70L
1119	Bidens ferrucaefolia	\N	\N	2	70D
1120	Billardiera longiflora 	\N	\N	2	70 GA-3 - 40
1121	Billardiera longiflora fructoalba	\N	\N	2	70 GA-3
1122	Biscutella coronopifolia	\N	1	\N	70D
1123	Bitium	\N	1	\N	see Chenopodium
1124	Bixa orellana	\N	1	\N	70
1125	Bixa orellana	B	\N	\N	70
1126	Blackstonia perfoliata	B	\N	\N	70
1127	Blephilia hirsuta	\N	1	\N	70L
1128	Bloomeria crocea	\N	1	\N	40
1129	Blossfelldia iliputana	\N	1c	\N	no germ
1130	Boenninghausenia albiflora	\N	1	\N	70D
1131	Bolboschoenus caldwellii	\N	\N	2	40-70L
1132	Bolboschoenus fluviatilis	\N	\N	2	40-70L
1133	Bomarea sp.	\N	\N	2	70D-40-70D-40-70D-40-70D-40-70D-40-70D
1134	Bomarea sp.	\N	1	\N	70 GA-3
1135	Bombax malabaricum	\N	1	\N	70D
1136	Bongardia sp.	B	\N	\N	40
1137	Borago officinalis	\N	1	\N	D-70
1138	Borago officinalis	B	\N	\N	70D GA-3
1139	Boronia ledifolia	\N	\N	2	rotted
1140	Boronia megastigma	\N	\N	2	rotted
1141	Bouteloua curtipendula	Bg	\N	\N	D-70
1142	Bouteloua gracilis	Bg	\N	\N	D-70
1143	Boykinia aconitifolia	\N	\N	2	70L
1144	Brachiaria dictyoneura	\N	\N	2	70 GA-3
1145	Brachiaria dictyoneura 	\N	1	\N	D-70 OS
1146	Brachycome iberidifolia	\N	\N	2	70D
1147	Brachycome iberidifolia	B	\N	\N	70
1148	Brachyglottis bellidioides	\N	1	\N	70L
1149	Brassica olearaceae	B	\N	\N	70L
1150	Braya alpina	\N	1	\N	70L
1151	Briggsia aurantiaca	B	\N	\N	70L
1152	Brimeura amethystina	B	\N	\N	40-70-40
1153	Brimeura amethystina 	\N	1	\N	40-70-40
1154	Brimeura amethystina alba	\N	1	\N	70L-40
1155	Brimeura pulchella	\N	1	\N	40
1156	Briza maxima	Bg	\N	\N	D-70
1157	Brodiae congesta	B	\N	\N	40
1158	Brodiae douglasii	B	\N	\N	40-70
1159	Brodiae pulchella	B	\N	\N	40
1160	Brodiaea laxa	\N	\N	2	70D-40
1161	Bromus macrostachys	Bg	\N	\N	D-70
1162	Broussonetia papyrifera	\N	\N	2	DS 2 y = dead
1163	Broussonetia papyrifera	\N	1	\N	70D-40-70D
1164	Browallia sp.	\N	\N	2	comment
1165	Browningia candelaris	\N	\N	2c	50-70 GA-3 or GA-4
1166	Bruckenthalia spiculifolia	B	\N	\N	70
1167	Brugmansia suaveolens	\N	\N	2	70L-40-70L
1168	Brunia laevis	\N	\N	2	rotted
1169	Brunia stokei	\N	\N	2	rotted
1170	Buddleia davidii	B	\N	\N	70L
1171	Buddleia davidii	\N	1	\N	70L
1172	Buddleia globosa	\N	\N	2	70
1173	Buiningia aurea	\N	1c	\N	no germ
1174	Buiningia brevicylindrica	\N	1c	\N	no germ
1175	Bulbine annua	\N	\N	2	70
1176	Bulbine annua	\N	1	\N	70L
1177	Bulbine bulbosa	\N	\N	2	70
1178	Bulbine bulbosa	\N	1	\N	70
1179	Bulbine caulescens	\N	\N	2	70
1180	Bulbine caulescens	\N	1	\N	70
1181	Bulbine frutescens	\N	\N	2	70
1182	Bulbine frutescens	\N	1	\N	70
1183	Bulbine glauca	\N	\N	2	rotted
1184	Bulbine semibarbata	\N	\N	2	70D
1185	Bulbinella hookeri	B	\N	\N	40-70-40
1186	Bulbocodium vernum	B	\N	\N	70-40-70-40
1187	Bupleurum aureum	B	\N	\N	40
1188	Bupleurum longifolium	\N	\N	2	70D-40
1189	Bupleurum longifolium	\N	1	\N	70-40-70-40
1190	Bupleurum ranunculoides	\N	\N	2	70D
1191	Bupleurum ranunculoides	\N	1	\N	70D
1192	Bupleurum rotundifolium	\N	\N	2	40
1193	Bupleurum rotundifolium 	\N	1	\N	40
1194	Bupleurum spinosum	B	\N	\N	70D-40
1195	Butia capitata	\N	\N	2	comment
1196	Butia capitata v. odorata	\N	1	\N	no germ
1197	Butomus umbellatus	B	\N	\N	40-70L
1198	Caesalpina pulcherrima	\N	1	\N	rotted
1199	Caesalpinia pulcherrima	\N	\N	2	rotted
1200	Cajanus cajon	\N	1	\N	70D
1201	Cajophora acuminata	\N	\N	2	DS 1 y = dead
1202	Cajophora acuminata	\N	1	\N	70D
1203	Cajophora coronata	B	\N	\N	70L
1204	Cajophora laterita	B	\N	\N	70D
1205	Calamagrostis acutiflora	Bg	\N	\N	D-70
1206	Calandrinia acutisepala	\N	\N	2	empty
1207	Calandrinia caespitosa	B	\N	\N	40-70
1208	Calandrinia caespitosa	\N	\N	2	empty
1209	Calandrinia grandiflora	B	\N	\N	70
1210	Calandrinia umbellata	B	\N	\N	70
1211	Calastrus scandens	B	\N	\N	WC, 70
1212	Calceolaria (annual hybrids)	\N	\N	2	55-75
1213	Calceolaria falklandica	B	\N	\N	70
1214	Calendula officinalis	\N	1	\N	D-70
1215	Callianthemum sp.	B	\N	\N	no germ
1216	Callicarpa dichotoma	B	\N	\N	70
1217	Callicarpa japonica	B	\N	\N	WC, 70L
1218	Callistemon sp.	B	\N	\N	70L
1219	Callistemon speciosus	\N	1	\N	70D
1220	Callistemon speciosus	B	\N	\N	70L
1221	Callistemon speciosus 	\N	\N	2	70D
1222	Callistephus chinensis	\N	\N	2	50-85
1223	Callitris canescens	\N	\N	2	70D-40
1224	Callitris rhomboidea	\N	1	\N	70
1225	Calluna vulgaris	B	\N	\N	70D GA-3
1226	Calochortus aureus	B	\N	\N	40
1227	Calochortus gunnisonii	B	\N	\N	40
1228	Calochortus kennedyi	\N	1	\N	40
1229	Calochortus sp.	B	\N	\N	40
1230	Calonycton aculeatum	\N	1	\N	comment
1231	Caloscordum neriniflorum	B	\N	\N	70
1232	Calothamnus quadrifidus	\N	1	\N	70L
1233	Calothamnus quadrifidus	B	\N	\N	70L
1234	Caltha biflora	B	\N	\N	40-70
1235	Caltha leptosepala	B	\N	\N	OT
1236	Caltha palustris	\N	1	\N	70 GA-3
1237	Caltha palustris	B	\N	\N	OT
1238	Calycanthus floridus	B	\N	\N	70
1239	Calycocarpum lyoni	\N	\N	2	40-70D-40
1240	Calycocarpum lyoni	\N	1	\N	40-70D-40
1241	Calydorea amabilis	\N	\N	2	70D
1242	Calydorea nuda	\N	\N	2	70D
1243	Calydorea pallens	\N	\N	2	70L
1244	Calydorea speciosa	\N	\N	2	70D
1245	Calydorea xiphioides	\N	\N	2	70L-40
1246	Calylophus lavandulifolius	\N	1	\N	70D
1247	Calylophus lavandulifolius	B	\N	\N	70
1248	Calyptridium monospermum	\N	1	\N	70L
1249	Calyptridium umbellatum	\N	1	\N	70 GA-3
1250	Calyptridium umbellatum	B	\N	\N	70L
1251	Camassia leichtlinii	B	\N	\N	40-40
1252	Camassia leichtlinii v. suksdorfii	B	\N	\N	40-40
1253	Campanula (annuals)	\N	\N	2	55-85
1254	Campanula alliarifolia	B	\N	\N	40-70
1255	Campanula allioni	B	\N	\N	D-70
1256	Campanula alpina	B	\N	\N	D-70
1257	Campanula altaica	B	\N	\N	40-70
1258	Campanula americana	B	\N	\N	D-70 40-70
1259	Campanula aucheri	B	\N	\N	D-70
1260	Campanula barbata	B	\N	\N	D-70
1261	Campanula bellidifolia	B	\N	\N	D-70
1262	Campanula betulaefolia	B	\N	\N	70
1263	Campanula caespitosa	B	\N	\N	70
1264	Campanula carpathica	B	\N	\N	D-70
1265	Campanula carpatica alba	\N	\N	2	70D
1266	Campanula cashmeriana	B	\N	\N	70
1267	Campanula cenisia	B	\N	\N	70
1268	Campanula chamissonii	B	\N	\N	70
1269	Campanula cochlearifolia	B	\N	\N	D-70
1270	Campanula collina	B	\N	\N	D-70
1271	Campanula coriacea	B	\N	\N	70
1272	Campanula finitima	B	\N	\N	D-70
1273	Campanula formanekiana	B	\N	\N	D-70
1274	Campanula garganica	B	\N	\N	D-70
1275	Campanula glomerata	B	\N	\N	D-70
1276	Campanula glomerata acaulis	B	\N	\N	70L
1277	Campanula gracilis	B	\N	\N	D-70
1278	Campanula hawkinsiana	B	\N	\N	D-70
1279	Campanula incurva	\N	\N	2	70L
1280	Campanula jenkinsae	B	\N	\N	D-70
1281	Campanula latifolia	\N	\N	2	70D
1282	Campanula latifolia	\N	1	\N	70
1283	Campanula latifolia alba	\N	\N	2	comment
1284	Campanula latifolia alba	\N	1	\N	70D
1285	Campanula latiloba	B	\N	\N	40
1286	Campanula linearifolia	B	\N	\N	70L
1287	Campanula linifolia	B	\N	\N	D-70
1288	Campanula longistyla	B	\N	\N	D-70
1289	Campanula lyrata	B	\N	\N	70
1290	Campanula medium	B	\N	\N	70
1291	Campanula moesica	B	\N	\N	D-70
1292	Campanula napuligera	B	\N	\N	D-70
1293	Campanula ossetica	B	\N	\N	70L
1294	Campanula pallida	B	\N	\N	40-70
1295	Campanula persicifolia	B	\N	\N	D-70
1296	Campanula pilosa	B	\N	\N	D-70
1297	Campanula pulla	B	\N	\N	D-70
1298	Campanula punctata	B	\N	\N	70L
1299	Campanula pyramidalis	\N	\N	2	70D
1300	Campanula pyramidalis	B	\N	\N	70
1301	Campanula raddeana	B	\N	\N	D-70
1302	Campanula ramosissima	B	\N	\N	D-70L
1303	Campanula rapunculoides	B	\N	\N	D-70 40-70
1304	Campanula rotundifolia	B	\N	\N	D-70
1305	Campanula sarmakadensis	B	\N	\N	70L
1306	Campanula sarmatica	B	\N	\N	D-70
1307	Campanula saxifraga	B	\N	\N	D-70
1308	Campanula scabrella	B	\N	\N	70L
1309	Campanula scheuzeri	B	\N	\N	D-70
1310	Campanula shetleri	\N	\N	2	40-70D
1311	Campanula sibirica	B	\N	\N	D-70
1312	Campanula spicata	B	\N	\N	70
1313	Campanula steveni	B	\N	\N	D-70
1314	Campanula takesimana	B	\N	\N	70L
1315	Campanula taurica	B	\N	\N	70
1316	Campanula thrysoides	\N	\N	2	DS 4 y = dead
1317	Campanula trautvetteri	B	\N	\N	70
1318	Campanula tridentata	B	\N	\N	D-70
1319	Campsis radicans	B	\N	\N	soak, strip, 70L
1320	Canna indica	B	\N	\N	comment
1321	Cannabis sativa	\N	1	\N	70
1322	Capparis spinosa	B	\N	\N	70 GA-3
1323	Capparis spinosa 	\N	1	\N	70 GA-3 40-70
1324	Capsicum annuum	\N	\N	2	70D
1325	Capsicum annuum	\N	1	\N	70L
1326	Capsicum frutescens	\N	\N	2	WC, 70
1327	Capsicum frutescens	\N	1	\N	70D
1328	Capsicum frutescens	B	\N	\N	WC, 70D
1329	Capsicus pubescens	\N	1	\N	70
1330	Cardamine pennsylvanica	\N	1	\N	70L
1331	Cardiocrinum cordatum v. glehnii	\N	\N	2	40-70D-40-70D-40-70D-40-70D-40-70D-40-70D
1332	Cardiocrinum cordatum v. glehnii	\N	1	\N	no germ
1333	Cardiocrinum giganteum	\N	1	\N	40-70-40-70-40
1334	Cardiocrinum giganteum	B	\N	\N	40-70-40-70-40
1335	Cardiospermum halicacabum	B	\N	\N	70L
1336	Carex arenaria	\N	\N	2	70L
1337	Carex arenaria	\N	1	\N	70L
1338	Carex comans	\N	\N	2	70L
1339	Carex comans	\N	1	\N	70L
1340	Carex grayi	\N	\N	2	70L
1341	Carex grayi	\N	1	\N	70L
1342	Carex lurida	\N	\N	2	70L
1343	Carex lurida	\N	1	\N	70L
1344	Carex muskingumensis	\N	1	\N	70L
1345	Carex pendula	\N	\N	2	70L
1346	Carex pendula	\N	1	\N	70L
1347	Carex retrorsa	\N	\N	2	70L
1348	Carex retrorsa	\N	1	\N	70L-40-70L
1349	Carex secta	\N	\N	2	DS 7 y = dead
1350	Carex stricta	\N	1	\N	70L
1351	Carica papaya	\N	\N	2	70L
1352	Carica papaya	\N	1	\N	70L
1353	Carlina acaulis	B	\N	\N	70L
1354	Carmichaelia apressa	\N	1	\N	puncture, 70
1355	Carmichaelia monroi	\N	1	\N	puncture, 70
1356	Carnegia gigantea	\N	1c	\N	70
1357	Carpentaria californica	\N	\N	2	70L
1358	Carrica papaya	B	\N	\N	WC 7 d, 70L
1359	Carthamus tinctorious	B	\N	\N	70
1360	Carum caryi	\N	\N	2	70L
1361	Carum caryi	\N	1	\N	70L
1362	Carya sp.	\N	1	\N	rotted
1363	Caryopteris incana	B	\N	\N	70
1364	Cassiope fastigiata	B	\N	\N	70L
1365	Castanea sativa	\N	1	\N	extract, peel, 70
1366	Castanea sinensis	\N	1	\N	extract, peel, 70
1367	Castillea parviflora	\N	1	\N	70D
1368	Castilleja integra	B	\N	\N	70
1369	Castilleja miniata	B	\N	\N	70-40
1370	Castilleja parviflora	B	\N	\N	70D
1371	Castilleja rhexifolia	B	\N	\N	70-40
1372	Castilleja sp. 	B	\N	\N	40
1373	Casuarina sp.	\N	1	\N	70
1374	Catalpa bignonioides	\N	\N	2	70L
1375	Catalpa bignonioides	\N	1	\N	70L
1376	Catalpa bignonioides	B	\N	\N	70L
1377	Catharanthus roseus	\N	1	\N	70
1378	Caulophyllum thalictroides	\N	\N	2	no germ
1379	Caulophyllum thalictroides	\N	1	\N	OT
1380	Caulophyllum thalictroides	B	\N	\N	WC 7 d, 40-70-40-70-OT
1381	Cautleya spicata	\N	1	\N	70D
1382	Ceanothus americana	B	\N	\N	extract, OT
1383	Cedrela sinensis	\N	1	\N	70D
1384	Cedrus atlantica	B	\N	\N	40
1385	Celmisia armstrongii	B	\N	\N	D-70
1386	Celmisia dallii	B	\N	\N	D-70
1387	Celmisia monroi	B	\N	\N	D-70
1388	Celmisia semicordata	B	\N	\N	D-70
1389	Celmisia spectabilis	B	\N	\N	D-70
1390	Celmisia traversii	B	\N	\N	D-70
1391	Celosia argentea	\N	\N	2	70
1392	Celtis tenuifolia 	B	\N	\N	D-40 OT
1393	Centaurea maculosa	B	\N	\N	D-70
1394	Centaurium erythraea	B	\N	\N	70
1395	Centaurium meyeri	B	\N	\N	70
1396	Centaurium muhlenbergii	\N	\N	2	70D
1397	Centaurium muhlenbergii	\N	1	\N	70D
1398	Centaurium pulchellum	B	\N	\N	D-70L
1399	Centaurium scilloides	B	\N	\N	D-70L
1400	Centranthus ruber	B	\N	\N	70
1401	Cephalanthus occidentalis	B	\N	\N	70L
1402	Cephalaria gigantea	\N	\N	2	DS 4 y = dead
1403	Cephalaria leucantha	B	\N	\N	70L
1404	Cephalocereus alensis	\N	1c	\N	70
1405	Cephalocereus royenii	\N	1c	\N	70
1406	Cephalocereus senilis	\N	\N	2c	70 GA-4
1407	Cephalocereus senilis	\N	1c	\N	70
1408	Cerastium alpinum	B	\N	\N	D-70
1409	Cerastium bossieri	\N	\N	2	70D
1410	Cerastium candidissimum	B	\N	\N	D-70
1411	Cerastium fontanum	\N	\N	2	DS 3 y = dead
1412	Cerastium fontanum	\N	1	\N	70L
1413	Cerastium maximum	B	\N	\N	D-70
1414	Cerastium montanum	B	\N	\N	D-70
1415	Cerastium uniflorum	B	\N	\N	D-70
1416	Ceratotheca triloba	\N	1	\N	70
1417	Cercidiphyllum japonicum	B	\N	\N	40-70
1418	Cercis canadensis alba	B	\N	\N	puncture, 70
1419	Cercis chinensis	B	\N	\N	40-70
1420	Cercocarpus betuloides	B	\N	\N	70D
1421	Cercocarpus intricatus	\N	\N	2	40
1422	Cercocarpus intricatus	\N	1	\N	70D-40-70D
1423	Cereus aethiops	\N	1c	\N	70 GA-3
1424	Cereus validus	\N	1c	\N	70 GA-3
1425	Cerinthe major	\N	\N	2	70 GA-3
1426	Cerinthe major	\N	1	\N	70 GA-3
1427	Cestrum nocturnum	\N	1	\N	70L
1428	Chaenactis douglasii	B	\N	\N	40
1429	Chaenomeles japonica	B	\N	\N	WC, 40-70
1430	Chaenomeles sinensis	\N	\N	2	40
1431	Chaenomeles sinensis	\N	1	\N	WC 7 d, 70
1432	Chaenorrhinum oreganifolium	B	\N	\N	70L
1433	Chaerophyllum hirsutum	\N	\N	2	no germ
1434	Chamaebatia millefolium	\N	1	\N	70
1435	Chamaebatia millefolium 	\N	\N	2	70
1436	Chamaechaenactis scaposa	B	\N	\N	70
1437	Chamaecytisus austriacus	\N	\N	2	puncture, 70D
1438	Chamaecytisus austriacus	\N	1	\N	puncture, 70
1439	Chamaecytisus austriacus	B	\N	\N	puncture, 70
1440	Chamaedaphne calyculata	\N	\N	2	70L
1441	Chamaedaphne calyculata	\N	1	\N	70 GA-3
1442	Chamaelirium luteum	\N	\N	2	70D
1443	Chamaemelum nobile	\N	1	\N	D-70
1444	Chamaespartium sagitate	\N	\N	2	70D
1445	Chasmanthe floribunda	\N	\N	2	70D-40
1446	Cheiranthus cheiri	\N	\N	2	50-85
1447	Cheiranthus cheiri	B	\N	\N	70
1448	Chelidonium majus	B	\N	\N	70
1449	Chelone glabra	B	\N	\N	70L-40-70L
1450	Chenopodium (Bitium) virgatum	\N	1	\N	70L
1451	Chenopodium ambrosiodes	\N	1	\N	comment
1452	Chenopodium ambrosiodes	B	\N	\N	70L
1453	Chenopodium bonus	\N	\N	2	70L
1454	Chenopodium bonus	\N	1	\N	70L
1455	Chenopodium virgatum	\N	\N	2	70L
1456	Chenopodium vulvaria	\N	1	\N	70L
1457	Chenopodium vulvularia	\N	\N	2	DS 3 y = dead
1458	Chiastophyllum oppositifolia	B	\N	\N	70D GA-3
1459	Chiliotrichum amelloides	\N	\N	2	chaff
1460	Chilopsis linearis	B	\N	\N	70D
1461	Chimonanthus praecox	\N	\N	2	DS 3 y = dead
1462	Chimonanthus praecox	\N	1	\N	70D
1463	Chionanthus virginica	\N	1	\N	70-40-70
1464	Chionanthus virginica	B	\N	\N	WC 7 d, 40-70-40-70
1465	Chionochloa rubra	\N	\N	2	chaff
1466	Chionodoxa luciliae	B	\N	\N	WC 7 d, 70-40 5 m-70-40
1467	Chloranthus sp.	B	\N	\N	rotted
1468	Chlorogalum pomeridianum	B	\N	\N	40
1469	Chordospartium muritai	\N	1	\N	70
1470	Chrysanthemum cinerarifolium	\N	\N	2	55-80
1471	Chrysanthemum djilgense	B	\N	\N	D-70
1472	Chrysanthemum koreanum	B	\N	\N	D-70
1473	Chrysanthemum leucanthemum 	B	\N	\N	70
1474	Chrysanthemum pyrethroides	B	\N	\N	D-70
1475	Chrysopsis villosa	B	\N	\N	70
1476	Cicer arietinum	\N	1	\N	70 GA-3
1477	Cicerbita alpina	\N	1	\N	70L
1478	Cichorum intybus	B	\N	\N	70L
1479	Cimicifuga racemosa	B	\N	\N	70-40
1480	Circaea lutetiana	\N	1	\N	OT
1481	Circaea lutetiana	B	\N	\N	70L
1482	Cissus striata	\N	\N	2	70D-40-70D
1483	Cistus laurifolius	B	\N	\N	70
1484	Citrofortunella mitis	\N	\N	2	WC, 70L
1485	Citrullus vulgaris	\N	1	\N	70
1486	Citrullus vulgaris	\N	\N	2	70
1487	Citrullus vulgaris	B	\N	\N	70
1488	Citrus nobilis	B	\N	\N	70L
1489	Cladastris lutea	\N	\N	2	puncture, 70
1490	Cladastris lutea	\N	1	\N	comment
1491	Cladastris lutea	B	\N	\N	puncture, 70
1492	Cladothamnus pyroliflorus	\N	\N	2	70L
1493	Clarkia amoena	B	\N	\N	70
1494	Clarkia elegans	\N	\N	2	50-85
1495	Claytonia megarhiza	B	\N	\N	OT
1496	Claytonia virginica	B	\N	\N	70-40
1497	Cleistocactus aureispinus	\N	1c	\N	70 GA-3
1498	Cleistocactus baumannii	\N	1c	\N	no germ
1499	Cleistocactus smaragdiflorus	\N	1c	\N	70 GA-3
1500	Clematis addisonii	\N	1	\N	70 GA-3
1501	Clematis addisonii	B	\N	\N	70D GA-3
1502	Clematis albicoma v. coactilis	B	\N	\N	70
1503	Clematis alpina	B	\N	\N	70-40
1504	Clematis coactilis	\N	\N	2	70D-40-70D
1505	Clematis coactilis	\N	1	\N	70D
1506	Clematis columbiana	\N	1	\N	OT
1507	Clematis columbiana	B	\N	\N	70L
1508	Clematis connata	B	\N	\N	40-70
1509	Clematis crispa	B	\N	\N	40-70-40-70-40
1510	Clematis forsteri	B	\N	\N	70 GA-3 40
1511	Clematis grata	\N	1	\N	70L
1512	Clematis grata	B	\N	\N	70L
1513	Clematis hirsutissima	B	\N	\N	40-70
1514	Clematis integrifolia	B	\N	\N	70
1515	Clematis ladakhiana	B	\N	\N	70D
1516	Clematis lanuginosa	B	\N	\N	70-40-70-40-70
1517	Clematis maculata	B	\N	\N	70-40
1518	Clematis occidentalis	B	\N	\N	70-40
1519	Clematis orientalis	\N	1	\N	70L
1520	Clematis pitcheri	B	\N	\N	70-40
1521	Clematis recta	\N	1	\N	70D
1522	Clematis recta	B	\N	\N	70-40
1523	Clematis rehderiana	B	\N	\N	70-40
1524	Clematis sp.	B	\N	\N	70
1525	Clematis vernayi	B	\N	\N	70
1526	Clematis verticillata	B	\N	\N	70L
1527	Clematis viorna	B	\N	\N	70D
1528	Clematis virginiana	\N	1	\N	70L
1529	Clematis virginiana	B	\N	\N	70L
1530	Cleome hassleriana	\N	1	\N	70
1531	Cleome serrulata	B	\N	\N	70L
1532	Clethra alnifolia	B	\N	\N	40-70L
1533	Clethra fargesii	\N	1	\N	70L
1534	Clethra fargesii	B	\N	\N	40-70L
1535	Clianthus formosa	\N	1	\N	puncture, 70
1536	Clianthus formosus	\N	\N	2	puncture, 70D
1537	Clianthus puniceus 	\N	\N	2	puncture, 70D
1538	Clianthus puniceus alba	B	\N	\N	puncture, 70
1539	Clintonia andrewsiana	B	\N	\N	40-70
1540	Clintonia borealis	B	\N	\N	OT
1541	Clintonia umbellata	B	\N	\N	40-70-40-70
1542	Clitoria ternatea	\N	\N	2	puncture, 70D
1543	Clitoria ternatea	\N	1	\N	puncture, 70
1544	Clivia miniata	\N	\N	2	70D
1545	Cneorum tricoccon	\N	1	\N	70 GA-3
1546	Cnicus benedictus	\N	1	\N	D-70
1547	Cobaea scandens	\N	\N	2	70
1548	Cobaea scandens	\N	1	\N	70D
1549	Coccoloba uvifera	\N	\N	2	no germ
1550	Cocculus carolinus 	\N	1	\N	70D
1551	Cochlearia alpina	B	\N	\N	70
1552	Cochlearia officinalis	\N	\N	2	DS 2 y = dead
1553	Cochlearia officinalis	\N	1	\N	70L
1554	Codonopsis clematidea	B	\N	\N	70
1555	Codonopsis ovata	\N	\N	2	DS 3 y = dead
1556	Codonopsis ovata	B	\N	\N	70
1557	Codonopsis pilosula	\N	1	\N	D-70
1558	Codonopsis viridis	B	\N	\N	70
1559	Coffea arabica	\N	\N	2	no germ
1560	Colchicum autumnale	B	\N	\N	70-40
1561	Colchicum luteum	\N	1	\N	comment
1562	Colchicum luteum	B	\N	\N	70-40
1563	Coleocephalocereus goebelianus	\N	1c	\N	70 GA-3
1564	Coleus frederici	\N	\N	2	70L
1565	Coleus plumosa	\N	\N	2	70
1566	Collinsia bicolor	\N	\N	2	70D
1567	Collinsia bicolor	\N	1	\N	70
1568	Collinsonia canadensis	B	\N	\N	OT
1569	Collomia cavanillesii	\N	\N	2	40
1570	Collomia debilis	B	\N	\N	70 GA-3
1571	Collomia grandiflora	\N	1	\N	40
1572	Collomia grandiflora	B	\N	\N	40
1573	Collomia involucrata	\N	\N	2	no germ after DS 5 y
1574	Collomia sp.	B	\N	\N	70D GA-3
1575	Colutea arborescens	\N	\N	2	puncture, 70D
1576	Colutea arborescens	B	\N	\N	puncture, 70
1577	Colutea hyb. media	\N	\N	2	puncture, 70D
1578	Coluteocarpus vesicaria	\N	1	\N	70D
1579	Commelina dianthifolia	\N	\N	2	70D
1580	Commelina dianthifolia	B	\N	\N	70
1581	Conanthera bifolia	B	\N	\N	40
1582	Conimitella williamsii	\N	1	\N	70D
1583	Conospermum taxifolium	\N	\N	2	rotted
1584	Convallaria majalis	B	\N	\N	WC, D-70D
1585	Convolvus compactus	B	\N	\N	70
1586	Convolvus lineatus ssp. angustifolius	B	\N	\N	40-70
1587	Convolvus sp.	B	\N	\N	40
1588	Convolvus tricolor	\N	\N	2	70D
1589	Convolvus tricolor	\N	1	\N	70
1590	Copiapoa barquitensis	\N	1c	\N	70 GA-3
1591	Copiapoa bridgesii	\N	\N	2c	70 GA-3
1592	Copiapoa humilis	\N	1c	\N	no germ
1593	Copiapoa hypogaea	\N	1c	\N	no germ
1594	Copiapoa magnifica 	\N	1c	\N	70
1595	Copiapoa tenuissima	\N	1c	\N	no germ
1596	Coprosma acerosa	\N	\N	2	70D-40-70D
1597	Coprosma atropurpurea	\N	\N	2	70D-40-70D
1598	Coprosma petriel	\N	\N	2	70D-40-70D
1599	Coprosma rhamnoides	\N	\N	2	70D-40-70D
1600	Cordyline indivisa	\N	1	\N	empty
1601	Cordyline pumilio	\N	\N	2	70L
1602	Coreopsis lanceolata	B	\N	\N	D-70
1603	Coriandrum sativum	B	\N	\N	70
1604	Coriaria terminalis	B	\N	\N	70L
1605	Coriaria terminalis xanthocarpa	\N	1	\N	70L
1606	Cornus alternifolia	B	\N	\N	WC, OT
1607	Cornus amomum	\N	1	\N	OT
1608	Cornus amomum	B	\N	\N	WC, OT
1609	Cornus canadensis	\N	\N	2	70 GA-3
1610	Cornus canadensis	\N	1	\N	70 GA-3
1611	Cornus florida	\N	\N	2	70D-40-70D
1612	Cornus florida	B	\N	\N	WC, 40-70
1613	Cornus kousa	B	\N	\N	WC, 40
1614	Cornus mas	\N	\N	2	70 GA-3 - 40
1615	Cornus nuttallii	B	\N	\N	WC, OT
1616	Cornus racemosa	B	\N	\N	WC, OT
1617	Cornus siberica	B	\N	\N	WC, OT
1618	Cornus stolonifera	B	\N	\N	WC, 70-40-70
1619	Cornus suecica	B	\N	\N	WC, OT
1620	Corokia cotoneaster	\N	\N	2	no germ
1621	Coronilla varia	B	\N	\N	extract, 70
1622	Correa aquae-gelidae	\N	\N	2	rotted
1623	Correa cordifolia	\N	\N	2	no germ
1624	Corryocactus tarijensis	\N	1c	\N	no germ
1625	Corryocactus urmiriensis	\N	1c	\N	70 GA-3
1626	Cortusa matthioli	B	\N	\N	70
1627	Cortusa turkestanica	B	\N	\N	70
1628	Corydalis caseana ssp. brandegei	\N	1	\N	70 GA-3
1629	Corydalis cheilanthifolia	B	\N	\N	70-40
1630	Corydalis lutea	B	\N	\N	70-40
1631	Corydalis nobile	\N	1	\N	OT
1632	Corydalis nobile	B	\N	\N	OT
1633	Corydalis sempervirens	\N	\N	2	DS 6 m 70D
1634	Corylopsis pauciflora	B	\N	\N	DS 6 m, OT
1635	Corylopsis spicata	B	\N	\N	DS 6 m, extract, OT
1636	Corylus avellana	\N	\N	2	70D
1637	Corylus avellana	\N	1	\N	comment
1638	Corylus avellana	B	\N	\N	extract, 40-70
1639	Corylus cornuta	B	\N	\N	70-40-70
1640	Coryphantha echinoides	\N	1c	\N	70
1641	Coryphantha palmeri	\N	1c	\N	70
1642	Coryphantha vivipara	\N	1c	\N	70 GA-3
1643	Coryphantha vivipara	B	\N	\N	70
1644	Cosmos bipinnatus	\N	\N	2	70D
1645	Costus guanaiensis	\N	\N	2	70
1646	Costus guanaiensis	\N	1	\N	70L
1647	Cotinus coggyria	\N	1	\N	70D-40-70D
1648	Cotoneaster acutifolia	B	\N	\N	comment
1649	Cotoneaster apiculata	B	\N	\N	comment
1650	Cotoneaster dammeri	B	\N	\N	40-70-40-70
1651	Cotoneaster depressa	B	\N	\N	70-40-70
1652	Cotoneaster divaricata	\N	1	\N	40-70-40-70-40-70-40-70
1653	Cotoneaster divaricata	B	\N	\N	WC, 40-70-40-70-40-70
1654	Cotoneaster horizontalis	B	\N	\N	70-40-70
1655	Cotoneaster integerrimus	\N	\N	2	no germ
1656	Cotoneaster microphyllus	\N	\N	2	DS 3 y 40-70D
1657	Cotoneaster microphyllus v. cochleatus	\N	1	\N	70 GA-3
1658	Cotoneaster microphyllus v. cochleatus	B	\N	\N	70D GA-3
1659	Cotoneaster zagelii	\N	\N	2	no germ
1660	Cotyledon orbiculata	\N	1	\N	70
1661	Cowania mexicana	\N	1	\N	40
1662	Crambe cordifolia	\N	\N	2	40-70D
1663	Crambe cordifolia	\N	1	\N	70L
1664	Crambe maritima	\N	1	\N	70L
1665	Craspedia incana	B	\N	\N	70D
1666	Crataegus coccinea	B	\N	\N	40-70
1667	Crataegus cordata	B	\N	\N	40-70
1668	Crataegus crus-galli	B	\N	\N	70-40-70
1669	Crataegus flava	B	\N	\N	70-40-70
1670	Crataegus mollis	B	\N	\N	40-70
1671	Crataegus monogyna	\N	1	\N	WC 7 d, 70-40-70
1672	Crataegus monogyna	B	\N	\N	70-40-70
1673	Crataegus oxycantha	B	\N	\N	70-40-70
1674	Crataegus phaenopyrum	B	\N	\N	WC, 70-40-70
1675	Crataegus punctata	B	\N	\N	70-40-70
1676	Crataegus rotundifolia	B	\N	\N	70-40-70
1677	Cremanthodium arnicoides	B	\N	\N	70
1678	Cremanthodium ellisii	B	\N	\N	70L
1679	Crepis sibiricus	\N	1	\N	70D-40-70D
1680	Crinodendron hookerianum	\N	1	\N	dead
1681	Criscoma coma-aurea	\N	1	\N	chaff
1682	Crocosmia aurea	B	\N	\N	70L
1683	Crocosmia aurea 	\N	1	\N	70L
1684	Crocus speciosus	B	\N	\N	70-40
1685	Crocus tomasinianus	B	\N	\N	WC, 70-40-40
1686	Croton alabamensis	\N	\N	2	no germ
1687	Crowea angustifolia	B	\N	\N	comment
1688	Crowea angustifolia v. dentata	\N	1	\N	comment
1689	Cruckshanksia glacialis	B	\N	\N	70-40
1690	Cruckshanksia hymenodon	B	\N	\N	70 4 w, 40
1691	Cryptantha paradoxa	\N	1	\N	70D
1692	Cryptantha paradoxa 	\N	\N	2	70D
1693	Cryptantha thompsonii	B	\N	\N	70D
1694	Cryptotaenia japonica atropurpurea 	\N	\N	2	70D-40-70D-40-70D
1695	Cucumis melo	\N	\N	2	70
1696	Cucumis melo	\N	1	\N	70D
1697	Cucumis melo	B	\N	\N	70
1698	Cucurbita maxima	\N	\N	2	comment, 70
1699	Cucurbita maxima	\N	1	\N	70L
1700	Cucurbita maxima	B	\N	\N	70
1701	Cucurbita melo	\N	\N	2	70D
1702	Cucurbita mixta	\N	1	\N	70
1703	Cucurbita pepo	\N	\N	2	70
1704	Cucurbita pepo	\N	1	\N	70L
1705	Cucurbita pepo	B	\N	\N	70
1706	Cucurbita sativus	\N	1	\N	70L
1707	Cucurbita sativus	B	\N	\N	70
1708	Cumarinia odorata	\N	1c	\N	70 GA-3
1709	Cuminium cyminum	\N	1	\N	70
1710	Cunninghamia lanceolata	B	\N	\N	70D
1711	Cuphea ignea	\N	\N	2	55-85
1712	Cuphea llavea	\N	\N	2	40-70D-40-70D
1713	Cuphea petiolata	B	\N	\N	OT
1714	Cupressus lusitanica	\N	1	\N	40-70
1715	Cupressus macrocarpa	B	\N	\N	40-70
1716	Cuscuta sp.	\N	1	\N	70D
1717	Cyananthus lobatus	B	\N	\N	70
1718	Cyananthus sp.	B	\N	\N	70L
1719	Cyathodes empetrifolia	\N	\N	2	70-40-70-40-70-40-70-40
1720	Cyathodes empetrifolia	\N	1	\N	70-40-70-40-70-40-70-40-70
1721	Cyathodes robusta	\N	\N	2	no germ
1722	Cyclamen neapolitanum	B	\N	\N	70-40-70-40
1723	Cyclamen persicum	B	\N	\N	70
1724	Cymbalaria muralis	\N	\N	2	70L
1725	Cymbalaria muralis	\N	1	\N	70L
1726	Cymopteris aboriginism	\N	\N	2	70D-40
1727	Cymopteris aboriginism	\N	1	\N	40
1728	Cymopteris sp.	B	\N	\N	40
1729	Cymopteris terebinthinus	B	\N	\N	40-70-40-70
1730	Cynanchum acutum	\N	\N	2	70D
1731	Cynanchum acutum	\N	1	\N	70D
1732	Cynoglossum amabile	\N	\N	2	50-85
1733	Cynoglossum amabile	B	\N	\N	70L
1734	Cynoglossum grande	\N	1	\N	40
1735	Cypella amosa	\N	1	\N	70L
1736	Cypella coelestis	\N	1	\N	70D-40-70D
1737	Cyperus alternifolium	\N	\N	2	70L
1738	Cyperus papyrus	\N	\N	2	70L
1739	Cyperus papyrus	\N	1	\N	70L
1740	Cyphomandia betacea	\N	1	\N	WC, 70
1741	Cypripedium acaule	Bo	\N	\N	comment
1742	Cypripedium andrewsii	Bo	\N	\N	comment
1743	Cypripedium calceolus	Bo	\N	\N	comment
1744	Cypripedium candidum	Bo	\N	\N	comment
1745	Cypripedium reginae	Bo	\N	\N	comment
1746	Cyrtanthus parviflorus	\N	\N	2	no germ
1747	Cythomandra betacea	\N	\N	2	comment
1748	Cythomandra betacea 	\N	1	\N	WC, 70L
1749	Cytisus scoparius	B	\N	\N	puncture, 70
1750	Daboecia cantabrica	\N	1	\N	70L
1751	Dahlia (dwarf hybrids)	\N	\N	2	50-85
1752	Dalea sp.	B	\N	\N	70
1753	Daphne caucasicum	B	\N	\N	40-70-40-70
1754	Daphne cneorum	B	\N	\N	comment
1755	Daphne genkwa	B	\N	\N	40
1756	Daphne giraldi	B	\N	\N	40-70
1757	Daphne mezereum	\N	1	\N	40-70-40-70
1758	Daphne mezereum alba	\N	1	\N	40-70
1759	Daphne oleoides	B	\N	\N	no germ
1760	Darlingtonia californica	\N	\N	2	70D-40-70D
1761	Darwinia citriodora	\N	\N	2	rotted
1762	Datura innoxia	\N	1	\N	D-70
1763	Datura metaloides	\N	\N	2	70D
1764	Datura metaloides	\N	1	\N	70
1765	Datura sanguinea	\N	1	\N	70L
1766	Datura sp.	\N	1	\N	70L-40-70L
1767	Datura stramonium	B	\N	\N	D-70L
1768	Datura suaveolens	\N	1	\N	extract, 70L
1769	Datura tatula	\N	1	\N	D-70
1770	Daubenya aurea	\N	1	\N	70D-40
1771	Daucus carota	\N	\N	2	70D
1772	Daucus carota	B	\N	\N	D-70L
1773	Daucus carota v. sativus	B	\N	\N	70D
1774	Davidia involucrata	\N	\N	2	comment
1775	Davidia involucrata	\N	1	\N	WC 7 d, 40-70-40-70-40-70-40-70
1776	Decaisnea fargesii	\N	\N	2	no germ
1777	Decaisnea fargesii	B	\N	\N	70-40-70-OT
1778	Degenia velebitica	B	\N	\N	70
1779	Deinanthe bifida	B	\N	\N	70L
1780	Delonix regia	\N	\N	2	puncture, 70D
1781	Delonix regia	\N	1	\N	puncture, 70
1782	Delosperma cooperi	B	\N	\N	70
1783	Delphinium belladonna	B	\N	\N	70
1784	Delphinium bicolor	B	\N	\N	D-40, 40
1785	Delphinium cashmerianum	B	\N	\N	70
1786	Delphinium consolida	\N	1	\N	70D-40
1787	Delphinium elatum	B	\N	\N	70
1788	Delphinium exaltatum	B	\N	\N	OT
1789	Delphinium geraniifolium	B	\N	\N	70D
1790	Delphinium geyeri	B	\N	\N	OT
1791	Delphinium glaucum	B	\N	\N	70-40
1792	Delphinium grandiflorum	\N	\N	2	70D
1793	Delphinium grandiflorum	B	\N	\N	70
1794	Delphinium lipskyi	B	\N	\N	OT
1795	Delphinium oreophilum	B	\N	\N	70
1796	Delphinium oxysepalum	B	\N	\N	70-40-70-40
1797	Delphinium tatsiense	B	\N	\N	70
1798	Delphinium tennuisectum	B	\N	\N	70
1799	Delphinium tricorne	\N	1	\N	70-40-70-40-70-40-70-40-70-40
1800	Delphinium tricorne	B	\N	\N	70-40-70-40-70
1801	Delphinium virescens	B	\N	\N	OT
1802	Delphinium xantholeucum	B	\N	\N	40
1803	Dendranthema arctica	\N	\N	2	no germ
1804	Dendrocalamus asper	\N	\N	2	70L
1805	Dendrocalamus membranaceous	\N	\N	2	70L
1806	Dendrocalamus strictus	\N	\N	2	70L
1807	Dendromecon rigida	\N	1	\N	70 GA-3
1808	Denmoza rhodacantha	\N	1c	\N	70 GA-3
1809	Dentaria hexaphylla	B	\N	\N	rotted
1810	Dentaria lacinata	\N	1	\N	70 GA-3 40
1811	Dentaria laciniata	B	\N	\N	40 GA-3 70
1812	Dentaria pentaphylla	B	\N	\N	rotted
1813	Desfontainea spinosa	B	\N	\N	no germ
1814	Desmanthus illinoensis	\N	1	\N	70 GA-3
1815	Desmodium canadense	\N	\N	2	puncture, 70D
1816	Desmodium canadense	\N	1	\N	puncture, 70
1817	Deutzia staminea	\N	1	\N	comment
1818	Deutzia staminea	B	\N	\N	70
1819	Dianella intermedia	\N	\N	2	70L
1820	Dianella intermedia	\N	1	\N	70L-40-70L
1821	Dianthus alpinus	B	\N	\N	70
1822	Dianthus armeria	\N	1	\N	comment
1823	Dianthus armeria	B	\N	\N	70L
1824	Dianthus barbatus	\N	\N	2	70D
1825	Dianthus barbatus	\N	1	\N	70D
1826	Dianthus broteri	B	\N	\N	70
1827	Dianthus carthusianorum	\N	\N	2	70D
1828	Dianthus caryophyllus	\N	\N	2	55-70
1829	Dianthus chinensis	\N	\N	2	50-85
1830	Dianthus crinitus	B	\N	\N	70
1831	Dianthus darwasica	B	\N	\N	70
1832	Dianthus erinaceus	B	\N	\N	70
1833	Dianthus fragrans	B	\N	\N	70
1834	Dianthus frigidus	B	\N	\N	70
1835	Dianthus glacialis	B	\N	\N	70
1836	Dianthus gratianopolitanus	\N	\N	2	70D
1837	Dianthus haematocalyx	B	\N	\N	70
1838	Dianthus knappii	\N	\N	2	70
1839	Dianthus leptopetalus	B	\N	\N	70
1840	Dianthus myrtinervis	B	\N	\N	70
1841	Dianthus neglectus	B	\N	\N	70
1842	Dianthus pancici	B	\N	\N	70
1843	Dianthus repens	B	\N	\N	70
1844	Dianthus sequieri	B	\N	\N	70
1845	Dianthus spiculifolius	\N	\N	2	70D
1846	Dianthus superbus alba	\N	1	\N	70L
1847	Diascia barberae	\N	\N	2	70
1848	Diascia barberae	\N	1	\N	70
1849	Dicentra citrina	B	\N	\N	40-70
1850	Dicentra cucullaria	B	\N	\N	40-70-40-70
1851	Dicentra eximia	B	\N	\N	40-70-40-70
1852	Dicentra scandens	B	\N	\N	40-70
1853	Dicentra spectabilis	B	\N	\N	70-40-70
1854	Dicentra uniflora	\N	1	\N	70D
1855	Dichelostemma capitatum	\N	1	\N	40
1856	Dichelostemma ida-maia	\N	\N	2	40
1857	Dichelostemma ida-maia	\N	1	\N	40
1858	Dichelostemma multiflorum	\N	1	\N	40
1859	Dichelostemma multiflorum 	\N	\N	2	40
1860	Dicranostigma franchetianum	\N	1	\N	70D
1861	Dictamnus alba	B	\N	\N	40-70-40-70-40-70
1862	Dictyolimon macrorrhabdos	B	\N	\N	70L
1863	Dierama pulcherrima	B	\N	\N	70D
1864	Dietes grandiflora	\N	1	\N	70L
1865	Dietes grandiflora 	\N	\N	2	70L
1866	Dietes indioides 	\N	\N	2	70L
1867	Digitalis grandiflora	\N	\N	2	70D
1868	Digitalis lutea 	\N	\N	2	70D
1869	Digitalis purpurea	\N	\N	2	70
1870	Digitalis purpurea	B	\N	\N	70
1871	Digitalis viridiflora 	\N	\N	2	70D
1872	Dimorphotheca aurantiaca	B	\N	\N	70
1873	Dimorphotheca aurantiaca 	\N	\N	2	70
1874	Dionea muscipula	B	\N	\N	70L
1875	Dionysia involucrata	B	\N	\N	40
1876	Dioscorea battatus	\N	\N	2	70D
1877	Dioscorea quaternata	B	\N	\N	70-40-70
1878	Dioscorea villosa	B	\N	\N	40-70
1879	Diospyros rhomboidalis	\N	\N	2	70
1880	Diospyros texana	\N	\N	2	70D
1881	Diospyros texana	\N	1	\N	70
1882	Diospyros virginiana	\N	1	\N	70 GA-3
1883	Diospyros virginiana	\N	\N	2	40-70D
1884	Diospyros virginiana	B	\N	\N	WC 7 d, 40-70
1885	Dipcadi fulvum	\N	\N	2	70D
1886	Dipcadi fulvum	\N	1	\N	70
1887	Dipcadi serotinum	\N	1	\N	70
1888	Dipcadi serotinum 	\N	\N	2	70D
1889	Dipcadi viride	\N	\N	2	70D
1890	Diphylleia cymosa	\N	1	\N	dead
1891	Diplacus bifidus	B	\N	\N	70L
1892	Diplarrhena latifolia 	\N	\N	2	70L
1893	Diplarrhena moraea	\N	\N	2	70L
1894	Dipsacus fullonum	\N	\N	2	70L
1895	Dipsacus fullonum	\N	1	\N	70 GA-3
1896	Dipsacus pilosus	\N	\N	2	DS 5 y = dead
1897	Dipsacus strigosus	\N	\N	2	70D-40-70D-40
1898	Dipsacus strigosus	\N	1	\N	40-70-40-70-40-70
1899	Dipsacus sylvestris	B	\N	\N	70L
1900	Dirca palustris	\N	\N	2	WC, 32
1901	Dirca palustris	\N	1	\N	WC, extract, 70L
1902	Discaria toumatou	\N	\N	2	40-70D
1903	Disocactus alteolens	\N	1c	\N	70 GA-3
1904	Disocactus boomianus	\N	1c	\N	70 GA-3
1905	Disocactus crystallophilus	\N	1c	\N	70 GA-3
1906	Disocactus pugionacanthus	\N	1c	\N	70 GA-3
1907	Disporum hookerianum v. trachyandrum	B	\N	\N	WC, 40
1908	Disporum lanuginosum	B	\N	\N	WC, 40
1909	Dodecatheon alpinum	B	\N	\N	70L
1910	Dodecatheon amethystinum	B	\N	\N	70D GA-3 40-70
1911	Dodecatheon jeffreyi	B	\N	\N	40-70
1912	Dodecatheon media	B	\N	\N	40
1913	Dodecatheon pulchellum	B	\N	\N	70
1914	Dodecatheon pulchellum 	\N	\N	2	70D
1915	Dodonea viscosa 	\N	\N	2	70D
1916	Doligloglottis schorzeneroides	\N	\N	2	chaff
1917	Doronicum caucasicum	B	\N	\N	70
1918	Doronicum columnae	B	\N	\N	70
1919	Doronicum orientale	B	\N	\N	70
1920	Dorotheanthus bellidiformis	\N	1	\N	70
1921	Dorotheanthus bellidiformis	\N	\N	2	70D GA-3
1922	Dorotheanthus rourkei	\N	\N	2	70D GA-3
1923	Dorycnium rectum	B	\N	\N	70
1924	Douglasia laeviagata	B	\N	\N	OT
1925	Douglasia nivalis	B	\N	\N	OT
1926	Draba acaulis	B	\N	\N	40-70
1927	Draba aizoon	B	\N	\N	DS 12 m, 70
1928	Draba argyrea	B	\N	\N	OT 2 m, 70
1929	Draba brunifolia	B	\N	\N	70
1930	Draba compacta	B	\N	\N	D-70
1931	Draba cretica	B	\N	\N	70D
1932	Draba dedeana	B	\N	\N	40
1933	Draba densifolia	B	\N	\N	D-70
1934	Draba hoppeana	B	\N	\N	70
1935	Draba incerta	B	\N	\N	40
1936	Draba lasiocarpa	B	\N	\N	D-70
1937	Draba lemmonii	B	\N	\N	OT 2 m, 70
1938	Draba parnassica	B	\N	\N	D-70
1939	Draba polytricha	B	\N	\N	OT
1940	Draba sartori	B	\N	\N	D-70
1941	Draba ventosa	\N	\N	2	70L
1942	Dracocephalum renati	B	\N	\N	70L
1943	Dracocephalum tanguticum	\N	1	\N	70 GA-3 40-70-40-70
1944	Dracophyllum uniflorum	\N	\N	2	no germ
1945	Dracunculus canariensis	\N	\N	2	70
1946	Dracunculus canariensis	\N	1	\N	70D
1947	Dracunculus vulgaris	\N	\N	2	70D-40
1948	Draperia systyla	\N	1	\N	70 GA-3 40
1949	Drosera aliciae	\N	1	\N	70
1950	Drosera angelica	\N	1	\N	40-70L
1951	Drosera binata	\N	1	\N	70L
1952	Drosera binata v. multifida	\N	1	\N	70L
1953	Drosera burkeana	\N	1	\N	70L
1954	Drosera capensis	\N	\N	2	70L
1955	Drosera capensis	\N	1	\N	70L
1956	Drosera spathulata	\N	1	\N	70L
1957	Dryandra formosa	B	\N	\N	40
1958	Dryandra serra	\N	1	\N	40-70
1959	Dryandra serra	B	\N	\N	40-70D
1960	Dryas octapetala	\N	1	\N	70
1961	Dryas octapetala	B	\N	\N	70
1962	Dryas sundermannii	B	\N	\N	70
1963	Drymophila cyanocarpa	\N	\N	2	70D-40
1964	Duchesnea indica	\N	1	\N	70L
1965	Dudleya brittonii	\N	1	\N	70
1966	Dudleya cymosa	B	\N	\N	70
1967	Dudleya pachyphytum	\N	1	\N	70
1968	Dyosma versipelle	\N	\N	2	70 GA-3
1969	Eccremocarpus scaber	\N	1	\N	70L
1970	Echinacea angustifolia	\N	1	\N	D-70
1971	Echinacea purpurea	\N	1	\N	D-70
1972	Echinocactus horizonthalonius	\N	1c	\N	70 GA-3
1973	Echinocactus ingens	\N	1c	\N	70 GA-3
1974	Echinocactus platyacanthus	\N	1c	\N	70 GA-3
1975	Echinocactus texensis	\N	1c	\N	70 GA-3
1976	Echinocereus baileyi	B	\N	\N	70 GA-3
1977	Echinocereus engelmanni	\N	1c	\N	70 GA-3
1978	Echinocereus engelmanni v. chrysocentrus	\N	1c	\N	70 GA-3
1979	Echinocereus fendleri	\N	1c	\N	70 GA-3
1980	Echinocereus ferreiranus	\N	1c	\N	70
1981	Echinocereus pectinatus	\N	\N	2c	OS 50-70 GA-3
1982	Echinocereus pectinatus	\N	1c	\N	70 GA-3
1983	Echinocereus pectinatus 	B	\N	\N	70 GA-3
1984	Echinocereus pectinatus (hybrids)	\N	1c	\N	70 GA-3
1985	Echinocereus pectinatus v. wenigeri	\N	\N	2c	OS 50-70 GA-3
1986	Echinocereus pectinatus v. wenigeri	\N	1c	\N	70 GA-3
1987	Echinocereus reichenbachii	\N	\N	2c	OS 32-75 GA-3
1988	Echinocereus reichenbachii	\N	1c	\N	70 GA-3
1989	Echinocereus reichenbachii	B	\N	\N	70 GA-3
1990	Echinocereus reichenbachii v. albispinus	\N	1c	\N	70 GA-3
1991	Echinocereus reichenbachii v. baileyi	\N	1c	\N	70 GA-3
1992	Echinocereus reichenbachii v. caespitosus	\N	1c	\N	70 GA-3
1993	Echinocereus reichenbachii v. perbellus	\N	1c	\N	70 GA-3
1994	Echinocereus reichenbachii v. perbellus 	\N	\N	2c	OS 32-75 GA-3
1995	Echinocereus spinigemmatus	\N	1c	\N	no germ
1996	Echinocereus triglochidiatus	\N	1c	\N	70 GA-3
1997	Echinocereus triglochidiatus	B	\N	\N	70
1998	Echinocereus triglochidiatus v. mojavensis	\N	1c	\N	70 GA-3
1999	Echinocereus viridiflorus	\N	1c	\N	70 GA-3
2000	Echinocereus viridiflorus	B	\N	\N	comment
2001	Echinocereus x roetteri	\N	\N	2c	OS 32-75 GA-4
2002	Echinocereus x roetteri	\N	1c	\N	no germ
2003	Echinocystis lobata	B	\N	\N	OT
2004	Echinofossulocactus dichroacanthus	\N	1c	\N	70 GA-3
2005	Echinofossulocactus erectocentrus	\N	1c	\N	70 GA-3
2006	Echinofossulocactus heteracanthus	\N	1c	\N	70 GA-3
2007	Echinofossulocactus zacatecasensis	\N	1c	\N	70 GA-3
2008	Echinomastus dasyacanthus	\N	1c	\N	70 GA-3
2009	Echinomastus laui	\N	1c	\N	70 GA-3
2010	Echinops sphaerocephalum	\N	1	\N	70D
2011	Echinopsis ancistrophora hamatacantha	\N	1c	\N	70 GA-3
2012	Echinopsis mirabilis	\N	1c	\N	70 GA-3
2013	Echinopsis rhodotricha	\N	1c	\N	70 GA-3
2014	Echinopsis tapecuna tropica	\N	1c	\N	70 GA-3
2015	Echioides longiflorum	B	\N	\N	70
2016	Edraianthus dalmaticus	B	\N	\N	70D GA-3
2017	Edraianthus graminifolius	B	\N	\N	70
2018	Edraianthus pumilio	\N	\N	2	70L
2019	Edraianthus pumilio	B	\N	\N	70L
2020	Edraianthus tennuifolius	B	\N	\N	70
2021	Ehretia anacua	\N	1	\N	70D
2022	Elaeagnus angustifolia	\N	1	\N	WC 7 d, 70D
2023	Eleaganus angustifolia	B	\N	\N	40-70
2024	Eleaganus umbellata	B	\N	\N	WC 14 d, 70-40-70-40-70
2025	Eleagnus angustifolia	\N	\N	2	70D
2026	Eleocharas sphacelata	\N	\N	2	70L
2027	Eleusine coracana	Bg	\N	\N	D-70
2028	Elmera racemosa	B	\N	\N	70L
2029	Elmera racemosa 	\N	1	\N	70L
2030	Embothrium coccineum	\N	\N	2	70L
2031	Embothrium coccineum	\N	1	\N	empty
2032	Eminium regelii	B	\N	\N	70-40-70-40
2033	Empetrum nigrum	\N	1	\N	70 GA-3
2034	Enceliopsis nudicaule	B	\N	\N	40
2035	Engelmannia pinnatifida	\N	1	\N	70
2036	Enkianthus campanulatus	B	\N	\N	OT
2037	Ennealophus euryandus	\N	\N	2	no germ
2038	Ephedra fedtschenkoi	B	\N	\N	70
2039	Ephedra intermedia	B	\N	\N	70
2040	Ephedra minima	\N	\N	2	70D
2041	Ephedra minuta	B	\N	\N	70
2042	Epigea repens	B	\N	\N	70L
2043	Epilobium anagallidifolium	\N	1	\N	70D
2044	Epilobium angustifolium	\N	\N	2	50-70 OS
2045	Epilobium angustifolium	\N	1	\N	70L
2046	Epilobium latifolium	\N	1	\N	70D
2047	Epilobium palustris	\N	1	\N	70D
2048	Epilobium rigidum	\N	\N	2	rotted
2049	Epilobium tasmanicum	B	\N	\N	70
2050	Epimedum colchicum	B	\N	\N	40
2051	Epimedum pinnatum	B	\N	\N	40-70
2052	Epithelantha micromeris	\N	1c	\N	70 GA-3
2053	Epostoa mirabilis	\N	1c	\N	70 GA-3
2054	Epostoa nana	\N	1c	\N	70 GA-3
2055	Eranthis hyemalis	\N	1	\N	comment
2056	Eranthis hyemalis	B	\N	\N	70-40
2057	Erdisia quadrangularis	\N	1c	\N	70 GA-3
2058	Eremophila	\N	1	\N	comment
2059	Eremophila aricantha	\N	\N	2	extract, 70D
2060	Eremophila cuneifolia	\N	\N	2	extract, 70D
2061	Eremophila eriocalyx	\N	\N	2	extract, 70D
2062	Eremophila laanii	\N	\N	2	extract, 70D
2063	Eremophila longifolia	\N	\N	2	extract, 70D
2064	Eremophila macdonaldii	\N	\N	2	extract, 70D
2065	Eremophila maculata	\N	\N	2	extract, 70D
2066	Eremostachys speciosa 	B	\N	\N	70-40-70
2067	Eremurus altaica	B	\N	\N	70-40
2068	Eremurus robustus	\N	\N	2	comment
2069	Eremurus robustus	\N	1	\N	40-70-40-70-40
2070	Eremurus robustus	B	\N	\N	70-40-70-40
2071	Eremurus stenocalyx	B	\N	\N	40-70-40
2072	Eriastrum densifolium v. austromontanum	\N	1	\N	70 GA-3
2073	Erigenia bulbosa	B	\N	\N	70-40-70
2074	Erigeron alpinus	B	\N	\N	D-70
2075	Erigeron aurantiacus	B	\N	\N	D-70
2076	Erigeron compositus	B	\N	\N	70
2077	Erigeron eatoni	B	\N	\N	D-70
2078	Erigeron elegantulus	B	\N	\N	70
2079	Erigeron flabellifolius 	\N	\N	2	70D
2080	Erigeron flagellaris	B	\N	\N	D-70
2081	Erigeron flettii	\N	\N	2	70D
2082	Erigeron flettii	\N	1	\N	70D
2083	Erigeron flettii	B	\N	\N	70D
2084	Erigeron fremonti	B	\N	\N	D-70
2085	Erigeron glabellus	B	\N	\N	D-70
2086	Erigeron leimoerus	B	\N	\N	70-40-70
2087	Erigeron nanus	B	\N	\N	D-70
2088	Erigeron pinnatisectus	B	\N	\N	D-70
2089	Erigeron sp.	B	\N	\N	70
2090	Erigeron speciosus	B	\N	\N	D-70
2091	Erigeron subtrinervis	B	\N	\N	D-70
2092	Erigeron trifidus	B	\N	\N	D-70
2093	Erigeron uniflorus	B	\N	\N	D-70
2094	Erigeron villarsii	B	\N	\N	D-70
2095	Erinus alpinus	\N	\N	2	70D
2096	Erinus alpinus	\N	1	\N	70D
2097	Erinus alpinus alba	\N	\N	2	70D
2098	Eriocereus jusbertii	\N	1c	\N	70 GA-3
2099	Eriogonum allenii	\N	1	\N	40-70D
2100	Eriogonum allenii	B	\N	\N	OT
2101	Eriogonum bicolor	\N	\N	2	40
2102	Eriogonum bicolor	\N	1	\N	40-70D
2103	Eriogonum brevicaule ssp. oredense	B	\N	\N	40-70
2104	Eriogonum caespitosum	B	\N	\N	40
2105	Eriogonum compositum	B	\N	\N	70
2106	Eriogonum douglasii	B	\N	\N	70
2107	Eriogonum ericifolium v. pulchrum	B	\N	\N	40
2108	Eriogonum flavum	B	\N	\N	70
2109	Eriogonum flavum v. xanthum	B	\N	\N	40
2110	Eriogonum morifolium	B	\N	\N	40-70
2111	Eriogonum niveum	B	\N	\N	40-70
2112	Eriogonum ovalifolium v. depressum	B	\N	\N	40-70
2113	Eriogonum shockleyi	B	\N	\N	70
2114	Eriogonum sphaerocephalum	B	\N	\N	40-70
2115	Eriogonum strictum ssp. proliferum	B	\N	\N	40-70
2116	Eriogonum thymoides	B	\N	\N	OT
2117	Eriogonum tumulosum	B	\N	\N	70
2118	Eriogonum umbellatum	B	\N	\N	70-40
2119	Eriophorum angustifolium	\N	1	\N	70L
2120	Eriophorum scheuzeri	\N	1	\N	70L
2121	Eriophyllum lanatum	B	\N	\N	40
2122	Eriostemon myoporoides	\N	\N	2	rotted
2123	Eriosyce ceratistes	\N	\N	2c	OS 32-80
2124	Eriosyce ihotzkyana	\N	1c	\N	70 GA-3
2125	Eriosyce ihotzkyana 	\N	\N	2c	comment
2126	Eriosyce sandillon	\N	\N	2c	OS 32-80
2127	Eritrichum howardi	B	\N	\N	70
2128	Eritrichum rupestre v. pectinatum	\N	1	\N	70D
2129	Ermannia papyroides	\N	\N	2	70D
2130	Eryngium agavifolium	\N	\N	2	DS 3 y = dead
2131	Eryngium alpinum	B	\N	\N	70
2132	Eryngium planum	\N	\N	2	DS 6 y = dead
2133	Eryngium yuccifolium	B	\N	\N	40
2134	Erysimum kotschyanum	B	\N	\N	70
2135	Erysimum nivale	B	\N	\N	70
2136	Erysimum perofskianum	B	\N	\N	70
2137	Erythrina crista-galli	\N	1	\N	sterile puncture, 70
2138	Erythronium americanum	B	\N	\N	40-70-40-70
2139	Erythronium citrinum	B	\N	\N	70-40-70
2140	Erythronium grandiflorum	\N	1	\N	70D-40-70D-40
2141	Erythronium grandiflorum	B	\N	\N	70L-40-70L
2142	Erythronium hendersoni	B	\N	\N	70-40-70
2143	Erythronium hendersonii x citrinum	\N	1	\N	40
2144	Erythronium mesochorum	B	\N	\N	40-70-40
2145	Erythronium revolutum	B	\N	\N	70-40+-70
2146	Erythronium sibiricum	B	\N	\N	70-40
2147	Eschscholzia californica	\N	\N	2	70D
2148	Eschscholzia californica	\N	1	\N	D-70
2149	Escobaria minima	\N	1c	\N	70 GA-3
2150	Escobaria vivipara	\N	1c	\N	70 GA-3
2151	Escontria chiotilla	\N	1c	\N	70 GA-3
2152	Eucalyptus doratoxlyn	B	\N	\N	70
2153	Eucalyptus leucoxlyn	\N	1	\N	70D
2154	Eucalyptus leucoxlyn	B	\N	\N	70
2155	Euceliopsis covellei	\N	\N	2	70D
2156	Euceliopsis covellei	\N	1	\N	70D
2157	Eucomis bicolor	\N	\N	2	70D
2158	Eucomis bicolor	\N	1	\N	70D
2159	Eucomis pole-evansii	\N	\N	2	70D
2160	Eucomis zambesiaca	\N	\N	2	70D
2161	Eucryphia glutinosa	\N	\N	2	DS 3 y = dead
2162	Eulychnia acida	\N	1c	\N	70 GA-3
2163	Eulychnia castanea	\N	1c	\N	70 GA-3
2164	Eunomia oppositifolia	B	\N	\N	70
2165	Euonymus alatus	\N	1	\N	WC 7 d, OT
2166	Euonymus alatus	B	\N	\N	WC 4 w, OT
2167	Euonymus atropurpurea	B	\N	\N	WC 7 d, 70-40-70-40-70-40-70
2168	Euonymus bungeana	B	\N	\N	WC 7 d, 40
2169	Euonymus europaeus	\N	1	\N	WC 7 d, OT
2170	Euonymus europaeus	B	\N	\N	WC 4 w, OT
2171	Euonymus phellomanus	\N	\N	2	70D-40-70D
2172	Euonymus radicans	B	\N	\N	WC 7 d, DS 6 m, 70
2173	Eupatorium coelestinum	B	\N	\N	70
2174	Eupatorium perfoliatum	\N	1	\N	70L
2175	Eupatorium purpureum	B	\N	\N	40-70
2176	Eupatorium urticaefolium	B	\N	\N	70
2177	Euphorbia aristata	B	\N	\N	OT
2178	Euphorbia francheti	B	\N	\N	40-70
2179	Euphorbia myrsinites	\N	\N	2	DS 1 y 70D
2180	Euphorbia myrsinites 	\N	1	\N	70 GA-3
2181	Euphorbia polychroma	B	\N	\N	soak, extract, 70
2182	Euphorbia pulcherrima	\N	\N	2	50-85
2183	Euphorbia wulfenii	\N	\N	2	70D-40-70D
2184	Euphorbia wulfenii	\N	1	\N	70-40-70
2185	Eustoma	B	\N	\N	see Lisianthus
2186	Evodia daniellii	B	\N	\N	40-70 GA-3
2187	Exacum affine	\N	\N	2	60L-80L
2188	Exocarpos sparteus	\N	\N	2	70 GA-3 - 40
2189	Exochorda grandiflora	B	\N	\N	40
2190	Fallugia paradoxa	\N	1	\N	70
2191	Fatsia sp.	\N	1	\N	dead
2192	Fedia cornucopiae	\N	\N	2	70D
2193	Fedia cornucopiae	\N	1	\N	empty
2194	Feijoa sellowiana	\N	1	\N	WC 7 d, 70L
2195	Ferocactus acanthoides	\N	\N	2c	70 GA-3
2196	Ferocactus acanthoides	\N	1c	\N	70 GA-3
2197	Ferocactus acanthoides	B	\N	\N	70 GA-3
2198	Ferocactus gracilis	\N	1c	\N	70
2199	Ferocactus wislizenii	\N	1c	\N	70 GA-3
2200	Ferocactus wislizenii	B	\N	\N	70 GA-3
2201	Ferraria crispa	\N	\N	2	70D
2202	Ferula sp.	B	\N	\N	40-70
2203	Festuca glauca	Bg	\N	\N	D-70
2204	Festuca mairei	Bg	\N	\N	D-70
2205	Festuca novae-zealandiae	Bg	\N	\N	D-70
2206	Festuca ovina	Bg	\N	\N	D-70
2207	Fibigia clypeata	B	\N	\N	70
2208	Ficus carica	\N	1	\N	70L
2209	Ficus carica 	\N	\N	2	WC, 70L
2210	Filipendula ulmaria	B	\N	\N	70L
2211	Foeniculum vulgare	\N	\N	2	70L
2212	Foeniculum vulgare	\N	1	\N	70L
2213	Forskohlea angustifolia	\N	\N	2	comment
2214	Forskohlea angustifolia	\N	1	\N	70L
2215	Forstera bidwillii	\N	\N	2	empty
2216	Forsythia suspensa	B	\N	\N	70-40-70
2217	Fortunella crassifolia	\N	1	\N	WC, 70D
2218	Fortunella sp.	\N	\N	2	70D
2219	Fouquieria spendens	\N	1	\N	70D
2220	Fragraria chiloensis	\N	1	\N	WC 7 d, 70L
2221	Frailea alacriportana fulvispina	\N	1c	\N	70 GA-3
2222	Frailea aureinitens	\N	1c	\N	70 GA-3
2223	Frailea gracillima	\N	1c	\N	70 GA-3
2224	Frailea grahliama	\N	1c	\N	70
2225	Frailea lepida 	\N	\N	2c	70 GA-3
2226	Francoa appendiculata	\N	\N	2	70D
2227	Francoa ramosa	\N	\N	2	DS 1 y = dead
2228	Francoa sonchifolia 	\N	\N	2	70D
2229	Francoa sp.	\N	1	\N	70
2230	Frankenia thymifolia	\N	1	\N	70D
2231	Franklinia alatahama	\N	1	\N	70L
2232	Franklinia alatahama	\N	\N	2	70L
2233	Franklinia alatahama	B	\N	\N	70
2234	Frasera albicaulis	B	\N	\N	70-40-70-40
2235	Frasera fastigiata	\N	1	\N	70-40-70-40-70-40-70-40-70
2236	Frasera fastigiata	B	\N	\N	70-40-70-40-70
2237	Frasera speciosa	B	\N	\N	OT
2238	Fraxinus americana	\N	\N	2	70
2239	Fraxinus americana	\N	1	\N	strip, 70L
2240	Fraxinus americana	B	\N	\N	comment
2241	Fraxinus anomala	\N	\N	2	70D-40
2242	Fraxinus anomala	\N	1	\N	40-70D
2243	Fraxinus cuspidata	\N	\N	2	GA-3 50 to 70 OS
2244	Fraxinus excelsior	B	\N	\N	comment
2245	Fraxinus lanceolata	B	\N	\N	comment
2246	Fraxinus mandschurica	B	\N	\N	comment
2247	Fraxinus nigra	B	\N	\N	comment
2248	Fraxinus oxycarpa	B	\N	\N	comment
2249	Fraxinus pennsylvanica	B	\N	\N	comment
2250	Fraxinus pennsylvanica	B	\N	\N	comment
2251	Fraxinus quadrangulata  	\N	\N	2	70D-40-70D-40-70D-40
2252	Fraxinus quandrangulata	\N	1	\N	70-40-70-40-70-40-70
2253	Fraxinus syriaca	B	\N	\N	comment
2254	Freesia (hybrids)	\N	\N	2	55-65
2255	Freesia (hybrids)	B	\N	\N	70
2256	Fremontodendron californicum	\N	1	\N	puncture
2257	Fritillaria acmopetala	B	\N	\N	40-70
2258	Fritillaria armena	B	\N	\N	OT
2259	Fritillaria aurea	B	\N	\N	OT
2260	Fritillaria carica	B	\N	\N	40
2261	Fritillaria forbsii	B	\N	\N	OT
2262	Fritillaria gantneri	B	\N	\N	40
2263	Fritillaria glauca	B	\N	\N	40
2264	Fritillaria graeca	B	\N	\N	OT
2265	Fritillaria graeca v. thessalica	\N	1	\N	70-40-70-40
2266	Fritillaria graeca v. thessalica	B	\N	\N	40-70D
2267	Fritillaria imperialis	\N	1	\N	40
2268	Fritillaria imperialis	B	\N	\N	40-70-40-70
2269	Fritillaria imperialis 	\N	\N	2	comment
2270	Fritillaria kurdica	B	\N	\N	OT
2271	Fritillaria lanceolata	B	\N	\N	40
2272	Fritillaria meleagris	B	\N	\N	70-40-70
2273	Fritillaria michaelowskii	B	\N	\N	OT
2274	Fritillaria pallida	\N	1	\N	70 (6 m) 40-70
2275	Fritillaria pallida	B	\N	\N	40-70-40-70-40
2276	Fritillaria pallidiflora	B	\N	\N	OT
2277	Fritillaria persica	B	\N	\N	40
2278	Fritillaria pluriflora	B	\N	\N	OT
2279	Fritillaria pontica	B	\N	\N	40-70
2280	Fritillaria pudica	B	\N	\N	OT
2281	Fritillaria pyrenaica	B	\N	\N	OT
2282	Fritillaria raddeana	B	\N	\N	OT
2283	Fritillaria recurva	B	\N	\N	70-40
2284	Fritillaria sp.	B	\N	\N	40-70
2285	Fritillaria thunbergii	B	\N	\N	40-70-40
2286	Fritillaria tubiformis	B	\N	\N	40-70
2287	Fritillaria ussuriensis	B	\N	\N	40-70-40
2288	Fumana viridis	B	\N	\N	70-40-70
2289	Fumaria officinalis	\N	1	\N	OT
2290	Fuschia (hybrids)	B	\N	\N	70 GA-3
2291	Gagea sp.	B	\N	\N	OT
2292	Gahnia clarkei	\N	\N	2	70L
2293	Gahnia sieberiana	\N	\N	2	70L
2294	Gaillardia aristata	\N	\N	2	70D
2295	Gaillardia aristata	B	\N	\N	70
2296	Galanthus elwesii	B	\N	\N	70-40-70-40-70-40
2297	Galanthus nivalis	B	\N	\N	WC 7 d, 40-70-40
2298	Galax urceolata	\N	\N	2	empty
2299	Galega officinalis	\N	1	\N	D-70
2300	Galeopsis speciosa	\N	\N	2	70D-40-70D
2301	Galtonia candicans	\N	\N	2	70D
2302	Galtonia candicans	B	\N	\N	70
2303	Gamocheta nivalis	\N	1	\N	70D
2304	Gardenia jasminoides 	\N	1	\N	70D
2305	Gaultheria depressa	B	\N	\N	WC, 70L
2306	Gaultheria hispida	\N	\N	2	70D
2307	Gaultheria procumbens	B	\N	\N	WC, 70
2308	Gaultheria shallon	\N	1	\N	70L
2309	Gaultheria trichophylla	B	\N	\N	WC, 70L
2310	Gaura biennis	B	\N	\N	70D GA-3
2311	Gaura coccinea	B	\N	\N	40-70
2312	Gaura lindheimeri	B	\N	\N	70D
2313	Gazania (hybrids)	\N	\N	2	55-75
2314	Geissorhiza aspera	\N	\N	2	70D-40
2315	Geissorhiza fulva	\N	\N	2	70D-40
2316	Geissorhiza inequalis	\N	\N	2	70D-40
2317	Geissorhiza juncea	\N	\N	2	70D
2318	Geissorhiza monantha	\N	\N	2	70D-40
2319	Geissorhiza rochensis	\N	\N	2	70D-40
2320	Geissorhiza rochensis spithamaea	\N	\N	2	70D-40
2321	Geissorhiza secunda	\N	\N	2	70L-40
2322	Geissorhiza splendissima	\N	\N	2	70L-40
2323	Gelasine azurea	\N	\N	2	70L
2324	Genista subcapitata	B	\N	\N	OT
2325	Gentiana acaulis	B	\N	\N	70-40-70-40-70
2326	Gentiana affinis	\N	1	\N	70 GA-3
2327	Gentiana affinis	B	\N	\N	OT
2328	Gentiana asclepiadea	\N	\N	2	DS 3 y = dead
2329	Gentiana asclepiadea	B	\N	\N	70
2330	Gentiana asclepiadea	\N	1	\N	70L
2331	Gentiana asclepiadea rosea	\N	\N	2	70L
2332	Gentiana aspera	B	\N	\N	OT
2333	Gentiana austriaca	B	\N	\N	OT
2334	Gentiana autumnalis	B	\N	\N	DS 6 m 70, 40-70
2335	Gentiana barbata	B	\N	\N	OT
2336	Gentiana bellidifolia	B	\N	\N	70 GA-3
2337	Gentiana boisseri	B	\N	\N	40-70
2338	Gentiana cachmerica	B	\N	\N	70
2339	Gentiana calycosa	\N	1	\N	DS 1 y = dead
2340	Gentiana calycosa	B	\N	\N	70D GA-3
2341	Gentiana ciliata	\N	\N	2	no germ
2342	Gentiana clusii	B	\N	\N	70-40-70
2343	Gentiana corymbifera	B	\N	\N	70 GA-3
2344	Gentiana crinita	B	\N	\N	70D GA-3
2345	Gentiana cruciata	\N	1	\N	70 GA-3
2346	Gentiana dahurica	B	\N	\N	OT
2347	Gentiana decumbens	B	\N	\N	70
2348	Gentiana depressa	B	\N	\N	OT
2349	Gentiana dinarica	B	\N	\N	70D GA-3
2350	Gentiana farreri	B	\N	\N	70-40-70
2351	Gentiana fischeri	B	\N	\N	70
2352	Gentiana flavida	B	\N	\N	70
2353	Gentiana gelida	B	\N	\N	70-40-70-40
2354	Gentiana gracilipes	B	\N	\N	OT
2355	Gentiana grombezewskii	\N	\N	2	70L
2356	Gentiana lagodechiana	B	\N	\N	70
2357	Gentiana linearis	B	\N	\N	OT
2358	Gentiana loderi	B	\N	\N	70
2359	Gentiana lutea	B	\N	\N	OT
2360	Gentiana macrophylla	B	\N	\N	70
2361	Gentiana nesophila	B	\N	\N	OT
2362	Gentiana nivalis	\N	1	\N	70 GA-3
2363	Gentiana occidentalis	B	\N	\N	70D GA-3
2364	Gentiana olivieri	B	\N	\N	OT
2365	Gentiana paradoxa	\N	1	\N	70D
2366	Gentiana paradoxa	B	\N	\N	70D GA-3
2367	Gentiana parryi	B	\N	\N	70
2368	Gentiana platypetala	B	\N	\N	OT
2369	Gentiana procera	B	\N	\N	OT
2370	Gentiana pseudoaquatica	B	\N	\N	40-70
2371	Gentiana pterocalyx	B	\N	\N	70
2372	Gentiana puberulenta	B	\N	\N	40-70
2373	Gentiana quinquifolia	B	\N	\N	OT
2374	Gentiana saponaria	B	\N	\N	70D-40-70L
2375	Gentiana scabra	\N	\N	2	DS 1 y = dead
2376	Gentiana scabra	\N	1	\N	comment
2377	Gentiana scabra	B	\N	\N	70L
2378	Gentiana sceptrum	\N	\N	2	70 GA-3
2379	Gentiana septemfida	B	\N	\N	70
2380	Gentiana sino-ornata	B	\N	\N	70-40-70
2381	Gentiana siphonantha	B	\N	\N	70
2382	Gentiana sp. blue	\N	\N	2	70L
2383	Gentiana tianschanica	B	\N	\N	70
2384	Gentiana tibetica	B	\N	\N	70
2385	Gentiana trichotoma	B	\N	\N	70
2386	Gentiana turkestanicum	B	\N	\N	OT
2387	Gentiana verna	B	\N	\N	70 GA-3
2388	Gentiana walujewii	B	\N	\N	OT
2389	Gentianella barbellata	B	\N	\N	70-40-70
2390	Gentianella campestris	\N	1	\N	70 GA-3
2391	Gentianella germanica	\N	1	\N	70 GA-3
2392	Gentianella moorcroftiana	B	\N	\N	70
2393	Gentianella paludosa	B	\N	\N	70
2394	Gentianella sp.	B	\N	\N	70
2395	Gentianella turkestanorum	\N	1	\N	70 GA-3
2396	Gentianella turkestanorum	B	\N	\N	OT
2397	Gentianopsis crinita	B	\N	\N	see Gentiana crinita
2398	Gentianopsis stricta	B	\N	\N	OT
2399	Gentianopsis thermalis	B	\N	\N	40-70
2400	Geranium maculatum	B	\N	\N	OT
2401	Geranium sanguineum	B	\N	\N	70D
2402	Geranium sylvaticum	\N	\N	2	70D-40-70D
2403	Geranium sylvaticum	\N	1	\N	70L-40-70D
2404	Geranium transbaicalicum	B	\N	\N	70
2405	Geranium traversii	B	\N	\N	70D
2406	Geranium wallichianum	B	\N	\N	70
2407	Gerardia grandiflora	B	\N	\N	OT
2408	Geum borisii	B	\N	\N	OT
2409	Geum coccineum	B	\N	\N	70L
2410	Geum montanum	\N	\N	2	rotted
2411	Geum montanum	\N	1	\N	40-70D
2412	Geum montanum	B	\N	\N	OT
2413	Geum radicatum	B	\N	\N	70
2414	Geum reptans	B	\N	\N	OT
2415	Geum rivale	\N	1	\N	70L
2416	Geum urbanum	\N	1	\N	D-70
2417	Gilia androsacea	B	\N	\N	70
2418	Gilia formosa	\N	\N	2	70D
2419	Gilia formosa	\N	1	\N	40
2420	Gilia tricolor	B	\N	\N	40
2421	Gillenia trifoliata	\N	1	\N	OT
2422	Gillenia trifoliata	B	\N	\N	40-70 GA-3
2423	Gingidium decipiens	\N	\N	2	empty
2424	Gingidium montana	\N	\N	2	40
2425	Gingko biloba	B	\N	\N	WC 7 d, 70
2426	Gladiolus anatolicus	B	\N	\N	40
2427	Gladiolus caucasicus	B	\N	\N	OT
2428	Gladiolus imbricata	B	\N	\N	OT
2429	Gladiolus kotschyanus	B	\N	\N	40
2430	Glandulicactus uncinnatus	\N	1c	\N	70 GA-3
2431	Glandulicactus wrightii	\N	1c	\N	70 GA-3
2432	Glaucidium palmatum	B	\N	\N	70D
2433	Glaucidium palmatum album	B	\N	\N	70 GA-3
2434	Glaucium elegans	\N	1	\N	70D
2435	Glaucium elegans	B	\N	\N	70D
2436	Glaucium squamigera	B	\N	\N	70
2437	Gleditsia triacanthos	B	\N	\N	puncture, 70
2438	Globularia bisnagarica	\N	1	\N	chaff
2439	Globularia cordifolia	\N	1	\N	chaff
2440	Globularia cordifolia purpurea	\N	1	\N	chaff
2441	Globularia gellifolia	\N	1	\N	chaff
2442	Globularia incanescens	\N	1	\N	chaff
2443	Globularia nudicaulis	\N	\N	2	70D
2444	Globularia punctata	\N	1	\N	70L
2445	Globularia repens	\N	\N	2	70
2446	Globularia sp.	\N	\N	2	70L
2447	Globularia sp.	\N	1	\N	70D
2448	Globularia trichosantha	\N	\N	2	70D
2449	Globularia trichosantha	\N	1	\N	70L
2450	Gloriosa superba	\N	1	\N	70D
2451	Glycyrrhiza glabra	\N	1	\N	comment
2452	Glyphosperma palmeri	\N	\N	2	70D
2453	Glyphosperma palmeri	\N	1	\N	70D
2454	Godetia grandiflora	\N	\N	2	70D
2455	Godetia grandiflora	\N	1	\N	70L
2456	Gomphrena globosa	\N	\N	2	70D
2457	Gomphrena haageana	B	\N	\N	90d-70n OS
2458	Gomphrena haageana	\N	1	\N	70-90 OS
2459	Goniolimon tataricum	B	\N	\N	70
2460	Goodenia scapigera	\N	1	\N	empty
2461	Gossypium herbaceum	\N	1	\N	D-70
2462	Gossypium thurberii	\N	1	\N	comment
2463	Grayia spinosa	\N	1	\N	70 GA-3
2464	Grevillea buxifolia	\N	\N	2	extract, 70
2465	Grevillea pulchella	\N	\N	2	rotted
2466	Grevillea robusta	\N	\N	2	75
2467	Grevillea sp.	\N	1	\N	70
2468	Greyia spinosa	\N	\N	2	comment
2469	Grumolo verde scuro	B	\N	\N	70
2470	Grusonia bradtiana cuatrocienagas	\N	1c	\N	70 GA-3
2471	Guichenotia sterculiaceae	\N	1	\N	puncture, 70
2472	Gunnera chilensis	\N	1	\N	WC
2473	Gunnera densiflora	\N	1	\N	70 GA-3 40-70
2474	Gunnera flavida	B	\N	\N	rotted
2475	Gunnera manicata	\N	1	\N	WC
2476	Gunnera manicata	B	\N	\N	soak, 70
2477	Gunnera prorepens	B	\N	\N	rotted
2478	Gunnera sp.	B	\N	\N	rotted
2479	Gutierrizia sarothrae	B	\N	\N	70
2480	Gymnocactus beguinii	\N	1c	\N	70 GA-3
2481	Gymnocactus beguinii senilis	\N	1c	\N	70 GA-3
2482	Gymnocactus calochorum proliferum	\N	1c	\N	70 GA-3
2483	Gymnocactus knuthianus	\N	1c	\N	70 GA-3
2484	Gymnocactus subterraneus zaragosae	\N	1c	\N	70 GA-3
2485	Gymnocalycium ambatoense	\N	1c	\N	70 GA-3
2486	Gymnocalycium anisitsii	\N	1c	\N	70 GA-3
2487	Gymnocalycium baldianum	\N	1c	\N	70 GA-3
2488	Gymnocalycium bodenbenderianum	\N	1c	\N	70 GA-3
2489	Gymnocalycium calochorum proliferum	\N	1c	\N	70 GA-3
2490	Gymnocalycium gibbosum	\N	\N	2c	OS 50-70
2491	Gymnocalycium gibbosum	\N	1c	\N	70 GA-3
2492	Gymnocalycium gibbosum nigrum	\N	1c	\N	no germ
2493	Gymnocalycium multiflorum	\N	\N	2c	70 GA-3
2494	Gymnocalycium multiflorum	\N	1c	\N	70 GA-3
2495	Gymnocladus dioica	B	\N	\N	puncture, 70
2496	Gymnospermium altaicum	B	\N	\N	70-40-70
2497	Gynandriris setifolia	\N	\N	2	70D
2498	Gynandriris simulans	\N	\N	2	70D
2499	Gypsophila bungeana	B	\N	\N	D-70
2500	Gypsophila capitoliflora	B	\N	\N	D-70
2501	Gypsophila cerastoides	B	\N	\N	D-70
2502	Gypsophila elegans	\N	\N	2	50-85
2503	Gypsophila pacifica	B	\N	\N	40
2504	Haageocereus chosicensis	\N	1c	\N	70 GA-3
2505	Haageocereus pseudomelanostele	\N	1c	\N	70 GA-3
2506	Haberlea rhodopensis	B	\N	\N	70L-bagged
2507	Habranthus andersonii	B	\N	\N	70
2508	Hackelia bella	\N	1	\N	40
2509	Haleria corniculata	\N	1	\N	70L
2510	Halesia caroliniana	\N	\N	2	comment
2511	Halesia caroliniana	\N	1	\N	40-70-40-70-40-70-40-70-40-70
2512	Halesia caroliniana	B	\N	\N	(40-70-40-70) x 2-4 y
2513	Halgania cyanea	\N	\N	2	rotted
2514	Halimium alyssoides	\N	\N	2	no germ
2515	Halimium atroplicifolium	\N	\N	2	40
2516	Halimium ocymoides	\N	\N	2	70D
2517	Halimium ocymoides	\N	1	\N	70D
2518	Haloragis erecta	\N	\N	2	40-70D
2519	Hamamelis virginiana	\N	1	\N	DS 5 y = dead
2520	Hamamelis virginiana	B	\N	\N	70-40-70-40-70
2521	Hamatocactus sp.	\N	1c	\N	70 GA-3
2522	Haplocarpha scaposa	\N	\N	2	chaff
2523	Haplopappus bradegei	\N	\N	2	chaff
2524	Haplopappus Lyallii	B	\N	\N	70
2525	Haplopappus spinulosus	B	\N	\N	70
2526	Hardenburgia comptoniana	\N	1	\N	puncture
2527	Hardenburgia comptoniana	B	\N	\N	puncture, 70
2528	Harrisia bonplandii	\N	1c	\N	70 GA-3
2529	Harrisia brookii	\N	1c	\N	70 GA-3
2530	Hastingsia alba	B	\N	\N	DS 6 m, OT 
2531	Hebe chatamica	B	\N	\N	40-70-40-70
2532	Hebe epacridea	\N	1	\N	70L
2533	Hebe guthreana	B	\N	\N	40-70
2534	Hedeoma hispida	\N	1	\N	70L
2535	Hedyotis pygmaea	B	\N	\N	70L
2536	Hedyotis rubra	B	\N	\N	70L
2537	Hedysarum cephrolotes	B	\N	\N	70
2538	Heimia salicifolia 	\N	\N	2	70
2539	Helianthemum ledifolium	B	\N	\N	70-40-70
2540	Helianthemum nummularium	B	\N	\N	40
2541	Helianthemum oelandicum	B	\N	\N	70-40-70
2542	Helianthemum salicifolium	B	\N	\N	70
2543	Helianthus sp.	B	\N	\N	D-70
2544	Helichrysum bracteatum 	\N	\N	2	70D
2545	Helichrysum sp. 	B	\N	\N	70
2546	Heliotropium arborescens	\N	\N	2	70D
2547	Heliotropium arborescens	\N	1	\N	70
2548	Helleborus argutifolius	\N	1	\N	70-40-70-40
2549	Helleborus argutifolius	B	\N	\N	70-40
2550	Helleborus corsicus	B	\N	\N	dead
2551	Helleborus faetidus	\N	\N	2	DS 4 y = dead
2552	Helleborus niger	B	\N	\N	70-40
2553	Helleborus orientalis	B	\N	\N	70-40
2554	Helonias bullata	\N	\N	2	DS 1 y = dead
2555	Helonias bullata	\N	1	\N	70L
2556	Helonias bullata	B	\N	\N	70L
2557	Hemerocallis (hybrids)	B	\N	\N	70
2558	Hepatica acutiloba	B	\N	\N	70-40
2559	Hepatica americana	B	\N	\N	70-40
2560	Hepatica nobilis	B	\N	\N	40
2561	Heptacodium jasminoides	\N	\N	2	70D
2562	Heracleum nepalense	B	\N	\N	D-70
2563	Hermodactylus tuberosus	B	\N	\N	70-40
2564	Herniaria glabra	\N	1	\N	D-70
2565	Hesperaloe parviflora	\N	1	\N	70D
2566	Hesperantha bachmannii	\N	\N	2	40
2567	Hesperantha baurii (mossii)	\N	\N	2	40
2568	Hesperantha cucullata	\N	\N	2	40
2569	Hesperantha falcata	\N	\N	2	40
2570	Hesperantha pauciflora	\N	\N	2	40
2571	Hesperantha pearsoni	\N	\N	2	40
2572	Hesperantha sp.	\N	\N	2	40
2573	Hesperis matronalis	B	\N	\N	D-70
2574	Hesperochiron californicum	\N	1	\N	70 GA-3
2575	Heterodendrum oleifolium	\N	1	\N	70C
2576	Heterotheca fulcrata	B	\N	\N	70
2577	Heuchera cylindrica	\N	1	\N	70L
2578	Heuchera cylindrica	B	\N	\N	70L
2579	Heuchera cylindrica v. alpina	B	\N	\N	70
2580	Heuchera hallii	B	\N	\N	70L-40-70L
2581	Heuchera hispida	B	\N	\N	70L
2582	Heuchera richardsonii	\N	1	\N	70L
2583	Heuchera richardsonii	B	\N	\N	70
2584	Heuchera villosa	B	\N	\N	D-70L
2585	Hibbertia dentata	\N	1	\N	70 GA-3 40
2586	Hibiscus esculenta	\N	\N	2	70C
2587	Hibiscus lasiocarpus	\N	\N	2	70
2588	Hibiscus moscheutos	\N	\N	2	DS 1 y = dead
2589	Hibiscus moscheutos	B	\N	\N	70
2590	Hibiscus syriacus	B	\N	\N	70
2591	Hibiscus trionum	\N	\N	2	70D
2592	Hibiscus trionum	\N	1	\N	70D
2593	Hieracium maculatum	\N	1	\N	70L
2594	Hieracium olafii	\N	\N	2	DS 2 y = dead
2595	Hieracium olafii	\N	1	\N	70L
2596	Hierochloe	\N	\N	2	comment
2597	Hierochloe odorata	\N	1	\N	chaff
2598	Hippolytica darwasica	B	\N	\N	70
2599	Hippophae salicifolia	B	\N	\N	70
2600	Hoheria lyalli	\N	1	\N	empty
2601	Holodiscus discolor	B	\N	\N	40-70
2602	Homeria breyniana	\N	\N	2	40
2603	Homeria collina	\N	\N	2	40
2604	Honckenya (Ammadenia) peploides	\N	1	\N	70 GA-3
2605	Horminum pyrenaicum	B	\N	\N	70
2606	Hosta nakiana	B	\N	\N	70
2607	Hosta sieboldi	B	\N	\N	70
2608	Houstonia coerulea	B	\N	\N	70
2609	Houttuynia cordata	\N	1	\N	70L
2610	Hudsonia ericoides	B	\N	\N	70L
2611	Hulsea algida	\N	\N	2	40
2612	Humulus lupulus	\N	1	\N	70 GA-3
2613	Hunnemannia fumariifolia	\N	1	\N	70
2614	Hunnemannia fumariifolia	\N	\N	2	70D
2615	Hutchinsia alpinus	B	\N	\N	70
2616	Hyacinthella azurea	\N	\N	2	40
2617	Hyacinthus orientalis	B	\N	\N	70-40
2618	Hydrangea arborescens	\N	1	\N	70L
2619	Hydrangea panniculata	\N	1	\N	70 GA-3
2620	Hydrangea quercifolia	B	\N	\N	70L
2621	Hydrastis canadensis	B	\N	\N	40-70-40-70-40-70
2622	Hydrophyllum capitatum	\N	1	\N	70 GA-3 40
2623	Hylomecon japonicum	\N	\N	2	70 GA-3
2624	Hymenanthera alpina	\N	\N	2	70D-40-70D-40-70D
2625	Hymenocallis occidentalis	B	\N	\N	70-bagged
2626	Hymenocrater bituminosus	B	\N	\N	70
2627	Hymenolepis paraviflora	\N	\N	2	chaff
2628	Hymenosporum flavum	\N	1	\N	70L
2629	Hymenoxys acaulis ssp. caespitosa	B	\N	\N	70
2630	Hymenoxys grandiflora	B	\N	\N	70
2631	Hymenoxys lapidicola	B	\N	\N	70
2632	Hymenoxys sp.	B	\N	\N	40-70
2633	Hymenoxys subintegra	B	\N	\N	70
2634	Hyoscyamus niger	\N	1	\N	70 GA-3
2635	Hypericum choisianum	B	\N	\N	70L
2636	Hypericum densiflorum	B	\N	\N	70
2637	Hypericum olympicum	\N	\N	2	70 GA-3
2638	Hypericum olympicum	\N	1	\N	70 GA-3
2639	Hypericum perforatum	B	\N	\N	70L
2640	Hypericum pulchellum	B	\N	\N	70
2641	Hypericum spathulatum	\N	1	\N	70 L
2642	Hypericum spathulatum	B	\N	\N	70D GA-3
2643	Hypoxis hirsuta	B	\N	\N	70
2644	Hysoppus officinalis	\N	1	\N	70D
2645	Hysopus seravshanicus	B	\N	\N	70
2646	Hyssopus officinalis	\N	\N	2	70D
2647	Hystrix patula	Bg	\N	\N	40-70
2648	Iberis sempervirens	B	\N	\N	40
2649	Iberis umbellata	\N	\N	2	70D
2650	Iberis umbellata	\N	1	\N	70D
2651	Ibicella lutea	\N	\N	2	DS 2 y = dead
2652	Ibicella lutea	\N	1	\N	peel, 70D
2653	Ikonnikovia kaufmanniana	B	\N	\N	70
2654	Ilex aquifolium	\N	\N	2	no germ
2655	Ilex glabra	\N	1	\N	OT
2656	Ilex glabra	B	\N	\N	WC 7 d, OT
2657	Ilex japonica	B	\N	\N	WC 7 d, 40-70
2658	Ilex montana	\N	\N	2	no germ
2659	Ilex monticola	B	\N	\N	WC 14 d, OT
2660	Ilex opaca	\N	\N	2	no germ
2661	Ilex opaca	B	\N	\N	comment
2662	Ilex serrata	B	\N	\N	WC 7 d, 40-70
2663	Ilex verticillata	B	\N	\N	WC 14 d, OT
2664	Illiamna longisepala	B	\N	\N	puncture, 70
2665	Illiamna rivularis	B	\N	\N	puncture, 70
2666	Impatiens balfouri	\N	\N	2	40
2667	Impatiens balsamina	\N	\N	2	70D
2668	Impatiens balsamina	\N	1	\N	D-70
2669	Impatiens biflora	B	\N	\N	40-OT
2670	Impatiens parviflora	B	\N	\N	comment
2671	Impatiens scabrida	B	\N	\N	70
2672	Incarvillea arguta	B	\N	\N	D-70
2673	Incarvillea mairei	B	\N	\N	D-70
2674	Incarvillea olgae	B	\N	\N	D-70
2675	Indifogera heteranthera	B	\N	\N	puncture, 70
2676	Inula ensifolia	B	\N	\N	D-70
2677	Inula helenium	\N	1	\N	70L
2678	Inula helenium 	\N	\N	2	70D
2679	Inula obtusifolia	B	\N	\N	D-70
2680	Inula rhizocephala	B	\N	\N	D-70
2681	Ipheion uniflorum	\N	1	\N	40-70D-40
2682	Ipomoea batatas	\N	1	\N	comment
2683	Ipomoea leptophylla	B	\N	\N	70
2684	Ipomoea tricolor	\N	\N	2	55-85
2685	Ipomoea tricolor	\N	1	\N	D-70
2686	Ipomopsis aggregata	B	\N	\N	40-70
2687	Ipomopsis rubra	\N	\N	2	70D
2688	Ipomopsis spicata	B	\N	\N	70-40
2689	Iris acutiloba	B	\N	\N	70-40-70-40-70-40-70
2690	Iris attica	\N	1	\N	(40-70) x 8 + 40
2691	Iris barnumae	B	\N	\N	comment
2692	Iris bracteata	B	\N	\N	40
2693	Iris brandzae	B	\N	\N	70-40-70
2694	Iris bulleyana	\N	1	\N	70L
2695	Iris chrysophylla	B	\N	\N	40
2696	Iris darwasica	\N	1	\N	(70-40-70-40) x 3.5 + 40
2697	Iris decora	B	\N	\N	70
2698	Iris dichotoma	B	\N	\N	70
2699	Iris douglasiana	B	\N	\N	WC 4 w, 40
2700	Iris elegantissima	B	\N	\N	70-OT
2701	Iris ensata	B	\N	\N	OT
2702	Iris foetidissima	B	\N	\N	40-70-40
2703	Iris forrestii	B	\N	\N	WC 7 d, OT
2704	Iris germanica	B	\N	\N	40
2705	Iris goniocarpa	B	\N	\N	OT
2706	Iris histroides	B	\N	\N	(40-70-40-70) x 2-3y, OT
2707	Iris hoogiana	B	\N	\N	40-70-40
2708	Iris hookeri	B	\N	\N	70-40-70
2709	Iris illlyrica	B	\N	\N	40-70
2710	Iris innominata	B	\N	\N	70-40
2711	Iris junoniana	B	\N	\N	70
2712	Iris kemaoensis	B	\N	\N	70-40-70-40-70
2713	Iris lactea	B	\N	\N	OT
2714	Iris latifolia	B	\N	\N	WC 4 w, 70-40
2715	Iris lutescens	B	\N	\N	70
2716	Iris mandschurica	B	\N	\N	70L
2717	Iris milesii	B	\N	\N	40-70L
2718	Iris missouriensis	B	\N	\N	70L
2719	Iris nepalensis	B	\N	\N	70
2720	Iris oncocyclus (hybrids)	B	\N	\N	70-40-70-40-70-40
2721	Iris orientalis	B	\N	\N	70-40
2722	Iris paradoxa	B	\N	\N	70
2723	Iris pseudoacorus	B	\N	\N	70L-40-70L
2724	Iris pumila	B	\N	\N	70
2725	Iris reticulata	B	\N	\N	70-40-70-40-70-40
2726	Iris ruthenica	B	\N	\N	70D
2727	Iris setosa	B	\N	\N	OT
2728	Iris sibirica	B	\N	\N	70L
2729	Iris sintenesii	B	\N	\N	see Iris brandzae
2730	Iris sogdiana	B	\N	\N	70L
2731	Iris spuria	B	\N	\N	70L
2732	Iris spuria v. halophila	B	\N	\N	70
2733	Iris stolonifera	\N	\N	2	comment
2734	Iris stolonifera	\N	1	\N	(40-70-40-70) x 2 + 40
2735	Iris subbiflora	B	\N	\N	70-40-70-40-70
2736	Iris taochia	B	\N	\N	70L
2737	Iris tectorum	B	\N	\N	70L
2738	Iris tectorum alba	B	\N	\N	70L
2739	Iris tenax	B	\N	\N	40
2740	Iris trojana	\N	1	\N	70
2741	Iris trojana	B	\N	\N	70
2742	Iris typhifolia 	\N	1	\N	70L
2743	Iris unguicularis	B	\N	\N	70-40
2744	Iris versicolor	\N	1	\N	70L
2745	Iris versicolor	B	\N	\N	70L
2746	Iris wilsoni	B	\N	\N	70L
2747	Iris xiphoides	\N	1	\N	70 GA-3 40
2748	Isatis tinctoria	\N	\N	2	40
2749	Isatis tinctoria	\N	1	\N	40
2750	Isoplexis canariensis	\N	\N	2	70
2751	Isoplexis canariensis	\N	1	\N	70L
2752	Isopyrum biternatum	B	\N	\N	70-40-40
2753	Isotoma axillaris	\N	\N	2	70
2754	Isotoma axillaris	\N	1	\N	70L
2755	Itea virginica 	B	\N	\N	40-70L
2756	Ivesia gordonii	B	\N	\N	70
2757	Ixia paniculata	\N	\N	2	70D-40
2758	Ixia pumilio	\N	\N	2	70D
2759	Ixia pycnostachys	\N	\N	2	70D
2760	Ixia viridiflora	\N	\N	2	70D
2761	Ixolirion kerateginium	B	\N	\N	OT
2762	Ixolirion tataricum	B	\N	\N	40
2763	Jacaranda mimosifolia	B	\N	\N	70
2764	Jamesia americana	\N	1	\N	70L
2765	Jankae heldrichii	B	\N	\N	70
2766	Jasione crispa	B	\N	\N	70
2767	Jasminum humile	B	\N	\N	70L
2768	Jatropha curcas	\N	1	\N	70D
2769	Jatropha macrocarpa	\N	\N	2	no germ
2770	Jeffersonia diphylla	B	\N	\N	40-70-40-70-40-70
2771	Jeffersonia dubia	B	\N	\N	OT
2772	Jovellana repens	\N	1	\N	chaff
2773	Juglans ailantifolia v. cordiformis	B	\N	\N	40-70-40-70
2774	Juglans cinerea	B	\N	\N	OT
2775	Juglans nigra	B	\N	\N	OT
2776	Juglans regia	\N	1	\N	70D
2777	Juncus compressus	\N	1	\N	70L
2778	Juncus effusus	\N	\N	2	70L
2779	Juncus effusus	\N	1	\N	70L
2780	Juncus tenuis	\N	\N	2	70L
2781	Juncus tenuis	\N	1	\N	70L
2782	Juniperus horizontalis	\N	1	\N	70-40-70-40-70
2783	Juniperus horizontalis	B	\N	\N	40
2784	Juniperus virginiana	B	\N	\N	40-70-40-70
2785	Juno aitchisonii	B	\N	\N	70
2786	Juno albomarginata	B	\N	\N	70-40-70
2787	Juno aucheri	B	\N	\N	70-40-70-40-70-40
2788	Juno baldshuanica	B	\N	\N	40-70-40-70-40
2789	Juno bucharica	\N	\N	2	green 40-40
2790	Juno bucharica	\N	1	\N	green, 70-40
2791	Juno bucharica	B	\N	\N	D-70-40-70-40-70-40-70-40
2792	Juno coerulea	B	\N	\N	40-70-40-70-40-70
2793	Juno cycloglossa	B	\N	\N	70-40
2794	Juno graeberiana	B	\N	\N	40-70-40
2795	Juno halda	\N	\N	2	green 40-40
2796	Juno kuschakewiczii	B	\N	\N	40-70-40
2797	Juno magnifica	\N	\N	2	green 40-40
2798	Juno magnifica	B	\N	\N	40
2799	Juno orchioides	B	\N	\N	70
2800	Juno sp.	B	\N	\N	70-40-70-40
2801	Juno stenophylla v. allisonii	B	\N	\N	40-70
2802	Juno subdecolorata	B	\N	\N	70-40
2803	Juno vicaria	B	\N	\N	40-70-40-70-40
2804	Juno wilmottiana	B	\N	\N	OT
2805	Juno zaprajagejewii	B	\N	\N	40-70-40-70
2806	Jurinella moschus	B	\N	\N	70
2807	Kalanchoe (hybrids)	B	\N	\N	70L
2808	Kalanchoe flammea	\N	\N	2	60L-85L
2809	Kalanchoe grandiflora	\N	\N	2	50-70 OS
2810	Kalmia angustifolia	B	\N	\N	70L
2811	Kalmia cuneata	B	\N	\N	comment
2812	Kalmia hirsuta	B	\N	\N	comment
2813	Kalmia latifolia	B	\N	\N	70L
2814	Kalmia microphylla	B	\N	\N	comment
2815	Kalmia polifolia	B	\N	\N	comment
2816	Kalopanax pictus	\N	1	\N	70D-40-70D
2817	Kedrostis	\N	\N	2	comment
2818	Kedrostis africana	\N	1	\N	70D
2819	Kelseya uniflora	\N	\N	2	70D
2820	Kelseya uniflora	\N	1	\N	70 GA-3
2821	Kernera saxatilis	\N	1	\N	70L
2822	Kigelia pinnata	\N	1	\N	70
2823	Kirengoshima palmata	B	\N	\N	40
2824	Kitaibelia vitifolia	\N	1	\N	puncture, 70D
2825	Knautia macedonica	\N	1	\N	70L
2826	Kochia scoparia	\N	\N	2	50-85
2827	Koeleria glauca	Bg	\N	\N	D-70
2828	Koelreuteria paniculata	B	\N	\N	D-puncture, 70-40-70
2829	Koenigia islandica	\N	1	\N	70
2830	Kolkwitzia amabilis	B	\N	\N	70
2831	Korolkowia sewerzowii	B	\N	\N	OT
2832	Kunzea baxteri	\N	1	\N	70D
2833	Kunzea baxteri	B	\N	\N	70L
2834	Kunzea vestita	\N	1	\N	comment
2835	Kunzea vestita	B	\N	\N	70L
2836	Laburnum vossi	B	\N	\N	puncture, 70
2837	Lachenalia algoensis	\N	\N	2	70D
2838	Lachenalia aloides	\N	\N	2	70D
2839	Lachenalia arabuthnotiae	\N	\N	2	70D
2840	Lachenalia bulbifera	\N	\N	2	70D
2841	Lachenalia capensis	\N	\N	2	70D-40
2842	Lachenalia elegans	\N	\N	2	70D-40
2843	Lachenalia fistulosa	\N	\N	2	70D
2844	Lachenalia gilleti	\N	1	\N	70D
2845	Lachenalia gillettii	\N	\N	2	70D
2846	Lachenalia glaucina	\N	\N	2	70D
2847	Lachenalia glaucina pallida	\N	\N	2	70D
2848	Lachenalia latiflora	\N	\N	2	70D
2849	Lachenalia latiflora	\N	1	\N	70D
2850	Lachenalia latifolia	\N	\N	2	70D
2851	Lachenalia liliflora	\N	\N	2	70D
2852	Lachenalia mediana	\N	\N	2	70D
2853	Lachenalia mediana	\N	1	\N	70D
2854	Lachenalia orchioides	\N	\N	2	70D
2855	Lachenalia orthopetala	\N	\N	2	70D
2856	Lachenalia pallida	\N	\N	2	70D
2857	Lachenalia postulata	\N	\N	2	70D
2858	Lachenalia postulata	\N	1	\N	70D
2859	Lachenalia reflexa	\N	\N	2	70D
2860	Lachenalia rosea	\N	\N	2	70D
2861	Lachenalia unicolor	\N	\N	2	70D
2862	Lachenalia unicolor	\N	1	\N	70D
2863	Lactuca sativus	\N	\N	2	70D
2864	Lactuca sativus	\N	1	\N	70
2865	Lagarus ovatus	Bg	\N	\N	D-70
2866	Lagopsis marrubiastrum	\N	1	\N	empty
2867	Lagotis ikonnikovii	B	\N	\N	70
2868	Lagotis uralensis	B	\N	\N	70-40
2869	Lagunaria patersonii	\N	\N	2	comment
2870	Lagunaria patersonii	\N	1	\N	puncture, 70D
2871	Lallemantia canescens	B	\N	\N	70
2872	Lallemantia iberica	\N	\N	2	WC, 70D
2873	Lamium maculatum	B	\N	\N	70L
2874	Lapeirousia anomatheca laxa	\N	\N	2	70D
2875	Lapeirousia laxa	B	\N	\N	70L
2876	Lapeirousia laxa alba	B	\N	\N	40-70
2877	Larix kaempferi	B	\N	\N	40
2878	Larrea tridentata	\N	\N	2	70D
2879	Larrea tridentata	\N	1	\N	70D
2880	Larrea tridentata	B	\N	\N	70D
2881	Lathyrus latifolius	\N	1	\N	70D
2882	Lathyrus latifolius	\N	\N	2	70D
2883	Lathyrus latifolius	B	\N	\N	70
2884	Lathyrus odoratus	\N	\N	2	70D
2885	Lathyrus vernus	B	\N	\N	40
2886	Laurentia axillaris	\N	\N	2	rotted
2887	Laurentia gasparrinii	\N	\N	2	70D
2888	Lavandula sp.	\N	1	\N	70D
2889	Lavandula spica	B	\N	\N	70L
2890	Lavatera arborea	\N	\N	2	70D
2891	Lavatera thuringiaca	\N	\N	2	70D
2892	Lavatera thuringiaca	\N	1	\N	70
2893	Lavetia (Azorella ) compacta	\N	\N	2	70D
2894	Lawsonia inermis v. alba	\N	1	\N	no germ
2895	Lechenaultia biloba	\N	\N	2	empty
2896	Ledum groenlandicum	B	\N	\N	70D GA-3
2897	Legousia patagonia	\N	1	\N	70L
2898	Legousia patagonia 	\N	\N	2	70L
2899	Leiophyllum buxifolium	B	\N	\N	70L
2900	Leonotis dysophylla	\N	\N	2	70D
2901	Leonotis leonurus	\N	1	\N	70
2902	Leontice incerta	B	\N	\N	70
2903	Leontodon autumnalis	\N	1	\N	70L
2904	Leontodon autumnalis	\N	\N	2	70D
2905	Leontopodium alpinum	B	\N	\N	70
2906	Leontopodium calocephalum	B	\N	\N	70
2907	Leontopodium himalaicum	B	\N	\N	70
2908	Leontopodium nivale	B	\N	\N	70
2909	Leontopodium ochroleucum	B	\N	\N	70
2910	Leontopodium paliginianus	\N	\N	2	70D
2911	Leontopodium soulei	B	\N	\N	70
2912	Leonurus cardiaca	\N	1	\N	D-70
2913	Leonurus sibiricus	\N	1	\N	D-70
2914	Leopoldia comosa alba	\N	\N	2	70D-40
2915	Lepechina calycina	\N	1	\N	70D-40-70D
2916	Lepidium sativum	B	\N	\N	70
2917	Leptarrhena pyrolifolia	B	\N	\N	70L
2918	Leptinella (Cotula) pyrethifolia	\N	\N	2	70D
2919	Leptinella pyrethifolia 	\N	1	\N	70L
2920	Leptodactylon pungens	B	\N	\N	70
2921	Leptodactylon watsonii	\N	\N	2	70D
2922	Leptodactylon watsonii	\N	1	\N	70D
2923	Leptosiphon (hybrids)	\N	\N	2	70D
2924	Leptosiphon (hybrids)	B	\N	\N	70
2925	Leptospermum lanigenum	\N	1	\N	70
2926	Leptospermum petersonii	\N	\N	2	chaff
2927	Leptospermum scoparium	\N	\N	2	chaff
2928	Leptospermum scoparium	\N	1	\N	70
2929	Lespedeza bicolor	B	\N	\N	70-40-70
2930	Lesquerella condensata	B	\N	\N	70
2931	Lesquerella fendleri	B	\N	\N	70
2932	Lesquerella ovalifolia	B	\N	\N	70
2933	Lesquerella pinetorum	B	\N	\N	70
2934	Lesquerella purshii	B	\N	\N	70
2935	Lesquerella rubicunde	B	\N	\N	70
2936	Leucaena leucocephala	\N	\N	2	puncture, 70
2937	Leucaena leucocephala	\N	1	\N	puncture, 70D
2938	Leuchtenbergia principis	\N	1c	\N	70 GA-3
2939	Leucocrinum montanum	\N	1	\N	40-70D
2940	Leucojum aestivum	B	\N	\N	70-40-70-40-70
2941	Leucojum vernum	B	\N	\N	70
2942	Leucopogon colensoi	\N	1	\N	no germ
2943	Leucopogon fraseri	\N	\N	2	40-70D-40-70D-40-70D
2944	Leucospermum formosum	\N	\N	2	rotted
2945	Leucothoe racemosa	B	\N	\N	70L
2946	Levisticum officinale	B	\N	\N	70L
2947	Levisticum officinale	\N	1	\N	70D
2948	Lewisia brachycalyx	B	\N	\N	70-40
2949	Lewisia cotyledon	\N	\N	2	40
2950	Lewisia cotyledon	B	\N	\N	40
2951	Lewisia nevadensis	B	\N	\N	OT
2952	Lewisia pygmaea	B	\N	\N	OT
2953	Lewisia rediviva	B	\N	\N	40
2954	Lewisia tweedyi	B	\N	\N	D-40
2955	Leycesteria formosa	\N	\N	2	70L
2956	Leycesteria formosa	\N	1	\N	70D
2957	Liatris spicata	\N	\N	2	40-70D
2958	Liatris spicata	B	\N	\N	70
2959	Libanotis montana	B	\N	\N	OT
2960	Libertia caerulescens	\N	\N	2	no germ
2961	Libertia formosa	\N	\N	2	70D
2962	Libertia formosa	\N	1	\N	70D
2963	Libertia grandiflora 	\N	\N	2	70L-40
2964	Libertia ixioides 	\N	\N	2	70L-40
2965	Libertia perecrinans	\N	\N	2	70L-40-70D
2966	Libertia tricolor	\N	\N	2	no germ
2967	Libocedrus decurrens	\N	1	\N	70D
2968	Libocedrus decurrens	B	\N	\N	70D
2969	Lignocarpa carnosula	\N	\N	2	no germ
2970	Ligularia amplexicaulis	B	\N	\N	70D
2971	Ligularia dentata	B	\N	\N	40-70
2972	Ligularia japonica	\N	1	\N	70D-40-70D
2973	Ligusticum scoticum	\N	1	\N	OT
2974	Ligustrum japonicum	B	\N	\N	70
2975	Ligustrum obtusifolium	B	\N	\N	WC, 70-40-70
2976	Lilium albanicum	B	\N	\N	70-40
2977	Lilium alexandrae	B	\N	\N	70
2978	Lilium amabile	B	\N	\N	70
2979	Lilium amabile luteum	B	\N	\N	70
2980	Lilium auratum	\N	1	\N	70D
2981	Lilium auratum	B	\N	\N	70
2982	Lilium canadense flavum	B	\N	\N	70
2983	Lilium canadense v. editorum	B	\N	\N	70
2984	Lilium canadense v. editorum	\N	1	\N	70D
2985	Lilium candidum	B	\N	\N	70
2986	Lilium catesbaei	B	\N	\N	comment
2987	Lilium caucasicum	B	\N	\N	70-40
2988	Lilium centifolium (hybrids)	\N	\N	2	DS 3 y = dead
2989	Lilium centifolium (hybrids)	B	\N	\N	70-70
2990	Lilium centifolium x henryi	B	\N	\N	comment
2991	Lilium cernuum	B	\N	\N	70
2992	Lilium chalcedonicum	B	\N	\N	70-40-70
2993	Lilium ciliatum	B	\N	\N	70-40-70
2994	Lilium columbianum	\N	1	\N	40-70-40-70-40
2995	Lilium concolor	B	\N	\N	70
2996	Lilium concolor v. partheneion	B	\N	\N	70-40
2997	Lilium davidi	B	\N	\N	70
2998	Lilium debile	B	\N	\N	70-40
2999	Lilium formosanum	B	\N	\N	70
3000	Lilium grayi	B	\N	\N	70
3001	Lilium humboldtii v. ocellatum	\N	1	\N	70-40
3002	Lilium kelleyanum	B	\N	\N	70-40
3003	Lilium martagon	\N	\N	2	DS 3 y = dead
3004	Lilium martagon	\N	1	\N	70D
3005	Lilium martagon	B	\N	\N	40-70
3006	Lilium martagon album	B	\N	\N	70
3007	Lilium maximowiczii	B	\N	\N	70
3008	Lilium michauxii	B	\N	\N	70-40
3009	Lilium michauxii 	\N	\N	2	70D-40
3010	Lilium michiganense	B	\N	\N	70
3011	Lilium monadelphum	B	\N	\N	70-40-40
3012	Lilium nanum	B	\N	\N	70
3013	Lilium nepalense	B	\N	\N	70
3014	Lilium nobilissimum	B	\N	\N	40
3015	Lilium occidentale	\N	\N	2	40
3016	Lilium occidentale	\N	1	\N	40
3017	Lilium pardalinum	\N	1	\N	OT
3018	Lilium pardalinum	B	\N	\N	OT-40-70
3019	Lilium pardalinum v. wigginsii	\N	1	\N	70-40
3020	Lilium parryi	\N	1	\N	70-40
3021	Lilium parvum	B	\N	\N	OT-40-70
3022	Lilium philadelphicum	B	\N	\N	comment
3023	Lilium pomponium	B	\N	\N	70-40
3024	Lilium ponticum	B	\N	\N	70-40-70
3025	Lilium pulchellum	B	\N	\N	70
3026	Lilium pumilium	B	\N	\N	70
3027	Lilium pumilum 	\N	\N	2	70D
3028	Lilium pyrenaicum	\N	\N	2	DS 4 y = dead
3029	Lilium pyrenaicum	B	\N	\N	OT
3030	Lilium regale	\N	\N	2	DS 3 y = dead
3031	Lilium regale	B	\N	\N	70
3032	Lilium sachalinense	B	\N	\N	70
3033	Lilium shastense	B	\N	\N	OT-40-70
3034	Lilium superbum	\N	1	\N	70
3035	Lilium superbum	B	\N	\N	70
3036	Lilium szovitsianum	\N	1	\N	70D-40-70
3037	Lilium szovitsianum	B	\N	\N	70
3038	Lilium szovitsianum 	\N	\N	2	70D
3039	Lilium tennuifolium	B	\N	\N	70
3040	Lilium tsingtauense	B	\N	\N	70-40-70
3041	Lilium washingtonianum	B	\N	\N	70-40-70
3042	Limnanthes douglasii	\N	\N	2	70D
3043	Limnanthus douglasii	B	\N	\N	70
3044	Limonium latifolium	B	\N	\N	70
3045	Limonium minutum	B	\N	\N	70
3046	Limonium sinuatum 	\N	\N	2	70D
3047	Linanthrastum nuttallii	\N	\N	2	70D-40
3048	Linanthrastum nuttallii	\N	1	\N	70 GA-3
3049	Linanthrastum nuttallii	B	\N	\N	40
3050	Linanthus grandiflora	B	\N	\N	70
3051	Linanthus grandiflorus	\N	\N	2	70D
3052	Linaria kurdica	B	\N	\N	70
3053	Linaria purpurea	B	\N	\N	70L
3054	Linaria pyramidata	B	\N	\N	70
3055	Linaria trystis	B	\N	\N	D-70
3056	Lindelofia longiflora	B	\N	\N	70
3057	Lindera benzoin	B	\N	\N	WC, 70-40-70
3058	Linum alpinum	\N	\N	2	DS 1 y = dead
3059	Linum alpinum	\N	1	\N	70 GA-3
3060	Linum boreale	B	\N	\N	70D
3061	Linum bulgaricum	B	\N	\N	70L
3062	Linum capitatum	B	\N	\N	70 GA-3
3063	Linum catharticum	\N	1	\N	70L-40-70D
3064	Linum catharticum	B	\N	\N	70 GA-3
3065	Linum dolomiticum	B	\N	\N	OT
3066	Linum extraaxillare	B	\N	\N	70-40-70-40-70-40-70
3067	Linum kingii	B	\N	\N	70
3068	Linum perenne	B	\N	\N	70L
3069	Linum usitatissimum	\N	1	\N	D-70
3070	Linum veitatissi	B	\N	\N	70
3071	Lippia (Phyla) nodiflora	\N	1	\N	chaff
3072	Liquidambar styraciflua	B	\N	\N	D-70
3073	Liriodendron tulipifera	\N	1	\N	70D-40-70D
3074	Liriope spicata	B	\N	\N	70L
3075	Lirodendron tulipifera	B	\N	\N	comment
3076	Lisianthus russelianum	B	\N	\N	70L
3077	Lithocarpus densiflorus v. echinoides	\N	1	\N	70D-40
3078	Lithospermum incisum	B	\N	\N	70L
3079	Lithospermum multiflorum	B	\N	\N	70L
3080	Lithospermum officinale	\N	1	\N	70L
3081	Livistonia chinensis	\N	\N	2	DS 1 y = dead
3082	Livistonia chinensis	\N	1	\N	70
3083	Lloydia serotina	B	\N	\N	70
3084	Lloydia triflora	B	\N	\N	40
3085	Loasa nana	B	\N	\N	70D
3086	Loasa sigmoidea	B	\N	\N	rotted
3087	Loasa vulcanica	B	\N	\N	70L
3088	Lobelia anatina	\N	1	\N	70 GA-3
3089	Lobelia boykinii	\N	1	\N	70 GA-3
3090	Lobelia cardinalis	\N	1	\N	70L
3091	Lobelia cardinalis	B	\N	\N	70L
3092	Lobelia erinus	\N	\N	2	70D
3093	Lobelia inflata	\N	1	\N	70L
3094	Lobelia inflata	B	\N	\N	70L
3095	Lobelia pendula	\N	\N	2	70D
3096	Lobelia pendula	\N	1	\N	70
3097	Lobelia sessilifolia	B	\N	\N	70L-40-70L
3098	Lobelia syphilitica	B	\N	\N	70L
3099	Lobelia tupa	B	\N	\N	70
3100	Lobivia acanthophlegma oligotricha	\N	1c	\N	70 GA-3
3101	Lobivia aurea	\N	1c	\N	70 GA-3
3102	Lobivia aurea leucomalis	\N	1c	\N	70 GA-3
3103	Lobivia backebergii	\N	1c	\N	70 GA-3
3104	Lobivia bruchii	\N	\N	2c	70 GA-3
3105	Lobivia bruchii	\N	1c	\N	70
3106	Lobivia chrysantha	\N	1c	\N	70
3107	Lobivia einsteinii aureiflora	\N	1c	\N	70 GA-3
3108	Lobivia saltensis nealeana	\N	1c	\N	70 GA-3
3109	Lobivia wrightiana winteriana	\N	1c	\N	70
3110	Loiseleuria procumbens	\N	1	\N	70L
3111	Lomatium columbianum	B	\N	\N	40
3112	Lomatium grayi	B	\N	\N	40-70
3113	Lomatium laevigatum	B	\N	\N	40
3114	Lomatium macrocarpum	B	\N	\N	40
3115	Lomatium martindalei	B	\N	\N	40
3116	Lomatium nudicaule	B	\N	\N	40
3117	Lomatium nuttallii	\N	1	\N	40
3118	Lomatogonum sp.	B	\N	\N	40-70L
3119	Lonicera hallii	B	\N	\N	40-70
3120	Lonicera maacki	B	\N	\N	40
3121	Lonicera obovata	B	\N	\N	70
3122	Lonicera pyrenaica	B	\N	\N	70-40-70-40-70
3123	Lonicera sempervirens	B	\N	\N	40
3124	Lonicera tatarica	B	\N	\N	70
3125	Lopezia racemosa	\N	1	\N	70
3126	Lophocereus schottii	\N	1c	\N	70 GA-3
3127	Lophophora decipiens	\N	1c	\N	70 GA-3
3128	Lotus corniculatus	B	\N	\N	70
3129	Loxanthocereus seniloides	\N	1c	\N	70 GA-3
3130	Luetkea pectinata	\N	\N	2	70D
3131	Lunaria annua	B	\N	\N	70
3132	Lupinus lepidus v. lobbii	B	\N	\N	puncture, 70
3133	Lupinus lyallii v. lobbii	B	\N	\N	puncture, 70
3134	Lupinus polyphyllus	\N	\N	2	50-85
3135	Luzula luzuloides	\N	1	\N	70
3136	Luzula nivea	\N	1	\N	70
3137	Luzula pilosa	\N	1	\N	70L
3138	Lycene kubotai	\N	\N	2	70L
3139	Lychnis (hybrids)	\N	\N	2	70D
3140	Lychnis alba	\N	\N	2	70L
3141	Lychnis alba	\N	1	\N	70L
3142	Lychnis alba	B	\N	\N	70L
3143	Lychnis alpina	B	\N	\N	70
3144	Lychnis chalcedonica	\N	\N	2	70D
3145	Lychnis chalcedonica	B	\N	\N	70
3146	Lychnis coronaria 	\N	\N	2	70D
3147	Lychnis flos-cuculi	\N	1	\N	70
3148	Lychnis flos-jovis   	\N	\N	2	70D
3149	Lychnis sieboldi	B	\N	\N	70
3150	Lychnis viscaria	\N	\N	2	70D
3151	Lychnis wilfordii	B	\N	\N	70L
3152	Lychnis x arkwrightii	\N	\N	2	70D
3153	Lychnis yunnanensis	\N	\N	2	70D
3154	Lycium chinense	\N	1	\N	70
3155	Lycopersicon esculentum	\N	\N	2	70D
3156	Lycopersicon esculentum	\N	1	\N	70D
3157	Lycopersicon esculentum	B	\N	\N	70D
3158	Lycopus europaeus	\N	1	\N	D-70
3159	Lycoris pumila	B	\N	\N	70-40
3160	Lygodesmia texana	B	\N	\N	40-70
3161	Lyonia mariana	B	\N	\N	70L
3162	Lysichiton americanum	\N	1	\N	70L
3163	Lysichiton americanum	B	\N	\N	40-nick-70
3164	Lysichiton camschatcencis	B	\N	\N	70-40-70
3165	Lysichiton camschatcencis	\N	1	\N	70L
3166	Lysimachia ciliata	B	\N	\N	70
3167	Lysimachia punctata	\N	\N	2	70L
3168	Lysimachia punctata	\N	1	\N	70L
3169	Lythrum salicaria	B	\N	\N	70L
3170	Maackia amurensis	\N	1	\N	puncture, 70D
3171	Macfadyena unguis-cati	\N	1	\N	70
3172	Machaeranthera tanacetifolia	\N	\N	2	70D
3173	Machaeranthera tanacetifolia	B	\N	\N	70
3174	Machaerocereus gummosus	\N	1c	\N	70 GA-3
3175	Macleaya cordata	B	\N	\N	70L
3176	Maclura pomifera	B	\N	\N	WC 5 d, WC 5 d (det.), 70
3177	Magnolia denudata	B	\N	\N	WC (det.), 40-70
3178	Magnolia glauca	B	\N	\N	WC (det.), 40-70
3179	Magnolia grandiflora	\N	\N	2	DS 1 y = dead
3180	Magnolia grandiflora	\N	1	\N	WC 7 d, 6 w OS, 70D
3181	Magnolia kobus v. stellata	\N	1	\N	40-70
3182	Magnolia kobus v. stellata	B	\N	\N	WC (det.), 40-70-40-70
3183	Magnolia sieboldi	B	\N	\N	DS 2 y = dead
3184	Magnolia tripetala	B	\N	\N	WC (det.), 40-70-40-70
3185	Magnolia wilsoni	B	\N	\N	DS 2 y = dead
3186	Mahonia aquifolium 	B	\N	\N	WC 7 d, DS, 40-70-40-70-40-70
3187	Maianthemum canadense	B	\N	\N	40-70
3188	Maihuenia patagonica	\N	\N	2c	70 GA-3
3189	Maihuenia patagonica	\N	1c	\N	70 GA-3
3190	Maihueniopsis glomerata	\N	1c	\N	70 GA-3
3191	Maihueniopsis sp. 'yocalla'	\N	1c	\N	no germ
3192	Majorana hortensis	B	\N	\N	70
3193	Malabaila involucrata	\N	\N	2	70
3194	Malacothamnus densiflorus	\N	1	\N	puncture, 70D
3195	Malesherbia linearifolia	B	\N	\N	40
3196	Malleostemon roseus	\N	\N	2	rotted
3197	Malope trifida	\N	\N	2	70D
3198	Malope trifida	\N	1	\N	70
3199	Malus baccata	B	\N	\N	40
3200	Malus 'bob white'	B	\N	\N	40
3201	Malus 'donald wyman'	B	\N	\N	40
3202	Malus hupenensis	\N	\N	2	DS 3 y = dead
3203	Malus 'joneliscious'	B	\N	\N	40-70
3204	Malus 'red splendor'	B	\N	\N	40
3205	Malus robusta	\N	\N	2	DS 4 y = dead
3206	Malus sp.	B	\N	\N	40-70
3207	Malus 'yellow delicious'	B	\N	\N	40
3208	Malva alcaea	\N	1	\N	puncture, 70
3209	Malva moschata	\N	1	\N	70
3210	Malva moschata	B	\N	\N	70
3211	Malvaviscus arboreus	\N	1	\N	70L
3212	Mamillaria apamiensis pratensis	\N	1c	\N	70 GA-3
3213	Mamillaria apozolensis saltensis	\N	1c	\N	70 GA-3
3214	Mamillaria aurihamata	\N	\N	2c	OS 32-75
3215	Mamillaria aurihamata	\N	1c	\N	70 GA-3
3216	Mamillaria backebergiana	\N	1c	\N	70
3217	Mamillaria bocasana f. roseiflora	\N	1c	\N	70 GA-3
3218	Mamillaria carnea	\N	1c	\N	no germ
3219	Mamillaria gueizowiana	\N	1c	\N	70 GA-3
3220	Mamillaria lasiacantha	\N	\N	2c	OS 32-75
3221	Mamillaria lasiacantha	\N	1c	\N	70 GA-3
3222	Mamillaria melacantha	\N	1c	\N	70 GA-3
3223	Mamillaria napina	\N	\N	2c	70 GA-3
3224	Mamillaria senilis	\N	1c	\N	70 GA-3
3225	Mamillaria theresae	\N	\N	2c	OS 32-75
3226	Mamillaria theresae	\N	1c	\N	70 GA-3
3227	Mamillaria wrightrii	\N	\N	2c	OS 32-75
3228	Mandevilla suaveolens	\N	\N	2	70L
3229	Mandevilla suaveolens	\N	1	\N	70D
3230	Mandragora officinalis	\N	1	\N	40-70-40-70
3231	Mangifera indica	\N	1	\N	extract, WC, 70
3232	Margyricarpus setosus	\N	1	\N	70D
3233	Marrubium vulgare	\N	1	\N	D-70
3234	Marshallia obovata	B	\N	\N	70
3235	Matelea obliquus	\N	1	\N	70 GA-3
3236	Matelea obliquus	B	\N	\N	70D GA-3
3237	Mathiola bicornis 	\N	\N	2	70
3238	Mathiola fruticulosa 	\N	\N	2	70D-40
3239	Mathiola incana	\N	1	\N	70L
3240	Mathiola incana	B	\N	\N	70L
3241	Matricaria maritima	\N	1	\N	70L
3242	Matricaria recutita	\N	1	\N	D-70
3243	Matucana formosa	\N	1c	\N	70 GA-3
3244	Matucana haynei	\N	1c	\N	70 GA-3
3245	Matucana roseo-alba	\N	1c	\N	70 GA-3
3246	Maurandia (Asarina) petrophilia	\N	1	\N	70L
3247	Mazus reptans	\N	\N	2	70
3248	Meconopsis aculeata	B	\N	\N	70L
3249	Meconopsis betonicifolia	\N	1	\N	70D
3250	Meconopsis betonicifolia	B	\N	\N	70D
3251	Meconopsis betonicifolia alba	B	\N	\N	70D
3252	Meconopsis betonicifolia pratensis	B	\N	\N	70D
3253	Meconopsis cambrica	B	\N	\N	70-40-70
3254	Meconopsis paniculata	B	\N	\N	70
3255	Medeola virginiana	\N	\N	2	no germ
3256	Medicago achinus	\N	1	\N	70D
3257	Melaleuca diosmafolia	\N	1	\N	70D
3258	Melaleuca diosmafolia	B	\N	\N	70 GA-3
3259	Melaleuca diosmafolia 	\N	\N	2	70D
3260	Melaleuca huegellii	\N	\N	2	comment
3261	Melaleuca huegeri	\N	1	\N	D-70
3262	Melaleuca huegeri	B	\N	\N	70D
3263	Melampodium cinereum	B	\N	\N	70
3264	Melampyrum lineare	B	\N	\N	70-40
3265	Melandrium sachilinense	B	\N	\N	70
3266	Melanoselinum decipiens	\N	\N	2	70
3267	Melasphaerula graminea	B	\N	\N	70-40
3268	Melia azederach	\N	\N	2	WC 7 d, 70L-40-70L
3269	Melia azederach	\N	1	\N	70 GA-3 40-70
3270	Melica ciliata	Bg	\N	\N	D-70
3271	Melilotus alba	\N	\N	2	comment
3272	Melilotus alba	\N	1	\N	puncture, 70D
3273	Melilotus alba	B	\N	\N	puncture, 70
3274	Melissa officinalis	\N	\N	2	70L
3275	Melissa officinalis	\N	1	\N	70L
3276	Melocactus amoenus	\N	1c	\N	no germ
3277	Melocactus bahiensis	\N	1c	\N	no germ
3278	Melocactus concinnus	\N	1c	\N	70 GA-3
3279	Melocactus loboguereroi	\N	1c	\N	70 GA-3
3280	Melocactus oaxacensis	\N	1c	\N	70 GA-3
3281	Melospermum peleponnesius	\N	\N	2	70D-40-70D 
3282	Melospermum peleponnesius	\N	1	\N	70D-40-70D
3283	Menodora scabra	B	\N	\N	70
3284	Mentha microphylla	\N	1	\N	70L
3285	Mentha microphylla	B	\N	\N	70L
3286	Mentha requenii	\N	\N	2	70L
3287	Mentha sp.	\N	1	\N	70 GA-3
3288	Mentha spicata	\N	1	\N	70L
3289	Mentha spicata	B	\N	\N	70L
3290	Mentzelia (Bartonia) aurea	\N	1	\N	70D
3291	Mentzelia aurea	\N	\N	2	70D-40
3292	Mentzelia chrysantha	B	\N	\N	70D
3293	Mentzelia decapetala	B	\N	\N	40
3294	Mentzelia lindleyi	\N	\N	2	rotted
3295	Mentzelia nuda	B	\N	\N	40
3296	Menyanthes trifoliata	\N	1	\N	70L
3297	Menziesia pillosa	\N	1	\N	70L
3298	Merendera pyrenaica	B	\N	\N	70-40
3299	Merendera sobolifera	B	\N	\N	70-40
3300	Merendera trigyna	B	\N	\N	70-40
3301	Merremia tuberosa	\N	1	\N	70D
3302	Merremia tuberosa 	\N	\N	2	70D
3303	Mertensia alpina	B	\N	\N	70L
3304	Mertensia bakeri	B	\N	\N	40-70
3305	Mertensia cana	B	\N	\N	70L
3306	Mertensia lanceolata	B	\N	\N	70
3307	Mertensia maritima	\N	\N	2	70
3308	Mertensia maritima	\N	1	\N	extract, 70L
3309	Mertensia virginica	B	\N	\N	70-40
3310	Mesembryanthemum nodiflorum	\N	\N	2	32-75 OS
3311	Mesperula graminae roscoae	\N	\N	2	70D-40
3312	Meum athamanticum	B	\N	\N	40
3313	Michauxia tchiharchewii	B	\N	\N	70D GA-3
3314	Micranthocereus auri-azureus	\N	1c	\N	no germ
3315	Micranthocereus strekereii	\N	1c	\N	70 GA-3
3316	Micromeria juliana	\N	\N	2	70L
3317	Micromeria juliana	\N	1	\N	70L
3318	Micromeria thymifolia	\N	1	\N	70 GA-3
3319	Micromeria thymifolia 	\N	\N	2	40-70L
3320	Mila fortalezensis	\N	1c	\N	70 GA-3
3321	Mila pugionofera	\N	1c	\N	70 GA-3
3322	Milligania densiflora	\N	\N	2	70
3323	Mimosa pudica	B	\N	\N	comment
3324	Mimulus (calypso  hybrids)	\N	\N	2	70D
3325	Mimulus (calypso hybrids)	\N	1	\N	70
3326	Mimulus 'andean nymph	B	\N	\N	40
3327	Mimulus 'calypso' (hybrids)	B	\N	\N	70
3328	Mimulus cardinalis	B	\N	\N	70
3329	Mimulus cusickii	\N	\N	2	70L-40-70L
3330	Mimulus guttatus	B	\N	\N	70
3331	Mimulus lewisii	B	\N	\N	70
3332	Mimulus luteus	B	\N	\N	70
3333	Mimulus primuloides	B	\N	\N	70L
3334	Mimulus puniceus	B	\N	\N	70
3335	Mimulus ringens	\N	1	\N	70L
3336	Mimulus ringens	B	\N	\N	70D GA-3
3337	Mimulus rupicola 	\N	1	\N	70L
3338	Mina (Quamoclit) lobata	\N	1	\N	70
3339	Minuartia biflora	B	\N	\N	40
3340	Minuartia laricifolia	B	\N	\N	70
3341	Minuartia recurva	B	\N	\N	70
3342	Minuartia sp.	\N	1	\N	70
3343	Mirabilis jalapa	\N	\N	2	70
3344	Mirabilis longiflora	\N	\N	2	70D
3345	Mirabilis multiflora	\N	1	\N	70D
3346	Miscanthus (hybrids)	Bg	\N	\N	D-70
3347	Misopates oronticum	\N	1	\N	70L
3348	Misopates oronticum 	\N	\N	2	70L
3349	Mitchella repens	B	\N	\N	40-70-40-70-40-70-40-70
3350	Mitella diphylla	B	\N	\N	70-40
3351	Modiola caroliniana	\N	1	\N	70L
3352	Moehringia muscosa	\N	\N	2	empty
3353	Moltkia petraea	\N	1	\N	40-70D
3354	Moluccella laevis	\N	1	\N	70D
3355	Moluccella laevis	\N	\N	2	70D
3356	Momordica rostrata	\N	\N	2	70L
3357	Momordica rostrata	\N	1	\N	70L
3358	Monarda citriodora	\N	\N	2	70D
3359	Monarda citriodora	B	\N	\N	70
3360	Monarda didyma	B	\N	\N	70L
3361	Monarda fistulosa	\N	\N	2	DS 4 y = dead
3362	Monarda fistulosa	\N	1	\N	70L
3363	Monarda fistulosa	B	\N	\N	70L
3364	Monarda menthifolia	\N	1	\N	70
3365	Monarda menthifolia 	\N	\N	2	70
3366	Monarda punctata	\N	\N	2	DS 4 y = dead
3367	Monarda punctata	\N	1	\N	70L
3368	Monardella odoratissima	B	\N	\N	70L
3369	Montbretia securigera	\N	\N	2	70L
3370	Montia (Claytonia) sibirica	\N	1	\N	70L
3371	Montia sibirica	\N	\N	2	DS 2 y = dead
3372	Montiopsis andicola (Calandrinia tricolor)	\N	\N	2	dead 
3373	Moraea huttonii	B	\N	\N	40-70
3374	Moraea sp	\N	1	\N	70L
3375	Morawetzia sericata	\N	1c	\N	70 GA-3
3376	Moricanda arvensis	\N	\N	2	40
3377	Moricanda arvensis	\N	1	\N	70
3378	Morina longifolia	\N	\N	2	70
3379	Morina longifolia	\N	1	\N	70
3380	Morocarpus foliosus	B	\N	\N	70
3381	Morus alba	B	\N	\N	WC 4 d, 70
3382	Mosla punctalata	\N	\N	2	rotted
3383	Musa punctata	\N	\N	2	70
3384	Musa velutina	\N	1	\N	puncture, 70
3385	Musa violacea	\N	1	\N	puncture, 70
3386	Muscari botryoides	B	\N	\N	D-70-40
3387	Muscarimia ambrosiacum	\N	\N	2	70D
3388	Muscarimia macrocarpum	\N	\N	2	70D-40
3389	Musella lasiocarpa	\N	\N	2	no germ
3390	Mussaenda roxburghii	B	\N	\N	70L
3391	Musschia aurea	\N	\N	2	70
3392	Mutisia latifolia	\N	\N	2	40
3393	Mutisia spinosa	B	\N	\N	70 4 w, 40
3394	Mutisia subulata	B	\N	\N	40-70
3395	Myoporum debile	\N	1	\N	70D
3396	Myoporum sp.	\N	\N	2	comment
3397	Myositidium hortensia	\N	\N	2	40-70D
3398	Myosotis arvensis	\N	\N	2	50-75
3399	Myosotis asiatica	B	\N	\N	70
3400	Myosotis sylvatica	B	\N	\N	70
3401	Myrica caroliniensis	B	\N	\N	40-70
3402	Myrica gale	\N	1	\N	70L
3403	Myrica pennsylvanica	B	\N	\N	dewax, 70-40
3404	Myrrhis odorata	B	\N	\N	OT
3405	Myrsine nummularia	\N	1	\N	70-40-70
3406	Myrtillocactus geometrizans	\N	1c	\N	70 GA-3
3407	Myrtus communis 	\N	1	\N	70D
3408	Nama hispidum	\N	1	\N	70D
3409	Nama rothrockii	\N	1	\N	70 GA-3 40
3410	Nandina domestica	\N	1	\N	70L-70D
3411	Nandina domestica	B	\N	\N	rotted
3412	Narcissus (hybrids)	B	\N	\N	70-40
3413	Nardophyllum obtusifolium	\N	\N	2	rotted
3414	Narthecium californicum	\N	1	\N	40-70D
3415	Narthecium ossifragum	\N	1	\N	70L-40-70L
3416	Nasturtium officinale	B	\N	\N	D-70
3417	Nebelia paleacea	\N	\N	2	chaff
3418	Nectaroscordum siculum	\N	\N	2	70D-40
3419	Nectaroscordum siculum	\N	1	\N	dead
3420	Nelumbo lutea	B	\N	\N	puncture, submerge, 70D
3421	Nemastylis acuta	\N	1	\N	comment
3422	Nemastylis acuta	B	\N	\N	comment
3423	Nemastylis pringlei	B	\N	\N	40-70-40-70
3424	Nemastylis tenuis	B	\N	\N	70
3425	Nemesia sp.	\N	\N	2	70L
3426	Nemesia sp.	\N	1	\N	70L
3427	Nemesia strumosa	\N	\N	2	70
3428	Nemesia strumosa	\N	1	\N	70
3429	Nemesia umbonata	\N	\N	2	70
3430	Nemesia umbonata	\N	1	\N	70
3431	Nemopanthus mucronatus	\N	1	\N	(70-40-70-40) x 2 + 70
3432	Nemophila maculata	B	\N	\N	70
3433	Nemophila menziesii	\N	\N	2	70D
3434	Nemophila menziesii	B	\N	\N	70
3435	Neobessya missouriensis	\N	1c	\N	WC, 70
3436	Neobessya missouriensis	B	\N	\N	WC, 70
3437	Neobuxbaumia tetetzo	\N	1c	\N	70 GA-3
3438	Neocardenassia herzogiana	\N	1c	\N	no germ
3439	Neoevansia diguetii	\N	1c	\N	70 GA-3
3440	Neolloydia conoidea	\N	1c	\N	70 GA-3
3441	Neoporteria chilensis albidiflora	\N	1c	\N	70 GA-3
3442	Neoporteria coimasensis	\N	1c	\N	70 GA-3
3443	Neoporteria curvispina kesselringianus	\N	1c	\N	70 GA-3
3444	Neoporteria engleri	\N	\N	2c	70 GA-3
3445	Neoporteria napina miris	\N	\N	2c	70 GA-3
3446	Neoporteria sp.	\N	1c	\N	70 GA-3
3447	Neoporteria villosa	\N	\N	2c	70 GA-3
3448	Neoraimondia roseiflora	\N	1c	\N	70 GA-3
3449	Neowerdermannia worwerkii	\N	1c	\N	no germ
3450	Nepeta cataria	B	\N	\N	70L
3451	Nepeta floccosa	B	\N	\N	40-70
3452	Nepeta glutinosa	B	\N	\N	40
3453	Nepeta grandiflora	\N	\N	2	70D
3454	Nepeta nepetalla	\N	1	\N	70L
3455	Nepeta siasessois	\N	\N	2	70L
3456	Nepeta sp.	\N	\N	2	DS 2 y = dead
3457	Nepeta subsessilis	\N	\N	2	DS 3 y = dead
3458	Nerium oleander	\N	1	\N	70D
3459	Nerium oleander	B	\N	\N	70
3460	Nicandra physalodes	\N	\N	2	comment
3461	Nicandra physalodes	\N	1	\N	70L
3462	Nicotiana affinis	\N	\N	2	70L
3463	Nicotiana langsdorfii	\N	1	\N	D-70
3464	Nicotiana sylvestris	\N	1	\N	D-70L
3465	Nicotiana tabacum	\N	\N	2	70
3466	Nicotiana trigonophylla	\N	1	\N	D-70
3467	Nierembergia caerulea	\N	\N	2	60-85
3468	Nigella damascena	\N	\N	2	70D
3469	Nigella damascena	\N	1	\N	70D
3470	Nigella damascena (hybrids)	\N	\N	2	70D
3471	Nigella hispanica	\N	\N	2	70L
3472	Nigella hispanica	\N	1	\N	70L
3473	Nigella orientalis	\N	\N	2	70L
3474	Nigella orientalis	\N	1	\N	70
3475	Nivenia stokoei	\N	\N	2	70D-40-70D
3476	Nolana paradoxa	\N	\N	2	70D
3477	Nolana paradoxa	\N	1	\N	70D
3478	Nolana sp.	\N	\N	2	70D
3479	Nolana sp.	\N	1	\N	70L
3480	Nolina parryi	\N	\N	2	70D-40
3481	Nolina parryi	\N	1	\N	70D-40
3482	Nomocharis sp.	\N	\N	2	70D
3483	Nomocharis sp.	B	\N	\N	70
3484	Notholirion bulbiferum	\N	1	\N	70D
3485	Nothoscordum bonariensis	\N	\N	2	70D-40-70D
3486	Nothoscordum inodorum	\N	\N	2	70D-40
3487	Nothoscordum nerinifolium	\N	\N	2	70D
3488	Notothlaspi rosulatum	\N	1	\N	70D
3489	Notothlaspi rosulatum	B	\N	\N	70D
3490	Nototocactus agnetae	\N	1c	\N	70 GA-3
3491	Nototocactus ampliocostatus	\N	1c	\N	70
3492	Nototocactus bueneckeri	\N	1c	\N	no germ
3493	Nototocactus purpureus meugelianus	\N	1c	\N	70 GA-3
3494	Nototocactus rutilans	\N	1c	\N	no germ
3495	Nyctanthes arbor-tristis	\N	1	\N	70L
3496	Nymphaea tetragona	B	\N	\N	40-70
3497	Nyssa sinensis	B	\N	\N	OT
3498	Nyssa sylvatica	\N	1	\N	40-70
3499	Nyssa sylvatica	\N	\N	2	OT
3500	Nyssa sylvatica	B	\N	\N	40-70
3501	Obregonia denegrii	\N	1c	\N	70 GA-3
3502	Ochna serrulata	\N	1	\N	no germ
3503	Ochna sp.	\N	\N	2	comment
3504	Ocimum basilicum	B	\N	\N	70
3505	Odontostomum hartwegii	\N	\N	2	70D
3506	Oenothera albicaulis	B	\N	\N	70
3507	Oenothera argillicola	\N	1	\N	70D
3508	Oenothera argillicola	B	\N	\N	70L
3509	Oenothera biennis	\N	1	\N	70L
3510	Oenothera biennis	B	\N	\N	70L
3511	Oenothera brachycarpa	B	\N	\N	40
3512	Oenothera caespitosa	\N	1	\N	70L
3513	Oenothera caespitosa	B	\N	\N	70L
3514	Oenothera cheiranthifolia	B	\N	\N	70
3515	Oenothera cupressus	B	\N	\N	70
3516	Oenothera fendleri	B	\N	\N	70
3517	Oenothera glauca	B	\N	\N	70
3518	Oenothera pallida	B	\N	\N	70
3519	Oenothera serrulata	B	\N	\N	70
3520	Oenothera speciosa	\N	1	\N	70D
3521	Oenothera speciosa	B	\N	\N	70
3522	Oenothera speciosa 	\N	\N	2	70D
3523	Oenothera triloba	B	\N	\N	70
3524	Oenothera xylocarpa	B	\N	\N	70D
3525	Olea cuspidata	\N	\N	2	40-70D-40
3526	Olearia sp.	\N	1	\N	chaff
3527	Olsynium chrysochromum	\N	\N	2	no germ
3528	Omalotheca (Gnaphalium) supina	\N	1	\N	70L
3529	Omalotheca norvegica	\N	\N	2	70D
3530	Omalotheca norvegica	\N	1	\N	70
3531	Omalotheca supina	\N	\N	2	70D
3532	Omphalodes cappadocica   	\N	\N	2	70D
3533	Omphalodes linifolia	\N	\N	2	70D
3534	Omphalodes linifolia	\N	1	\N	70
3535	Omphalodes linifolia alba	\N	\N	2	70D
3536	Omphalodes linifolia alba	\N	1	\N	70
3537	Omphalodes luciliae	\N	1	\N	70
3538	Omphalodes luciliae alba	\N	\N	2	70D
3539	Omphalodes sp.	\N	1	\N	70
3540	Ononis natrix	\N	1	\N	puncture, 70
3541	Ononis rotundifolia	\N	\N	2	puncture, 70D
3542	Onopordum acanthum	\N	\N	2	70L
3543	Onopordum nervosa	\N	1	\N	70L
3544	Onopordum sylvestris	\N	1	\N	70L
3545	Onosma armenum	B	\N	\N	40
3546	Onosma nanum	B	\N	\N	70
3547	Onosma stellulata	B	\N	\N	40
3548	Onosma taurica	B	\N	\N	40-70
3549	Onosmodium molle	\N	\N	2	70 GA-3 -40
3550	Ophiopogon japonicus	B	\N	\N	70D
3551	Opithandra sp.	B	\N	\N	70
3552	Opuntia aurea	B	\N	\N	70
3553	Opuntia basilaris	\N	\N	2c	70 GA-3
3554	Opuntia basilaris	\N	1c	\N	70 GA-3
3555	Opuntia basilaris v. woodburyi	\N	\N	2c	70 GA-3
3556	Opuntia basilaris v. woodburyii	\N	1c	\N	70 GA-3
3557	Opuntia chisosensis	\N	1c	\N	no germ
3558	Opuntia clavata	\N	1c	\N	70 GA-3
3559	Opuntia cyclodes	\N	1c	\N	no germ
3560	Opuntia engelmannii	\N	1c	\N	no germ
3561	Opuntia erinacea	\N	1c	\N	70 GA-3
3562	Opuntia erinacea ursina	\N	1c	\N	70
3563	Opuntia fragilis	\N	1c	\N	70
3564	Opuntia gilvescens	\N	1c	\N	no germ
3565	Opuntia gregoriana	\N	1c	\N	no germ
3566	Opuntia humifusa	\N	\N	2c	comment
3567	Opuntia humifusa	\N	1c	\N	WC 7 d, 70 GA-3
3568	Opuntia humifusa	B	\N	\N	70
3569	Opuntia imbricata	\N	1c	\N	70 GA-3
3570	Opuntia imbricata	B	\N	\N	70
3571	Opuntia joconosiele	\N	1c	\N	70 GA-3
3572	Opuntia leptocaulis	B	\N	\N	70
3573	Opuntia macrocentra	\N	1c	\N	no germ
3574	Opuntia macrorhiza	\N	\N	2c	70 GA-3
3575	Opuntia nicholii	\N	1c	\N	70-40-70
3576	Opuntia phaecantha	\N	\N	2c	comment
3577	Opuntia phaecantha	\N	1c	\N	40-70-40-70
3578	Opuntia phaecantha	B	\N	\N	70
3579	Opuntia phaecantha 'oklahoma'	\N	1c	\N	no germ
3580	Opuntia polycantha	B	\N	\N	70
3581	Opuntia polycantha (hybrids)	\N	1c	\N	40-70
3582	Opuntia polycantha 'crystal tide'	\N	1c	\N	70 GA-3
3583	Opuntia polycantha hystricina	\N	1c	\N	70 GA-3
3584	Opuntia pottsii	\N	1c	\N	70D-40-70D-70 GA-3 40-70
3585	Opuntia rhodanthe	B	\N	\N	70
3586	Opuntia rutila	B	\N	\N	70
3587	Opuntia sanguinicula	\N	1c	\N	no germ
3588	Opuntia tuna	\N	1c	\N	70 GA-3
3589	Opuntia tuna	B	\N	\N	WC 7 d, 70D GA-3
3590	Opuntia woodsii	\N	1c	\N	no germ
3591	Oreocereus celsianus	\N	1c	\N	70 GA-3
3592	Oreocereus hendriksenianus	\N	1c	\N	70 GA-3
3593	Origanum vulgare	\N	\N	2	50-80
3594	Origanum vulgare	B	\N	\N	70
3595	Ornithogalum caudatum	B	\N	\N	70
3596	Ornithogalum dubium	B	\N	\N	comment
3597	Ornithogalum maculatum	B	\N	\N	comment
3598	Ornithogalum nutans	B	\N	\N	40
3599	Ornithogalum pyrenaicum	\N	1	\N	40
3600	Ornithogalum pyrenaicum	B	\N	\N	40
3601	Ornithogalum umbellatum	B	\N	\N	40
3602	Orobanche minor	\N	1	\N	comment
3603	Orontium aquaticum	B	\N	\N	70
3604	Orostachys iwarenge	\N	1	\N	70
3605	Orthrosanthus chimboracensis	\N	\N	2	70L
3606	Orthrosanthus chimboracensis v. centroamericanus	\N	1	\N	70L
3607	Orychophragmus violacens	\N	\N	2	70
3608	Orychophragmus violacens	\N	1	\N	70L
3609	Osbeckia stellata	B	\N	\N	70L
3610	Osmaronia cerasiformis	\N	\N	2	rotted
3611	Ostrowskia magnifica	B	\N	\N	40
3612	Ostrya virginiana	B	\N	\N	70D GA-3 40
3613	Ourisia macrophylla	B	\N	\N	70L
3614	Ourisia polyantha	\N	\N	2	70L
3615	Oxalis magellanica	B	\N	\N	40
3616	Oxalis sp.	B	\N	\N	70
3617	Oxydendrum arborescens	B	\N	\N	70L
3618	Oxypetalum caeruleum	\N	1	\N	70
3619	Oxyria digyna	\N	1	\N	70
3620	Oxytropis besseyi	B	\N	\N	70
3621	Oxytropis cachmerica	B	\N	\N	70
3622	Oxytropis chankaensis	B	\N	\N	OT
3623	Oxytropis chiliophylla	\N	1	\N	puncture, 70D
3624	Oxytropis chiliophylla	B	\N	\N	puncture, 70
3625	Oxytropis chiliophylla 	\N	\N	2	puncture, 70
3626	Oxytropis halleri	B	\N	\N	OT
3627	Oxytropis humifusa	B	\N	\N	40-70
3628	Oxytropis lamberti	B	\N	\N	70-40
3629	Oxytropis megalantha	B	\N	\N	OT
3630	Oxytropis multiceps	B	\N	\N	70-40
3631	Oxytropis sericea	B	\N	\N	70
3632	Oxytropis shokanbetshensis	B	\N	\N	OT
3633	Oxytropis splendens	B	\N	\N	puncture, 70
3634	Oxytropis viscida	B	\N	\N	40
3635	Oxytropis williamsii	B	\N	\N	70
3636	Pachycereus pectin-aboriginum	\N	1c	\N	70 GA-3
3637	Pachystegia insignis minor	\N	\N	2	comment
3638	Pachystegia insignis minor	\N	1	\N	70D
3639	Pachystegia insignis minor	B	\N	\N	40
3640	Paeonea anomala	B	\N	\N	70-40-70
3641	Paeonea broteri	B	\N	\N	70-40
3642	Paeonea brownii	B	\N	\N	40
3643	Paeonea cambessedi	B	\N	\N	70-40
3644	Paeonea emodi	B	\N	\N	70-40-70
3645	Paeonea lutea	B	\N	\N	70-40-70
3646	Paeonea mlkosewetschii	B	\N	\N	70-40-70
3647	Paeonea obovata	B	\N	\N	70-40-70
3648	Paeonea officinalis	B	\N	\N	70-40-70
3649	Paeonea suffruticosa	B	\N	\N	70-40-70
3650	Paeonea vernalis	B	\N	\N	70-40-70-40
3651	Panax quinquifolium	B	\N	\N	40-70-40-70-OT
3652	Panax trifolium	B	\N	\N	no germ
3653	Pancratium maritimum	\N	\N	2	70
3654	Pancratium maritimum	\N	1	\N	70D
3655	Pandorea jasminoides	\N	\N	2	70D
3656	Pandorea jasminoides	\N	1	\N	70
3657	Panicum violaceum	Bg	\N	\N	D-70
3658	Panicum virgatum	Bg	\N	\N	D-70
3659	Paonea broteri	\N	1	\N	70-40-70-40-70-40-70-40-70
3660	Paonea suffruticosa	\N	\N	2	40-70D
3661	Paonea suffruticosa	\N	1	\N	70D-40-70D
3662	Papaver alboroseum	B	\N	\N	70
3663	Papaver amenum	\N	1	\N	70 GA-3
3664	Papaver atlanticum	B	\N	\N	70
3665	Papaver degenii	\N	\N	2	70D
3666	Papaver degenii	\N	1	\N	70
3667	Papaver ecoanense	\N	\N	2	70D
3668	Papaver ecoanense	\N	1	\N	70L
3669	Papaver faurei	\N	1	\N	70L
3670	Papaver julicum	\N	1	\N	70 GA-3
3671	Papaver kluantense	\N	\N	2	empty
3672	Papaver kluantense	\N	1	\N	no germ
3673	Papaver lapponicum	B	\N	\N	40-70
3674	Papaver miyabeanum	B	\N	\N	70
3675	Papaver nudicaule	\N	\N	2	50-85
3676	Papaver nudicaule	B	\N	\N	70
3677	Papaver orientale	B	\N	\N	70
3678	Papaver pilosum	\N	1	\N	70 GA-3
3679	Papaver pyrenaicum v. rhaeticum	\N	1	\N	70 GA-3
3680	Papaver radicatum	\N	1	\N	70 GA-3
3681	Papaver ruprifagum	B	\N	\N	D-70
3682	Papaver sendtueri	\N	\N	2	70L
3683	Papaver somniferum	\N	1	\N	70L
3684	Papaver somniferum	B	\N	\N	D-70
3685	Papaver tatrae	B	\N	\N	70
3686	Papaver tatricum	B	\N	\N	OT
3687	Paradisea liliastrum	\N	1	\N	OT
3688	Paradisea liliastrum	B	\N	\N	OT
3689	Paradisea racemosum	\N	1	\N	comment
3690	Parahebe linifolia	\N	1	\N	70L
3691	Paraquilegia grandiflora	B	\N	\N	OT
3692	Paris quadrifolia	B	\N	\N	70-40-70
3693	Parnassia fimbriata	B	\N	\N	40-70L-40-70L
3694	Parnassia glauca	B	\N	\N	40-70L
3695	Parnassia laxmannii	B	\N	\N	70
3696	Parnassia palustris	\N	1	\N	70 GA-3
3697	Parnassia palustris	B	\N	\N	70L
3698	Parochetus communis	\N	\N	2	puncture, 70D
3699	Parodia amblayensis	\N	1c	\N	70 GA-3
3700	Parodia aureispina	\N	1c	\N	70 GA-3
3701	Parodia cabracoraliensis	\N	1c	\N	70 GA-3
3702	Parodia comarapana	\N	1c	\N	70 GA-3
3703	Parodia comarapana 	\N	\N	2c	70 GA-3
3704	Parodia laui	\N	1c	\N	70 GA-3
3705	Parodia mazanensis	\N	1c	\N	no germ
3706	Parodia microthele	\N	\N	2c	OS 32-75 GA-3 or GA-4
3707	Parodia microthele	\N	1c	\N	70 GA-3
3708	Parodia minuta	\N	1c	\N	70 GA-3
3709	Paronychia sp.	B	\N	\N	70
3710	Parrotia persica	B	\N	\N	40
3711	Parrotiopsis jacquemontiana	B	\N	\N	70-40-70-40-70
3712	Parrya menziesii	B	\N	\N	70-40-70
3713	Parrya schugnana	B	\N	\N	70-40-70
3714	Parsonia capsularis	\N	1	\N	70D
3715	Parthenocissus quinquifolia	B	\N	\N	WC, 70-40-70
3716	Parthenocissus tricuspidata	B	\N	\N	WC 7 d, 70
3717	Passiflora antiquiensis	\N	1	\N	125 4 d, 70
3718	Passiflora cinnabarina	\N	1	\N	no germ
3719	Passiflora coccinea	\N	1	\N	no germ
3720	Passiflora edulis	\N	1	\N	70-40-70
3721	Passiflora edulis	B	\N	\N	70-40-70
3722	Passiflora incarnata	B	\N	\N	40-70
3723	Passiflora malformis	\N	1	\N	125 4 d, 70
3724	Passiflora mollissima	\N	1	\N	125 4 d, 70
3725	Passiflora vitafolia	\N	1	\N	125 4 d, 70
3726	Patersonia sp.	\N	\N	2	empty
3727	Patrinia gibbosa	\N	1	\N	70L
3728	Patrinia scabiosifolia	\N	1	\N	70L
3729	Paulownia tomentosum	\N	1	\N	comment
3730	Paulownia tomentosum	B	\N	\N	70L
3731	Pavonia lasiopetala	\N	\N	2	extract from outer coat, puncture, 70D
3732	Pedicularis rainierensis	\N	1	\N	70 GA-3
3733	Pedicularis rainierensis	B	\N	\N	70D GA-3
3734	Pediocactus peelesianaus	\N	1c	\N	70 GA-3
3735	Pediocactus simpsoni	\N	1c	\N	70 GA-3
3736	Pediocactus simpsoni	B	\N	\N	40
3737	Peganum harmela	\N	1	\N	D-70
3738	Pelargonium (hybrids)	\N	\N	2	scarify, 70D
3739	Pelecyphora aselliformis	\N	1c	\N	70 GA-3
3740	Pelkovia sp.	B	\N	\N	70D
3741	Peltiphyllum peltatum	\N	1	\N	70L
3742	Peltoboykinia tellimoides	B	\N	\N	40-70L
3743	Peniocereus greggii transmontanus	\N	1c	\N	70 GA-3
3744	Pennisetum alopecuroides	Bg	\N	\N	D-70
3745	Pennisetum villosum	Bg	\N	\N	D-70
3746	Penstemon acaulis	B	\N	\N	70
3747	Penstemon acuminatus	B	\N	\N	40-70
3748	Penstemon alpinus	B	\N	\N	70 GA-3
3749	Penstemon ambiguus	\N	1	\N	70D
3750	Penstemon ambiguus	B	\N	\N	70
3751	Penstemon angustifolius	B	\N	\N	70-40-70
3752	Penstemon arenicola	B	\N	\N	40-70
3753	Penstemon barbatus	B	\N	\N	70
3754	Penstemon brevicaulis	B	\N	\N	70-40-70
3755	Penstemon caerulea	B	\N	\N	70
3756	Penstemon caespitosus desertipictus	B	\N	\N	70 GA-3
3757	Penstemon centranthifolius	\N	1	\N	70D
3758	Penstemon cleburnei	B	\N	\N	40-70
3759	Penstemon cobaea	\N	\N	2	70 GA-3
3760	Penstemon cobaea	B	\N	\N	70
3761	Penstemon corymbosus	\N	1	\N	70L
3762	Penstemon crandalli	B	\N	\N	70-40
3763	Penstemon cyathophorus	\N	\N	2	70 GA-3
3764	Penstemon davidsonii	B	\N	\N	70
3765	Penstemon digitalis	B	\N	\N	D-70L
3766	Penstemon dolius	B	\N	\N	40
3767	Penstemon duchesnis	B	\N	\N	40
3768	Penstemon duchesuensis	\N	\N	2	70D-40
3769	Penstemon duchesuensis	\N	1	\N	40-70D
3770	Penstemon eatoni	B	\N	\N	40
3771	Penstemon eriantherus	B	\N	\N	40-70
3772	Penstemon flowersii	\N	\N	2	70D-40
3773	Penstemon flowersii	\N	1	\N	40-70D
3774	Penstemon flowersii	B	\N	\N	40
3775	Penstemon francisci-pennellii	B	\N	\N	70-40
3776	Penstemon frutescens	B	\N	\N	70L
3777	Penstemon gairdneri ssp. gairdneri	B	\N	\N	40
3778	Penstemon gairdneri ssp. oreganus	B	\N	\N	40
3779	Penstemon glaber	B	\N	\N	70
3780	Penstemon glabrescens	B	\N	\N	40
3781	Penstemon globosus	B	\N	\N	70L
3782	Penstemon goodrichii	B	\N	\N	40
3783	Penstemon gormani	B	\N	\N	70
3784	Penstemon gracilis	B	\N	\N	OT
3785	Penstemon grandiflora	B	\N	\N	D-40
3786	Penstemon hallii	B	\N	\N	70
3787	Penstemon harbouri	\N	\N	2	70L
3788	Penstemon harbouri	\N	1	\N	70L
3789	Penstemon heterophyllus	\N	\N	2	40
3790	Penstemon heterophyllus	\N	1	\N	70L
3791	Penstemon hirsutus	B	\N	\N	40-70L
3792	Penstemon hirsutus pygmaea	B	\N	\N	70L
3793	Penstemon humilis	B	\N	\N	40-70
3794	Penstemon hyacinthus	B	\N	\N	70
3795	Penstemon jamesii	B	\N	\N	70
3796	Penstemon janishae	B	\N	\N	40
3797	Penstemon johnsoniae	B	\N	\N	70
3798	Penstemon kunthii	B	\N	\N	40
3799	Penstemon laricifolius	B	\N	\N	40-70
3800	Penstemon leiophylla	B	\N	\N	OT
3801	Penstemon lemhiensis	B	\N	\N	40
3802	Penstemon lentus	B	\N	\N	40
3803	Penstemon linearioides	B	\N	\N	40
3804	Penstemon lyallii	\N	\N	2	70L
3805	Penstemon mensarum	\N	\N	2	70 GA-3
3806	Penstemon moffatii	B	\N	\N	40
3807	Penstemon monoensis	\N	\N	2	70L-40
3808	Penstemon monoensis	\N	1	\N	40
3809	Penstemon montanus	B	\N	\N	40-70
3810	Penstemon montanus ssp. idahoensis	\N	\N	2	OT
3811	Penstemon mucronatus	B	\N	\N	40
3812	Penstemon nitidus	B	\N	\N	D-40
3813	Penstemon ophianthus	\N	1	\N	70D
3814	Penstemon ophianthus	B	\N	\N	70
3815	Penstemon osterhouti	B	\N	\N	70
3816	Penstemon ovatus	B	\N	\N	70
3817	Penstemon pachyphyllus	\N	1	\N	70 GA-3
3818	Penstemon pachyphyllus	B	\N	\N	70D GA-3
3819	Penstemon palmeri	B	\N	\N	OT
3820	Penstemon paysoniorum	B	\N	\N	40-70
3821	Penstemon peckii	B	\N	\N	OT
3822	Penstemon pinifolius	\N	1	\N	70
3823	Penstemon pinifolius	B	\N	\N	OT
3824	Penstemon retroceus	\N	\N	2	40
3825	Penstemon retroceus	\N	1	\N	40
3826	Penstemon rupicola	B	\N	\N	70
3827	Penstemon scapoides	\N	\N	2	40-70
3828	Penstemon scapoides	\N	1	\N	40-70D
3829	Penstemon 'scarlet queen'	\N	\N	2	70D
3830	Penstemon 'scarlet queen'	B	\N	\N	70
3831	Penstemon scouleri	B	\N	\N	70
3832	Penstemon secundiflorus	B	\N	\N	70 GA-3
3833	Penstemon serrulatus	B	\N	\N	OT
3834	Penstemon smallii	B	\N	\N	40-70L
3835	Penstemon sp.	B	\N	\N	40
3836	Penstemon speciosus ssp. kennedyi	B	\N	\N	70D GA-3
3837	Penstemon teucrioides	B	\N	\N	70
3838	Penstemon tolmei	B	\N	\N	70
3839	Penstemon uintahensis	\N	\N	2	OT
3840	Penstemon uintahensis	B	\N	\N	40-70D
3841	Penstemon utahensis	B	\N	\N	40
3842	Penstemon virens	B	\N	\N	D-40-70
3843	Penstemon whippleanus	B	\N	\N	70
3844	Penstemon wilcoxii	B	\N	\N	40
3845	Penstemon wizlizenii	B	\N	\N	40
3846	Perilla frutescens	\N	\N	2	55-75
3847	Periploca graeca	B	\N	\N	70-40-70
3848	Pernettya macrostigma	\N	\N	2	comment
3849	Pernettya macrostigma	\N	1	\N	70L
3850	Pernettya macrostigma	B	\N	\N	70L
3851	Perovskia abrotanoides	\N	1	\N	70D
3852	Perovskia atriplicifolia	\N	\N	2	70D
3853	Perovskia atriplicifolia 	\N	1	\N	70
3854	Persea americana	B	\N	\N	WC, suspend base in aqua
3855	Petalonyx nitidus	\N	1	\N	40-70D
3856	Petrocoptis glaucifolia	B	\N	\N	70
3857	Petrocoptis hispanica	B	\N	\N	70
3858	Petrocoptis pyrenaica	B	\N	\N	70
3859	Petrophytum caespitosum	B	\N	\N	70
3860	Petroragia tunica	\N	1	\N	70L
3861	Petrorhagia saxifraga	\N	\N	2	70L
3862	Petroselinum crispum	\N	\N	2	70D
3863	Petroselinum hortense	\N	\N	2	70D
3864	Petroselinum hortense	B	\N	\N	70
3865	Petunia (hybrids)	\N	\N	2	70D
3866	Phacelia bipinnatifida	\N	\N	2	70 GA-3
3867	Phacelia campanularia	B	\N	\N	40
3868	Phacelia dubia	B	\N	\N	70-40-OT
3869	Phacelia grandiflora	B	\N	\N	70
3870	Phacelia purshii	\N	1	\N	70D
3871	Phacelia sericea	B	\N	\N	70
3872	Phacelia x 'lavender lady'	B	\N	\N	70
3873	Phalolepis nigricans	\N	\N	2	70L-40-70L-40-70L
3874	Phaseolus acutifolius	\N	1	\N	70
3875	Phaseolus vulgaris	\N	\N	2	70D
3876	Phellodendron amurense	B	\N	\N	WC 7 d, extract, OT
3877	Philadelphus coronarius	B	\N	\N	D-70
3878	Phlomis fruticosa	B	\N	\N	70D
3879	Phlomis samia	\N	1	\N	70D
3880	Phlomis tuberosa	B	\N	\N	70
3881	Phlox adsurgens	B	\N	\N	comment
3882	Phlox bifida	B	\N	\N	comment
3883	Phlox diffusa v. longistylis	B	\N	\N	70
3884	Phlox divaricata	B	\N	\N	70-40-70-40-70
3885	Phlox drummondi	B	\N	\N	70
3886	Phlox glaberrima	\N	1	\N	70 GA-3
3887	Phlox glaberrima	B	\N	\N	D-40-70
3888	Phlox hoodii	B	\N	\N	40-70
3889	Phlox longifolia	B	\N	\N	40
3890	Phlox multiflora	B	\N	\N	40
3891	Phlox paniculata	B	\N	\N	OT
3892	Phlox pilosa	B	\N	\N	70-40-70-40-70
3893	Phlox pulchra	B	\N	\N	40-70-40-70
3894	Phlox pulvinata	B	\N	\N	40-70
3895	Phlox scleranthifolia	B	\N	\N	comment
3896	Phlox speciosa	\N	1	\N	70-40
3897	Phlox speciosa	B	\N	\N	40-70
3898	Phlox stolonifera	B	\N	\N	comment
3899	Phoenicaulis cheiranthoides	\N	\N	2	40-70D
3900	Phoenicaulis cheiranthoides	\N	1	\N	70D
3901	Phoenix dactylifera	\N	\N	2	70D
3902	Phoenix dactylifera	\N	1	\N	WC 3 d, 70D
3903	Phoenix dactylifera	B	\N	\N	WC, 70
3904	Phoradendron flavescens	B	\N	\N	70L
3905	Phormium colensoi	\N	\N	2	no germ
3906	Phormium cookianum	\N	\N	2	70L
3907	Phormium tenax	\N	\N	2	70L
3908	Phormium tenax purpureum	\N	1	\N	70L
3909	Phormium tenax variegatum	\N	\N	2	70D
3910	Photinia villosa	\N	\N	2	40-70D
3911	Photinia villosa	\N	1	\N	40-70D
3912	Photinia villosa	B	\N	\N	40-70
3913	Phuopsis stylosa 	\N	\N	2	70D
3914	Phygelius aequalis	\N	\N	2	70L
3915	Phygelius aequalis	\N	1	\N	70L
3916	Phygelius capensis	\N	\N	2	70L
3917	Phygelius capensis	\N	1	\N	70L
3918	Phylica pubescens	\N	\N	2	no germ
3919	Phyllodoce coerulea	B	\N	\N	70
3920	Phyllodoce nipponica	B	\N	\N	70L
3921	Phyllostachys pubescens	\N	\N	2	70L
3922	Physalis alkekengi	\N	1	\N	DS 3 y = dead
3923	Physalis alkekengi	B	\N	\N	WC 7 d, 70D GA-3
3924	Physalis ixocarpa	\N	1	\N	WC 1 d, 70L
3925	Physalis virginiana	B	\N	\N	WC 5 w, 70L
3926	Physaria alpina	B	\N	\N	OT
3927	Physaria newberryi	B	\N	\N	70
3928	Physocarpus opulifolius 	B	\N	\N	D-40-70
3929	Physoplexis comosum	B	\N	\N	70D GA-3
3930	Physoptychis gnaphlodes	\N	1	\N	70D
3931	Physostegia virginiana alba	B	\N	\N	70
3932	Phyteuma charmellii	B	\N	\N	70
3933	Phyteuma haemispherica	B	\N	\N	70
3934	Phyteuma nigra	B	\N	\N	70
3935	Phyteuma scheuzeri	B	\N	\N	70
3936	Phyteuma serratum	B	\N	\N	70D GA-3
3937	Phytolacca americana	B	\N	\N	WC 7 d, D-40-70
3938	Phytolace dioica	\N	1c	\N	70 GA-3
3939	Picea abies	\N	1	\N	70D
3940	Picea abies	B	\N	\N	70D
3941	Picea excelsa	B	\N	\N	70
3942	Picea mariana	\N	1	\N	70D
3943	Picea mariana	B	\N	\N	70
3944	Picea pungens	\N	\N	2	70 GA-3
3945	Picea pungens	B	\N	\N	D-40-70
3946	Picea rubra	B	\N	\N	40-70
3947	Pieris formosa	\N	\N	2	70
3948	Pieris japonica	B	\N	\N	70L
3949	Pilosella islandica	\N	1	\N	70D
3950	Pimelea prostrata	\N	1	\N	40-70
3951	Pimelea prostrata	B	\N	\N	40-70D
3952	Pimpinella anisum	B	\N	\N	70
3953	Pinellia ternata	B	\N	\N	40-70
3954	Pinguicula macroceras	B	\N	\N	70L
3955	Pinquicula vulgaris	\N	1	\N	40-70L
3956	Pinus aristata	B	\N	\N	40-70
3957	Pinus canadensis	B	\N	\N	40-70
3958	Pinus caribea	B	\N	\N	40-70
3959	Pinus cembra	B	\N	\N	40-70
3960	Pinus cembroides	B	\N	\N	40-70
3961	Pinus contorta	B	\N	\N	40-70
3962	Pinus coulteri	B	\N	\N	40-70
3963	Pinus densiflora	B	\N	\N	40-70
3964	Pinus echinata	B	\N	\N	40-70
3965	Pinus elliottii	\N	1	\N	70D
3966	Pinus excelsa	B	\N	\N	40-70
3967	Pinus flexilis	B	\N	\N	40-70
3968	Pinus insignis	B	\N	\N	40-70
3969	Pinus koraiensis	B	\N	\N	40 5 m, 70
3970	Pinus lambertiana	B	\N	\N	40-70
3971	Pinus monophylla	B	\N	\N	40-70
3972	Pinus monticola	B	\N	\N	40-70
3973	Pinus mugo	B	\N	\N	70
3974	Pinus palustris	B	\N	\N	40-70
3975	Pinus parviflora	B	\N	\N	40-70
3976	Pinus pinea	B	\N	\N	70
3977	Pinus poderosa	B	\N	\N	40-70
3978	Pinus pumila	B	\N	\N	40-70
3979	Pinus radiata	B	\N	\N	40-70
3980	Pinus resinosa	B	\N	\N	40-70
3981	Pinus rigida	B	\N	\N	40-70
3982	Pinus roxburghii	B	\N	\N	70
3983	Pinus sabiniana	B	\N	\N	40-70
3984	Pinus strobus	B	\N	\N	70L-40-70D
3985	Pinus sylvestris	B	\N	\N	70
3986	Pinus taeda	B	\N	\N	40-70
3987	Pinus thunbergii	B	\N	\N	40-70
3988	Pinus torreyana	B	\N	\N	40-70
3989	Pinus tuberculata	B	\N	\N	40-70
3990	Pinus virginiana	B	\N	\N	40-70
3991	Piptanthus nepalensis	B	\N	\N	70
3992	Pittosporum crassicaule	\N	1	\N	70-40-70-40-70-40-70-40-70-40-70
3993	Placeae ornata	\N	1	\N	rotted
3994	Plantago coronopus	\N	\N	2	70L
3995	Plantago coronopus	\N	1	\N	70L
3996	Plantago lanceolata	\N	\N	2	70L
3997	Plantago lanceolata	\N	1	\N	70L
3998	Plantago major	\N	\N	2	70L
3999	Plantago major	\N	1	\N	70L
4000	Plantago maritima	\N	1	\N	70L
4001	Plantago purshii	\N	\N	2	70L
4002	Plantago purshii	\N	1	\N	70
4003	Plantago serpentina	\N	1	\N	70L
4004	Plantago virginica	\N	1	\N	70L
4005	Platanus occidentalis	B	\N	\N	OT
4006	Platycodon grandiflora	B	\N	\N	40-70
4007	Pleiospilos bolusii	\N	1	\N	70L
4008	Pleiospilus bolusii	\N	\N	2	70D
4009	Pleuroginella brachyanthera	B	\N	\N	OT
4010	Pleurospermum brunonis	\N	1	\N	70D
4011	Plumbago capensis	\N	\N	2	55-85
4012	Plumeria emarginata	\N	1	\N	70D
4013	Podocarpus nivalis	\N	\N	2	40-70D
4014	Podocarpus nivalis	\N	1	\N	no germ
4015	Podophyllum emodi	B	\N	\N	WC 7 d, D-70
4016	Podophyllum hexandrum	B	\N	\N	WC 7 d, D-70
4017	Podophyllum peltatum	B	\N	\N	WC 7 d, OT
4018	Podophyllum pentaphyllum	B	\N	\N	WC 7 d, D-70
4019	Polanisia dodecandra	\N	1	\N	70D
4020	Polaskia chichipe	\N	1c	\N	70 GA-3
4021	Polemonium acutiflorum	B	\N	\N	70
4022	Polemonium brandegii	B	\N	\N	70
4023	Polemonium caeruleum	\N	\N	2	comment
4024	Polemonium coeruleum	B	\N	\N	70
4025	Polemonium coeruleum alba	\N	1	\N	70L
4026	Polemonium coeruleum ssp. villosum	B	\N	\N	70D
4027	Polemonium delicatum	B	\N	\N	D-40
4028	Polemonium grayanum	B	\N	\N	70L
4029	Polemonium haydeni	B	\N	\N	70
4030	Polemonium mellitum	B	\N	\N	70D
4031	Polemonium pauciflorum	\N	\N	2	comment
4032	Polemonium pauciflorum	B	\N	\N	70
4033	Polemonium pulchellum	B	\N	\N	70
4034	Polemonium pulcherrimum v. calycinum	B	\N	\N	70L
4035	Polemonium reptans	B	\N	\N	70-40-70-40
4036	Polemonium vanbruntiae	\N	\N	2	40-70D
4037	Polemonium vanbruntiae	B	\N	\N	40-70L
4038	Polemonium viscosum	B	\N	\N	70
4039	Poliomintha incana	\N	1	\N	70
4040	Polygala brevifolia	B	\N	\N	70-40-70D
4041	Polygala calcarea	B	\N	\N	70L
4042	Polygala chamaebuxus	B	\N	\N	70
4043	Polygala lutea	B	\N	\N	40-70L
4044	Polygala nuttallii	B	\N	\N	70-40-70
4045	Polygala paucifolia	\N	1	\N	70D
4046	Polygala senega	\N	1	\N	70L-40-70D
4047	Polygonatum biflorum	B	\N	\N	WC 7 d, OT
4048	Polygonatum humile	\N	1	\N	70D-40-70-40-70
4049	Polygonatun glaberrimum	B	\N	\N	OT
4050	Polygonatun humile	B	\N	\N	70D
4051	Polygonum acifolium	B	\N	\N	40-70
4052	Polygonum acre	B	\N	\N	40-70
4053	Polygonum amphibium	B	\N	\N	40-70
4054	Polygonum aviculare	B	\N	\N	40-70
4055	Polygonum coccineum	B	\N	\N	40-70
4056	Polygonum cuspidatum	B	\N	\N	70L
4057	Polygonum hydropiperoides	B	\N	\N	40-70
4058	Polygonum lapathifolium	B	\N	\N	40-70
4059	Polygonum orientale	\N	\N	2	comment
4060	Polygonum orientale	\N	1	\N	comment
4061	Polygonum orientale	B	\N	\N	70
4062	Polygonum pennsylvanicum	B	\N	\N	40-70
4063	Polygonum scandens	B	\N	\N	40-70
4064	Polygonum virginianum	B	\N	\N	40-70
4065	Polyxena corymbosa	\N	\N	2	70D
4066	Polyxena corymbosa	\N	1	\N	70D
4067	Polyxena ensifolia	\N	\N	2	70D
4068	Polyxena ensifolia	\N	1	\N	70D
4069	Polyxena odorata	\N	\N	2	70D
4070	Polyxena odorata	\N	1	\N	70D
4071	Poncirus trifoliata	B	\N	\N	WC 7 d, 70D
4072	Pontederia cordata	\N	\N	2	no germ
4073	Popoviolimon turkominicum	B	\N	\N	40
4074	Populus gradidentata	B	\N	\N	70
4075	Populus tremuloides	B	\N	\N	70
4076	Porophyllum rudicale	\N	1	\N	D-70
4077	Portulaca grandiflora	\N	\N	2	70D
4078	Portulaca mundula	\N	\N	2	GA-4 32-75 OS
4079	Portulaca mundula	\N	1	\N	70 GA-3
4080	Potentilla argyrophylla	B	\N	\N	70D
4081	Potentilla atrosanguinea	B	\N	\N	70L
4082	Potentilla crantzii	B	\N	\N	70D
4083	Potentilla cuneata	B	\N	\N	70D
4084	Potentilla eriocarpa	B	\N	\N	70D
4085	Potentilla fruticosa	B	\N	\N	70D
4086	Potentilla megalantha	B	\N	\N	70L
4087	Potentilla nuttallii	B	\N	\N	70D
4088	Potentilla recta	\N	\N	2	70L
4089	Potentilla recta	\N	1	\N	70L
4090	Potentilla recta	B	\N	\N	70D GA-3
4091	Potentilla rupestris	B	\N	\N	70L
4092	Potentilla rupestrus	\N	\N	2	70L
4093	Potentilla salesoviana	B	\N	\N	70D
4094	Prasophyllum colensoi	\N	\N	2	no germ
4095	Pratia angulata	\N	\N	2	70L
4096	Primula algida	B	\N	\N	70
4097	Primula alpicola	B	\N	\N	70
4098	Primula alpicola violacea	B	\N	\N	70
4099	Primula anisodora	B	\N	\N	70
4100	Primula apoclita	B	\N	\N	70
4101	Primula aurantiaca	B	\N	\N	70
4102	Primula auricula	B	\N	\N	70
4103	Primula auriculata	B	\N	\N	70
4104	Primula beesiana	B	\N	\N	70
4105	Primula bulleyana	\N	\N	2	DS 5 y = dead
4106	Primula bulleyana	B	\N	\N	70
4107	Primula burmanica	B	\N	\N	70
4108	Primula buryana	B	\N	\N	70L
4109	Primula calycina	B	\N	\N	70
4110	Primula capitata	B	\N	\N	70
4111	Primula chionantha	B	\N	\N	70
4112	Primula chungensis	B	\N	\N	70
4113	Primula clusiana	B	\N	\N	70
4114	Primula cockburniana	B	\N	\N	40-70
4115	Primula cortusoides	B	\N	\N	40-70
4116	Primula cuneifolia	B	\N	\N	70
4117	Primula darialica	B	\N	\N	70
4118	Primula denticulata	B	\N	\N	40-70
4119	Primula dowensis	\N	1	\N	70
4120	Primula elatior	B	\N	\N	70-40-70
4121	Primula elliptica	B	\N	\N	70
4122	Primula ellisiae	B	\N	\N	70
4123	Primula erosa	B	\N	\N	70
4124	Primula farinosa	B	\N	\N	70
4125	Primula firmipes	B	\N	\N	70
4126	Primula flexuosa	B	\N	\N	40
4127	Primula florindae	\N	\N	2	DS 3 y = dead
4128	Primula florindae	B	\N	\N	70L
4129	Primula forrestii	\N	\N	2	DS 7 y = dead
4130	Primula forrestii	\N	1	\N	comment
4131	Primula forrestii	B	\N	\N	70L
4132	Primula frondosa	\N	\N	2	DS 6 y = dead
4133	Primula frondosa	B	\N	\N	70
4134	Primula gambeliana	B	\N	\N	70
4135	Primula geraniifolia	B	\N	\N	70-40-70
4136	Primula glutinosa	B	\N	\N	70
4137	Primula halleri	B	\N	\N	70
4138	Primula helodoxa	B	\N	\N	70
4139	Primula heucherifolia	B	\N	\N	70
4140	Primula iljinski	B	\N	\N	70L
4141	Primula integrifolia	B	\N	\N	70
4142	Primula intercedens	B	\N	\N	40-70
4143	Primula involucrata	B	\N	\N	70
4144	Primula ioessa	B	\N	\N	70
4145	Primula japonica	B	\N	\N	40-70
4146	Primula juliae	B	\N	\N	70
4147	Primula kaufmanniana	B	\N	\N	70
4148	Primula kisoana	\N	1	\N	DS 2 y = dead
4149	Primula kisoana	B	\N	\N	70L
4150	Primula laurentiana	B	\N	\N	70
4151	Primula luteola	B	\N	\N	70
4152	Primula macrophylla	B	\N	\N	no germ
4153	Primula maguerei	B	\N	\N	70
4154	Primula malacoides	\N	\N	2	60L-75L
4155	Primula malacoides	B	\N	\N	70
4156	Primula marginata	B	\N	\N	70
4157	Primula melanops	B	\N	\N	70
4158	Primula minima	B	\N	\N	70
4159	Primula minutissima	B	\N	\N	70
4160	Primula modesta	B	\N	\N	OT
4161	Primula muscarioides	B	\N	\N	70
4162	Primula nevadensis	\N	\N	2	70D
4163	Primula nevadensis	\N	1	\N	70D
4164	Primula nutans	B	\N	\N	70
4165	Primula obconica	B	\N	\N	70
4166	Primula pamirica	B	\N	\N	D-70
4167	Primula parryi	B	\N	\N	40-70
4168	Primula poissoni	B	\N	\N	70
4169	Primula polyneura	\N	\N	2	DS 6 y = dead
4170	Primula polyneura	B	\N	\N	70
4171	Primula prolifera	B	\N	\N	70
4172	Primula pulverulenta	B	\N	\N	70
4173	Primula pulvurea	B	\N	\N	70L
4174	Primula reidii	B	\N	\N	70
4175	Primula reticulata	B	\N	\N	70
4176	Primula rosea	B	\N	\N	70
4177	Primula rotundifolia	\N	1	\N	comment
4178	Primula rotundifolia	B	\N	\N	70L
4179	Primula rusbyi	B	\N	\N	70
4180	Primula scandinavica	B	\N	\N	70
4181	Primula scotica	B	\N	\N	70
4182	Primula secundiflora	B	\N	\N	70
4183	Primula serratifolia	B	\N	\N	70
4184	Primula sieboldi	B	\N	\N	70D GA-3
4185	Primula sikkimensis	B	\N	\N	70
4186	Primula sinoplantaginea	B	\N	\N	70
4187	Primula sinopurpurea	B	\N	\N	70
4188	Primula spectabilis	B	\N	\N	70-40-70
4189	Primula specuicola	\N	\N	2	40-70D
4190	Primula specuicola	\N	1	\N	40-70D
4191	Primula stuartii	B	\N	\N	70
4192	Primula suffrutescens	B	\N	\N	70
4193	Primula tschuktschorum	B	\N	\N	70
4194	Primula veris	B	\N	\N	70D
4195	Primula vernales (hybrids)	B	\N	\N	40 GA-3
4196	Primula verticillata	B	\N	\N	70L
4197	Primula vialli	B	\N	\N	70
4198	Primula violacea	B	\N	\N	70-40-70
4199	Primula viscosa	B	\N	\N	70
4200	Primula waltoni	B	\N	\N	70
4201	Primula warshenewskiana	B	\N	\N	70
4202	Primula wilsoni	B	\N	\N	70
4203	Primula yargongensis	B	\N	\N	70
4204	Prinsepia sinensis	B	\N	\N	WC 14 d, crack, 70
4205	Protea longifolia	\N	\N	2	rotted
4206	Protea mundii	\N	\N	2	rotted
4207	Protea repens	\N	\N	2	40
4208	Prunella vulgaris	\N	1	\N	70L
4209	Prunella webbiana	B	\N	\N	70
4210	Prunus allegheniensis	B	\N	\N	WC 7 d, OT
4211	Prunus armenaica	\N	1	\N	extract, WC, 70
4212	Prunus armenaica	B	\N	\N	WC 7 d, extract, 70
4213	Prunus avium v. juliana	B	\N	\N	WC 7 d, 70-40-70-70-40-70
4214	Prunus 'bing cherry'	\N	\N	2	crack, 70D-40-70D
4215	Prunus communis	\N	1	\N	extract, OT
4216	Prunus 'golden beauty'	\N	\N	2	40-70D-40-70D
4217	Prunus 'golden beauty'	\N	1	\N	extract, 40
4218	Prunus serotina	B	\N	\N	WC 7 d, 40-70-40-70
4219	Prunus serrulata	B	\N	\N	WC 7 d, 70-40-70-40-70-40-70-40
4220	Prunus sp.	\N	1	\N	40-70-40-70
4221	Psathyrotes pilifera	\N	1	\N	40
4222	Pseudomertensia nemorosa	B	\N	\N	70
4223	Pseudomuscari azureum 	\N	\N	2	40
4224	Pseudomuscari azureum album	\N	\N	2	40
4225	Pseudotaenidia montana	B	\N	\N	70
4226	Pseudotsuga menziesii	B	\N	\N	70D
4227	Psidium guajava	\N	\N	2	70D
4228	Psychotria nervosa	\N	\N	2	70D
4229	Psychotria nervosa	\N	1	\N	70
4230	Psychrogeton andryaloides	B	\N	\N	70
4231	Ptelea isophylla	B	\N	\N	40-70
4232	Ptelea trifoliata	\N	\N	2	comment
4233	Ptelea trifoliata	\N	1	\N	70 GA-3
4234	Ptelea trifoliata	B	\N	\N	40-70
4235	Pterocephalus perennis	\N	1	\N	70D
4236	Pterostyrax hispidus	\N	1	\N	70 GA-3
4237	Ptilotrichum coccineum	\N	1	\N	70D
4238	Ptilotrichum macrocarpum	B	\N	\N	40
4239	Ptilotrichum spinosum	\N	1	\N	empty
4240	Pueraria lobota	\N	1	\N	comment
4241	Pulsatilla alba	\N	\N	2	rotted
4242	Pulsatilla albana	B	\N	\N	70
4243	Pulsatilla ambigua	B	\N	\N	OT
4244	Pulsatilla bungeana	B	\N	\N	OT
4245	Pulsatilla campanella	B	\N	\N	70
4246	Pulsatilla grandis	\N	\N	2	70D
4247	Pulsatilla grandis	B	\N	\N	OT
4248	Pulsatilla montana	\N	\N	2	rotted
4249	Pulsatilla occidentalis	B	\N	\N	OT
4250	Pulsatilla patens	B	\N	\N	70
4251	Pulsatilla pratensis	B	\N	\N	OT
4252	Pulsatilla sulphurea	B	\N	\N	OT
4253	Pulsatilla turczaminovii	B	\N	\N	70D
4254	Pulsatilla vernalis	B	\N	\N	OT
4255	Pulsatilla vulgaris	B	\N	\N	70
4256	Pulsatilla vulgaris v. zimmermannii	B	\N	\N	70D
4257	Pulsatilla wallichianum	B	\N	\N	70
4258	Punica granatum	\N	\N	2	scrape, WC 7 d, 70D
4259	Punica granatum	\N	1	\N	scrape, WC 7 d, 70D
4260	Punica granatum	B	\N	\N	comment
4261	Purshia mexicana v. stansburyana	\N	1	\N	70L
4262	Purshia tridentata	\N	1	\N	40
4263	Puschkinia scilloides	B	\N	\N	70-40
4264	Putoria calabrica	\N	\N	2	70L-40-70L-40-70L
4265	Pycnanthemum incanum	\N	1	\N	D-70L
4266	Pycnanthemum incanum	B	\N	\N	70D GA-3
4267	Pyracantha lalandi	B	\N	\N	70
4268	Pyrola minor	\N	1	\N	no germ
4269	Pyrosia serpens	\N	\N	2	empty
4270	Pyrrhocactus bulbocalyx	\N	1c	\N	70 GA-3
4271	Pyrrhocactus sanjuanensis	\N	1c	\N	70 GA-3
4272	Pyrrhocactus umadeave	\N	1c	\N	70 GA-3
4273	Pyrus 'buerre bosc'	\N	1	\N	40
4274	Pyrus calleriana	\N	1	\N	WC 7 d, 40
4275	Pyrus calleryana	\N	\N	2	40
4276	Pyrus calleryana	B	\N	\N	40
4277	Pyrus 'kieffer'	\N	1	\N	40-70
4278	Pyrus pyrifolia 	\N	\N	2	70D-40-70D-40-70D
4279	Pyxidanthera barbulata	B	\N	\N	70
4280	Quercus alba	\N	1	\N	70
4281	Quercus alba	B	\N	\N	70
4282	Quercus borealis	\N	1	\N	40-70
4283	Quercus borealis	B	\N	\N	40-70
4284	Quercus coccinea	\N	1	\N	40-70
4285	Quercus coccinea	B	\N	\N	40-70
4286	Quercus macrocarpa	B	\N	\N	40-70
4287	Quercus phellos	B	\N	\N	70-40-70
4288	Quercus velutina	B	\N	\N	40-70
4289	Quercus virginiana	\N	1	\N	70
4290	Ramonda myconi	B	\N	\N	D-40-70
4291	Ranunculus acris	B	\N	\N	40-70
4292	Ranunculus adoneus	B	\N	\N	70L
4293	Ranunculus asiaticus	\N	1	\N	70
4294	Ranunculus bulbosus	\N	1	\N	70L
4295	Ranunculus glacialis	\N	1	\N	70 GA-3
4296	Ranunculus gramineus	B	\N	\N	40-70-40
4297	Ranunculus hispidulus	B	\N	\N	70-40-70-40
4298	Ranunculus illyricus	B	\N	\N	70D-40
4299	Ranunculus lyallii	\N	1	\N	DS 2 y = dead
4300	Ranunculus lyallii	B	\N	\N	70 GA-3
4301	Ranunculus repens	B	\N	\N	70L-40-70L-40-70L
4302	Ranunculus semiverticillatus	\N	\N	2	no germ
4303	Ranunculus sp.	B	\N	\N	70
4304	Raphanus sativus	\N	\N	2	70D
4305	Rathbunia alamosensis	\N	1c	\N	70 GA-3
4306	Ratibida (hybrids)	\N	\N	2	70D
4307	Ratibida columnifera	\N	1	\N	70D
4308	Ratibida columnifera	B	\N	\N	70
4309	Ratibida columnifera 	\N	\N	2	70D
4310	Rauheocereus riosaniensis	\N	1c	\N	70 GA-3
4311	Rebutia (hybrids)	\N	1c	\N	70
4312	Rebutia (hybrids) 	B	\N	\N	70
4313	Rebutia marsoneri	\N	1c	\N	70 GA-3
4314	Rebutia narvaecensis	\N	1c	\N	70 GA-3
4315	Rehmannia elata	\N	\N	2	70D
4316	Rehmannia elata	\N	1	\N	70L
4317	Reseda odorata	\N	\N	2	70D
4318	Reseda odorata grandiflora	\N	1	\N	70D
4319	Rhamnus caroliniana	B	\N	\N	WC, 40-70
4320	Rhamnus cathartica	B	\N	\N	WC, 70
4321	Rhamnus fallax	B	\N	\N	WC, 70D
4322	Rheum altaicum	B	\N	\N	70
4323	Rheum ribes	B	\N	\N	70
4324	Rheum tibeticum	B	\N	\N	70
4325	Rhexia mariana	B	\N	\N	70L
4326	Rhexia virginiana	B	\N	\N	40-70L
4327	Rhinanthus minor	\N	1	\N	OT
4328	Rhinephyllum broomii	\N	1	\N	70L
4329	Rhinephyllum broomii 	\N	\N	2	70
4330	Rhinopetalum bucharica	B	\N	\N	OT
4331	Rhinopetalum stenantherium	B	\N	\N	OT
4332	Rhipsalis baccifera	\N	1c	\N	no germ
4333	Rhodiola atropurpurea	B	\N	\N	70L
4334	Rhodiola heterodonta	B	\N	\N	40-70
4335	Rhodiola sp.	B	\N	\N	70
4336	Rhodochiton atrosanguineum	\N	1	\N	70
4337	Rhododendron (hybrids)	\N	\N	2	70L
4338	Rhododendron anthopogon	B	\N	\N	70L
4339	Rhododendron catawbiense (hybrids)	B	\N	\N	70L
4340	Rhododendron lepidotum	B	\N	\N	70L
4341	Rhododendron maximum	B	\N	\N	70
4342	Rhododendron mollis (hybrids)	B	\N	\N	70
4343	Rhododendron schlippenbachii	B	\N	\N	70
4344	Rhododendron sp.	B	\N	\N	70L
4345	Rhodolirion montanum	B	\N	\N	40
4346	Rhodophiala advena	B	\N	\N	70
4347	Rhodophiala andicola	\N	1	\N	40
4348	Rhodophiala andicola	B	\N	\N	40
4349	Rhodophiala araucana	B	\N	\N	40
4350	Rhodophiala elwesii	\N	1	\N	40
4351	Rhodophiala elwesii	B	\N	\N	40
4352	Rhodophiala montanum	\N	1	\N	40
4353	Rhodophiala pratensis	B	\N	\N	40
4354	Rhodophiala sp.	\N	1	\N	40
4355	Rhodophiala sp.	B	\N	\N	40
4356	Rhodotypos tetrapetala	B	\N	\N	70-40-70-40
4357	Rhus canadensis	B	\N	\N	40-70-40-70
4358	Rhus trilobata	B	\N	\N	comment
4359	Rhus typhina	B	\N	\N	puncture, 70
4360	Ribes americana	B	\N	\N	WC 7 d, OT
4361	Ribes cereum	B	\N	\N	WC 7 d, GA-3, OT
4362	Ribes grossularia	B	\N	\N	WC 7 d, OT
4363	Ribes hirtellum	\N	\N	2	40-70
4364	Ribes lacustre	\N	1	\N	OT
4365	Ribes lobbii	B	\N	\N	WC 7 d, OT
4366	Rivina humilis	\N	\N	2	70L
4367	Robinia pseudoacacia 	B	\N	\N	puncture, 70
4368	Rodgersia pinnata	B	\N	\N	70
4369	Rodgersia pinnata alba	B	\N	\N	70
4370	Rodgersia pinnata superba	B	\N	\N	70
4371	Rodgersia sambucifolia	B	\N	\N	70
4372	Rodgersia tabularis	B	\N	\N	70-40
4373	Romanzoffia sitchensis	B	\N	\N	70L
4374	Romneya coulteri	\N	1	\N	comment
4375	Romneya coulteri	B	\N	\N	70D GA-3
4376	Romneya trichocalyx	\N	\N	2	DS 6 m + GA-3
4377	Romneya trichocalyx	\N	1	\N	70 GA-3 40
4378	Romulea bulbocdium	B	\N	\N	40
4379	Romulea hantamensis	B	\N	\N	comment
4380	Romulea luthicii	B	\N	\N	40
4381	Rorippa islandica	\N	1	\N	70L
4382	Rosa (hybrids)	B	\N	\N	WC 7 d, 40-70-40
4383	Rosa alba 'suaveolens'	\N	\N	2	70D-40-70D-40-70D
4384	Rosa amurensis	B	\N	\N	WC 7 d, OT
4385	Rosa avchurensis	B	\N	\N	WC 7 d, 70-40-70-40-70
4386	Rosa canina	\N	\N	2	70D-40-70D-40-70D
4387	Rosa canina	\N	1	\N	70-40-70-40-70-40-70-40-70-40-70
4388	Rosa carolina	\N	1	\N	40-70-40-70-40-70
4389	Rosa 'dornroschen'	\N	\N	2	70D-40-70D-40-70D
4390	Rosa eglanteria	\N	\N	2	70D-40-70D-40-70D
4391	Rosa gallica 'tuscany superba'	\N	\N	2	70D-40-70D-40-70D
4392	Rosa multiflora	B	\N	\N	WC 7 d, 40-70-40-70
4393	Rosa palustris	\N	\N	2	70D-40-70D
4394	Rosa palustris	\N	1	\N	40-70-40-70-40-70
4395	Rosa paulii rosea	\N	\N	2	70D-40-70D-40-70D-40-70D
4396	Rosa rubrifolia	\N	\N	2	no germ
4397	Rosa 'sheilers provence'	\N	\N	2	70D-40-70D-40-70D
4398	Rosa sp. 'south dakota'	\N	\N	2	70D-40-70D-40-70D
4399	Rosa virginiana	B	\N	\N	WC 7 d, 70D-40-70D
4400	Rosa webbiana	B	\N	\N	WC 7 d, OT
4401	Rosa x 'sheilers provence'	\N	1	\N	70-40-70
4402	Roscoea alpina	\N	\N	2	70D
4403	Roscoea alpina	B	\N	\N	40-70
4404	Rosmarinus officinalis	B	\N	\N	70
4405	Rosularia pallida	\N	1	\N	70L
4406	Rosularia sempervivum	\N	1	\N	70
4407	Roystonia regia	\N	\N	2	DS 2 y = dead
4408	Roystonia regia	\N	1	\N	40-70D
4409	Rubus argutus	\N	1	\N	D-OT
4410	Rubus argutus	B	\N	\N	40-70
4411	Rubus argutus 	\N	\N	2	DS 6 m, OT
4412	Rubus occidentalis	B	\N	\N	WC 7 d, DS 6 m, 40-OT
4413	Rubus odoratus	B	\N	\N	70L
4414	Rubus parviflorus	B	\N	\N	70 GA-3
4415	Rudbeckia (hybrids)	\N	\N	2	70D
4416	Rudbeckia fulgida	\N	1	\N	82-90
4417	Rudbeckia hirta (hybrids)	B	\N	\N	70
4418	Rudbeckia occidentalis	\N	\N	2	70D
4419	Rudbeckia x 'goldsturm'	\N	1	\N	82-90
4420	Ruellia humilis	B	\N	\N	40 14 d-70
4421	Rumex acetosa	\N	\N	2	70D
4422	Rumex acetosa	\N	1	\N	70
4423	Rumex acetosella	\N	\N	2	70L
4424	Rumex acetosella	\N	1	\N	70D
4425	Rumex alpinus	\N	\N	2	70D
4426	Rumex alpinus	\N	1	\N	70L
4427	Rumex crispus	\N	\N	2	70L
4428	Rumex crispus	\N	1	\N	70L
4429	Rumex longifolius	\N	1	\N	70D
4430	Rumex obtusifolius	\N	\N	2	70L
4431	Rumex obtusifolius	\N	1	\N	70L
4432	Rumex obtusifolius	B	\N	\N	70L
4433	Rumex patientia	\N	\N	2	70L
4434	Rumex patientia	\N	1	\N	70L
4435	Rumex scutatus	\N	\N	2	70L
4436	Rumex scutatus	\N	1	\N	70L
4437	Rumex venosus	\N	1	\N	40
4438	Rupicapnos africana	\N	\N	2	70 GA-3 - 40
4439	Ruta corsica	\N	\N	2	70D
4440	Ruta graveolens	\N	1	\N	70D
4441	Ruta graveolens 	\N	\N	2	70D
4442	Sabal minor	B	\N	\N	40-70
4443	Sabal palmetto	\N	\N	2	70D
4444	Sabal palmetto	\N	1	\N	puncture, 70D
4445	Sabatia kennedyana	B	\N	\N	70-40-70
4446	Sagina procumbens	\N	1	\N	70L
4447	Sagina selaginoides	\N	\N	2	70L
4448	Sagina selaginoides	\N	1	\N	70L
4449	Sagittaria latifolia 	\N	\N	2	70L
4450	Saintpaulia ionantha	\N	\N	2	65L-80L
4451	Salix artica	\N	1	\N	70, DS 3 w = dead, MS@40 12 w = OK
4452	Salix calcicola	\N	1	\N	dead
4453	Salix cascadensis	B	\N	\N	40-70L
4454	Salix herbacea	\N	1	\N	70, DS 3 w = dead, MS@40 12 w = OK
4455	Salix lanata	\N	1	\N	70, DS 3 w = dead, MS@40 12 w = OK
4456	Salix phylicifolia	\N	1	\N	70, DS 3 w = dead, MS@40 12 w = OK
4457	Salpiglosis (hybrids)	B	\N	\N	70
4458	Salpiglossis sinuata	\N	\N	2	70D
4459	Salvia argentea	B	\N	\N	70L
4460	Salvia candidissima	B	\N	\N	70L
4461	Salvia cyanescens	\N	\N	2	70 GA-3
4462	Salvia cyanescens	B	\N	\N	70L
4463	Salvia dumetorum	B	\N	\N	70
4464	Salvia fulgens	\N	\N	2	70D
4465	Salvia glutinosa	B	\N	\N	70L
4466	Salvia hians	B	\N	\N	70L
4467	Salvia hispanica	\N	1	\N	70
4468	Salvia huberi	B	\N	\N	OT
4469	Salvia moorcroftiana	B	\N	\N	D-70
4470	Salvia officinalis	B	\N	\N	70
4471	Salvia pratensis	\N	1	\N	70
4472	Salvia repens	B	\N	\N	70
4473	Salvia sclarea	B	\N	\N	70L
4474	Salvia sclarea 'turkestanica'	\N	\N	2	70D
4475	Salvia superba	\N	\N	2	70D
4476	Salvia verticillata	\N	\N	2	DS 3 y = dead
4477	Sambucus canadensis	\N	1	\N	70 GA-3
4478	Sambucus canadensis	B	\N	\N	WC 7 d, 70D GA-3
4479	Sambucus nigra	\N	1	\N	70-40-70
4480	Sambucus pubens	\N	1	\N	70 GA-3
4481	Sambucus pubens	B	\N	\N	no germ
4482	Sambucus racemosa	B	\N	\N	WC 7 d, 70D-40-70
4483	Sandersonia aurantiaca	\N	\N	2	OT
4484	Sandersonia aurantiaca	\N	1	\N	OT
4485	Sandersonia aurantiaca	B	\N	\N	70L
4486	Sanguinaria canadensis	\N	1	\N	OT
4487	Sanguinaria canadensis	B	\N	\N	OT
4488	Sanguisorba minor	\N	\N	2	70D
4489	Sanguisorba minor	\N	1	\N	70D
4490	Sanguisorba minor	B	\N	\N	70
4491	Sanguisorba officinalis	B	\N	\N	70L
4492	Sanicula arctopoides	\N	1	\N	OT
4493	Santolina pectinata	\N	\N	2	70D
4494	Sapindus saponaria v. drummondi	\N	1	\N	no germ
4495	Sapium sebeferum 	\N	1	\N	70 GA-3 40
4496	Saponaria caespitosa	B	\N	\N	D-40
4497	Saponaria chlorifolia	\N	1	\N	70 GA-3
4498	Saponaria ocymoides	\N	\N	2	70D
4499	Saponaria ocymoides	\N	1	\N	70L
4500	Sarcocca saligna	B	\N	\N	WC, 70
4501	Sarcopotorum spinosum	\N	1	\N	70 GA-3
4502	Sarracenia alabamensis	\N	1	\N	40-70L
4503	Sarracenia alabamensis	B	\N	\N	40-70L
4504	Sarracenia flava	B	\N	\N	40-70L
4505	Sarracenia purpurea	B	\N	\N	40-70L
4506	Sarracenia sp.	B	\N	\N	40-70L
4507	Sassafras varifolium	\N	\N	2	OT
4508	Sassafras varifolium	\N	1	\N	no germ
4509	Sassafras varifolium	B	\N	\N	no germ
4510	Satureja discolor	B	\N	\N	70
4511	Satureja hortensis	B	\N	\N	70
4512	Satureja vulgaris	B	\N	\N	70L
4513	Sauromatum venosum	\N	1	\N	70
4514	Saxifraga aff. nanella	B	\N	\N	70L
4515	Saxifraga aizoides	\N	1	\N	70-40-70
4516	Saxifraga caesia	B	\N	\N	70D
4517	Saxifraga caespitosa	\N	1	\N	70 GA-3
4518	Saxifraga chrysantha	\N	\N	2	70L-40-70L
4519	Saxifraga cotyledon	\N	1	\N	70L
4520	Saxifraga flagellaris	B	\N	\N	70-40-70
4521	Saxifraga hirculus	B	\N	\N	40
4522	Saxifraga hostii	B	\N	\N	OT
4523	Saxifraga latiopetalaata	B	\N	\N	70
4524	Saxifraga nivalis	\N	1	\N	70L
4525	Saxifraga oppositifolia	\N	1	\N	70L-40-70L
4526	Saxifraga oppositifolia	B	\N	\N	70D GA-3
4527	Saxifraga paniculata	B	\N	\N	70
4528	Saxifraga sp.	B	\N	\N	70L
4529	Saxifraga spinulosa	B	\N	\N	70L
4530	Saxifraga stellaris	\N	1	\N	70 GA-3
4531	Saxifraga tricuspidata	B	\N	\N	70
4532	Scabiosa atropurpurea	\N	\N	2	55-85
4533	Scabiosa caucasica	B	\N	\N	70
4534	Scabiosa farinosa	\N	\N	2	DS 5 y = dead
4535	Scabiosa ochraleuca	\N	1	\N	70
4536	Scabiosa vestita	\N	1	\N	70L
4537	Schisandra chinensis	B	\N	\N	40-70
4538	Schivereckia doerfleri	\N	\N	2	40
4539	Schivereckia doerfleri	\N	1	\N	70D
4540	Schivereckia monticola	\N	\N	2	70D
4541	Schizanthus (disco hybrids)	B	\N	\N	70
4542	Schizanthus (hybrids)	\N	\N	2	70
4543	Schizanthus grahamii	B	\N	\N	70D
4544	Schizanthus hookeri	B	\N	\N	70D
4545	Schizopetalon walkeri	\N	\N	2	70
4546	Schizopetalon walkeri	\N	1	\N	70D
4547	Schizophragma integrifolium 	\N	\N	2	70L
4548	Schlumbergera truncata	\N	1c	\N	70 GA-3
4549	Schoenolirion bracteosa	B	\N	\N	40
4550	Sciadopitys verticillata	B	\N	\N	70
4551	Scilla bifolia	B	\N	\N	DS, 40-70-40
4552	Scilla campanulata	B	\N	\N	70-40
4553	Scilla chinensis	\N	\N	2	70D
4554	Scilla chinensis	\N	1	\N	70L
4555	Scilla hispanica	B	\N	\N	40
4556	Scilla natalensis	B	\N	\N	comment
4557	Scilla rosenii	B	\N	\N	40-70-40
4558	Scilla scilloides	B	\N	\N	70
4559	Scilla sibirica	B	\N	\N	70-40
4560	Scilla tubergeniana	B	\N	\N	70-40
4561	Scirpus holoschoenus	\N	\N	2	70L
4562	Scirpus holoschoenus	\N	1	\N	70L
4563	Scleranthus biflorus	\N	\N	2	40-70D-40-70D
4564	Scleranthus uniflorus 	\N	\N	2	70D
4565	Sclerocactus glaucus	\N	1c	\N	70 GA-3
4566	Sclerocactus nevadensis	\N	1c	\N	70 GA-3
4567	Sclerocactus parviflorus	\N	1c	\N	no germ
4568	Sclerocactus pubispinus	\N	1c	\N	70 GA-3
4569	Sclerocactus spinosior	\N	1c	\N	no germ
4570	Sclerocactus whipplei v. roseus	\N	1c	\N	70 GA-3
4571	Scoliopus bigelovii	B	\N	\N	70-40
4572	Scrophularia lanceolata	\N	1	\N	70 GA-3
4573	Scrophularia nodosa	\N	\N	2	comment
4574	Scrophularia nodosa	\N	1	\N	70L
4575	Scutellaria adeniostegia	B	\N	\N	70
4576	Scutellaria baicalensis	\N	1	\N	D-70
4577	Scutellaria elliptica	\N	1	\N	empty
4578	Scutellaria haematochlora	B	\N	\N	70
4579	Scutellaria integrifolia	\N	1	\N	70L
4580	Scutellaria integrifolia 	\N	\N	2	DS 2 y = dead
4581	Scutellaria intermedia	B	\N	\N	70
4582	Scutellaria laterifolia	\N	1	\N	D-70
4583	Scutellaria microdasys	B	\N	\N	70
4584	Scutellaria novae-zealandiae	\N	1	\N	70D-40-70
4585	Scutellaria novae-zealandiae	B	\N	\N	70D
4586	Scutellaria ovata	\N	1	\N	empty
4587	Scutellaria pontica	B	\N	\N	70
4588	Scutellaria resinosa	\N	\N	2	70D
4589	Scutellaria rubicunda	B	\N	\N	70
4590	Scutellaria subcaespitosa	B	\N	\N	70
4591	Securinega suffruticosa	B	\N	\N	70
4592	Sedum kamschaticum	B	\N	\N	70
4593	Sedum lanceolatum	B	\N	\N	70
4594	Sedum pilosum	\N	1	\N	70L
4595	Sedum pilosum	B	\N	\N	70L
4596	Sedum pulchellum	B	\N	\N	70L
4597	Sedum spectabile	B	\N	\N	70
4598	Sedum stelleforme	B	\N	\N	70
4599	Sedum subulatum	B	\N	\N	70
4600	Sedum telephioides	B	\N	\N	70D GA-3
4601	Sedum villosum	\N	1	\N	no germ
4602	Selenomeles lechleri	\N	\N	2	70D-40-70D
4603	Selinus tenuifolium 	B	\N	\N	70-40-70
4604	Semiaquilegia elcalcarata 	\N	\N	2	70 GA-3
4605	Sempervivum sp.	B	\N	\N	70L
4606	Senecio abrotanifolius	\N	1	\N	no germ
4607	Senecio abrotanifolius v. tirolensis	\N	1	\N	70
4608	Senecio aureus	\N	1	\N	70L
4609	Senecio cruentus	\N	\N	2	55-85
4610	Senecio harbouri	B	\N	\N	70D
4611	Senecio holmii	B	\N	\N	70D
4612	Senecio nudicaulis	B	\N	\N	70
4613	Sequoia gigantea	B	\N	\N	40-70
4614	Sequoiadendron giganteum	\N	1	\N	40-70D
4615	Sequoiadendron giganteum	B	\N	\N	70D
4616	Serenoa repens	\N	1	\N	70D
4617	Sesamum orientalis	\N	\N	2	70D
4618	Sesamum orientalis	\N	1	\N	70
4619	Sesbania tripetii	\N	\N	2	puncture, 70
4620	Sesbania tripetii	\N	1	\N	puncture, 70
4621	Sesbania triquetri	\N	1	\N	puncture, 70
4622	Seseli gummiferum	\N	\N	2	70
4623	Setaria glauca	Bg	\N	\N	70-40-70
4624	Setaria italica	\N	1	\N	70
4625	Seticereus icosagonus	\N	1c	\N	70 GA-3
4626	Shepherdia canadensis	\N	1	\N	70L-40-70D
4627	Shortia galacifolia	B	\N	\N	70L +
4628	Shortia soldanelloides	\N	1	\N	70D
4629	Shoshonea pulvinata	\N	1	\N	70D-40
4630	Sibbaldia procumbens	\N	1	\N	D-70L
4631	Sibbaldia procumbens	B	\N	\N	70L
4632	Sicyos angularis	B	\N	\N	WC 2 w, OT
4633	Sideritis hyssopifolia	B	\N	\N	70
4634	Silene acaulis	B	\N	\N	70
4635	Silene agraea	B	\N	\N	40-70
4636	Silene armeria	B	\N	\N	70L
4637	Silene californica	\N	1	\N	70
4638	Silene californica	B	\N	\N	70
4639	Silene californica 	\N	\N	2	70
4640	Silene caroliniana	\N	\N	2	70
4641	Silene caroliniana	\N	1	\N	70
4642	Silene caroliniana	B	\N	\N	OT
4643	Silene ciliata	B	\N	\N	70
4644	Silene colorata	\N	\N	2	70
4645	Silene colorata	\N	1	\N	70
4646	Silene compacta	B	\N	\N	70
4647	Silene delavayi	\N	1	\N	70
4648	Silene dioica	B	\N	\N	70-40-70
4649	Silene douglasii	B	\N	\N	70
4650	Silene elizabethae	B	\N	\N	70
4651	Silene gallica	\N	\N	2	comment
4652	Silene gallica	\N	1	\N	70L
4653	Silene guntensis	B	\N	\N	70
4654	Silene hookeri	B	\N	\N	70
4655	Silene keiskii	B	\N	\N	70
4656	Silene laciniata	\N	1	\N	70D
4657	Silene laciniata	B	\N	\N	70D
4658	Silene nutans	B	\N	\N	70
4659	Silene pendula	B	\N	\N	70D
4660	Silene pennsylvanica	B	\N	\N	OT
4661	Silene polypetala	B	\N	\N	70
4662	Silene pusilla	B	\N	\N	70
4663	Silene regia	B	\N	\N	70
4664	Silene ruprechti	B	\N	\N	70-40-70
4665	Silene saxatilis	B	\N	\N	70
4666	Silene saxifraga	B	\N	\N	70
4667	Silene schafta	\N	\N	2	DS 6 y = dead
4668	Silene schafta	B	\N	\N	70-40
4669	Silene sp.	B	\N	\N	70-40-70
4670	Silene uniflora	\N	1	\N	70 GA-3
4671	Silene uniflora 	\N	\N	2	DS 2 y = dead
4672	Silene vallesia	B	\N	\N	70
4673	Silene virginica	B	\N	\N	70-40-70-40-70
4674	Silybum marianum	\N	1	\N	D-70
4675	Sinningia speciosa	\N	\N	2	65L-85L
4676	Sisyrinchium angustifolium	B	\N	\N	70L
4677	Sisyrinchium bellum	B	\N	\N	OT
4678	Sisyrinchium campestre	B	\N	\N	OT
4679	Sisyrinchium demissum album	B	\N	\N	40-70L
4680	Sisyrinchium inflatum	\N	1	\N	40
4681	Sisyrinchium inflatum	B	\N	\N	40
4682	Sisyrinchium laetum	\N	\N	2	no germ
4683	Sisyrinchium littorale	\N	\N	2	70D-40
4684	Sisyrinchium mulcronatum	B	\N	\N	OT
4685	Skimmia japonica	B	\N	\N	WC, 40
4686	Smilacina racemosa 	B	\N	\N	DS, 40-70
4687	Smilax ecirrhata	B	\N	\N	DS, 70-40-70-40-OT
4688	Smilax ferox	B	\N	\N	70L
4689	Smyrnium perfoliatum	\N	1	\N	70L-40-70
4690	Solanum aculeatissimum	\N	1	\N	D-70
4691	Solanum capsicastrum	\N	1	\N	70
4692	Solanum dulcamara	\N	1	\N	70L
4693	Solanum dulcamara	B	\N	\N	WC 4 w, 70L
4694	Solanum melongena 	B	\N	\N	70L
4695	Solanum sisymbrifolium	\N	1	\N	70D
4696	Soldanella carpathica	\N	1	\N	70D
4697	Soldanella hungarica	B	\N	\N	70
4698	Soldanella montana	B	\N	\N	70
4699	Solidago caesia	B	\N	\N	40-70
4700	Solidago canadensis	B	\N	\N	DS, 70
4701	Solidago spathulata	B	\N	\N	70
4702	Sollya heterophylla	\N	1	\N	empty
4703	Sollya heterophylla 	\N	\N	2	70 GA-3
4704	Sophora japonica	\N	\N	2	green, 70D
4705	Sophora japonica 	B	\N	\N	puncture, 70
4706	Sophora microphylla	\N	1	\N	puncture, 70
4707	Sophora mollis	\N	\N	2	puncture, 70D
4708	Sophora moorcroftiana	B	\N	\N	70
4709	Sophora prostrata	\N	\N	2	puncture, 70D
4710	Sophora secundiflora	\N	\N	2	puncture, 70D
4711	Sophora tetraptera	\N	\N	2	puncture, 70D
4712	Sophora tomentosum	\N	1	\N	puncture, 70
4713	Sorbus americana	\N	\N	2	OT
4714	Sorbus aucuparia	\N	1	\N	OT
4715	Sorbus aucuparia	B	\N	\N	OT
4716	Sorbus caucasica	B	\N	\N	40-70
4717	Sparaxis (hybrids)	\N	1	\N	70D
4718	Spartium junceum	\N	\N	2	puncture, 70D
4719	Spathodea campanulata	\N	1	\N	70L
4720	Specularia speculum-veneris	\N	1	\N	70L
4721	Spergularia rubra	\N	\N	2	70L
4722	Spergularia rupicola	\N	\N	2	70L
4723	Spergularia rupicola	\N	1	\N	70L
4724	Sphaeralcea (Illimna) remota	\N	1	\N	puncture, 70
4725	Sphaeralcea ambigua	\N	\N	2	70L
4726	Sphaeralcea coccinea	B	\N	\N	puncture, 70
4727	Sphaeralcea grossolariaefolia	B	\N	\N	puncture, 70
4728	Sphaeralcea incana	\N	\N	2	70L
4729	Sphaeralcea incana	\N	1	\N	70L
4730	Sphaeralcea parvifolia	B	\N	\N	puncture, 70
4731	Spigelia marilandica	\N	\N	2	OT
4732	Spigelia marilandica	B	\N	\N	OT
4733	Spilanthes acmella	\N	1	\N	D-70
4734	Spiraea alba	B	\N	\N	70D
4735	Spiraea betulifolia	B	\N	\N	70L
4736	Spiraea canescens	B	\N	\N	70
4737	Spiraea japonica	B	\N	\N	70L
4738	Spiraea ulmaria	\N	1	\N	comment
4739	Spraguea umbellata	B	\N	\N	70D-40-70L
4740	Sprekelia formosissima	\N	\N	2	70D
4741	Stachys alpina	\N	\N	2	DS 1 y = dead
4742	Stachys alpina	\N	1	\N	70L
4743	Stachys lanata	\N	\N	2	70L
4744	Stachys macrantha	B	\N	\N	OT
4745	Stachys macrantha 	\N	\N	2	70D
4746	Stachys officinalis	\N	1	\N	D-70
4747	Stachyurus chinensis	\N	\N	2	70L-40-70L
4748	Stachyurus chinensis	\N	1	\N	70L-40-70L
4749	Stanleya pinnata	B	\N	\N	D-70
4750	Stapelia leendertzii	\N	\N	2	70
4751	Stapelia leendertzii	\N	1	\N	70
4752	Stellaria chamaejasme	B	\N	\N	70-40-70
4753	Stellaria media	\N	1	\N	D-70
4754	Stellera chamaejasme	\N	1	\N	comment - not stellaria
4755	Stenanthium occidentale	\N	\N	2	70
4756	Stenanthium occidentale	\N	1	\N	70
4757	Stenocereus griseus	\N	1c	\N	70 GA-3
4758	Stenocereus stellatus	\N	1c	\N	70 GA-3
4759	Stenocereus thurberi	\N	1c	\N	70 GA-3
4760	Stephanocereus leucostelie	\N	1c	\N	70 GA-3
4761	Stephanotis floribunda	\N	1	\N	70D
4762	Sternbergia candida	B	\N	\N	40-70-40-70-40-70-OT
4763	Stetsonia coryne	\N	1c	\N	70 GA-3
4764	Stewartia koreana	B	\N	\N	OT
4765	Stewartia pseudocamellia	B	\N	\N	OT
4766	Stipa capillata	Bg	\N	\N	D-70
4767	Stipa pennata	Bg	\N	\N	D-70
4768	Stirlingia latifolia	\N	\N	2	DS 3 y = dead
4769	Stokesia laevis	B	\N	\N	70
4770	Strangweia spicata	B	\N	\N	40
4771	Stransvaesia nitakaymensis	\N	1	\N	40-70D
4772	Strelitzia nicolae	\N	\N	2	comment
4773	Strelitzia nicolae	\N	1	\N	comment
4774	Strelitzia reginae	\N	\N	2	70D
4775	Strelitzia reginae	\N	1	\N	puncture, 70D
4776	Streptocarpus (hybrids)	\N	\N	2	60L-75L
4777	Streptopus rosea	\N	1	\N	70D-40-70D
4778	Strombocactus disciformis	\N	1c	\N	no germ
4779	Stylidium graminifolium	\N	1	\N	70L
4780	Stylomecon heterophylla	\N	\N	2	70D
4781	Stylomecon heterophylla	\N	1	\N	70D
4782	Stylophorum diphyllum	B	\N	\N	40-70-40-70
4783	Stylophorum lasiocarpum	B	\N	\N	OT
4784	Stypandra glauca	\N	1	\N	70L
4785	Styrax japonica	B	\N	\N	70-40-70-40-70
4786	Styrax obassia	\N	\N	2	40-70D
4787	Styrax obassia	\N	1	\N	no germ
4788	Styrax obassia	B	\N	\N	40-70
4789	Succisa inflexa	\N	1	\N	70L
4790	Succisa pratensis	\N	1	\N	70L
4791	Sulcorebutia totorensis lepida	\N	1c	\N	70 GA-3
4792	Sutherlandia frutescens prostrata	\N	\N	2	70D
4793	Sutherlandia montana	\N	\N	2	puncture, 70D
4794	Sutherlandia montana	\N	1	\N	70D
4795	Sutherlandia prostata	\N	\N	2	70D
4796	Sutherlandia sp.	\N	\N	2	puncture, 70D
4797	Swertia fedtschenkoana	B	\N	\N	OT
4798	Swertia marginata	B	\N	\N	OT
4799	Swertia perennis	B	\N	\N	70
4800	Swertia shugnanica	B	\N	\N	OT
4801	Symphoricarpos albus	\N	\N	2	no germ
4802	Symphoricarpos orbiculata	B	\N	\N	WC 7 d, 40-70-40-70-40-70-40-70
4803	Symphyandra hoffmannii	B	\N	\N	70-40-70
4804	Symphyandra tianschanica	B	\N	\N	70
4805	Symphyandra wanneri	B	\N	\N	70
4806	Symplocarpus foetidus	\N	1	\N	70L
4807	Symplocarpus foetidus	B	\N	\N	WC 7 d, 40-70-40-70
4808	Synnotia parviflora 	\N	\N	2	70D-40
4809	Synnotia variegata	\N	\N	2	70L-40
4810	Synnotia variegata metelerkampiae	\N	\N	2	40-70-40
4811	Synnotia villosa	\N	\N	2	70L-40
4812	Synthyris alpina (Bessya alpina)	\N	1	\N	70D-40-70D
4813	Synthyris pinnatifida	B	\N	\N	70-40-70
4814	Syringa amurensis	B	\N	\N	70
4815	Syringa pekinensis	B	\N	\N	70
4816	Syringa vulgaris	B	\N	\N	70
4817	Tacitus bellus	\N	\N	2	no germ
4818	Tagetes (hybrids)	\N	\N	2	70D
4819	Talinum brevifolium	\N	\N	2	70L
4820	Talinum calycinum	B	\N	\N	40-70
4821	Talinum okanoganense	B	\N	\N	40-70
4822	Talinum sp.	\N	\N	2	comment
4823	Talinum sp.	\N	1	\N	40-70
4824	Talinum sp.	B	\N	\N	40-70D
4825	Talinum spinescens	B	\N	\N	40-70
4826	Talinum teretifolium	B	\N	\N	40-70L
4827	Tamarindus indica	\N	\N	2	puncture, 70D
4828	Tamarindus indica	\N	1	\N	puncture, 70D
4829	Tamus communis	B	\N	\N	70-40-70
4830	Tanacetopsis subsincks	B	\N	\N	70
4831	Tanacetum capitatum	B	\N	\N	70
4832	Tanacetum dolichophyllum	B	\N	\N	70
4833	Tanacetum gracile	B	\N	\N	70-40-70-40-70
4834	Tanacetum parthenium	\N	1	\N	D-70
4835	Tanacetum sp.	B	\N	\N	70D
4836	Tanacetum turcomanicum	\N	1	\N	chaff
4837	Taraxacum officinale	B	\N	\N	70
4838	Taxodium distichum	B	\N	\N	40 1 m, 70
4839	Taxus baccata	\N	1	\N	comment
4840	Taxus baccata	B	\N	\N	WC 7 d, 70-40-70-40-70
4841	Tecoma stans	\N	\N	2	70
4842	Tecomaria capensis	\N	1	\N	70
4843	Teesdaliopsis conferta	\N	\N	2	70D
4844	Telephium imperati	\N	\N	2	no germ
4845	Telesonix jamesii	\N	\N	2	comment
4846	Telesonix jamesii	B	\N	\N	70L-40-70L
4847	Tellima alexanderi	\N	1	\N	70 GA-3
4848	Tellima articulatus	\N	1	\N	70 GA-3
4849	Tellima grandiflora	\N	1	\N	70 GA-3
4850	Tellima grandiflora	B	\N	\N	70L
4851	Tephrocactus alexanderi bruchii	\N	1c	\N	70 GA-3
4852	Tephrocactus articulatus (chilecito)	\N	1c	\N	70 GA-3
4853	Tephrocactus articulatus campana	\N	1c	\N	70 GA-3
4854	Tephrocactus rauhii	\N	1c	\N	no germ
4855	Tephrocactus 't.a.b. pomen'	\N	1c	\N	70 GA-3
4856	Tephrosia virginiana	\N	1	\N	comment
4857	Tephrosia virginiana	B	\N	\N	puncture, 70
4858	Tetragonolobus maritimus	\N	1	\N	puncture, 70
4859	Teucrium sp.	B	\N	\N	70D
4860	Thalictrum aquilegifolium	B	\N	\N	70
4861	Thalictrum dioicum	B	\N	\N	70 GA-3
4862	Thalictrum kemense	B	\N	\N	40-70
4863	Thalictrum lucidum	\N	1	\N	70 GA-3
4864	Thalictrum minus	\N	1	\N	70 GA-3
4865	Thalictrum petaloideum	B	\N	\N	70
4866	Thalictrum rochebrunianum	\N	1	\N	70 GA-3
4867	Thalictrum rochebrunianum	B	\N	\N	70 GA-3
4868	Thalictrum sp.	B	\N	\N	70
4869	Thalictrum speciosissimum	B	\N	\N	40
4870	Thalictrum tuberiferum	\N	1	\N	OT
4871	Thalictrum tuberiferum	B	\N	\N	70 GA-3
4872	Thalictrum tuberosum	B	\N	\N	40-70
4873	Thalictrum uchiyamai	B	\N	\N	70
4874	Thaspium trifoliatum	\N	1	\N	70
4875	Thelocactus bicolor	\N	1c	\N	70 GA-3
4876	Thelocactus conothele	\N	1c	\N	70
4877	Thelocactus hexaedrophorus 	\N	1c	\N	70
4878	Thelocactus leucacanthus schmollii	\N	1c	\N	70 GA-3
4879	Thelocactus tulensis	\N	1c	\N	no germ
4880	Thermopsis alpina	B	\N	\N	puncture, 70
4881	Thermopsis alternifolia	B	\N	\N	puncture, 70
4882	Thermopsis caroliniana	\N	1	\N	comment
4883	Thermopsis caroliniana	B	\N	\N	scarify, 70
4884	Theropogon pallidos	B	\N	\N	70
4885	Thespesia populaea	\N	1	\N	puncture, 70
4886	Thlaspi bulbosum	B	\N	\N	70
4887	Thlaspi montanum	B	\N	\N	70
4888	Thlaspi rotundifolia	B	\N	\N	70
4889	Thlaspi stylosum	B	\N	\N	70
4890	Thomasia quercifolia	\N	\N	2	70D
4891	Thrixanthocereus blossfeldiorum	\N	1c	\N	70 GA-3
4892	Thrysostachys siamensis	\N	\N	2	70D
4893	Thuja occidentalis	\N	1	\N	70D
4894	Thuja occidentalis	B	\N	\N	70
4895	Thunbergia alaga	\N	\N	2	55-85
4896	Thunbergia alata	\N	1	\N	70
4897	Thymus incertus	B	\N	\N	70
4898	Thymus vulgare	B	\N	\N	70
4899	Thysanotus multiflorus	\N	1	\N	70 GA-3
4900	Tiarella cordifolia	B	\N	\N	70L
4901	Tiarella wherryi	B	\N	\N	70D-40-70L
4902	Tibouchina grandiflora	\N	\N	2	70L
4903	Tibouchina grandiflora	\N	1	\N	70L
4904	Tigridia pavonia	B	\N	\N	70L
4905	Tilia americanum	B	\N	\N	comment
4906	Tilia cordata	B	\N	\N	OT
4907	Tilingia tachiroei	\N	\N	2	70D-40-70D
4908	Tillandsia sp.	\N	\N	2	no germ
4909	Tofieldia pusilla	\N	1	\N	70L
4910	Torenia (hybrids)	\N	\N	2	70D
4911	Toumeya papyracantha	\N	1c	\N	70 GA-3
4912	Townsendia eximia	B	\N	\N	70
4913	Townsendia exscapa	B	\N	\N	70
4914	Townsendia florifer	B	\N	\N	70
4915	Townsendia formosa	B	\N	\N	70
4916	Townsendia glabella	B	\N	\N	70
4917	Townsendia grandiflora	B	\N	\N	70
4918	Townsendia hirsuta	B	\N	\N	70
4919	Townsendia hookeri	B	\N	\N	70
4920	Townsendia incana	B	\N	\N	70
4921	Townsendia mensana	B	\N	\N	70
4922	Townsendia montana	B	\N	\N	70
4923	Townsendia parryi	B	\N	\N	D-70
4924	Townsendia rothrockii	B	\N	\N	70
4925	Townsendia sericea	B	\N	\N	70
4926	Townsendia sp.	B	\N	\N	70
4927	Townsendia tomentosa	B	\N	\N	70
4928	Townsendia wilcoxiana	B	\N	\N	70
4929	Trachelium caeruleum	\N	\N	2	70L
4930	Trachelium rumelicum	B	\N	\N	70L
4931	Trachymene caerulea	\N	\N	2	70L
4932	Trachymene caerulea	\N	1	\N	70L
4933	Trachyspermum ammi	\N	\N	2	70D
4934	Trachyspermum ammi	\N	1	\N	70D
4935	Tradescantia bracteata	\N	1	\N	40-70D
4936	Tradescantia longipes	B	\N	\N	40-70
4937	Tribeles australis	\N	\N	2	no germ
4938	Trichocereus bridgesii	\N	1c	\N	70 GA-3
4939	Trichocereus bruchii nivalis	\N	1c	\N	70 GA-3
4940	Trichocereus formosus	\N	1c	\N	70
4941	Trichocereus pachanoi	\N	1c	\N	70 GA-3
4942	Trichophorum alpinum	\N	1	\N	70L
4943	Trichosanthes cuspidata	B	\N	\N	70
4944	Trichostema dichotomum	\N	1	\N	70L-40-70L
4945	Trichostema dichotomum	B	\N	\N	70D GA-3
4946	Trichostema setaceum	B	\N	\N	OT
4947	Tricyrtis affinis	B	\N	\N	70L
4948	Tricyrtis bakeri	B	\N	\N	70L
4949	Tricyrtis dilitata	B	\N	\N	70L-40-70L
4950	Tricyrtis flava	B	\N	\N	70L
4951	Tricyrtis formosana	B	\N	\N	70L
4952	Tricyrtis hirta	B	\N	\N	40-70L
4953	Tricyrtis hirta alba	B	\N	\N	40-70L
4954	Tricyrtis latifolia	B	\N	\N	40-70L
4955	Tricyrtis macrantha	B	\N	\N	OT
4956	Tricyrtis macropoda	B	\N	\N	40-70L
4957	Tricyrtis nana	B	\N	\N	40-70L
4958	Tricyrtis perfoliata	B	\N	\N	70L
4959	Tricyrtis pilosa	B	\N	\N	40-70
4960	Tricyrtis puberula	B	\N	\N	70L-40-70L
4961	Tricyrtis stolonifera	B	\N	\N	70L-40-70L
4962	Trifolium dasyphyllum	B	\N	\N	70
4963	Trifolium pratense	B	\N	\N	70D
4964	Trifolium repens	\N	1	\N	puncture, 70D
4965	Trifolium virginiana	B	\N	\N	70
4966	Trifurcia lahue caerulea	\N	\N	2	70L
4967	Triglochin maritima	\N	1	\N	70L
4968	Trigonella foenum-graecum	\N	1	\N	D-70
4969	Trillidium govianum	B	\N	\N	70-OT-70D GA-3 40-70D
4970	Trillium albidum	\N	1	\N	70D-40-70D
4971	Trillium albidum	B	\N	\N	40-70
4972	Trillium apetalon	\N	1	\N	70 GA-3 40
4973	Trillium chloropetalum	\N	1	\N	40-70
4974	Trillium erectum	\N	1	\N	40-70 GA-3
4975	Trillium erectum	B	\N	\N	OT 4 y, 70 GA-3
4976	Trillium erectum alba	\N	1	\N	40-70 GA-3
4977	Trillium flexipes	\N	1	\N	comment
4978	Trillium flexipes	B	\N	\N	OT 2 y, 70 GA-3
4979	Trillium grandiflorum	\N	\N	2	comment
4980	Trillium grandiflorum	\N	1	\N	comment
4981	Trillium grandiflorum	B	\N	\N	70 GA-3
4982	Trillium grandiflorum roseum	\N	1	\N	comment
4983	Trillium kamschaticum	\N	1	\N	40-70
4984	Trillium luteum	\N	1	\N	comment
4985	Trillium luteum	B	\N	\N	70 GA-3
4986	Trillium nivale	\N	1	\N	40-70
4987	Trillium nivale	B	\N	\N	40-70-40-70-40-70-40
4988	Trillium ovatum	\N	1	\N	comment
4989	Trillium ovatum	B	\N	\N	70D
4990	Trillium pusillum	\N	1	\N	70 GA-3
4991	Trillium pusillum	B	\N	\N	40-70-40-70-40
4992	Trillium recurvatum	\N	1	\N	40-70 GA-3
4993	Trillium rugeli	\N	1	\N	40-70 GA-3
4994	Trillium tschonoski	\N	1	\N	70 GA-3
4995	Trillium tschonoski	B	\N	\N	70 GA-3
4996	Trillium undulatum	\N	\N	2	70D
4997	Trillium vaseyi	\N	1	\N	40-70 GA-3
4998	Trillium vaseyi	B	\N	\N	WC 3 w, 40-70
4999	Triosteum perfoliatum	\N	\N	2	no germ
5000	Triosteum perfoliatum	\N	1	\N	no germ
5001	Tripetaleia paniculata	\N	\N	2	70L
5002	Tripterocalyx cyclopetris	\N	1	\N	no germ
5003	Triteleia laxa	\N	\N	2	DS 4 y = dead
5004	Triteleia laxa	B	\N	\N	40
5005	Tritoma (hybrids)	B	\N	\N	70D
5006	Tritonia crocea	\N	1	\N	70D
5007	Trochodendron aralioides	\N	1	\N	70L
5008	Trollium pumilus	\N	\N	2	DS 3 y = dead
5009	Trollius acaulis	B	\N	\N	40-70
5010	Trollius altissimus	B	\N	\N	OT
5011	Trollius asiaticus	B	\N	\N	OT
5012	Trollius chinensis	B	\N	\N	40
5013	Trollius dschungaricus	B	\N	\N	OT
5014	Trollius laxus	B	\N	\N	OT
5015	Trollius laxus 	\N	1	\N	comment
5016	Trollius ledebouri	B	\N	\N	OT
5017	Trollius pumilus	B	\N	\N	OT
5018	Tropaeolum  azureum 	B	\N	\N	70 4 w, 40
5019	Tropaeolum azureum	\N	\N	2	40
5020	Tropaeolum major	\N	\N	2	70D
5021	Tropaeolum minus	\N	1	\N	D-70
5022	Tropaeolum pentaphyllum	\N	1	\N	70D-40-40-70D
5023	Tropaeolum polyphyllum	B	\N	\N	70 4 w, 40
5024	Tropaeolum sessilifolium	B	\N	\N	70 4 w, 40
5025	Tropaeolum speciosum	\N	1	\N	70D-40-70D-40
5026	Tsuga canadensis	\N	1	\N	70D-40-70
5027	Tsuga canadensis	B	\N	\N	40-70
5028	Tuberaria lignosa	\N	\N	2	70D
5029	Tulbaghia galpinii	\N	1	\N	70D
5030	Tulipa chrysantha	\N	1	\N	70D-40
5031	Tulipa clusiana	B	\N	\N	70-40
5032	Tulipa sp.	B	\N	\N	40
5033	Tulipa sprengeri	\N	1	\N	40-70-40-70-40
5034	Tulipa stellata	B	\N	\N	40
5035	Tulipa tarda	B	\N	\N	40-70
5036	Tulipa turkestanica	B	\N	\N	40-70
5037	Turbinocarpus lophophoroides	\N	1c	\N	70 GA-3
5038	Turbinocarpus polaskii	\N	1c	\N	70 GA-3
5039	Turricula parryi	\N	1	\N	70 GA-3
5040	Tussilago farfara	B	\N	\N	70
5041	Tussilago sp.	\N	\N	2	DS 4 w = dead
5042	Typha latifolia	B	\N	\N	70L
5043	Typha latifolia	B	\N	\N	70L
5044	Uebelmannia gummifera	\N	1c	\N	70 GA-3
5045	Ulmus glabra	B	\N	\N	70
5046	Umbilicus rupestris	B	\N	\N	70
5047	Uncinia (Ursinia) rubra	\N	\N	2	70D-40-70D
5048	Uncinia (Ursinia) uncinnata	\N	\N	2	chaff
5049	Ungernia victoris	B	\N	\N	70
5050	Ungnadia speciosa	\N	1	\N	OS
5051	Urginea secunda	\N	\N	2	70D
5052	Urospermum delechampii	\N	\N	2	chaff
5053	Urtica membranacea	\N	1	\N	40
5054	Urtica piculifera	\N	1	\N	70L
5055	Uvularia grandiflora	B	\N	\N	OT
5056	Vaccaria hispanica	\N	\N	2	rotted
5057	Vaccaria hispanica	\N	1	\N	40
5058	Vaccaria pyrimidata	\N	\N	2	70D
5059	Vaccaria pyrimidata	\N	1	\N	70D
5060	Vaccinium globulare	\N	1	\N	70L
5061	Vaccinium macrocarpum	\N	1	\N	70L
5062	Vaccinium macrocarpum	B	\N	\N	70L
5063	Vaccinium myrtillus	\N	1	\N	70L
5064	Vaccinium nummularia	B	\N	\N	70
5065	Vaccinium uliginosum	\N	1	\N	40-70D
5066	Vaccinium vitis-idaea	\N	1	\N	70L
5067	Valeriana officinalis	\N	1	\N	comment
5068	Vatricania guentheri	\N	1c	\N	70 GA-3
5069	Veltheimia bracteata	\N	\N	2	70D
5070	Veltheimia bracteata	\N	1	\N	70D
5071	Veratrum californicum	\N	1	\N	70 GA-3
5072	Veratrum californicum	B	\N	\N	70-40-70
5073	Verbascum blattaria	\N	1	\N	70L
5074	Verbascum blattaria	B	\N	\N	70L
5075	Verbascum bombyciferum	\N	1	\N	70L
5076	Verbascum chaixi album	\N	1	\N	70L
5077	Verbascum nigrum	\N	1	\N	70L
5078	Verbascum nigrum album	\N	1	\N	70L
5079	Verbascum olympicum	\N	1	\N	70L
5080	Verbascum phoeniceum	\N	1	\N	70L
5081	Verbascum phoeniceum	B	\N	\N	70
5082	Verbascum thapsus	\N	1	\N	70L
5083	Verbena (quartz hybrids)	\N	\N	2	70L
5084	Verbena (wings hybrids)	\N	\N	2	70L
5085	Verbena hastata	B	\N	\N	40-70L
5086	Verbena macdouglii	\N	1	\N	70
5087	Verbena macdouglii	\N	\N	2	70L
5088	Vernonia altissima	\N	1	\N	70 GA-3
5089	Vernonia novaboracencis	B	\N	\N	40-70D
5090	Veronica aphylla	B	\N	\N	40
5091	Veronica bellidioides	B	\N	\N	70L
5092	Veronica caespitosa	B	\N	\N	40-70
5093	Veronica fruticans	\N	\N	2	DS 1 y = dead
5094	Veronica fruticans	\N	1	\N	40-70D
5095	Veronica fruticulosa	B	\N	\N	40
5096	Veronica nipponica	B	\N	\N	70
5097	Veronica nummularia	B	\N	\N	70L
5098	Veronica ponae	B	\N	\N	70L
5099	Veronica serpyllifolia	\N	1	\N	40-70L
5100	Veronica tauricola	B	\N	\N	70
5101	Veronicastrum virginica	\N	1	\N	70L
5102	Veronicastrum virginica 	\N	\N	2	70L
5103	Verticordia aff. ovalifolia	\N	\N	2	DS 3 y = dead
5104	Verticordia chrysantha v. preissii	\N	\N	2	DS 3 y = dead
5105	Vestia foetida	\N	1	\N	70
5106	Vestia lycioiodes  ?	\N	1	\N	70L
5107	Viburnum acerifolium	B	\N	\N	WC 7 d, 40-70-40-70-40
5108	Viburnum burkwoodi	B	\N	\N	WC 7 d, 40-70
5109	Viburnum carlesi	\N	1	\N	WC 7 d, 70D-40-70D
5110	Viburnum dentatum	B	\N	\N	WC 7 d, 70-40-70-40-70
5111	Viburnum dilatatum	B	\N	\N	WC 7 d, 70-40-70-40-70
5112	Viburnum lantana	B	\N	\N	WC 7 d, 40-70-40-70
5113	Viburnum opulis	B	\N	\N	WC 7 d, 70-40-70-40
5114	Viburnum prunifolium	B	\N	\N	WC 5 w, 40-70-40
5115	Viburnum rhytidophyllum	B	\N	\N	WC 7 d, 40-70-40-70
5116	Viburnum sargenti	\N	1	\N	WC 7 d, 70
5117	Viburnum sargenti	B	\N	\N	WC 7 d, 70
5118	Viburnum setigerum	\N	\N	2	70 GA-3 - 40
5119	Viburnum setigerum	B	\N	\N	WC 7 d, 70-40-70-40-70-40
5120	Viburnum sieboldi	B	\N	\N	WC 7 d, 70-40-70-40
5121	Viburnum tomentosum	B	\N	\N	WC 7 d, 70-40-70
5122	Viburnum trifolium	\N	1	\N	WC 7 d, 40-70
5123	Viburnum trifolium	B	\N	\N	WC 7 d, 70 GA-3
5124	Viburnum trilobum	\N	1	\N	WC 7 d, 70D-40-70
5125	Vicia americana	B	\N	\N	puncture, 70
5126	Vicia cracca	\N	\N	2	puncture, 70D
5127	Vicia cracca	\N	1	\N	puncture, 70D
5128	Vicia cracca	B	\N	\N	70
5129	Viguiera porteri	\N	\N	2	40
5130	Viguiera porteri	\N	1	\N	70
5131	Vinca rosea	\N	\N	2	70D
5132	Vincatoxicum hirundinaria	\N	\N	2	DS 3 y = dead
5133	Vincatoxicum hirundinaria	\N	1	\N	70 GA-3
5134	Vincatoxicum nigrum	\N	\N	2	DS 4 y = dead
5135	Vincatoxicum nigrum	\N	1	\N	70 GA-3
5136	Viola adunca	\N	1	\N	70 GA-3
5137	Viola aff. rosulata	\N	\N	2	rotted
5138	Viola altaica	B	\N	\N	70
5139	Viola appalachiensis	B	\N	\N	OT
5140	Viola arborescens 	\N	\N	2	70 GA-3
5141	Viola biflora	B	\N	\N	rotted
5142	Viola canadensis	B	\N	\N	OT
5143	Viola canina	\N	1	\N	70 GA-3
5144	Viola cornuta	B	\N	\N	70D
5145	Viola coronifera	\N	\N	2	rotted
5146	Viola cotyledon	\N	\N	2	rotted
5147	Viola cucullata	B	\N	\N	70D GA-3
5148	Viola cuneata	\N	1	\N	70 GA-3
5149	Viola dactyloides	B	\N	\N	70L
5150	Viola dasyphylla	\N	\N	2	rotted
5151	Viola delphinantha	B	\N	\N	rotted
5152	Viola fimbriatula	B	\N	\N	70D GA-3
5153	Viola fluehmannii	\N	\N	2	rotted
5154	Viola glabella	\N	1	\N	70 GA-3
5155	Viola incisa	B	\N	\N	70L
5156	Viola labradorica	B	\N	\N	70L
5157	Viola maculata	\N	\N	2	rotted
5158	Viola montana	B	\N	\N	70L-40-70L
5159	Viola nuttallii	\N	1	\N	40
5160	Viola odorata	\N	\N	2	70 GA-3
5161	Viola palmata	B	\N	\N	OT
5162	Viola papilonacea	B	\N	\N	OT
5163	Viola pedatifida	B	\N	\N	OT
5164	Viola philippii	\N	\N	2	rotted
5165	Viola pubescens	B	\N	\N	70D GA-3
5166	Viola rugulosa	B	\N	\N	OT-70L
5167	Viola sagittata	B	\N	\N	OT
5168	Viola sheltoni	B	\N	\N	40
5169	Viola sororia alba	B	\N	\N	70-40-70
5170	Viola sp. (rosulate)	B	\N	\N	40 GA-3
5171	Viola striata	B	\N	\N	OT
5172	Viola tricolor	B	\N	\N	70L
5173	Viola tricolor (hybrids)	\N	\N	2	OS 40-70L
5174	Vitaliana (Douglasia) primuliflora	\N	1	\N	70D
5175	Vitaliana primuliflora	\N	\N	2	70D
5176	Vitex agnus-castus	\N	\N	2	70D-40-70D-40-70D-40-70D-40-70D
5177	Vitex agnus-castus	\N	1	\N	70L
5178	Vitis vinifera	B	\N	\N	WC, 70-40-70
5179	Vitis vulpina 	B	\N	\N	40-70
5180	Wachendorfia thrysiflora	\N	1	\N	70L
5181	Wahlenbergia congesta	\N	\N	2	40-70L
5182	Wahlenbergia congesta	\N	1	\N	70L
5183	Wahlenbergia congesta (hybrids)	\N	\N	2	40-70L
5184	Wahlenbergia gloriosa	\N	1	\N	70D
5185	Wahlenbergia gloriosa 	\N	\N	2	40-70L
5186	Wahlenbergia saxicola	\N	\N	2	40-70L
5187	Wahlenbergia sp.	\N	\N	2	70L
5188	Wahlenbergia trichogyna	\N	\N	2	70
5189	Waitzia citrina	\N	\N	2	chaff
5190	Waldheimia glabra	B	\N	\N	70
5191	Waldheimia stoliczkai	B	\N	\N	70
5192	Waldheimia tomentosa	B	\N	\N	70
5193	Waldsteinia fragrarioides	B	\N	\N	70L
5194	Washingtonia filifera	\N	1	\N	comment
5195	Washingtonia filifera	B	\N	\N	puncture, 70
5196	Watsonia beatricis	\N	\N	2	70D
5197	Watsonia beatricis	\N	1	\N	70D
5198	Watsonia sp.	\N	\N	2	70
5199	Watsonia sp.	\N	1	\N	70D
5200	Weberbauerocereus johnsonii	\N	1c	\N	70 GA-3
5201	Weigelia florida	B	\N	\N	70L
5202	Weingartia hediniana	\N	1c	\N	70 GA-3
5203	Weingartia longigipba	\N	1c	\N	70 GA-3
5204	Wisteria sinensis	B	\N	\N	70
5205	Withania somnifera	\N	\N	2	comment
5206	Withania somnifera	\N	1	\N	70L
5207	Wulfenia carinthiaca	B	\N	\N	70L
5208	Wyethia amplexicaulis	B	\N	\N	40-70
5209	Wyethia arizonica	B	\N	\N	70D GA-3
5210	Wyethia helianthoides	B	\N	\N	40-70
5211	Xanthoceras sorbifolium	\N	\N	2	70D
5212	Xanthoceras sorbifolium	\N	1	\N	70
5213	Xeranthemum annuum	B	\N	\N	70D
5214	Xeronema callistemon	B	\N	\N	40-70
5215	Xerophyllum asphodeloides	B	\N	\N	OT
5216	Xerophyllum tenax	\N	\N	2	rotted
5217	Xylanthemum pamiricum	B	\N	\N	70D
5218	Yucca filamentosa	B	\N	\N	70
5219	Yucca glauca	B	\N	\N	70
5220	Yucca navajoa	B	\N	\N	70D
5221	Yucca whipplei	B	\N	\N	70
5222	Zaluzianskya capensis	\N	\N	2	70
5223	Zaluzianskya capensis	B	\N	\N	70
5224	Zantedeschia ethiopeca	\N	1	\N	extract, 70D
5225	Zantedeschia ethiopeca	B	\N	\N	extract, WC, 70D
5226	Zauschneria arizonica	B	\N	\N	40
5227	Zauschneria garrettii	B	\N	\N	40
5228	Zea mays	\N	1	\N	70D
5229	Zea sp.	\N	\N	2	70D
5230	Zenobia pulverulenta	\N	\N	2	empty
5231	Zephyra 	\N	\N	2	comment
5232	Zephyra minima	\N	1	\N	70D
5233	Zephyranthes atamasco	B	\N	\N	70
5234	Zephyranthes rosea	B	\N	\N	70
5235	Zigadenus elegans	B	\N	\N	70
5236	Zigadenus fremonti	B	\N	\N	40
5237	Zinnia elegans	\N	\N	2	70
5238	Zizania aquatica	\N	1	\N	OT
5239	Zizia aptera	\N	1	\N	70L
5240	Zizia aurea	B	\N	\N	70D GA-3
5241	Ziziphora bungeana	B	\N	\N	70
5242	Zizyphus jujuba	\N	1	\N	no germ
5243	Zygocactus truncatus	\N	1c	\N	70
5244	Zygophyllum atriplicoides	\N	1	\N	70 GA-3
\.


--
-- Data for Name: taxa; Type: TABLE DATA; Schema: deno; Owner: gastil
--

COPY deno.taxa (taxon) FROM stdin;
Abeliophyllum distichum
Abies alba
Abies amabilis
Abies boris-regis
Abies cephalonica
Abies cilicica
Abies equi-trojani
Abies fabri
Abies firma
Abies holophylla
Abies koreana
Abies nephrolepsiis
Abies nordmanniana
Abies pindrow
Abies recurvata
Abies religiosa
Abies veitchii
Abronia fragrans
Abronia villosa
Abutilon (hybrids)
Abutilon theophrasti
Abutilon vitifolium
Acacia cyanophylla
Acacia dealbata
Acacia iteophylla
Acaena anserinifolia
Acaena caesiiglauca
Acaena inermis
Acaena microphylla
Acaena nova-zelandiae
Acaena saccaticupula
Acaena splendens
Acanthocalycium peitscherianum
Acanthocalycium spiniflorum
Acanthocalycium violaceum
Acantholimon araxanum
Acantholimon armenum
Acantholimon bracteatum
Acantholimon caryophyllaceum
Acantholimon diapensoides
Acantholimon glumaceum
Acantholimon hedinum
Acantholimon hilariae
Acantholimon litvinovii
Acantholimon pamiricum
Acantholimon parviflorum
Acantholimon pterostegium
Acantholimon puberulum
Acantholimon pulchellum
Acantholimon raddeanum
Acantholimon reflexifolium
Acantholimon spirizianum
Acantholimon ulcinum
Acantholimon vedicum
Acantholimon velutinum
Acantholimon venustum
Acanthophyllum glandulosum
Acanthophyllum gypsophiloides
Acanthophyllum macrocephalum
Acanthophyllum pungens
Acanthophyllum shugnanicum
Acanthophyllum sordidum
Acanthus balcanicus
Acanthus mollis
Acer buergerianum
Acer crataegifolium
Acer ginnala v. aidzvense
Acer ginnala
Acer griseum
Acer heldreichii
Acer japonicum
Acer negundo
Acer nikoense
Acer pennsylvanicum
Acer platanoides
Acer pseudoplatanus 
Acer pseudoplatanus
Acer pseudosieboldiana
Acer rubrum
Acer saccharinum
Acer saccharum
Acer semenovii
Acer spicatum 
Acer tataricum
Acer truncatum
Achillea millefolium
Achlys triphylla 
Acidanthera bicolor
Acinos alpinus
Aciphylla aurea
Aciphylla dobsonii
Aciphylla hectori
Aciphylla monroi
Ackama roseifolia
Acnistus australis
Aconitum ajanense
Aconitum apetalum
Aconitum ferox
Aconitum firmum
Aconitum heterophyllum
Aconitum lycoctorum
Aconitum macrostynchium
Aconitum napellus
Aconitum nasutum
Aconitum orientale
Aconitum pubiceps
Aconitum raddeanum
Aconitum variagatum
Aconitum volubile
Aconitum vulparia
Aconitum wilsoni
Actaea erythrocarpa
Actaea pachypoda
Actaea rubra
Actaea spicata
Actinidia chinensis
Actinomeris alternifolia
Actinotus helianthii
Adenium obesum
Adenophora farreri
Adenophora koreana
Adenophora kurilensis
Adenophora lilifolia
Adenophora potanini
Adenophora tashiroi
Adenostoma facsiculatum
Adlumia fungosa
Adonis aestivalis
Adonis amurensis
Adonis brevistylis
Adonis chrysocyathus
Adonis pyrenaica
Adonis turkestanica
Adonis vernalis
Aeniopsis cabolica
Aeonium simsii
Aeonium tabuliforme
Aesculus discolor
Aesculus glabra
Aesculus hippocastanum
Aesculus octandra
Aesculus parviflora serotina
Aesculus parviflora
Aesculus pavia
Aesculus sylvatica
Aesculus turbinata tomentosa (A. chinensis)
Aesculus turbinata
Aesculus x carnea
Aethephyllum pinnatifidum
Aethionema grandiflorum
Aethiopsis cabolica
Agalinis setacea
Agapanthus africanus
Agastache anisata
Agastache foeniculum
Agastache fragrans
Agastache nepetoides
Agastache occidentalis
Agastache scrophulariaefolia
Agastache urticifolium
Agathosma ovata
Agave (Manfreda) virginica
Ageratina occidentale
Ageratum sp.
Agrimonia eupatoria
Agrophyron pubiflorum
Agrophyron scabrum
Agrostemma githago
Agrostemma tinicola
Agrostocrinum scabrum
Aichryson divaricatum
Ailanthus altissima
Ajania tibetica
Ajuga chamaepitys
Akebia quinata
Alangium platanifolium
Albizzia julibrissin
Albuca aurea 
Albuca aurea
Albuca canadensis
Albuca humilis
Albuca longifolia
Albuca shawii
Albuca sp.
Alcea ficifolia
Alcea rosea
Alchemilla alpina
Alchemilla faeronensis
Alchemilla mollis
Alchemilla saxatilis
Alchemilla vulgaris
Aletes humilis
Aletris farinosa
Alisma plantago-aquatica
Allardia tridactylites
Allium aff. farreri
Allium alba
Allium albopilosum
Allium azureum
Allium cernuum
Allium christophii
Allium falcifolium
Allium flavum
Allium giganteum
Allium goodingii
Allium karataviense
Allium moly
Allium pulchellum 
Allium pulchellum
Allium schubertii
Allium tanguticum
Allium tricoccum
Allium unifolium
Allium vulgaris
Alnus crispa
Alnus glutinosa
Alnus hirsuta v. hirsuta
Alnus japonica
Alnus maritima
Alnus rugosa
Alnus serrulata
Alonsoa linearis
Alonsoa meridionalis
Alonsoa warscewiczii
Alophia drummondi
Alophia lahue
Alstroemeria (hybrids)
Alstroemeria aurantiaca
Alstroemeria aurea
Alstroemeria garaventae
Alstroemeria haemantha
Alstroemeria ligtu
Alstroemeria pallida
Alstroemeria sp.
Alstroemeria umbellata
Althaea hirsuta
Althaea officinalis 
Althaea rosea
Alyssoides utriculata
Alyssum saxatile
Alyssum sp.
Amaranthus caudatus
Amaranthus cruentus
Amaranthus hypochondriacus
Ambrosia mexicana
Amelanchier alnifolia 
Amelanchier canadensis
Amelanchier grandiflora
Amelanchier laevis
Amelanchier sanguinea
Amelanchier stolonifera
Amethystia caerulea
Ammi majus
Ammi visnaga
Amorpha fruticosa
Amsonia jonesii
Amsonia montana
Amsonia tabernaemontana
Amsonia tomentosa
Anacampseros ruffescens
Anacyclus depressus
Anagallis arvensis
Anagallis linifolia
Anaphalis triplinervis
Anaphalis virgata
Anchusa angutissima
Anchusa azurea 
Anchusa azurea
Anchusa officinalis
Ancistrocactus brevinamatus
Ancistrocactus scheeri
Androcymbium rechingeri
Androcymbium striatum
Andropogon gerardii
Andropogon scoparia
Androsace alpina
Androsace armeniaca
Androsace barbulata
Androsace carnea
Androsace chamaejasme ssp. carinata
Androsace charpentieri
Androsace cylindrica
Androsace elongata
Androsace geraniifolia
Androsace hedreantha
Androsace kochii ssp. tauricola
Androsace lactea
Androsace lanuginosa
Androsace mucronifolia
Androsace multiscapa
Androsace muscoides
Androsace obtusifolia
Androsace rotundifolia
Androsace sempervivoides
Androsace septentrionalis
Androsace sericea
Androsace spinulifera
Androsace studiosorum
Androsace vandellii
Androsace villosa v. congesta
Androsace villosa
Androstephium breviflorum
Andryala agardhii
Anelsonia eurycarpa
Anemonastrum fasculatum v. roseum
Anemonastrum protractum
Anemonastrum speciosum
Anemone altaica
Anemone baicalensis
Anemone baldensis
Anemone biamiensis
Anemone biflora
Anemone blanda
Anemone caucasica
Anemone crinita
Anemone cylindrica
Anemone demissa
Anemone drummondi
Anemone fasciculata
Anemone fasciculatum v. roseum
Anemone japonica
Anemone kurilensis
Anemone lesseri
Anemone loesseri rubra
Anemone magellanica
Anemone multifida
Anemone narcissiflora 'zephyra'
Anemone narcissiflora
Anemone nemorosa
Anemone obtusiloba
Anemone occidentalis
Anemone palmata
Anemone pavoniana
Anemone polyanthes
Anemone ranunculoides 
Anemone ranunculoides
Anemone rivularis
Anemone rupicola
Anemone sylvestris
Anemone tetonensis
Anemone tetrasepala
Anemone vitifolia
Anemonella thalictroides
Anemonopsis macrophylla
Anethum graveolens
Angelica archangelica
Angelica gigas
Angelica grayi
Anigozanthos falvidus
Anigozanthos flavidus
Anigozanthos manglesii
Anisodontea capensis 
Anisotome aromatica
Anisotome haastii
Annona cherimola
Annona cherimosa
Anoda sp.
Anthemis montana
Anthericum liliago
Anthericum racemosum
Anthericum torreyi
Anthriscus cerefolium
Anthyllis montana
Anthyllis vulneraria
Antigon leptopus
Antirrhinum major
Antirrhinum majus
Aphananthe aspersa
Apium graveolens
Aquilegia akitensis
Aquilegia atravinosa
Aquilegia barnebyi
Aquilegia canadensis
Aquilegia chrysantha
Aquilegia coerulea
Aquilegia discolor
Aquilegia elegantula
Aquilegia eximia
Aquilegia flabellata nana
Aquilegia flavescens
Aquilegia formosa
Aquilegia fragrans
Aquilegia japonica
Aquilegia jonesii x saximontana
Aquilegia jonesii
Aquilegia jucunda
Aquilegia laramiensis
Aquilegia micrantha
Aquilegia olympica
Aquilegia pyrenaica
Aquilegia saximontana
Aquilegia scopulorum
Aquilegia skinneri
Aquilegia sp. (Darwas)
Aquilegia tridentata
Aquilegia vulgaris
Arabis albida
Arabis alpina
Arabis bellidifolia
Arabis blepharophylla
Arabis petraea
Arabis pumila
Arabis purpurea
Aralia californica
Aralia elata
Aralia hispida
Aralia nudicaulis
Aralia racemosa
Araujia seridifera
Arbutus menziesii
Arctium lappa
Arctomecon californica
Arctomecon humilis
Arctostaphylos columbiana x uva-ursi
Arctostaphylos crustacea
Arctostaphylos nevadensis
Arctostaphylos patula
Arctostaphylos pungens
Arctostaphylos uva-ursi
Ardisia crenata
Ardisia crispa
Arenaria caroliniana
Arenaria hookeri
Arenaria kingii
Arenaria norvegica
Arenaria polaris
Arenaria procera
Arenaria pseudoacantholimon
Arenaria purpurescens
Arenaria saxosa
Arenaria stricta
Arenaria tmolea
Arequipa erectocylindrica
Arequipa sp. 'tachna'
Arequipa weingartiana
Arethusa bulbosa
Argemone grandiflora
Argemone hispida
Argemone munita
Argemone pleicantha
Argylia adscendens
Argylia potentillifolia
Argylia sp.
Argyranthemum sp.
Argyreia nervosa
Argyroderma congregatum
Ariocarpus agavoides
Ariocarpus kotschoubeyanus
Ariocarpus retusus
Ariocarpus trigonus
Arisaema amurense
Arisaema consanguineum
Arisaema dracontium
Arisaema flavum
Arisaema jacquemonti
Arisaema nepenthioides
Arisaema quinata
Arisaema quinquifolium
Arisaema sikokianum
Arisaema thunbergii
Arisaema tortuosum
Arisaema triphyllum
Aristea ecklonii
Aristolochia baetica
Aristolochia macrophylla
Aristolochia serpentaria
Aristotelia fruticosa x serrata
Armataocereus matulanensis
Armenaica sibirica
Armeria caespitosa
Armeria corsica
Armeria maritima
Armeria tweedyi
Arnebia echioides
Arnebia euchroma
Arnica frigida
Arnica montana
Aronia arbutifolia
Aronia melanocarpa
Artemesia pamirica
Artemisia caucasica
Artemisia frigida
Artemisia pamirica
Arthropodium cirrhatum 
Arthropodium cirrhatum
Arum concinnatum
Arum cyrenaicum
Arum dioscoridis
Arum italicum
Arum maculatum
Arum nigrum
Aruncus dioicus
Aruncus sylvestris
Asarina barclaiana
Asarina procumbens
Asarina purpusii
Asarum canadensis
Asarum europaeus
Asclepias cordifolia
Asclepias cryptoceras
Asclepias erosa
Asclepias incarnata
Asclepias phytolaccoides
Asclepias quadrifolia
Asclepias speciosa
Asclepias syriacus
Asclepias tuberosa
Asclepias viridiflorus
Asimina triloba
Asparagus officinalis
Asparagus sprengeri
Asperula arvensis
Asperula orientalis
Asperula pontica
Asperula tinctoria
Asphodeline brevicaulis
Asphodeline liburnica
Asphodeline lutea
Asphodeline microcarpus
Asphodelus aestivus
Asphodelus albus
Asphodelus cerasiferus
Asphodelus fistulosus
Asphodelus luteus
Asphodelus microcarpus
Asphodelus ramosus
Astelboides
Astelia nervosa
Aster alpellus
Aster alpigenus v haydenii
Aster alpinus
Aster bigelovii
Aster brachytrichus
Aster coloradoensis
Aster ericoides
Aster farreri
Aster himalaicus
Aster likiangensis
Aster nova-anglae
Aster oblongifolius
Aster sibirica
Aster tibeticus
Asteromoa mongolica
Astilbe biternata
Astilbe chinensis
Astilboides tabularis
Astragalus glycyphyllos
Astragalus membranaceous
Astragalus sp.
Astragalus whitneyi
Astrantia carniolica rubra
Astrantia involucrata
Astrantia major 
Astrantia major
Astrantia minor
Astrophytum asterias
Astrophytum capricorne crassispinum
Astrophytum coahuilense
Astrophytum x 'sen-as'
Asyneuma limoniflium
Asyneuma limonifolium
Athamanta turbith
Atractyloides japonica
Atriplex canescens
Atriplex hymenolytra 
Atriplex longipes
Atropa belladonna
Aubrieta deltoides
Aubrietia grandiflora
Aucuba japonica
Aureolaria virginica
Austrocactus bertinii 'patagonicus'
Austrocactus bertinii
Austrocylindropuntia floccosa
Austrocylindropuntia haematacantha
Austrocylindropuntia inarmata
Austrocylindropuntia shaferi
Austrocylindropuntia weingartiana
Averrhoa carambola
Azorina vidallii
Aztekium ritteri
Babiana dregei
Babiana tubulosa
Baeometra uniflora 
Ballota pseudodictamnus
Balsamorhiza hookeri
Balsamorhiza sagitatta
Bambusa arundinacea
Banksia integrifolia
Banksia prionotes
Banksia sp.
Baptisia australis
Baptisia leucophaea
Baptisia viridis
Barbarea rupicola
Barbarea sp.
Barbarea vulgaris variegata
Barbarea vulgaris
Barleria obtusa
Bartsia alpina 
Bauhinia monandra
Bauhinia purpurea
Baumea articulata
Begonia dioica
Begonia evansiana
Begonia hirta
Begonia picta
Begonia semperflorens
Begonia suffruticosa
Begonia tuber hybrida
Belamcanda chinensis
Bellevalia dubia
Bellevalia pycnantha
Bellevalia romana
Bensoniella oregona
Berardia subacaulis
Berberis julianae
Berberis sphaerocarpa
Berberis thunbergii
Bergenia ciliata
Berlandiera lyrata
Bertholletia excelsa
Berzelia galpinii
Berzelia lanuginosa
Berzelia rubra
Beschorneria bracteata
Beschorneria yuccoides
Bessya alpina
Beta vulgare
Betula delavayi
Betula ermanii
Betula glandulosa
Betula lenta
Betula lutea
Betula nana
Betula pendula
Betula platyphylla japonica
Betula populifolia
Betula pubescens
Betula tianschanica
Bidens ferrucaefolia
Billardiera longiflora 
Billardiera longiflora fructoalba
Biscutella coronopifolia
Bitium
Bixa orellana
Blackstonia perfoliata
Blephilia hirsuta
Bloomeria crocea
Blossfelldia iliputana
Boenninghausenia albiflora
Bolboschoenus caldwellii
Bolboschoenus fluviatilis
Bomarea sp.
Bombax malabaricum
Bongardia sp.
Borago officinalis
Boronia ledifolia
Boronia megastigma
Bouteloua curtipendula
Bouteloua gracilis
Boykinia aconitifolia
Brachiaria dictyoneura 
Brachiaria dictyoneura
Brachycome iberidifolia
Brachyglottis bellidioides
Brassica olearaceae
Braya alpina
Briggsia aurantiaca
Brimeura amethystina 
Brimeura amethystina alba
Brimeura amethystina
Brimeura pulchella
Briza maxima
Brodiae congesta
Brodiae douglasii
Brodiae pulchella
Brodiaea laxa
Bromus macrostachys
Broussonetia papyrifera
Browallia sp.
Browningia candelaris
Bruckenthalia spiculifolia
Brugmansia suaveolens
Brunia laevis
Brunia stokei
Buddleia davidii
Buddleia globosa
Buiningia aurea
Buiningia brevicylindrica
Bulbine annua
Bulbine bulbosa
Bulbine caulescens
Bulbine frutescens
Bulbine glauca
Bulbine semibarbata
Bulbinella hookeri
Bulbocodium vernum
Bupleurum aureum
Bupleurum longifolium
Bupleurum ranunculoides
Bupleurum rotundifolium 
Bupleurum rotundifolium
Bupleurum spinosum
Butia capitata v. odorata
Butia capitata
Butomus umbellatus
Caesalpina pulcherrima
Caesalpinia pulcherrima
Cajanus cajon
Cajophora acuminata
Cajophora coronata
Cajophora laterita
Calamagrostis acutiflora
Calandrinia acutisepala
Calandrinia caespitosa
Calandrinia grandiflora
Calandrinia umbellata
Calastrus scandens
Calceolaria (annual hybrids)
Calceolaria falklandica
Calendula officinalis
Callianthemum sp.
Callicarpa dichotoma
Callicarpa japonica
Callistemon sp.
Callistemon speciosus 
Callistemon speciosus
Callistephus chinensis
Callitris canescens
Callitris rhomboidea
Calluna vulgaris
Calochortus aureus
Calochortus gunnisonii
Calochortus kennedyi
Calochortus sp.
Calonycton aculeatum
Caloscordum neriniflorum
Calothamnus quadrifidus
Caltha biflora
Caltha leptosepala
Caltha palustris
Calycanthus floridus
Calycocarpum lyoni
Calydorea amabilis
Calydorea nuda
Calydorea pallens
Calydorea speciosa
Calydorea xiphioides
Calylophus lavandulifolius
Calyptridium monospermum
Calyptridium umbellatum
Camassia leichtlinii v. suksdorfii
Camassia leichtlinii
Campanula (annuals)
Campanula alliarifolia
Campanula allioni
Campanula alpina
Campanula altaica
Campanula americana
Campanula aucheri
Campanula barbata
Campanula bellidifolia
Campanula betulaefolia
Campanula caespitosa
Campanula carpathica
Campanula carpatica alba
Campanula cashmeriana
Campanula cenisia
Campanula chamissonii
Campanula cochlearifolia
Campanula collina
Campanula coriacea
Campanula finitima
Campanula formanekiana
Campanula garganica
Campanula glomerata acaulis
Campanula glomerata
Campanula gracilis
Campanula hawkinsiana
Campanula incurva
Campanula jenkinsae
Campanula latifolia alba
Campanula latifolia
Campanula latiloba
Campanula linearifolia
Campanula linifolia
Campanula longistyla
Campanula lyrata
Campanula medium
Campanula moesica
Campanula napuligera
Campanula ossetica
Campanula pallida
Campanula persicifolia
Campanula pilosa
Campanula pulla
Campanula punctata
Campanula pyramidalis
Campanula raddeana
Campanula ramosissima
Campanula rapunculoides
Campanula rotundifolia
Campanula sarmakadensis
Campanula sarmatica
Campanula saxifraga
Campanula scabrella
Campanula scheuzeri
Campanula shetleri
Campanula sibirica
Campanula spicata
Campanula steveni
Campanula takesimana
Campanula taurica
Campanula thrysoides
Campanula trautvetteri
Campanula tridentata
Campsis radicans
Canna indica
Cannabis sativa
Capparis spinosa 
Capparis spinosa
Capsicum annuum
Capsicum frutescens
Capsicus pubescens
Cardamine pennsylvanica
Cardiocrinum cordatum v. glehnii
Cardiocrinum giganteum
Cardiospermum halicacabum
Carex arenaria
Carex comans
Carex grayi
Carex lurida
Carex muskingumensis
Carex pendula
Carex retrorsa
Carex secta
Carex stricta
Carica papaya
Carlina acaulis
Carmichaelia apressa
Carmichaelia monroi
Carnegia gigantea
Carpentaria californica
Carrica papaya
Carthamus tinctorious
Carum caryi
Carya sp.
Caryopteris incana
Cassiope fastigiata
Castanea sativa
Castanea sinensis
Castillea parviflora
Castilleja integra
Castilleja miniata
Castilleja parviflora
Castilleja rhexifolia
Castilleja sp. 
Casuarina sp.
Catalpa bignonioides
Catharanthus roseus
Caulophyllum thalictroides
Cautleya spicata
Ceanothus americana
Cedrela sinensis
Cedrus atlantica
Celmisia armstrongii
Celmisia dallii
Celmisia monroi
Celmisia semicordata
Celmisia spectabilis
Celmisia traversii
Celosia argentea
Celtis tenuifolia 
Centaurea maculosa
Centaurium erythraea
Centaurium meyeri
Centaurium muhlenbergii
Centaurium pulchellum
Centaurium scilloides
Centranthus ruber
Cephalanthus occidentalis
Cephalaria gigantea
Cephalaria leucantha
Cephalocereus alensis
Cephalocereus royenii
Cephalocereus senilis
Cerastium alpinum
Cerastium bossieri
Cerastium candidissimum
Cerastium fontanum
Cerastium maximum
Cerastium montanum
Cerastium uniflorum
Ceratotheca triloba
Cercidiphyllum japonicum
Cercis canadensis alba
Cercis chinensis
Cercocarpus betuloides
Cercocarpus intricatus
Cereus aethiops
Cereus validus
Cerinthe major
Cestrum nocturnum
Chaenactis douglasii
Chaenomeles japonica
Chaenomeles sinensis
Chaenorrhinum oreganifolium
Chaerophyllum hirsutum
Chamaebatia millefolium 
Chamaebatia millefolium
Chamaechaenactis scaposa
Chamaecytisus austriacus
Chamaedaphne calyculata
Chamaelirium luteum
Chamaemelum nobile
Chamaespartium sagitate
Chasmanthe floribunda
Cheiranthus cheiri
Chelidonium majus
Chelone glabra
Chenopodium (Bitium) virgatum
Chenopodium ambrosiodes
Chenopodium bonus
Chenopodium virgatum
Chenopodium vulvaria
Chenopodium vulvularia
Chiastophyllum oppositifolia
Chiliotrichum amelloides
Chilopsis linearis
Chimonanthus praecox
Chionanthus virginica
Chionochloa rubra
Chionodoxa luciliae
Chloranthus sp.
Chlorogalum pomeridianum
Chordospartium muritai
Chrysanthemum cinerarifolium
Chrysanthemum djilgense
Chrysanthemum koreanum
Chrysanthemum leucanthemum 
Chrysanthemum pyrethroides
Chrysopsis villosa
Cicer arietinum
Cicerbita alpina
Cichorum intybus
Cimicifuga racemosa
Circaea lutetiana
Cissus striata
Cistus laurifolius
Citrofortunella mitis
Citrullus vulgaris
Citrus nobilis
Cladastris lutea
Cladothamnus pyroliflorus
Clarkia amoena
Clarkia elegans
Claytonia megarhiza
Claytonia virginica
Cleistocactus aureispinus
Cleistocactus baumannii
Cleistocactus smaragdiflorus
Clematis addisonii
Clematis albicoma v. coactilis
Clematis alpina
Clematis coactilis
Clematis columbiana
Clematis connata
Clematis crispa
Clematis forsteri
Clematis grata
Clematis hirsutissima
Clematis integrifolia
Clematis ladakhiana
Clematis lanuginosa
Clematis maculata
Clematis occidentalis
Clematis orientalis
Clematis pitcheri
Clematis recta
Clematis rehderiana
Clematis sp.
Clematis vernayi
Clematis verticillata
Clematis viorna
Clematis virginiana
Cleome hassleriana
Cleome serrulata
Clethra alnifolia
Clethra fargesii
Clianthus formosa
Clianthus formosus
Clianthus puniceus 
Clianthus puniceus alba
Clintonia andrewsiana
Clintonia borealis
Clintonia umbellata
Clitoria ternatea
Clivia miniata
Cneorum tricoccon
Cnicus benedictus
Cobaea scandens
Coccoloba uvifera
Cocculus carolinus 
Cochlearia alpina
Cochlearia officinalis
Codonopsis clematidea
Codonopsis ovata
Codonopsis pilosula
Codonopsis viridis
Coffea arabica
Colchicum autumnale
Colchicum luteum
Coleocephalocereus goebelianus
Coleus frederici
Coleus plumosa
Collinsia bicolor
Collinsonia canadensis
Collomia cavanillesii
Collomia debilis
Collomia grandiflora
Collomia involucrata
Collomia sp.
Colutea arborescens
Colutea hyb. media
Coluteocarpus vesicaria
Commelina dianthifolia
Conanthera bifolia
Conimitella williamsii
Conospermum taxifolium
Convallaria majalis
Convolvus compactus
Convolvus lineatus ssp. angustifolius
Convolvus sp.
Convolvus tricolor
Copiapoa barquitensis
Copiapoa bridgesii
Copiapoa humilis
Copiapoa hypogaea
Copiapoa magnifica 
Copiapoa tenuissima
Coprosma acerosa
Coprosma atropurpurea
Coprosma petriel
Coprosma rhamnoides
Cordyline indivisa
Cordyline pumilio
Coreopsis lanceolata
Coriandrum sativum
Coriaria terminalis xanthocarpa
Coriaria terminalis
Cornus alternifolia
Cornus amomum
Cornus canadensis
Cornus florida
Cornus kousa
Cornus mas
Cornus nuttallii
Cornus racemosa
Cornus siberica
Cornus stolonifera
Cornus suecica
Corokia cotoneaster
Coronilla varia
Correa aquae-gelidae
Correa cordifolia
Corryocactus tarijensis
Corryocactus urmiriensis
Cortusa matthioli
Cortusa turkestanica
Corydalis caseana ssp. brandegei
Corydalis cheilanthifolia
Corydalis lutea
Corydalis nobile
Corydalis sempervirens
Corylopsis pauciflora
Corylopsis spicata
Corylus avellana
Corylus cornuta
Coryphantha echinoides
Coryphantha palmeri
Coryphantha vivipara
Cosmos bipinnatus
Costus guanaiensis
Cotinus coggyria
Cotoneaster acutifolia
Cotoneaster apiculata
Cotoneaster dammeri
Cotoneaster depressa
Cotoneaster divaricata
Cotoneaster horizontalis
Cotoneaster integerrimus
Cotoneaster microphyllus v. cochleatus
Cotoneaster microphyllus
Cotoneaster zagelii
Cotyledon orbiculata
Cowania mexicana
Crambe cordifolia
Crambe maritima
Craspedia incana
Crataegus coccinea
Crataegus cordata
Crataegus crus-galli
Crataegus flava
Crataegus mollis
Crataegus monogyna
Crataegus oxycantha
Crataegus phaenopyrum
Crataegus punctata
Crataegus rotundifolia
Cremanthodium arnicoides
Cremanthodium ellisii
Crepis sibiricus
Crinodendron hookerianum
Criscoma coma-aurea
Crocosmia aurea 
Crocosmia aurea
Crocus speciosus
Crocus tomasinianus
Croton alabamensis
Crowea angustifolia v. dentata
Crowea angustifolia
Cruckshanksia glacialis
Cruckshanksia hymenodon
Cryptantha paradoxa 
Cryptantha paradoxa
Cryptantha thompsonii
Cryptotaenia japonica atropurpurea 
Cucumis melo
Cucurbita maxima
Cucurbita melo
Cucurbita mixta
Cucurbita pepo
Cucurbita sativus
Cumarinia odorata
Cuminium cyminum
Cunninghamia lanceolata
Cuphea ignea
Cuphea llavea
Cuphea petiolata
Cupressus lusitanica
Cupressus macrocarpa
Cuscuta sp.
Cyananthus lobatus
Cyananthus sp.
Cyathodes empetrifolia
Cyathodes robusta
Cyclamen neapolitanum
Cyclamen persicum
Cymbalaria muralis
Cymopteris aboriginism
Cymopteris sp.
Cymopteris terebinthinus
Cynanchum acutum
Cynoglossum amabile
Cynoglossum grande
Cypella amosa
Cypella coelestis
Cyperus alternifolium
Cyperus papyrus
Cyphomandia betacea
Cypripedium acaule
Cypripedium andrewsii
Cypripedium calceolus
Cypripedium candidum
Cypripedium reginae
Cyrtanthus parviflorus
Cythomandra betacea 
Cythomandra betacea
Cytisus scoparius
Daboecia cantabrica
Dahlia (dwarf hybrids)
Dalea sp.
Daphne caucasicum
Daphne cneorum
Daphne genkwa
Daphne giraldi
Daphne mezereum alba
Daphne mezereum
Daphne oleoides
Darlingtonia californica
Darwinia citriodora
Datura innoxia
Datura metaloides
Datura sanguinea
Datura sp.
Datura stramonium
Datura suaveolens
Datura tatula
Daubenya aurea
Daucus carota v. sativus
Daucus carota
Davidia involucrata
Decaisnea fargesii
Degenia velebitica
Deinanthe bifida
Delonix regia
Delosperma cooperi
Delphinium belladonna
Delphinium bicolor
Delphinium cashmerianum
Delphinium consolida
Delphinium elatum
Delphinium exaltatum
Delphinium geraniifolium
Delphinium geyeri
Delphinium glaucum
Delphinium grandiflorum
Delphinium lipskyi
Delphinium oreophilum
Delphinium oxysepalum
Delphinium tatsiense
Delphinium tennuisectum
Delphinium tricorne
Delphinium virescens
Delphinium xantholeucum
Dendranthema arctica
Dendrocalamus asper
Dendrocalamus membranaceous
Dendrocalamus strictus
Dendromecon rigida
Denmoza rhodacantha
Dentaria hexaphylla
Dentaria lacinata
Dentaria laciniata
Dentaria pentaphylla
Desfontainea spinosa
Desmanthus illinoensis
Desmodium canadense
Deutzia staminea
Dianella intermedia
Dianthus alpinus
Dianthus armeria
Dianthus barbatus
Dianthus broteri
Dianthus carthusianorum
Dianthus caryophyllus
Dianthus chinensis
Dianthus crinitus
Dianthus darwasica
Dianthus erinaceus
Dianthus fragrans
Dianthus frigidus
Dianthus glacialis
Dianthus gratianopolitanus
Dianthus haematocalyx
Dianthus knappii
Dianthus leptopetalus
Dianthus myrtinervis
Dianthus neglectus
Dianthus pancici
Dianthus repens
Dianthus sequieri
Dianthus spiculifolius
Dianthus superbus alba
Diascia barberae
Dicentra citrina
Dicentra cucullaria
Dicentra eximia
Dicentra scandens
Dicentra spectabilis
Dicentra uniflora
Dichelostemma capitatum
Dichelostemma ida-maia
Dichelostemma multiflorum 
Dichelostemma multiflorum
Dicranostigma franchetianum
Dictamnus alba
Dictyolimon macrorrhabdos
Dierama pulcherrima
Dietes grandiflora 
Dietes grandiflora
Dietes indioides 
Digitalis grandiflora
Digitalis lutea 
Digitalis purpurea
Digitalis viridiflora 
Dimorphotheca aurantiaca 
Dimorphotheca aurantiaca
Dionea muscipula
Dionysia involucrata
Dioscorea battatus
Dioscorea quaternata
Dioscorea villosa
Diospyros rhomboidalis
Diospyros texana
Diospyros virginiana
Dipcadi fulvum
Dipcadi serotinum 
Dipcadi serotinum
Dipcadi viride
Diphylleia cymosa
Diplacus bifidus
Diplarrhena latifolia 
Diplarrhena moraea
Dipsacus fullonum
Dipsacus pilosus
Dipsacus strigosus
Dipsacus sylvestris
Dirca palustris
Discaria toumatou
Disocactus alteolens
Disocactus boomianus
Disocactus crystallophilus
Disocactus pugionacanthus
Disporum hookerianum v. trachyandrum
Disporum lanuginosum
Dodecatheon alpinum
Dodecatheon amethystinum
Dodecatheon jeffreyi
Dodecatheon media
Dodecatheon pulchellum 
Dodecatheon pulchellum
Dodonea viscosa 
Doligloglottis schorzeneroides
Doronicum caucasicum
Doronicum columnae
Doronicum orientale
Dorotheanthus bellidiformis
Dorotheanthus rourkei
Dorycnium rectum
Douglasia laeviagata
Douglasia nivalis
Draba acaulis
Draba aizoon
Draba argyrea
Draba brunifolia
Draba compacta
Draba cretica
Draba dedeana
Draba densifolia
Draba hoppeana
Draba incerta
Draba lasiocarpa
Draba lemmonii
Draba parnassica
Draba polytricha
Draba sartori
Draba ventosa
Dracocephalum renati
Dracocephalum tanguticum
Dracophyllum uniflorum
Dracunculus canariensis
Dracunculus vulgaris
Draperia systyla
Drosera aliciae
Drosera angelica
Drosera binata v. multifida
Drosera binata
Drosera burkeana
Drosera capensis
Drosera spathulata
Dryandra formosa
Dryandra serra
Dryas octapetala
Dryas sundermannii
Drymophila cyanocarpa
Duchesnea indica
Dudleya brittonii
Dudleya cymosa
Dudleya pachyphytum
Dyosma versipelle
Eccremocarpus scaber
Echinacea angustifolia
Echinacea purpurea
Echinocactus horizonthalonius
Echinocactus ingens
Echinocactus platyacanthus
Echinocactus texensis
Echinocereus baileyi
Echinocereus engelmanni v. chrysocentrus
Echinocereus engelmanni
Echinocereus fendleri
Echinocereus ferreiranus
Echinocereus pectinatus 
Echinocereus pectinatus (hybrids)
Echinocereus pectinatus v. wenigeri
Echinocereus pectinatus
Echinocereus reichenbachii v. albispinus
Echinocereus reichenbachii v. baileyi
Echinocereus reichenbachii v. caespitosus
Echinocereus reichenbachii v. perbellus 
Echinocereus reichenbachii v. perbellus
Echinocereus reichenbachii
Echinocereus spinigemmatus
Echinocereus triglochidiatus v. mojavensis
Echinocereus triglochidiatus
Echinocereus viridiflorus
Echinocereus x roetteri
Echinocystis lobata
Echinofossulocactus dichroacanthus
Echinofossulocactus erectocentrus
Echinofossulocactus heteracanthus
Echinofossulocactus zacatecasensis
Echinomastus dasyacanthus
Echinomastus laui
Echinops sphaerocephalum
Echinopsis ancistrophora hamatacantha
Echinopsis mirabilis
Echinopsis rhodotricha
Echinopsis tapecuna tropica
Echioides longiflorum
Edraianthus dalmaticus
Edraianthus graminifolius
Edraianthus pumilio
Edraianthus tennuifolius
Ehretia anacua
Elaeagnus angustifolia
Eleaganus angustifolia
Eleaganus umbellata
Eleagnus angustifolia
Eleocharas sphacelata
Eleusine coracana
Elmera racemosa 
Elmera racemosa
Embothrium coccineum
Eminium regelii
Empetrum nigrum
Enceliopsis nudicaule
Engelmannia pinnatifida
Enkianthus campanulatus
Ennealophus euryandus
Ephedra fedtschenkoi
Ephedra intermedia
Ephedra minima
Ephedra minuta
Epigea repens
Epilobium anagallidifolium
Epilobium angustifolium
Epilobium latifolium
Epilobium palustris
Epilobium rigidum
Epilobium tasmanicum
Epimedum colchicum
Epimedum pinnatum
Epithelantha micromeris
Epostoa mirabilis
Epostoa nana
Eranthis hyemalis
Erdisia quadrangularis
Eremophila aricantha
Eremophila cuneifolia
Eremophila eriocalyx
Eremophila laanii
Eremophila longifolia
Eremophila macdonaldii
Eremophila maculata
Eremophila
Eremostachys speciosa 
Eremurus altaica
Eremurus robustus
Eremurus stenocalyx
Eriastrum densifolium v. austromontanum
Erigenia bulbosa
Erigeron alpinus
Erigeron aurantiacus
Erigeron compositus
Erigeron eatoni
Erigeron elegantulus
Erigeron flabellifolius 
Erigeron flagellaris
Erigeron flettii
Erigeron fremonti
Erigeron glabellus
Erigeron leimoerus
Erigeron nanus
Erigeron pinnatisectus
Erigeron sp.
Erigeron speciosus
Erigeron subtrinervis
Erigeron trifidus
Erigeron uniflorus
Erigeron villarsii
Erinus alpinus alba
Erinus alpinus
Eriocereus jusbertii
Eriogonum allenii
Eriogonum bicolor
Eriogonum brevicaule ssp. oredense
Eriogonum caespitosum
Eriogonum compositum
Eriogonum douglasii
Eriogonum ericifolium v. pulchrum
Eriogonum flavum v. xanthum
Eriogonum flavum
Eriogonum morifolium
Eriogonum niveum
Eriogonum ovalifolium v. depressum
Eriogonum shockleyi
Eriogonum sphaerocephalum
Eriogonum strictum ssp. proliferum
Eriogonum thymoides
Eriogonum tumulosum
Eriogonum umbellatum
Eriophorum angustifolium
Eriophorum scheuzeri
Eriophyllum lanatum
Eriostemon myoporoides
Eriosyce ceratistes
Eriosyce ihotzkyana 
Eriosyce ihotzkyana
Eriosyce sandillon
Eritrichum howardi
Eritrichum rupestre v. pectinatum
Ermannia papyroides
Eryngium agavifolium
Eryngium alpinum
Eryngium planum
Eryngium yuccifolium
Erysimum kotschyanum
Erysimum nivale
Erysimum perofskianum
Erythrina crista-galli
Erythronium americanum
Erythronium citrinum
Erythronium grandiflorum
Erythronium hendersoni
Erythronium hendersonii x citrinum
Erythronium mesochorum
Erythronium revolutum
Erythronium sibiricum
Eschscholzia californica
Escobaria minima
Escobaria vivipara
Escontria chiotilla
Eucalyptus doratoxlyn
Eucalyptus leucoxlyn
Euceliopsis covellei
Eucomis bicolor
Eucomis pole-evansii
Eucomis zambesiaca
Eucryphia glutinosa
Eulychnia acida
Eulychnia castanea
Eunomia oppositifolia
Euonymus alatus
Euonymus atropurpurea
Euonymus bungeana
Euonymus europaeus
Euonymus phellomanus
Euonymus radicans
Eupatorium coelestinum
Eupatorium perfoliatum
Eupatorium purpureum
Eupatorium urticaefolium
Euphorbia aristata
Euphorbia francheti
Euphorbia myrsinites 
Euphorbia myrsinites
Euphorbia polychroma
Euphorbia pulcherrima
Euphorbia wulfenii
Eustoma
Evodia daniellii
Exacum affine
Exocarpos sparteus
Exochorda grandiflora
Fallugia paradoxa
Fatsia sp.
Fedia cornucopiae
Feijoa sellowiana
Ferocactus acanthoides
Ferocactus gracilis
Ferocactus wislizenii
Ferraria crispa
Ferula sp.
Festuca glauca
Festuca mairei
Festuca novae-zealandiae
Festuca ovina
Fibigia clypeata
Ficus carica 
Ficus carica
Filipendula ulmaria
Foeniculum vulgare
Forskohlea angustifolia
Forstera bidwillii
Forsythia suspensa
Fortunella crassifolia
Fortunella sp.
Fouquieria spendens
Fragraria chiloensis
Frailea alacriportana fulvispina
Frailea aureinitens
Frailea gracillima
Frailea grahliama
Frailea lepida 
Francoa appendiculata
Francoa ramosa
Francoa sonchifolia 
Francoa sp.
Frankenia thymifolia
Franklinia alatahama
Frasera albicaulis
Frasera fastigiata
Frasera speciosa
Fraxinus americana
Fraxinus anomala
Fraxinus cuspidata
Fraxinus excelsior
Fraxinus lanceolata
Fraxinus mandschurica
Fraxinus nigra
Fraxinus oxycarpa
Fraxinus pennsylvanica
Fraxinus quadrangulata  
Fraxinus quandrangulata
Fraxinus syriaca
Freesia (hybrids)
Fremontodendron californicum
Fritillaria acmopetala
Fritillaria armena
Fritillaria aurea
Fritillaria carica
Fritillaria forbsii
Fritillaria gantneri
Fritillaria glauca
Fritillaria graeca v. thessalica
Fritillaria graeca
Fritillaria imperialis 
Fritillaria imperialis
Fritillaria kurdica
Fritillaria lanceolata
Fritillaria meleagris
Fritillaria michaelowskii
Fritillaria pallida
Fritillaria pallidiflora
Fritillaria persica
Fritillaria pluriflora
Fritillaria pontica
Fritillaria pudica
Fritillaria pyrenaica
Fritillaria raddeana
Fritillaria recurva
Fritillaria sp.
Fritillaria thunbergii
Fritillaria tubiformis
Fritillaria ussuriensis
Fumana viridis
Fumaria officinalis
Fuschia (hybrids)
Gagea sp.
Gahnia clarkei
Gahnia sieberiana
Gaillardia aristata
Galanthus elwesii
Galanthus nivalis
Galax urceolata
Galega officinalis
Galeopsis speciosa
Galtonia candicans
Gamocheta nivalis
Gardenia jasminoides 
Gaultheria depressa
Gaultheria hispida
Gaultheria procumbens
Gaultheria shallon
Gaultheria trichophylla
Gaura biennis
Gaura coccinea
Gaura lindheimeri
Gazania (hybrids)
Geissorhiza aspera
Geissorhiza fulva
Geissorhiza inequalis
Geissorhiza juncea
Geissorhiza monantha
Geissorhiza rochensis spithamaea
Geissorhiza rochensis
Geissorhiza secunda
Geissorhiza splendissima
Gelasine azurea
Genista subcapitata
Gentiana acaulis
Gentiana affinis
Gentiana asclepiadea rosea
Gentiana asclepiadea
Gentiana aspera
Gentiana austriaca
Gentiana autumnalis
Gentiana barbata
Gentiana bellidifolia
Gentiana boisseri
Gentiana cachmerica
Gentiana calycosa
Gentiana ciliata
Gentiana clusii
Gentiana corymbifera
Gentiana crinita
Gentiana cruciata
Gentiana dahurica
Gentiana decumbens
Gentiana depressa
Gentiana dinarica
Gentiana farreri
Gentiana fischeri
Gentiana flavida
Gentiana gelida
Gentiana gracilipes
Gentiana grombezewskii
Gentiana lagodechiana
Gentiana linearis
Gentiana loderi
Gentiana lutea
Gentiana macrophylla
Gentiana nesophila
Gentiana nivalis
Gentiana occidentalis
Gentiana olivieri
Gentiana paradoxa
Gentiana parryi
Gentiana platypetala
Gentiana procera
Gentiana pseudoaquatica
Gentiana pterocalyx
Gentiana puberulenta
Gentiana quinquifolia
Gentiana saponaria
Gentiana scabra
Gentiana sceptrum
Gentiana septemfida
Gentiana sino-ornata
Gentiana siphonantha
Gentiana sp. blue
Gentiana tianschanica
Gentiana tibetica
Gentiana trichotoma
Gentiana turkestanicum
Gentiana verna
Gentiana walujewii
Gentianella barbellata
Gentianella campestris
Gentianella germanica
Gentianella moorcroftiana
Gentianella paludosa
Gentianella sp.
Gentianella turkestanorum
Gentianopsis crinita
Gentianopsis stricta
Gentianopsis thermalis
Geranium maculatum
Geranium sanguineum
Geranium sylvaticum
Geranium transbaicalicum
Geranium traversii
Geranium wallichianum
Gerardia grandiflora
Geum borisii
Geum coccineum
Geum montanum
Geum radicatum
Geum reptans
Geum rivale
Geum urbanum
Gilia androsacea
Gilia formosa
Gilia tricolor
Gillenia trifoliata
Gingidium decipiens
Gingidium montana
Gingko biloba
Gladiolus anatolicus
Gladiolus caucasicus
Gladiolus imbricata
Gladiolus kotschyanus
Glandulicactus uncinnatus
Glandulicactus wrightii
Glaucidium palmatum album
Glaucidium palmatum
Glaucium elegans
Glaucium squamigera
Gleditsia triacanthos
Globularia bisnagarica
Globularia cordifolia purpurea
Globularia cordifolia
Globularia gellifolia
Globularia incanescens
Globularia nudicaulis
Globularia punctata
Globularia repens
Globularia sp.
Globularia trichosantha
Gloriosa superba
Glycyrrhiza glabra
Glyphosperma palmeri
Godetia grandiflora
Gomphrena globosa
Gomphrena haageana
Goniolimon tataricum
Goodenia scapigera
Gossypium herbaceum
Gossypium thurberii
Grayia spinosa
Grevillea buxifolia
Grevillea pulchella
Grevillea robusta
Grevillea sp.
Greyia spinosa
Grumolo verde scuro
Grusonia bradtiana cuatrocienagas
Guichenotia sterculiaceae
Gunnera chilensis
Gunnera densiflora
Gunnera flavida
Gunnera manicata
Gunnera prorepens
Gunnera sp.
Gutierrizia sarothrae
Gymnocactus beguinii senilis
Gymnocactus beguinii
Gymnocactus calochorum proliferum
Gymnocactus knuthianus
Gymnocactus subterraneus zaragosae
Gymnocalycium ambatoense
Gymnocalycium anisitsii
Gymnocalycium baldianum
Gymnocalycium bodenbenderianum
Gymnocalycium calochorum proliferum
Gymnocalycium gibbosum nigrum
Gymnocalycium gibbosum
Gymnocalycium multiflorum
Gymnocladus dioica
Gymnospermium altaicum
Gynandriris setifolia
Gynandriris simulans
Gypsophila bungeana
Gypsophila capitoliflora
Gypsophila cerastoides
Gypsophila elegans
Gypsophila pacifica
Haageocereus chosicensis
Haageocereus pseudomelanostele
Haberlea rhodopensis
Habranthus andersonii
Hackelia bella
Haleria corniculata
Halesia caroliniana
Halgania cyanea
Halimium alyssoides
Halimium atroplicifolium
Halimium ocymoides
Haloragis erecta
Hamamelis virginiana
Hamatocactus sp.
Haplocarpha scaposa
Haplopappus Lyallii
Haplopappus bradegei
Haplopappus spinulosus
Hardenburgia comptoniana
Harrisia bonplandii
Harrisia brookii
Hastingsia alba
Hebe chatamica
Hebe epacridea
Hebe guthreana
Hedeoma hispida
Hedyotis pygmaea
Hedyotis rubra
Hedysarum cephrolotes
Heimia salicifolia 
Helianthemum ledifolium
Helianthemum nummularium
Helianthemum oelandicum
Helianthemum salicifolium
Helianthus sp.
Helichrysum bracteatum 
Helichrysum sp. 
Heliotropium arborescens
Helleborus argutifolius
Helleborus corsicus
Helleborus faetidus
Helleborus niger
Helleborus orientalis
Helonias bullata
Hemerocallis (hybrids)
Hepatica acutiloba
Hepatica americana
Hepatica nobilis
Heptacodium jasminoides
Heracleum nepalense
Hermodactylus tuberosus
Herniaria glabra
Hesperaloe parviflora
Hesperantha bachmannii
Hesperantha baurii (mossii)
Hesperantha cucullata
Hesperantha falcata
Hesperantha pauciflora
Hesperantha pearsoni
Hesperantha sp.
Hesperis matronalis
Hesperochiron californicum
Heterodendrum oleifolium
Heterotheca fulcrata
Heuchera cylindrica v. alpina
Heuchera cylindrica
Heuchera hallii
Heuchera hispida
Heuchera richardsonii
Heuchera villosa
Hibbertia dentata
Hibiscus esculenta
Hibiscus lasiocarpus
Hibiscus moscheutos
Hibiscus syriacus
Hibiscus trionum
Hieracium maculatum
Hieracium olafii
Hierochloe odorata
Hierochloe
Hippolytica darwasica
Hippophae salicifolia
Hoheria lyalli
Holodiscus discolor
Homeria breyniana
Homeria collina
Honckenya (Ammadenia) peploides
Horminum pyrenaicum
Hosta nakiana
Hosta sieboldi
Houstonia coerulea
Houttuynia cordata
Hudsonia ericoides
Hulsea algida
Humulus lupulus
Hunnemannia fumariifolia
Hutchinsia alpinus
Hyacinthella azurea
Hyacinthus orientalis
Hydrangea arborescens
Hydrangea panniculata
Hydrangea quercifolia
Hydrastis canadensis
Hydrophyllum capitatum
Hylomecon japonicum
Hymenanthera alpina
Hymenocallis occidentalis
Hymenocrater bituminosus
Hymenolepis paraviflora
Hymenosporum flavum
Hymenoxys acaulis ssp. caespitosa
Hymenoxys grandiflora
Hymenoxys lapidicola
Hymenoxys sp.
Hymenoxys subintegra
Hyoscyamus niger
Hypericum choisianum
Hypericum densiflorum
Hypericum olympicum
Hypericum perforatum
Hypericum pulchellum
Hypericum spathulatum
Hypoxis hirsuta
Hysoppus officinalis
Hysopus seravshanicus
Hyssopus officinalis
Hystrix patula
Iberis sempervirens
Iberis umbellata
Ibicella lutea
Ikonnikovia kaufmanniana
Ilex aquifolium
Ilex glabra
Ilex japonica
Ilex montana
Ilex monticola
Ilex opaca
Ilex serrata
Ilex verticillata
Illiamna longisepala
Illiamna rivularis
Impatiens balfouri
Impatiens balsamina
Impatiens biflora
Impatiens parviflora
Impatiens scabrida
Incarvillea arguta
Incarvillea mairei
Incarvillea olgae
Indifogera heteranthera
Inula ensifolia
Inula helenium 
Inula helenium
Inula obtusifolia
Inula rhizocephala
Ipheion uniflorum
Ipomoea batatas
Ipomoea leptophylla
Ipomoea tricolor
Ipomopsis aggregata
Ipomopsis rubra
Ipomopsis spicata
Iris acutiloba
Iris attica
Iris barnumae
Iris bracteata
Iris brandzae
Iris bulleyana
Iris chrysophylla
Iris darwasica
Iris decora
Iris dichotoma
Iris douglasiana
Iris elegantissima
Iris ensata
Iris foetidissima
Iris forrestii
Iris germanica
Iris goniocarpa
Iris histroides
Iris hoogiana
Iris hookeri
Iris illlyrica
Iris innominata
Iris junoniana
Iris kemaoensis
Iris lactea
Iris latifolia
Iris lutescens
Iris mandschurica
Iris milesii
Iris missouriensis
Iris nepalensis
Iris oncocyclus (hybrids)
Iris orientalis
Iris paradoxa
Iris pseudoacorus
Iris pumila
Iris reticulata
Iris ruthenica
Iris setosa
Iris sibirica
Iris sintenesii
Iris sogdiana
Iris spuria v. halophila
Iris spuria
Iris stolonifera
Iris subbiflora
Iris taochia
Iris tectorum alba
Iris tectorum
Iris tenax
Iris trojana
Iris typhifolia 
Iris unguicularis
Iris versicolor
Iris wilsoni
Iris xiphoides
Isatis tinctoria
Isoplexis canariensis
Isopyrum biternatum
Isotoma axillaris
Itea virginica 
Ivesia gordonii
Ixia paniculata
Ixia pumilio
Ixia pycnostachys
Ixia viridiflora
Ixolirion kerateginium
Ixolirion tataricum
Jacaranda mimosifolia
Jamesia americana
Jankae heldrichii
Jasione crispa
Jasminum humile
Jatropha curcas
Jatropha macrocarpa
Jeffersonia diphylla
Jeffersonia dubia
Jovellana repens
Juglans ailantifolia v. cordiformis
Juglans cinerea
Juglans nigra
Juglans regia
Juncus compressus
Juncus effusus
Juncus tenuis
Juniperus horizontalis
Juniperus virginiana
Juno aitchisonii
Juno albomarginata
Juno aucheri
Juno baldshuanica
Juno bucharica
Juno coerulea
Juno cycloglossa
Juno graeberiana
Juno halda
Juno kuschakewiczii
Juno magnifica
Juno orchioides
Juno sp.
Juno stenophylla v. allisonii
Juno subdecolorata
Juno vicaria
Juno wilmottiana
Juno zaprajagejewii
Jurinella moschus
Kalanchoe (hybrids)
Kalanchoe flammea
Kalanchoe grandiflora
Kalmia angustifolia
Kalmia cuneata
Kalmia hirsuta
Kalmia latifolia
Kalmia microphylla
Kalmia polifolia
Kalopanax pictus
Kedrostis africana
Kedrostis
Kelseya uniflora
Kernera saxatilis
Kigelia pinnata
Kirengoshima palmata
Kitaibelia vitifolia
Knautia macedonica
Kochia scoparia
Koeleria glauca
Koelreuteria paniculata
Koenigia islandica
Kolkwitzia amabilis
Korolkowia sewerzowii
Kunzea baxteri
Kunzea vestita
Laburnum vossi
Lachenalia algoensis
Lachenalia aloides
Lachenalia arabuthnotiae
Lachenalia bulbifera
Lachenalia capensis
Lachenalia elegans
Lachenalia fistulosa
Lachenalia gilleti
Lachenalia gillettii
Lachenalia glaucina pallida
Lachenalia glaucina
Lachenalia latiflora
Lachenalia latifolia
Lachenalia liliflora
Lachenalia mediana
Lachenalia orchioides
Lachenalia orthopetala
Lachenalia pallida
Lachenalia postulata
Lachenalia reflexa
Lachenalia rosea
Lachenalia unicolor
Lactuca sativus
Lagarus ovatus
Lagopsis marrubiastrum
Lagotis ikonnikovii
Lagotis uralensis
Lagunaria patersonii
Lallemantia canescens
Lallemantia iberica
Lamium maculatum
Lapeirousia anomatheca laxa
Lapeirousia laxa alba
Lapeirousia laxa
Larix kaempferi
Larrea tridentata
Lathyrus latifolius
Lathyrus odoratus
Lathyrus vernus
Laurentia axillaris
Laurentia gasparrinii
Lavandula sp.
Lavandula spica
Lavatera arborea
Lavatera thuringiaca
Lavetia (Azorella ) compacta
Lawsonia inermis v. alba
Lechenaultia biloba
Ledum groenlandicum
Legousia patagonia 
Legousia patagonia
Leiophyllum buxifolium
Leonotis dysophylla
Leonotis leonurus
Leontice incerta
Leontodon autumnalis
Leontopodium alpinum
Leontopodium calocephalum
Leontopodium himalaicum
Leontopodium nivale
Leontopodium ochroleucum
Leontopodium paliginianus
Leontopodium soulei
Leonurus cardiaca
Leonurus sibiricus
Leopoldia comosa alba
Lepechina calycina
Lepidium sativum
Leptarrhena pyrolifolia
Leptinella (Cotula) pyrethifolia
Leptinella pyrethifolia 
Leptodactylon pungens
Leptodactylon watsonii
Leptosiphon (hybrids)
Leptospermum lanigenum
Leptospermum petersonii
Leptospermum scoparium
Lespedeza bicolor
Lesquerella condensata
Lesquerella fendleri
Lesquerella ovalifolia
Lesquerella pinetorum
Lesquerella purshii
Lesquerella rubicunde
Leucaena leucocephala
Leuchtenbergia principis
Leucocrinum montanum
Leucojum aestivum
Leucojum vernum
Leucopogon colensoi
Leucopogon fraseri
Leucospermum formosum
Leucothoe racemosa
Levisticum officinale
Lewisia brachycalyx
Lewisia cotyledon
Lewisia nevadensis
Lewisia pygmaea
Lewisia rediviva
Lewisia tweedyi
Leycesteria formosa
Liatris spicata
Libanotis montana
Libertia caerulescens
Libertia formosa
Libertia grandiflora 
Libertia ixioides 
Libertia perecrinans
Libertia tricolor
Libocedrus decurrens
Lignocarpa carnosula
Ligularia amplexicaulis
Ligularia dentata
Ligularia japonica
Ligusticum scoticum
Ligustrum japonicum
Ligustrum obtusifolium
Lilium albanicum
Lilium alexandrae
Lilium amabile luteum
Lilium amabile
Lilium auratum
Lilium canadense flavum
Lilium canadense v. editorum
Lilium candidum
Lilium catesbaei
Lilium caucasicum
Lilium centifolium (hybrids)
Lilium centifolium x henryi
Lilium cernuum
Lilium chalcedonicum
Lilium ciliatum
Lilium columbianum
Lilium concolor v. partheneion
Lilium concolor
Lilium davidi
Lilium debile
Lilium formosanum
Lilium grayi
Lilium humboldtii v. ocellatum
Lilium kelleyanum
Lilium martagon album
Lilium martagon
Lilium maximowiczii
Lilium michauxii 
Lilium michauxii
Lilium michiganense
Lilium monadelphum
Lilium nanum
Lilium nepalense
Lilium nobilissimum
Lilium occidentale
Lilium pardalinum v. wigginsii
Lilium pardalinum
Lilium parryi
Lilium parvum
Lilium philadelphicum
Lilium pomponium
Lilium ponticum
Lilium pulchellum
Lilium pumilium
Lilium pumilum 
Lilium pyrenaicum
Lilium regale
Lilium sachalinense
Lilium shastense
Lilium superbum
Lilium szovitsianum 
Lilium szovitsianum
Lilium tennuifolium
Lilium tsingtauense
Lilium washingtonianum
Limnanthes douglasii
Limnanthus douglasii
Limonium latifolium
Limonium minutum
Limonium sinuatum 
Linanthrastum nuttallii
Linanthus grandiflora
Linanthus grandiflorus
Linaria kurdica
Linaria purpurea
Linaria pyramidata
Linaria trystis
Lindelofia longiflora
Lindera benzoin
Linum alpinum
Linum boreale
Linum bulgaricum
Linum capitatum
Linum catharticum
Linum dolomiticum
Linum extraaxillare
Linum kingii
Linum perenne
Linum usitatissimum
Linum veitatissi
Lippia (Phyla) nodiflora
Liquidambar styraciflua
Liriodendron tulipifera
Liriope spicata
Lirodendron tulipifera
Lisianthus russelianum
Lithocarpus densiflorus v. echinoides
Lithospermum incisum
Lithospermum multiflorum
Lithospermum officinale
Livistonia chinensis
Lloydia serotina
Lloydia triflora
Loasa nana
Loasa sigmoidea
Loasa vulcanica
Lobelia anatina
Lobelia boykinii
Lobelia cardinalis
Lobelia erinus
Lobelia inflata
Lobelia pendula
Lobelia sessilifolia
Lobelia syphilitica
Lobelia tupa
Lobivia acanthophlegma oligotricha
Lobivia aurea leucomalis
Lobivia aurea
Lobivia backebergii
Lobivia bruchii
Lobivia chrysantha
Lobivia einsteinii aureiflora
Lobivia saltensis nealeana
Lobivia wrightiana winteriana
Loiseleuria procumbens
Lomatium columbianum
Lomatium grayi
Lomatium laevigatum
Lomatium macrocarpum
Lomatium martindalei
Lomatium nudicaule
Lomatium nuttallii
Lomatogonum sp.
Lonicera hallii
Lonicera maacki
Lonicera obovata
Lonicera pyrenaica
Lonicera sempervirens
Lonicera tatarica
Lopezia racemosa
Lophocereus schottii
Lophophora decipiens
Lotus corniculatus
Loxanthocereus seniloides
Luetkea pectinata
Lunaria annua
Lupinus lepidus v. lobbii
Lupinus lyallii v. lobbii
Lupinus polyphyllus
Luzula luzuloides
Luzula nivea
Luzula pilosa
Lycene kubotai
Lychnis (hybrids)
Lychnis alba
Lychnis alpina
Lychnis chalcedonica
Lychnis coronaria 
Lychnis flos-cuculi
Lychnis flos-jovis   
Lychnis sieboldi
Lychnis viscaria
Lychnis wilfordii
Lychnis x arkwrightii
Lychnis yunnanensis
Lycium chinense
Lycopersicon esculentum
Lycopus europaeus
Lycoris pumila
Lygodesmia texana
Lyonia mariana
Lysichiton americanum
Lysichiton camschatcencis
Lysimachia ciliata
Lysimachia punctata
Lythrum salicaria
Maackia amurensis
Macfadyena unguis-cati
Machaeranthera tanacetifolia
Machaerocereus gummosus
Macleaya cordata
Maclura pomifera
Magnolia denudata
Magnolia glauca
Magnolia grandiflora
Magnolia kobus v. stellata
Magnolia sieboldi
Magnolia tripetala
Magnolia wilsoni
Mahonia aquifolium 
Maianthemum canadense
Maihuenia patagonica
Maihueniopsis glomerata
Maihueniopsis sp. 'yocalla'
Majorana hortensis
Malabaila involucrata
Malacothamnus densiflorus
Malesherbia linearifolia
Malleostemon roseus
Malope trifida
Malus 'bob white'
Malus 'donald wyman'
Malus 'joneliscious'
Malus 'red splendor'
Malus 'yellow delicious'
Malus baccata
Malus hupenensis
Malus robusta
Malus sp.
Malva alcaea
Malva moschata
Malvaviscus arboreus
Mamillaria apamiensis pratensis
Mamillaria apozolensis saltensis
Mamillaria aurihamata
Mamillaria backebergiana
Mamillaria bocasana f. roseiflora
Mamillaria carnea
Mamillaria gueizowiana
Mamillaria lasiacantha
Mamillaria melacantha
Mamillaria napina
Mamillaria senilis
Mamillaria theresae
Mamillaria wrightrii
Mandevilla suaveolens
Mandragora officinalis
Mangifera indica
Margyricarpus setosus
Marrubium vulgare
Marshallia obovata
Matelea obliquus
Mathiola bicornis 
Mathiola fruticulosa 
Mathiola incana
Matricaria maritima
Matricaria recutita
Matucana formosa
Matucana haynei
Matucana roseo-alba
Maurandia (Asarina) petrophilia
Mazus reptans
Meconopsis aculeata
Meconopsis betonicifolia alba
Meconopsis betonicifolia pratensis
Meconopsis betonicifolia
Meconopsis cambrica
Meconopsis paniculata
Medeola virginiana
Medicago achinus
Melaleuca diosmafolia 
Melaleuca diosmafolia
Melaleuca huegellii
Melaleuca huegeri
Melampodium cinereum
Melampyrum lineare
Melandrium sachilinense
Melanoselinum decipiens
Melasphaerula graminea
Melia azederach
Melica ciliata
Melilotus alba
Melissa officinalis
Melocactus amoenus
Melocactus bahiensis
Melocactus concinnus
Melocactus loboguereroi
Melocactus oaxacensis
Melospermum peleponnesius
Menodora scabra
Mentha microphylla
Mentha requenii
Mentha sp.
Mentha spicata
Mentzelia (Bartonia) aurea
Mentzelia aurea
Mentzelia chrysantha
Mentzelia decapetala
Mentzelia lindleyi
Mentzelia nuda
Menyanthes trifoliata
Menziesia pillosa
Merendera pyrenaica
Merendera sobolifera
Merendera trigyna
Merremia tuberosa 
Merremia tuberosa
Mertensia alpina
Mertensia bakeri
Mertensia cana
Mertensia lanceolata
Mertensia maritima
Mertensia virginica
Mesembryanthemum nodiflorum
Mesperula graminae roscoae
Meum athamanticum
Michauxia tchiharchewii
Micranthocereus auri-azureus
Micranthocereus strekereii
Micromeria juliana
Micromeria thymifolia 
Micromeria thymifolia
Mila fortalezensis
Mila pugionofera
Milligania densiflora
Mimosa pudica
Mimulus 'andean nymph
Mimulus 'calypso' (hybrids)
Mimulus (calypso  hybrids)
Mimulus (calypso hybrids)
Mimulus cardinalis
Mimulus cusickii
Mimulus guttatus
Mimulus lewisii
Mimulus luteus
Mimulus primuloides
Mimulus puniceus
Mimulus ringens
Mimulus rupicola 
Mina (Quamoclit) lobata
Minuartia biflora
Minuartia laricifolia
Minuartia recurva
Minuartia sp.
Mirabilis jalapa
Mirabilis longiflora
Mirabilis multiflora
Miscanthus (hybrids)
Misopates oronticum 
Misopates oronticum
Mitchella repens
Mitella diphylla
Modiola caroliniana
Moehringia muscosa
Moltkia petraea
Moluccella laevis
Momordica rostrata
Monarda citriodora
Monarda didyma
Monarda fistulosa
Monarda menthifolia 
Monarda menthifolia
Monarda punctata
Monardella odoratissima
Montbretia securigera
Montia (Claytonia) sibirica
Montia sibirica
Montiopsis andicola (Calandrinia tricolor)
Moraea huttonii
Moraea sp
Morawetzia sericata
Moricanda arvensis
Morina longifolia
Morocarpus foliosus
Morus alba
Mosla punctalata
Musa punctata
Musa velutina
Musa violacea
Muscari botryoides
Muscarimia ambrosiacum
Muscarimia macrocarpum
Musella lasiocarpa
Mussaenda roxburghii
Musschia aurea
Mutisia latifolia
Mutisia spinosa
Mutisia subulata
Myoporum debile
Myoporum sp.
Myositidium hortensia
Myosotis arvensis
Myosotis asiatica
Myosotis sylvatica
Myrica caroliniensis
Myrica gale
Myrica pennsylvanica
Myrrhis odorata
Myrsine nummularia
Myrtillocactus geometrizans
Myrtus communis 
Nama hispidum
Nama rothrockii
Nandina domestica
Narcissus (hybrids)
Nardophyllum obtusifolium
Narthecium californicum
Narthecium ossifragum
Nasturtium officinale
Nebelia paleacea
Nectaroscordum siculum
Nelumbo lutea
Nemastylis acuta
Nemastylis pringlei
Nemastylis tenuis
Nemesia sp.
Nemesia strumosa
Nemesia umbonata
Nemopanthus mucronatus
Nemophila maculata
Nemophila menziesii
Neobessya missouriensis
Neobuxbaumia tetetzo
Neocardenassia herzogiana
Neoevansia diguetii
Neolloydia conoidea
Neoporteria chilensis albidiflora
Neoporteria coimasensis
Neoporteria curvispina kesselringianus
Neoporteria engleri
Neoporteria napina miris
Neoporteria sp.
Neoporteria villosa
Neoraimondia roseiflora
Neowerdermannia worwerkii
Nepeta cataria
Nepeta floccosa
Nepeta glutinosa
Nepeta grandiflora
Nepeta nepetalla
Nepeta siasessois
Nepeta sp.
Nepeta subsessilis
Nerium oleander
Nicandra physalodes
Nicotiana affinis
Nicotiana langsdorfii
Nicotiana sylvestris
Nicotiana tabacum
Nicotiana trigonophylla
Nierembergia caerulea
Nigella damascena (hybrids)
Nigella damascena
Nigella hispanica
Nigella orientalis
Nivenia stokoei
Nolana paradoxa
Nolana sp.
Nolina parryi
Nomocharis sp.
Notholirion bulbiferum
Nothoscordum bonariensis
Nothoscordum inodorum
Nothoscordum nerinifolium
Notothlaspi rosulatum
Nototocactus agnetae
Nototocactus ampliocostatus
Nototocactus bueneckeri
Nototocactus purpureus meugelianus
Nototocactus rutilans
Nyctanthes arbor-tristis
Nymphaea tetragona
Nyssa sinensis
Nyssa sylvatica
Obregonia denegrii
Ochna serrulata
Ochna sp.
Ocimum basilicum
Odontostomum hartwegii
Oenothera albicaulis
Oenothera argillicola
Oenothera biennis
Oenothera brachycarpa
Oenothera caespitosa
Oenothera cheiranthifolia
Oenothera cupressus
Oenothera fendleri
Oenothera glauca
Oenothera pallida
Oenothera serrulata
Oenothera speciosa 
Oenothera speciosa
Oenothera triloba
Oenothera xylocarpa
Olea cuspidata
Olearia sp.
Olsynium chrysochromum
Omalotheca (Gnaphalium) supina
Omalotheca norvegica
Omalotheca supina
Omphalodes cappadocica   
Omphalodes linifolia alba
Omphalodes linifolia
Omphalodes luciliae alba
Omphalodes luciliae
Omphalodes sp.
Ononis natrix
Ononis rotundifolia
Onopordum acanthum
Onopordum nervosa
Onopordum sylvestris
Onosma armenum
Onosma nanum
Onosma stellulata
Onosma taurica
Onosmodium molle
Ophiopogon japonicus
Opithandra sp.
Opuntia aurea
Opuntia basilaris v. woodburyi
Opuntia basilaris v. woodburyii
Opuntia basilaris
Opuntia chisosensis
Opuntia clavata
Opuntia cyclodes
Opuntia engelmannii
Opuntia erinacea ursina
Opuntia erinacea
Opuntia fragilis
Opuntia gilvescens
Opuntia gregoriana
Opuntia humifusa
Opuntia imbricata
Opuntia joconosiele
Opuntia leptocaulis
Opuntia macrocentra
Opuntia macrorhiza
Opuntia nicholii
Opuntia phaecantha 'oklahoma'
Opuntia phaecantha
Opuntia polycantha 'crystal tide'
Opuntia polycantha (hybrids)
Opuntia polycantha hystricina
Opuntia polycantha
Opuntia pottsii
Opuntia rhodanthe
Opuntia rutila
Opuntia sanguinicula
Opuntia tuna
Opuntia woodsii
Oreocereus celsianus
Oreocereus hendriksenianus
Origanum vulgare
Ornithogalum caudatum
Ornithogalum dubium
Ornithogalum maculatum
Ornithogalum nutans
Ornithogalum pyrenaicum
Ornithogalum umbellatum
Orobanche minor
Orontium aquaticum
Orostachys iwarenge
Orthrosanthus chimboracensis v. centroamericanus
Orthrosanthus chimboracensis
Orychophragmus violacens
Osbeckia stellata
Osmaronia cerasiformis
Ostrowskia magnifica
Ostrya virginiana
Ourisia macrophylla
Ourisia polyantha
Oxalis magellanica
Oxalis sp.
Oxydendrum arborescens
Oxypetalum caeruleum
Oxyria digyna
Oxytropis besseyi
Oxytropis cachmerica
Oxytropis chankaensis
Oxytropis chiliophylla 
Oxytropis chiliophylla
Oxytropis halleri
Oxytropis humifusa
Oxytropis lamberti
Oxytropis megalantha
Oxytropis multiceps
Oxytropis sericea
Oxytropis shokanbetshensis
Oxytropis splendens
Oxytropis viscida
Oxytropis williamsii
Pachycereus pectin-aboriginum
Pachystegia insignis minor
Paeonea anomala
Paeonea broteri
Paeonea brownii
Paeonea cambessedi
Paeonea emodi
Paeonea lutea
Paeonea mlkosewetschii
Paeonea obovata
Paeonea officinalis
Paeonea suffruticosa
Paeonea vernalis
Panax quinquifolium
Panax trifolium
Pancratium maritimum
Pandorea jasminoides
Panicum violaceum
Panicum virgatum
Paonea broteri
Paonea suffruticosa
Papaver alboroseum
Papaver amenum
Papaver atlanticum
Papaver degenii
Papaver ecoanense
Papaver faurei
Papaver julicum
Papaver kluantense
Papaver lapponicum
Papaver miyabeanum
Papaver nudicaule
Papaver orientale
Papaver pilosum
Papaver pyrenaicum v. rhaeticum
Papaver radicatum
Papaver ruprifagum
Papaver sendtueri
Papaver somniferum
Papaver tatrae
Papaver tatricum
Paradisea liliastrum
Paradisea racemosum
Parahebe linifolia
Paraquilegia grandiflora
Paris quadrifolia
Parnassia fimbriata
Parnassia glauca
Parnassia laxmannii
Parnassia palustris
Parochetus communis
Parodia amblayensis
Parodia aureispina
Parodia cabracoraliensis
Parodia comarapana 
Parodia comarapana
Parodia laui
Parodia mazanensis
Parodia microthele
Parodia minuta
Paronychia sp.
Parrotia persica
Parrotiopsis jacquemontiana
Parrya menziesii
Parrya schugnana
Parsonia capsularis
Parthenocissus quinquifolia
Parthenocissus tricuspidata
Passiflora antiquiensis
Passiflora cinnabarina
Passiflora coccinea
Passiflora edulis
Passiflora incarnata
Passiflora malformis
Passiflora mollissima
Passiflora vitafolia
Patersonia sp.
Patrinia gibbosa
Patrinia scabiosifolia
Paulownia tomentosum
Pavonia lasiopetala
Pedicularis rainierensis
Pediocactus peelesianaus
Pediocactus simpsoni
Peganum harmela
Pelargonium (hybrids)
Pelecyphora aselliformis
Pelkovia sp.
Peltiphyllum peltatum
Peltoboykinia tellimoides
Peniocereus greggii transmontanus
Pennisetum alopecuroides
Pennisetum villosum
Penstemon 'scarlet queen'
Penstemon acaulis
Penstemon acuminatus
Penstemon alpinus
Penstemon ambiguus
Penstemon angustifolius
Penstemon arenicola
Penstemon barbatus
Penstemon brevicaulis
Penstemon caerulea
Penstemon caespitosus desertipictus
Penstemon centranthifolius
Penstemon cleburnei
Penstemon cobaea
Penstemon corymbosus
Penstemon crandalli
Penstemon cyathophorus
Penstemon davidsonii
Penstemon digitalis
Penstemon dolius
Penstemon duchesnis
Penstemon duchesuensis
Penstemon eatoni
Penstemon eriantherus
Penstemon flowersii
Penstemon francisci-pennellii
Penstemon frutescens
Penstemon gairdneri ssp. gairdneri
Penstemon gairdneri ssp. oreganus
Penstemon glaber
Penstemon glabrescens
Penstemon globosus
Penstemon goodrichii
Penstemon gormani
Penstemon gracilis
Penstemon grandiflora
Penstemon hallii
Penstemon harbouri
Penstemon heterophyllus
Penstemon hirsutus pygmaea
Penstemon hirsutus
Penstemon humilis
Penstemon hyacinthus
Penstemon jamesii
Penstemon janishae
Penstemon johnsoniae
Penstemon kunthii
Penstemon laricifolius
Penstemon leiophylla
Penstemon lemhiensis
Penstemon lentus
Penstemon linearioides
Penstemon lyallii
Penstemon mensarum
Penstemon moffatii
Penstemon monoensis
Penstemon montanus ssp. idahoensis
Penstemon montanus
Penstemon mucronatus
Penstemon nitidus
Penstemon ophianthus
Penstemon osterhouti
Penstemon ovatus
Penstemon pachyphyllus
Penstemon palmeri
Penstemon paysoniorum
Penstemon peckii
Penstemon pinifolius
Penstemon retroceus
Penstemon rupicola
Penstemon scapoides
Penstemon scouleri
Penstemon secundiflorus
Penstemon serrulatus
Penstemon smallii
Penstemon sp.
Penstemon speciosus ssp. kennedyi
Penstemon teucrioides
Penstemon tolmei
Penstemon uintahensis
Penstemon utahensis
Penstemon virens
Penstemon whippleanus
Penstemon wilcoxii
Penstemon wizlizenii
Perilla frutescens
Periploca graeca
Pernettya macrostigma
Perovskia abrotanoides
Perovskia atriplicifolia 
Perovskia atriplicifolia
Persea americana
Petalonyx nitidus
Petrocoptis glaucifolia
Petrocoptis hispanica
Petrocoptis pyrenaica
Petrophytum caespitosum
Petroragia tunica
Petrorhagia saxifraga
Petroselinum crispum
Petroselinum hortense
Petunia (hybrids)
Phacelia bipinnatifida
Phacelia campanularia
Phacelia dubia
Phacelia grandiflora
Phacelia purshii
Phacelia sericea
Phacelia x 'lavender lady'
Phalolepis nigricans
Phaseolus acutifolius
Phaseolus vulgaris
Phellodendron amurense
Philadelphus coronarius
Phlomis fruticosa
Phlomis samia
Phlomis tuberosa
Phlox adsurgens
Phlox bifida
Phlox diffusa v. longistylis
Phlox divaricata
Phlox drummondi
Phlox glaberrima
Phlox hoodii
Phlox longifolia
Phlox multiflora
Phlox paniculata
Phlox pilosa
Phlox pulchra
Phlox pulvinata
Phlox scleranthifolia
Phlox speciosa
Phlox stolonifera
Phoenicaulis cheiranthoides
Phoenix dactylifera
Phoradendron flavescens
Phormium colensoi
Phormium cookianum
Phormium tenax purpureum
Phormium tenax variegatum
Phormium tenax
Photinia villosa
Phuopsis stylosa 
Phygelius aequalis
Phygelius capensis
Phylica pubescens
Phyllodoce coerulea
Phyllodoce nipponica
Phyllostachys pubescens
Physalis alkekengi
Physalis ixocarpa
Physalis virginiana
Physaria alpina
Physaria newberryi
Physocarpus opulifolius 
Physoplexis comosum
Physoptychis gnaphlodes
Physostegia virginiana alba
Phyteuma charmellii
Phyteuma haemispherica
Phyteuma nigra
Phyteuma scheuzeri
Phyteuma serratum
Phytolacca americana
Phytolace dioica
Picea abies
Picea excelsa
Picea mariana
Picea pungens
Picea rubra
Pieris formosa
Pieris japonica
Pilosella islandica
Pimelea prostrata
Pimpinella anisum
Pinellia ternata
Pinguicula macroceras
Pinquicula vulgaris
Pinus aristata
Pinus canadensis
Pinus caribea
Pinus cembra
Pinus cembroides
Pinus contorta
Pinus coulteri
Pinus densiflora
Pinus echinata
Pinus elliottii
Pinus excelsa
Pinus flexilis
Pinus insignis
Pinus koraiensis
Pinus lambertiana
Pinus monophylla
Pinus monticola
Pinus mugo
Pinus palustris
Pinus parviflora
Pinus pinea
Pinus poderosa
Pinus pumila
Pinus radiata
Pinus resinosa
Pinus rigida
Pinus roxburghii
Pinus sabiniana
Pinus strobus
Pinus sylvestris
Pinus taeda
Pinus thunbergii
Pinus torreyana
Pinus tuberculata
Pinus virginiana
Piptanthus nepalensis
Pittosporum crassicaule
Placeae ornata
Plantago coronopus
Plantago lanceolata
Plantago major
Plantago maritima
Plantago purshii
Plantago serpentina
Plantago virginica
Platanus occidentalis
Platycodon grandiflora
Pleiospilos bolusii
Pleiospilus bolusii
Pleuroginella brachyanthera
Pleurospermum brunonis
Plumbago capensis
Plumeria emarginata
Podocarpus nivalis
Podophyllum emodi
Podophyllum hexandrum
Podophyllum peltatum
Podophyllum pentaphyllum
Polanisia dodecandra
Polaskia chichipe
Polemonium acutiflorum
Polemonium brandegii
Polemonium caeruleum
Polemonium coeruleum alba
Polemonium coeruleum ssp. villosum
Polemonium coeruleum
Polemonium delicatum
Polemonium grayanum
Polemonium haydeni
Polemonium mellitum
Polemonium pauciflorum
Polemonium pulchellum
Polemonium pulcherrimum v. calycinum
Polemonium reptans
Polemonium vanbruntiae
Polemonium viscosum
Poliomintha incana
Polygala brevifolia
Polygala calcarea
Polygala chamaebuxus
Polygala lutea
Polygala nuttallii
Polygala paucifolia
Polygala senega
Polygonatum biflorum
Polygonatum humile
Polygonatun glaberrimum
Polygonatun humile
Polygonum acifolium
Polygonum acre
Polygonum amphibium
Polygonum aviculare
Polygonum coccineum
Polygonum cuspidatum
Polygonum hydropiperoides
Polygonum lapathifolium
Polygonum orientale
Polygonum pennsylvanicum
Polygonum scandens
Polygonum virginianum
Polyxena corymbosa
Polyxena ensifolia
Polyxena odorata
Poncirus trifoliata
Pontederia cordata
Popoviolimon turkominicum
Populus gradidentata
Populus tremuloides
Porophyllum rudicale
Portulaca grandiflora
Portulaca mundula
Potentilla argyrophylla
Potentilla atrosanguinea
Potentilla crantzii
Potentilla cuneata
Potentilla eriocarpa
Potentilla fruticosa
Potentilla megalantha
Potentilla nuttallii
Potentilla recta
Potentilla rupestris
Potentilla rupestrus
Potentilla salesoviana
Prasophyllum colensoi
Pratia angulata
Primula algida
Primula alpicola violacea
Primula alpicola
Primula anisodora
Primula apoclita
Primula aurantiaca
Primula auricula
Primula auriculata
Primula beesiana
Primula bulleyana
Primula burmanica
Primula buryana
Primula calycina
Primula capitata
Primula chionantha
Primula chungensis
Primula clusiana
Primula cockburniana
Primula cortusoides
Primula cuneifolia
Primula darialica
Primula denticulata
Primula dowensis
Primula elatior
Primula elliptica
Primula ellisiae
Primula erosa
Primula farinosa
Primula firmipes
Primula flexuosa
Primula florindae
Primula forrestii
Primula frondosa
Primula gambeliana
Primula geraniifolia
Primula glutinosa
Primula halleri
Primula helodoxa
Primula heucherifolia
Primula iljinski
Primula integrifolia
Primula intercedens
Primula involucrata
Primula ioessa
Primula japonica
Primula juliae
Primula kaufmanniana
Primula kisoana
Primula laurentiana
Primula luteola
Primula macrophylla
Primula maguerei
Primula malacoides
Primula marginata
Primula melanops
Primula minima
Primula minutissima
Primula modesta
Primula muscarioides
Primula nevadensis
Primula nutans
Primula obconica
Primula pamirica
Primula parryi
Primula poissoni
Primula polyneura
Primula prolifera
Primula pulverulenta
Primula pulvurea
Primula reidii
Primula reticulata
Primula rosea
Primula rotundifolia
Primula rusbyi
Primula scandinavica
Primula scotica
Primula secundiflora
Primula serratifolia
Primula sieboldi
Primula sikkimensis
Primula sinoplantaginea
Primula sinopurpurea
Primula spectabilis
Primula specuicola
Primula stuartii
Primula suffrutescens
Primula tschuktschorum
Primula veris
Primula vernales (hybrids)
Primula verticillata
Primula vialli
Primula violacea
Primula viscosa
Primula waltoni
Primula warshenewskiana
Primula wilsoni
Primula yargongensis
Prinsepia sinensis
Protea longifolia
Protea mundii
Protea repens
Prunella vulgaris
Prunella webbiana
Prunus 'bing cherry'
Prunus 'golden beauty'
Prunus allegheniensis
Prunus armenaica
Prunus avium v. juliana
Prunus communis
Prunus serotina
Prunus serrulata
Prunus sp.
Psathyrotes pilifera
Pseudomertensia nemorosa
Pseudomuscari azureum 
Pseudomuscari azureum album
Pseudotaenidia montana
Pseudotsuga menziesii
Psidium guajava
Psychotria nervosa
Psychrogeton andryaloides
Ptelea isophylla
Ptelea trifoliata
Pterocephalus perennis
Pterostyrax hispidus
Ptilotrichum coccineum
Ptilotrichum macrocarpum
Ptilotrichum spinosum
Pueraria lobota
Pulsatilla alba
Pulsatilla albana
Pulsatilla ambigua
Pulsatilla bungeana
Pulsatilla campanella
Pulsatilla grandis
Pulsatilla montana
Pulsatilla occidentalis
Pulsatilla patens
Pulsatilla pratensis
Pulsatilla sulphurea
Pulsatilla turczaminovii
Pulsatilla vernalis
Pulsatilla vulgaris v. zimmermannii
Pulsatilla vulgaris
Pulsatilla wallichianum
Punica granatum
Purshia mexicana v. stansburyana
Purshia tridentata
Puschkinia scilloides
Putoria calabrica
Pycnanthemum incanum
Pyracantha lalandi
Pyrola minor
Pyrosia serpens
Pyrrhocactus bulbocalyx
Pyrrhocactus sanjuanensis
Pyrrhocactus umadeave
Pyrus 'buerre bosc'
Pyrus 'kieffer'
Pyrus calleriana
Pyrus calleryana
Pyrus pyrifolia 
Pyxidanthera barbulata
Quercus alba
Quercus borealis
Quercus coccinea
Quercus macrocarpa
Quercus phellos
Quercus velutina
Quercus virginiana
Ramonda myconi
Ranunculus acris
Ranunculus adoneus
Ranunculus asiaticus
Ranunculus bulbosus
Ranunculus glacialis
Ranunculus gramineus
Ranunculus hispidulus
Ranunculus illyricus
Ranunculus lyallii
Ranunculus repens
Ranunculus semiverticillatus
Ranunculus sp.
Raphanus sativus
Rathbunia alamosensis
Ratibida (hybrids)
Ratibida columnifera 
Ratibida columnifera
Rauheocereus riosaniensis
Rebutia (hybrids) 
Rebutia (hybrids)
Rebutia marsoneri
Rebutia narvaecensis
Rehmannia elata
Reseda odorata grandiflora
Reseda odorata
Rhamnus caroliniana
Rhamnus cathartica
Rhamnus fallax
Rheum altaicum
Rheum ribes
Rheum tibeticum
Rhexia mariana
Rhexia virginiana
Rhinanthus minor
Rhinephyllum broomii 
Rhinephyllum broomii
Rhinopetalum bucharica
Rhinopetalum stenantherium
Rhipsalis baccifera
Rhodiola atropurpurea
Rhodiola heterodonta
Rhodiola sp.
Rhodochiton atrosanguineum
Rhododendron (hybrids)
Rhododendron anthopogon
Rhododendron catawbiense (hybrids)
Rhododendron lepidotum
Rhododendron maximum
Rhododendron mollis (hybrids)
Rhododendron schlippenbachii
Rhododendron sp.
Rhodolirion montanum
Rhodophiala advena
Rhodophiala andicola
Rhodophiala araucana
Rhodophiala elwesii
Rhodophiala montanum
Rhodophiala pratensis
Rhodophiala sp.
Rhodotypos tetrapetala
Rhus canadensis
Rhus trilobata
Rhus typhina
Ribes americana
Ribes cereum
Ribes grossularia
Ribes hirtellum
Ribes lacustre
Ribes lobbii
Rivina humilis
Robinia pseudoacacia 
Rodgersia pinnata alba
Rodgersia pinnata superba
Rodgersia pinnata
Rodgersia sambucifolia
Rodgersia tabularis
Romanzoffia sitchensis
Romneya coulteri
Romneya trichocalyx
Romulea bulbocdium
Romulea hantamensis
Romulea luthicii
Rorippa islandica
Rosa 'dornroschen'
Rosa 'sheilers provence'
Rosa (hybrids)
Rosa alba 'suaveolens'
Rosa amurensis
Rosa avchurensis
Rosa canina
Rosa carolina
Rosa eglanteria
Rosa gallica 'tuscany superba'
Rosa multiflora
Rosa palustris
Rosa paulii rosea
Rosa rubrifolia
Rosa sp. 'south dakota'
Rosa virginiana
Rosa webbiana
Rosa x 'sheilers provence'
Roscoea alpina
Rosmarinus officinalis
Rosularia pallida
Rosularia sempervivum
Roystonia regia
Rubus argutus 
Rubus argutus
Rubus occidentalis
Rubus odoratus
Rubus parviflorus
Rudbeckia (hybrids)
Rudbeckia fulgida
Rudbeckia hirta (hybrids)
Rudbeckia occidentalis
Rudbeckia x 'goldsturm'
Ruellia humilis
Rumex acetosa
Rumex acetosella
Rumex alpinus
Rumex crispus
Rumex longifolius
Rumex obtusifolius
Rumex patientia
Rumex scutatus
Rumex venosus
Rupicapnos africana
Ruta corsica
Ruta graveolens 
Ruta graveolens
Sabal minor
Sabal palmetto
Sabatia kennedyana
Sagina procumbens
Sagina selaginoides
Sagittaria latifolia 
Saintpaulia ionantha
Salix artica
Salix calcicola
Salix cascadensis
Salix herbacea
Salix lanata
Salix phylicifolia
Salpiglosis (hybrids)
Salpiglossis sinuata
Salvia argentea
Salvia candidissima
Salvia cyanescens
Salvia dumetorum
Salvia fulgens
Salvia glutinosa
Salvia hians
Salvia hispanica
Salvia huberi
Salvia moorcroftiana
Salvia officinalis
Salvia pratensis
Salvia repens
Salvia sclarea 'turkestanica'
Salvia sclarea
Salvia superba
Salvia verticillata
Sambucus canadensis
Sambucus nigra
Sambucus pubens
Sambucus racemosa
Sandersonia aurantiaca
Sanguinaria canadensis
Sanguisorba minor
Sanguisorba officinalis
Sanicula arctopoides
Santolina pectinata
Sapindus saponaria v. drummondi
Sapium sebeferum 
Saponaria caespitosa
Saponaria chlorifolia
Saponaria ocymoides
Sarcocca saligna
Sarcopotorum spinosum
Sarracenia alabamensis
Sarracenia flava
Sarracenia purpurea
Sarracenia sp.
Sassafras varifolium
Satureja discolor
Satureja hortensis
Satureja vulgaris
Sauromatum venosum
Saxifraga aff. nanella
Saxifraga aizoides
Saxifraga caesia
Saxifraga caespitosa
Saxifraga chrysantha
Saxifraga cotyledon
Saxifraga flagellaris
Saxifraga hirculus
Saxifraga hostii
Saxifraga latiopetalaata
Saxifraga nivalis
Saxifraga oppositifolia
Saxifraga paniculata
Saxifraga sp.
Saxifraga spinulosa
Saxifraga stellaris
Saxifraga tricuspidata
Scabiosa atropurpurea
Scabiosa caucasica
Scabiosa farinosa
Scabiosa ochraleuca
Scabiosa vestita
Schisandra chinensis
Schivereckia doerfleri
Schivereckia monticola
Schizanthus (disco hybrids)
Schizanthus (hybrids)
Schizanthus grahamii
Schizanthus hookeri
Schizopetalon walkeri
Schizophragma integrifolium 
Schlumbergera truncata
Schoenolirion bracteosa
Sciadopitys verticillata
Scilla bifolia
Scilla campanulata
Scilla chinensis
Scilla hispanica
Scilla natalensis
Scilla rosenii
Scilla scilloides
Scilla sibirica
Scilla tubergeniana
Scirpus holoschoenus
Scleranthus biflorus
Scleranthus uniflorus 
Sclerocactus glaucus
Sclerocactus nevadensis
Sclerocactus parviflorus
Sclerocactus pubispinus
Sclerocactus spinosior
Sclerocactus whipplei v. roseus
Scoliopus bigelovii
Scrophularia lanceolata
Scrophularia nodosa
Scutellaria adeniostegia
Scutellaria baicalensis
Scutellaria elliptica
Scutellaria haematochlora
Scutellaria integrifolia 
Scutellaria integrifolia
Scutellaria intermedia
Scutellaria laterifolia
Scutellaria microdasys
Scutellaria novae-zealandiae
Scutellaria ovata
Scutellaria pontica
Scutellaria resinosa
Scutellaria rubicunda
Scutellaria subcaespitosa
Securinega suffruticosa
Sedum kamschaticum
Sedum lanceolatum
Sedum pilosum
Sedum pulchellum
Sedum spectabile
Sedum stelleforme
Sedum subulatum
Sedum telephioides
Sedum villosum
Selenomeles lechleri
Selinus tenuifolium 
Semiaquilegia elcalcarata 
Sempervivum sp.
Senecio abrotanifolius v. tirolensis
Senecio abrotanifolius
Senecio aureus
Senecio cruentus
Senecio harbouri
Senecio holmii
Senecio nudicaulis
Sequoia gigantea
Sequoiadendron giganteum
Serenoa repens
Sesamum orientalis
Sesbania tripetii
Sesbania triquetri
Seseli gummiferum
Setaria glauca
Setaria italica
Seticereus icosagonus
Shepherdia canadensis
Shortia galacifolia
Shortia soldanelloides
Shoshonea pulvinata
Sibbaldia procumbens
Sicyos angularis
Sideritis hyssopifolia
Silene acaulis
Silene agraea
Silene armeria
Silene californica 
Silene californica
Silene caroliniana
Silene ciliata
Silene colorata
Silene compacta
Silene delavayi
Silene dioica
Silene douglasii
Silene elizabethae
Silene gallica
Silene guntensis
Silene hookeri
Silene keiskii
Silene laciniata
Silene nutans
Silene pendula
Silene pennsylvanica
Silene polypetala
Silene pusilla
Silene regia
Silene ruprechti
Silene saxatilis
Silene saxifraga
Silene schafta
Silene sp.
Silene uniflora 
Silene uniflora
Silene vallesia
Silene virginica
Silybum marianum
Sinningia speciosa
Sisyrinchium angustifolium
Sisyrinchium bellum
Sisyrinchium campestre
Sisyrinchium demissum album
Sisyrinchium inflatum
Sisyrinchium laetum
Sisyrinchium littorale
Sisyrinchium mulcronatum
Skimmia japonica
Smilacina racemosa 
Smilax ecirrhata
Smilax ferox
Smyrnium perfoliatum
Solanum aculeatissimum
Solanum capsicastrum
Solanum dulcamara
Solanum melongena 
Solanum sisymbrifolium
Soldanella carpathica
Soldanella hungarica
Soldanella montana
Solidago caesia
Solidago canadensis
Solidago spathulata
Sollya heterophylla 
Sollya heterophylla
Sophora japonica 
Sophora japonica
Sophora microphylla
Sophora mollis
Sophora moorcroftiana
Sophora prostrata
Sophora secundiflora
Sophora tetraptera
Sophora tomentosum
Sorbus americana
Sorbus aucuparia
Sorbus caucasica
Sparaxis (hybrids)
Spartium junceum
Spathodea campanulata
Specularia speculum-veneris
Spergularia rubra
Spergularia rupicola
Sphaeralcea (Illimna) remota
Sphaeralcea ambigua
Sphaeralcea coccinea
Sphaeralcea grossolariaefolia
Sphaeralcea incana
Sphaeralcea parvifolia
Spigelia marilandica
Spilanthes acmella
Spiraea alba
Spiraea betulifolia
Spiraea canescens
Spiraea japonica
Spiraea ulmaria
Spraguea umbellata
Sprekelia formosissima
Stachys alpina
Stachys lanata
Stachys macrantha 
Stachys macrantha
Stachys officinalis
Stachyurus chinensis
Stanleya pinnata
Stapelia leendertzii
Stellaria chamaejasme
Stellaria media
Stellera chamaejasme
Stenanthium occidentale
Stenocereus griseus
Stenocereus stellatus
Stenocereus thurberi
Stephanocereus leucostelie
Stephanotis floribunda
Sternbergia candida
Stetsonia coryne
Stewartia koreana
Stewartia pseudocamellia
Stipa capillata
Stipa pennata
Stirlingia latifolia
Stokesia laevis
Strangweia spicata
Stransvaesia nitakaymensis
Strelitzia nicolae
Strelitzia reginae
Streptocarpus (hybrids)
Streptopus rosea
Strombocactus disciformis
Stylidium graminifolium
Stylomecon heterophylla
Stylophorum diphyllum
Stylophorum lasiocarpum
Stypandra glauca
Styrax japonica
Styrax obassia
Succisa inflexa
Succisa pratensis
Sulcorebutia totorensis lepida
Sutherlandia frutescens prostrata
Sutherlandia montana
Sutherlandia prostata
Sutherlandia sp.
Swertia fedtschenkoana
Swertia marginata
Swertia perennis
Swertia shugnanica
Symphoricarpos albus
Symphoricarpos orbiculata
Symphyandra hoffmannii
Symphyandra tianschanica
Symphyandra wanneri
Symplocarpus foetidus
Synnotia parviflora 
Synnotia variegata metelerkampiae
Synnotia variegata
Synnotia villosa
Synthyris alpina (Bessya alpina)
Synthyris pinnatifida
Syringa amurensis
Syringa pekinensis
Syringa vulgaris
Tacitus bellus
Tagetes (hybrids)
Talinum brevifolium
Talinum calycinum
Talinum okanoganense
Talinum sp.
Talinum spinescens
Talinum teretifolium
Tamarindus indica
Tamus communis
Tanacetopsis subsincks
Tanacetum capitatum
Tanacetum dolichophyllum
Tanacetum gracile
Tanacetum parthenium
Tanacetum sp.
Tanacetum turcomanicum
Taraxacum officinale
Taxodium distichum
Taxus baccata
Tecoma stans
Tecomaria capensis
Teesdaliopsis conferta
Telephium imperati
Telesonix jamesii
Tellima alexanderi
Tellima articulatus
Tellima grandiflora
Tephrocactus 't.a.b. pomen'
Tephrocactus alexanderi bruchii
Tephrocactus articulatus (chilecito)
Tephrocactus articulatus campana
Tephrocactus rauhii
Tephrosia virginiana
Tetragonolobus maritimus
Teucrium sp.
Thalictrum aquilegifolium
Thalictrum dioicum
Thalictrum kemense
Thalictrum lucidum
Thalictrum minus
Thalictrum petaloideum
Thalictrum rochebrunianum
Thalictrum sp.
Thalictrum speciosissimum
Thalictrum tuberiferum
Thalictrum tuberosum
Thalictrum uchiyamai
Thaspium trifoliatum
Thelocactus bicolor
Thelocactus conothele
Thelocactus hexaedrophorus 
Thelocactus leucacanthus schmollii
Thelocactus tulensis
Thermopsis alpina
Thermopsis alternifolia
Thermopsis caroliniana
Theropogon pallidos
Thespesia populaea
Thlaspi bulbosum
Thlaspi montanum
Thlaspi rotundifolia
Thlaspi stylosum
Thomasia quercifolia
Thrixanthocereus blossfeldiorum
Thrysostachys siamensis
Thuja occidentalis
Thunbergia alaga
Thunbergia alata
Thymus incertus
Thymus vulgare
Thysanotus multiflorus
Tiarella cordifolia
Tiarella wherryi
Tibouchina grandiflora
Tigridia pavonia
Tilia americanum
Tilia cordata
Tilingia tachiroei
Tillandsia sp.
Tofieldia pusilla
Torenia (hybrids)
Toumeya papyracantha
Townsendia eximia
Townsendia exscapa
Townsendia florifer
Townsendia formosa
Townsendia glabella
Townsendia grandiflora
Townsendia hirsuta
Townsendia hookeri
Townsendia incana
Townsendia mensana
Townsendia montana
Townsendia parryi
Townsendia rothrockii
Townsendia sericea
Townsendia sp.
Townsendia tomentosa
Townsendia wilcoxiana
Trachelium caeruleum
Trachelium rumelicum
Trachymene caerulea
Trachyspermum ammi
Tradescantia bracteata
Tradescantia longipes
Tribeles australis
Trichocereus bridgesii
Trichocereus bruchii nivalis
Trichocereus formosus
Trichocereus pachanoi
Trichophorum alpinum
Trichosanthes cuspidata
Trichostema dichotomum
Trichostema setaceum
Tricyrtis affinis
Tricyrtis bakeri
Tricyrtis dilitata
Tricyrtis flava
Tricyrtis formosana
Tricyrtis hirta alba
Tricyrtis hirta
Tricyrtis latifolia
Tricyrtis macrantha
Tricyrtis macropoda
Tricyrtis nana
Tricyrtis perfoliata
Tricyrtis pilosa
Tricyrtis puberula
Tricyrtis stolonifera
Trifolium dasyphyllum
Trifolium pratense
Trifolium repens
Trifolium virginiana
Trifurcia lahue caerulea
Triglochin maritima
Trigonella foenum-graecum
Trillidium govianum
Trillium albidum
Trillium apetalon
Trillium chloropetalum
Trillium erectum alba
Trillium erectum
Trillium flexipes
Trillium grandiflorum roseum
Trillium grandiflorum
Trillium kamschaticum
Trillium luteum
Trillium nivale
Trillium ovatum
Trillium pusillum
Trillium recurvatum
Trillium rugeli
Trillium tschonoski
Trillium undulatum
Trillium vaseyi
Triosteum perfoliatum
Tripetaleia paniculata
Tripterocalyx cyclopetris
Triteleia laxa
Tritoma (hybrids)
Tritonia crocea
Trochodendron aralioides
Trollium pumilus
Trollius acaulis
Trollius altissimus
Trollius asiaticus
Trollius chinensis
Trollius dschungaricus
Trollius laxus 
Trollius laxus
Trollius ledebouri
Trollius pumilus
Tropaeolum  azureum 
Tropaeolum azureum
Tropaeolum major
Tropaeolum minus
Tropaeolum pentaphyllum
Tropaeolum polyphyllum
Tropaeolum sessilifolium
Tropaeolum speciosum
Tsuga canadensis
Tuberaria lignosa
Tulbaghia galpinii
Tulipa chrysantha
Tulipa clusiana
Tulipa sp.
Tulipa sprengeri
Tulipa stellata
Tulipa tarda
Tulipa turkestanica
Turbinocarpus lophophoroides
Turbinocarpus polaskii
Turricula parryi
Tussilago farfara
Tussilago sp.
Typha latifolia
Uebelmannia gummifera
Ulmus glabra
Umbilicus rupestris
Uncinia (Ursinia) rubra
Uncinia (Ursinia) uncinnata
Ungernia victoris
Ungnadia speciosa
Urginea secunda
Urospermum delechampii
Urtica membranacea
Urtica piculifera
Uvularia grandiflora
Vaccaria hispanica
Vaccaria pyrimidata
Vaccinium globulare
Vaccinium macrocarpum
Vaccinium myrtillus
Vaccinium nummularia
Vaccinium uliginosum
Vaccinium vitis-idaea
Valeriana officinalis
Vatricania guentheri
Veltheimia bracteata
Veratrum californicum
Verbascum blattaria
Verbascum bombyciferum
Verbascum chaixi album
Verbascum nigrum album
Verbascum nigrum
Verbascum olympicum
Verbascum phoeniceum
Verbascum thapsus
Verbena (quartz hybrids)
Verbena (wings hybrids)
Verbena hastata
Verbena macdouglii
Vernonia altissima
Vernonia novaboracencis
Veronica aphylla
Veronica bellidioides
Veronica caespitosa
Veronica fruticans
Veronica fruticulosa
Veronica nipponica
Veronica nummularia
Veronica ponae
Veronica serpyllifolia
Veronica tauricola
Veronicastrum virginica 
Veronicastrum virginica
Verticordia aff. ovalifolia
Verticordia chrysantha v. preissii
Vestia foetida
Vestia lycioiodes  ?
Viburnum acerifolium
Viburnum burkwoodi
Viburnum carlesi
Viburnum dentatum
Viburnum dilatatum
Viburnum lantana
Viburnum opulis
Viburnum prunifolium
Viburnum rhytidophyllum
Viburnum sargenti
Viburnum setigerum
Viburnum sieboldi
Viburnum tomentosum
Viburnum trifolium
Viburnum trilobum
Vicia americana
Vicia cracca
Viguiera porteri
Vinca rosea
Vincatoxicum hirundinaria
Vincatoxicum nigrum
Viola adunca
Viola aff. rosulata
Viola altaica
Viola appalachiensis
Viola arborescens 
Viola biflora
Viola canadensis
Viola canina
Viola cornuta
Viola coronifera
Viola cotyledon
Viola cucullata
Viola cuneata
Viola dactyloides
Viola dasyphylla
Viola delphinantha
Viola fimbriatula
Viola fluehmannii
Viola glabella
Viola incisa
Viola labradorica
Viola maculata
Viola montana
Viola nuttallii
Viola odorata
Viola palmata
Viola papilonacea
Viola pedatifida
Viola philippii
Viola pubescens
Viola rugulosa
Viola sagittata
Viola sheltoni
Viola sororia alba
Viola sp. (rosulate)
Viola striata
Viola tricolor (hybrids)
Viola tricolor
Vitaliana (Douglasia) primuliflora
Vitaliana primuliflora
Vitex agnus-castus
Vitis vinifera
Vitis vulpina 
Wachendorfia thrysiflora
Wahlenbergia congesta (hybrids)
Wahlenbergia congesta
Wahlenbergia gloriosa 
Wahlenbergia gloriosa
Wahlenbergia saxicola
Wahlenbergia sp.
Wahlenbergia trichogyna
Waitzia citrina
Waldheimia glabra
Waldheimia stoliczkai
Waldheimia tomentosa
Waldsteinia fragrarioides
Washingtonia filifera
Watsonia beatricis
Watsonia sp.
Weberbauerocereus johnsonii
Weigelia florida
Weingartia hediniana
Weingartia longigipba
Wisteria sinensis
Withania somnifera
Wulfenia carinthiaca
Wyethia amplexicaulis
Wyethia arizonica
Wyethia helianthoides
Xanthoceras sorbifolium
Xeranthemum annuum
Xeronema callistemon
Xerophyllum asphodeloides
Xerophyllum tenax
Xylanthemum pamiricum
Yucca filamentosa
Yucca glauca
Yucca navajoa
Yucca whipplei
Zaluzianskya capensis
Zantedeschia ethiopeca
Zauschneria arizonica
Zauschneria garrettii
Zea mays
Zea sp.
Zenobia pulverulenta
Zephyra 
Zephyra minima
Zephyranthes atamasco
Zephyranthes rosea
Zigadenus elegans
Zigadenus fremonti
Zinnia elegans
Zizania aquatica
Zizia aptera
Zizia aurea
Ziziphora bungeana
Zizyphus jujuba
Zygocactus truncatus
Zygophyllum atriplicoides
\.


--
-- Name: row_num_seq; Type: SEQUENCE SET; Schema: deno; Owner: gastil
--

SELECT pg_catalog.setval('deno.row_num_seq', 5244, true);


--
-- Name: book_index deno_index_row_pk; Type: CONSTRAINT; Schema: deno; Owner: gastil
--

ALTER TABLE ONLY deno.book_index
    ADD CONSTRAINT deno_index_row_pk PRIMARY KEY (autoinc);


--
-- Name: taxa taxa_pkey; Type: CONSTRAINT; Schema: deno; Owner: gastil
--

ALTER TABLE ONLY deno.taxa
    ADD CONSTRAINT taxa_pkey PRIMARY KEY (taxon);


--
-- Name: book_index deno_index_taxon_fk; Type: FK CONSTRAINT; Schema: deno; Owner: gastil
--

ALTER TABLE ONLY deno.book_index
    ADD CONSTRAINT deno_index_taxon_fk FOREIGN KEY (taxon) REFERENCES deno.taxa(taxon);


--
-- PostgreSQL database dump complete
--

