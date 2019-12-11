--
-- PostgreSQL database dump
--

-- Dumped from database version 12.1
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
-- Name: bx; Type: SCHEMA; Schema: -; Owner: gastil
--

CREATE SCHEMA bx;


ALTER SCHEMA bx OWNER TO gastil;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bx_dates; Type: TABLE; Schema: bx; Owner: gastil
--

CREATE TABLE bx.bx_dates (
    bx_id character varying(6) NOT NULL,
    date_open date,
    date_close date,
    director_initials character varying(10)
);


ALTER TABLE bx.bx_dates OWNER TO gastil;

--
-- Name: bx_items; Type: TABLE; Schema: bx; Owner: gastil
--

CREATE TABLE bx.bx_items (
    bx_id character varying(6) NOT NULL,
    category character(5),
    item numeric NOT NULL,
    taxon character varying(100) NOT NULL,
    donor character varying(100),
    notes text,
    photo_link character varying(200),
    season character varying(100),
    of character varying(100)
);


ALTER TABLE bx.bx_items OWNER TO gastil;

--
-- Name: COLUMN bx_items.of; Type: COMMENT; Schema: bx; Owner: gastil
--

COMMENT ON COLUMN bx.bx_items.of IS 'ie Small cormlets of, Seedlings of, Tubers of, Offsets of, Leaf bulbils of,...';


--
-- Name: vw_date_open_n_items_for_graph; Type: VIEW; Schema: bx; Owner: gastil
--

CREATE VIEW bx.vw_date_open_n_items_for_graph AS
 SELECT d.bx_id,
    d.date_open,
    max(i.item) AS max_item,
    count(*) AS n_items
   FROM (bx.bx_dates d
     LEFT JOIN bx.bx_items i ON (((d.bx_id)::text = (i.bx_id)::text)))
  WHERE ((d.bx_id)::text !~~ 'SX%'::text)
  GROUP BY d.date_open, d.bx_id
  ORDER BY d.bx_id;


ALTER TABLE bx.vw_date_open_n_items_for_graph OWNER TO gastil;

--
-- Name: vw_n_bx_per_month_qtr; Type: VIEW; Schema: bx; Owner: gastil
--

CREATE VIEW bx.vw_n_bx_per_month_qtr AS
 SELECT count(DISTINCT i.bx_id) AS n_bx,
    date_part('month'::text, d.date_open) AS mon,
    min(date_part('quarter'::text, d.date_open)) AS qtr,
    count(*) AS n_items,
    (count(*) / count(DISTINCT i.bx_id)) AS items_per_month
   FROM (bx.bx_dates d
     JOIN bx.bx_items i ON (((d.bx_id)::text = (i.bx_id)::text)))
  WHERE ((d.bx_id)::text !~~ 'SX%'::text)
  GROUP BY (date_part('month'::text, d.date_open))
  ORDER BY (date_part('month'::text, d.date_open));


ALTER TABLE bx.vw_n_bx_per_month_qtr OWNER TO gastil;

--
-- Name: vw_span_of_dates; Type: VIEW; Schema: bx; Owner: gastil
--

CREATE VIEW bx.vw_span_of_dates AS
 SELECT min(d.date_open) AS first_date,
    max(d.date_open) AS last_date,
    age((min(d.date_open))::timestamp with time zone, (max(d.date_open))::timestamp with time zone) AS "interval",
    count(*) AS qc_count
   FROM (bx.bx_dates d
     JOIN bx.bx_items i ON (((d.bx_id)::text = (i.bx_id)::text)))
  WHERE ((d.bx_id)::text !~~ 'SX%'::text);


ALTER TABLE bx.vw_span_of_dates OWNER TO gastil;

--
-- Data for Name: bx_dates; Type: TABLE DATA; Schema: bx; Owner: gastil
--

COPY bx.bx_dates (bx_id, date_open, date_close, director_initials) FROM stdin;
BX 300	2011-12-17	\N	ds
BX 301	2011-12-31	2012-01-01	ds
BX 302	2012-02-01	\N	ds
BX 303	2012-02-17	2012-02-17	ds
BX 304	2012-03-09	2012-03-10	ds
BX 305	2012-03-22	\N	ds
BX 306	2012-04-01	2012-04-02	ds
BX 307	2012-04-09	\N	ds
BX 308	2012-04-26	\N	ds
BX 309	2012-05-06	\N	ds
BX 310	2012-05-17	2012-05-18	ds
BX 311	2012-05-28	\N	ds
BX 312	2012-06-05	\N	ds
BX 313	2012-06-08	\N	ds
BX 314	2012-06-22	\N	ds
BX 315	2012-06-27	2012-06-27	ds
BX 316	2012-06-30	\N	ds
BX 317	2012-07-04	2012-07-06	ds
BX 318	2012-07-19	\N	ds
BX 319	2012-07-29	2012-08-02	ds
BX 320	2012-08-09	2012-08-10	ds
BX 321	2012-08-23	\N	ds
BX 322	2012-09-06	2012-09-09	ds
BX 323	2012-09-18	2012-09-20	ds
BX 324	2012-09-25	2012-09-27	ds
BX 325	2012-10-01	2012-10-07	ds
BX 326	2012-10-13	2012-10-15	ds
BX 327	2012-10-25	2012-10-26	ds
BX 328	2012-11-08	2012-11-09	ds
BX 329	2012-11-25	2012-11-27	ds
BX 330	2012-12-01	2012-12-03	ds
BX 331	2012-12-11	2012-12-12	ds
BX 332	2013-01-22	2013-01-22	ds
BX 333	2013-02-22	2013-02-23	ds
BX 334	2013-03-20	2013-03-21	ds
BX 335	2013-04-01	2013-04-02	ds
BX 336	2013-04-18	2013-04-18	ds
BX 337	2013-05-05	2013-05-07	ds
BX 338	2013-05-15	2013-05-18	ds
BX 339	2013-05-28	2013-05-29	ds
BX 340	2013-07-03	2013-07-04	ds
BX 341	2013-07-22	2013-07-23	ds
BX 342	2013-08-12	2013-08-14	ds
BX 343	2013-08-21	2013-08-23	ds
BX 344	2013-09-01	2013-09-03	ds
BX 345	2013-09-06	2013-09-10	ds
BX 346	2013-09-16	2013-09-17	ds
BX 347	2013-09-25	2013-09-26	ds
BX 348	2013-09-30	2013-10-02	ds
BX 349	2013-10-07	2013-10-09	ds
BX 350	2013-10-14	2013-10-15	ds
BX 351	2013-10-23	2013-10-24	ds
BX 352	2013-11-02	2013-11-03	ds
BX 353	2013-11-13	2013-11-13	ds
BX 354	2013-12-01	2013-12-03	ds
BX 355	2013-12-10	2013-12-15	ds
BX 356	2014-01-22	2014-01-24	ds
BX 357	2014-03-26	2014-03-27	ds
BX 358	2014-04-12	2014-04-13	ds
BX 359	2014-04-26	2014-04-27	ds
BX 360	2014-05-05	2014-05-07	ds
BX 361	2014-05-16	2014-05-17	ds
BX 362	2014-05-28	2014-05-31	ds
BX 363	2014-06-11	2014-06-12	ds
BX 364	2014-07-01	\N	ds
BX 365	2014-07-19	\N	ds
BX 366	2014-08-04	2014-08-04	ds
BX 367	2014-08-08	2014-08-09	ds
BX 368	2014-08-17	2014-08-18	ds
BX 369	2014-09-02	2014-09-02	ds
BX 370	2014-09-15	2014-09-16	ds
BX 371	2014-10-03	2014-10-04	ds
BX 372	2014-11-08	2014-11-09	ds
BX 373	2014-12-28	2014-12-29	ds
SX 002	2015-02-06	2015-02-14	sm
BX 374	2015-03-26	2015-03-26	ds
BX 375	2015-04-06	2015-04-07	ds
BX 376	2015-04-20	2015-04-21	ds
BX 377	2015-04-26	2015-04-28	ds
BX 378	2015-05-15	2015-05-17	ds
BX 379	2015-06-04	2015-06-05	ds
BX 380	2015-06-20	2015-06-20	ds
BX 381	2015-07-12	2015-07-13	ds
BX 382	2015-07-29	2015-07-30	ds
SX 003	2015-08-03	\N	sm
BX 383	2015-08-09	2015-08-10	ds
BX 384	2015-08-19	\N	ds
BX 385	2015-09-02	2015-09-03	ds
BX 386	2015-09-27	2015-09-27	ds
BX 387	2015-10-15	2015-10-17	ds
BX 388	2015-10-23	2015-10-25	ds
BX 389	2015-10-28	2015-10-29	ds
BX 390	2015-11-06	2015-11-07	ds
BX 391	2015-11-13	2015-11-14	ds
BX 392	2015-11-24	2015-11-24	ds
BX 393	2015-12-01	2015-12-02	ds
BX 394	2016-01-23	2016-01-24	ds
BX 395	2016-02-22	2016-02-22	ds
BX 396	2016-03-29	2016-03-29	ds
BX 397	2016-04-28	2016-04-29	ds
BX 398	2016-05-11	2016-05-12	ds
BX 399	2016-05-23	2016-05-24	ds
BX 400	2016-06-03	2016-06-04	ds
\.


--
-- Data for Name: bx_items; Type: TABLE DATA; Schema: bx; Owner: gastil
--

COPY bx.bx_items (bx_id, category, item, taxon, donor, notes, photo_link, season, of) FROM stdin;
BX 301	SEEDS	1	Haemanthus albiflos	Richard Hart	\N	\N	\N	\N
BX 301	BULBS	2	Nerine laticoma	Ellen Hornig	\N	\N	\N	\N
BX 301	BULBS	3	Talinum paniculatum	Pam Slate	small tubers	\N	\N	\N
BX 301	BULBS	4	Albuca nelsonii	Pam Slate	\N	\N	\N	\N
BX 301	BULBS	5	mixed zephyranthes	Pam Slate	\N	\N	\N	\N
BX 301	SEEDS	6	Nothoscordum bivalve (few)	Jerry Lehmann	\N	\N	\N	\N
BX 301	SEEDS	7	Iris versicolor, collected in Two Inlets, MN	Jerry Lehmann	\N	\N	\N	\N
BX 301	SEEDS	8	Anemone virginica and/or A. cylindrica "Thimbleweed"	Jerry Lehmann	collected in Becker Co., MN	\N	\N	\N
BX 301	SEEDS	9	Liatris 'Kobold' in bloom at the same time as L. spicata 'Alba'	Jerry Lehmann	\N	\N	\N	\N
BX 301	SEEDS	10	Liatris spicata 'Alba', ditto	Jerry Lehmann	\N	\N	\N	\N
BX 301	SEEDS	11	Aster macrophyllus	Jerry Lehmann	\N	\N	\N	\N
BX 301	BULBS	12	Ornithogalum caudatum (longibracteatum), mix of two forms,	Jerry Lehmann	Bulblets, one with rounder, more green leaves	\N	\N	\N
BX 301	BULBS	13	Small Bessera elegans	Jerry Lehmann	\N	\N	\N	\N
BX 301	SEEDS	14	Habranthus tubispathus var roseus	Ina Crossley	\N	\N	\N	\N
BX 301	SEEDS	15	Zephyranthes verecunda white	Ina Crossley	\N	\N	\N	\N
BX 301	SEEDS	16	Zephyranthes verecunda rosea	Ina Crossley	\N	\N	\N	\N
BX 301	SEEDS	17	Zephyranthes drummondii	Ina Crossley	\N	\N	\N	\N
BX 301	SEEDS	18	Hippeastrum calyptratum	David Boucher	\N	\N	\N	\N
BX 301	SEEDS	19	Anchomanes difformis var welwitschii, a close relative of	David Boucher	Amorphophallus from Africa. Has spines, but most of the stink is not present	\N	\N	\N
BX 302	BULBS	1	Amorphophallus albus	Bonaventure Magrys	Small tubers	\N	\N	\N
BX 302	BULBS	2	Amorphophallus bulbifer	Bonaventure Magrys	Small tubers	\N	\N	\N
BX 302	SEEDS	3	Larsenianthus careyanus (Zingiberaceae)	Fred Thorne	\N	\N	\N	\N
BX 302	SEEDS	4	Ennealophus euryandrus	Lee Poulsen	\N	\N	\N	\N
BX 302	SEEDS	5	Cypella peruviana	Lee Poulsen	\N	\N	\N	\N
BX 302	SEEDS	6	Cypella coelestis	Lee Poulsen	\N	\N	\N	\N
BX 302	BULBS	7	Small bulbs of Ipheion sessile	Lee Poulsen	Small bulbs	\N	\N	\N
BX 302	SEEDS	8	Bowiea volubilis	Kipp McMichael	\N	\N	\N	\N
BX 302	SEEDS	9	Habranthus tubispathus rosea	Ina Crossley	\N	\N	\N	\N
BX 302	SEEDS	10	Zephyranthes 'Hidalgo'	Ina Crossley	\N	\N	\N	\N
BX 302	SEEDS	11	Zephyranthes drummondii	Ina Crossley	\N	\N	\N	\N
BX 302	SEEDS	12	Zephyranthes lindleyana (morrisclintii)	Ina Crossley	\N	\N	\N	\N
BX 302	SEEDS	13	Zephyranthes primulina	Ina Crossley	\N	\N	\N	\N
BX 302	SEEDS	14	Zephyranthes verecunda rosea	Ina Crossley	\N	\N	\N	\N
BX 302	SEEDS	15	Freesia laxa, blue	Mary Gastil-Buhl	\N	\N	\N	\N
BX 302	BULBS	16	Freesia laxa, pale lavender blue	Mary Gastil-Buhl	Corms/cormels	\N	\N	\N
BX 302	SEEDS	17	Biophytum sensitivum (Oxalidaceae)	Dennis Kramb	\N	\N	\N	\N
BX 302	SEEDS	18	Gloxinella lindeniana (Gesneriaceae)	Dennis Kramb	\N	\N	\N	\N
BX 302	SEEDS	19	Primulina tamiana (Gesneriaceae), formerly Chirita tamiana	Dennis Kramb	\N	\N	\N	\N
BX 302	SEEDS	20	Hesperantha coccinea 'Oregon Sunset'	Randy Linke	\N	\N	\N	\N
BX 302	SEEDS	21	Dietes grandiflora	Mary Sue Ittner	evergreen, long blooming in mild climates in a sunny location	\N	\N	\N
BX 302	SEEDS	22	Hesperoxiphion peruvianum	Mary Sue Ittner	summer growing, fall blooming for me. This plant has a spectacular flower, but each flower is very short lived opening in the am and fading before the day is over (faster on This plant has a spectacular flower, but each flower is very short).  This plant has a spectacular flower, but each flower is very short	\N	\N	\N
BX 302	SEEDS	23	Moraea polystachya	Mary Sue Ittner	winter growing, long season of bloom in fall, best with some water during dormancy	\N	\N	\N
BX 303	BULBS	1	Alocasia X Mark Campbell	Jude Platteborze	Tubers various sizes	\N	\N	\N
BX 303	SEEDS	2	Hippeastrum nelsonii	Stephen Putman	(LIMITED SUPPLY)	\N	\N	\N
BX 303	BULBS	3	Ledebouria cooperi	Monica Swartz	ex BX 169	\N	\N	\N
BX 303	SEEDS	4	Ornithogalum glandulosum	Monica Swartz	ex Jim Duggan Flower Nursery	\N	\N	\N
BX 303	SEEDS	5	Chlorophytum orchidantheroides or amaniense	Monica Swartz	Yes the Chlorophytum is geophytic. They have big fat storage roots and some individuals die back to the ground in winter. I recommend that this species NOT be grown in frost free areas because it is very fecund and could become invasive. Sow seeds thinly because most seeds germinate and since most of the plant is below ground, the pot will get too crowded very fast. The flashy orange leaf bases will develop after the first year.	\N	\N	\N
BX 303	SEEDS	6	Boophane disticha	Fereydoun Sharifi	\N	\N	\N	\N
BX 303	SEEDS	7	Boophane haemanthoides	Fereydoun Sharifi	\N	\N	\N	\N
BX 303	SEEDS	8	Brunsvigia radulosa	Fereydoun Sharifi	\N	\N	\N	\N
BX 303	SEEDS	9	Calydorea amabilis	Fereydoun Sharifi	\N	\N	\N	\N
BX 303	SEEDS	10	Ceropegia ampliata (Asclepidaceae)	Fereydoun Sharifi	\N	\N	\N	\N
BX 303	SEEDS	11	Ceropegia macmasteri	Fereydoun Sharifi	\N	\N	\N	\N
BX 303	SEEDS	12	Cipura paludosa	Fereydoun Sharifi	\N	\N	\N	\N
BX 303	SEEDS	13	Cyclamen graecum anatolicum	Fereydoun Sharifi	\N	\N	\N	\N
BX 303	SEEDS	14	Cyclamen hederifolium 'Perlenteppich'	Fereydoun Sharifi	\N	\N	\N	\N
BX 303	SEEDS	15	Cyclamen x hildebrandtii	Fereydoun Sharifi	\N	\N	\N	\N
BX 303	SEEDS	16	Cyrtanthus falcatus	Fereydoun Sharifi	\N	\N	\N	\N
BX 303	SEEDS	17	Cyrtanthus galpinii	Fereydoun Sharifi	\N	\N	\N	\N
BX 303	SEEDS	18	Diplarrhena moraea	Fereydoun Sharifi	\N	\N	\N	\N
BX 303	SEEDS	19	Gladiolus miniatus	Fereydoun Sharifi	\N	\N	\N	\N
BX 303	SEEDS	20	Gladiolus sericeo-villosus	Fereydoun Sharifi	\N	\N	\N	\N
BX 303	SEEDS	21	Gladiolus vandermerwei	Fereydoun Sharifi	\N	\N	\N	\N
BX 303	SEEDS	22	Iris (Juno) albomarginata	Fereydoun Sharifi	\N	\N	\N	\N
BX 303	SEEDS	23	Iris (Juno) aucheri, white and dark	Fereydoun Sharifi	\N	\N	\N	\N
BX 303	SEEDS	24	Iris (Juno) zenaidae	Fereydoun Sharifi	\N	\N	\N	\N
BX 303	SEEDS	25	Narcissus miniatus	Fereydoun Sharifi	ex Seville, Spain	\N	\N	\N
BX 303	SEEDS	26	Scadoxus puniceus	Fereydoun Sharifi	\N	\N	\N	\N
BX 303	SEEDS	27	Zephyra elegans	Fereydoun Sharifi	\N	\N	\N	\N
BX 304	BULBS	1	Crinum 'digweedii'	Mark Lysne	\N	\N	\N	\N
BX 304	BULBS	2	Crinum 'Purple Prince'	Mark Lysne	\N	\N	\N	\N
BX 304	BULBS	3	Hymenocallis probably 'Tropical Giant'	Mark Lysne	\N	\N	\N	\N
BX 304	SEEDS	4	Zephyranthes dichromantha	Ina Crossley	\N	\N	\N	\N
BX 304	SEEDS	5	Zephyranthes 'Hidalgo'	Ina Crossley	\N	\N	\N	\N
BX 304	SEEDS	6	Zephyranthes "Hidalgo 'John Fellers'"	Ina Crossley	\N	\N	\N	\N
BX 304	SEEDS	7	Zephyranthes primulina	Ina Crossley	\N	\N	\N	\N
BX 304	SEEDS	8	Habranthus robusta 'Russell Manning'	Ina Crossley	\N	\N	\N	\N
BX 304	SEEDS	9	Zephyranthes citrina	Ina Crossley	\N	\N	\N	\N
BX 304	SEEDS	10	Zephyranthes flavissima	Ina Crossley	\N	\N	\N	\N
BX 304	SEEDS	11	Zephyranthes drummondii	Ina Crossley	\N	\N	\N	\N
BX 304	BULBS	12	Rhizomes of Achimenes erecta	Dennis Kramb	\N	\N	\N	\N
BX 304	BULBS	13	Rhizomes of Diastema vexans	Dennis Kramb	\N	\N	\N	\N
BX 304	BULBS	14	Rhizomes of Gloxinella lindeniana	Dennis Kramb	\N	\N	\N	\N
BX 304	SEEDS	15	Seeds of Gloxinella lindeniana	Dennis Kramb	\N	\N	\N	\N
BX 304	BULBS	16	Achimenes 'Desiree'	Dennis Kramb	Propagules (aerial rhizomes)	\N	\N	\N
BX 304	BULBS	17	Eucrosia bicolor	Monica Swartz	Small bulbs	\N	\N	\N
BX 304	SEEDS	18	Agapanthus campanulatus	PBS	\N	\N	\N	\N
BX 304	SEEDS	19	Cyrtanthus epiphyticus	PBS	\N	\N	\N	\N
BX 304	SEEDS	20	Dierama trichorhizum?	PBS	\N	\N	\N	\N
BX 304	SEEDS	21	Dierama dracomontanum	PBS	\N	\N	\N	\N
BX 304	SEEDS	22	Kniphofia ichopensis	PBS	\N	\N	\N	\N
BX 304	SEEDS	23	Kniphofia ritualis	PBS	\N	\N	\N	\N
BX 305	BULBS	1	Ledebouria cooperi	Mary Sue Ittner	a small summer grower from South Africa	\N	\N	\N
BX 305	BULBS	2	Oxalis sp.	Mary Sue Ittner	from Ul. collected in Oaxaca, Mexico. It is summer growing and blooming	\N	\N	\N
BX 305	BULBS	3	Polianthes gemiflora	Mary Sue Ittner	syn Bravoa geminiflora - summer growing and flowering	\N	\N	\N
BX 305	BULBS	4	Zephyranthes candida	Jim Waddick	This is the starter drug for Rain lily fans. Among the easiest, most vigorous and available of all rain lilies. Single white 6 petal flowers appear by 'magic' during and after summer rain. Very easy. Hrdiness? Zone 6/7	\N	\N	\N
BX 305	BULBS	5	Oxalis tetraphylla 'Iron Cross'	Nhu Nguyen	this is one of those widespread plants with nice leaves and prolific flowers. It is larger so it can be grown in the ground with other landscaping plants. It doesn't mind winter water as long as the media is really well drained.	\N	\N	\N
BX 305	BULBS	6	Gladiolus dalenii	Nhu Nguyen	grown from seeds, 2 years old	\N	\N	\N
BX 305	BULBS	7	Tigridia pavonia	Nhu Nguyen	typical red/orange form, grown from seeds, 2 years old, should bloom in the 3rd or 4th year.	\N	\N	\N
BX 305	SEEDS	8	Cyrtanthus galpinii	Nhu Nguyen	wild collected seeds from KwaZulu-Natal South Africa	\N	\N	\N
BX 305	SEEDS	9	Melasphaerula ramosa	Nhu Nguyen	I got these from a friend but I already have some so I'm passing them on.	\N	\N	\N
BX 305	SEEDS	10	Triteleia clementina	Nhu Nguyen	\N	\N	\N	\N
BX 305	SEEDS	11	Lapeirousia aff. jacquinii	Nhu Nguyen	\N	\N	\N	\N
BX 305	SEEDS	12	Hesperoxiphion peruvianum	Nhu Nguyen	\N	\N	\N	\N
BX 305	SEEDS	13	Calochortus catalinae	Bob Werra	\N	\N	\N	\N
BX 305	SEEDS	14	Moraea ciliate, blue	Bob Werra	\N	\N	\N	\N
BX 305	SEEDS	15	Moraea macrocarpa	Bob Werra	\N	\N	\N	\N
BX 305	SEEDS	16	Moraea pendula	Bob Werra	\N	\N	\N	\N
BX 305	SEEDS	17	Moraea polyanthus	Bob Werra	\N	\N	\N	\N
BX 305	SEEDS	18	Moraea tripetala	Bob Werra	\N	\N	\N	\N
BX 305	SEEDS	19	Moraea vegeta	Bob Werra	\N	\N	\N	\N
BX 305	SEEDS	20	Moraea vespertina	Bob Werra	\N	\N	\N	\N
BX 305	SEEDS	21	Romulea grandiscapa	Bob Werra	? uncertain	\N	\N	\N
BX 307	SEEDS	1	Hippeastrum striatum	Stephen Putman	\N	\N	\N	\N
BX 307	SEEDS	2	Aristea ecklonii	SIGNA	The following seeds were donated by the Species Iris Group of North America	\N	\N	\N
BX 307	SEEDS	3	Babiana, mixed	SIGNA	\N	\N	\N	\N
BX 307	SEEDS	4	Cipura paludosa	SIGNA	\N	\N	\N	\N
BX 307	SEEDS	5	Crocus versicolor	SIGNA	\N	\N	\N	\N
BX 307	SEEDS	6	Cypella herbertii	SIGNA	\N	\N	\N	\N
BX 307	SEEDS	7	Dietes grandiflora	SIGNA	\N	\N	\N	\N
BX 307	SEEDS	9	Dietes iridioides	SIGNA	\N	\N	\N	\N
BX 307	SEEDS	10	Gladiolus tristis	SIGNA	\N	\N	\N	\N
BX 307	SEEDS	11	Moraea huttonii	SIGNA	\N	\N	\N	\N
BX 307	SEEDS	12	Moraea polystachya	SIGNA	\N	\N	\N	\N
BX 307	SEEDS	13	Moraea setifolia	SIGNA	\N	\N	\N	\N
BX 307	SEEDS	14	Moraea vegeta	SIGNA	\N	\N	\N	\N
BX 307	SEEDS	15	Sisyrinchium angustifolium	SIGNA	\N	\N	\N	\N
BX 307	SEEDS	16	Sisyrinchium bermudianum	SIGNA	\N	\N	\N	\N
BX 307	SEEDS	17	Sisyrinchium idahoense	SIGNA	\N	\N	\N	\N
BX 307	SEEDS	18	Sparaxis caryophyllacea	SIGNA	\N	\N	\N	\N
BX 307	SEEDS	19	Sparaxis tricolor	SIGNA	\N	\N	\N	\N
BX 308	SEEDS	1	Massonia depressa	From Sophie Dixon:	\N	\N	\N	\N
BX 308	SEEDS	2	Clivia miniata, yellow hybrids	From Peter Taggart:	\N	\N	\N	\N
BX 308	SEEDS	3	Fritillaria pallida	From Peter Taggart:	\N	\N	\N	\N
BX 308	SEEDS	4	Fritillaria sewerzowi	From Peter Taggart:	\N	\N	\N	\N
BX 308	SEEDS	5	Iris magnifica	From Peter Taggart:	ex Agalik	\N	\N	\N
BX 308	SEEDS	6	Iris Pacific Coast hybrids	From Peter Taggart:	\N	\N	\N	\N
BX 308	SEEDS	7	Corydalis	From Peter Taggart:	Leontocoides section, probably C. popovii or else mixed hybrids including genes from popovii, maracandica, and ledbouriana. Fresh seed which should be sown as quickly as possible	\N	\N	\N
BX 308	SEEDS	8	Tulipa binutans	From Peter Taggart:	(OP) ex Ruksans	\N	\N	\N
BX 308	SEEDS	9	Tulipa ferghanica	From Peter Taggart:	? (OP)	\N	\N	\N
BX 308	SEEDS	10	Tulipa biebersteiniana	From Peter Taggart:	(OP)	\N	\N	\N
BX 308	SEEDS	11	Tulipa turkestanica	From Peter Taggart:	(OP)	\N	\N	\N
BX 308	SEEDS	12	Tulipa kolpakowskiana	From Peter Taggart:	(OP)	\N	\N	\N
BX 308	SEEDS	13	Tulipa sprengeri	From Peter Taggart:	(OP), goes very deep and will grow on acid sand	\N	\N	\N
BX 308	SEEDS	14	Tulipa vvedenskyi	From Peter Taggart:	(OP)	\N	\N	\N
BX 308	SEEDS	15	Tulipa vvedenskyi	From Peter Taggart:	(OP) large form	\N	\N	\N
BX 308	SEEDS	16	Paeonia mascula	From Peter Taggart:	?	\N	\N	\N
BX 308	BULBS	17	Nothoscordum bivalve	From Peter Taggart:	BULBILS	\N	\N	\N
BX 308	BULBS	18	Triteleia hyacinthina	From Peter Taggart:	BULBILS	\N	\N	\N
BX 308	BULBS	19	Achimenes grandiflora ‘Robert Dressler’	From Lynn Makela:	\N	\N	\N	\N
BX 308	BULBS	20	Achimenes ‘Pink Cloud’	From Lynn Makela:	\N	\N	\N	\N
BX 308	BULBS	21	Eucodonia verticillata	From Lynn Makela:	\N	\N	\N	\N
BX 308	BULBS	22	Sinningia amambayensis	From Lynn Makela:	\N	\N	\N	\N
BX 308	BULBS	23	Crinum `menehume'	From Lynn Makela:	(C. oliganthum x C. procerum)? 2', red leaves, pink flowers, Z 8b. "I grow it in full sun with average water. A very nice plant that can be grown in bog conditions" FEW	\N	\N	\N
BX 308	BULBS	24	Hippeastrum 'San Antonio Rose'	From Lynn Makela:	\N	\N	\N	\N
BX 308	BULBS	25	Nothoscordum felippenei	From Lynn Makela:	\N	\N	\N	\N
BX 308	BULBS	26	Onixotis stricta	From Lynn Makela:	\N	\N	\N	\N
BX 308	BULBS	27	Oxalis goniorhiza	From Lynn Makela:	VERY FEW	\N	\N	\N
BX 309	BULBS	1	Drimiopsis maculata	From Roy Herold:	Offsets and near-blooming size.	\N	\N	\N
BX 309	BULBS	2	Drimiopsis kirkii	From Roy Herold:	Offsets and near-blooming size.	\N	\N	\N
BX 309	SEEDS	3	Eucomis zambesiaca	From Roy Herold:	outside chance some are crossed with E. vandermervii.	\N	\N	\N
BX 309	SEEDS	4	Ophiopogon umbraticola	From Roy Herold:	received as O. chingii, new ID by Mark McDonough. Berries have been left uncleaned so you can admire the iridescent blue color. Clean before planting.	\N	\N	\N
BX 309	SEEDS	5	Clivia 'Anna's Yellow'	From Roy Herold:	OP; from the magnificent garden of my wife's aunt in Hilton, KZN.	\N	\N	\N
BX 309	BULBS	6	Clivia 'Shortleaf Yellow x Shortleaf Yellow' OP	From Roy Herold:	OP; from seedlings grown from Nakamura seed by Matt Mattus and Joe Philip.	\N	\N	\N
BX 309	BULBS	7	Clivia 'Monk x Daruma' OP	From Roy Herold:	OP; from seedlings grown from Nakamura seed by Matt Mattus and Joe Philip.	\N	\N	\N
BX 309	BULBS	8	Clivia 'Multipetal x Self'	From Roy Herold:	OP--this one tends to throw interesting crested offsets. from seedlings grown from Nakamura seed by Matt Mattus and Joe Philip.	\N	\N	\N
BX 309	BULBS	9	Gladiolus flanaganii	Paul Otto	Small corms	\N	\N	\N
BX 309	SEEDS	10	Seed of Bomarea sp. (acutifolia?)	From Max Withers:	ex Nhu Nguyen OP, probably selfed	\N	\N	\N
BX 309	SEEDS	11	Brachylaena discolor	From Roland de Boer:	(only one order of each)	\N	\N	\N
BX 309	SEEDS	12	Dietes butcheriana	From Roland de Boer:	(only one order of each)	\N	\N	\N
BX 309	SEEDS	13	Eucomis, mixed spp	From Roland de Boer:	(only one order of each)	\N	\N	\N
BX 309	SEEDS	14	Kniphofia uvaria	From Roland de Boer:	(only one order of each)	\N	\N	\N
BX 309	SEEDS	15	Monopsis lutea	From Roland de Boer:	(only one order of each)	\N	\N	\N
BX 309	SEEDS	16	Polyxena ensifolia var ensifolia	From Roland de Boer:	(only one order of each)	\N	\N	\N
BX 309	SEEDS	17	Gentiana flavida	From Roland de Boer:	(more than one order available)	\N	\N	\N
BX 309	SEEDS	18	Aeonium hierrense	From Roland de Boer:	(more than one order available)	\N	\N	\N
BX 309	SEEDS	19	Colchicum corsicum ?	From Roland de Boer:	(more than one order available)	\N	\N	\N
BX 309	SEEDS	20	Galanthus reginae-olgae ssp reginae-olgae ex Sicily	From Roland de Boer:	(more than one order available)	\N	\N	\N
BX 309	SEEDS	21	Polygonatum alte-lobatum	From Roland de Boer:	(more than one order available)	\N	\N	\N
BX 310	SEEDS	1	Hippeastrum striatum	From Jim Jones:	\N	\N	\N	\N
BX 310	SEEDS	2	Narcissus 'Nylon'	From Jim Jones:	\N	\N	\N	\N
BX 310	SEEDS	3	Hippeastrum papilio	From Marvin Ellenbecker:	\N	\N	\N	\N
BX 310	SEEDS	4	Gladiolus dalenii	From Jonathan Lubar:	\N	\N	\N	\N
BX 310	SEEDS	5	Freesia laxa, blue	From Jonathan Lubar:	\N	\N	\N	\N
BX 310	BULBS	6	Oxalis hirta	From Jonathan Lubar:	\N	\N	\N	\N
BX 310	BULBS	7	Neomarica gracilis	From Dell Sherk:	\N	\N	\N	\N
BX 310	BULBS	8	Agapanthus	From Fred Biasella:	light blue, dwarf form	\N	\N	\N
BX 310	BULBS	9	Hymenocallis	From Fred Biasella:	Small bulbs of Hymenocallis (Ismene), fragrant white flowers, "Peruvian daffodil"	\N	\N	\N
BX 310	BULBS	10	Eucomis comosa	From Fred Biasella:	white/green flowers, coconut fragrance	\N	\N	\N
BX 310	BULBS	11	Cyranthus mackenii	From Fred Biasella:	Small bulbs, yellow	\N	\N	\N
BX 313	SEEDS	1	Allium christophii	Gordon Julian	\N	\N	\N	\N
BX 313	SEEDS	2	Arthropodium candidum 'Bronze'	Gordon Julian	\N	\N	\N	\N
BX 313	SEEDS	3	Arum creticum	Gordon Julian	\N	\N	\N	\N
BX 313	SEEDS	4	Arum purpureospathum	Gordon Julian	\N	\N	\N	\N
BX 313	SEEDS	5	Babiana stricta hybrids	Gordon Julian	\N	\N	\N	\N
BX 313	SEEDS	6	Colchicum corsicum	Gordon Julian	\N	\N	\N	\N
BX 313	SEEDS	7	Cyclamen coum ex CSE	Gordon Julian	\N	\N	\N	\N
BX 313	SEEDS	8	Cyclamen graecum	Gordon Julian	\N	\N	\N	\N
BX 313	SEEDS	9	Cyclamen hederifolium	Gordon Julian	\N	\N	\N	\N
BX 313	SEEDS	10	Cyclamen libanoticum	Gordon Julian	\N	\N	\N	\N
BX 313	SEEDS	11	Cyclamen persicum	Gordon Julian	\N	\N	\N	\N
BX 313	SEEDS	12	Cyclamen purpurascens	Gordon Julian	\N	\N	\N	\N
BX 313	SEEDS	13	Dierama pulcherrimum purple form	Gordon Julian	\N	\N	\N	\N
BX 313	SEEDS	14	Dierama trichorrhizum	Gordon Julian	\N	\N	\N	\N
BX 313	SEEDS	15	Fritillaria acmopetala	Gordon Julian	\N	\N	\N	\N
BX 313	SEEDS	16	Fritillaria affinis	Gordon Julian	\N	\N	\N	\N
BX 313	SEEDS	17	Fritillaria biflora	Gordon Julian	\N	\N	\N	\N
BX 313	SEEDS	18	Galtonia candicans	Gordon Julian	\N	\N	\N	\N
BX 313	SEEDS	19	Galtonia regalis	Gordon Julian	\N	\N	\N	\N
BX 313	SEEDS	20	Gladiolus carneus	Gordon Julian	\N	\N	\N	\N
BX 313	SEEDS	21	Gladiolus geardii	Gordon Julian	\N	\N	\N	\N
BX 313	SEEDS	22	Gladiolus oppositiflorus ssp.salmonoides	Gordon Julian	\N	\N	\N	\N
BX 313	SEEDS	24	Veltheimia bracteata, soft pink color	Gordon Julian	\N	\N	\N	\N
BX 313	SEEDS	25	Griffinia espiritensis var. espiritensis	Dave Boucher	\N	\N	\N	\N
BX 313	SEEDS	26	Hippeastrum brasilianum	Dave Boucher	\N	\N	\N	\N
BX 315	SEEDS	1	Ammocharis tinneana	Lee Poulsen	AMARYLLIDS: (LIMITED SUPPLIES)	\N	\N	\N
BX 315	SEEDS	2	Brunsvigia littoralis	Lee Poulsen	AMARYLLIDS: (LIMITED SUPPLIES)	\N	\N	\N
BX 315	SEEDS	3	Gethyllis villosa	Lee Poulsen	AMARYLLIDS: (LIMITED SUPPLIES)	\N	\N	\N
BX 315	SEEDS	4	Haemanthus nortieri	Lee Poulsen	AMARYLLIDS: (LIMITED SUPPLIES)	\N	\N	\N
BX 315	SEEDS	5	Nerine laticoma	Lee Poulsen	AMARYLLIDS: (LIMITED SUPPLIES)	\N	\N	\N
BX 315	SEEDS	6	Strumaria discifera, ex Nieuwoudtville	Lee Poulsen	AMARYLLIDS: (LIMITED SUPPLIES)	\N	\N	\N
BX 315	SEEDS	7	Baeometra uniflora	Lee Poulsen	\N	\N	\N	\N
BX 315	SEEDS	8	Lapeirousia enigmata	Lee Poulsen	\N	\N	\N	\N
BX 315	SEEDS	9	Nothoscordum montevidense	Lee Poulsen	few	\N	\N	\N
BX 315	SEEDS	10	Tropaeolum azureum	Lee Poulsen	(few)	\N	\N	\N
BX 316	SEEDS	1	Crinum bulbispermum	Jay Yourch	all from Jumbo selections. Very cold hardy.	\N	\N	\N
BX 314	BULBS	25	Habranthus magnoi	Pam Slate	\N	\N	\N	\N
BX 314	BULBS	26	Oxalis stenorhyncha	Pam Slate	\N	\N	\N	\N
BX 314	BULBS	27	Oxalis regnellii	Pam Slate	\N	\N	\N	\N
BX 317	SEEDS	1	Albuca spiralis	Nhu Nguyen	tight curly form, OP	http://flickr.com/photos/xerantheum/…	\N	\N
BX 313	SEEDS	23.1	Gladiolus tristis	Gordon Julian	First item #23	\N	\N	\N
BX 316	BULBS	2	Crinum bulbispermum 'Wide Open White' x C. 'Spring Joy'	Jay Yourch	from crosses which I made in 2006. Their flowers are variable, showing the diversity of genes present in their parents. They should be very cold hardy, likely doing well into zone 6. They start flowering before any other Crinum in my garden, usually April here in central North Carolina, although they got started in March this year and continued into June. There are bulbs with white flowers and bulbs with pale pink flowers, and they are labeled.hey are labeled.	\N	\N	\N
BX 316	BULBS	3	Crinum pedunculatum	Jay Yourch	Fairly tender, Zone 8, but does well in colder areas if grown in a large container and protected from freezing temperatures. A greenhouse is not required, my spends each winter in a cool garage (above freezing) and looks nearly as good in early spring as it did the previous autumn. While I enjoy its spidery, white flowers, Isenjoy its architectural foliage even more.	\N	\N	\N
BX 316	BULBS	4	Cyrtanthus loddigesianus	Terry Laskiewicz	clear pink, original seed from SGRC. Plant immediately.	\N	\N	\N
BX 316	BULBS	5	Hyacinthoides lingulata	Terry Laskiewicz	fall blooming, "perfect leaves"	\N	\N	\N
BX 316	BULBS	6	Notholirion thompsonianum	Terry Laskiewicz	from Jane McGary	\N	\N	\N
BX 306	SEEDS	1	Nerine rehmannii	Pieter van der Walt	W/C Johannesburg, Gauteng	\N	\N	\N
BX 306	SEEDS	2	Moraea stricta	Pieter van der Walt	W/C Broederstroom, Gauteng	\N	\N	\N
BX 306	SEEDS	4	Xerophyta retinervis	Pieter van der Walt	W/C Muldersdrift, Gauteng	\N	\N	\N
BX 306	SEEDS	5	Asclepidaceae sp.	Pieter van der Walt	W/C Malolotja, Swaziland (Flowers not seen)	\N	\N	\N
BX 306	SEEDS	6	Adenium swazicum	Pieter van der Walt	Ex Hort.	\N	\N	\N
BX 306	BULBS	7	Polianthes x bundrantii	Jim Waddick	See Polianthes wiki page. These are offsets from mature blooming bulbs and few will bloom soon, others take a bit. An interesting cross with tall spikes of tubular red-pink flowers. No scent. I keep them almost totally dry all winter in cool storage indoors here.	\N	\N	\N
BX 306	BULBS	8	Sprekelia formosissima	Jim Waddick	See Sprekelia wiki page. These are a mix of two clones mostly the typical and a couple 'Orient Red'. Both bloom and get treated like typical Hippeastrum cvs.	\N	\N	\N
BX 306	SEEDS	10	Haemanthus humilis	PBS	red stem	\N	\N	\N
BX 306	SEEDS	11	Haemanthus humilis	PBS	yellow throat	\N	\N	\N
BX 306	SEEDS	12	Nerine laticoma	PBS	short stem	\N	\N	\N
BX 306	SEEDS	13	Nerine laticoma	PBS	with red stripe	\N	\N	\N
BX 306	SEEDS	14	Scadoxus puniceus	PBS	light pink	\N	\N	\N
BX 306	SEEDS	15	Scadoxus puniceus	PBS	dark pink stripe	\N	\N	\N
BX 306	BULBS	16	Rhizomes of Achimenes	From Joyce Miller:	mixed	\N	\N	\N
BX 314	BULBS	1	Oxalis callosa	Mary Sue Ittner	Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers).	\N	w	\N
BX 314	BULBS	2	Oxalis commutata	Mary Sue Ittner	Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers).	\N	w	\N
BX 314	BULBS	3	Oxalis depressa MV4871	Mary Sue Ittner	Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers).	\N	w	\N
BX 314	BULBS	4	Oxalis engleriana	Mary Sue Ittner	Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers).	\N	w	\N
BX 314	BULBS	5	Oxalis fabaefolia	Mary Sue Ittner	(Christiaan says this is now considered a form of flava) Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers).	\N	w	\N
BX 314	BULBS	6	Oxalis hirta	Mary Sue Ittner	Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers).	\N	w	\N
BX 314	BULBS	7	Oxalis hirta	Mary Sue Ittner	(mauve form) Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers)	\N	w	\N
BX 314	BULBS	8	Oxalis hirta 'Gothenburg'	Mary Sue Ittner	(giant form) Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers).	\N	w	\N
BX 314	BULBS	9	Oxalis melanosticta 'Ken Aslet'	Mary Sue Ittner	(blooms best in deep pot) Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers)	\N	w	\N
BX 314	BULBS	10	Oxalis palmifrons	Mary Sue Ittner	(grown for the leaves as most of us never see any flowers) Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers)	\N	w	\N
BX 314	BULBS	11	Oxalis purpurea	Mary Sue Ittner	(white flowers) Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers)	\N	w	\N
BX 314	BULBS	12	Oxalis purpurea 'Lavender & White'	Mary Sue Ittner	Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers).	\N	w	\N
BX 314	BULBS	13	Oxalis purpurea 'Skar'	Mary Sue Ittner	(pink flowers) Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers)	\N	w	\N
BX 314	BULBS	14	Oxalis zeekoevleyensis	Mary Sue Ittner	(one of the first to start into growth) Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers)	\N	w	\N
BX 314	BULBS	15	Tulipa batalini	Mary Sue Ittner	Very small bulbs	\N	w	\N
BX 314	SEEDS	16	Haemanthus albiflos	Mary Sue Ittner	evergreen	\N	e	\N
BX 314	BULBS	17	Narcissus 'Nylon'	Jim Jones	Small bulbs	\N	\N	\N
BX 314	SEEDS	18	Crinum bulbispermum 'Jumbo'	Jim Waddick	This was originated from the late Crinum expert Les Hannibal and distributed by Marcelle Sheppard. This species does not pup a lot, so must be grown from seed for practical purposes. Totally hardy here in Kansas City Zone 5/6. Flowers open well in shades of light to dark pink. recommended and easy.	\N	\N	\N
BX 314	SEEDS	19	Fritillaria persica	Jim Waddick	This is a tall clone with rich purple/brown flowers. Does not pup freely here, but quite hardy in Kansas City.	\N	\N	\N
BX 314	SEEDS	20	Camassia 'Sacajewea'	Jim Waddick	Flowers creamy white, foliage white thin white edges. Of 3 or 4 species grown, only this one has made seed. A good size plant may be a form of C. leichtlinii.	\N	\N	\N
BX 314	BULBS	21	Rhodophiala bifida	Rod Barton	triploid Rhodophiala bifida heirloom. It's a veritable weed here in North Texas.	\N	\N	\N
BX 314	BULBS	22	Lycoris radiata	Pam Slate	\N	\N	\N	\N
BX 314	BULBS	23	Zephyranthes (Cooperia) drummondii	Pam Slate	\N	\N	\N	\N
BX 314	BULBS	24	Zephyranthes 'Labuffarosea'	Pam Slate	\N	\N	\N	\N
BX 317	SEEDS	2	Albuca spiralis	Nhu Nguyen	semi lax form	http://flickr.com/photos/xerantheum/…	\N	\N
BX 317	SEEDS	3	Albuca spiralis	Nhu Nguyen	lax form. Barely curly at the tips of the leaves	\N	\N	\N
BX 317	SEEDS	4	Zephyranthes "datensis"	Nhu Nguyen	control pollinated. I got seeds of this species from Brazil. It was called "datensis" but it does not appear to be a validly published name. Not winter growing.	http://flickr.com/photos/xerantheum/…	\N	\N
BX 317	SEEDS	5	Cyrtanthus brachyscyphus control pollinated	Nhu Nguyen	control pollinated. This is a lovely orange form of the species and one of the easiest species of Cyrtanthus to grow. Not winter growing.	http://flickr.com/photos/xerantheum/…	\N	\N
BX 317	SEEDS	6	Romulea bulbocodium	Nhu Nguyen	OP	http://flickr.com/photos/xerantheum/…	\N	\N
BX 317	SEEDS	7	Massonia pustulata NNBH2151.1	Nhu Nguyen	OP	http://flickr.com/photos/xerantheum/…	\N	\N
BX 317	SEEDS	8	Massonia pustulata NNBH2153.1	Nhu Nguyen	OP	http://flickr.com/photos/xerantheum/…	\N	\N
BX 317	SEEDS	9	Massonia depressa NNBH1222.1	Nhu Nguyen	OP	http://flickr.com/photos/xerantheum/…	\N	\N
BX 317	SEEDS	10	Lachenalia longituba	Nhu Nguyen	OP. From Mary Sue Ittner. It is the form depicted on the Wiki	\N	\N	\N
BX 317	SEEDS	11	Sprekelia formosissima	Nhu Nguyen	OP. Not winter growing.	http://flickr.com/photos/xerantheum/…	s	\N
BX 317	SEEDS	12	Toxicoscordon freemontii Bear Valley Form	Nhu Nguyen	OP. This is a robust and very ornamental form of the species.	\N	\N	\N
BX 317	SEEDS	13	Babiana longituba	Nhu Nguyen	OP. It can flower in 3 years from seeds.	http://flickr.com/photos/xerantheum/…	\N	\N
BX 317	SEEDS	14	Sparaxis grandiflora ssp. grandiflora	Nhu Nguyen	OP	\N	\N	\N
BX 317	SEEDS	15	Sparaxis elegans	Nhu Nguyen	OP	\N	\N	\N
BX 317	SEEDS	16	Sparaxis tricolor	Nhu Nguyen	OP	\N	\N	\N
BX 317	SEEDS	17	Geissorhiza aspera	Nhu Nguyen	OP	\N	\N	\N
BX 317	SEEDS	18	Romulea hirta	Nhu Nguyen	OP	\N	\N	\N
BX 317	SEEDS	19	Geissorhiza corrugata	Nhu Nguyen	OP	\N	\N	\N
BX 317	SEEDS	20	Ferraria crispa	Nhu Nguyen	OP	\N	\N	\N
BX 317	SEEDS	21	Allium hyalinum	Nhu Nguyen	OP. white form	\N	\N	\N
BX 317	SEEDS	22	Hesperantha bachmanii	Nhu Nguyen	OP	\N	\N	\N
BX 317	SEEDS	23	Triteleia laxa	Nhu Nguyen	typical violet form - OP	\N	\N	\N
BX 317	SEEDS	24	Pelargonium appendiculatum	Terry Laskiewicz	winter blooming in cool greenhouse, for me	\N	\N	\N
BX 317	SEEDS	25	Romulea rohlfsianum	Terry Laskiewicz	from SGRC 2008, ex Croatia, wild collected, white, graceful	\N	\N	\N
BX 317	SEEDS	26	Rauhia decora	Colin Davis	\N	\N	\N	\N
BX 317	SEEDS	42	Boophane disticha	Ken Blackford	summer-blooming	\N	\N	\N
BX 318	BULBS	1	Moraea ciliate	M Gastil-Buhl	Cormlets. Miss-spelling of Moraea ciliata	\N	w	\N
BX 318	BULBS	2	Babiana pulchra	M Gastil-Buhl	white, corms ex Jim Duggan	\N	w	\N
BX 318	BULBS	3	Sparaxis tricolor hybrid	M Gastil-Buhl	ex UCSB, dk velvet red with yellow+black markings, corms	\N	w	\N
BX 318	BULBS	4	Haemanthus humilis humilis	Jim Shields	I assume these are all the pink flowered form, but they are not yet bloom size so I'm not sure.	\N	\N	\N
BX 318	BULBS	5	Chlorogalum pomeridianum	Shawn Pollard	Small bulbs	\N	\N	\N
BX 318	BULBS	6	Babiana 'Deep Dreams'	John Wickham	CORMS	\N	w	\N
BX 318	BULBS	7	Babiana 'Purple Haze'	John Wickham	CORMS	\N	w	\N
BX 318	BULBS	8	Babiana 'Brilliant Blue'	John Wickham	CORMS	\N	w	\N
BX 318	BULBS	9	Babiana 'Midnight Blues'	John Wickham	CORMS	\N	w	\N
BX 318	BULBS	10	Babiana 'Bright Eyes'	John Wickham	CORMS	\N	w	\N
BX 318	BULBS	11	Babiana angustifolia	John Wickham	CORMS	\N	w	\N
BX 318	BULBS	12	Babiana odorata	John Wickham	CORMS	\N	w	\N
BX 318	BULBS	13	Ipheion 'Rolf Fiedler'	John Wickham	CORMS. ex UCI	\N	w	\N
BX 318	BULBS	14	Tritonia 'Charles Puddles'	John Wickham	CORMS	\N	\N	\N
BX 318	BULBS	15	Tritonia hyalina	John Wickham	CORMS	\N	\N	\N
BX 318	BULBS	16	Tritonia 'Rosy Picture'	John Wickham	CORMS	\N	\N	\N
BX 318	BULBS	17	Ferraria ferrariola	Mary Sue Ittner	grown from seed, never bloomed so can't confirm identity (few)	\N	w	\N
BX 318	BULBS	18	Ferraria variabilis	Mary Sue Ittner	descendents from Robinett give-away marked F. divaricata. They have never bloomed and I'm giving up and hoping someone in a warmer climate in summer than mine will have success. I suspect that these are F. variabilis as F. divaricata has been reduced, part of it is not considered F. variabilis	\N	w	\N
BX 318	BULBS	19	Lachenalia aloides var. quadricolor	Mary Sue Ittner	mostly the small bulblets that form around the bulb	\N	w	\N
BX 318	BULBS	20	Oxalis bowiei	Mary Sue Ittner	very tall fall bloomer with pink flowers, best I suspect in deep pot	\N	w	\N
BX 318	BULBS	21	Oxalis caprina	Mary Sue Ittner	this one has a reputation as being weedy, but hasn't been any worse than some of the others, lilac flowers, late fall	\N	w	\N
BX 318	BULBS	22	Oxalis flava	Mary Sue Ittner	there are lots of different flava forms, this one has yellow flowers, fall bloomer	\N	w	\N
BX 318	BULBS	23	Oxalis flava (as namaquana)	Mary Sue Ittner	purchased as namaquana, but is flava, I think it is different than the one above, but can't remember exactly how	\N	w	\N
BX 317	SEEDS	27	Babiana pulchra	M Gastil-Buhl	white, seeds from 2011 corms ex JimDuggan	http://www.flickr.com/photos/gastils_garden/7475677940/in/set-72157630359362966/	w	\N
BX 317	SEEDS	28	Babiana purpurea	M Gastil-Buhl	some pinkish-purple, some bluish-purple, ex Jim Duggan	http://www.flickr.com/photos/gastils_garden/7475678438/in/set-72157630359362966/	w	\N
BX 317	SEEDS	29	Babiana 'Purple Haze'	M Gastil-Buhl	ex EasyToGrow	http://www.flickr.com/photos/gastils_garden/7475762562/in/set-72157630359362966/	w	\N
BX 318	BULBS	24	Oxalis gracilis	Mary Sue Ittner	orange flowers late fall, nicely divided leaves, short bloomer for me	\N	w	\N
BX 318	BULBS	25	Oxalis livida	Mary Sue Ittner	fall bloomer, very different leaves, check it out on the wiki, purple flowers	\N	w	\N
BX 318	BULBS	26	Oxalis namaquana	Mary Sue Ittner	small bulbs, bright yellow flowers in winter, low, seen in Namaqualand in mass in a wet spot	\N	w	\N
BX 318	BULBS	27	Oxalis obtusa	Mary Sue Ittner	winter blooming, didn't make a note of color	\N	w	\N
BX 318	BULBS	28	Oxalis obtusa MV 6341	Mary Sue Ittner	Nieuwoudtville. 1.5" bright yellow flowers. Tight, compact plants. Winter blooming	\N	w	\N
BX 318	BULBS	29	Oxalis polyphylla v heptaphylla MV6396	Mary Sue Ittner	fall bloomer, lavender flowers	\N	w	\N
BX 318	BULBS	30	Oxalis imbricata	Mary Sue Ittner	\N	\N	w	\N
BX 319	BULBS	1	Narcissus 'Stockens Gib'	Roy Herold	Another mystery from Lt Cdr Chris M Stocken. This one came to me from a friend who received it from a grower in Belgium. It was listed by the RHS as last being commercially available in 2005. The term 'gib' was a mystery to me, and originally I thought it to be an alternate spelling of a 'jib' sail. Google told me that a 'gib' is a castrated male cat or ferret. No thanks, but it also told me that 'gib' is short for Gibraltar. Stocken also collected in the Ronda mountains of Spain, and Gibraltar is just to the south, so is the probable origin of these bulbs. As for the bulb itself, it has never bloomed for me in ~8 years, but has multiplied like crazy. It has received the summer treatment recommended for plain old 'Stockens', but to no avail. Let me know how it turns out	\N	w	\N
BX 319	BULBS	2	Narcissus mixed seedlings	Roy Herold	These date back to a mass sowing in 2004 of seed from moderately controlled crosses of romieuxii, cantabricus, albidus, zaianicus, and similar early blooming sorts of the bulbocodium group. Colors tend to be light yellow through cream to white, and flowers are large, much larger than the little gold colored bulbocodiums of spring. These have been selected three times, and the keepers are choice. There is the odd runt, but 95% look to be blooming size	\N	w	\N
BX 319	BULBS	3	Albuca sp	Roy Herold	north of Calitzdorp, 12-18". Wild collected seed	\N	\N	\N
BX 319	BULBS	4	Albuca sp	Roy Herold	Paardepoort, north of Herold. Wild collected seed	\N	\N	\N
BX 319	BULBS	5	Albuca sp	Roy Herold	De Rust. Wild collected seed	\N	\N	\N
BX 319	BULBS	6	Albuca sp	Roy Herold	Volmoed, southwest of Oudtshoorn, only a couple. Wild collected seed	\N	\N	\N
BX 319	BULBS	7	Albuca sp	Roy Herold	Uniondale, 1 or 2 flowers per scape. Wild collected seed	\N	\N	\N
BX 319	BULBS	8	Lilium tigrinum	Jerry Lehmann	Bulbils	\N	\N	\N
BX 319	BULBS	9	Gladiolus murielae	Jonathan Lubar	\N	\N	\N	\N
BX 319	BULBS	10	Babiana sp.	Mary Sue Ittner	Corms. These have naturalized in my Northern California garden and are probably a form of Babiana stricta. Originally grown from mixed seed more than twenty years ago. Winter growing	\N	w	\N
BX 319	BULBS	11	Oxalis pulchella var tomentosa	Mary Sue Ittner	ex BX 221 and Ron Vanderhoff - Low, pubescent, mat forming foliage and large very pale salmon colored flowers. Fall blooming. This one hasn't bloomed for me yet, but I hope it will this year.	\N	w	\N
BX 319	BULBS	12	Oxalis semiloba	Mary Sue Ittner	originally from Uli, this is supposed to be a summer rainfall species, but grows for me in winter and dormant in summer. It never bloomed but the leaves reminded me of Oxalis boweii.  Chuck Powell provided me with some photos of this species he grow successfully (also on a winter growing schedule) and I added them to the wiki. I can't confirm the identity of these.	\N	w	\N
BX 319	BULBS	13	Oxalis obtusa	Mary Sue Ittner	Oxalis obtusa (peach flowers), winter-growing	\N	w	\N
BX 319	BULBS	14	Oxalis flava	Mary Sue Ittner	Oxalis flava (lupinifolia form), winter-growing	\N	w	\N
BX 319	BULBS	15	Ammocharis longifolia	Mary Sue Ittner	syn. Cybistetes longifolia, (survivors from seed sown from Silverhill Seed in 2000 and 2005). It can take 8 to 10 years to flower so I may be giving up too soon, but I suspect they need more summer heat and bright light than I can provide so I'm letting someone else have a crack at them.	\N	\N	\N
BX 319	BULBS	16	Gladiolus flanaganii	PBS	small corms	\N	\N	\N
BX 319	BULBS	17	Zephyranthes 'Labuffarosea'	PBS	small bulbs	\N	\N	\N
BX 319	BULBS	18	Tigridia pavonia	PBS	small corms	\N	\N	\N
BX 319	BULBS	19	Gladiolus dalenii	PBS	small corms	\N	\N	\N
BX 320	SEEDS	1	Ipheion uniflorum 'Charlotte Bishop'	Kathleen Sayce:	pink	\N	w	\N
BX 320	SEEDS	2	Arum palaestinum	From Arnold Trachtenberg:	\N	\N	\N	\N
BX 320	SEEDS	3	Arum korolkowii	From Arnold Trachtenberg:	\N	\N	\N	\N
BX 320	BULBS	4	Arisaema draconitum 'Green Dragon'	From Jerry Lehmann:	Seedling tubers. Collected seed "cluster" fall of 2 from habitat. Placed in protected location on soilsurface at my house over winter, cleaned and separated seeds and immediately sowed at the end of March 2011.	\N	\N	\N
BX 320	SEEDS	5	Camassia 'Sacajawea'	From Jerry Lehmann:	Mine is in full sun until 3 pm. Then light shade. Holds foliage color well.	\N	\N	\N
BX 320	SEEDS	6	Zigadenus nuttallii	From Jerry Lehmann:	ex Riley County, Kansas	\N	\N	\N
BX 320	SEEDS	7	Hippeastrum stylosum	From Stephen Putman:	\N	\N	\N	\N
BX 320	SEEDS	8	Allium 'Globemaster'	From Phil Andrews:	and similar white alliums. Both have identical leaf forms and flower stalk heights, so they go well together. I don't know if they come true from seed yet.	\N	\N	\N
BX 320	SEEDS	9	Arum purpureospathum	From Mary Sue Ittner:	\N	\N	\N	\N
BX 320	SEEDS	10	Cyrtanthus mackenii	From Mary Sue Ittner:	not sure which color form	\N	\N	\N
BX 320	SEEDS	11	Manfreda erubescens	From Shawn Pollard:	I got the seeds for my plants from the BX years ago and this is the most beautiful and successful of the Manfredas inmy Yuma garden.	\N	\N	\N
BX 320	SEEDS	12	Nyctaginia capitata	From Shawn Pollard:	This tuberous-rooted ground cover (scarletmuskflower or ramillete del diablo) from West Texas doesn't mind Yuma'ssummer heat one bit. Yes, the flowers are musky, like a carob.	\N	\N	\N
BX 320	SEEDS	13	Amoreuxia palmatifida	From Shawn Pollard:	(Mexican yellowshow).	\N	\N	\N
BX 320	SEEDS	14	Amoreuxia gonzalezii	From Shawn Pollard:	(Santa Rita yellowshow).	\N	\N	\N
BX 320	SEEDS	15	Ascelpias albicans	From Shawn Pollard:	A stem-succulent relative of the tuberous milkweeds, this is a hard-core xerophyte with no frost tolerance that grows on rocky slopes from where all cold air drains away in winter. Tarantula hawks love the flowers	\N	\N	\N
BX 320	SEEDS	16	Bowiea volubilis	From Shirley Meneice:	\N	\N	\N	\N
BX 320	SEEDS	17	Anomatheca laxa, red	From Shirley Meneice:	that is a Lapeirousia or some other Irid now	\N	\N	\N
BX 320	SEEDS	18	Hymenocallis astrostephana	From Dave Boucher:	\N	\N	\N	\N
BX 320	SEEDS	19	Lilium formosanum	From Steven Hart:	\N	\N	\N	\N
BX 320	SEEDS	20	Habranthus robustus	From Steven Hart:	\N	\N	\N	\N
BX 320	SEEDS	21	Veltheimia bracteata	From Richard Hart:	\N	\N	w	\N
BX 320	SEEDS	22	Datura sp. "Moonflower"	From Richard Hart:	\N	\N	\N	\N
BX 320	SEEDS	23	Worsleya procera	Fereydoun Sharifi	4 seeds (3 from Brazilian plant + 1 from Australian plant)	\N	\N	\N
BX 320	SEEDS	24	Nerine humilis	Fereydoun Sharifi	Nerine humilis: Early season/large flower/pale pink	\N	\N	\N
BX 320	SEEDS	25	Nerine humilis	Fereydoun Sharifi	Nerine humilis: Mid season/dark pink	\N	\N	\N
BX 320	SEEDS	26	Nerine humilis	Fereydoun Sharifi	Nerine humilis: Late season/small flower	\N	\N	\N
BX 320	SEEDS	27	Nerine filifolia	Fereydoun Sharifi	\N	\N	\N	\N
BX 320	SEEDS	28	Nerine undulata	Fereydoun Sharifi	\N	\N	\N	\N
BX 320	SEEDS	29	Nerine undulata alta	Fereydoun Sharifi	\N	\N	\N	\N
BX 320	SEEDS	30	Pucara leucantha	From Dell Sherk:	(few)	\N	\N	\N
BX 320	SEEDS	31	Cyrtanthus	From Dell Sherk:	\N	\N	\N	\N
BX 320	SEEDS	32	Lewisia brachycalyx	From Nhu Nguyen:	OP, W, no other species blooming at the same time, probably pure	\N	\N	\N
BX 320	SEEDS	33	Lapeirousia corymbosa	From Nhu Nguyen:	OP, W, although no other Lapeirousia blooming at the same time, probably pure	\N	\N	\N
BX 320	SEEDS	34	Babiana ringens	From Nhu Nguyen:	OP, W, nice red form	\N	\N	\N
BX 320	SEEDS	35	Calochortus luteus NNBH69.1	From Nhu Nguyen:	OP, W	\N	\N	\N
BX 320	SEEDS	36	Calochortus luteus NNBH2	From Nhu Nguyen:	OP, W, collected from a native patch in a friend's yard in the foothills of the Sierra Nevada. These are supposed to have nice brown markings. I have some extra so I'm sharing them.	\N	\N	\N
BX 320	SEEDS	37	Solenomelus pedunculatus	From Nhu Nguyen:	OP, W, probably pure since no other irids were blooming at the same time.	\N	\N	\N
BX 320	SEEDS	38	Allium unifolium	From Nhu Nguyen:	OP, W.	\N	\N	\N
BX 320	SEEDS	39	Tulbaghia acutiloba	From Nhu Nguyen:	cross pollinated between two forms, S	\N	\N	\N
BX 320	SEEDS	40	Herbertia lahue	From Nhu Nguyen:	OP, S	\N	\N	\N
BX 320	SEEDS	41	Impatiens gomphophylla	From Nhu Nguyen:	OP, S, winter dormant, tuberous. High chance of hybridization with other impatiens species.	\N	\N	\N
BX 320	SEEDS	42	Freesia laxa, blue	M Gastil-Buhl	\N	\N	\N	\N
BX 321	BULBS	1	Oxalis bowiei	Jim Waddick	\N	\N	\N	\N
BX 321	BULBS	2	Oxalis compressa 'Flore Plena'	Jim Waddick	\N	\N	\N	\N
BX 321	BULBS	3	Oxalis gracilis	Jim Waddick	\N	\N	\N	\N
BX 321	BULBS	4	Oxalis hirta 'Gothenberg'	Jim Waddick	\N	\N	\N	\N
BX 321	BULBS	5	Oxalis luteola	Jim Waddick	\N	\N	\N	\N
BX 321	BULBS	6	Oxalis melanosticta 'Ken Aslet'	Jim Waddick	\N	\N	\N	\N
BX 321	BULBS	7	Brodiaea terrestris	Nhu Nguyen	NNBH1205	\N	w	\N
BX 321	BULBS	8	Calochortus vestae	Nhu Nguyen	pink form ex Mary Sue Ittner, originally from Bob Werra. This is a very vigorous pupping form.	\N	w	\N
BX 321	BULBS	9	Sparaxis elegans	Nhu Nguyen	NNBH627. offsets, grown from Silverhill Seeds	\N	w	\N
BX 321	BULBS	10	Sparaxis grandiflora ssp. grandiflora	Nhu Nguyen	NNBH628. offsets, grown from Silverhill Seeds	\N	w	\N
BX 321	BULBS	11	Sparaxis tricolor	Nhu Nguyen	NNBH629. offsets, grown from Silverhill Seeds	\N	w	\N
BX 321	BULBS	12	Moraea lurida	Nhu Nguyen	NNBH198. originally from a BX	\N	w	\N
BX 321	BULBS	13	Oxalis commutata	Nhu Nguyen	MV5117	\N	w	\N
BX 321	BULBS	14	Oxalis melanosticta 'Ken Aslet'	Nhu Nguyen	NNBH776. these are early responders and have started sprouting.	\N	w	\N
BX 321	BULBS	15	Oxalis polyphylla var. heptaphylla	Nhu Nguyen	\N	\N	w	\N
BX 321	BULBS	16	Oxalis hirta	Nhu Nguyen	\N	\N	w	\N
BX 321	BULBS	17	Chasmanthe bicolor	Randy Linke	Seedling corms	\N	\N	\N
BX 321	BULBS	18	Rhodophiala bifida	Judy Glattstein	Small bulbs	\N	\N	\N
BX 321	BULBS	19	Lilium lanceifolium	Joyce Miller	Bulbils	\N	\N	\N
BX 321	BULBS	20	Oxalis fabaefolia	Lynn Makela	\N	\N	\N	\N
BX 321	BULBS	21	Oxalis namaquana	Lynn Makela	\N	\N	\N	\N
BX 321	BULBS	22	Oxalis perdicaria v. malecobubos	Lynn Makela	\N	\N	\N	\N
BX 321	BULBS	23	Oxalis purpurea 'Garnet'	Lynn Makela	\N	\N	\N	\N
BX 321	BULBS	24	Oxalis purpurea	Lynn Makela	salmon	\N	\N	\N
BX 321	BULBS	25	Oxalis virginea	Lynn Makela	\N	\N	\N	\N
BX 321	BULBS	26	Oxalis x 'Omel'	Lynn Makela	a rapid producer of bulbs, but oh so pretty	\N	\N	\N
BX 321	BULBS	27	Sinningia warminginii	Lynn Makela	few	\N	\N	\N
BX 321	BULBS	28	Amaryllis belladonna	Kathleen Sayce	ex Mike Mace seed from BX 262, dark pink	\N	\N	\N
BX 321	BULBS	29	Amaryllis belladonna	Kathleen Sayce	ex Mary Sue Ittner seed from BX 259, pink	\N	\N	\N
BX 321	BULBS	30	Colchicum autumnale	Kathleen Sayce	\N	\N	\N	\N
BX 322	SEEDS	1	Arum nigrum	Jim Waddick	Hardy in Kansas City, Black spathe originally from Denver Bot Gard.	\N	\N	\N
BX 322	SEEDS	2	Paramongaia weberbauri	Bill McLauglin	\N	\N	\N	\N
BX 322	SEEDS	3	Crocus longiflorus	Roland de Boer	?, N. Sicily, rich flowering	\N	\N	\N
BX 322	SEEDS	4	Gladiolus caucasicus	Roland de Boer	\N	\N	\N	\N
BX 322	SEEDS	5	Asarum caudatum album	Roland de Boer	\N	\N	\N	\N
BX 322	SEEDS	6	Tulipa turkestanica	Roland de Boer	\N	\N	\N	\N
BX 322	SEEDS	7	Colchicum autumnale	Jane McGary	NARGS exchange w/c in France	\N	\N	\N
BX 322	SEEDS	8	Colchicum bivonae	Jane McGary	Jane has provenance data for almost all these plants, including original collector's numbers and sites, so if this information is important for you, please contact her at janemcgary@earthlink.net and she will retrieve it for you.	\N	\N	\N
BX 322	SEEDS	9	Colchicum hungaricum	Jane McGary	Jane has provenance data for almost all these plants, including original collector's numbers and sites, so if this information is important for you, please contact her at janemcgary@earthlink.net and she will retrieve it for you.	\N	\N	\N
BX 322	SEEDS	10	Colchicum sfikasianum	Jane McGary	Jane has provenance data for almost all these plants, including original collector's numbers and sites, so if this information is important for you, please contact her at janemcgary@earthlink.net and she will retrieve it for you.	\N	\N	\N
BX 322	SEEDS	11	Cyclamen graecum	Jane McGary	mixture from the Peloponnese and the Aegean island of Gaiduronisi	\N	\N	\N
BX 322	BULBS	12	Fritillaria camtschatcensis	Jane McGary	bulblets, from Southeast Alaska	\N	\N	\N
BX 322	SEEDS	13	Fritillaria agrestis	Jane McGary	Archibald collection	\N	\N	\N
BX 322	SEEDS	14	Fritillaria biflora 'grayana'	Jane McGary	hort.	\N	\N	\N
BX 322	SEEDS	15	Fritillaria biflora	Jane McGary	various sources	\N	\N	\N
BX 325	SEEDS	1	Amaryllis belladonna	Penny Sommerville	pink, Fresh seed	\N	\N	\N
BX 325	SEEDS	2	Hippeastrum striatum	Stephen Putman	few Seeds	\N	\N	\N
BX 322	SEEDS	16	Fritillaria bithynica	Jane McGary	Jane has provenance data for almost all these plants, including original collector's numbers and sites, so if this information is important for you, please contact her at janemcgary@earthlink.net and she will retrieve it for you.	\N	\N	\N
BX 322	SEEDS	17	Fritillaria liliacea	Jane McGary	Robinett collection	\N	\N	\N
BX 322	SEEDS	18	Fritillaria purdyi x biflora	Jane McGary	McGary hybrid	\N	\N	\N
BX 322	SEEDS	19	Fritillaria raddeana	Jane McGary	Jane has provenance data for almost all these plants, including original collector's numbers and sites, so if this information is important for you, please contact her at janemcgary@earthlink.net and she will retrieve it for you.	\N	\N	\N
BX 322	SEEDS	20	Fritillaria rhodocanakis	Jane McGary	Jane has provenance data for almost all these plants, including original collector's numbers and sites, so if this information is important for you, please contact her at janemcgary@earthlink.net and she will retrieve it for you.	\N	\N	\N
BX 322	SEEDS	21	Fritillaria stenanthera	Jane McGary	Halda collection	\N	\N	\N
BX 322	SEEDS	22	Fritillaria viridea	Jane McGary	Robinett collection	\N	\N	\N
BX 322	SEEDS	23	Gymnospermium albertii	Jane McGary	J. Halda collection	\N	\N	\N
BX 322	SEEDS	24	Hyacinthella heldreichii	Jane McGary	Archibald collection	\N	\N	\N
BX 322	SEEDS	25	Hyacinthoides algeriense	Jane McGary	Salmon collection	\N	\N	\N
BX 322	SEEDS	26	Nectaroscordum tripedale	Jane McGary	Jane has provenance data for almost all these plants, including original collector's numbers and sites, so if this information is important for you, please contact her at janemcgary@earthlink.net and she will retrieve it for you.	\N	\N	\N
BX 322	SEEDS	27	Romulea nivalis	Jane McGary	Jane has provenance data for almost all these plants, including original collector's numbers and sites, so if this information is important for you, please contact her at janemcgary@earthlink.net and she will retrieve it for you.	\N	\N	\N
BX 322	SEEDS	28	Romulea requienii	Jane McGary	Salmon collection	\N	\N	\N
BX 322	SEEDS	29	Triteleia hyacinthina	Jane McGary	Jane has provenance data for almost all these plants, including original collector's numbers and sites, so if this information is important for you, please contact her at janemcgary@earthlink.net and she will retrieve it for you.	\N	\N	\N
BX 322	SEEDS	30	Triteleia ixioides subsp. scabra	Jane McGary	McGary collection, hills W of Salinas CA	\N	\N	\N
BX 322	SEEDS	31	Triteleia laxa 'giant form'	Jane McGary	McGary collection from Mariposa County CA	\N	\N	\N
BX 323	SEEDS	1	Allium abramsii	Jane McGary	Ratko collection	\N	\N	\N
BX 323	SEEDS	2	Allium campanulatum	Jane McGary	Ratko collection	\N	\N	\N
BX 323	SEEDS	3	Allium diabloense	Jane McGary	Ratko collection	\N	\N	\N
BX 323	SEEDS	4	Allium douglasii	Jane McGary	Ratko collection	\N	\N	\N
BX 323	SEEDS	5	Allium hyalinum	Jane McGary	pink form, Ratko collection	\N	\N	\N
BX 323	SEEDS	6	Allium oreophilum ex 'Samur'	Jane McGary	Ruksans selection	\N	\N	\N
BX 323	SEEDS	7	Allium peninsulare	Jane McGary	Ratko collection	\N	\N	\N
BX 323	SEEDS	8	Allium praecox	Jane McGary	Ratko collection	\N	\N	\N
BX 323	SEEDS	9	Allium scorzoneriifolium subsp. xericense	Jane McGary	Salmon collection	\N	\N	\N
BX 323	SEEDS	10	Allium serra	Jane McGary	Ratko collection	\N	\N	\N
BX 323	SEEDS	11	Anemone palmata	Jane McGary	M. Salmon collection	\N	\N	\N
BX 323	SEEDS	12	Calochortus amabilis	Jane McGary	Robinett collection	\N	\N	\N
BX 323	SEEDS	13	Calochortus catalinae	Jane McGary	\N	\N	\N	\N
BX 323	SEEDS	14	Calochortus clavatus subsp. gracilis	Jane McGary	Ratko collection	\N	\N	\N
BX 323	SEEDS	15	Calochortus dunnii	Jane McGary	Ratko collection	\N	\N	\N
BX 323	SEEDS	16	Calochortus elegans	Jane McGary	McGary collection, Siskiyou Mts	\N	\N	\N
BX 323	SEEDS	17	Calochortus longebarbatus	Jane McGary	Leach Botanical Garden collection	\N	\N	\N
BX 323	SEEDS	18	Calochortus monophyllus	Jane McGary	\N	\N	\N	\N
BX 323	SEEDS	19	Calochortus striatus	Jane McGary	Ratko collection	\N	\N	\N
BX 323	SEEDS	20	Calochortus superbus	Jane McGary	Archibald collection (probably a from a hybrid swarm with C. luteus)	\N	\N	\N
BX 323	SEEDS	21	Calochortus venustus	Jane McGary	red forms from various collections	\N	\N	\N
BX 323	SEEDS	22	Calochortus venustus	Jane McGary	white forms, from various seed sources	\N	\N	\N
BX 323	SEEDS	23	Camassia quamash subsp. breviflora	Jane McGary	Phyllis Gustafson collection	\N	\N	\N
BX 323	SEEDS	24	Camassia quamash subsp. maxima 'Puget Blue'	Jane McGary	\N	\N	\N	\N
BX 323	SEEDS	25	Alophia drummondii	Rodney Barton	\N	\N	\N	\N
BX 323	SEEDS	26	Habranthus tubispathus var. texensis	Rodney Barton	\N	\N	\N	\N
BX 323	SEEDS	27	Herbertia lahue ssp caerulea	Rodney Barton	\N	\N	\N	\N
BX 323	SEEDS	28	Lilium humboldtii	Mary Sue Ittner	\N	\N	\N	\N
BX 323	SEEDS	29	Lilium pardalinum 'Giganteum'	Mary Sue Ittner	\N	\N	\N	\N
BX 323	SEEDS	30	Haemanthus humilis	Mary Sue Ittner	\N	\N	\N	\N
BX 323	SEEDS	31	Veltheimia bracteata	Mary Sue Ittner	\N	\N	\N	\N
BX 323	SEEDS	32	Pelargonium barkleyi	Mary Sue Ittner	\N	\N	\N	\N
BX 323	SEEDS	33	Triteleia peduncularis	Mary Sue Ittner	\N	\N	\N	\N
BX 323	SEEDS	34	Pelargonium appendiculatum	Terry Laskiewicz	\N	\N	\N	\N
BX 324	BULBS	1	Babiana framesii	Mary Sue Ittner	various sizes, some small cormlets	\N	\N	\N
BX 324	BULBS	2	Ferraria crispa ssp. nortieri	Mary Sue Ittner	\N	\N	\N	\N
BX 324	BULBS	3	Ferraria variabilis	Mary Sue Ittner	(from seed labeled F. divaricarta, never bloomed, I suspect is F. variabilis)	\N	\N	\N
BX 324	BULBS	4	Freesia caryophyllacea	Mary Sue Ittner	mostly cormlets	\N	\N	\N
BX 324	BULBS	5	Oxalis flava	Mary Sue Ittner	(lupinifolia)	\N	\N	\N
BX 324	BULBS	6	Oxalis obtusa	Mary Sue Ittner	(copper color)	\N	\N	\N
BX 324	BULBS	7	Ferraria crispa	Mary Sue Ittner	this one smells like vanilla, has been spreading planted in the ground	\N	\N	\N
BX 324	BULBS	8	Herbertia lahue	Mary Sue Ittner	\N	\N	\N	\N
BX 324	BULBS	9	Muscari pallens	Mary Sue Ittner	\N	\N	\N	\N
BX 324	BULBS	10	Oxalis polyphylla var heptaphylla	Mary Sue Ittner	MV 4381B, 4km into Skoemanskloof from Oudtshoorn. Long, succulent, thread-like leaves.	\N	\N	\N
BX 324	BULBS	11	Chasmanthe bicolor	Randy Linke	Cormlets	\N	\N	\N
BX 324	BULBS	12	Arum palaestinum	Arnold Trachtenberg	Tubers	\N	\N	\N
BX 324	BULBS	13	Arum korolkowii	Arnold Trachtenberg	Tubers	\N	\N	\N
BX 324	BULBS	14	Watsonia hybrids	Pam Slate	Mixed corms of Watsonia mixed hybrids (Snow Queen, Flamboyant and Double Vision) and Ixia (Giant)	\N	\N	\N
BX 324	BULBS	15	Babiana sp	Kathleen Sayce	? Small corms	\N	\N	\N
BX 325	SEEDS	3	Hippeastrum neopardinum	Stephen Putman	Seeds (only three shares)	\N	\N	\N
BX 325	SEEDS	4	Cyclamen hederifolium	Kathleen Sayce	mixed leaf forms	\N	\N	\N
BX 325	SEEDS	5	Urginea (Scilla) maritima	Richard Wagner	Very fresh seed. Needs to be fresh for germination	\N	\N	\N
BX 325	SEEDS	6	Pancratium maritimum	Richard Wagner	\N	\N	\N	\N
BX 325	SEEDS	7	Sisyrinchium californicum	Shirley Meneice	\N	\N	\N	\N
BX 325	SEEDS	8	Sisyrinchium bellum	Shirley Meneice	\N	\N	\N	\N
BX 325	SEEDS	9	Sisyrinchium angustifolium	Shirley Meneice	\N	\N	\N	\N
BX 325	SEEDS	10	Schizostylis coccinea	Shirley Meneice	\N	\N	\N	\N
BX 325	SEEDS	11	Tigridia pavonia	Shirley Meneice	\N	\N	\N	\N
BX 325	SEEDS	12	Ornithogalum saundersiae	Jerry Lehmann	\N	\N	\N	\N
BX 325	SEEDS	13	Liatris pychostachya	Jerry Lehmann	ex Becker County, MN, open pollinated	\N	\N	\N
BX 325	SEEDS	14	Iris versicolor	Jerry Lehmann	ex Becker County, MN	\N	\N	\N
BX 325	SEEDS	15	Uvularia sessilifolia	Jerry Lehmann	ex Becker County, MN	\N	\N	\N
BX 325	SEEDS	16	Heracleum lanatum	Jerry Lehmann	I have never had success with these from seed. They tend to grow in sandy ditches, but where water is funneled to the ditch sides, not really in water.	\N	\N	\N
BX 325	SEEDS	17	Allium sanbornii	Nhu Nguyen	W, OP, pink form	\N	W	\N
BX 325	SEEDS	18	Allium jepsonii	Nhu Nguyen	W, OP	\N	W	\N
BX 325	SEEDS	19	Brodiaea elegans	Nhu Nguyen	W, OP	\N	W	\N
BX 325	SEEDS	20	Iris douglasiana	Nhu Nguyen	W wild collected, Marin Co., California - this comes from a variable population so you may get a mix of colors and forms	\N	W	\N
BX 325	SEEDS	21	Triteleia laxa	Nhu Nguyen	W, OP deep purple, coastal Marin Co., California form	\N	W	\N
BX 325	SEEDS	22	Chlorogalum sp.	Nhu Nguyen	W wild collected, Placer Co., form, Sierra Nevada, about 4500ft (1370m)	\N	W	\N
BX 325	SEEDS	23	Chlorogalum pomeridianum	Nhu Nguyen	W wild collected, Santa Cruz, California, near sea level	\N	W	\N
BX 325	SEEDS	24	Alstroemeria ligtu ssp. simsii	Nhu Nguyen	W, CP	\N	W	\N
BX 325	SEEDS	25	Allium sp.	Nhu Nguyen	W, CP. Chiapas, Mexico	http://flickr.com/photos/xerantheum/#	W	\N
BX 325	SEEDS	26	Allium carinatum var. pulchellum	Nhu Nguyen	W, CP	\N	W	\N
BX 325	SEEDS	27	Albuca shawii	Nhu Nguyen	SU, OP	\N	S	\N
BX 325	SEEDS	28	Cyclamen africanum	Nhu Nguyen	W, CP	\N	W	\N
BX 325	SEEDS	29	Galtonia viridiflora	Nhu Nguyen	SU, CP	\N	S	\N
BX 325	SEEDS	30	Gladiolus flanaganii	Nhu Nguyen	SU, CP	\N	S	\N
BX 325	SEEDS	31	Veltheimia bracteata	Nhu Nguyen	W/SU, OP	\N	W	\N
BX 325	SEEDS	32	Tulbaghia galpinii	Nhu Nguyen	S, OP	\N	S	\N
BX 325	SEEDS	33	Ixia viridiflora	Nhu Nguyen	W, OP	\N	W	\N
BX 325	SEEDS	34	Calydorea amabilis	Nhu Nguyen	S, CP	\N	S	\N
BX 325	SEEDS	36	Camassia quamash	Gene Mirro	182: Willamette Valley, OR form. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	\N	\N	\N
BX 325	SEEDS	38	Colchicum	Gene Mirro	garden forms mixed. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	\N	\N	\N
BX 325	SEEDS	40	Erythronium revolutum	Gene Mirro	25: All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	\N	\N	\N
BX 325	SEEDS	43	Lilium kelloggi	Gene Mirro	545: pink; blooms early summer; 2 - 4 feet tall; water lightly after bloom time. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	\N	\N	\N
BX 325	SEEDS	48	Lilium wigginsi	Gene Mirro	1268: blooms early summer; 3 - 4 feet tall; needs summer water. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	\N	\N	\N
BX 342	BULBS	3	Crinum asiaticum var pedunculatum	Jay Yourch	Small bulbs	\N	\N	\N
BX 325	SEEDS	44	Lilium kelloggi white	Gene Mirro	320: blooms early summer; rare white form; 2 - 3 feet tall; water lightly after bloom time. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/motie42/kelloggiwhite_zps6668f279.jpg	\N	\N
BX 325	SEEDS	45	Lilium medeoloides	Gene Mirro	682: blooms midsummer; downfacing orange flowers; 2 - 3 feet tall; needs summer water. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/motie42/medeoloides_zpsf4f30b16.jpg	\N	\N
BX 325	SEEDS	46	Lilium parryi	Gene Mirro	1070: blooms early summer; 3 feet tall; outfacing yellow flowers; needs summer water. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/motie42/parryismall.jpg	\N	\N
BX 325	SEEDS	47	Lilium lijiangense	Gene Mirro	1174: blooms early summer; 3 - 4 feet tall; needs summer water. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/motie42/lijiangense_zps0056afef.jpg	\N	\N
BX 325	SEEDS	50	Trillium rivale	Gene Mirro	706: unmarked white form. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	\N	\N	\N
BX 330	SEEDS	1	Calochortus amabilis	From Bob Werra:	Bob says, It's not too late to plant winter rainfall species.	\N	\N	\N
BX 330	SEEDS	2	Dichelostemma ida-maia	From Bob Werra:	\N	\N	\N	\N
BX 330	SEEDS	3	Fritillaria affinis	From Bob Werra:	ex Ukiah, CA	\N	\N	\N
BX 330	SEEDS	4	Fritillaria liliaceae	From Bob Werra:	\N	\N	\N	\N
BX 330	SEEDS	5	Gladiolus huttonii	From Bob Werra:	\N	\N	\N	\N
BX 330	SEEDS	6	Gladiolus priori	From Bob Werra:	\N	\N	\N	\N
BX 330	SEEDS	7	Moraea ciliata	From Bob Werra:	(CORMLETS)	\N	\N	\N
BX 330	SEEDS	8	Moraea ciliate	From Bob Werra:	\N	\N	\N	\N
BX 330	SEEDS	9	Moraea elegans	From Bob Werra:	\N	\N	\N	\N
BX 330	SEEDS	10	Moraea graminicola	From Bob Werra:	ex Eastern Cape, RSA	\N	\N	\N
BX 330	SEEDS	11	Moraea pendula	From Bob Werra:	\N	\N	\N	\N
BX 330	SEEDS	12	Moraea polyanthus	From Bob Werra:	\N	\N	\N	\N
BX 330	SEEDS	13	Moraea polystachya	From Bob Werra:	\N	\N	\N	\N
BX 330	SEEDS	14	Moraea vegeta	From Bob Werra:	\N	\N	\N	\N
BX 330	SEEDS	15	Moraea vespertina	From Bob Werra:	\N	\N	\N	\N
BX 330	SEEDS	16	Moraea villosa	From Bob Werra:	\N	\N	\N	\N
BX 330	SEEDS	17	Rhodophiala	From Bob Werra:	pink	\N	\N	\N
BX 330	SEEDS	18	Rhodophiala	From Bob Werra:	dark maroon	\N	\N	\N
BX 330	SEEDS	19	Sandersonia aurantiaca	From Bob Werra:	\N	\N	\N	\N
BX 330	SEEDS	20	Crotolaria capensis	From Roland de Boer:	\N	\N	\N	\N
BX 330	SEEDS	21	Cyclamen hederifolium	From Roland de Boer:	mixed pink forms	\N	\N	\N
BX 330	SEEDS	22	Galtonia viridiflora	From Roland de Boer:	tall form	\N	\N	\N
BX 330	SEEDS	23	Kochia scoparia	From Roland de Boer:	\N	\N	\N	\N
BX 330	SEEDS	24	Leucocoryne purpurea	From Roland de Boer:	\N	\N	\N	\N
BX 330	SEEDS	25	Malcomia maritima	From Roland de Boer:	\N	\N	\N	\N
BX 330	SEEDS	26	Massonia echinata	From Roland de Boer:	\N	\N	\N	\N
BX 330	SEEDS	27	Massonia pustulata	From Roland de Boer:	\N	\N	\N	\N
BX 330	SEEDS	28	Paradisia lusitanicum	From Roland de Boer:	\N	\N	\N	\N
BX 330	SEEDS	29	Eucomis comosa	From Dee Foster:	green/white	\N	\N	\N
BX 330	SEEDS	30	Eucomis comosa	From Dee Foster:	mixed colors, mostly pink	\N	\N	\N
BX 330	SEEDS	31	Eucomis cv	From Dee Foster:	dwarf purple flower, green foliage	\N	\N	\N
BX 330	SEEDS	32	Gloriosa superba	From Dee Foster:	(rotschildiana)	\N	\N	\N
BX 330	SEEDS	33	Veltheimia bracteata	From Dee Foster:	pink	\N	\N	\N
BX 330	SEEDS	34	Mirabilis jalapa	From Dee Foster:	Four O'clocks, magenta	\N	\N	\N
BX 330	SEEDS	35	Amaryllis belladonna	From Mary Sue Ittner:	OP	\N	winter growing	\N
BX 330	SEEDS	36	Cyrtanthus elatus x montanus	From Mary Sue Ittner:	(all OP)	\N	evergreen	\N
BX 330	BULBS	37	Cyrtanthus elatus x montanus	From Mary Sue Ittner:	Bulblets	\N	evergreen	\N
BX 330	SEEDS	38	Eucomis bicolor	From Mary Sue Ittner:	(all OP)	\N	summer growing	\N
BX 330	SEEDS	39	Nerine bowdenii	From Mary Sue Ittner:	confused about when it should grow (all OP)	\N	\N	\N
BX 330	SEEDS	40	Nerine sarninesis hybrid	From Mary Sue Ittner:	(had red flowers) (all OP)	\N	w	\N
BX 330	SEEDS	41	Nerine sarniensis hybrid	From Mary Sue Ittner:	(seed from rescue bulb) (all OP)	\N	w	\N
BX 330	SEEDS	42	Polianthes geminiflora	From Mary Sue Ittner:	(all OP)	\N	s	\N
BX 331	SEEDS	1	Dracunculus vulgaris	From Richard Hart:	\N	\N	\N	\N
BX 331	SEEDS	2	Haemanthus albiflos	From Richard Hart:	\N	\N	\N	\N
BX 331	SEEDS	3	Tigridia pavonia, yellow	From Richard Hart:	\N	\N	\N	\N
BX 331	SEEDS	4	Dietes grandiflora	From Guy L'Eplattenier:	\N	\N	\N	\N
BX 331	SEEDS	5	Lapiedra martinezii	From Guy L'Eplattenier:	(for those who did not get any the last time)	\N	\N	\N
BX 331	SEEDS	6	Pancratium canariense	From Guy L'Eplattenier:	\N	\N	\N	\N
BX 331	SEEDS	7	Dichelostemma volubile	From Gene Mirro:	\N	http://i232.photobucket.com/albums/ee69/#	\N	\N
BX 331	SEEDS	8	Lilium auratum rubrovittatum	From Gene Mirro:	\N	\N	\N	\N
BX 331	SEEDS	9	Lilium henryi citrinum`	From Gene Mirro:	\N	\N	\N	\N
BX 331	BULBS	10	Lilium sulphureum	From Gene Mirro:	1139: blooms late summer; 5 - 8 ft. tall, large fragrant flowers with white/green inside, white/purple outside; strong straight stems; needs summer water; purple stem bulbils.	http://s232.photobucket.com/albums/ee69/# 39_zps217d838f.jpg	\N	\N
BX 331	BULBS	11	Lilium sulphureum	From Gene Mirro:	1469: blooms late summer; 5 - 8 ft. tall, large fragrant flowers with white/yellow inside, white/purple outside; strong straight stems; lives 15 years or more; needs summer water. Bulbils	\N	\N	\N
BX 332	BULBS	1	Watsonia sp. aff. fulgens. Cormlets	From Kipp McMichael:	red	\N	\N	\N
BX 332	SEEDS	2	Massonia pustulata	From Kipp McMichael:	purple and mottled purple	\N	\N	\N
BX 332	SEEDS	3	Albuca nelsonii	From Stephen Gregg:	ex Silverhill. Grows 2 metres high	\N	\N	\N
BX 332	SEEDS	4	Erythronium elegans	From Kathleen Sayce:	wild collected Mt Hebo, Tillamook County, Oregon	\N	\N	\N
BX 332	SEEDS	5	Asphodelus acaulis	From Angelo Porcelli:	\N	\N	\N	\N
BX 332	SEEDS	6	Iris coccina	From Angelo Porcelli:	\N	\N	\N	\N
BX 332	SEEDS	7	Iris planifolia	From Angelo Porcelli:	\N	\N	\N	\N
BX 332	SEEDS	8	Paeonia mascula ssp mascula	From Angelo Porcelli:	\N	\N	\N	\N
BX 332	SEEDS	9	Pancratium canariense	From Angelo Porcelli:	\N	\N	\N	\N
BX 332	SEEDS	10	Pancratium parviflorum	From Angelo Porcelli:	\N	\N	\N	\N
BX 332	SEEDS	11	Ceropegia ballyana	From Sophie Dixon:	\N	\N	\N	\N
BX 332	SEEDS	12	Dietes grandiflora	From Guy L'Eplattenier:	\N	\N	\N	\N
BX 332	SEEDS	13	Lapiedra martinezii	From Guy L'Eplattenier:	\N	\N	\N	\N
BX 332	SEEDS	14	Pancratium canariense	From Guy L'Eplattenier:	\N	\N	\N	\N
BX 332	SEEDS	15	Narcissus serotinus	From Donald Leevers:	\N	\N	\N	\N
BX 333	SEEDS	1	Sprekelia cv, 'Orient Red'	From Stephen Gregg:	repeat bloomer, prominent white stripe	\N	\N	\N
BX 333	SEEDS	2	Fritillaria meleagris	From David Pilling:	\N	\N	\N	\N
BX 333	SEEDS	3.1	Lilium formosanum	From David Pilling:	\N	\N	\N	\N
BX 333	SEEDS	3.2	Lilium regale	From David Pilling:	\N	\N	\N	\N
BX 333	SEEDS	4	Zantedeschia aethiopica	From David Pilling:	\N	\N	\N	\N
BX 333	SEEDS	5	Manfreda undulata 'Chocolate Chips'	From Dennis Kramb:	\N	\N	\N	\N
BX 333	SEEDS	6	Sinningia speciosa	From Dennis Kramb:	\N	\N	\N	\N
BX 333	SEEDS	7	Zephyranthes hidalgo x Z. grandiflora	From Ina Crossley:	could not be verified	\N	\N	\N
BX 333	SEEDS	8	Zephyranthes 'Pink Beauty'	From Ina Crossley:	\N	\N	\N	\N
BX 333	SEEDS	9	Zephyranthes drummondii	From Ina Crossley:	\N	\N	\N	\N
BX 333	SEEDS	10	Zephyranthes dichromantha	From Ina Crossley:	\N	\N	\N	\N
BX 333	SEEDS	11	Zephyranthes flavissima	From Ina Crossley:	\N	\N	\N	\N
BX 333	SEEDS	12	Zephyranthes lindleyana	From Ina Crossley:	\N	\N	\N	\N
BX 333	SEEDS	13	Zephyranthes hidalgo 'John Fellers'	From Ina Crossley:	could not be verified	\N	\N	\N
BX 333	SEEDS	14	Zephyranthes jonesii	From Ina Crossley:	\N	\N	\N	\N
BX 333	SEEDS	15	Zephyranthes fosteri	From Ina Crossley:	\N	\N	\N	\N
BX 333	SEEDS	16	Zephyranthes primulina	From Ina Crossley:	\N	\N	\N	\N
BX 333	SEEDS	17	Zephyranthes reginae	From Ina Crossley:	\N	\N	\N	\N
BX 333	SEEDS	18	Zephyranthes tenexico	From Ina Crossley:	apricot. could not be verified	\N	\N	\N
BX 333	SEEDS	19	Zephyranthes verecunda rosea	From Ina Crossley:	could not be verified	\N	\N	\N
BX 333	BULBS	20	Achimenes erecta 'Tiny Red'	From Dennis Kramb:	RHIZOMES/TUBERS	\N	\N	\N
BX 333	BULBS	21	Achimenes 'Desiree'	From Dennis Kramb:	RHIZOMES/TUBERS	\N	\N	\N
BX 333	BULBS	22	Gloxinella lindeniana	From Dennis Kramb:	RHIZOMES/TUBERS	\N	\N	\N
BX 333	BULBS	23	Niphaea oblonga	From Dennis Kramb:	RHIZOMES/TUBERS	\N	\N	\N
BX 333	BULBS	24	Sinningia eumorpha 'Saltao'	From Dennis Kramb:	RHIZOMES/TUBERS	\N	\N	\N
BX 333	BULBS	25	Sinningia speciosa	From Dennis Kramb:	RHIZOMES/TUBERS	\N	\N	\N
BX 334	SEEDS	1	Gloriosa modesta	From Mary Sue Ittner:	(Littonia modesta)	\N	summer growing	\N
BX 334	SEEDS	2	Tigridia vanhouttei	From Mary Sue Ittner:	\N	\N	summer growing	\N
BX 334	BULBS	3	Oxalis triangularis	From Mary Sue Ittner:	evergreen if you keep watering it	\N	\N	\N
BX 334	BULBS	4	Oxalis sp. Mexico	From Mary Sue Ittner:	\N	\N	summer growing	\N
BX 334	SEEDS	5	Habranthus martinezii x H. robustus	From Stephen Gregg	\N	\N	\N	\N
BX 334	SEEDS	6	Moraea polystachya	From Jim Waddick and SIGNA:	\N	\N	\N	\N
BX 334	SEEDS	7	Iris tectorum	From Jim Waddick and SIGNA:	Album'	\N	\N	\N
BX 334	SEEDS	8	Iris tectorum, mixed	From Jim Waddick and SIGNA:	\N	\N	\N	\N
BX 334	SEEDS	9	Geissorhiza	From Jim Waddick and SIGNA:	falcata (???)	\N	\N	\N
BX 334	SEEDS	10	Herbertia lahue	From Jim Waddick and SIGNA:	\N	\N	\N	\N
BX 334	SEEDS	11	Crocosmia	From Jim Waddick and SIGNA:	ex 'Lucifer'	\N	\N	\N
BX 334	SEEDS	12	Calydorea amabilis	From Jim Waddick and SIGNA:	\N	\N	\N	\N
BX 334	SEEDS	13	Cypella coelestis	From Jim Waddick and SIGNA:	(syn Phalocallis coelestis)	\N	\N	\N
BX 334	SEEDS	14	Dietes iridioides	From Jim Waddick and SIGNA:	\N	\N	\N	\N
BX 334	SEEDS	15	Romulea monticola	From Jim Waddick and SIGNA:	\N	\N	\N	\N
BX 334	SEEDS	16	Herbertia pulchella	From Jim Waddick and SIGNA:	\N	\N	\N	\N
BX 334	SEEDS	17	Dietes bicolor	From Jim Waddick and SIGNA:	\N	\N	\N	\N
BX 334	SEEDS	18	Freesia laxa, blue	From Jim Waddick and SIGNA:	\N	\N	\N	\N
BX 334	SEEDS	19	Watsonia	From Jim Waddick and SIGNA:	ex 'Frosty Morn'	\N	\N	\N
BX 334	SEEDS	20	Crocosmia paniculata	From Jim Waddick and SIGNA:	\N	\N	\N	\N
BX 334	SEEDS	21	Gelasine elongata	From Jim Waddick and SIGNA:	\N	\N	\N	\N
BX 335	SEEDS	1	Phaedranassa tunguraguae	From Bjorn Wretman:	\N	\N	\N	\N
BX 335	SEEDS	2	Hippeastrum nelsonii	From Stephen Putman:	\N	\N	\N	\N
BX 335	SEEDS	3	Zephyranthes fosteri	From Ina Crossley:	\N	\N	\N	\N
BX 335	SEEDS	4	Zephyranthes dichromantha	From Ina Crossley:	\N	\N	\N	\N
BX 335	SEEDS	5	Zephyranthes 'Hidalgo'	From Ina Crossley:	\N	\N	\N	\N
BX 335	SEEDS	6	Zephyranthes reginae	From Ina Crossley:	\N	\N	\N	\N
BX 335	SEEDS	7	Zephyranthes 'Tenexico'	From Ina Crossley:	apricot	\N	\N	\N
BX 335	SEEDS	8	Tigridia pavonia	From Ina Crossley:	pure white	\N	\N	\N
BX 335	SEEDS	9	Zephyranthes citrina	From Ina Crossley:	\N	\N	\N	\N
BX 335	SEEDS	10	Zephyranthes primulina	From Ina Crossley:	\N	\N	\N	\N
BX 335	SEEDS	11	Zephyranthes 'Ajax'	From Ina Crossley:	\N	\N	\N	\N
BX 335	SEEDS	12	Habranthus tubispathus	From Ina Crossley:	Texensis'	\N	\N	\N
BX 335	SEEDS	13	Habranthus brachyandrus	From Ina Crossley:	\N	\N	\N	\N
BX 335	SEEDS	14	Habranthus tubispathusvar. roseus	From Ina Crossley:	\N	\N	\N	\N
BX 335	SEEDS	15	Zephyranthes 'Sunset Strain'	From Ina Crossley:	\N	\N	\N	\N
BX 335	SEEDS	16	Tigridia pavonia	From Nhu Nguyen:	- S, OP	\N	s	\N
BX 335	SEEDS	17	Herbertia tigridioides	From Nhu Nguyen:	- S, OP	\N	s	\N
BX 335	SEEDS	18	Calydorea amabilis	From Nhu Nguyen:	- S, OP	\N	s	\N
BX 335	SEEDS	19	Cypella herbertii	From Nhu Nguyen:	- S, OP	\N	s	\N
BX 335	SEEDS	20	Ornithogalum regale	From Nhu Nguyen:	- W, control pollinated	\N	w	\N
BX 335	BULBS	21	Oxalis lasiandra	From Nhu Nguyen:	\N	\N	s	\N
BX 335	BULBS	22	Oxalis tetraphylla 'Reverse Iron Cross'	From Nhu Nguyen:	\N	\N	s	\N
BX 335	BULBS	23	Oxalis sp.	From Nhu Nguyen:	Durango, Mexico	\N	s	\N
BX 336	BULBS	1	Achimenes grandiflora	From Lynn Makela:	Robert Dressler'	\N	\N	\N
BX 336	BULBS	2	Achimenes 'Purple King'	From Lynn Makela:	\N	\N	\N	\N
BX 336	BULBS	3	Crinum 'Menehune' dwarf	From Lynn Makela:	purple leaves, pink flowers	\N	\N	\N
BX 336	BULBS	4	Eucodonia andrieuxii	From Lynn Makela:	hybrids (few)	\N	\N	\N
BX 336	BULBS	5	xGlokohleria 'Pink Heaven'	From Lynn Makela:	\N	\N	\N	\N
BX 336	BULBS	6	Sinningia bullata	From Lynn Makela:	bright red flowers (few)	\N	\N	\N
BX 336	BULBS	7	Zephyranthesr	From Lynn Makela:	ex Jacala, Mexico, wine-red flowers	\N	\N	\N
BX 336	BULBS	8	Zephyranthes traubii	From Lynn Makela:	Carlos form	\N	\N	\N
BX 336	SEEDS	10	Burchardia congesta	From Don Leevers:	(syn B. umbellata)	\N	\N	\N
BX 336	SEEDS	11	Caesia parviflora	From Don Leevers:	\N	\N	\N	\N
BX 336	SEEDS	12	Xyris lanata	From Don Leevers:	\N	\N	\N	\N
BX 336	SEEDS	13	Xyris operculata	From Don Leevers:	\N	\N	\N	\N
BX 336	BULBS	14	Hippeastrum cybister	From Dell Sherk:	Bulblets	\N	\N	\N
BX 336	BULBS	15	Strumaria truncata	From Dell Sherk:	Bulblets	\N	\N	\N
BX 336	BULBS	16	Strumaria discifera	From Dell Sherk:	Bulblets. (very few)	\N	\N	\N
BX 336	BULBS	17	Nerine pudica	From Dell Sherk:	Bulblets	\N	\N	\N
BX 337	SEEDS	1	Hippeastrum striatum	From Stephen Putman:	\N	\N	\N	\N
BX 337	SEEDS	2	Narcissus cantabricus	From Arnold Trachtenberg:	clusii. Per TPL and IPNI, there is no listing for this. Per TPL, N. clusii is a synonym of N. cantabricus var. cantabricus.  Per IPNI, N. cantabricus and N. clusii are two separate species.	\N	\N	\N
BX 337	SEEDS	3	Narcissus romieuxii	From Arnold Trachtenberg:	\N	\N	\N	\N
BX 337	SEEDS	4	Narcissus romieuxii	From Arnold Trachtenberg:	var mesatlanticus. Per TPL and IPNI, there is no listing for this. Also no listing under N. mesatlanticus.  PBS lists it as a synonym for N. romieuxii ssp. romieuxii var. romieuxii (also not a valid name per TPL & IPNI), but does not indicate where it is validly described.The Alpine Garden Society states, in part, 'or the dubiously distinct variety mesatlanticus..'	(http://alpinegardensociety.net/plants/#ii/12/)	\N	\N
BX 337	SEEDS	5	Narcissus cantabricus	From Arnold Trachtenberg:	\N	\N	\N	\N
BX 337	SEEDS	6	Narcissus romieuxii 'Julia Jane'	From Arnold Trachtenberg:	\N	\N	\N	\N
BX 337	SEEDS	7	Narcissus romieuxii 'Jessamy'	From Arnold Trachtenberg:	\N	\N	\N	\N
BX 337	SEEDS	8	Massonia pustulata	From Arnold Trachtenberg:	\N	\N	\N	\N
BX 337	SEEDS	9	Massonia pustulata	From Arnold Trachtenberg:	purple leaves	\N	\N	\N
BX 337	BULBS	10	Freesia elimensis	From Arnold Trachtenberg:	(syn? F. caryophyllacea)	\N	\N	\N
BX 337	BULBS	11	Freesia fucata	From Arnold Trachtenberg:	\N	\N	\N	\N
BX 337	BULBS	12	Lachenalia liliflora	From Arnold Trachtenberg:	\N	\N	\N	\N
BX 337	BULBS	13	Leucocoryne purpurea	From Arnold Trachtenberg:	\N	\N	\N	\N
BX 337	BULBS	14	Freesia sp.	From Arnold Trachtenberg:	?	\N	\N	\N
BX 337	BULBS	15	Arum	From Arnold Trachtenberg:	unidentified	\N	\N	\N
BX 337	BULBS	16	Ferraria uncinata	From Arnold Trachtenberg:	\N	\N	\N	\N
BX 337	BULBS	17	Babiana rubrocyanea	From Arnold Trachtenberg:	\N	\N	\N	\N
BX 337	SEEDS	18	Massonia pustulata	From Antigoni Rentzeperis:	\N	\N	\N	\N
BX 338	SEEDS	1	Schizobasis intricata	From Monica Swartz:	ex Huntington Botanic Gardens (ISI 2004-36),	\N	\N	\N
BX 338	SEEDS	2	Ornithogalum glandulosum	From Monica Swartz:	ex Jim Duggan Flower Nursery, the earliest winter flower I grow,	\N	\N	\N
BX 338	BULBS	3	Alocasia hypnosa	From Monica Swartz:	Small tubers of Alocasia hypnosa, a recently described (2005) species from China. Big light green leaves that give a tropical look to a shady area. Winter dormant. I store the big tubers in a bucket of dry sand in a cold garage every winter, but small tubers have over-wintered fine in ground in my 8b garden. I suspect the big tubers would do the same if buried in well-drained soil. They are waking now, so plant right away.	\N	\N	\N
BX 338	SEEDS	4	Freesia viridis	From Antigoni Rentzeperis:	\N	\N	\N	\N
BX 338	SEEDS	5	Lachenalia viridiflora	From Antigoni Rentzeperis:	\N	\N	\N	\N
BX 338	SEEDS	6	Pelargonium appendiculatum	From Ruth Jones:	Per TPL, Geraniospermum appendiculatum is the accepted name; P. appendiculatum is the synonym. Per IPNI, each name is a separate species.	\N	\N	\N
BX 338	SEEDS	7	Clivia miniata	From Mary Sue Ittner:	from two plants, both very light yellow flowers Bulbs: all winter growing, may not all be blooming size	\N	\N	\N
BX 338	BULBS	8	Oxalis assinia	From Mary Sue Ittner:	(syn. O. fabaefolia)	\N	\N	\N
BX 338	BULBS	9	Oxalis bowiei	From Mary Sue Ittner:	Oxalis bowiei This made the favorite pink category of a couple of us.  This is a fall blooming, tall, big gorgeous plant.	\N	\N	\N
BX 338	BULBS	10	Oxalis engleriana	From Mary Sue Ittner:	South African, fall blooming, linear leaves	\N	\N	\N
BX 338	BULBS	11	Oxalis flava	From Mary Sue Ittner:	yellow, winter growing, fall blooming	\N	w	\N
BX 338	BULBS	12	Oxalis flava	From Mary Sue Ittner:	received as O. namaquana, but is this species, yellow flowers	\N	\N	\N
BX 338	BULBS	13	Oxalis flava	From Mary Sue Ittner:	(lupinifolia) -- lupine like leaves and pink flowers, fall blooming	\N	\N	\N
BX 338	BULBS	14	Oxalis flava	From Mary Sue Ittner:	(pink) -- leaves low to ground, attractive, one year some of the flowers were also yellow (along with the pink), but usually it has pink flowers, no guarantee about the color but the leaves are nice and it doesn't offset a lot	\N	\N	\N
BX 338	BULBS	15	Oxalis hirta	From Mary Sue Ittner:	(mauve) received from Ron Vanderhoff, definitely a different color from the pink ones I grow, really pretty, fall blooming	\N	\N	\N
BX 338	BULBS	16	Oxalis hirta	From Mary Sue Ittner:	(pink) From South Africa, blooms late fall, early winter, bright pink flowers. Increases rapidly. does better for me in deep pot, fall blooming	\N	\N	\N
BX 338	BULBS	17	Oxalis hirta	From Mary Sue Ittner:	Gothenburg'- a hirta on steroids, gets to be a very large plant and does best with a deep pot	\N	\N	\N
BX 338	BULBS	18	Oxalis imbricata	From Mary Sue Ittner:	-recycled from the BX. This one has pink flowers even though Cape Plants says the flowers are white. The one shown on the web that everyone grows has hairy leaves, pink flowers. Fall into winter blooming	\N	\N	\N
BX 338	BULBS	19	Oxalis luteola	From Mary Sue Ittner:	MV 5567 60km s of Clanwilliam. 1.25 inch lt yellow flrs, darker ctr. This one has been very reliable for me in Northern California	\N	\N	\N
BX 338	BULBS	20	Oxalis melanosticta	From Mary Sue Ittner:	Ken Aslet' -- has a reputation for not blooming and originally I grew it for its hairy soft leaves that make you want to touch it, but grown in a deep pot it has been blooming the last several years in the fall	\N	\N	\N
BX 338	BULBS	21	Oxalis obtusa	From Mary Sue Ittner:	MV 5051 Vanrhynshoek. 2 inch lt copper-orange, darker veining, yellow ctr.	\N	\N	\N
BX 338	BULBS	22	Oxalis palmifrons	From Mary Sue Ittner:	-grown for the leaves, mine have never flowered, but the leaves I like	\N	\N	\N
BX 338	BULBS	23	Oxalis polyphylla	From Mary Sue Ittner:	var heptaphylla MV 4381B - 4km into Skoemanskloof from Oudtshoorn. Long, succulent, thread-like leaves	\N	\N	\N
BX 338	BULBS	24	Oxalis polyphylla	From Mary Sue Ittner:	var heptaphylla MV6396 Vanrhynsdorp. Succulent thread-like leaves. Winter growing, blooms fall	\N	\N	\N
BX 338	BULBS	25	Oxalis pulchella	From Mary Sue Ittner:	var tomentosa - ex BX 221 and Ron Vanderhoff - Low, pubescent, mat forming foliage and large very pale salmon colored flowers. Fall blooming. This one hasn't bloomed for me yet, but I keep hoping as the bulbs are getting bigger and bigger	\N	\N	\N
BX 338	BULBS	26	Oxalis purpurea (white)	From Mary Sue Ittner:	(white) winter growing, long blooming, but beware of planting in the ground in a Mediterranean climate unless you don't care if it takes over as it expands dramatically, a lot.	\N	w	\N
BX 342	SEEDS	4	Crinum bulbispermum 'Jumbo'	Jay Yourch	\N	\N	\N	\N
BX 338	BULBS	27	Oxalis purpurea 'Lavender & White'	From Mary Sue Ittner:	Lavender & White'	\N	\N	\N
BX 338	BULBS	28	Oxalis purpurea 'Skar'	From Mary Sue Ittner:	originally from Bill Baird, long blooming, pink flowers	\N	\N	\N
BX 338	BULBS	29	Oxalis versicolor	From Mary Sue Ittner:	--lovely white with candy stripe on back, winter blooming	\N	\N	\N
BX 338	BULBS	30	Tulipa humilis	From Mary Sue Ittner:	Red Cup' - received as this from Brent & Becky's, but I can't find validation about the name. There is a Tulipa hageri 'Red Cup'. I'd love to know what the name should be. I've added photos to the wiki	\N	\N	\N
BX 338	BULBS	31	Tulipa turkestanica	From Mary Sue Ittner:	\N	\N	\N	\N
BX 338	BULBS	32	Oxalis zeekoevleyensis	From Mary Sue Ittner:	blooms early fall, lavender flowers	\N	\N	\N
BX 338	BULBS	33	Ferraria sp.	From Arnold Trachtenberg:	? Small corms	\N	\N	\N
BX 339	SEEDS	1	Freesia laxa ssp. cruenta)	M Gastil-Buhl	Primarily winter grower but also grows and blooms some year round. Not as easy to grow as the red ones. Easier to grow than the white ones.	\N	w	\N
BX 339	SEEDS	2	Chasmanthe sp.	M Gastil-Buhl	Winter grower / Summer deciduous Very weedy in Southern California. (Too easy to grow.)	\N	w	\N
BX 339	BULBS	3	Oxalis obtusa	From Mary Sue Ittner:	MV5005a 10km n of Matjiesfontein. Red-orange	\N	\N	\N
BX 339	BULBS	4	Tulipa clusiana	From Mary Sue Ittner:	small bulbs, not blooming size	\N	\N	\N
BX 339	BULBS	5	Oxalis depressa	From Mary Sue Ittner:	MV 4871	\N	\N	\N
BX 339	SEEDS	6	Tritonia dubia	From Monica Swartz:	\N	\N	\N	\N
BX 339	SEEDS	7	Romulea gigantea	From Monica Swartz:	\N	\N	\N	\N
BX 339	SEEDS	8	Albuca suaveolens	From Monica Swartz:	\N	\N	\N	\N
BX 339	SEEDS	9	Freesia refracta	From Monica Swartz:	\N	\N	\N	\N
BX 339	BULBS	10	Cyrtanthus elatus x montanus	From Monica Swartz:	Bulblets	\N	\N	\N
BX 339	BULBS	11	Cyrtanthus sanguineus	From Monica Swartz:	Bulblets	\N	\N	\N
BX 339	BULBS	12	Lachenalia orchioidesr var. glaucina	From Arnold Trachtenberg	Bulblets	\N	\N	\N
BX 339	BULBS	13	Lachenalia glauca	From Arnold Trachtenberg	Bulblets	\N	\N	\N
BX 339	BULBS	14	Lachenalia namaquensis	From Arnold Trachtenberg	Bulblets	\N	\N	\N
BX 339	BULBS	15	Lachenalia aloides var. quadricolor	From Arnold Trachtenberg	Bulblets	\N	\N	\N
BX 339	BULBS	16	Lachenalia viridiflora	From Arnold Trachtenberg	Bulblets	\N	\N	\N
BX 339	BULBS	17	Lachenalia comptonii	From Arnold Trachtenberg	Bulblets	\N	\N	\N
BX 339	BULBS	18	Cyrtanthus labiatus	From Arnold Trachtenberg	Bulblets	\N	\N	\N
BX 339	BULBS	19	Stenomesson pearcei	From Arnold Trachtenberg	Bulblets	\N	\N	\N
BX 339	SEEDS	20	Lachenalia reflexa	From Arnold Trachtenberg	\N	\N	\N	\N
BX 339	SEEDS	21	Tristagma uniflorum 'Charlotte Bishop'	From Kathleen Sayce:	formerly Ipheion, has large pink flowers. Plants should not completely dry out during summer dormancy. (few)	\N	\N	\N
BX 341	SEEDS	1	Albuca spiralis	Nhu Nguyen	[W, OP] this plant selfs and there were no other Albuca blooming at the same time.	\N	w	\N
BX 341	SEEDS	2	Albuca sp. Willowmore (pod) x Augrabies Hills (pollen)	Nhu Nguyen	[W, CP] - tentatively identified as forms of Albuca polyphylla	\N	w	\N
BX 341	SEEDS	3	Albuca sp. Willowmore (pollen) x Augrabies Hills (pod)	Nhu Nguyen	[W, CP] - tentatively identified as forms of Albuca polyphylla	\N	w	\N
BX 341	SEEDS	4	Babiana 'longituba'	Nhu Nguyen	[W, OP]	\N	w	\N
BX 341	SEEDS	5	Gladiolus splendens	Nhu Nguyen	[W, OP]	\N	w	\N
BX 341	SEEDS	6	Gladiolus quadrangularis	Nhu Nguyen	[W, OP]	\N	w	\N
BX 341	SEEDS	7	Gladiolus alatus	Nhu Nguyen	[W, OP]	\N	w	\N
BX 341	SEEDS	8	Geissorhiza radians	Nhu Nguyen	[W, OP]	\N	w	\N
BX 341	SEEDS	9	Geissorhiza corrugata	Nhu Nguyen	[W, OP]	\N	w	\N
BX 341	SEEDS	10	Geissorhiza aspera	Nhu Nguyen	[W, OP]	\N	w	\N
BX 341	SEEDS	11	Sparaxis elegans	Nhu Nguyen	[W, OP]	\N	w	\N
BX 341	SEEDS	12	Sparaxis tricolor	Nhu Nguyen	[W, OP]	\N	w	\N
BX 341	SEEDS	13	Hesperantha bachmannii	Nhu Nguyen	[W, OP] no other Hesperantha were blooming at the same time	\N	w	\N
BX 341	SEEDS	14	Massonia pustulata	Nhu Nguyen	NNBH905 [W, OP] originally from Paul Cumbleton, BX181, described as having very few pustules	\N	w	\N
BX 341	SEEDS	15	Massonia aff. pustulata	Nhu Nguyen	NNBH786 [W, OP] originally from Roy Herold, BX174	\N	w	\N
BX 341	SEEDS	16	Lachenalia ensifolia	Nhu Nguyen	(syn Polyxena pygmaea) [W, OP]	\N	w	\N
BX 341	SEEDS	17	Rauhia multiflora	Nhu Nguyen	[S, CP]	\N	s	\N
BX 341	SEEDS	18	Calochortus umbellatus	Nhu Nguyen	[W, OP]	\N	w	\N
BX 341	SEEDS	19	Triteleia lugens	Nhu Nguyen	[W, CP]	\N	w	\N
BX 341	SEEDS	20	Delphinium nudicaule	Nhu Nguyen	[W, CP] these seeds should be pure	\N	w	\N
BX 341	SEEDS	21	Lewisia brachycalyx	Nhu Nguyen	[W, CP]	\N	w	\N
BX 341	SEEDS	22	Fritillaria affinis	Nhu Nguyen	robust x normal form [W, CP] - we had a discussion about the robust form before that it may be a triploid. However, it crossed just fine with a regular form, from a different location, so I don't think it's a triploid. The seedlings should be an interesting mix of sizes and colors.	\N	w	\N
BX 341	BULBS	23	Hippeastrum petiolatum	Nhu Nguyen	NNBH1306	\N	\N	\N
BX 341	BULBS	24	Hippeastrum petiolatum	Nhu Nguyen	NNBH1304	\N	\N	\N
BX 341	BULBS	25	Hippeastrum striatum	Nhu Nguyen	\N	\N	\N	\N
BX 341	BULBS	26	Sparaxis elegans	Nhu Nguyen	\N	\N	\N	\N
BX 341	BULBS	27	Sparaxis tricolor	Nhu Nguyen	\N	\N	\N	\N
BX 341	SEEDS	28	Pancratium maritimum	Stephen Gregg	\N	\N	\N	\N
BX 341	SEEDS	29	Veltheimia bracteata	Ray Talley	pink form, though about 10% turn out to be yellow. ex Cal State Fullerton	\N	\N	\N
BX 341	SEEDS	30	Hippeastrum 'Orange Sovereign'	Karl Church	OP	\N	\N	\N
BX 341	SEEDS	31	Hippeastrum 'Minerva'	Karl Church	OP	\N	\N	\N
BX 341	SEEDS	32	Crinum bulbispermum, 'Jumbo'	Jim Waddick	\N	\N	\N	\N
BX 341	SEEDS	33	Crinum macowanii	Jim Waddick	\N	\N	\N	\N
BX 341	SEEDS	34	Crinum bulbispermum	Jim Shields	\N	\N	\N	\N
BX 341	SEEDS	35	Hymenocallis guerreroensis	Jim Shields	(VERY FEW)	\N	\N	\N
BX 341	SEEDS	36	Hymenocallis franklinensis	Jim Shields	(VERY FEW)	\N	\N	\N
BX 341	SEEDS	37	Haemanthus montanus	Jim Shields	(FEW)	\N	\N	\N
BX 341	SEEDS	38	Sprekelia howardii	Jim Shields	\N	\N	\N	\N
BX 341	SEEDS	39	Habranthus tubispathus cf texanus	Jim Shields	\N	\N	\N	\N
BX 341	SEEDS	40	Crinum bulbispermum	Jim Shields	\N	\N	\N	\N
BX 342	BULBS	1	Crinum 'Summer Nocturne'.	Jay Yourch	Small bulbs	\N	\N	\N
BX 342	BULBS	2	Crinum 'Birthday Party'	Jay Yourch	Small bulbs	\N	\N	\N
BX 342	BULBS	5	Oxalis bowiei	Rimmer de Vries	ex BX 251	\N	\N	\N
BX 342	BULBS	6	Amaryllis belladonna	Kathleen Sayce	(three different cultivars) small bulbs	\N	\N	\N
BX 342	BULBS	7	Sparaxis parviflora	Monica Swartz	Cormlets	\N	\N	\N
BX 342	BULBS	8	Ornithogalum glandulosum	Monica Swartz	\N	\N	\N	\N
BX 342	BULBS	9	Oxalis convexula	Monica Swartz	\N	\N	\N	\N
BX 342	BULBS	10	Nerine sarniensis	Monica Swartz	Small bulbs	\N	\N	\N
BX 342	BULBS	11	Cyanella hyacinthoides	Monica Swartz	Small corms	\N	\N	\N
BX 342	BULBS	12	Ledebouria socialis	Nhu Nguyen	green form, 'Laxifolia'	\N	\N	\N
BX 342	BULBS	13	Ledebouria socialis	Nhu Nguyen	purple form	\N	\N	\N
BX 342	BULBS	14	Tulbaghia simmleri	Nhu Nguyen	light pink form	\N	\N	\N
BX 342	BULBS	15	Narcissus 'Taffeta'	Nhu Nguyen	Small bulbs	\N	\N	\N
BX 342	BULBS	16	Zephyranthes pulchella	Jim Shields	\N	\N	\N	\N
BX 342	BULBS	17	Chasmanthe floribunda	Penny Sommerville	Large corms	\N	\N	\N
BX 342	BULBS	18	Narcissus romieuxi 'Julia Jane'	Terry Laskiewicz	Small bulbs	\N	\N	\N
BX 343	SEEDS	1	Cyrtanthus brachyscyphus	Penny Sommerville	\N	\N	\N	\N
BX 343	SEEDS	2	Albuca concordiana	Sophie Dixon	(from three different parents plants)	\N	\N	\N
BX 343	SEEDS	3	Albuca shawii	Jerry Lehmann	\N	\N	\N	\N
BX 343	SEEDS	4	Scilla cilicica	Rimmer de Vries	\N	\N	\N	\N
BX 343	SEEDS	5	Cyclamen hederifolium	Rimmer de Vries	\N	\N	\N	\N
BX 343	SEEDS	6	Hippeastrum stylosum	Stephen Putman	\N	\N	\N	\N
BX 343	SEEDS	7	Albuca sp	Leo Martin	? yellow and green	\N	\N	\N
BX 343	SEEDS	8	Albuca clanwilliamae-gloria	Leo Martin	\N	\N	\N	\N
BX 343	SEEDS	9	Lachenalia unicolor	Monica Swartz	\N	\N	\N	\N
BX 343	SEEDS	10	Lachenalia namaquensis	Monica Swartz	\N	\N	\N	\N
BX 343	SEEDS	11	Polyxena pygmaea	Monica Swartz	\N	\N	\N	\N
BX 343	SEEDS	12	Lachenalia viridiflora	Monica Swartz	\N	\N	\N	\N
BX 343	SEEDS	13	Lachenalia splendida	Monica Swartz	\N	\N	\N	\N
BX 343	SEEDS	14	Lachenalia bachmanii	Monica Swartz	\N	\N	\N	\N
BX 343	SEEDS	15	Lachenalia contaminata	Monica Swartz	\N	\N	\N	\N
BX 343	SEEDS	16	Lachenalia orthopetala	Monica Swartz	\N	\N	\N	\N
BX 343	SEEDS	17	Manfreda sileri	Monica Swartz	\N	\N	\N	\N
BX 343	SEEDS	18	Ferraria crispa, dark	Monica Swartz	\N	\N	\N	\N
BX 343	SEEDS	19	Zephyranthes minuta	Monica Swartz	(syn Z. verecunda)	\N	\N	\N
BX 343	SEEDS	20	Habranthus magnoi	Monica Swartz	\N	\N	\N	\N
BX 343	SEEDS	21	Erythronium revolutum	Kathleen Sayce	from seeds collected on Saddle Mountain, NW Oregon	\N	\N	\N
BX 343	BULBS	22	Lilium pardalinum ssp. pitkinense	Larry Neel	Blooming/near blooming size bulbs.  These are a wetland species and are almost never without roots	\N	\N	\N
BX 344	BULBS	1	Oxalis glabra	Nhu Nguyen	\N	\N	\N	\N
BX 344	BULBS	2	Oxalis cathara	Nhu Nguyen	\N	\N	\N	\N
BX 344	BULBS	3	Oxalis obtusa;MV 5005a	Nhu Nguyen	\N	\N	\N	\N
BX 344	BULBS	4	Oxalis fabifolia	Monica Swartz	\N	\N	\N	\N
BX 344	BULBS	5	Oxalis massonorum	Monica Swartz	(not unequivocally verified.)	\N	\N	\N
BX 344	BULBS	6	Oxalis imbricata	Monica Swartz	\N	\N	\N	\N
BX 344	BULBS	7	Oxalis polyphylla    var. heptaphylla	Monica Swartz	(not unequivocally verified.)	\N	\N	\N
BX 344	BULBS	8	Oxalis flava  pectinaria	Monica Swartz	(not unequivocally verified.)	\N	\N	\N
BX 344	BULBS	9	Oxalis namaquana	Monica Swartz	\N	\N	\N	\N
BX 344	BULBS	10	Oxalis callosa	Mike Mace	\N	\N	\N	\N
BX 344	BULBS	11	Oxalis kaasvogdensis	Mike Mace	(not unequivocally verified.)	\N	\N	\N
BX 344	BULBS	12	Oxalis luteola MV 5567	Mike Mace	\N	\N	\N	\N
BX 344	BULBS	13	Oxalis obtusa	Mike Mace	pink (ex Siskiyou Rare Plants)	\N	\N	\N
BX 344	BULBS	14	Oxalis polyphylla var. heptaphylla	Mike Mace	MV 6396 (not unequivocally verified.)	\N	\N	\N
BX 344	BULBS	15	Oxalis sp., MV 4621A	Mike Mace	\N	\N	\N	\N
BX 344	BULBS	16	Oxalis sp., MV 4674	Mike Mace	\N	\N	\N	\N
BX 344	BULBS	17	Oxalis sp., MV 4719D	Mike Mace	\N	\N	\N	\N
BX 344	BULBS	18	Oxalis sp., MV 4871	Mike Mace	\N	\N	\N	\N
BX 344	BULBS	19	Oxalis sp., MV 4960B	Mike Mace	\N	\N	\N	\N
BX 344	BULBS	20	Oxalis sp., MV 5117	Mike Mace	\N	\N	\N	\N
BX 344	BULBS	21	Oxalis sp., MV 5180	Mike Mace	\N	\N	\N	\N
BX 344	BULBS	22	Oxalis sp., MV 5532	Mike Mace	\N	\N	\N	\N
BX 344	BULBS	23	Oxalis sp., MV 5630A	Mike Mace	\N	\N	\N	\N
BX 344	BULBS	24	Oxalis sp., MV 5752	Mike Mace	\N	\N	\N	\N
BX 344	BULBS	25	Oxalis sp	Mike Mace	probably O. hirta, pink	\N	\N	\N
BX 344	BULBS	26	Oxalis stenorhyncha	Mike Mace	\N	\N	\N	\N
BX 345	SEEDS	1	Haemanthus humilis subsp. humilis	Jim Shields	\N	\N	\N	\N
BX 345	BULBS	2	Hippeastrum aglaiae	Jim Shields	cream form, (Doran clone A x Doran clone C) (few). Small bulbs	\N	\N	\N
BX 345	SEEDS	3	Zephyranthes longifolia	Jim Shields	(syn Habranthus longifolius)	\N	\N	\N
BX 345	SEEDS	4	Nerine krigei	Jim Shields	mixed pink and red	\N	\N	\N
BX 345	SEEDS	5	Hymenocallis glauca	Jim Shields	(few)	\N	\N	\N
BX 345	SEEDS	6	Hymenocallis howardii	Jim Shields	(few)	\N	\N	\N
BX 345	BULBS	10	Moraea polystachya	Monica Swartz	\N	\N	\N	\N
BX 345	BULBS	11	Hyacinthoides lingulata	Mary Sue Ittner	summer dormant, fall blooming, starting to form new roots	\N	\N	\N
BX 345	BULBS	12	Nothoscordum sp.	Mary Sue Ittner	(from Harry Hay seed labeled Nothoscordum ostenii, but with white flowers).	http://www.pacificbulbsociety.org/pbswiki/index.php/Nothoscordum#sp	\N	\N
BX 345	BULBS	15	Allium amplectens	Nhu Nguyen	\N	\N	\N	\N
BX 345	BULBS	16	Allium campanulatum	Nhu Nguyen	- Southern Sierra Nevada form	\N	\N	\N
BX 345	BULBS	17	Allium unifolium	Nhu Nguyen	- nice and typically robust, good in the ground	\N	\N	\N
BX 345	BULBS	18	Babiana nana	Nhu Nguyen	- grown from Silverhill seeds	\N	\N	\N
BX 345	BULBS	19	Brodiaea elegans	Nhu Nguyen	\N	\N	\N	\N
BX 345	BULBS	20	Brodiaea minor	Nhu Nguyen	\N	\N	\N	\N
BX 345	BULBS	21	Brodiaea pallida	Nhu Nguyen	\N	\N	\N	\N
BX 345	BULBS	22	Calochortus luteus	Nhu Nguyen	\N	\N	\N	\N
BX 345	BULBS	23	Calochortus uniflorus	Nhu Nguyen	\N	\N	\N	\N
BX 345	BULBS	24	Calochortus vestae	Nhu Nguyen	\N	\N	\N	\N
BX 345	BULBS	25	Dichelostemma multiflorum	Nhu Nguyen	\N	\N	\N	\N
BX 345	BULBS	26	Ferraria crispa	Nhu Nguyen	\N	\N	\N	\N
BX 345	BULBS	27	Gladiolus liliaceus	Nhu Nguyen	\N	\N	\N	\N
BX 345	BULBS	28	Gladiolus trichonemifolius	Nhu Nguyen	\N	\N	\N	\N
BX 345	BULBS	29	Gladiolus tristis	Nhu Nguyen	\N	\N	\N	\N
BX 345	BULBS	30	Lachenalia purpureo-caerulea	Nhu Nguyen	\N	\N	\N	\N
BX 345	BULBS	31	Lachenalia unifolia	Nhu Nguyen	\N	\N	\N	\N
BX 345	BULBS	32	Moraea tripetala	Nhu Nguyen	\N	\N	\N	\N
BX 345	BULBS	33	Romulea tortuosa	Nhu Nguyen	- non curly leaf form	\N	\N	\N
BX 345	BULBS	34	Scilla ramburei	Nhu Nguyen	\N	\N	\N	\N
BX 345	BULBS	35	Erythronium 'Pagoda'	Larry Neel	\N	\N	\N	\N
BX 345	BULBS	36	Lachenalia arbuthnotiae	Mike Mace	\N	\N	\N	\N
BX 345	BULBS	37	Lachenalia mutabilis	Mike Mace	\N	\N	\N	\N
BX 345	BULBS	38	Lachenalia rosea	Mike Mace	\N	\N	\N	\N
BX 345	BULBS	39	Lachenalia species	Mike Mace	(probably L. arbuthnotiae)	\N	\N	\N
BX 345	BULBS	40	Lachenalia viridiflora	Mike Mace	(unspotted leaves)	\N	\N	\N
BX 346	SEEDS	1	Brunsvigia josephiniae	Kipp McMichael	\N	\N	\N	\N
BX 346	SEEDS	2	Boophone sp.	Kipp McMichael	?, seeds from Australia	\N	\N	\N
BX 346	BULBS	3	Gladiolus italicus	M Gastil-Buhl	Corms of mixed sizes	\N	\N	\N
BX 346	BULBS	4	Moraea bellendenii	M Gastil-Buhl	ID not confirmed. Corms	\N	\N	\N
BX 346	BULBS	5	Lachenalia sargeantii	Colin Davis	Offset bulblets	\N	\N	\N
BX 346	BULBS	6	Haemanthus coccineus x H. albiflos	Jim Shields	Good sized (few)	\N	\N	\N
BX 346	BULBS	7	Haemanthus coccineus	Jim Shields	ex Bokkeveld Escarpment (few) Good sized	\N	\N	\N
BX 346	BULBS	8	Haemanthus barkerae	Jim Shields	Various sized (few)	\N	\N	\N
BX 346	BULBS	9	Lachenalia mutabilis	Arnold Trachtenberg	Bulblets of	\N	\N	\N
BX 346	BULBS	10	Lachenalia juncifolia	Arnold Trachtenberg	Bulblets of	\N	\N	\N
BX 346	BULBS	11	Ferraria divaricata	Arnold Trachtenberg	Small corms	\N	\N	\N
BX 346	BULBS	12	Ferraria densipunctulata	Mary Sue Ittner	Corms of	\N	\N	\N
BX 346	BULBS	13	Ambrosina bassii	Roy Herold	Small offsets	\N	\N	\N
BX 346	BULBS	14	Drimia sp	Roy Herold	(formerly Rhadamanthus)--ex Tom Glavich, BX214-19. This is indeed quite different from D. platyphylla, although the leaves are similar. The bulbs are two to three times the size of platyphylla, it emerges a month sooner (in full leaf now), and it has the curious habit of forming little bulbils at the soil surface at the top of the bulb neck. It has yet to bloom for me. Only a few.	\N	\N	\N
BX 346	BULBS	15	Drimia sp. Calitzdorp	Roy Herold	ex Gariep Nursery. Similar to platyphylla, but the jury is out on a positive ID. Only a few.	\N	\N	\N
BX 346	BULBS	16	Cyrtanthus brachyscyphus	Roy Herold	\N	\N	\N	\N
BX 346	BULBS	17	Cyrtanthus hybrid #1	Roy Herold	ex Logee's. Big, soft orange trumpets. Evergreen.	\N	e	\N
BX 346	BULBS	18	Cyrtanthus hybrid #2	Roy Herold	ex Logee's. Smaller medium orange trumpets fading to pink. Evergreen.	\N	e	\N
BX 346	SEEDS	19	Fritillaria bucharica	Larry Neel	\N	\N	\N	\N
BX 346	SEEDS	20	Fritillaria stenanthera	Larry Neel	\N	\N	\N	\N
BX 346	SEEDS	21	Fritillaria yuminensis	Larry Neel	pink	\N	\N	\N
BX 346	SEEDS	22	Trillium albidum	Larry Neel	plain-leafed, high elevation form	\N	\N	\N
BX 346	SEEDS	23	Trillium angustipetalum	Larry Neel	\N	\N	\N	\N
BX 346	SEEDS	24	Trillium angustipetalum	Larry Neel	large form	\N	\N	\N
BX 346	SEEDS	25	Trillium chloropetalum	Larry Neel	rose	\N	\N	\N
BX 346	SEEDS	26	Trillium chloropetalum	Larry Neel	rose and white	\N	\N	\N
BX 346	SEEDS	27	Trillium chloropetalum	Larry Neel	plum and white	\N	\N	\N
BX 346	SEEDS	28	Trillium kurabayashii	Larry Neel	\N	\N	\N	\N
BX 346	SEEDS	29	Trillium kurabayashii	Larry Neel	late, high-elevation form	\N	\N	\N
BX 346	SEEDS	30	Trillium kurabaysahii	Larry Neel	yellow	\N	\N	\N
BX 346	SEEDS	31	Trillium ovatum	Larry Neel	\N	\N	\N	\N
BX 346	SEEDS	32	Sinningia cardinalis	Dennis Kramb	red	\N	\N	\N
BX 346	SEEDS	33	Calochortus palmeri	Chris Elwell	var munzii	\N	\N	\N
BX 346	SEEDS	34	Calochortus luteus	Chris Elwell	(OP)	\N	\N	\N
BX 346	SEEDS	35	Calochortus venustus var. sanguineus	Chris Elwell	(syn C. venustus)	\N	\N	\N
BX 346	SEEDS	36	Calochortus venustus	Chris Elwell	burgundy	\N	\N	\N
BX 346	SEEDS	37	Aristea ecklonii	Jonathan Lubar	\N	\N	\N	\N
BX 346	SEEDS	38	Calydorea amabilis	Jonathan Lubar	\N	\N	\N	\N
BX 346	SEEDS	39	Lilium formosanum	Jonathan Lubar	var formosanum (syn L.f. var pricei), ex wild-collected seed from Taiwan, 3 - 3.5 ft tall	\N	\N	\N
BX 347	SEEDS	1	Lachenalia liliiflora	Monica Swartz	\N	\N	\N	\N
BX 347	SEEDS	2	Romulea tetragona	Mike Mace	\N	\N	\N	\N
BX 347	SEEDS	3	Moraea vespertina	Mike Mace	\N	\N	\N	\N
BX 347	SEEDS	4	Cyclamen pseudibericum	Mary Sue Ittner	\N	\N	\N	\N
BX 347	SEEDS	5	Pelargonium incrassatum	Mary Sue Ittner	\N	\N	\N	\N
BX 347	SEEDS	6	Phaedranassa cinerea	Mary Sue Ittner	\N	\N	\N	\N
BX 347	SEEDS	7	Nothoscordum sp.	Mary Sue Ittner	from Harry Hay as N. ostenii	\N	\N	\N
BX 347	SEEDS	8	Geissorhiza imbricata	Mary Sue Ittner	\N	\N	\N	\N
BX 347	SEEDS	9	Freesia leichtlinii ssp. alba	Mary Sue Ittner	\N	\N	\N	\N
BX 347	SEEDS	10	Veltheimia bracteata	Mary Sue Ittner	\N	\N	\N	\N
BX 347	SEEDS	11	Cyclamen repandum	Mary Sue Ittner	\N	\N	\N	\N
BX 347	SEEDS	12	Allium hyalinum	Mary Sue Ittner	\N	\N	\N	\N
BX 347	SEEDS	13	Leucocoryne vittata	Mary Sue Ittner	hybrid	\N	\N	\N
BX 347	SEEDS	14	Gladiolus italicus	Gastil	\N	\N	\N	\N
BX 347	SEEDS	15	Aristea capitata	Gastil	\N	\N	\N	\N
BX 347	SEEDS	16	Albuca spiralis	Chris Elwell (I think)	\N	\N	\N	\N
BX 347	SEEDS	17	Lachenalia hirta	Chris Elwell (I think)	\N	\N	\N	\N
BX 347	SEEDS	18	Pamianthe peruviana	Dave Boucher	\N	\N	\N	\N
BX 347	SEEDS	19	Lilium longiflorum	Dave Boucher	ex Okinawa	\N	\N	\N
BX 347	SEEDS	20	Scilla haemorrhoidalis	Dave Boucher	\N	\N	\N	\N
BX 347	SEEDS	21	Herbertia lahue	Dave Boucher	\N	\N	\N	\N
BX 347	SEEDS	22	Albuca shawii	Jerry Lehmann	\N	\N	\N	\N
BX 347	SEEDS	23	Ornithogalum viridiflorum	Jerry Lehmann	\N	\N	\N	\N
BX 347	SEEDS	24	Ornithogalum fimbrimarginatum	Karl Church	HRG 118287, ISI 2013-27, S. Hammer and C. Barnhill. Tall inflorescense with white, narcissus-like flowers, open pollinated	\N	\N	\N
BX 349	SEED 	26	Tulbaghia simmleri	Nhu Nguyen	(fragrans), purple form	\N	\N	\N
BX 347	SEEDS	25	Lilium columbianum	Kathleen Sayce	Columbia lily ex hort. Parent seeds from Saddle Mtn, NW Oregon, orange flowers May-June, open pollinated	\N	\N	\N
BX 347	SEEDS	26	Leucojum aestivum	Kathleen Sayce	\N	\N	\N	\N
BX 347	SEEDS	27	Fritillaria affinis	Kathleen Sayce	\N	\N	\N	\N
BX 347	SEEDS	28	Tulipa turkestanica	Kathleen Sayce	\N	\N	\N	\N
BX 347	SEEDS	29	Tulipa greigii	Kathleen Sayce	\N	\N	\N	\N
BX 347	SEEDS	30	Tulipa clusiana	Kathleen Sayce	\N	\N	\N	\N
BX 347	SEEDS	31	Freesia laxa; mostly red	Marvin Ellenbecker	\N	\N	\N	\N
BX 347	SEEDS	32	Louisiana iris;light blue	Marvin Ellenbecker	\N	\N	\N	\N
BX 347	SEEDS	33	Sisyrinchium bellum;\\blue-eyed grass\\	Marvin Ellenbecker	\N	\N	\N	\N
BX 347	SEEDS	34	Paeonia obovata	Roy Herold	white	\N	\N	\N
BX 347	SEEDS	35	Medeola virginiana	Roy Herold	wc  Carlisle, MA	\N	\N	\N
BX 347	SEEDS	36	Arisaema triphyllum	Roy Herold	population 1, wc Carlisle, MA	\N	\N	\N
BX 347	SEEDS	37	Arisaema triphyllum	Roy Herold	population 2, wc Carlisle, MA	\N	\N	\N
BX 347	SEEDS	38	Arisaema triphyllum ssp. stewardsonii	Roy Herold	wc Carlisle, MA	\N	\N	\N
BX 347	SEEDS	39	Arisaema flavum	Roy Herold	\N	\N	\N	\N
BX 347	SEEDS	40	Sinopodophyllum hexandrum	Roy Herold	\N	\N	\N	\N
BX 347	SEEDS	41	Smilacina racemosa  'Aaron's Variegated'	Roy Herold	(Maianthemum?)	\N	\N	\N
BX 348	BULBS	1	Typhonium venosum	Jerry Lehmann	(Sauromatum) Small tubers already sprouting - plant immediately. Zone 5 winter hardy in sheltered location (although after 10+ yrs, it's never flowered: some springs it emerges late.)	\N	\N	\N
BX 348	BULBS	2	Oxalis conorrhiza	Ernie De Marie	(syn. O. andicola), ex Chile Flora	\N	\N	\N
BX 348	BULBS	3	Oxalis caprina	Ernie De Marie	\N	\N	\N	\N
BX 348	BULBS	4	Oxalis compressa	Ernie De Marie	ex BX 218	\N	\N	\N
BX 348	BULBS	5	Oxalis bifurca	Ernie De Marie	\N	\N	\N	\N
BX 348	BULBS	6	Oxalis dichotoma	Ernie De Marie	\N	\N	\N	\N
BX 348	BULBS	7	Oxalis fabifolia	Ernie De Marie	ex BX 218	\N	\N	\N
BX 348	BULBS	8	Oxalis hirta	Ernie De Marie	\N	\N	\N	\N
BX 348	BULBS	9	Oxalis luteola	Ernie De Marie	MV 5090	\N	\N	\N
BX 348	BULBS	10	Oxalis obtusa	Ernie De Marie	no label	\N	\N	\N
BX 348	BULBS	11	Oxalis obtusa	Ernie De Marie	two forms?	\N	\N	\N
BX 348	BULBS	12	Oxalis obtusa	Ernie De Marie	no data	\N	\N	\N
BX 348	BULBS	13	Oxalis 'polyphylla var. heptaphylla'	Ernie De Marie	\N	\N	\N	\N
BX 348	BULBS	14	Oxalis simplex	Ernie De Marie	\N	\N	\N	\N
BX 348	BULBS	15	Oxalis	Ernie De Marie	no label, probably O. stenorhynca	\N	\N	\N
BX 348	BULBS	16	Oxalis sp.	Ernie De Marie	MV 7088	\N	\N	\N
BX 348	BULBS	17	Calochortus vestae	Mary Sue Ittner	bulblets	\N	w	\N
BX 348	BULBS	18	Oxalis compressa	Mary Sue Ittner	double	\N	w	\N
BX 348	BULBS	19	Oxalis obtusa	Mary Sue Ittner	coral	\N	w	\N
BX 348	BULBS	20	Lachenalia longituba	Mary Sue Ittner	(Polyxena longituba)	\N	w	\N
BX 348	BULBS	21	Spiloxene capensis	Mary Sue Ittner	\N	\N	w	\N
BX 348	BULBS	22	Narcissus bulbocodium subsp. praecox	Arnold Trachtenberg	(paucinervis?)	\N	\N	\N
BX 348	BULBS	23	Narcissus 'albidus folius'	Arnold Trachtenberg	\N	\N	\N	\N
BX 348	BULBS	24	Narcissus bulbocodium	Arnold Trachtenberg	ex Morocco	\N	\N	\N
BX 348	BULBS	25	Narcissus bulbocodium var. genuinus	Arnold Trachtenberg	\N	\N	\N	\N
BX 348	BULBS	26	Narcissus cantabricus 'Silver Palace'	Arnold Trachtenberg	\N	\N	\N	\N
BX 348	BULBS	27	Narcissus jonquilla subsp. cordubensis	Arnold Trachtenberg	\N	\N	\N	\N
BX 348	BULBS	28	Narcissus 'Firelight Gold'	Arnold Trachtenberg	\N	\N	\N	\N
BX 348	BULBS	29	Narcissus cantabricus 'Peppermint'	Arnold Trachtenberg	\N	\N	\N	\N
BX 348	BULBS	30	Narcissus bulbocodium subsp. praecox	Arnold Trachtenberg	\N	\N	\N	\N
BX 348	BULBS	31	Narcissus romieuxii 'Julia Jane'	Arnold Trachtenberg	\N	\N	\N	\N
BX 348	BULBS	32	Narcissus romieuxii var. mesatlanticus	Arnold Trachtenberg	\N	\N	\N	\N
BX 348	BULBS	33	Narcussus romieuxii x N. cantabricus	Arnold Trachtenberg	\N	\N	\N	\N
BX 348	SEED 	34	Crinum macowanii	Tony Avent	ex Zambia	\N	\N	\N
BX 348	SEED 	35	Crinum macowanii	Tony Avent	ex Malawi	\N	\N	\N
BX 348	SEED 	36	Crinum bulbispermum	Tony Avent	ex 'Jumbo Champagne'	\N	\N	\N
BX 348	SEED 	37	Crinum bulbispermum	Tony Avent	ex Orange River form	\N	\N	\N
BX 348	SEED 	38	Crinum bulbispermum	Tony Avent	ex 'Wow'	\N	\N	\N
BX 348	SEED 	39	Crinum [(forbesii x macowanii) x (macowanii x acaule)]	Tony Avent	\N	\N	\N	\N
BX 348	SEED 	40	Ammocharis coranica	Tony Avent	\N	\N	\N	\N
BX 349	SEED 	1	Albuca albucoides	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEED 	2	Albuca namaquensis	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEED 	3	Allium dichlamydeum	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEED 	4	Allium unifolium	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEED 	5	Alstroemeria ligtu subsp. simsii	Nhu Nguyen	a lovely orange form of the subspecies. Seeds self pollinated from the same plant shown on the wiki.	http://pacificbulbsociety.org/pbswiki/index.php/Alstroemeria#ligtu	\N	\N
BX 349	SEED 	6	Brodiaea coronaria	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEED 	7	Brodiaea elegans	Nhu Nguyen	- a wonderful and rewarding species. It is also easy to grow, although very prone to virus infections.	\N	\N	\N
BX 349	SEED 	8	Bulbine aff. diphylla	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEED 	9	Calochortus luteus	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEED 	10	Calochortus vestae	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEED 	11	Chlorogalum pomeridianum	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEED 	12	Cyclamen africanum	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEED 	13	Dichelostemma multiflorum	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEED 	14	Drimia platyphylla	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEED 	15	Erythronium pusaterii	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEED 	16	Iris douglasiana	Nhu Nguyen	wild collected from Marin County, California. These seeds should produce progeny with a a wide variety of colors from bright purple to lilac and almost white.	\N	\N	\N
BX 349	SEED 	17	Ixia viridiflora var. minor	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEED 	18	Lachenalia mathewsii	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEED 	19	Lachenalia viridiflora	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEED 	20	Massonia sp.	Nhu Nguyen	NNBH385, open pollinated	\N	\N	\N
BX 349	SEED 	21	Lachenalia (Polyxena) sp.	Nhu Nguyen	NNBH1779	\N	\N	\N
BX 349	SEED 	22	Triteleia hyacinthina	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEED 	23	Triteleia laxa	Nhu Nguyen	mixed forms	\N	\N	\N
BX 349	SEED 	24	Triteleia laxa	Nhu Nguyen	Tilden form	\N	\N	\N
BX 349	SEED 	25	Tulbaghia dregeana	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEED 	27	Umbilicus rupestris	Nhu Nguyen	- this is a really nice species, but be warned, the plants produce copious seeds and can run amok in succulent collections. Not recommended for countries/areas where invasive plants	\N	\N	\N
BX 349	SEED 	28	Xeronema callistemon	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEED 	29	Zephyranthes sp.	Nhu Nguyen	Guatamala City, white	\N	\N	\N
BX 349	SEED 	30	Zephyranthes sp.	Nhu Nguyen	NNBH1050	\N	\N	\N
BX 349	SEED 	31	Amoreuxia gonzalezii	Leo Martin	\N	\N	\N	\N
BX 349	SEED 	32	Allium peninsulare	Jane McGary	Ratko coll., rare CA sp.	\N	\N	\N
BX 349	SEED 	33	Allium praecox	Jane McGary	Ratko coll. from CA	\N	\N	\N
BX 349	SEED 	34	Allium scorzonerifolium subsp. xericense	Jane McGary	bright yellow	\N	\N	\N
BX 349	SEED 	35	Alstroemeria hookeri	Jane McGary	small, low species	\N	\N	\N
BX 349	SEED 	36	Calochortus argillosus	Jane McGary	southern form, white	\N	\N	\N
BX 349	SEED 	37	Calochortus clavatus var. gracilis	Jane McGary	\N	\N	\N	\N
BX 349	SEED 	38	Calochortus longebarbatus	Jane McGary	interior NW species	\N	\N	\N
BX 349	SEED 	39	Calochortus monophyllus	Jane McGary	short, early yellow	\N	\N	\N
BX 349	SEED 	40	Calochortus obispoensis	Jane McGary	rare endemic, curious	\N	\N	\N
BX 349	SEED 	41	Calochortus plummerae	Jane McGary	late-blooming, rare in cult.	\N	\N	\N
BX 349	SEED 	42	Calochortus venustus	Jane McGary	red forms from 2 populations	\N	\N	\N
BX 349	SEED 	43	Calochortus venustus	Jane McGary	pretty pink forms	\N	\N	\N
BX 349	SEED 	44	Camassia quamash subsp. maxima	Jane McGary	very large form sometimes called `Puget Blue'	\N	\N	\N
BX 349	SEED 	45	Colchicum sp	Jane McGary	SBL 412, fairly small sp.	\N	\N	\N
BX 349	SEED 	46	Crocus oreocreticus	Jane McGary	autumnal	\N	\N	\N
BX 349	SEED 	47	Cyclamen graecum	Jane McGary	from Greek collections	\N	\N	\N
BX 349	SEED 	48	Fritillaria sewerzowi	Jane McGary	Central Asian, give plenty of room	\N	\N	\N
BX 349	SEED 	49	Narcissus obvallaris	Jane McGary	Tenby daffodil of Britain	\N	\N	\N
BX 349	SEED 	50	Sisyrinchium macrocarpum	Jane McGary	little plant with big yellow/brown fls	\N	\N	\N
BX 349	SEED 	51	Triteleia ixioides	Jane McGary	coll. Salinas Co., CA	\N	\N	\N
BX 349	SEED 	52	Triteleia laxa	Jane McGary	giant form from Mariposa Co. CA	\N	\N	\N
BX 349	SEED 	53	Triteleia peduncularis	Jane McGary	striking inflorescence	\N	\N	\N
BX 349	SEED 	54	Tropaeolum tricolor	Jane McGary	hardy strain	\N	\N	\N
BX 349	SEED 	55	Tulipa sprengeri	Jane McGary	\N	\N	\N	\N
BX 350	SEED 	1	Ornithogalum muitifolium	Dylan Hannon	ex Nieuwoudtville, collected 2006. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEED 	2	Bessera elegans	Dylan Hannon	purple, collected 2006. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEED 	3	Cyclamen rohlfsianum	Dylan Hannon	selfed, collected 2003. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEED 	4	Daubenya alba	Dylan Hannon	ex Sutherland, Bu Visririer, 2007. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEED 	5	Daubenya stylosa	Dylan Hannon	collected 2004. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEED 	6	Dipcadi serotinum	Dylan Hannon	ex Portugal:  Quinta do Lago, collected 2006. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEED 	7	Drimia anomala	Dylan Hannon	ex Grahamstown, collected 2004. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 351	BULBS	15	Albuca circinata	Ernie DeMarie		\N	\N	Bulblets
BX 351	BULBS	16	Amaryllis belladonna	Ernie DeMarie	hybrids; white, ex BX 227	\N	\N	Bulblets
BX 350	SEED 	8	Gladiolus equitans	Dylan Hannon	ex Kamieskroon, collected 2004. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEED 	9	Hyacinthoides vincentina	Dylan Hannon	ex Portugal:  Cabo San Vicente, collected 2006. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEED 	10	Iris planifolia	Dylan Hannon	ex Portugal:  west of Loule, collected 2011. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEED 	11	Lapeirousia oreogena	Dylan Hannon	ex Nieuwoudtville, collected 2006. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEED 	12	Lapeirousia plicata	Dylan Hannon	ex Calvinia, Lavranos 30401, collected 2001. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEED 	13	Leucocoryne vittata	Dylan Hannon	collected 2006. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEED 	14	Massonia depressa	Dylan Hannon	ex N of Steinkopf, collected 2006. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEED 	15	Massonia echinata	Dylan Hannon	ex Nieuwoudtville, collected 2007. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEED 	16	Moraea ciliata	Dylan Hannon	ex Sutherland, Lavranos 30469, collected 2008. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEED 	17	Muilla maritima	Dylan Hannon	dwarf form, ex Baja CA, road to La  Zorra, collected 2003. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEED 	18	Ornithogalum polyphyllum	Dylan Hannon	ex Kamieskroon, collected 2006. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 351	BULBS	17	Amaryllis belladonna	Ernie DeMarie	hybrids; pinks, ex BX 227	\N	\N	Bulblets
BX 351	BULBS	18	Amaryllis belladonna	Ernie DeMarie	hybrids; many buds per umble, ex BX 262	\N	\N	Bulblets
BX 351	BULBS	19	Ferraria cf. schaeferi	Ernie DeMarie		\N	\N	Bulblets/Cormlets
BX 351	BULBS	20	Freesia grandilora	Ernie DeMarie	ex Malawi	\N	\N	Cormlets
BX 361	BULBS	3	Arisaema flavum	Jyl Tuck		\N	\N	\N
BX 350	SEED 	19	Ornithogalum reverchonii	Dylan Hannon	ex Spain:  Grazalema, collected 2006. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEED 	20	Brunsvigia litoralis	Kipp Mc Michael	\N	\N	\N	\N
BX 350	SEED 	21	Calochortus ambiguus	Ellen Watrous	wild-collected in Yavapai County, Arizona	\N	\N	\N
BX 350	SEED 	22	Calochortus kennedyi	Ellen Watrous	wild-collected in Yavapai County, Arizona, mixed collection of orange and yellow pod parents.	\N	\N	\N
BX 350	SEED 	23	Calochortus nuttallii	Ellen Watrous	wild-collected in Utah	\N	\N	\N
BX 350	SEED 	24	Eucomis comosa	Dee Foster	various colors	\N	\N	\N
BX 350	SEED 	25	Freesia viridis	Dee Foster	open-pollinated	\N	\N	\N
BX 350	SEED 	26	Veltheimia  bracteata	Dee Foster	pink	\N	\N	\N
BX 350	SEED 	27	Allium cyrilli	Angelo Porcelli	\N	\N	\N	\N
BX 350	SEED 	28	Allium nigrum	Angelo Porcelli	\N	\N	\N	\N
BX 350	SEED 	29	Asphodelus liburnicus	Angelo Porcelli	(Asphodeline?) liburnicus	\N	\N	\N
BX 350	SEED 	30	Narcissus broussonetii	Angelo Porcelli	\N	\N	\N	\N
BX 350	SEED 	31	Narcissus bertolonii	Angelo Porcelli	(N. tazetta subsp. aureus?)	\N	\N	\N
BX 350	SEED 	32	Pancratium illyricum	Angelo Porcelli	\N	\N	\N	\N
BX 350	SEED 	33	Sprekelia formosissima 'Orient Red'  x 'superba'	Angelo Porcelli	\N	\N	\N	\N
BX 350	SEED 	34	Allium dichlamydeum	Mike Mace	\N	\N	\N	\N
BX 350	SEED 	35	Allium unifolium	Mike Mace	(few seeds)	\N	\N	\N
BX 350	SEED 	36	Babiana rubrocyanea	Mike Mace	\N	\N	\N	\N
BX 350	SEED 	37	Bloomeria crocea	Mike Mace	\N	\N	\N	\N
BX 350	SEED 	38	Calochortus amabilis	Mike Mace	(few seeds)	\N	\N	\N
BX 350	SEED 	39	Calochortus argillosus	Mike Mace	\N	\N	\N	\N
BX 350	SEED 	40	Calochortus luteus	Mike Mace	- striations but no spot	\N	\N	\N
BX 350	SEED 	41	Calochortus uniflorus	Mike Mace	(few seeds)	\N	\N	\N
BX 350	SEED 	42	Calochortus weedii	Mike Mace	\N	\N	\N	\N
BX 350	SEED 	43	Ferraria crispa	Mike Mace	maroon/olive	\N	\N	\N
BX 350	SEED 	44	Ferraria crispa	Mike Mace	subsp. nortieri	\N	\N	\N
BX 350	SEED 	45	Ferraria undulata	Mike Mace	(F. crispa subsp crispa?), olive/brown	\N	\N	\N
BX 350	SEED 	46	Geissorhiza aspera	Mike Mace	\N	\N	\N	\N
BX 350	SEED 	47	Geissorhiza monanthos	Mike Mace	\N	\N	\N	\N
BX 350	SEED 	48	Gladiolus trichonemifolius	Mike Mace	\N	\N	\N	\N
BX 350	SEED 	49	Gladiolus violaceolineatus	Mike Mace	\N	\N	\N	\N
BX 350	SEED 	50	Moraea aristata	Mike Mace	\N	\N	\N	\N
BX 350	SEED 	51	Moraea bellendenii	Mike Mace	\N	\N	\N	\N
BX 350	SEED 	52	Moraea elegans	Mike Mace	orange/green/yellow	\N	\N	\N
BX 350	SEED 	53	Moraea elegans	Mike Mace	yellow/green	\N	\N	\N
BX 350	SEED 	54	Moraea fugax	Mike Mace	yellow	\N	\N	\N
BX 350	SEED 	55	Moraea loubseri	Mike Mace	\N	\N	\N	\N
BX 350	SEED 	56	Moraea lurida	Mike Mace	(pale yellow/maroon)	\N	\N	\N
BX 350	SEED 	57	Moraea macrocarpa	Mike Mace	\N	\N	\N	\N
BX 350	SEED 	58	Moraea polyanthos	Mike Mace	\N	\N	\N	\N
BX 350	SEED 	59	Moraea tripetala	Mike Mace	\N	\N	\N	\N
BX 350	SEED 	60	Moraea tulbaghensis	Mike Mace	(tulbaghensis form, with dark orange tepals/dark gray eye)	\N	\N	\N
BX 350	SEED 	61	Moraea villosa 'A'	Mike Mace	form A	\N	\N	\N
BX 350	SEED 	62	Moraea villosa 'B'	Mike Mace	form B	\N	\N	\N
BX 350	SEED 	63	Moraea villosa	Mike Mace	mixed colors	\N	\N	\N
BX 350	SEED 	64	Onixotis triquetra	Mike Mace	(Wurmbea stricta?)	\N	\N	\N
BX 350	SEED 	65	Romulea camerooniana	Mike Mace	pink	\N	\N	\N
BX 350	SEED 	66	Romulea camerooniana	Mike Mace	white	\N	\N	\N
BX 350	SEED 	67	Romulea eximia	Mike Mace	\N	\N	\N	\N
BX 350	SEED 	68	Romulea tabularis	Mike Mace	\N	\N	\N	\N
BX 350	SEED 	69	Sprarxis metelerkampiae	Mike Mace	\N	\N	\N	\N
BX 350	SEED 	70	Alstromeria sp.	Dylan Hannon	sp?, magenta, 2013	\N	\N	\N
BX 350	SEED 	71	Albuca concordiana	Dylan Hannon	(Ornithogalum), 2013	\N	\N	\N
BX 345	SEEDS	7.1	Hymenocallis glauca	Dave Boucher	(few). First of two listed as item 7.	\N	\N	\N
BX 345	BULBS	7.2	Ferraria crispa	Monica Swartz	Form A'. Second of two listed as item 7.	\N	\N	\N
BX 345	SEEDS	8.1	Dracunculus vulgaris	Jim Waddick and Jim Murrain	mixed. First of two listed as item 8.	\N	\N	\N
BX 345	BULBS	8.2	Ferraria crispa	Monica Swartz	dark form. Second of two listed as item 8.	\N	\N	\N
BX 345	BULBS	9.1	Hippeastrum papilio	Bob Hoel	Near Blooming size bulbs. SPECIAL PRICE: $7 EACH. Order multiples if you want them. First of two listed as item 9.	\N	\N	\N
BX 345	BULBS	9.2	Ferraria schaeferi	Monica Swartz	Second of two listed as item 9.	\N	\N	\N
BX 351	BULBS	1	Albuca juncifolia	Monica Swartz	Small bulbs. ex BX 236	\N	\N	\N
BX 351	BULBS	2	Lachenalia liliflora	Monica Swartz	Small bulbs. ex BX 181	\N	\N	\N
BX 351	BULBS	3	Lachenalia paucifolia	Monica Swartz	(Polyxena paucifolia) ex BX242. Bulblets.	\N	\N	\N
BX 351	BULBS	4	Albuca glandulifera	Monica Swartz	Small bulbs. (Original listing spelled Albuca glandulifolia). ex Jim Duggan Flower Nursery	\N	\N	\N
BX 351	BULBS	5	Tritonia dubia	Monica Swartz	Cormlets. ex BX 241	\N	\N	\N
BX 351	BULBS	6	Ornithogalum reverchonii	Monica Swartz	Small bulbs. ex BX 290	\N	\N	\N
BX 351	BULBS	7	Albuca namaquensis	Monica Swartz	Small bulbs. ex BX 174	\N	\N	\N
BX 351	BULBS	8	Lachenalia ensifolia	Monica Swartz	Small bulbs. (Polyxena ensifolia)	\N	\N	\N
BX 351	BULBS	9	Albuca acuminata	Monica Swartz	Small bulbs	\N	\N	\N
BX 351	BULBS	10	Ornithogalum pilosum	Tom Glavich	ex Charles Craib	\N	\N	Small bulbs
BX 351	BULBS	11	Eucomis comosa	Dee Foster?	mixed colors: white, pink, purple. open-pollinated	\N	\N	Small bulbs
BX 351	BULBS	12	Lycoris houdyshelii	Kelly Irvin	Small bulbs of 'the true' Lycoris houdyshelii	\N	\N	\N
BX 351	BULBS	13	Camassia	Joyce Miller	Camassia;bulbs, species unknown. These were grown from BX seed. I planted C leichtlinii, C quamash and C. cusickii. The flower color is not white or blue, but is lavender.	\N	\N	Bulbs
BX 351	BULBS	14	Arum dioscorides	Ernie DeMarie	var. cyprium	\N	\N	Bulblets/Cormlets
BX 351	BULBS	21	Gladiolus orchidiflorus	Ernie DeMarie	Later discoved to be mixed with Gladiolus splendens	\N	\N	Cormlets
BX 351	BULBS	22	Gladiolus alatus	Ernie DeMarie		\N	\N	Cormlets
BX 351	BULBS	23	Gladiolus scullyi	Ernie DeMarie		\N	\N	Cormlets
BX 351	BULBS	24	Gladiolus tristis	Ernie DeMarie	dark flowers, ex Lifestyle Seeds	\N	\N	Cormlets
BX 351	BULBS	25	Gladiolus tristis	Ernie DeMarie	hybrid (x G. alatus?)	\N	\N	Cormlets
BX 351	BULBS	26	Gladiolus virescens	Ernie DeMarie	ex Lifestyle Seeds	\N	\N	Cormlets
BX 351	BULBS	27	Ipheion sellowianum	Ernie DeMarie	(Tristagma sellowianum)	\N	\N	Bulblets/Cormlets
BX 351	BULBS	28	Ixia rouxii	Ernie DeMarie	ex SRGS	\N	\N	Cormlets
BX 351	BULBS	29	Nerine humilis	Ernie DeMarie		\N	\N	Bulblets/Cormlets
BX 351	BULBS	30	Lachenalia convallarioides	Ernie DeMarie	ex Silverhill	\N	\N	Bulblets/Cormlets
BX 351	BULBS	31	Othonna sp	Ernie DeMarie	?; Simonsvlei, white flowers	\N	\N	Bulblets/Cormlets
BX 351	BULBS	32	Sparaxis	Ernie DeMarie	Hadeco hybrids; ex Chiltern's	\N	\N	Cormlets
BX 351	BULBS	33	Sparaxis tricolor	Ernie DeMarie	ex Silverhill	\N	\N	Cormlets
BX 351	BULBS	34	Tritonia deusta	Ernie DeMarie		\N	\N	Bulblets/Cormlets
BX 351	BULBS	35	Veltheimia 'Lemon Flame'	Ernie DeMarie	selfed	\N	\N	Bulblets
BX 351	BULBS	36	Watsonia cf. laccata	Ernie DeMarie	orange dwarf	\N	\N	Cormlets
BX 352	SEEDS	1	Calochortus albus	Robert Werra		\N	\N	\N
BX 352	SEEDS	2	Calochortus amabilis	Robert Werra		\N	\N	\N
BX 352	SEEDS	3	Calochortus catalinae	Robert Werra		\N	\N	\N
BX 352	SEEDS	4	Calochortus obispoensis	Robert Werra		\N	\N	\N
BX 352	SEEDS	5	Calochortus uniflorus	Robert Werra		\N	\N	\N
BX 352	SEEDS	6	Calochortus venustus	Robert Werra	white	\N	\N	\N
BX 352	SEEDS	7	Calochortus weedii	Robert Werra	yellow	\N	\N	\N
BX 352	SEEDS	8	Fritillaria affinis	Robert Werra		\N	\N	\N
BX 352	SEEDS	9	Moraea bellendenii	Robert Werra		\N	\N	\N
BX 352	SEEDS	10	Moraea pendula	Robert Werra		\N	\N	\N
BX 352	SEEDS	11	Moraea polyanthos	Robert Werra		\N	\N	\N
BX 352	SEEDS	12	Moraea tripetala	Robert Werra		\N	\N	\N
BX 352	SEEDS	13	Moraea vegeta	Robert Werra	tan	\N	\N	\N
BX 352	SEEDS	14	Moraea vegeta	Robert Werra	yellow	\N	\N	\N
BX 352	SEEDS	15	Moraea vespertina	Robert Werra		\N	\N	\N
BX 352	SEEDS	16	Moraea villosa	Robert Werra		\N	\N	\N
BX 352	SEEDS	17	Romulea tabularis	Robert Werra	blue/purple	\N	\N	\N
BX 352	BULBS	18	Calochortus amabilis	Robert Werra	cormlets	\N	\N	\N
BX 352	BULBS	19	Moraea ciliata	Robert Werra	blue. cormlets	\N	\N	\N
BX 352	SEEDS	20	Lilium pumilum	Francisco Torres		\N	\N	\N
BX 352	SEEDS	21	Tulipa kaufmanniana	Francisco Torres		\N	\N	\N
BX 352	SEEDS	22	Paris quadrifolia	Francisco Torres		\N	\N	\N
BX 352	SEEDS	23	Phalocallis coelestis	Francisco Torres	(Cypella) coelestis	\N	\N	\N
BX 352	SEEDS	24	Gladiolus palustris	Francisco Torres		\N	\N	\N
BX 352	SEEDS	25	Belamcanda sinensis	Francisco Torres	(Iris domestica)	\N	\N	\N
BX 352	SEEDS	26	Sternbergia lutea	Angelo Porcelli	large flowers	\N	\N	Seeds
BX 352	SEEDS	27	Camassia scilloides	Rodney Barton	ex Colin County, Texas	\N	\N	Seeds
BX 352	SEEDS	28	Cyanella hyacinthoides	Mary Sue Ittner	- winter growing	\N	w	\N
BX 352	SEEDS	29	Eucomis bicolor	Mary Sue Ittner	- summer growing	\N	s	\N
BX 352	SEEDS	30	Freesia grandiflora	Mary Sue Ittner	- winter growing	\N	w	\N
BX 352	SEEDS	31	Lilium maritimum	Mary Sue Ittner	- redwood forest coastal plant	\N	\N	\N
BX 352	SEEDS	32	Lilium pardalinum 'Giganteum'	Mary Sue Ittner	- seed from this plant which may be a hybrid between it and Lilium humboldtii or just a very large form, winter growing, summer flowering	\N	w	\N
BX 352	SEEDS	33	Nerine platypetala	Mary Sue Ittner	-summer growing	\N	s	\N
BX 352	SEEDS	34	Nerine sarniensis	Mary Sue Ittner	hybrids - winter growing	\N	w	\N
BX 352	SEEDS	35	Sandersonia aurantiaca	Mary Sue Ittner	- summer growing	\N	s	\N
BX 352	SEEDS	36	Tigridia vanhouttei	Mary Sue Ittner	- summer growing, individual flowers short lived, but mine blooms for months, flies pollinate it	\N	s	\N
BX 353	SEEDS	1	Clivia miniata 'Nakamura Bronze'	Stephen Gregg	multipetal	\N	\N	\N
BX 353	SEEDS	2	Clivia miniata 'Chubb'	Stephen Gregg	peach-yellow	\N	\N	\N
BX 353	SEEDS	3	Clivia miniata 'Chinese Daruma'	Stephen Gregg	selfed	\N	\N	\N
BX 353	SEEDS	4	Clivia miniata Belgian	Stephen Gregg	Belgian hybrids, yellow x red broadleafed	\N	\N	\N
BX 353	SEEDS	5	Clivia miniata Nakamura	Stephen Gregg	Nakamura hybrid, broad leafed red	\N	\N	\N
BX 353	SEEDS	6	Clivia miniata Peachy	Stephen Gregg	Peachy pastels	\N	\N	\N
BX 353	SEEDS	7	Clivia miniata Nakamura	Stephen Gregg	Nakamura pastel multipetal	\N	\N	\N
BX 353	SEEDS	8	Eucomis vandermerwei	Arnold Trachtenberg		\N	\N	Small bulbs
BX 353	BULBS	9	Moraea setifolia	Rodney Barton	from SIGNA seed	\N	\N	\N
BX 353	BULBS	10	Freesia viridis	Rodney Barton	from SIGNA seed	\N	\N	\N
BX 353	BULBS	11	Gladiolus dalenii var. garnieri Madagascar form	Rodney Barton	ex seeds from Maurice Boussard (Gladiolus garneri / Gladiolus watsonioides)	\N	\N	\N
BX 353	BULBS	12	Pancratium maritimum	Francisco Torres		\N	\N	Seed
BX 353	BULBS	13	Lapeirousia neglecta	Ernie De Marie		\N	\N	Cormlets
BX 353	BULBS	14	Melasphaerula ramosa	Mary Sue Ittner		\N	\N	Bulblets
BX 353	BULBS	15	Calochortus argillosus	Mary Sue Ittner		\N	\N	Bulblets
BX 353	BULBS	16	Manfreda undulata	Monica Swartz		\N	\N	Seed
BX 353	BULBS	17	Lachenalia vanzyliae	Monica Swartz		\N	\N	Small bulbs
BX 353	BULBS	18	Lachenalia mutabilis	Monica Swartz	electric blue	\N	\N	Bulbs
BX 353	BULBS	19	Lachenalia quadricolor	Monica Swartz		\N	\N	Bulbs
BX 353	BULBS	20	Lachenalia unicolor	Monica Swartz		\N	\N	Bulbs
BX 353	BULBS	21	Brunsvigia bosmaniae	Monica Swartz		\N	\N	Seeds
BX 353	BULBS	22	mixed bearded	Jude Platteborze	iris	\N	\N	Small rhizomes
BX 353	BULBS	23	Convallaria	Jude Platteborze	- mixed white, pink and double. Initially listed as 'Roots or Aspidistra sp.'	\N	\N	\N
BX 353	BULBS	24	Rohdea japonica	Jude Platteborze		\N	\N	Rhizomes
BX 353	BULBS	25	Rhodophiala bifida	Cynthia Mueller	pink	\N	\N	Seed
BX 353	BULBS	26	Rhodophiala bifida	Cynthia Mueller	pink with star in throat	\N	\N	Seed
BX 353	SEEDS	27	Lilium regale 'Alba'	Rimmer de Vries		\N	\N	\N
BX 353	SEEDS	28	Allium senescens subsp. montanum	Rimmer de Vries		\N	\N	\N
BX 353	SEEDS	29	Iris delavayi	Rimmer de Vries		\N	\N	\N
BX 354	BULBS	1	Hippeastrum hybrids	Jude Platteborze	Bulbs of Hippeastrum commercial hybrids. Varying from 2 - 6 cm diameter. Only one available of most of these. SPECIFY A QUANTITY OF ASSORTED BULBS. ($1 apiece) Varieties include: Joker, Desire, Exotica, Harlequin, Grand Cru, Scarlet Baby, Night Star, Jewel, Little Devil, United Nations, Donau, Pavlova, Pizzazz, Celica, Monte Carlo, President Johnson, Ragtime, Fanfare, Aphrodite, Lovely Garden, Temptation, Mega Star, Novella, Giraffe, Flamenco Queen.	\N	\N	Bulbs
BX 354	SEEDS	2	Zephyranthes smallii	Jim Shields (and Charles Crane)	original seed collected near airport at Brownsville, TX	\N	\N	Seeds
BX 354	SEEDS	3	Chlorogalum pomeridianum	Mary Sue Ittner	- winter growing	\N	w	\N
BX 354	SEEDS	4	Eucomis comosa	Mary Sue Ittner	- summer growing, purple leaves	\N	s	\N
BX 354	SEEDS	5	Nerine angustifolia	Mary Sue Ittner	(already sprouting), open pollinated so likely hybrid	\N	\N	\N
BX 354	SEEDS	6	Nerine sarniensis	Mary Sue Ittner	(mixed colors)	\N	\N	\N
BX 354	SEEDS	7	Polianthes geminiflora	Mary Sue Ittner	- summer growing	\N	s	\N
BX 354	SEEDS	8	Tigridia vanhouttei	Mary Sue Ittner	- summer growing	\N	s	\N
BX 354	SEEDS	9	Arisaema triphyllum	Nicholas Plummer	- these are seeds from plants grown in my garden and are two generations removed from seed originally collected in Wake Co, NC. I usually observe good germination after cold, moist stratification.	\N	\N	Seeds
BX 354	SEEDS	10	Lilium formosanum	Nicholas Plummer	- these are the tall standard variety originally purchased from Niche Gardens. They were pollinated by moths in the open garden, but I did not have any other Lilium species blooming at the time. I think the chance of hybrids is minimal. These plants volunteer readily, so I have never attempted controlled germination. Consequently, I do not know what percentage of seeds are viable.	\N	\N	Seeds
BX 354	SEEDS	11	Calochortus venustus	Chris Elwell	burgundy (OP)	\N	\N	\N
BX 354	SEEDS	12	Calochortus venustus	Chris Elwell	var. sanguineus (OP)	\N	\N	\N
BX 354	SEEDS	13	Habranthus gracilifolius	Chris Elwell		\N	\N	\N
BX 354	SEEDS	14	Gloriosa superba	Dee Foster		\N	\N	Seeds
BX 354	SEEDS	15	Eucomis comosa	Dee Foster	pink, purple, white mix (OP)	\N	\N	Seeds
BX 354	SEEDS	16	Eucomis comosa	Dee Foster	dwarf purple (OP)	\N	\N	Seeds
BX 354	SEEDS	17	Lycoris	Jim Waddick	- L. chinensis, L. longituba, L. longituba flava and hybrids all mixed	\N	\N	Seeds
BX 354	SEEDS	18	Hippeastrum papilio	Marvin Ellenbecker	(2 - 6 cm dia.)	\N	\N	Bulbs
BX 355	SEEDS	1	Clivia miniata	Rimmer de Vries	yellow	\N	\N	\N
BX 355	SEEDS	2	Iris 'Dunshanbe'	Rimmer de Vries	OP- few seeds	\N	\N	\N
BX 355	SEEDS	3	Iris hoogiana 'Bronze Beauty' x Iris hoogiana	Rimmer de Vries	(med blue color)- quite a few seeds	\N	\N	\N
BX 355	SEEDS	4	Barnardia japonica	Rimmer de Vries	(Scilla) japonica; (There is much confusion about the correct name)	\N	\N	\N
BX 355	SEEDS	5	Tigridia pavonia	Rimmer de Vries	seeds from the 'Sunset in Oz' plants came From Ellen Hornig in BX 272 #10. Parent plants pictured in the Sept 2013 International rock Gardener	http://srgc.org.uk/logs/logdir/#	\N	\N
BX 355	BULBS	6	Habranthus tubispathus	Jim Shields	(typical Texas form) The rain lilies are from Charles Crane's research collection at Purdue. He collected the original bulbs in Texas up to 40 years ago. These are selected seedlings, descendants of the original wild-collected parents.	\N	\N	\N
BX 355	BULBS	7	Habranthus tubispathus	Jim Shields	(form from San Marcos county, TX) The rain lilies are from Charles Crane's research collection at Purdue. He collected the original bulbs in Texas up to 40 years ago. These are selected seedlings, descendants of the original wild-collected parents.	\N	\N	\N
BX 355	BULBS	8	Zephyranthes jonesii	Jim Shields	The rain lilies are from Charles Crane's research collection at Purdue. He collected the original bulbs in Texas up to 40 years ago. These are selected seedlings, descendants of the original wild-collected parents.	\N	\N	\N
BX 355	BULBS	9	Zephyranthes pulchella	Jim Shields	(from Texas originally) The rain lilies are from Charles Crane's research collection at Purdue. He collected the original bulbs in Texas up to 40 years ago. These are selected seedlings, descendants of the original wild-collected parents.	\N	\N	\N
BX 355	BULBS	10	Zephyranthes smallii	Jim Shields	(from Texas originally)	\N	\N	\N
BX 355	BULBS	11	Tristagma	Jim Shields	(Ipheion) 'Charlotte Bishop' (a very few bulbs) The Ipheion bulbs are originally from gardens	\N	\N	\N
BX 355	BULBS	12	Tristagma	Jim Shields	(Ipheion) 'Rolf Fiedler' The Ipheion bulbs are originally from gardens	\N	\N	\N
BX 356	SEEDS	1	Crinum americanum	Kipp McMichael	ex Florida	\N	\N	Seeds
BX 356	BULBS	2	Hymenocallis latifolia	Kipp McMichael	- very few	\N	\N	Bulbils
BX 356	SEEDS	3	Narcissus serotinus	Donald Leevers		\N	\N	Seed
BX 356	SEEDS	4	Pancratium maritimum	Donald Leevers		\N	\N	Seed
BX 356	SEEDS	5	Cardiocrinum giganteum	Donald Leevers		\N	\N	Seed
BX 356	SEEDS	6	Agapanthus	Bea Spencer	Headbourne hybrids	\N	\N	Seed
BX 356	SEEDS	7	Alophia drummondii	Jonathan Lubar		\N	\N	Seeds
BX 356	SEEDS	8	Nemastylis floridiana	Jonathan Lubar		\N	\N	Seeds
BX 356	SEEDS	9	Amoreuxia gonzalezii	Shawn Pollard		\N	\N	\N
BX 356	SEEDS	10	Amoreuxia palmatifida	Shawn Pollard		\N	\N	\N
BX 356	SEEDS	11	Allium tuberosum	Shawn Pollard		\N	\N	\N
BX 356	SEEDS	12	Senna hirsuta var glaberrima	Shawn Pollard		\N	\N	\N
BX 356	SEEDS	13	Proboscidea althaeifolia	Shawn Pollard		\N	\N	\N
BX 357	SEEDS	1	Achimenes pedunculata	Uli Urban	aerial bulbili summer growing winter dormant Gesneriad, upright plant to 1m tall, lots of small orange-red flowers, needs good light	\N	\N	\N
BX 357	SEEDS	2	Albuca aurea	Uli Urban	not really yellow, rather greenish yellow upright flowers, stout evergreen plant, flowers in spring 50cm tall. Always looks somewhat untidy.	\N	\N	\N
BX 357	SEEDS	3	Albuca shawii	Uli Urban	(Ornithogalum shawii, Albuca tenuifolia) 40cm tall, summer growing, winter dormant, nodding yellow unscented flowers, pleasantly fragrant foliage	\N	\N	\N
BX 357	SEEDS	4	Albuca sp	Uli Urban	.;?. bought as shawii but distinct. Leaves not fragrant, scented yellow nodding flowers, 40cm, possibly a variation of shawii	\N	\N	\N
BX 357	SEEDS	5	Albuca sp	Uli Urban	.;? tall white inflorescence, evergreen tidy foliage, very lush plant. bought as a very small offset in a California rare plant fair, 1,5m tall.	\N	\N	\N
BX 357	SEEDS	6	Allium cernuum	Uli Urban	charming inflorescence of many dangling purple urns, stamens protruding. 60cm tall, very hardy, summer flowering	\N	\N	\N
BX 357	SEEDS	7	Arisaema cf	Uli Urban	. consanguineum; from Chiltern seeds, tall plant, many leaflets arranged radially, green flowers, enormous bright red fruit. Not tested for hardiness. 1.2m tall.	\N	\N	\N
BX 357	SEEDS	8	Canna paniculata	Uli Urban	(?) evergreen, no rest period, it will die if you keep it as a dry rhizome. flowers in spring rather insignificant. But magnificent foliage plant. Identity not certain, from a few grains from Bolivia.	\N	\N	\N
BX 357	SEEDS	9	Dahlia coccinea	Uli Urban	(var palmeri) (open pollinated, may not come true) The original seed was from Harry Hay. Collecting data available. Fantastic plant, likes cool summers and/or semi shade. best in September when it cools down. 2,5m tall, very elegant, finely dissected foliage, horizontal bright orange single flowers. Seeds germinate best in cool conditions. Some plants may flower yellow, also attractive. VERY IMPORTANT: the tubers will form at a good distance from the main stem, only attached by a thin string-like root. It DOES form tubers, take care when digging it up for winter storage. Does not reach its adult size the first year from seed.	\N	\N	\N
BX 357	SEEDS	10	Ipomoea lindheimeri	Uli Urban	not a tuber but a fleshy rhizome. Pretty light blue flowers with a cream throat, slighty scented. A US native. Easy.	\N	\N	\N
BX 357	SEEDS	11	Lilium	Uli Urban	White Tetra Trumpets';like a giant version of Lilium regale but lacking its elegance.	\N	\N	\N
BX 357	SEEDS	12	Mirabilis jalapa	Uli Urban	tall form much taller than the trade form. Up to 1,8m. large mostly purple flowers. The tuber is so big that I can hardly carry it when I dig it up for winter storage. From cultivated plants in Bolivia.	\N	\N	\N
BX 357	SEEDS	13	Nerine bowdenii	Uli Urban	Typ Oswald From Mr Oswald in the former East-Germany. The origin of this plant is obscure. Looks like ordinary N. bowdenii but much hardier. Mr Oswald grows his stock plants among the beans and strawberries in his garden, heavily mulched in winter. (Zone 7) Seed has sprouted and is forming small bulbs. Should be planted immediately on receipt. Summer growing, it should still form a small plant this season.	\N	\N	\N
BX 357	SEEDS	14	Nerine alta	Uli Urban	(N. undulata)(?) Bought as N. bowdenii seed from David Human in South Africa but is so distinct that I doubt. Very frilled narrow petals, many more flowers per stem than bowdenii. Has proved extremely hardy (Zone 7, Temps can go down to -20°C) with winter mulch and protection from winter wet. Takes a long time to establish. Very attractive. Seed has sprouted as well, see above.	\N	\N	\N
BX 357	SEEDS	15	Tradescantia boliviana	Uli Urban	Only recently described. 80cm tall upright perennial, summer growing, strictly and completely dry winter dormancy. Needs full sun to remain upright, masses of medium sized purple triangles along the shoots, very attractive. Bolivian native.	\N	\N	\N
BX 357	SEEDS	16	Tropaeolum pentaphyllum	Uli Urban	subsp. megapetalum. The summer growing and winter dormant version of T. pentaphyllum, Has two relatively large bright red 'ears'. Difficult and slow to germinate, sometimes germinating very easily. Forms very large sausage shaped tubers, strictly winter dormant. Very vigorous climber. Bolivia	\N	\N	\N
BX 357	SEEDS	17	Zantedeschia jucunda	Uli Urban	originally from Chiltern seeds, summer growing winter dormant species. Attractive foliage is bright green with white dots and the flowers are of a very thick wax like texture, very long lasting but.... not very numerous. always sets seed but this takes ages to ripen. I am not sure if this seeds is properly ripe, the pods went soft and mushy so I cleaned and dried it. The pods remain on the plant long after the leaves have died down.	\N	\N	\N
BX 357	BULBS	18	Rhodohypoxis 'Albrighton'	Roy Herold	Most of the Rhodohypoxis are blooming size.	\N	\N	\N
BX 357	BULBS	19	Rhodohypoxis 'Hinky Pinky'	Roy Herold	(few) Most of the Rhodohypoxis are blooming size.	\N	\N	\N
BX 357	BULBS	20	Rhodohypoxis 'Candy Stripe'	Roy Herold	Most of the Rhodohypoxis are blooming size.	\N	\N	\N
BX 357	BULBS	21	Rhodohypoxis 'Stella'	Roy Herold	Most of the Rhodohypoxis are blooming size.	\N	\N	\N
BX 357	BULBS	22	Rhodohypoxis 'Tetra Pink'	Roy Herold	Most of the Rhodohypoxis are blooming size.	\N	\N	\N
BX 357	BULBS	23	Rhodohypoxis 'Harlequin'	Roy Herold	Most of the Rhodohypoxis are blooming size.	\N	\N	\N
BX 357	BULBS	24	Rhodohypoxis 'Matt's White	Roy Herold	I received this one from Matt Mattus as 'White', possibly due to a lost label. I'm sure it has a proper cultivar name (perhaps 'Helen'), but I haven't been able to figure it out for sure. Most of the Rhodohypoxis are blooming size.	\N	\N	\N
BX 357	BULBS	25	Calanthe 'Kozu Hybrids'	Roy Herold	Brick Red. The Calanthes will take another year to bloom.	\N	\N	\N
BX 357	BULBS	26	Calanthe 'Kozu Hybrids'	Roy Herold	Pink. The Calanthes will take another year to bloom.	\N	\N	\N
BX 357	SEEDS	27	Eucomis vandermerwei	Roy Herold	(OP, some might be hybrids with E. zambesiaca)	\N	\N	\N
BX 357	SEEDS	28	Eucomis zambesiaca	Roy Herold	(OP, some might be hybrids with E. vandermerwei)	\N	\N	\N
BX 357	SEEDS	29	Narcissus tazetta	Bill Welch	best autumn and winter-flowering selections, hand-crossed, often with polyploids. Full range of colors	\N	\N	Seed
BX 357	SEEDS	30	Zephyranthes macrosiphon	Dave Brastow		\N	\N	Seed
BX 357	SEEDS	31	Actaea pachypoda	Jerry Lehmann	from cultivated stock	\N	\N	Seeds
BX 357	SEEDS	33	Heirloom hippeastrum	Ann Patterson	that was discussed on the list a while back. One order only.	\N	\N	Seeds
BX 358	SEEDS	1	Delphinium nudicaule	Mary Sue Ittner	this one is a dark red, rather than the usual orange red. It bloomed early before the others so seedlings might turn out to be this color.	\N	\N	\N
BX 358	SEEDS	2	Haemanthus deformis	Mary Sue Ittner	- mostly evergreen, with giant leaves and beautiful flowers in winter, often when not much else is blooming; I grow this year round in my unheated greenhouse in Northern California.	http://pacificbulbsociety.org/pbswiki/index.php/#	e	\N
BX 358	SEEDS	3	Gloriosa superba	Mary Sue Ittner	summer growing, I let it dry out in winter in my greenhouse, but grow it there in summer where it gets extra warmth in my cooler summer climate. This is a photo of it in bloom.	http://pacificbulbsociety.org/pbswiki/files/#	s	\N
BX 358	SEEDS	4	Brunsvigia grandiflora	Mary Sue Ittner	only a few seed, some sprouting, summer flowering in South Africa, but mine in California bloom late fall, early winter	\N	\N	\N
BX 358	SEEDS	5	Moraea polystachya	Mary Sue Ittner	long blooming fall into winter, may need some moisture during dormancy, comes into growth early fall	\N	w	\N
BX 358	SEEDS	6	Scadoxus membranaceus	Mary Sue Ittner	- only a few seed, summer growing, this is a lovely plant, see photos here from Nhu and me	http://pacificbulbsociety.org/pbswiki/index.php/#	s	\N
BX 358	SEEDS	7	Zephyranthes 'Hidalgo' 'John Fellers'	Ina Crossley		\N	\N	\N
BX 358	SEEDS	8	Zephyranthes jonesii	Ina Crossley		\N	\N	\N
BX 358	SEEDS	9	Zephyranthes dichromantha	Ina Crossley		\N	\N	\N
BX 358	SEEDS	10	Zephyranthes flavissima	Ina Crossley		\N	\N	\N
BX 358	SEEDS	11	Zephyranthes minuta	Ina Crossley	white	\N	\N	\N
BX 358	SEEDS	12	Zephyranthes katheriniae	Ina Crossley	red form	\N	\N	\N
BX 358	SEEDS	13	Zephyranthes 'Pink Beauty'	Ina Crossley		\N	\N	\N
BX 358	SEEDS	14	Zephyranthes macrosiphon 'Hidalgo'	Ina Crossley		\N	\N	\N
BX 358	SEEDS	15	Zephyranthes drummondii	Ina Crossley		\N	\N	\N
BX 358	SEEDS	16	Zephyranthes citrina	Ina Crossley		\N	\N	\N
BX 358	SEEDS	17	Zephyranthes primulina	Ina Crossley		\N	\N	\N
BX 358	SEEDS	18	Zephyranthes lindleyana	Ina Crossley		\N	\N	\N
BX 358	SEEDS	19	Zephyranthes mesochloa	Ina Crossley		\N	\N	\N
BX 358	SEEDS	20	Zephyranthes morrisclintii	Ina Crossley		\N	\N	\N
BX 358	SEEDS	21	Zephyranthes primulina	Ina Crossley	hybrid	\N	\N	\N
BX 358	SEEDS	22	Zephyranthes 'Sunset Strain'	Ina Crossley		\N	\N	\N
BX 358	SEEDS	23	Zephyranthes minuta 'Rosea'	Ina Crossley		\N	\N	\N
BX 358	SEEDS	24	Zephyranthes 'Hidalgo' x Z. grandiflora	Ina Crossley		\N	\N	\N
BX 358	SEEDS	25	Zephyranthes reginae	Ina Crossley		\N	\N	\N
BX 358	SEEDS	26	Tigridia pavonia	Ina Crossley	white	\N	\N	\N
BX 358	SEEDS	27	Kniphofia typhoides	Ina Crossley		\N	\N	\N
BX 358	SEEDS	28	H. 'Emerald' x H. 'Grandeur'	Tim Eck	Hippeastrum crosses	\N	\N	\N
BX 358	SEEDS	29	H. 'Lima' x (H. papilio x H. mandonii)	Tim Eck	Hippeastrum crosses	\N	\N	\N
BX 358	SEEDS	30	H. 'Evergreen' x (H.papilio x (H. cybister x H. papilio))	Tim Eck	Hippeastrum crosses	\N	\N	\N
BX 358	SEEDS	31	(H. neopardinum x H. papilio) x (H. cybister x H. papilio) F2	Tim Eck	subsp. megapetalum. The summer growing and winter dormant version of T. pentaphyllum, Has two relatively large bright red ears. Difficult and slow to germinate, sometimes germinating very easily. Forms very large sausage shaped tubers, strictly winter dormant. Very vigorous climber. Bolivia	\N	\N	\N
BX 358	SEEDS	32	H. papilio x S. 'Durgha-Pradham'	Tim Eck	Hippeastrum x Sprekelia	\N	\N	\N
BX 358	SEEDS	33	H. 'Emerald' x S. 'Durgha-Pradham'	Tim Eck	Hippeastrum x Sprekelia	\N	\N	\N
BX 358	SEEDS	34	H. papilio x S. formosissima	Tim Eck	Hippeastrum x Sprekelia	\N	\N	\N
BX 359	BULBS	1	Crinum 'Menehune'	Lyn Makela	deep wine-color leaves (Crinum oliganthum x C. asiaticum?)	\N	\N	\N
BX 359	BULBS	2	Talinum sp	Lyn Makela	from Yucca Do, ex Salta City, Argentina. Looks like 'Eyerdamii'? 12 inches	\N	\N	\N
BX 359	BULBS	3	Zephyranthes verecunda rosea	Lyn Makela	(Zephyranthes minuta 'Rosea')	\N	\N	\N
BX 359	BULBS	4	Cyrtanthus elatus x montanus	Mary Sue Ittner	- I keep in my greenhouse year round, for photos and info:	http://pacificbulbsociety.org/pbswiki/index.php/#	e	\N
BX 359	BULBS	5	Rhodohypoxis baurii	Mary Sue Ittner	- light pink, summer growing	\N	s	\N
BX 359	BULBS	6	Tigridia vanhouttei	Mary Sue Ittner	- winter dormant for me, summer growing, blooms late summer to fall, pollinated by flies	\N	s	\N
BX 359	BULBS	7	Zephyranthes candida	Jim Waddick		\N	\N	\N
BX 359	BULBS	8	Zephyranthes citrina	Jim Waddick		\N	\N	\N
BX 359	BULBS	9	Zephyranthes pulchella	Jim Waddick		\N	\N	\N
BX 359	BULBS	10	Zephyranthes candida	Jim Waddick	from a source different from #7	\N	\N	\N
BX 359	BULBS	11	Zephyranthes	Jim Waddick	Lost Label - citrina - I think, might be candida or something else.	\N	\N	\N
BX 359	BULBS	12	Drimiopsis maculata	Jim Waddick	ex Mark Mazer	\N	\N	\N
BX 360	SEEDS	1	Zephyranthes drummondii	Lynn Makela		\N	\N	\N
BX 360	SEEDS	2	Zephyranthes lindleyana	Lynn Makela		\N	\N	\N
BX 360	SEEDS	3	Zephyranthes morrisclintii	Lynn Makela		\N	\N	\N
BX 360	SEEDS	4	Zephyranthes primulina	Lynn Makela		\N	\N	\N
BX 360	SEEDS	5	Zephyranthes reginae	Lynn Makela		\N	\N	\N
BX 360	SEEDS	6	Zephyranthes sp.	Lynn Makela	. ex Jacala, Mexico, wine red	\N	\N	\N
BX 360	SEEDS	7	Hippeastrum neopardinum x H. papilio	Tim Eck	F2	\N	\N	\N
BX 360	SEEDS	8	Hippeastrum 'Lima' x H. 'Jade Dragon'	Tim Eck		\N	\N	\N
BX 360	SEEDS	9	Hippeastrum (neopardinum x papilio ) x (cybister x papilio)	Tim Eck	Excellent!	\N	\N	\N
BX 360	SEEDS	10	Hippeastrum 'Ludwig Goliath' x 'Red Pearl'	Tim Eck	Both > 8 inch dia. flowers	\N	\N	\N
BX 360	SEEDS	11	Hippeastrum (papilio x mandonii) x 'Jade Dragon'	Tim Eck		\N	\N	\N
BX 360	SEEDS	12	Hippeastrum papilio x 'Purple Rain'	Tim Eck		\N	\N	\N
BX 360	SEEDS	13	Hippeastrum 'Lima' x 'Grandeur'	Tim Eck		\N	\N	\N
BX 360	SEEDS	14	Hippeastrum 'Jade Dragon'x (papilio x neopardinum)	Tim Eck	Excellent!	\N	\N	\N
BX 360	SEEDS	15	Hippeastrum (puniceum x papilio) x (papilio x mandonii)	Tim Eck		\N	\N	\N
BX 360	SEEDS	16	Hippeastrum 'Giraffe' F2 x 'Purple Rain'	Tim Eck		\N	\N	\N
BX 360	SEEDS	17	Hippeastrum 'Red Garden'	Fred Biasella	(cluster type), selfed	\N	\N	\N
BX 360	SEEDS	18	Hippeastrum 'Bogota'	Fred Biasella	selfed	\N	\N	\N
BX 360	SEEDS	19	Hippeastrum 'Charisma'	Fred Biasella	selfed	\N	\N	\N
BX 360	SEEDS	20	Clivia miniata	Rimmer de Vries	hybrid; small red, OP, from B&O pastel x large Belgian	\N	\N	\N
BX 361	BULBS	1	Ledebouria socialis	Jyl Tuck		\N	\N	\N
BX 361	BULBS	2	Allium cristophii	Jyl Tuck		\N	\N	\N
BX 361	SEEDS	4	Corydalis cava	Larry Neel		\N	\N	\N
BX 361	SEEDS	5	Corydalis intermedia	Larry Neel		\N	\N	\N
BX 361	SEEDS	6	Corydalis ornata	Larry Neel		\N	\N	\N
BX 361	SEEDS	7	Corydalis paczoskii	Larry Neel		\N	\N	\N
BX 361	SEEDS	8	Corydalis solida	Larry Neel	mixed	\N	\N	\N
BX 361	SEEDS	9	Corydalis 'Falls of Nimrodel'	Larry Neel		\N	\N	\N
BX 361	SEEDS	10	Corydalis solida 'Zwanenburg'	Larry Neel		\N	\N	\N
BX 361	SEEDS	11	Corydalis solida 'George Baker'	Larry Neel		\N	\N	\N
BX 361	SEEDS	12	Corydalis tauricola x caucasica	Larry Neel		\N	\N	\N
BX 361	SEEDS	13	Corydalis wendelboi 'Purple King'	Larry Neel		\N	\N	\N
BX 361	SEEDS	14	Haemanthus pauculifolius	Mary Sue Ittner	(few)	\N	\N	Seed
BX 361	BULBS	15	Cyrtanthus mackenii	Mary Sue Ittner	evergreen	\N	e	\N
BX 361	BULBS	16	Oxalis purpurea	Mary Sue Ittner	white	\N	\N	\N
BX 361	BULBS	17	Oxalis purpurea 'Skar'	Mary Sue Ittner		\N	\N	\N
BX 361	BULBS	18	Oxalis hirta	Mary Sue Ittner	mauve	\N	\N	\N
BX 361	BULBS	19	Oxalis melanosticta 'Ken Aslet'	Mary Sue Ittner	fall-blooming	\N	\N	\N
BX 361	BULBS	20	Oxalis flava	Mary Sue Ittner	yellow, fall-blooming	\N	\N	\N
BX 361	BULBS	21	Oxalis engleriana	Mary Sue Ittner	fall-blooming	\N	\N	\N
BX 361	BULBS	22	Oxalis imbricata	Mary Sue Ittner		\N	\N	\N
BX 361	BULBS	23	Oxalis pardalis	Mary Sue Ittner	MV 7632, fall-blooming	\N	\N	\N
BX 361	BULBS	24	Oxalis flava	Mary Sue Ittner	(lupinifolia), fall-blooming	\N	\N	\N
BX 361	BULBS	25	Oxalis polyphylla var. heptaphylla	Mary Sue Ittner	MV 6396, fall-blooming	\N	\N	\N
BX 361	BULBS	26	Oxalis obtusa 'Peaches and Cream'	Mary Sue Ittner		\N	\N	\N
BX 361	BULBS	27	Oxalis obtusa	Mary Sue Ittner	MV 6341	\N	\N	\N
BX 361	BULBS	28	Oxalis purpurea	Mary Sue Ittner	lavender and white	\N	\N	\N
BX 361	BULBS	29	Oxalis obtusa	Mary Sue Ittner		\N	\N	\N
BX 361	BULBS	30	Tulipa linifolia	Mary Sue Ittner		\N	\N	\N
BX 362	BULBS	1	Alocasia hypnosa	Monica Swartz		\N	\N	Bulbs
BX 362	BULBS	2	Oxalis hirta	Nick Plummer		\N	\N	\N
BX 362	BULBS	3	Oxalis namaquana	Nick Plummer	(maybe O. flava)	\N	\N	\N
BX 362	BULBS	5	Oxalis fabifolia	John Wickham		\N	\N	\N
BX 362	BULBS	6	Oxalis cathara	John Wickham		\N	\N	\N
BX 362	BULBS	7	Oxalis sp	John Wickham	?, MV 5117	\N	\N	\N
BX 362	BULBS	8	Oxalis bowiei	John Wickham		\N	\N	\N
BX 362	BULBS	9	Oxalis namaquana	John Wickham		\N	\N	\N
BX 362	BULBS	10	Oxalis glabra	John Wickham		\N	\N	\N
BX 362	BULBS	11	Oxalis polyphylla heptaphylla	John Wickham	(again!, don't worry about it)	\N	\N	\N
BX 362	BULBS	12	Lachenalia aloides var. quadricolor	John Wickham		\N	\N	\N
BX 362	BULBS	13	Lachenalia pallida	John Wickham		\N	\N	\N
BX 362	BULBS	14	Lachenalia pendula	John Wickham	(syn. L. bulbifera)	\N	\N	\N
BX 362	BULBS	15	Gladiolus cunonius	John Wickham		\N	\N	\N
BX 363	SEEDS	1	Clivia hybrid	Rimmer de Vries	F2 from deep red, tulip-form , large Belgian, 2 - 3 inch wide leaves (Seed pods were very red)	\N	\N	\N
BX 363	SEEDS	2	Clivia hybrid	Rimmer de Vries	yellow (Vico yellow x Solomone yellow) open-pollinated (Seed pods were very yellow	\N	\N	\N
BX 363	SEEDS	3	Hippeastrum reticulatum var. striatifolium	Stephen Putman		\N	\N	\N
BX 363	SEEDS	4	Hippeastrum stylosum	Stephen Putman		\N	\N	\N
BX 363	SEEDS	5	Iris versicolor	Dennis Kramb	dark blue with heavy white veining	\N	\N	\N
BX 363	SEEDS	6	Moraea gigantea	Karl Church	OP, ex Telos	\N	\N	\N
BX 363	SEEDS	7	Calochortus weedii	Karl Church	OP	\N	\N	\N
BX 363	SEEDS	8	Moraea setifolia	Karl Church	OP	\N	\N	\N
BX 363	SEEDS	9	Freesia laxa	Karl Church	OP	\N	\N	\N
BX 363	SEEDS	10	Habranthus tubispathus	Karl Church	OP	\N	\N	\N
BX 363	SEEDS	11	Hippeastrum 'Orange Sovereign'	Karl Church	OP	\N	\N	\N
BX 363	SEEDS	12	Hesperocallis undulata	Shawn Pollard		\N	\N	\N
BX 363	SEEDS	13	Bursera fagaroides	Shawn Pollard		\N	\N	\N
BX 363	SEEDS	14	Asclepias albicans	Shawn Pollard		\N	\N	\N
BX 363	SEEDS	15	Canna sp	Shawn Pollard	small yellow flowers, maybe a few red, in great abundance	\N	\N	\N
BX 363	SEEDS	16	Freesia laxa	Marvin Ellenbecker	red and some pure white	\N	\N	\N
BX 363	SEEDS	17	Veltheimia bracteata	Marvin Ellenbecker	usual form	\N	\N	\N
BX 363	SEEDS	18	Veltheimia bracteata	Marvin Ellenbecker	smaller European selection with more yellow in the flowers FEW SEEDS	\N	\N	\N
BX 363	SEEDS	19	Clivia miniata	Marvin Ellenbecker	original plant came from Cecil Houdyshel Nursery, La Verne, CA, in 1957	\N	\N	\N
BX 363	SEEDS	20	Boophane disticha	Kipp McMichael	from pink mother and deep red father	\N	\N	\N
BX 364	BULBS	1	Haemanthus humilis subsp. humilis	Mary Sue Ittner	These are small seedlings grown from seed of Stutterheim form (white). Plant immediately.;	http://www.pacificbulbsociety.org/pbswiki/index.php/Haemanthus_humilis	\N	\N
BX 364	BULBS	2	Oxalis asinina	Mary Sue Ittner		\N	\N	\N
BX 364	BULBS	3	Oxalis bowiei	Mary Sue Ittner		\N	\N	\N
BX 364	BULBS	4	Oxalis callosa	Mary Sue Ittner		\N	\N	\N
BX 364	BULBS	5	Oxalis caprina	Mary Sue Ittner		\N	\N	\N
BX 364	BULBS	6	Oxalis commutata	Mary Sue Ittner		\N	\N	\N
BX 364	BULBS	7	Oxalis compressa	Mary Sue Ittner	(double flowers)	\N	\N	\N
BX 364	BULBS	8	Oxalis depressa	Mary Sue Ittner	MV 4871	\N	\N	\N
BX 364	BULBS	9	Oxalis flava	Mary Sue Ittner	(received as pink & mostly pink, occasionally a yellow one shows up)	\N	\N	\N
BX 364	BULBS	10	Oxalis hirta	Mary Sue Ittner		\N	\N	\N
BX 364	BULBS	11	Oxalis hirta 'Gothenburg'	Mary Sue Ittner	produces giant bulbs and you only need a couple for a pot and it doesn't increase much. Very very limited supply	\N	\N	\N
BX 364	BULBS	12	Oxalis luteola	Mary Sue Ittner	MV 5567	\N	\N	\N
BX 364	BULBS	13	Oxalis sp	Mary Sue Ittner	. MV 4674 (perhaps O. commutata?)	\N	\N	\N
BX 364	BULBS	14	Oxalis obtusa	Mary Sue Ittner	coral	\N	\N	\N
BX 364	BULBS	15	Oxalis obtusa	Mary Sue Ittner	MV 5005a	\N	\N	\N
BX 364	BULBS	16	Oxalis obtusa	Mary Sue Ittner	MV 5051	\N	\N	\N
BX 364	BULBS	17	Oxalis obtusa	Mary Sue Ittner	MV6235	\N	\N	\N
BX 364	BULBS	18	Oxalis obtusa	Mary Sue Ittner	MV 7085	\N	\N	\N
BX 364	BULBS	19	Oxalis obtusa	Mary Sue Ittner	(peach) - looks like MV 5005a	\N	\N	\N
BX 364	BULBS	20	Oxalis palmifrons	Mary Sue Ittner		\N	\N	\N
BX 364	BULBS	21	Oxalis versicolor	Mary Sue Ittner		\N	\N	\N
BX 364	BULBS	22	Tulipa batalinii	Mary Sue Ittner	(small bulbs)	\N	\N	\N
BX 364	BULBS	23	Tulipa 'Red Cup'	Mary Sue Ittner	(small bulbs) - This was purchased as Tulipa humilis 'Red Cup', but I'm suspicious about the name. I've found online pictures of Tulipa hageri 'Red Cup' that look like it. I'd love to know what to call it on the wiki. It's very pretty anyway.;	http://www.pacificbulbsociety.org/pbswiki/index.php/TulipaSpeciesTwo#humilis	\N	\N
BX 364	BULBS	24	Erythronium americanum	Roy Herold		\N	\N	\N
BX 364	BULBS	25	Ledebouria 'Pauciflora'	Jim Waddick		\N	\N	\N
BX 365	SEEDS	1	Pamianthe peruviana	Paul Matthews		\N	\N	\N
BX 365	SEEDS	2	Veltheimia bracteata	Ray Talley		\N	\N	\N
BX 365	SEEDS	3	Helocodiceros musciveros	Jim Waddick	Dead Horse Arum. Inflorescence is quite stinky. Gorgeous foliage. Hardy in Kansas City grown HOT, Dry and good drainage.	\N	\N	\N
BX 365	SEEDS	4	Cyclamen hederifolium	Kathleen Sayce	fresh from the pods, cleaned in a little clean sand. This population has wide color variations, dark pink to white, and foliage silvering also varies from nearly all green to very silver.	\N	\N	\N
BX 365	SEEDS	5	Erythronium revolutum	Kathleen Sayce		\N	\N	\N
BX 365	SEEDS	6	Zephyranthes drummondii	Rodney Barton	syn. Cooperia pedunculata	\N	\N	\N
BX 365	SEEDS	7	Zephyranthes flavissima	Nick Plummer		\N	\N	\N
BX 365	SEEDS	8	Aquilegia Canadensis	Nick Plummer	good companion for spring flowering bulbs	\N	\N	\N
BX 365	SEEDS	9	Habranthus robustus	Nick Plummer	x self, pale flowers, wide petals and sepals	\N	\N	\N
BX 365	SEEDS	10	Crinum bulbispermum	Jim Waddick	Jumbo strain	\N	\N	\N
BX 366	BULBS	1	Albuca acuminata	Roy Herold	Plettenberg Bay small offsets	\N	\N	\N
BX 366	BULBS	2	Albuca sp	Roy Herold	. Silverhill 14088, small seedlings	\N	\N	\N
BX 366	BULBS	3	Ambrosina bassii	Roy Herold		\N	\N	\N
BX 366	BULBS	4	Daubenya marginata	Roy Herold	Fransplaas MX21, small seedlings	\N	\N	\N
BX 366	BULBS	5	Daubenya stylosa	Roy Herold	MX20, small seedlings	\N	\N	\N
BX 366	BULBS	6	Lachenalia pusilla	Roy Herold	ex Hannon, small seedlings	\N	\N	\N
BX 366	SEEDS	7	Massonia depressa	Roy Herold	Carolusberg Mine M49. The following Massonias are from my 2011 seed collections in South Africa. These are one to two years old seedlings, some very small, and in very limited quantities.	\N	\N	\N
BX 366	SEEDS	8	Massonia depressa	Roy Herold	Kamieskroon Church M57. The following Massonias are from my 2011 seed collections in South Africa. These are one to two years old seedlings, some very small, and in very limited quantities.	\N	\N	\N
BX 366	SEEDS	9	Massonia depressa	Roy Herold	large Modderfontein M51. The following Massonias are from my 2011 seed collections in South Africa. These are one to two years old seedlings, some very small, and in very limited quantities.	\N	\N	\N
BX 366	SEEDS	10	Massonia depressa	Roy Herold	near Kamieskroon Hotel M56. The following Massonias are from my 2011 seed collections in South Africa. These are one to two years old seedlings, some very small, and in very limited quantities.	\N	\N	\N
BX 366	SEEDS	11	Massonia depressa	Roy Herold	Nieuwoudtville waterfall, reddest M48. The following Massonias are from my 2011 seed collections in South Africa. These are one to two years old seedlings, some very small, and in very limited quantities.	\N	\N	\N
BX 366	SEEDS	12	Massonia depressa	Roy Herold	small Modderfontein M53. The following Massonias are from my 2011 seed collections in South Africa. These are one to two years old seedlings, some very small, and in very limited quantities.	\N	\N	\N
BX 366	SEEDS	13	Massonia pygmaea	Roy Herold	5km S Elands Bay M59. The following Massonias are from my 2011 seed collections in South Africa. These are one to two years old seedlings, some very small, and in very limited quantities.	\N	\N	\N
BX 366	SEEDS	14	Massonia pygmaea	Roy Herold	Modderfontein renosterveld M54. The following Massonias are from my 2011 seed collections in South Africa. These are one to two years old seedlings, some very small, and in very limited quantities.	\N	\N	\N
BX 366	SEEDS	15	Massonia pygmaea	Roy Herold	Modderfontein wet pasture M55. The following Massonias are from my 2011 seed collections in South Africa. These are one to two years old seedlings, some very small, and in very limited quantities.	\N	\N	\N
BX 366	SEEDS	16	Massonia echinata	Roy Herold	Napier ex McMaster. These Massonias are also small seedlings.	\N	\N	\N
BX 366	SEEDS	17	Massonia hirsuta	Roy Herold	MG2712. These Massonias are also small seedlings.	\N	\N	\N
BX 366	SEEDS	18	Massonia jasminiflora	Roy Herold	Modder River. These Massonias are also small seedlings.	\N	\N	\N
BX 366	SEEDS	19	Massonia jasminiflora	Roy Herold	Smithfield. These Massonias are also small seedlings.	\N	\N	\N
BX 366	SEEDS	20	Massonia pustulata	Roy Herold	very pustulate parents M41 ex Cumbleton. These Massonias are also small seedlings.	\N	\N	\N
BX 366	SEEDS	21	Oxalis bowiei	Roy Herold		\N	\N	\N
BX 366	SEEDS	22	Oxalis luteola	Roy Herold	MV5567	\N	\N	\N
BX 366	SEEDS	23	Oxalis melanosticta 'Ken Aslet'	Roy Herold		\N	\N	\N
BX 366	SEEDS	24	Oxalis obtusa 'Heirloom Pink'	Roy Herold	best bloomer	\N	\N	\N
BX 366	SEEDS	25	Oxalis palmifrons	Roy Herold		\N	\N	\N
BX 366	SEEDS	26	Oxalis 'perdicaria var malacoides'	Roy Herold	ex BX183-13	\N	\N	\N
BX 366	SEEDS	27	Oxalis 'polyphylla heptaphylla'	Roy Herold		\N	\N	\N
BX 366	SEEDS	28	Oxalis sp	Roy Herold	. Uli69	\N	\N	\N
BX 366	SEEDS	29	Oxalis sp	Roy Herold	. Sutherland ex Hannon, like Ken Aslet with larger flowers	\N	\N	\N
BX 366	SEEDS	30	Polyxena ensifolia	Roy Herold	blooming size. Polyxenas are small seedlings unless noted. [NOTE: most Polyxenas are currently considered to be Lachenalias]	\N	\N	\N
BX 366	SEEDS	31	Polyxena longituba	Roy Herold	Polyxenas are small seedlings unless noted. [NOTE: most Polyxenas are currently considered to be Lachenalias]	\N	\N	\N
BX 369	BULBS	1	Brodiaea pallida	Mary Sue Ittner		\N	\N	\N
BX 366	SEEDS	32	Polyxena maughanii	Roy Herold	Silverhill. Polyxenas are small seedlings unless noted. [NOTE: most Polyxenas are currently considered to be Lachenalias]	\N	\N	\N
BX 366	SEEDS	33	Polyxena odorata	Roy Herold	(Lachenalia ensifolia) Polyxenas are small seedlings unless noted. [NOTE: most Polyxenas are currently considered to be Lachenalias]	\N	\N	\N
BX 366	SEEDS	34	Polyxena sp	Roy Herold	. Silverhill 4748. Polyxenas are small seedlings unless noted. [NOTE: most Polyxenas are currently considered to be Lachenalias]	\N	\N	\N
BX 367	BULBS	1	Narcissus albidus occidentalis	Roy Herold	N028 Narcissus are mostly blooming size. N numbers are Roy's own.	\N	\N	\N
BX 367	BULBS	2	Narcissus assoanus	Roy Herold	ex Spain N079 Narcissus are mostly blooming size. N numbers are Roy's own.	\N	\N	\N
BX 367	BULBS	3	Narcissus 'Atlas Gold'	Roy Herold	JCA805Y Narcissus are mostly blooming size. N numbers are Roy's own.	\N	\N	\N
BX 367	BULBS	4	Narcissus bulbocodium	Roy Herold	hybrid N051 Narcissus are mostly blooming size. N numbers are Roy's own.	\N	\N	\N
BX 367	BULBS	5	Narcissus bulbocodium	Roy Herold	N020 Narcissus are mostly blooming size. N numbers are Roy's own.	\N	\N	\N
BX 367	BULBS	6	Narcissus bulbocodium	Roy Herold	N052 Narcissus are mostly blooming size. N numbers are Roy's own.	\N	\N	\N
BX 367	BULBS	7	Narcissus bulbocodium obesus	Roy Herold	N024 Narcissus are mostly blooming size. N numbers are Roy's own.	\N	\N	\N
BX 367	BULBS	8	Narcissus bulbocodium obesus	Roy Herold	N027A Narcissus are mostly blooming size. N numbers are Roy's own.	\N	\N	\N
BX 367	BULBS	9	Narcissus bulbocodium var. praecox	Roy Herold	N076 Narcissus are mostly blooming size. N numbers are Roy's own.	\N	\N	\N
BX 367	BULBS	10	Narcissus bulbocodium ssp romieuxii	Roy Herold	N013 Narcissus are mostly blooming size. N numbers are Roy's own.	\N	\N	\N
BX 367	BULBS	11	Narcissus bulbocodium tenuifolius	Roy Herold	N022 Narcissus are mostly blooming size. N numbers are Roy's own.	\N	\N	\N
BX 367	BULBS	12	Narcissus 'Joy Bishop'	Roy Herold	N068 Narcissus are mostly blooming size. N numbers are Roy's own.	\N	\N	\N
BX 367	BULBS	13	Narcissus 'Julia Jane'	Roy Herold	N105 ex Odyssey, different from N106 Narcissus are mostly blooming size. N numbers are Roy's own.	\N	\N	\N
BX 367	BULBS	14	Narcissus 'Julia Jane'	Roy Herold	N106 ex McGary, different from N105 Narcissus are mostly blooming size. N numbers are Roy's own.	\N	\N	\N
BX 367	BULBS	15	Narcissus	Roy Herold	Mixed Seedlings These date back to a mass sowing in 2004 of seed from moderately controlled crosses of romieuxii, cantabricus, albidus, zaianicus, and similar early blooming sorts of the bulbocodium group. Colors tend to be light yellow through cream to white, and flowers are large, much larger than the little gold colored bulbocodiums of spring. These have been selected three times, and the keepers are choice. Similar to my 2012 PBS offering.	\N	\N	\N
BX 367	BULBS	16	Narcissus 'Nylon'	Roy Herold	Narcissus are mostly blooming size. N numbers are Roy's own.	\N	\N	\N
BX 367	BULBS	17	Narcissus romieuxii albidus tananicus	Roy Herold	N002 Narcissus are mostly blooming size. N numbers are Roy's own.	\N	\N	\N
BX 367	BULBS	18	Narcissus 'Treble Chance'	Roy Herold	JCA805 N066 Narcissus are mostly blooming size. N numbers are Roy's own.	\N	\N	\N
BX 367	BULBS	19	Narcissus zaianicus lutescens x cantabricus	Roy Herold	N037 Narcissus are mostly blooming size. N numbers are Roy's own.	\N	\N	\N
BX 367	BULBS	20	Oxalis engleriana	Roy Herold		\N	\N	\N
BX 367	BULBS	21	Lachenalia pallida	Roy Herold	ex BX 297	\N	\N	\N
BX 367	BULBS	22	Ledebouria socials cv 'violacea'	Jim Waddick	Received years ago under this name, but now known as simply L. socialis. Easy succulent bulb. Plant bulbs with base barely below soil level. Tender in Kansas City . Zone 8? 9?10?	\N	\N	\N
BX 367	BULBS	23	Babiana 'Blue Gem'	John Wickham		\N	\N	\N
BX 367	BULBS	24	Babiana 'Brilliant Blue'	John Wickham		\N	\N	\N
BX 367	BULBS	25	Babiana 'Deep Dreams'	John Wickham		\N	\N	\N
BX 367	BULBS	26	Babiana 'Mighty Magenta'	John Wickham		\N	\N	\N
BX 367	BULBS	27	Babiana 'Purple Haze'	John Wickham		\N	\N	\N
BX 367	BULBS	28	Babiana rubrocyanea	John Wickham		\N	\N	\N
BX 367	BULBS	29	Babiana stricta	John Wickham		\N	\N	\N
BX 368	BULBS	2	Ferraria crispa	John Wickham	(mixed forms)	\N	\N	\N
BX 368	BULBS	7	Freesia grandiflora	John Wickham		\N	\N	\N
BX 368	BULBS	8	Freesia leichtlinii	John Wickham		\N	\N	\N
BX 368	BULBS	9	Gladiolus carmineus	John Wickham		\N	\N	\N
BX 368	BULBS	10	Gladiolus splendens	John Wickham		\N	\N	\N
BX 368	BULBS	11	Gladiolus virescens	John Wickham		\N	\N	\N
BX 368	BULBS	12	Homoglad hybrids	John Wickham	(ex Annies Annuals)	\N	\N	\N
BX 368	BULBS	13	Lachenalia contaminata	John Wickham		\N	\N	\N
BX 368	BULBS	14	Narcissus	John Wickham	odoratus	\N	\N	\N
BX 368	BULBS	15	Oxalis flava	John Wickham	yellow	\N	\N	\N
BX 368	BULBS	16	Narcissus 'Polly's Tazettas'	John Wickham		\N	\N	\N
BX 368	BULBS	17	Tritonia 'Rosy Picture'	John Wickham		\N	\N	\N
BX 368	BULBS	18	Tritonia 'Salmon Run'	John Wickham		\N	\N	\N
BX 368	BULBS	19	Tritonia hyalina	John Wickham	(crocata?)	\N	\N	\N
BX 368	BULBS	20	Watsonia aletroides	John Wickham		\N	\N	\N
BX 368	BULBS	21	Albuca clanwilliamae-gloria	Pamela Slate		\N	\N	\N
BX 368	BULBS	22	Ferraria crispa	Pamela Slate	yellow form	\N	\N	\N
BX 368	BULBS	23	Ferraria crispa subsp. nortierii	Pamela Slate		\N	\N	\N
BX 368	BULBS	24	Ferraria crispa	Pamela Slate	usual form	\N	\N	\N
BX 368	BULBS	25	Watsonia 'Flamboyant'	Pamela Slate	stunning deep coral; need support	\N	\N	\N
BX 368	BULBS	26	Lachenalia mixed	Nhu Nguyen		\N	\N	\N
BX 368	BULBS	27	Habranthus martinezii	Jim Waddick		\N	\N	\N
BX 368	BULBS	28	Crinum 'Menehune'	Jim Waddick	a tropical cultivar said to originate from Hawaii. Zone 8 or warmer. AKA Crinum 'Purple Passion'. Has very dark purple foliage. Small grower suited to pot culture.	\N	\N	\N
BX 368	BULBS	1	Cyanella orchidiformis	John Wickham	\N	\N	\N	\N
BX 368	BULBS	3	Ferraria densipunctulata	John Wickham	\N	\N	\N	\N
BX 368	BULBS	4	Ferraria uncinata	John Wickham	\N	\N	\N	\N
BX 368	BULBS	5	Freesia alba	John Wickham	\N	\N	\N	\N
BX 368	BULBS	6	Freesia fucata	John Wickham	\N	\N	\N	\N
BX 369	BULBS	2	Calochortus argillosus	Mary Sue Ittner	- bulblets	\N	\N	\N
BX 369	BULBS	3	Dichelostemma capitatum	Mary Sue Ittner	- cormlets grown from Channel Islands seed	\N	\N	\N
BX 369	BULBS	4	Narcissus 'Stocken'	Mary Sue Ittner		\N	\N	\N
BX 369	BULBS	5	Nothoscordum dialystemon	Mary Sue Ittner	(Ipheion dialystemon)	\N	\N	\N
BX 369	BULBS	6	Oxalis flava	Mary Sue Ittner	(lupinifolia)	\N	\N	\N
BX 369	BULBS	7	Oxalis luteola	Mary Sue Ittner	MV5567	\N	\N	\N
BX 369	BULBS	8	Oxalis obtusa	Mary Sue Ittner	(not sure of color)	\N	\N	\N
BX 369	BULBS	9	Oxalis obtusa	Mary Sue Ittner	(yellow I think)	\N	\N	\N
BX 369	BULBS	10	Spiloxene capensis	Mary Sue Ittner	(pink I think)	\N	\N	\N
BX 369	BULBS	11	Spiloxene capensis	Mary Sue Ittner	(white I think )	\N	\N	\N
BX 369	BULBS	12	Tristagma uniflorum	Mary Sue Ittner	(Ipheion uniflorum) white	\N	\N	\N
BX 369	BULBS	13	Tropaeolum tricolor	Mary Sue Ittner		\N	\N	\N
BX 369	BULBS	14	Cyrtanthus labiatus	Roy Herold	ex BX 234	\N	\N	\N
BX 369	BULBS	15	Cyclamen africanum	Roy Herold	silver center	\N	\N	\N
BX 369	BULBS	16	Ornithogalum schmalhausenii	Roy Herold	ex Ruksans (VERY FEW)	\N	\N	\N
BX 369	BULBS	17	Ornothogalum sp	Roy Herold	., short, ex McGary (FEW)	\N	\N	\N
BX 369	BULBS	18	Oxalis caprina	Fred Thorne	ex BX 318	\N	\N	\N
BX 369	BULBS	19	Oxalis imbricata	Fred Thorne	ex BX 318	\N	\N	\N
BX 369	BULBS	20	Oxalis namaquana	Fred Thorne	ex BX 318	\N	\N	\N
BX 369	BULBS	21	Hippeastrum psittacinum	Nick Plummer	(FEW)	\N	\N	\N
BX 369	BULBS	22	Hippeastrum aulicum	Nick Plummer	(FEW)	\N	\N	\N
BX 369	BULBS	23	Hippeastrum glaucescens	Nick Plummer	(FEW)	\N	\N	\N
BX 370	SEEDS	1	Amorphophallus konjac	Nick Plummer		\N	\N	\N
BX 370	SEEDS	2	Hymenocallis astrostephana	Nick Plummer		\N	\N	\N
BX 370	SEEDS	3	Brunsvigia josephiniae	Kipp McMichael	. A very deep red form - the mother bulb was selfed to produce seeds on 2(!) bloom stems this season.	\N	\N	\N
BX 370	BULBS	4	Amaryllis belladonna	Tom Glavich from the collection of the late Charles Hardman	light pink with darker veins, small bulbs	\N	\N	\N
BX 370	BULBS	5	Cyclamen graecum	Tom Glavich from the collection of the late Charles Hardman	good sized tubers	\N	\N	\N
BX 370	BULBS	6	Haemanthus humilis subsp. hirsutus	Tom Glavich from the collection of the late Charles Hardman	small bulbs	\N	\N	\N
BX 370	BULBS	7	Ferraria sp	Tom Glavich from the collection of the late Charles Hardman	. ex Michael Vassar 55 km north of Port Nolloti? in pure white sand in full sun, sand dune near ocean; 60 cm long lvs; corms grow very deep. small corms	\N	\N	\N
BX 370	BULBS	8	Allium coryi	Tom Glavich from the collection of the late Charles Hardman	small bulbs	\N	\N	\N
BX 370	BULBS	9	Muscari armeniacum	Tom Glavich from the collection of the late Charles Hardman		\N	\N	\N
BX 370	BULBS	10	Crocus tournefortii	Jane McGary		\N	\N	\N
BX 370	BULBS	11	Oxalis compressa	Lynn Makela	double	\N	\N	\N
BX 370	BULBS	12	Oxalis melanosticta	Lynn Makela		\N	\N	\N
BX 370	BULBS	13	Oxalis namaquana	Lynn Makela		\N	\N	\N
BX 370	BULBS	14	Oxalis purpurea	Lynn Makela	white	\N	\N	\N
BX 370	BULBS	15	Oxalis purpurea 'Garnet'	Lynn Makela		\N	\N	\N
BX 370	BULBS	16	Oxalis purpurea	Lynn Makela	deep rose	\N	\N	\N
BX 370	BULBS	17	Oxalis purpurea	Lynn Makela	salmon	\N	\N	\N
BX 370	BULBS	18	Oxalis purpurea	Lynn Makela	yellow	\N	\N	\N
BX 370	BULBS	19	Oxalis stenorrhyncha	Lynn Makela		\N	\N	\N
BX 370	BULBS	20	Lachenalia mathewsii	Pamela Slate		\N	\N	\N
BX 370	BULBS	21	Lachenalia viridiflora	Pamela Slate	ex Hammer	\N	\N	\N
BX 370	BULBS	22	Lachenalia orchioides var. glaucina	Pamela Slate		\N	\N	\N
BX 370	BULBS	23	Lachenalia kliprandensis	Pamela Slate		\N	\N	\N
BX 370	BULBS	24	Lachenalia algoensis	Pamela Slate	ex Mark Mazer	\N	\N	\N
BX 370	BULBS	25	Lachenalia mutabilis	Pamela Slate	ex M. Swartz, BX 273	\N	\N	\N
BX 370	BULBS	26	Lachenalia quadricolor	Pamela Slate		\N	\N	\N
BX 370	BULBS	27	Lachenalia juncifolia	Pamela Slate	ex Mazer	\N	\N	\N
BX 371	BULBS	1	Lachenalia rubida	Fred Throne		\N	\N	Small bulbs
BX 371	BULBS	2	Fritillaria uva-vulpis	Fred Throne		\N	\N	Offsets
BX 371	BULBS	3	Arum palaestinum	Arnold Trachtenberg	(few)	\N	\N	Tubers
BX 371	BULBS	4	Freesia 'Red River'	Judy Glattstein	red	\N	\N	Small corms
BX 371	BULBS	5	Freesia 'Port Salut'	Judy Glattstein	yellow	\N	\N	Small corms
BX 371	BULBS	6	Freesia 'Ambiance'	Judy Glattstein	white	\N	\N	Small corms
BX 371	BULBS	7	Blooming size	Mary Sue Ittner	corms of Watsonia aletroides, 'my most dependably blooming watsonia'	\N	\N	corms
BX 371	BULBS	8	Geissorhiza imbricata	Mary Sue Ittner		\N	\N	Cormlets
BX 371	BULBS	9	Geissorhiza? or Hesperantha?	Mary Sue Ittner	\N	\N	\N	Small corms
BX 371	BULBS	10	Lachenalia quadricolor	Mary Sue Ittner		\N	\N	Small bulbs
BX 371	BULBS	11	Oxalis namaquana	Mary Sue Ittner		\N	\N	Small bulbs
BX 371	BULBS	12	Oxalis glabra	Mary Sue Ittner		\N	\N	Small bulbs
BX 371	BULBS	13	Arisaema triphyllum	Jyl Tuck	dark burgundy inflorescence, red veining on leaves	\N	\N	Small tubers
BX 371	SEEDS	14	Arisaema triphyllum	Jyl Tuck	dark burgundy inflorescence, red veining on leaves	\N	\N	Seeds
BX 371	SEEDS	15	Arisaema amurense	Jyl Tuck		\N	\N	Seed
BX 371	BULBS	16	Albuca shawii	Jyl Tuck	(A. tenuifolia), 'This albuca shawii with green tuff on inflorescence is what I sent in bulbs and seeds instead of my plain seed raised one. I just think its nicer ----- even though I don't know why it is this way and no one could help me at the PBS.'	\N	\N	Small bulbs
BX 371	BULBS	17	Gladiolus uysiae	Terry Laskiewicz		\N	\N	Small bulbs
BX 371	BULBS	18	Fritillaria affinis 'Wayne Roderick'	Terry Laskiewicz		\N	\N	Small bulbs
BX 371	BULBS	19	Fritillaria striata	Terry Laskiewicz		\N	\N	Small bulbs
BX 371	BULBS	20	Arum dioscoridis	Chris Elwell	(Very Few)	\N	\N	Tubers
BX 371	BULBS	21	Arum concinnatum	Chris Elwell	few	\N	\N	Tubers
BX 371	BULBS	22	Acis valentina	Chris Elwell	(Very Few)	\N	\N	Bulb
BX 371	BULBS	23	Calochortus uniflorus	Chris Elwell		\N	\N	Bulblets
BX 371	BULBS	24	Calochortus luteus	Chris Elwell		\N	\N	Bulblets
BX 371	SEEDS	25	Clivia 'Moondrops' 	Arnold Trachtenberg	Clivia 'Moondrops' F2 Gardenii.2014 x Yellow miniata	\N	\N	Seeds
BX 372	BULBS	1	Gladiolus tristis	Monica Swartz	ex bx 219	\N	\N	Bulbs
BX 372	BULBS	2	Moraea tripetala	Monica Swartz	ex Telos Rare Bulbs	\N	\N	Bulbs
BX 372	SEEDS	3	Brunsvigia bosmaniae	Monica Swartz	from Telos bulbs	\N	\N	Seed
BX 372	BULBS	4	Lachenalia unifolia	Monica Swartz	ex Telos Rare Bulbs	\N	\N	Bulbs
BX 372	BULBS	5	Lachenalia mutabilis	Monica Swartz	electric blue form ex bx 181	\N	\N	Bulbs
BX 372	BULBS	6	Albuca aff. flaccida	Monica Swartz	from a volunteer from Arid Lands	\N	\N	Bulbs
BX 372	BULBS	7	Albuca sp	Monica Swartz	. Plettenberg Bay ex BX 178 ex Roy Herold who wrote the following: 'from seed collected in November, 2006 from a plant growing in pure sand at the edge of the beach, perhaps 50 meters from the high waterline. This plant had gone dormant, and only the scape and seed pods remained, approximately 20-30cm high. Seedlings grew strongly through last summer and winter, and went dormant in May, stretching to go deeply into the pot.'	\N	\N	Bulbs
BX 372	BULBS	8	Alocasia x amazonica	Monica Swartz	an easy and common house plant (A. x mortfontanensis)?	\N	\N	Tubers
BX 372	BULBS	9	Ferraria sp	Mary Sue Ittner	? Corms	\N	\N	Corms
BX 372	BULBS	10	Oxalis obtusa	Rimmer de Vries	pink	\N	\N	Small bulbs
BX 372	BULBS	11	Eucharis sp	Rimmer de Vries	? , only one bulb	\N	\N	\N
BX 372	BULBS	12	Pancratium zeylanicum	Rimmer de Vries	only one bulb	\N	\N	\N
BX 372	BULBS	13	Arisaema amurense	Jyl Tuck		\N	\N	Small tubers
BX 372	BULBS	14	Lilium lancifolium	Francisco Lopez		\N	\N	Bulbils
BX 372	BULBS	15	Allium roseum	Francisco Lopez		\N	\N	Small bulbs
BX 372	BULBS	16	Ornithogalum caudatum	Francisco Lopez	(Albuca bracteata?) (Lonocornelos caudatum?)	\N	\N	Small bulbs
BX 372	BULBS	17	Watsonia sp	Francisco Lopez	?	\N	\N	Small corms
BX 372	BULBS	18	Clinanthus incarnatus	Giovanni Curci	yellow form (VERY FEW)	\N	\N	Small bulbs
BX 372	BULBS	19	Phaedranassa viridiflora	Giovanni Curci		\N	\N	Small bulbs
BX 372	SEEDS	20	Lycoris chinensis	Jim Waddick	These seed are from fairly isolated parents with this name, but it hybridizes readily with other fertile species. Expect flowers that are yellow to gold in color, somewhat 'spidery' in form and around 30 in tall. These are both Spring foliage species NOT suited to Mediterranean or South eastern climates. Do best north of zone 7 into Zone 4 and 5. NOT recommended for Southern CA. Plant seeds immediately on receipt as they do not have a long shelf life. They do poorly in pots for long term and rarely bloom in pots.	\N	\N	\N
BX 372	SEEDS	21	Lycoris hybrids	Jim Waddick	These are a mix of L. chinensis and L. longituba. Flowers will be smooth or spidery, from white to gold and may have some pink tints. Easy and hardy in Zone 5/6. These are both Spring foliage species NOT suited to Mediterranean or South eastern climates. Do best north of zone 7 into Zone 4 and 5. NOT recommended for Southern CA. Plant seeds immediately on receipt as they do not have a long shelf life. They do poorly in pots for long term and rarely bloom in pots.	\N	\N	\N
BX 373	BULBS	1	Cyrtanthus hybrid	Arnold Trachtenberg	orange-scarlet trumpets.	\N	\N	Bulbs
BX 373	SEEDS	2	Clivia 'Solomone light orange x yellow'	Dell Sherk	selfed	\N	\N	Seeds
BX 373	BULBS	3	Tulipa sylvestris	Rimmer de Vries		\N	\N	Small bulbs
BX 373	BULBS	4	Nymphaea sp.	Uli Urban	??, purple/blue, tuberous. I am very pleased to be able to share these tubers this year. I got this plant under the name of N. daubenyana which it is definetely not. The closest I came when I compared pictues on the web is the Hybrid 'Tina' . A magnificent aquatic with large very fragrant purple-blue flowers with yellow center that last several days and which are held above the water surface. In summer it needs as warm water as possible, mine is growing in a free standing tank of black plastic which is warmed up by the sun. No artificial heating. Fertilized with Osmocote which does not trouble the water. It should perform very well in warm summer climates in the US. It is viviparous which means that it can form young plants on the leaves. This is stimulated by cool temperatures and as we had an exceptionally long and mild autumn I could harvest a lot of small tubers that formed on the leaves where the stalk is attached. Some of these had sprouted and formed small leaves and roots. These small tubers should be kept slighty moist in sphagnum or peat or the like, I treated them with a fungicide to prevent rot. In spring they should be started in warm water in an aquarium with extra light and planted out into their summer basin once the water is warm enough. I start mine in May at 25°C in small pots and plant them into a large pot in the tank in June. In warmer climes this can be done earlier. The adult tubers reach about nut-size. After the first frost (I had flowers poking through a thin layer of ice, frozen of course) I remove the pot from the tank, cut off all the leaves at about 15cm from the base, give a GOOD spray of fungicide and dry down the pot slowly. I remove all remains of leaf stalks as they die down. Before it is totally dry it is wrapped into a plastic bag and stored at about 12°C until May. I had some losses if the pot gets too dry or if mildew attacks while still very wet. I have never had leaf tubers in autumn so this is an experiment for me, too. I keep some of the sprouted tubers in unheated water in the cold greenhouse, they look o.k. so far.	\N	\N	\N
BX 373	BULBS	5	Begonia martiana var gracilis	Uli Urban	(syn. B. gracilis), the 'hollyhock begonia' The material supplied is not seed but small bulbili which are produced en masse at the end of the growing period. These should be 'sown' immediately on receipt and kept just barely moist. Begonia martiana sprouts fairly late at the end of May. If kept totally dry these bulbili may dessicate and die. A very rewarding beautiful plant. But needs some patience if grown from these bulbili.	\N	\N	\N
BX 373	SEEDS	6	Nerine bowdenii	Uli Urban	(?) Type Human. originally from wild seed sent by David Human. This is a VERY hardy plant with large bulbs and a large inflorescence with fairly small very frilled pink flowers. Different from ordinary N. bowdenii. Knowlegable people commented that this may not be N. bowdenii but a different species. It takes a while to raise a flowering plant from seed but is very much worth the patience. Has survived the coldest winter with a good mulch and overhead protection from winter wet. Seed needs immediate sowing as it already starts to sprout.	\N	\N	Seed
BX 377	BULBS	5	(Hippeastrum papilio x H. mandonii) x H. 'Evergreen'	Tim Eck	Seedling bulbs of Hippeastrum crosses. All are close to 1 cm dia.	\N	\N	\N
BX 377	BULBS	6	Hippeastrum correiense x H. papilio	Tim Eck	{this papilio has excellent flower quality} Seedling bulbs of Hippeastrum crosses. All are close to 1 cm  dia.	\N	\N	\N
BX 377	BULBS	7	Hippeastrum 'Jade Dragon' x (H. neopardinum x H. papilio)	Tim Eck	Jade Dragon' x (H. neopardinum x H. papilio) {'Jade Dragon' = H. cybister x H. papilio, F2} Seedling bulbs of Hippeastrum crosses. All are close to 1 cm  dia.	\N	\N	\N
BX 386	BULBS	11	Oxalis compressa	Mary Sue Ittner	double	\N	\N	Bulbs
BX 373	SEEDS	7	Nerine bowdenii	Uli Urban	Type Oswald. The origin of this form cannot be traced. I got very good bulbs from Mr Oswald from former East Germany where it was grown for a long time. East Germany was fairly isolated from the West during communist times but had an active gardening tradition. Many breeding programmes emphasized hardiness with the (political) aim to be independent and self sufficient. He grew these bulbs amongst the beans and strawberries in rows in his vegetable garden and gave it a very thick winter mulch made of compost and stable manure. A very good plant, hardy in almost all winters with a good mulch and overhead protection against winter wet. Typical bright pink Nerine bowdenii flowers. Needs immediate sowing.	\N	\N	Seed
BX 374	BULBS	1	Albuca shawii	Joyce Miller	(A. tenuifolia) Small bulbs	\N	\N	\N
BX 374	BULBS	2	Drimiopsis kirkii	Joyce Miller	? (D. botryoides) Small bulbs	\N	\N	\N
BX 374	BULBS	3	Sinninigia sellovii	Joyce Miller	Various sized tubers	\N	\N	\N
BX 374	BULBS	4	Eucrosia bicolor	Joyce Miller	Various sized bulbs	\N	\N	\N
BX 374	BULBS	5	Lachenalia quadricolor	Joyce Miller	(L. aloides quadricolor). Small bulbs	\N	\N	\N
BX 374	BULBS	6	Camassia sp	Joyce Miller	? Various sized bulbs	\N	\N	\N
BX 374	SEEDS	7	Scadoxus sp	Uli Urban	? My Scadoxus plant came from a plant sale in a Botanical Garden in Germany where they had an old plant of amazing size in a very large tub, this plant was full of spent flowers and must have looked magnificent when it was in flower. Unfortunately there was no name on the plant. They said the seedlings they were selling came from this plant. It flowered for the very first time last year, I handpollinated the flowers and got a handful of berries. It could be the old Hybrid 'King Albert'	\N	\N	Seeds
BX 375	BULBS	1	Eucharis amazonica	Rimmer De Vries	- as stated in prior BXs these are presumed to carry a virus load but they bloom nicely-see photos;	https://www.flickr.com/photos/32952654@N06/sets/72157651609454716/	\N	\N
BX 375	BULBS	2	Othonna aff. perfoliata	Rimmer De Vries	ex Mike Vassar 7454, Simonsviel- (ex BX 353 as Othonna Sp? white) these have large fleshy leaves with purple backs and small yellow florets without ray petals, (ex BX 353 as Othonna Sp? white) these do very well if occasionally watered well while in growth in fall- winter see photos;	https://www.flickr.com/photos/32952654@N06/sets/72157651257523029/	\N	\N
BX 375	BULBS	3	Massonia echinata	Rimmer De Vries	ex NARGS 2012/13 #1684;	https://www.flickr.com/photos/32952654@N06/sets/72157649341793814/	\N	\N
BX 375	BULBS	4	Albuca humilis	Rimmer De Vries	JCA 15.856 - collected at 3,000M on gravelly ledges and pockets below cliffs in the Drakensberg- Mont aux Source collected on 25th March 1996 (Trip 30 field notes), see http://files.srgc.net/archibald/fieldnotes/30JCASAfrica1996.pdf;	https://www.flickr.com/photos/32952654@N06/sets/72157646437270133/	\N	\N
BX 375	BULBS	5	Albuca namaquensis	Rimmer De Vries	ex BX 351 bloomed winter 2014-15 ;	https://www.flickr.com/photos/32952654@N06/sets/72157649471752610/	\N	\N
BX 375	BULBS	6	Albuca nelsonii	Rimmer De Vries	PBS seed sale Feb 2014	\N	\N	\N
BX 375	BULBS	7	Cyclamen seedlings	Rimmer De Vries	probably persicum ex rock or alpine society seed ex.;	https://www.flickr.com/photos/32952654@N06/16964424816/	\N	\N
BX 375	BULBS	8	Cyclamen graecum	Rimmer De Vries		\N	\N	\N
BX 375	BULBS	9	Lachenalia pendula	Rimmer De Vries	(AKA L.bulbifera) ex BX 362	\N	\N	\N
BX 375	BULBS	10	Cyrtanthus elatus 'Pink Diamond'	Rimmer De Vries	from Glasshouse Works -few small bulbs or offsets, some in leaf	\N	\N	\N
BX 375	SEEDS	11	Clivia miniata	Rimmer De Vries	hybrid yellow;	https://www.flickr.com/photos/32952654@N06/16988983822/in/album-72157651257749069/	\N	\N
BX 375	SEEDS	12	Clivia miniata	Rimmer De Vries	red Nakumura type ex Kevin Akers;	https://www.flickr.com/photos/32952654@N06/16370236073/in/album-72157651257749069/	\N	\N
BX 375	SEEDS	13	Hybrid Clivia	Rimmer De Vries	? of Clivia caulescens X Clivia miniata-yellow Clivia caulescens -(JES # Clivia caulescens Woodbush)= pod parant flower: https://www.flickr.com/photos/32952654@N06/16964393666/in/album-72157651257749069/ x pollen from Clivia miniata-yellow- seed received from Maris Andersons 2007 flower: https://www.flickr.com/photos/32952654@N06/15859590245/in/album-72157647104139113/ seed:;	https://www.flickr.com/photos/32952654@N06/16782956697/in/album-72157651257749069/	\N	\N
BX 376	BULBS	1	Haemanthus humilis ssp. hirsutus	Jill Peterson	Small bulbs	\N	\N	\N
BX 376	SEEDS	2	Clivia	Jill Peterson	seeds from a plant with deep orange flowers	\N	\N	\N
BX 376	SEEDS	3	Clivia	Jill Peterson	seeds from a variegated plant with orange flowers.	\N	\N	\N
BX 376	BULBS	4	Haemanthus albiflos	Rimmer de Vries	wide green leaves, white flower - germinated seedlings from my plant- started in Jan 2015.;	https://www.flickr.com/photos/32952654@N06/sets/72157651531259990/	\N	\N
BX 376	BULBS	5	Albuca suaveolens	Rimmer de Vries	1 yrs old seedlings grown from PBS seed sale Feb 2014- blooms in 1 yrs from seed;	https://www.flickr.com/photos/32952654@N06/sets/72157649619924043/	\N	\N
BX 376	BULBS	6	Albuca sp	Rimmer de Vries	?, green and white - 1 yr old seedlings grown from PBS seed sale Feb 2014.	\N	\N	\N
BX 376	BULBS	7	Ledebouria cooperi	Mary Sue Ittner	summer growing	\N	s	\N
BX 376	BULBS	8	Oxalis engleriana	Mary Sue Ittner		\N	\N	\N
BX 376	BULBS	9	Oxalis flava	Mary Sue Ittner	(yellow)	\N	\N	\N
BX 376	BULBS	10	Oxalis hirta 'Gothenburg'	Mary Sue Ittner		\N	\N	\N
BX 376	BULBS	11	Oxalis obtusa	Mary Sue Ittner	MV6341	\N	\N	\N
BX 376	BULBS	12	Oxalis zeekoevleyensis	Mary Sue Ittner		\N	\N	\N
BX 376	SEEDS	13	Haemanthus albiflos	Mary Sue Ittner	Short lived seed	\N	\N	\N
BX 376	SEEDS	14	Hippeastrum papilio x reginae	Nick Plummer		\N	\N	Seeds
BX 376	BULBS	15	Moraea villosa	Dee Foster	Small corms	\N	\N	\N
BX 376	BULBS	16	Lachenalia mutabilis	Dee Foster	originally from UCI. Bulblets	\N	\N	\N
BX 377	BULBS	1	(Hippeastrum papilio x H. mandonii) x H. 'Jade Dragon'	Tim Eck	{'Jade Dragon' = H. cybister x H. papilio, F2} Seedling bulbs of Hippeastrum crosses. All are close to 1 cm  dia.	\N	\N	\N
BX 377	BULBS	2	Hippeastrum 'Orange Sovereign' x H. 'Red Pearl'	Tim Eck	{large multiflowered orange-red x large multiflowered black-red}	\N	\N	\N
BX 377	BULBS	3	Hippeastrum 'Ludwig Goliath' x H. 'Red Pearl'	Tim Eck	{both very large multiflowered reds} Seedling bulbs of Hippeastrum crosses. All are close to 1 cm  dia.	\N	\N	\N
BX 377	BULBS	4	Hippeastrum 'White Wedding' x H. 'Red Pearl'	Tim Eck	{large white x large red-black'; could show bands and textures} Seedling bulbs of Hippeastrum crosses. All are close to 1 cm  dia.	\N	\N	\N
BX 378	BULBS	1	Albuca juncifolia	Rimmer de Vries	ex BX 351 #1	\N	\N	\N
BX 378	BULBS	2	Albuca clanwilliamae-gloria	Rimmer de Vries	from Feb 2014 PBX seed sale	\N	\N	\N
BX 378	BULBS	3	Albuca acuminata	Rimmer de Vries	ex BX 351 #9 blooming size bulbs and lots of small bulbs.	\N	\N	\N
BX 378	BULBS	4	Polianthes geminiflora	Mary Sue Ittner	Bulbs to plant now	\N	s	\N
BX 378	BULBS	5	Oxalis bowiei	Mary Sue Ittner		\N	w	\N
BX 378	BULBS	6	Oxalis asinina	Mary Sue Ittner	(or O. fabifolia)	\N	w	\N
BX 378	BULBS	7	Oxalis caprina	Mary Sue Ittner		\N	w	\N
BX 378	BULBS	8	Oxalis flava	Mary Sue Ittner	mostly pink	\N	w	\N
BX 378	BULBS	9	Oxalis imbricata	Mary Sue Ittner		\N	w	\N
BX 378	BULBS	10	Oxalis luteola	Mary Sue Ittner	MV 5567	\N	w	\N
BX 378	BULBS	11	Oxalis melanosticta 'Ken Aslet'	Mary Sue Ittner		\N	w	\N
BX 378	BULBS	12	Oxalis obtusa	Mary Sue Ittner	MV 5005a	\N	w	\N
BX 378	BULBS	13	Oxalis obtusa	Mary Sue Ittner	coral	\N	w	\N
BX 378	BULBS	14	Oxalis obtusa	Mary Sue Ittner	MV 7085	\N	w	\N
BX 378	BULBS	15	Oxalis purpurea	Mary Sue Ittner	white	\N	w	\N
BX 378	BULBS	16	Oxalis purpurea 'Skar'	Mary Sue Ittner	Skar'	\N	w	\N
BX 378	BULBS	17	Tulipa turkestanica	Mary Sue Ittner		\N	w	\N
BX 379	SEEDS	1	Hippeastrum 'Red Garden'	Fred Biasella		\N	\N	Seeds
BX 379	BULBS	2	Phaedranassa viridiflora	Fred Biasella		\N	\N	Small bulbs
BX 379	SEEDS	3	xHippeastrelia	Pam Slate	selfed. ex Buried Treasures, Valrico, FL	\N	\N	Seed
BX 379	BULBS	4	Ornithogallum osmynellum	Pam Slate	(Albuca osmynella); ex BX 148, ex Steve Hammer, ex Noreogas	\N	\N	Small bulbs
BX 379	BULBS	5	Four taxa	Scott VanGerpen	One order, only. All four in a lot: 1 bulb of Biarum marmarisense; 1 cormlet of Geissorhiza radians, 1 bulb of Massonia pygmaea subsp. kamiesbergensis; and 1 bulb of Lachenalia trichophylla	\N	\N	\N
BX 379	BULBS	6	Chasmanthe floribunda 'Duckittii'	Arnold Trachtenberg		\N	\N	Corms
BX 379	BULBS	7	Albuca suaveolens	Rimmer de Vries		\N	\N	Bulbs
BX 379	BULBS	8	Othonna sp	Rimmer de Vries	?	\N	\N	Tubers
BX 380	BULBS	1	Lachenalia punctata	Uli Urban	(syn. L. rubida) bulbili. The plant is quite showy with red tubular flowers in early spring and is strictly winter growing. The bulbili form at the leaf bases and on the midrib like structure of the leaf.The mother plant was given to me by Dietrich Müller-Doblis but I do not have the collection data.	\N	\N	\N
BX 380	BULBS	2	Gladiolus flanaganii	Uli Urban	cormlets and small corms. It grows very vigorously with me but is a little shy to flower, easy, summer growing and winter dry.	\N	\N	\N
BX 380	BULBS	3	Tropical waterlily	Uli Urban	Tubers of my blue tropical waterlily. I posted those before. I lost the mother tubers in winter due to rot but the small tubers that formed in the center of the leaves were kept in moist Sphagnum with some fungicide at a temperature around 10°C. They kept very well, I started 2 of them at the end of April and all sprouted. I had kept one in unheated water in my frost free but cold greenhouse. It is sprouting, too. They should be started immediately in warm water, give them as much light and warmth as possible, fertilize well (Osmocote is best) and then they will grow VERY quickly. Purple-blue flowers with yellow centre held above the water, very scented. Will form new tubers or even small plants on the leaves (viviparous) Identity is uncertain, I got it as an exchange from the Strasbourg Botanical Garden in France under the name of Nymphaea daubeniana which it is definitely not. It comes closest to the Hybrid 'Tina'	\N	\N	\N
BX 380	SEEDS	4	Cyclamen graecum	Rimmer de Vries	fresh seeds moist packed in vermiculite.	\N	\N	\N
BX 380	SEEDS	5	Clivia miniata	Rimmer de Vries	hyb; Seeds of hyb- ex Maris Andersons- blooms as Salmon D4 to Apricot D6 (VERY FEW)	\N	\N	\N
BX 381	SEEDS	1	Hymenocallis guerreroensis	Monica Swartz	from bx 243	\N	\N	Seed
BX 381	BULBS	2	Lachenalia longituba	Monica Swartz	from bx 2008 seed clearance	\N	\N	Bulbs
BX 381	BULBS	3	Massonia cf. pustulata	Monica Swartz	from bx 174, ex Roy Herold, ex NARGS	\N	\N	Bulbs
BX 381	BULBS	4	Massonia echinata	Monica Swartz	mix of parents, some from bx 212	\N	\N	Bulbs
BX 381	BULBS	5	Massonia depressa	Monica Swartz	should all be from a brown flowered form though there may be some from a yellow flowered form.	\N	\N	Bulbs
BX 381	BULBS	6	Freesia laxa	Makiko Goto-Widerman	orange	\N	\N	Small corms
BX 381	SEEDS	7	Hippeastrum 'Charisma'	Sophie Dixon		\N	\N	Seeds
BX 381	BULBS	8	Acis autumnalis	Mary Sue Ittner		\N	\N	\N
BX 381	BULBS	9	Cyrtanthus mackenii	Mary Sue Ittner	- plant immediately as this one is evergreen	\N	e	\N
BX 381	BULBS	10	Oxalis bifurca	Mary Sue Ittner		\N	\N	\N
BX 381	BULBS	11	Oxalis commutata	Mary Sue Ittner		\N	\N	\N
BX 381	BULBS	12	Oxalis sp	Mary Sue Ittner	. MV4674	\N	\N	\N
BX 381	BULBS	13	Oxalis pardalis	Mary Sue Ittner	MV7632	\N	\N	\N
BX 381	BULBS	14	Oxalis obtusa 'Peaches & Cream'	Mary Sue Ittner		\N	\N	\N
BX 381	BULBS	15	Oxalis versicolor	Mary Sue Ittner		\N	\N	\N
BX 381	BULBS	16	Tulipa linifolia	Mary Sue Ittner	(yellow, form known by most at Tulipa batalinii), small bulbs	\N	\N	\N
BX 381	BULBS	17	Tulipa linifolia	Mary Sue Ittner	(red), small bulbs	\N	\N	\N
BX 381	BULBS	18	Crinum bulbispermum	Tim Eck	Jumbo strain	\N	\N	Seeds
BX 382	SEEDS	1	Cooperia drummondii	Cynthia Mueller	(Zephyranthes chlorosolen) - 'Prairie Lily' a form with blue-green leaves and white flowers.	\N	\N	\N
BX 382	SEEDS	2	Hippeastrum puniceum	Cynthia Mueller	. Apparently a bit more pinkish in color than the usual form. Good multiplier in pot.	\N	\N	\N
BX 382	SEEDS	3	Zephyranthes and Habranthus	Cynthia Mueller	Rain lily mix: seeds for those who might want to start growing rain lilies. These all thrive in Zone 8 - 9. May include red or yellow Zephyranthes katheriniae, Z. macrosiphon, what may be Z. primulina, and Habranthus robustus, large form.	\N	\N	\N
BX 382	SEEDS	4	Hippeastrum	Cynthia Mueller	strong red form for outdoor planting in Zone 8 - 9.	\N	\N	\N
BX 382	SEEDS	5	Hippeastrum 'Voodoo'	Cynthia Mueller	from Yucca Doo, a different plant from the one advertised by Plant Delights Nursery and on the web. This form looks like an extra fancy johnsonii type but without distinct red stripes. Multiplies well.	\N	\N	\N
BX 386	BULBS	10	Narcissus 'Stocken'	Mary Sue Ittner		\N	\N	Bulbs
BX 382	SEEDS	6	Hippeastrum 'Orange Tet'	Cynthia Mueller	. Red/orange large flowers with stripes, some greenish white in throat. Purchased from a Mom-and-Pop nursery on Alabama St in Houston in the early `70's. Always comes true from seed. Leaves can be 4' wide, extra long. Seedlings sometimes manage to come up elsewhere in the flowerbeds. Makes a distinct impression in the landscape.	\N	\N	\N
BX 382	SEEDS	7	Crinum bulbispermum	Cynthia Mueller	Brazos County, TX' Can flower at Christmas here if the weather has been relatively mild. Strong stalks, good shape and form of flowers for plain bulbispermum. Bluish-green leaves.	\N	\N	\N
BX 382	SEEDS	8	xHippeastrelia	Cynthia Mueller	- a vigorous plant that bears good, well filled seed pods.	\N	\N	\N
BX 382	SEEDS	9	Hippeastrum	Cynthia Mueller	Hippeastrum 'Fancy Red Garden' type.	\N	\N	\N
BX 382	SEEDS	10	Crinum carolo-schmidtii	Stephen Putman	ONE ORDER ONLY	\N	\N	\N
BX 382	SEEDS	11	Hippeastrum iguazuanum	Stephen Putman		\N	\N	\N
BX 382	SEEDS	12	Hippeastrum stylosum	Stephen Putman		\N	\N	\N
BX 382	SEEDS	13	Trillium viride	Rimmer de Vries	ex Jefferson Co. Mo. packed in damp vermiculite- these were taken from the fruits, washed and mailed to you in minutes and may mold up if not opened upon arrival. Pics of the trillium at the link below. These are hardy in Michigan. https://www.flickr.com/gp/32952654@N06/nF8tog/	https://flic.kr/s/aHskdyUcQ8/	\N	\N
BX 382	SEEDS	14	Clivia miniata	Rimmer de Vries	hybrid Nakamura type with short wide leaves, orange flowers, big red fruits. pic of the red fruits on flicker	https://flickr.com/photos/32952654@N06/#	\N	\N
BX 382	SEEDS	15	Habranthus robustus	Rimmer de Vries	ex BX 316 #6 came as Bulbs of Notholirion thompsonianum, these were hardy in a cold frame in Michigan for several years but really took off when I brought the pot inside. big pink flowers with dark throat. flowers everytime it rains all summer. some are red and some are green.	\N	\N	\N
BX 382	SEEDS	16	Clivia caulescens	Ray Talley	ONE ORDER ONLY - seeds	\N	\N	Seeds
BX 383	BULBS	1	Hippeastrum striatum 'Saltao'	Nicholas Plummer		\N	\N	Bulblets
BX 383	BULBS	2	Hippeastrum striatum	Nicholas Plummer	from a single clone, ex BX 341	\N	\N	Bulblets
BX 383	BULBS	3	Amaryllis belladonna	Jim Barton	One-yr-old bulblets	\N	\N	\N
BX 383	BULBS	4	Dichelostemma capitatum	Jim Barton		\N	\N	\N
BX 383	BULBS	5	Calochortus luteus	Jim Barton		\N	\N	\N
BX 383	BULBS	6	Triteleia hyacinthina	Jim Barton		\N	\N	\N
BX 383	BULBS	7	Triteleia ixioides	Jim Barton		\N	\N	\N
BX 383	BULBS	8	Triteleia laxa	Jim Barton		\N	\N	\N
BX 383	SEEDS	9	Trillium kurabayashii	Kathleen Sayce	Fresh moist seeds. Red flowers and nicely mottled foliage, grown from seeds from NARGS seed exchange.	\N	\N	\N
BX 384	BULBS	1	Crocus ochroleucus	Mary Sue Ittner	- small cormlets	\N	\N	\N
BX 384	BULBS	2	Freesia laxa	Mary Sue Ittner	blue - cormlets	\N	\N	\N
BX 384	BULBS	3	Freesia sparrmanii	Mary Sue Ittner	- cormlets	\N	\N	\N
BX 384	BULBS	4	Oxalis depressa	Mary Sue Ittner	MV4871 - bulbs	\N	\N	\N
BX 384	BULBS	5	Tristagma uniflorum	Mary Sue Ittner	(Ipheion uniflorum?), white - bulbs	\N	\N	\N
BX 384	SEEDS	6	Habranthus robustus	Rimmer de Vries	- Telos, .	https://flic.kr/p/xmZDVu/ -short lived seed	\N	Seed
BX 384	SEEDS	7	Habranthus sp	Rimmer de Vries	.. came as something else in BX 316 #16- i listed this as H. robustus on the seed packet but i have been told this is not the correct name. these are big plants with big flowers and like lots of water. This is seed from the same plants as BX 382 #15. Please note the correction. These were hardy in a cold frame in Michigan for several years but the plants really took off when I brought the pot inside. Big pink flowers flowers everytime it rains all summer. here is a link to photos of the plant and flowers.	https://flic.kr/s/aHskhHDZN9/ -short lived seed.	\N	Seed
BX 384	SEEDS	8	Leucojum aestivum	Rimmer de Vries	- moist packed - short lived seed.	\N	\N	Seed
BX 384	SEEDS	9	Sprekelia formosissima	Rimmer de Vries		\N	\N	Seed
BX 384	SEEDS	10	Cyrtanthus mackenii	Ray Talley		\N	\N	Seed
BX 384	BULBS	11	Amaryllis belladonna	Jim Barton	One year old small bulbs	\N	\N	\N
BX 384	BULBS	12	Lilium sargentiae	Arnold Trachtenberg	Stem bulbils	\N	\N	\N
BX 385	BULBS	1	Scilla lingulata	Rimmer de Vries	var. ciliolata (syn.? Hyacinthoides lingulata) (syn. H, ciliolata) ex Jane McGary. late flowering Late October - December and later, pale blue flowers have dark blue ovary and blue pollen- hardy outside in Zone 4 in a cold frame but excellent for a cold greenhouse	https://flic.kr/p/pXC9pV/	\N	\N
BX 385	BULBS	2	Scilla lingulata	Rimmer de Vries	var. ciliolata (syn. ? Hyacinthoides lingulata) (syn. H, ciliolata) - ex Paul Otto- probably the same as above, though there are many forms of this plant with different leaves and flowers and flowering times.	\N	\N	\N
BX 385	BULBS	3	Massonia echinata	Rimmer de Vries	- 2 yr old seedlings from NARGS 2012-13 seed ex # 1684 donated by Corina Rieder started 18 March 2013-	https://flic.kr/p/rTo7VD/	\N	\N
BX 385	BULBS	4	Massonia pustulata	Rimmer de Vries	- 2 yr old seedlings from BX 337 Arnold's purple leaved plants, seed started 12 May 2013	\N	\N	\N
BX 385	BULBS	5	Habranthus tubispathus	Rimmer de Vries	ex Jim Shelids, pot full of 1 yr old seedlings - seed collected 7/15/2014, started 7/16/2014	\N	\N	\N
BX 385	SEEDS	6	Pamianthe peruviana	Paul Matthews		\N	\N	Seeds
BX 385	BULBS	7	Sinningia leucotricha 'Max Dekking'	Dennis Kramb	ONE tuber	\N	\N	Tuber
BX 385	BULBS	8	Oxalis bowiei	John Willis		\N	\N	\N
BX 385	BULBS	9	Lachenalia contaminata	John Willis		\N	\N	\N
BX 385	BULBS	10	Lachenalia liliiflora	John Willis		\N	\N	\N
BX 386	BULBS	1	Bulbs and	Rimmer de Vries	offsets of Eucharis sp.?	\N	\N	\N
BX 386	BULBS	2	Cyrtanthus elatus	Rimmer de Vries	x montanus -ex BX 330	\N	\N	Bulblets
BX 386	BULBS	3	Tulipa sylvestris	Rimmer de Vries	- few small bulbs	\N	\N	\N
BX 386	SEEDS	4	Habranthus tubispathus	Rimmer de Vries	ex Telos	\N	\N	Seeds
BX 386	SEEDS	5	Habranthus robustus	Rimmer de Vries	ex Telos	\N	\N	Seeds
BX 386	BULBS	6	Lilium sargentiae	Cynthia Mueller	?	\N	\N	Bulbils
BX 386	SEEDS	7	Boophone haemanthoides	Kipp McMichael	white x pink	\N	\N	Seeds
BX 386	SEEDS	8	Boophone disticha	Kipp McMichael	wavy leaf, almost evergreen	\N	\N	Seeds
BX 386	BULBS	9	Griffinia aracensis	Mary Sue Ittner	(FEW)	\N	\N	Small bulbs
BX 386	BULBS	12	Hyacinthoides lingulata	Mary Sue Ittner		\N	\N	Bulbs
BX 386	BULBS	13	Colchicum hungaricum 'Valentine'	Terry Laskiewicz	blooms February	\N	\N	\N
BX 386	BULBS	14	Narcissus romieuxii 'Julia Jane'	Terry Laskiewicz		\N	\N	\N
BX 386	BULBS	15	Narcissus romieuxii	Terry Laskiewicz		\N	\N	\N
BX 386	BULBS	16	Notholirion thomsonianum	Terry Laskiewicz		\N	\N	\N
BX 386	BULBS	17	Ixia longituba	Monica Swartz	var. bellendenii	\N	\N	Small corms
BX 386	BULBS	18	Sinningia eumorpha 'Roxa Clenilson'	Denis Kramb	(small tubers, purple variant of Sinn. eumorpha, recently discovered in the wild by Clenilson Souza of Brazil, 'roxa' is Portuguese for 'purple', the name 'Roxa Clenilson' is not a registered name, but just a descriptor for the discoverer & color variant.)	\N	\N	\N
BX 386	BULBS	19	Sinningia cardinalis	Denis Kramb	(small tubers, most of them roughly pea-sized or smaller, should be planted & watered once, new growth should happen quickly)	\N	\N	\N
BX 386	BULBS	20	Sinningia cardinalis	Denis Kramb	(few, large tubers, recently bloomed this summer, may require a period of dormancy before resprouting, or might re-sprout immediately)	\N	\N	\N
BX 386	BULBS	21	Sinningia 'Deep Purple Dreaming'	Denis Kramb	(few, large tubers, these were harvested when fully dormant, but this cultivar has a long dormancy for me, so plant immediately but water sparingly until new growth naturally resumes)	\N	\N	\N
BX 386	BULBS	22	Gethyllis grandiflora	Arcangelo Wessells	ex Silverhill; bulbs went to the bottom of one gallon pot	\N	\N	Small bulbs
BX 386	BULBS	23	Gethyllis sp	Arcangelo Wessells	.?, ex Silverhill	\N	\N	Small bulbs
BX 387	SEEDS	1	Paeonia lactiflora	Rimmer De Vries	-The parents of the seeds area collection of singles and semi doubles in white, pinks, and reds grown from a mix of OP seedlings Color Magnet and Minnie Shaylor.	\N	\N	Seeds
BX 387	BULBS	2	Phaedranassa viridiflora	Rimmer De Vries	(VERY FEW)	\N	\N	\N
BX 387	BULBS	3	Eucrosia bicolor	Rimmer De Vries		\N	\N	\N
BX 387	BULBS	4	Clivia miniata	Rimmer De Vries	hybrids misc. 1-2 yr seedlings. appear to be reds.	\N	\N	\N
BX 387	BULBS	5	Allium acuminatum	Nhu Nguyen	NNBH853	\N	\N	\N
BX 387	BULBS	6	Allium amplectens	Nhu Nguyen	pink form NNBH849	\N	\N	\N
BX 387	BULBS	7	Allium campanulatum	Nhu Nguyen	NNBH850	\N	\N	\N
BX 387	BULBS	8	Allium hickmanii	Nhu Nguyen	NNBH1	\N	\N	\N
BX 387	BULBS	9	Allium hyalinum	Nhu Nguyen	pink form - NNBH147	\N	\N	\N
BX 387	BULBS	10	Allium hyalinum	Nhu Nguyen	white form - NNBH301	\N	\N	\N
BX 387	BULBS	11	Allium lemmonii	Nhu Nguyen	NNBH754 - from open pollinated plants and have not bloomed so I cannot confirm actual ID.	\N	\N	\N
BX 387	BULBS	12	Allium siskiyouense	Nhu Nguyen	NNBH347 - from Ron Ratko seeds	\N	\N	\N
BX 387	BULBS	13	Oxalis flava	Nhu Nguyen	(fabifolia?)- NNBH2221	\N	\N	\N
BX 387	BULBS	14	Oxalis bowiei	Nhu Nguyen	- NNBH2232	\N	\N	\N
BX 387	BULBS	15	Lachenalia multifolia	Nhu Nguyen	- NNBH408	\N	\N	\N
BX 387	BULBS	16	Ledebouria socialis 'Paucifolia'	Nhu Nguyen	- NNBH260 (from Mark Mazer BX166)	\N	\N	\N
BX 387	SEEDS	17	Nerine filifolia	Nhu Nguyen	OP All of these Nerine species were in bloom more or less at the same time so there is a good chance that they are hybrids of each other.	\N	\N	\N
BX 387	SEEDS	18	Nerine gibsonii	Nhu Nguyen	OP All of these Nerine species were in bloom more or less at the same time so there is a good chance that they are hybrids of each other.	\N	\N	\N
BX 387	SEEDS	19	Nerine falcata	Nhu Nguyen	(N. laticoma) OP All of these Nerine species were in bloom more or less at the same time so there is a good chance that they are hybrids of each other.	\N	\N	\N
BX 387	SEEDS	20	Haemanthus humilis	Nhu Nguyen	subsp. humilis OP	\N	\N	\N
BX 387	SEEDS	21	Haemanthus humilis	Nhu Nguyen	subsp. hirsutus OP	\N	\N	\N
BX 387	SEEDS	22	Ammocharis coranica	Nhu Nguyen	deep wine red x lighter red	\N	\N	\N
BX 387	SEEDS	23	Brunsvigia josephiniae	Kipp McMichael		\N	\N	Seeds
BX 387	SEEDS	24	Zephyranthes citrina	Victor Menendez Dominguez		\N	\N	Seeds
BX 388	BULBS	1	Arum purpureospathum	Mary Sue Ittner		\N	\N	\N
BX 388	BULBS	2	Calochortus uniflorus	Mary Sue Ittner	(spotted)	\N	\N	\N
BX 388	BULBS	3	Cyrtanthus brachyscyphus	Mary Sue Ittner	- evergreen, but dried off so could send them	\N	\N	\N
BX 388	BULBS	4	Dichelostemma multiflorum	Mary Sue Ittner	cormlets	\N	\N	\N
BX 388	BULBS	5	Ferraria crispa	Mary Sue Ittner		\N	\N	\N
BX 388	BULBS	6	Geissorhiza sp	Mary Sue Ittner	. (probably Geissorhiza inaequalis or G. heterostyla (G. rosea) or both))	\N	\N	\N
BX 388	BULBS	7	Moraea lurida	Mary Sue Ittner		\N	\N	\N
BX 388	BULBS	8	Nothoscordum dialystemon	Mary Sue Ittner		\N	\N	\N
BX 388	BULBS	9	Spiloxene capensis	Mary Sue Ittner		\N	\N	\N
BX 388	BULBS	10	Tristagma sellowianum	Mary Sue Ittner	syn. Ipheion sellowianum, syn. Nothoscordum felipponei	\N	\N	\N
BX 388	SEEDS	11	Habranthus brachyandrus	Cynthia Mueller		\N	\N	\N
BX 388	SEEDS	12	Habranthus tubispathus 'texanus'	Cynthia Mueller	copper-yellow with some dark markings; ex. Central Texas	\N	\N	\N
BX 388	SEEDS	13	Zephyranthes macrosiphon	Cynthia Mueller	good flowerer	\N	\N	\N
BX 388	SEEDS	14	Zephyranthes macrosiphon	Cynthia Mueller	crosses, pinks	\N	\N	\N
BX 388	SEEDS	15	Zephyranthes 'Labuffarosea'	Cynthia Mueller	crosses, pink, slender petals	\N	\N	\N
BX 388	SEEDS	16	Habranthus	Cynthia Mueller	Mixed open-pollinated Habranthus, such as Hh. floryi, robustus, 'Russell Manning'	\N	\N	\N
BX 388	BULBS	17	Sinningia 'Silhouette'	Dennis Kramb	(FEW)	\N	\N	Tubers
BX 388	BULBS	18	Sinningia eumorpha 'Roxa Clenilson'	Dennis Kramb		\N	\N	Tubers
BX 388	BULBS	19	xPhinastema 'California Dreaming'	Dennis Kramb		\N	\N	Dormant rhizomes
BX 389	BULBS	1	Moraea ciliata	Bob Werra	tall blue/yellow	\N	w	\N
BX 389	BULBS	2	Moraea ciliata	Bob Werra	short blue/white	\N	w	\N
BX 389	BULBS	3	Moraea macronyx	Bob Werra		\N	w	\N
BX 389	BULBS	4	Moraea tripetala	Bob Werra		\N	w	\N
BX 389	SEEDS	5	Moraea aristata	Bob Werra		\N	w	\N
BX 389	SEEDS	6	Moraea bellendenii	Bob Werra		\N	w	\N
BX 389	SEEDS	7	Moraea bituminosa	Bob Werra		\N	w	\N
BX 389	SEEDS	8	Moraea aristata	Bob Werra	or villosa ?	\N	w	\N
BX 389	SEEDS	9	Moraea ciliata	Bob Werra	short blue/white	\N	w	\N
BX 389	SEEDS	10	Moraea ciliata	Bob Werra	tall blue/yellow	\N	w	\N
BX 389	SEEDS	11	Moraea elegans	Bob Werra	orange	\N	w	\N
BX 389	SEEDS	12	Moraea elegans	Bob Werra	yellow/green	\N	w	\N
BX 389	SEEDS	13	Moraea fergusoniae	Bob Werra	lavender	\N	w	\N
BX 389	SEEDS	14	Moraea gawleri	Bob Werra	peach & yellow	\N	w	\N
BX 389	SEEDS	15	Moraea gigandra	Bob Werra		\N	w	\N
BX 389	SEEDS	16	Moraea fugax	Bob Werra	med-tall, yellow	\N	w	\N
BX 389	SEEDS	17	Moraea lurida	Bob Werra		\N	w	\N
BX 389	SEEDS	18	Moraea macronyx	Bob Werra	yellow/white	\N	w	\N
BX 389	SEEDS	19	Moraea papilionacea	Bob Werra		\N	w	\N
BX 389	SEEDS	20	Moraea polyanthos	Bob Werra		\N	w	\N
BX 389	SEEDS	21	Moraea stricta	Bob Werra	?, med-tall, dark blue	\N	w	\N
BX 389	SEEDS	22	Calostemma purpureum	Ivor Tyndal		\N	\N	Seeds
BX 389	SEEDS	23	Rhodophiala bakeri	Ivor Tyndal		\N	\N	Seeds
BX 389	SEEDS	24	Caliphruria subedentata	Ivor Tyndal		\N	\N	Bulbs
BX 390	SEEDS	1	Moraea tricuspidata	Bob Werra		\N	w	\N
BX 390	SEEDS	2	Moraea tripetala	Bob Werra		\N	w	\N
BX 390	SEEDS	3	Moraea tripetala	Bob Werra	dark blue	\N	w	\N
BX 390	SEEDS	4	Moraea tulbaghensis	Bob Werra		\N	w	\N
BX 390	SEEDS	5	Moraea vegeta	Bob Werra		\N	w	\N
BX 390	SEEDS	6	Moraea vespertina	Bob Werra	named because it bloomed during evening vespers. Modern name should be 'M. suppertina' - opens before supper and closes after supper. Slightly fragrant.	\N	w	\N
BX 390	SEEDS	7	Moraea villosa	Bob Werra	,	\N	w	\N
BX 390	SEEDS	8	Moraea villosa	Bob Werra	tan / dark blue	\N	w	\N
BX 390	SEEDS	9	Moraea villosa	Bob Werra	white/ blue	\N	w	\N
BX 390	SEEDS	10	Moraea villosa	Bob Werra	lavender/blue	\N	w	\N
BX 390	SEEDS	11	Moraea villosa	Bob Werra	tall, ivory/ blue	\N	w	\N
BX 390	SEEDS	12	Moraea villosa	Bob Werra	white/green	\N	w	\N
BX 390	SEEDS	13	Moraea villosa	Bob Werra	dark lavender/ blue	\N	w	\N
BX 390	SEEDS	14	Moraea villosa	Bob Werra	copper/ green	\N	w	\N
BX 390	SEEDS	15	Moraea villosa	Bob Werra	white/ dark blue	\N	w	\N
BX 390	SEEDS	16	Moraea sp	Bob Werra	.?, large orange	\N	w	\N
BX 390	SEEDS	17	Romulea sabulosa	Bob Werra		\N	w	\N
BX 390	SEEDS	18	Rhodophiala bifida	Bob Werra		\N	w	\N
BX 390	SEEDS	19	Fritillaria affinis	Bob Werra		\N	w	\N
BX 390	SEEDS	20	Fritillaria pluriflora	Bob Werra		\N	w	\N
BX 391	SEEDS	1	Calochortus amabilis	Robert Werra		\N	\N	\N
BX 391	SEEDS	2	Calochortus luteus	Robert Werra	native to Colusa County, California	\N	\N	\N
BX 391	SEEDS	3	Calochortus uniflorus	Robert Werra		\N	\N	\N
BX 391	SEEDS	4	Calochortus weedii	Robert Werra	var. weedii, yellow	\N	\N	\N
BX 391	SEEDS	5	Calochortus amabilis	Kipp McMichael	Napa Co.	\N	\N	\N
BX 391	SEEDS	6	Calochortus albus	Kipp McMichael	var. rubellus, San Luis Obispo Co.	\N	\N	\N
BX 391	SEEDS	7	Calochortus clavatus	Kipp McMichael	var. avius See wiki page	http://www.pacificbulbsociety.org/pbswiki/index.php/Calochortus_clavatus	\N	\N
BX 391	SEEDS	8	Calochortus clavatus	Kipp McMichael	var. gracilis, Soledad Canyon Rd.	\N	\N	\N
BX 391	SEEDS	9	Calochortus davidsonianus	Kipp McMichael	(C. splendens?), Bedford Motor Way	\N	\N	\N
BX 391	SEEDS	10	Calochortus davidsonianus	Kipp McMichael	(C. splendens?), Orange Co.	\N	\N	\N
BX 391	SEEDS	11	Calochortus fimbriatus	Kipp McMichael	Santa Barbara Co.	\N	\N	\N
BX 391	SEEDS	12	Calochortus invenustus	Kipp McMichael	Kern Co.	\N	\N	\N
BX 391	SEEDS	13	Calochortus kennedyi	Kipp McMichael	Kern Co.	\N	\N	\N
BX 391	SEEDS	14	Calochortus kennedyi	Kipp McMichael	Lockwood Valley Rd.	\N	\N	\N
BX 391	SEEDS	15	Calochortus luteus	Kipp McMichael	Santa Barbara Co.	\N	\N	\N
BX 391	SEEDS	16	Calochortus obispoensis	Kipp McMichael	San Luis Obispo Co.	\N	\N	\N
BX 391	SEEDS	17	Calochortus pulchellus	Kipp McMichael	Contra Costa Co.	\N	\N	\N
BX 391	SEEDS	18	Calochortus simulans	Kipp McMichael	Hi Mtn Rd., San Luis Obispo Co.	\N	\N	\N
BX 391	SEEDS	19	Calochortus splendens	Kipp McMichael	Kern Co.	\N	\N	\N
BX 391	SEEDS	20	Calochortus striatus	Kipp McMichael	ex hort.	\N	\N	\N
BX 391	SEEDS	21	Calochortus superbus	Kipp McMichael	Napa Co.	\N	\N	\N
BX 391	SEEDS	22	Calochortus tiburonensis	Kipp McMichael	ex hort.	\N	\N	\N
BX 391	SEEDS	23	Calochortus tolmiei	Kipp McMichael	Marin Co.	\N	\N	\N
BX 391	SEEDS	24	Calochortus tolmiei	Kipp McMichael	San Mateo Co.	\N	\N	\N
BX 391	SEEDS	25	Calochortus umbellatus	Kipp McMichael	Marin Co.	\N	\N	\N
BX 391	SEEDS	26	Calochortus weedii	Kipp McMichael	var. intermedius, San Diego Co.	\N	\N	\N
BX 391	SEEDS	27	Calochortus sp	Kipp McMichael	.?, maybe simulans, Hi Mtn. Rd.	\N	\N	\N
BX 392	BULBS	1	Amorphophallus sp	From Joyce Miller	.. grown from BX seeds.	\N	\N	\N
BX 392	BULBS	2	Nerine angustifolia	From Joyce Miller	.	\N	\N	\N
BX 392	BULBS	3	Nerine masonorum	From Joyce Miller	. These bloomed for me in Sacramento, CA where summer nights are hot.	\N	\N	\N
BX 392	BULBS	4	Sinningia sp.	From Joyce Miller	from BX seed donated by Nhu Nguyen.	\N	\N	\N
BX 392	BULBS	5	Griffinia espiritensis	Rimmer de Vries	ex Eden's Blooms; good, strong, freely blooming clone	\N	\N	\N
BX 392	BULBS	6	Cyrtanthus labiatus	Rimmer de Vries	ex BX; offsets freely, but does not grow to blooming size	\N	\N	\N
BX 392	BULBS	7	Babiana thunbergii	Mike Mace	(B. hirsuta)	\N	\N	\N
BX 392	BULBS	8	Geissorhiza inaequalis	Mike Mace		\N	\N	\N
BX 392	BULBS	9	Gladiolus sp	Mike Mace	. MM 00-00a (very nice mottled magenta and yellow flowers)	http://growingcoolplants.blogspot.com/	\N	\N
BX 392	BULBS	10	Gladiolus sp	Mike Mace	. MM 00-00d (similar to 00-00a, but less mottling)	http://growingcoolplants.blogspot.com/	\N	\N
BX 392	BULBS	11	Gladiolus watsonius	Mike Mace		\N	\N	\N
BX 392	BULBS	12	Moraea 'Zoe'	Mike Mace	second generation seedlings	http://growingcoolplants.blogspot.com/	\N	\N
BX 392	BULBS	13	Moraea aristata	Mike Mace		\N	\N	\N
BX 392	BULBS	14	Moraea fugax	Mike Mace	purple	\N	\N	\N
BX 392	BULBS	15	Moraea gigandra	Mike Mace		\N	\N	\N
BX 392	BULBS	16	Moraea lurida	Mike Mace	pale yellow/maroon	\N	\N	\N
BX 392	BULBS	17	Moraea sp	Mike Mace	. MM 03-04a	http://growingcoolplants.blogspot.com/	\N	\N
BX 392	BULBS	18	Moraea sp	Mike Mace	. MM 03-04b	http://growingcoolplants.blogspot.com/	\N	\N
BX 392	BULBS	19	Moraea sp	Mike Mace	. MM 03-07a	http://growingcoolplants.blogspot.com/	\N	\N
BX 392	BULBS	20	Moraea sp	Mike Mace	. MM 03-07b	http://growingcoolplants.blogspot.com/	\N	\N
BX 392	BULBS	21	Moraea sp	Mike Mace	. MM 03-98b	http://growingcoolplants.blogspot.com/	\N	\N
BX 392	BULBS	22	Moraea sp	Mike Mace	. MM 03-98c	http://growingcoolplants.blogspot.com/	\N	\N
BX 392	BULBS	23	Moraea sp	Mike Mace	. MM 03-98d	http://growingcoolplants.blogspot.com/	\N	\N
BX 392	BULBS	24	Moraea sp	Mike Mace	. 03-99a	http://growingcoolplants.blogspot.com/	\N	\N
BX 392	BULBS	25	Moraea sp	Mike Mace	. MM 09-01	http://growingcoolplants.blogspot.com/	\N	\N
BX 392	BULBS	26	Moraea sp	Mike Mace	. MM 09-04	http://growingcoolplants.blogspot.com/	\N	\N
BX 393	BULBS	1	Moraea sp	Mike Mace	. MM 10-04a	http://growingcoolplants.blogspot.com/	\N	\N
BX 393	BULBS	2	Moraea sp	Mike Mace	. MM 10-25	http://growingcoolplants.blogspot.com/	\N	\N
BX 393	BULBS	3	Moraea sp	Mike Mace	. MM 11-19	http://growingcoolplants.blogspot.com/	\N	\N
BX 393	BULBS	4	Moraea sp	Mike Mace	. MM 11-20	http://growingcoolplants.blogspot.com/	\N	\N
BX 393	BULBS	5	Moraea sp	Mike Mace	. MM 99-00	http://growingcoolplants.blogspot.com/	\N	\N
BX 393	BULBS	6	Moraea neopavonia	Mike Mace	(M. tulbaghensis)	\N	\N	\N
BX 393	BULBS	7	Moraea saxicola	Mike Mace		\N	\N	\N
BX 393	BULBS	8	Moraea schlechteri	Mike Mace		\N	\N	\N
BX 393	BULBS	9	Moraea setifolia	Mike Mace		\N	\N	\N
BX 393	BULBS	10	Moraea tripetala	Mike Mace		\N	\N	\N
BX 393	BULBS	11	Moraea tulbaghensis	Mike Mace	(tulbaghensis form)	\N	\N	\N
BX 393	BULBS	12	Moraea villosa	Mike Mace	form a	http://growingcoolplants.blogspot.com/	\N	\N
BX 393	BULBS	13	Moraea villosa	Mike Mace	form a+	http://growingcoolplants.blogspot.com/	\N	\N
BX 393	BULBS	14	Moraea villosa	Mike Mace	form b	http://growingcoolplants.blogspot.com/	\N	\N
BX 393	BULBS	15	Moraea villosa	Mike Mace	form c	http://growingcoolplants.blogspot.com/	\N	\N
BX 393	BULBS	16	Moraea villosa	Mike Mace	form f	http://growingcoolplants.blogspot.com/	\N	\N
BX 393	BULBS	17	Moraea villosa	Mike Mace	form g	http://growingcoolplants.blogspot.com/	\N	\N
BX 393	BULBS	18	Moraea villosa	Mike Mace	form h	http://growingcoolplants.blogspot.com/	\N	\N
BX 393	BULBS	19	Moraea villosa	Mike Mace	mixed colors	\N	\N	\N
BX 393	BULBS	20	Romulea citrina	Mike Mace		\N	\N	\N
BX 393	BULBS	21	Romulea komsbergensis	Mike Mace		\N	\N	\N
BX 393	BULBS	22	Romulea luteiflora	Mike Mace		\N	\N	\N
BX 393	BULBS	23	Notholirion thomsonianum	Jane McGary		\N	\N	\N
BX 393	BULBS	24	Triteleia peduncularis	Jane McGary		\N	\N	\N
BX 394	BULBS	1	Hyacinthoides hispanica subsp. algeriensis	Fausto Ceni	(H. cedretorum)	\N	\N	Bulbs
BX 394	SEEDS	2	Amaryllis belladonna	Mary Sue Ittner		\N	\N	Seeds
BX 394	SEEDS	3	Zinkowski Nerine 'Wombe' x 'Carmenita'	Mary Sue Ittner	 - light pink small ruffled flowers that are darker pink in bud and on the back, but open pollinated - very few seeds	http://www.pacificbulbsociety.org/pbswiki/index.php/NerineZinkowskiHybrids	\N	Seeds
BX 394	SEEDS	4	Zinkowski Nerine hybrids	Mary Sue Ittner	(mostly sarniensis heritage) - open pollinated	\N	\N	Seeds
BX 394	BULBS	5	Barnardia japonica	John Willis	ex BX 355	\N	\N	Bulbs
BX 394	SEEDS	6	Narcissus viridiflorus	Arnold Trachtenberg	(FEW)	\N	\N	Seed
BX 394	SEEDS	7	Hippeastrum iguazuanum	Andres Pontieri	(priority will go to those who did not receive this species in an earlier BX)	\N	\N	Seed
BX 394	SEEDS	8	Ipheion uniflorum 'Rolf Fiedler'	Andres Pontieri		\N	\N	Seed
BX 394	SEEDS	9	Albuca sp	Uli Urban	.: tall white inflorescence, large fleshy green bulbs above soil level, evergreen with attractive shiny green leaves, spring flowering.	\N	\N	\N
BX 394	SEEDS	10	Hippeastrum aulicum f. robustum	Uli Urban	A firm favourite of 19th century Germany but now nowhere available. Flowers around Christmas (this year much earlier, hence the ripe seed now) almost evergreen with a rest in summer, new growth starts in late summer. The seed is fresh, harvested by a friend for the PBS. I recommend the water flotation method for germination.	\N	\N	\N
BX 394	SEEDS	11	Nerine alta	Uli Urban	(?) (N. undulata) The identity is not certain, grown from seed from D. Human. Smaller but more frilled flowers than N. bowdenii, bright pink, large inflorescence. Very hardy, summer growing autumn flowering.	\N	\N	\N
BX 394	SEEDS	12	Nerine bowdenii	Uli Urban	ex Mr. Oswald. A hardy selection from former East Germany, very reliable and floriferous, typical N. bowdenii flowers. quite hardy with protection from winter wet. Summer growing and autumn flowering. Hardiness to both Nerines applies to adult bulbs, seedling bulbs should be kept frost free in winter until about egg size.	\N	\N	\N
BX 394	SEEDS	13	Tradescantia boliviana	Uli Urban	: 60 to 70cm tall upright tuberous perennial, this is NOT a trailing Tradescantia. bright pink flowers for a long time in summer all along the shoots, much loved by bees. When I saw it for the very first time, I mistook it for a somewhat strange looking Lythrum salicaria at first glance. Needs a strictly dry winter rest, the tubers will rot otherwise. Not hardy. Needs to be grown in as much full sun as possible with good water supply in summer otherwise it will fall over.	\N	\N	\N
BX 398	BULBS	5	Cyrtanthus sanguineus	Monica Swartz	ex BX 280	\N	\N	\N
BX 398	BULBS	6	Cyrtanthus elatus x montanus	Monica Swartz	ex BX 202	\N	\N	\N
BX 398	BULBS	7	Hippeastrum blossfeldiae	Monica Swartz	ex BX 220	\N	\N	\N
BX 400	SEEDS	23	Zephyranthes 'Sunset Strain'	Ina Crossley	\N	\N	\N	\N
BX 340	BULBS	1	Haemanthus albiflos	Marvin Ellenbecker	\N	\N	\N	Smallish bulbs
BX 394	SEEDS	14	Tropaeolum pentaphyllum subsp. megapetalum	Uli Urban	summer growing tall climber can go up several meters. Curtains of nice flowers in late summer with two bright red Mickey-Mouse-Ears. Forms very large carrot like tubers, needs a frost free fairly dry winter rest. Seeds sometimes does not germinate easily, best kept at fluctuating temperatues with immediate sowing after an overnight soak in lukewarm water. So do not throw away the pot too early. Will not flower the first year from seed.	\N	\N	\N
BX 395	SEEDS	1	Nerine sarniensis	Nhu Nguyen	hybrids	\N	\N	\N
BX 395	SEEDS	2	Nerine undulata	Nhu Nguyen	- open pollinated	\N	\N	\N
BX 395	BULBS	3	Sparaxis tricolor	Nhu Nguyen		\N	\N	\N
BX 395	BULBS	4	Oxalis brasiliensis	Nhu Nguyen		\N	\N	\N
BX 395	BULBS	5	Dichelostemma multiflorum	Nhu Nguyen		\N	\N	\N
BX 395	BULBS	6	Dichelostemma congestum	Nhu Nguyen		\N	\N	\N
BX 395	BULBS	7	Brodiaea filifolia	Nhu Nguyen		\N	\N	\N
BX 395	BULBS	8	Synandrospadix vermitoxicus	Nhu Nguyen	(only 2)	\N	\N	\N
BX 395	BULBS	9	Muscari comosum	Nhu Nguyen	(Leipoldtia comosa)	\N	\N	\N
BX 395	BULBS	10	Cyrtanthus elatus x montanus	Nhu Nguyen		\N	\N	\N
BX 395	BULBS	11	Unidentified	Nhu Nguyen	Grab bag various bulbs (unidentified)	\N	\N	
BX 395	BULBS	12	Achimenes 'George Houche'	Nhu Nguyen		\N	\N	\N
BX 395	BULBS	13	Achimenes 'Rose Frost'	Nhu Nguyen		\N	\N	\N
BX 395	BULBS	14	Achimenes 'Rose Elf'	Nhu Nguyen		\N	\N	\N
BX 395	BULBS	15	Achimenes 'Grape Wine'	Nhu Nguyen		\N	\N	\N
BX 395	BULBS	16	Achimenes 'Meissner Porzellan'	Nhu Nguyen		\N	\N	\N
BX 395	BULBS	17	Achimenes 'Apple Blossom'	Nhu Nguyen		\N	\N	\N
BX 395	BULBS	18	Achimenes 'Amie Saliba'	Nhu Nguyen		\N	\N	\N
BX 395	BULBS	19	Achimenes 'Desiree'	Nhu Nguyen		\N	\N	\N
BX 395	BULBS	20	xSmithocodonia 'Heartland's Joy'	Nhu Nguyen		\N	\N	\N
BX 395	BULBS	21	Hippeastrum 'Happy Garden'	Aad van Beek	Bulblets (1 - 4 cm) of Hippeastrum garden hybrids	\N	\N	\N
BX 395	BULBS	22	Hippeastrum 'Yellow Garden'	Aad van Beek	Bulblets (1 - 4 cm) of Hippeastrum garden hybrids	\N	\N	\N
BX 395	BULBS	23	Hippeastrum 'Striped Garden'	Aad van Beek	Bulblets (1 - 4 cm) of Hippeastrum garden hybrids	\N	\N	\N
BX 395	BULBS	24	Hippeastrum 'Pink Garden'	Aad van Beek	Bulblets (1 - 4 cm) of Hippeastrum garden hybrids	\N	\N	\N
BX 395	BULBS	25	Hippeastrum 'White Garden'	Aad van Beek	Bulblets (1 - 4 cm) of Hippeastrum garden hybrids	\N	\N	\N
BX 395	BULBS	26	Sinningia warmingii	Dell Sherk	Seedling tubers	\N	\N	\N
BX 396	BULBS	1	Habranthus tubispathus	Rimmer de Vries	ex Jim Shields	\N	\N	Seedling bulbs
BX 396	BULBS	2	Haemanthus albiflos	Rimmer de Vries	one-year bulblets; self-polinated; some fuzzy, some smooth	\N	\N	\N
BX 396	SEEDS	3	Phaedranassa cinerea	Rimmer de Vries	OP, leaves, petioles, and scapes somewhat glaucous, ex BX 347	\N	\N	Seed
BX 396	BULBS	4	Achimenes pedunculata	Rimmer de Vries	ex BX 357	\N	\N	Stem bulbils
BX 396	BULBS	5	Clinanthus variegatus	Rimmer de Vries	apricot, ex Telos	\N	\N	Offsets
BX 396	BULBS	6	Bessera elegans	Fred Biasella	red	\N	\N	Small bulbs
BX 396	BULBS	7	Eucomis comosa	Fred Biasella	green/white	\N	\N	Bulbs
BX 396	BULBS	8	Zephyranthes sp	Fred Biasella	.?, possibly Z. candida; white flowers, grasslike foliage; offsets like mad!	\N	\N	Small bulbs
BX 396	BULBS	9	Cyrtanthus suaveolens	Fred Biasella		\N	\N	Small bulbs
BX 396	SEEDS	10	Pamianthe peruviana	Paul Matthews		\N	\N	Seed
BX 396	SEEDS	11	Eucrosia mirabilis	Nick Plummer		\N	\N	Seed
BX 396	BULBS	12	Gloxinella lindeniana	Dennis Kramb		\N	\N	Rhizomes
BX 397	BULBS	1	Eucrosia bicolor	Monica Swartz BULBS		\N	\N	\N
BX 397	BULBS	2	Cyrtanthus brachyscyphus	Monica Swartz BULBS		\N	\N	\N
BX 397	SEEDS	3	Haemanthus albiflos	Mary Sue Ittner		\N	\N	\N
BX 397	BULBS	4	Oxalis sp	Mary Sue Ittner	. L 96/42- summer growing from Mexico, Plant now in northern hemisphere. See wiki for photos:	http://www.pacificbulbsociety.org/pbswiki/index.php/MiscellaneousOxalis#sp	s	\N
BX 397	BULBS	5	Oxalis bowiei	Mary Sue Ittner	- Winter growing: plant late summer northern hemisphere	\N	w	\N
BX 397	BULBS	6	Oxalis callosa	Mary Sue Ittner	- Winter growing: plant late summer northern hemisphere	\N	w	\N
BX 397	BULBS	7	Oxalis commutata	Mary Sue Ittner	- Winter growing: plant late summer northern hemisphere	\N	w	\N
BX 397	BULBS	8	Oxalis depressa	Mary Sue Ittner	MV4871 - Winter growing: plant late summer northern hemisphere	\N	w	\N
BX 397	BULBS	9	Oxalis engleriana	Mary Sue Ittner	- Winter growing: plant late summer northern hemisphere	\N	w	\N
BX 397	BULBS	10	Oxalis flava	Mary Sue Ittner	(yellow) - Winter growing: plant late summer northern hemisphere	\N	w	\N
BX 397	BULBS	11	Oxalis hirta 'Gothenburg'	Mary Sue Ittner	(very large bulbs) - Winter growing: plant late summer northern hemisphere	\N	w	\N
BX 397	BULBS	12	Oxalis hirta	Mary Sue Ittner	(mauve) - Winter growing: plant late summer northern hemisphere	\N	w	\N
BX 397	BULBS	13	Oxalis hirta	Mary Sue Ittner	(pink) - Winter growing: plant late summer northern hemisphere	\N	w	\N
BX 397	BULBS	14	Oxalis sp	Mary Sue Ittner	. MV4674 (commutata?) - Winter growing: plant late summer northern hemisphere	\N	w	\N
BX 397	BULBS	15	Oxalis obtusa	Mary Sue Ittner	MV6341 - Winter growing: plant late summer northern hemisphere	\N	w	\N
BX 397	BULBS	16	Tulipa turkestanica	Mary Sue Ittner		\N	w	\N
BX 398	BULBS	1	Clivia sp.	Rimmer de Vries	yellow Clivia sp.: 1 yr old seedings (VERY FEW) These are all Type 1 yellow clivia- that means they always make yellow seedlings no matter what pollen parent you use. The pale yellow flower flower is rather large and loose.	\N	\N	\N
BX 398	BULBS	2	Clivia sp.	Rimmer de Vries	yellow Clivia sp.: 3 yr old seedlings (FEW) These are all Type 1 yellow clivia- that means they always make yellow seedlings no matter what pollen parent you use. The pale yellow flower flower is rather large and loose.	\N	\N	\N
BX 398	BULBS	3	Ornithogalum caudatum	Rimmer de Vries	(Albuca bracteata) (FEW) half-inch bulb offsets	\N	\N	\N
BX 398	SEEDS	4	Clivia hyb	Rimmer de Vries	Salmon D4- Apricot D6 color, salmon colored fruits, ex Maris Andersons. (VERY FEW)	\N	\N	Seeds
BX 398	BULBS	8	Spathantheum orbignyanum	Uli Urban	a deciduous Aroid from Bolivia. It is incredibly prolific. This plant produces large leaves in summer similar to those of Acanthus. The flowers appear before the leaves and look like a long-stemmed thin leaf, only if you look at the underside one will see it is in fact a flower. The smell is strange, not on the pleasant side.... It likes full sun and lots of water and fertilize when in growth and takes a totally dry rest in winter, easy to grow.	\N	\N	Tubers
BX 398	BULBS	9	Lachenalia rubida var. bulbifera	Uli Urban	A nice and easy to grow plant, the bulbili are fresh and were harvested today. It is a winter growing plant with early spring flowers.	\N	\N	Bulbili
BX 398	SEEDS	10	Hippeastrum vittatum	Ralph Carpenter		\N	\N	Seeds
BX 398	SEEDS	11	Hippeastrum blossfeldiae	Ralph Carpenter		\N	\N	Seeds
BX 399	BULBS	1	Massonia pustulata	From Rimmer de Vries	bulbs from BX 337 donor's mother plant from Jim Digger had purple leaves, these don't	\N	\N	\N
BX 399	BULBS	2	Massonia echinata	From Rimmer de Vries	bulbs from NARGS 13 #1684, bright green leaves smallish white flowers with yellow pollen.	\N	\N	\N
BX 399	BULBS	3	Massonia hyb	From Rimmer de Vries	. came as depressa from NARGS 13 #1683 but not, big wide leaves,	\N	\N	\N
BX 399	BULBS	4	Albuca humilis	From Rimmer de Vries	ex JCA 15856 Drakensburg Mtns. from NARGS 2012-#83	\N	\N	Small bulbs
BX 399	BULBS	5	Habranthus hyb 'Jumbo Purple'	From Rimmer de Vries	offsets	\N	\N	\N
BX 399	BULBS	6	Haemanthus pauculifolius	From Rimmer de Vries	seedlings 2 yrs old	\N	\N	\N
BX 399	SEEDS	7	Clivia 'Sahin Twins'	From Rimmer de Vries	- deep red with big red berries, 'twins' means in ideal situations it blooms 2x a year.	\N	\N	Seeds
BX 399	BULBS	8	Drimia haworthioides	Monica Swartz	ex Huntington Botanic Gardens Collection #49314, this fun and easy plant has bulb scales that look like the leaves of a Haworthia when planted at the surface, then it grows fur-edged leaves in winter (they should be dying back now). One of my most requested plants. Doesn't mind year-round water with good drainage. Seems quite freeze hardy in my 8b climate but I have yet to try it in the ground. If one of the loose scales falls off, it will make bulblets on its edges if lightly buried.	\N	\N	Small bulbs
BX 399	BULBS	9	Cyrtanthus mackenii	Monica Swartz	ex Buried Treasures, yellow or orange flowered	\N	\N	Small bulbs
BX 399	BULBS	10	Hippeastrum vittatum	Dell Sherk		\N	\N	Small bulbs
BX 306	SEEDS	3	Schizocarphus nervosa (Syn. Scilla nervosa)	Pieter van der Walt	W/C Broederstroom, Gauteng	\N	\N	\N
BX 317	SEEDS	32	Dierama	M Gastil-Buhl	more than 5ft tall, white from UCSB seed in 1990s	http://www.flickr.com/photos/gastils_garden/7475678760/in/set-72157630359362966/	\N	\N
BX 317	SEEDS	40	Tecophilaea cyanocrocus Violacea	M Gastil-Buhl	ex Brent&Beckys	http://www.flickr.com/photos/gastils_garden/6783157906/in/set-72157630359362966/	\N	\N
BX 317	SEEDS	33	Freesia laxa	M Gastil-Buhl	blue	http://www.flickr.com/photos/gastils_garden/6315424747/in/set-72157630359362966/	\N	\N
BX 317	SEEDS	30	Camassia leichtlinii	M Gastil-Buhl	white-cream, single, tall, from McL&Z mid 1990s	http://www.flickr.com/photos/gastils_garden/7474112118/in/set-72157630359362966/	w	\N
BX 317	SEEDS	31	Chasmanthe	M Gastil-Buhl	(either bicolor or floribunda) blooms Nov-Dec; weedy	http://www.flickr.com/photos/gastils_garden/7475677028/in/set-72157630359362966/	w	\N
BX 317	SEEDS	34	Lachenalia	M Gastil-Buhl	unidentified, blue-purple with violet marks, likely L. unicolor	http://www.flickr.com/photos/gastils_garden/6929275915/in/set-72157630359362966/	w	\N
BX 317	SEEDS	35	Romulea	M Gastil-Buhl	tentatively identified as R. linaresii from photos; ID not confirmed	http://www.flickr.com/photos/gastils_garden/6787563018/in/set-72157630359362966/	w	\N
BX 317	SEEDS	36	Romulea ramiflora	M Gastil-Buhl	(identified from photos)	http://www.flickr.com/photos/gastils_garden/6868404750/in/set-72157630359362966/	w	\N
BX 317	SEEDS	37	Scilla hyacinthoides	M Gastil-Buhl	up to 5 ft tall from UCSB	http://www.flickr.com/photos/gastils_garden/7011797475/in/set-72157630359362966/	w	\N
BX 317	SEEDS	38	Scilla peruviana	M Gastil-Buhl	\N	http://www.flickr.com/photos/gastils_garden/6929278745/in/set-72157630359362966/	w	\N
BX 317	SEEDS	39	Sparaxis tricolor hybrid	M Gastil-Buhl	ex UCSB, dk velvet red with yellow+black markings	http://www.flickr.com/photos/gastils_garden/6866214878/in/set-72157630359362966/	w	\N
BX 317	SEEDS	41	Tropaeolum hookerianum subsp. austropurpureum	M Gastil-Buhl	ex Telos	http://www.flickr.com/photos/gastils_garden/7014515067/in/set-72157630359362966/	w	\N
BX 325	SEEDS	35	Camassia leichtlini v. suksdorfi	Gene Mirro	90: very vigorous, tall dark blue from Linn County, OR. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/motie42/camassialeichtvsuks_zpse7a6323b.jpg	\N	\N
BX 325	SEEDS	37	Camassia quamash ssp azurea	Gene Mirro	light blue form; grows near Chehalis, WA. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/motie42/camassiaquamashazurea_zpsf9b594dd.jpg	\N	\N
BX 327	SEEDS	14	Galtonia regalis	Sylvia Sykora	\N	\N	\N	Seeds
BX 327	SEEDS	15	Zigadenus venosus	Richard Haard	\N	\N	\N	Bulblets
BX 327	SEEDS	16	Fritillaria camschatensis	Richard Haard	\N	\N	\N	Seeds
BX 327	SEEDS	17	Veratrum californicum	Richard Haard	\N	\N	\N	Seed
BX 327	SEEDS	18	Pinellia pedatisecta	Jerry Lehmann	\N	\N	\N	Seedling tubers
BX 327	SEEDS	19	Albuca namaquensis	Kipp McMichael	\N	\N	\N	\N
BX 327	SEEDS	20	Daubenya comata	Kipp McMichael	\N	\N	\N	\N
BX 327	SEEDS	21	Massonia depressa	Kipp McMichael	several forms	\N	\N	\N
BX 327	SEEDS	22	Massonia pustulata	Kipp McMichael	purple and mostly purple	\N	\N	\N
BX 327	SEEDS	23	Orbea variegata	Kipp McMichael	\N	\N	\N	\N
BX 327	SEEDS	24	Ornithogalum fimbrimarginatum	Kipp McMichael	ex Steve Hammer	\N	\N	\N
BX 328	SEEDS	1	Lilium parvum	Nhu Nguyen	- Sp WC, Nevada Co., CA about 5000ft (1500m), stratification recommended.	\N	Sp	\N
BX 328	SEEDS	2	Lilium sp. (washingtonianum?)	Nhu Nguyen	- Sp WC, Nevada Co., CA about 3500ft (~1000). I found this only in seed so no guarantee of the actual species, but based on location and elevation, it could very well be L. washingtonianum. Stratification recommended although probably not necessary.	\N	Sp	\N
BX 325	SEEDS	39	Dichelostemma ida-maia	Gene Mirro	All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/motie42/dichelostemmaida-maia_zpse3bdc762.jpg	\N	\N
BX 325	SEEDS	41	Lilium bulbiferum croceum	Gene Mirro	1052: blooms early summer; 2 feet tall; upfacing red/orange flowers; needs summer water; does not make stem bulbils. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/motie42/bulbiferumcroceum_zps470c79f5.jpg	\N	\N
BX 325	SEEDS	42	Lilium canadense	Gene Mirro	15: blooms midsummer; 3 - 4 feet tall; downfacing red/yellow flowers; needs summer water. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/motie42/IMG_5772small_zps5d5da273.jpg	\N	\N
BX 325	SEEDS	49	Notholirion bulbuliferum	Gene Mirro	193: blooms early summer; 3 - 4 feet tall; monocarpic. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/motie42/notholirionbulbuliferum_zps6b75ed8f.jpg	\N	\N
BX 325	SEEDS	51	Tritelia bridgesi	Gene Mirro	111: All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/motie42/triteliabridgesi_zpsbb48417b.jpg	\N	\N
BX 326	BULBS	1	Ledebouria socialis 'paucifolia'	Nhu Nguyen	- SU this is what has been passed around as 'Ledebouria paucifolia'. It is slower growing than the other socialis form but it makes cute little leaves when grown bright and cool.	\N	s	\N
BX 326	BULBS	2	Ledebouria socialis	Nhu Nguyen	- SU with mild cross stripes, but the stripes are more evident under certain growing conditions	\N	s	\N
BX 326	BULBS	3	Romulea hirta	Nhu Nguyen	- W grown from seeds through the BX in 2008.	\N	w	\N
BX 326	BULBS	4	Lachenalia unifolia	Nhu Nguyen	- W grown from Silverhill Seeds	\N	w	\N
BX 326	BULBS	5	Fritillaria affinis	Nhu Nguyen	- W little maggot-like offsets from a robust pupping form from Marin Co. Originally wild collected.	http://pacificbulbsociety.org/pbswiki/files/Fritillaria/Fritillaria_affinis2/	w	\N
BX 326	BULBS	6	Oxalis cathara	Nhu Nguyen	- W	\N	w	\N
BX 326	BULBS	7	Oxalis glabra	Nhu Nguyen	- W	\N	w	\N
BX 326	BULBS	8	Oxalis bowiae	Nhu Nguyen	- W	\N	w	\N
BX 326	BULBS	9	Moraea aristata	Nhu Nguyen	- W	\N	w	\N
BX 326	BULBS	10	Lilium bulbiferum	Gene Mirro	1066: blooms early summer; 2 feet tall; upfacing red/orange flowers; needs summer water; originally collected in the Austrian Alps.	http://i232.photobucket.com/albums/ee69/motie42/bulbiferum_zps7ccf419b.jpg	\N	\N
BX 326	BULBS	11	Lilium lancifolium	Gene Mirro	diploid form, orange: blooms midsummer; 3 - 6 feet tall; downfacing orange flowers; needs summer water.	\N	\N	\N
BX 326	BULBS	12	Lilium lancifolium	Gene Mirro	diploid form, yellow: blooms midsummer; 3 - 6 feet tall; downfacing yellow flowers; needs summer water.	\N	\N	\N
BX 326	BULBS	13	Lilium sulphureum	Gene Mirro	1469 bulbils: blooms late summer; 5 - 8 ft. tall, large fragrant flowers with white/yellow inside, white/purple outside; strong straight stems; lives 15 years or more; needs summer water.	\N	\N	\N
BX 326	BULBS	14	Lilium sulphureum	Gene Mirro	1139 bulbils: blooms late summer; 5 - 8 ft. tall, large fragrant flowers with white/green inside, white/purple outside; strong straight stems; needs summer water; purple stem bulbils.	http://i232.photobucket.com/albums/ee69/motie42/sulph1139_zps217d838f.jpg	\N	\N
BX 326	BULBS	15	Lilium sulphureum	Gene Mirro	1189 bulbils: blooms late summer; 5 - 8 ft. tall, large fragrant flowers with white/yellow inside, white/purple outside; strong straight stems; needs summer water; green stem bulbils.	\N	\N	\N
BX 326	BULBS	16	Fritillaria recurva	Mary Sue Ittner	\N	\N	\N	Small bulbs
BX 326	BULBS	17	Fritillaria glauca	Mary Sue Ittner	\N	\N	\N	Small bulbs
BX 326	BULBS	18	Chlorogalum pomeridianum	Kipp Mc Michael	. From seed collected on Mt Diablo, Contra Costa County, California	\N	\N	Small bulbs
BX 326	BULBS	19	Massonia pustulata	Kipp Mc Michael	solid purple or mostly purple leaves	\N	\N	Small bulbs
BX 326	BULBS	20	Camassia leichtlinii var suksdorfi	Richard Haard	violet to bluish flowers, Field-grown bulbs from farm produced seed, Willamette Valley, OR	\N	\N	Bulbs
BX 326	BULBS	21	Dichelostemma congestum	Richard Haard	grown from wild-collected seed, Josephine County, OR	\N	\N	Bulbils
BX 326	BULBS	22	Babiana rubrocyanea	Richard Wagner	Initially listed as ? and later corrected.	\N	\N	Corms
BX 327	SEEDS	1	Lapiedra martinezii	Guy L'Eplattenier	I grow them in my garden at El Perelló, Cataluña, spanish med. coast, but they come from along the road to Cabo de La Nao, Javea, Provincia de Alicante, where they grow in clumps under Pinus Halepensis. ( they also grow in full sunshine in the cliffs next to the sea, but more one by one)I have them here half shade under the same pine trees and little by little they form a nice group of 20/30 bulbs now.They naturalize and I put more in various places.They have nice dark green leaves with a silvery midrib, they disappear beginning of the summer and white stary flowers begin blooming end of the summer ( same time as Urginea Maritima) , then rapidly form black seeds to get them ready for the october rains.They are highly drought resistant , wind resistant, salt resistant and cold resistant till -5 celsius... but maybe on the dry side... quite an interesting jewel for mediterranean gardens, in fact. Seeds do germinate easily.	\N	\N	Seed
BX 327	SEEDS	2	Crocosmia 'Lucifer'	Rich Hart	\N	\N	\N	Seed
BX 327	SEEDS	3	Datura sp.	Rich Hart	Moonflower'	\N	\N	Seed
BX 327	SEEDS	4	Rhodophiala bifida	Mark Wilcox	from Alberto Castillo's 2008 donation to the BX	\N	\N	Seed
BX 327	SEEDS	5	Ipheion hirtellum	Gordon Julian	ex hort	\N	\N	Seed
BX 327	SEEDS	6	Arum cyrenaicum	Angelo Porcelli	\N	\N	\N	\N
BX 327	SEEDS	7	Habranthus correntinus	Angelo Porcelli	\N	\N	\N	\N
BX 327	SEEDS	8	Habranthus martinezii	Angelo Porcelli	\N	\N	\N	\N
BX 327	SEEDS	9	Lilium bulbiferum ssp croceum	Angelo Porcelli	\N	\N	\N	\N
BX 327	SEEDS	10	Pancratium illyricum	Angelo Porcelli	\N	\N	\N	\N
BX 327	SEEDS	11	Sternbergia lutea	Angelo Porcelli	\N	\N	\N	\N
BX 327	SEEDS	12	Zephyranthes primulina	Angelo Porcelli	\N	\N	\N	\N
BX 327	SEEDS	13	Galtonia candicans	Sylvia Sykora	\N	\N	\N	Seeds
BX 328	SEEDS	3	Calochortus luteus	Nhu Nguyen	NNBH2503 - W WC, Calaveras Co., about 650ft (200m). From a friend's property. This form is supposed to have a nice and dark marking in the center.	\N	w	\N
BX 328	SEEDS	4	Bomarea acutifolia	Nhu Nguyen	- OP this species comes from Mexico and Central America. It likes to be slightly warmer than other species of Bomarea but grows fine in the Bay Area. This species can grow year-round in moderate winter areas, although much slower in winter and more vigorous in spring and summer. It is said that the seeds cannot dry out completely so I packed them into barely moist peat for distribution. NOT RECOMMENDED for Hawaii, New Zealand, Australia and other areas prone to invasive plants. These produce beautiful red seeds that are easily dispersed by birds, thus can spread.	\N	\N	\N
BX 328	SEEDS	5	Allium dichlamydeum	Nhu Nguyen	- W OP	\N	w	\N
BX 328	SEEDS	6	Allium hyalinum	Nhu Nguyen	pink - W OP	\N	w	\N
BX 328	SEEDS	7	Allium sanbornii	Nhu Nguyen	- W OP	\N	w	\N
BX 328	SEEDS	8	Dichelostemma multiflorum	Nhu Nguyen	- W OP	\N	w	\N
BX 328	SEEDS	9	Lachenalia aloides	Nhu Nguyen	v. aurea - W OP	\N	w	\N
BX 328	SEEDS	10	Cyrtanthus brachyscyphus	Nhu Nguyen	- W CP	\N	w	\N
BX 328	SEEDS	11	Ornithogalum fimbrimarginatum	Nhu Nguyen	form (Steve? Hammer) - W CP	\N	w	\N
BX 328	SEEDS	12	Gladiolus alatus	Nhu Nguyen	- W CP	\N	w	\N
BX 328	SEEDS	13	Nerine bowdenii	Nhu Nguyen	- W OP	\N	\N	\N
BX 328	BULBS	14	Hippeastrum striatum	Nhu Nguyen	- S seed grown, very vigorously offset forms mixed together so there is a good chance that you will get a multiple clones from several bulblets.	\N	\N	\N
BX 328	BULBS	15	Allium unifolium	Nhu Nguyen	- W always a nice and reliable onion that blooms midspring and multiplies slowly but steadily.	\N	\N	\N
BX 328	BULBS	16	Allium amplectens	Nhu Nguyen	- W	\N	\N	\N
BX 328	SEEDS	17	Diplarrhena moraea	Kathleen Sayce SEEDS	parent is white flowered, selfed (no other Diplarrhenas for males)	\N	\N	\N
BX 328	SEEDS	18	Romulea autumnalis	Kathleen Sayce SEEDS	\N	\N	\N	\N
BX 328	SEEDS	19	Acis autumnalis	Kathleen Sayce SEEDS	syn. Leucojum autumnale	\N	\N	\N
BX 328	SEEDS	20	Haemanthus coccineus	Kipp McMichael	ex Arid Lands, Outshoorn	\N	\N	Seeds
BX 328	SEEDS	21	Dichelostemma capitatum	Kipp McMichael	from San Francisco serpentine	\N	\N	Bulblets
BX 328	SEEDS	22	Ornithogalum fimbrimarginatum	Kipp McMichael	\N	\N	\N	Seed
BX 329	SEEDS	1	Rhodophiala bifida	Tony Avent and Plants Delights Nursery	carmine	\N	\N	Seed
BX 329	SEEDS	2	Lilium leichtlinii	Tony Avent and Plants Delights Nursery	var maximowiczh ?	\N	\N	Seed
BX 329	SEEDS	3	Crinum	Tony Avent and Plants Delights Nursery	PDN#015 [(C. forb x mac) x (mac x acaule)] - already germinating	\N	\N	Seed
BX 329	SEEDS	4	Crinum variabile	Tony Avent and Plants Delights Nursery	(already germinating)	\N	\N	Seed
BX 329	BULBS	5	Ismene 'Festalis'	Kathleen Sayce	\N	\N	\N	ONE bulb
BX 329	BULBS	6	Albuca nelsonii	Kathleen Sayce	from BX 301 ex Pam Slate	\N	\N	ONE bulb
BX 329	SEEDS	7	Cardiocrinum giganteum	Paige Woodward	\N	\N	\N	Seed
BX 329	SEEDS	8	Cardiocrinum cordatum var glehnii	Paige Woodward	\N	\N	\N	Seed
BX 329	SEEDS	9	Allium subhirsutum	Donald Leevers	\N	\N	\N	\N
BX 329	SEEDS	10	Anomatheca laxa	Donald Leevers (Seeds)	\N	\N	\N	\N
BX 329	SEEDS	11	Gladiolus tristis	Donald Leevers (Seeds)	\N	\N	\N	\N
BX 329	SEEDS	12	Habranthus martinezii	Donald Leevers (Seeds)	\N	\N	\N	\N
BX 329	SEEDS	13	Habranthus brachyandrus	Donald Leevers (Seeds)	\N	\N	\N	\N
BX 329	SEEDS	14	Habranthus andersonii	Donald Leevers (Seeds)	\N	\N	\N	\N
BX 329	SEEDS	15	Lilium candidum	Donald Leevers (Seeds)	\N	\N	\N	\N
BX 329	SEEDS	16	Ornithogalum caudatum	Donald Leevers (Seeds)	\N	\N	\N	\N
BX 329	SEEDS	17	Pancratium maritimum	Donald Leevers (Seeds)	\N	\N	\N	\N
BX 329	SEEDS	18	Tulbaghia maritima	Donald Leevers (Seeds)	\N	\N	\N	\N
BX 329	SEEDS	19	Urginea maritima	Donald Leevers (Seeds)	\N	\N	\N	\N
BX 329	SEEDS	20	Watsonia latifolia	Donald Leevers (Seeds)	\N	\N	\N	\N
BX 329	SEEDS	21	Zephyranthes reginae	Donald Leevers (Seeds)	\N	\N	\N	\N
BX 329	SEEDS	22	Allium obliquum	Roland de Boer (Seeds)	\N	\N	\N	\N
BX 329	SEEDS	23	Allium victorialis	Roland de Boer (Seeds)	form 1	\N	\N	\N
BX 329	SEEDS	24	Allium victorialis	Roland de Boer (Seeds)	form 2	\N	\N	\N
BX 329	SEEDS	25	Lilium columbianum	Roland de Boer (Seeds)	ex N. Rocky Mountains	\N	\N	\N
BX 329	SEEDS	26	Tropaeolum brachyceras	Roland de Boer (Seeds)	\N	\N	\N	\N
BX 400	SEEDS	1	Habranthus tubispathus	Ina Crossley	rosea	\N	\N	\N
BX 400	SEEDS	2	Habranthus tubispathus	Ina Crossley	variabile	\N	\N	\N
BX 400	SEEDS	3	Habranthus tubispathus	Ina Crossley	blue	\N	\N	\N
BX 400	SEEDS	4	Habranthus tubispathus	Ina Crossley	pale yellow - white	\N	\N	\N
BX 400	SEEDS	5	Habranthus sp.	Ina Crossley	blue	\N	\N	\N
BX 400	SEEDS	6	Habranthus robustus 'Russell Manning'	Ina Crossley	\N	\N	\N	\N
BX 400	SEEDS	7	Habranthus x floryi	Ina Crossley	green throat	\N	\N	\N
BX 400	SEEDS	8	Habranthus magnoi	Ina Crossley	\N	\N	\N	\N
BX 400	SEEDS	9	Habranthus brachyandrus	Ina Crossley	\N	\N	\N	\N
BX 400	SEEDS	10	Rhodophiala bakeri	Ina Crossley	apricot	\N	\N	\N
BX 400	SEEDS	11	Rhodophiala bifida	Ina Crossley	many flowers	\N	\N	\N
BX 400	SEEDS	12	Rhodophiala bifida	Ina Crossley	\N	\N	\N	\N
BX 400	SEEDS	13	Tigridia pavonia 'Sunset in Oz'	Ina Crossley	\N	\N	\N	\N
BX 400	SEEDS	14	Tigridia pavonia 'Alba'	Ina Crossley	\N	\N	\N	\N
BX 400	SEEDS	15	Zephyranthes fosteri	Ina Crossley	pink	\N	\N	\N
BX 400	SEEDS	16	Zephyranthes fosteri	Ina Crossley	white	\N	\N	\N
BX 400	SEEDS	17	Zephyranthes flavissima	Ina Crossley	\N	\N	\N	\N
BX 400	SEEDS	18	Zephyranthes sp.	Ina Crossley	ex Paul Niemi	\N	\N	\N
BX 400	SEEDS	19	Zephyranthes sp.	Ina Crossley	ex John Fellers	\N	\N	\N
BX 400	SEEDS	20	Zephyranthes 'Bangkok Pink'	Ina Crossley	\N	\N	\N	\N
BX 400	SEEDS	21	Zephyranthes jonesii	Ina Crossley	\N	\N	\N	\N
BX 400	SEEDS	22	Zephyranthes drummondii	Ina Crossley	\N	\N	\N	\N
BX 340	SEEDS	2	Freesia laxa	Marvin Ellenbecker	red and a few white	\N	\N	Seed
BX 340	SEEDS	3	Zephyranthes drummondii	Jonathan Lubar	ex Yucca Do 'San Carlos Form'	\N	\N	Seed
BX 340	SEEDS	4	Freesia laxa	Jonathan Lubar	ssp azurea	\N	\N	Seed
BX 340	SEEDS	5	Zephyranthes primulina	Jonathan Lubar	ex BX 298	\N	\N	Seed
BX 340	SEEDS	6	Drimia maritima	Stephen Gregg	(syn Urginea maritima), multiple spikes up to 1.5 m	\N	\N	Seed
BX 340	BULBS	7	Gladiolus flanaganii	Uli Urban	\N	\N	\N	Cormlets
BX 340	BULBS	8	Lachenalia bulbifera	Arnold Trachtenberg	\N	\N	\N	Small bulbs
BX 340	BULBS	9	Chasmanthe floribunda var. duckittii	Arnold Trachtenberg	(few)	\N	\N	Large corms
BX 340	BULBS	10	Moraea setifolia	Arnold Trachtenberg	(few)	\N	\N	Small corms
BX 340	SEEDS	11	Lachenalia nervosa	Arnold Trachtenberg	\N	\N	\N	Seed
BX 340	SEEDS	12	Colchicum	Arnold Trachtenberg	mixed spp/cvs, open pollinated	\N	\N	Seed
BX 340	BULBS	13	Allium canadense	Jerry Lehmann	ex Miami County, Kansas, pale pink	\N	\N	Bulbs
BX 340	SEEDS	14	Hippeastrum 'Red Lion'	Judy Glattstein	open-pollinated	\N	\N	Seed
BX 340	SEEDS	15	Boophane disticha	Kipp McMichael	\N	\N	\N	Seed
BX 340	BULBS	16	Chasmanthe	Shirley Meneice	Bulbils from that mystery Chasmanthe that grew to 6 feet. Someone on the PBS list suggested that members might be interested in them since the parent plant was so different from the standard variety.	\N	\N	Bulbils
BX 312	BULBS	1	Crinum x 'Menehune'	Joe Gray of Hines Horticultural	Growing plants of Crinum x 'Menehune'. This is a mostly aquatic crinum that	\N	\N	17 small bulbs (1 - 1.5 cm diameter)
BX 312	BULBS	2	Crinum x 'Menehune'	Joe Gray of Hines Horticultural	Growing plants of Crinum x 'Menehune'. This is a mostly aquatic crinum that	\N	\N	3 large bulbs (3 - 4 cm diameter) with offsets
BX 313	SEEDS	23.2	Tigridia pavonia mixed	Gordon Julian	Second item #23	\N	\N	\N
BX 311	SEEDS	1	Narcissus cantabricus 'Silver Palace'	Arnold Trachtenberg	(OP)	\N	\N	\N
BX 311	SEEDS	2	Narcissus cordubensis	Arnold Trachtenberg	? (OP)	\N	\N	\N
BX 311	SEEDS	3	Narcissus cantabricus clusii	Arnold Trachtenberg	? (OP)	\N	\N	\N
BX 311	SEEDS	4	Narcissus romieuxii mesatlanticus	Arnold Trachtenberg	? (OP)	\N	\N	\N
BX 311	SEEDS	5	Narcissus romieuxii 'Julia Jane'	Arnold Trachtenberg	(OP)	\N	\N	\N
BX 311	SEEDS	6	Narcissus assoanus minutus	Arnold Trachtenberg	? (OP)	\N	\N	\N
BX 311	SEEDS	7	Narcissus bulbocodium	Arnold Trachtenberg	(OP)	\N	\N	\N
BX 311	SEEDS	8	Gladiolus maculatus	Arnold Trachtenberg	\N	\N	\N	\N
BX 311	SEEDS	9	Massonia echinata	Arnold Trachtenberg	ex BX 247	\N	\N	\N
BX 311	SEEDS	10	Cyclamen coum 'Yayladgi'	Arnold Trachtenberg	(may only be shipped to US members because of CITES regulations). Yaylada is a city in Turkey near the Syrian border. 	http://pacificbulbsociety.org/pbswiki/index.php/CyclamenSpeciesOne#coum	\N	\N
BX 311	SEEDS	11	Cyrtanthus montanus x C. elatus	Robin Bell	\N	\N	\N	Small bulbs
BX 311	SEEDS	12	Lachenalia	Robin Bell	pink ex BX 183 (#21) possible hybrid?	\N	\N	Small bulbs
BX 311	SEEDS	13	Narcissus minor	Rimmer de Vries	hybs, parents include 'Weebee','Mite', 'Small Talk', etc.	\N	\N	Seed
BX 311	SEEDS	14	Polyxena	Rimmer de Vries	ex Silverhill 11152- from BX 240 previously from NARGS 07/08 donated by Mike Slater	\N	\N	Seed
BX 311	SEEDS	15	Scilla sp	Rimmer de Vries	? ex collected in Jebl Nusairi, Syria by R&R Wallis- previously donated to RHS LG by Alan Edwards of UK- I treat as tender in an unheated cold frame and they do well so maybe they are not so tender.	\N	\N	Seed
BX 311	SEEDS	16	Cyrtanthus hybrids	Jim Waddick	They seem close to CyrtanthusHybrids on the wiki but I have lost the label - or maybe these vigorous bulbs 'ate' the label. They are easy to grow, prolific and bloom easily. Color is bright orange red, Bulbs range from 'big blooming size' to mini starts. Mine grow in a sand based mix with irregular fertilizing and do well. 	http://www.pacificbulbsociety.org/pbswiki/index.php/CyrtanthusHybrids	\N	Bulbs
BX 336	SEEDS	9	Crinum herbertii	Lynn Makela	\N	\N	\N	\N
\.


--
-- Name: bx_dates bx_dates_pk; Type: CONSTRAINT; Schema: bx; Owner: gastil
--

ALTER TABLE ONLY bx.bx_dates
    ADD CONSTRAINT bx_dates_pk PRIMARY KEY (bx_id);


--
-- Name: bx_items bx_item_pk; Type: CONSTRAINT; Schema: bx; Owner: gastil
--

ALTER TABLE ONLY bx.bx_items
    ADD CONSTRAINT bx_item_pk PRIMARY KEY (bx_id, item);


--
-- PostgreSQL database dump complete
--

