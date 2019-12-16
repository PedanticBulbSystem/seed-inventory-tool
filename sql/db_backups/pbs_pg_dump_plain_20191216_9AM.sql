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
    bx_id character varying(7) NOT NULL,
    date_open date,
    date_close date,
    director_initials character varying(10)
);


ALTER TABLE bx.bx_dates OWNER TO gastil;

--
-- Name: bx_items; Type: TABLE; Schema: bx; Owner: gastil
--

CREATE TABLE bx.bx_items (
    bx_id character varying(7) NOT NULL,
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
-- Name: vw_abbrev_listing; Type: VIEW; Schema: bx; Owner: gastil
--

CREATE VIEW bx.vw_abbrev_listing AS
 SELECT bx_items.bx_id,
    bx_items.item,
    bx_items.taxon,
    bx_items.donor,
    "substring"((bx_items.category)::text, 1, 1) AS category_code
   FROM bx.bx_items
  ORDER BY bx_items.bx_id, bx_items.item;


ALTER TABLE bx.vw_abbrev_listing OWNER TO gastil;

--
-- Name: vw_date_open_n_items_for_graph; Type: VIEW; Schema: bx; Owner: gastil
--

CREATE VIEW bx.vw_date_open_n_items_for_graph AS
 SELECT ("substring"((d.bx_id)::text, 1, 6))::character varying(7) AS bx_id,
    d.date_open,
    max(i.item) AS max_item,
    count(*) AS n_items
   FROM (bx.bx_dates d
     LEFT JOIN bx.bx_items i ON (((d.bx_id)::text = (i.bx_id)::text)))
  WHERE ((d.bx_id)::text !~~ 'SX%'::text)
  GROUP BY d.date_open, ("substring"((d.bx_id)::text, 1, 6))
  ORDER BY ("substring"((d.bx_id)::text, 1, 6));


ALTER TABLE bx.vw_date_open_n_items_for_graph OWNER TO gastil;

--
-- Name: vw_donor_stats; Type: VIEW; Schema: bx; Owner: gastil
--

CREATE VIEW bx.vw_donor_stats AS
 SELECT i.donor,
    count(*) AS n_items,
    count(DISTINCT i.bx_id) AS n_bxs,
    count(DISTINCT i.taxon) AS n_taxa,
    count(DISTINCT i.category) AS n_categories,
    min(d.date_open) AS first_donation_date,
    max(d.date_open) AS last_donation_date
   FROM (bx.bx_items i
     JOIN bx.bx_dates d ON (((i.bx_id)::text = (d.bx_id)::text)))
  GROUP BY i.donor
  ORDER BY i.donor;


ALTER TABLE bx.vw_donor_stats OWNER TO gastil;

--
-- Name: vw_monthly_distrib_bulb_vs_seed; Type: VIEW; Schema: bx; Owner: gastil
--

CREATE VIEW bx.vw_monthly_distrib_bulb_vs_seed AS
 SELECT count(DISTINCT "substring"((i.bx_id)::text, 1, 6)) AS n_bx,
    date_part('month'::text, d.date_open) AS mon,
    min(date_part('quarter'::text, d.date_open)) AS qtr,
    count(*) AS n_items,
    i.category
   FROM (bx.bx_dates d
     JOIN bx.bx_items i ON (((d.bx_id)::text = (i.bx_id)::text)))
  WHERE (((d.bx_id)::text !~~ 'SX%'::text) AND ((d.bx_id)::text > 'BX 400'::text))
  GROUP BY (date_part('month'::text, d.date_open)), i.category
  ORDER BY i.category, (date_part('month'::text, d.date_open));


ALTER TABLE bx.vw_monthly_distrib_bulb_vs_seed OWNER TO gastil;

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
-- Name: vw_n_bx_per_month_qtr_below401; Type: VIEW; Schema: bx; Owner: gastil
--

CREATE VIEW bx.vw_n_bx_per_month_qtr_below401 AS
 SELECT count(DISTINCT "substring"((i.bx_id)::text, 1, 6)) AS n_bx,
    date_part('month'::text, d.date_open) AS mon,
    min(date_part('quarter'::text, d.date_open)) AS qtr,
    count(*) AS n_items
   FROM (bx.bx_dates d
     JOIN bx.bx_items i ON (((d.bx_id)::text = (i.bx_id)::text)))
  WHERE (((d.bx_id)::text !~~ 'SX%'::text) AND ((d.bx_id)::text < 'BX 401'::text))
  GROUP BY (date_part('month'::text, d.date_open))
  ORDER BY (date_part('month'::text, d.date_open));


ALTER TABLE bx.vw_n_bx_per_month_qtr_below401 OWNER TO gastil;

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
BX 401	2016-06-10	2016-06-11	ds
BX 402	2016-06-20	2016-06-21	ds
BX 403	2016-06-28	2016-06-30	ds
BX 404	2016-07-19	2016-07-20	ds
BX 405	2016-08-11	2016-08-12	ds
BX 406	2016-08-17	\N	ds
BX 407	2016-08-24	2016-08-25	ds
BX 408	2016-08-29	2016-08-30	ds
SX 6	2016-09-05	2016-09-15	ds
BX 409	2016-09-17	2016-09-19	ds
BX 410	2016-09-24	2016-09-26	ds
BX 411	2016-10-06	2016-10-08	ds
BX 412	2016-10-26	2016-10-27	ds
BX 413	2016-11-07	2016-11-08	ds
SX 7	2016-11-25	\N	ds
BX 414	2017-01-08	\N	ds
BX 415	2017-02-19	2017-02-20	ds
BX 416	2017-04-11	2017-04-12	ds
BX 417	2017-05-04	2017-05-05	ds
BX 418	2017-06-16	2017-06-17	ds
SX 8	2017-06-20	\N	ds
BX 419	2017-07-15	2017-07-16	ds
BX 420	2017-07-24	2017-07-26	ds
BX 421	2017-07-31	2017-08-01	ds
BX 422	2017-08-18	2017-08-18	ds
BX 423	2017-08-27	2017-08-28	ds
BX 424	2017-09-05	2017-09-06	ds
BX 425	2017-09-13	2017-09-14	ds
BX 426	2017-09-19	2017-09-20	ds
BX 427	2017-10-06	2017-10-07	ds
BX 428	2017-10-13	2017-10-14	ds
BX 429	2017-10-30	2017-10-31	ds
BX 430	2017-11-05	2017-11-06	ds
BX 431	2017-11-08	2017-11-09	ds
BX 432	2017-11-13	2017-11-13	ds
BX 433	2017-11-18	2017-11-19	ds
SX 9	2017-11-28	\N	ds
BX 434	2018-01-02	2018-01-03	as
BX 435	2018-01-14	2018-01-15	as
BX 436	2018-02-04	2018-02-04	as
BX 437	2018-03-27	2018-03-28	as
BX 438	2018-04-22	2018-04-23	as
BX 439	2018-05-08	2018-05-09	as
BX 440	2018-05-24	2018-05-23	as
SX 10	2018-06-12	2018-06-25	as
BX 441	2018-06-25	2018-06-26	as
BX 442	2018-06-30	2018-07-01	as
BX 443	2018-07-25	\N	as
BX 444	2018-08-05	2018-08-06	as
BX 445	2018-08-12	2018-08-13	as
BX 446	2018-08-27	2018-08-28	as
BX 447	2018-09-15	2018-09-16	as
BX 448	2018-09-22	2018-09-23	as
BX 449	2018-10-02	2018-10-03	as
BX 450	2018-10-15	2018-10-16	as
BX 451	2018-11-26	\N	as
BX 452	2018-12-08	2018-12-10	as
SX 11	2019-01-24	\N	as
BX 453	2019-01-24	2019-01-25	as
BX 454	2019-02-23	2019-02-24	as
BX 455	2019-04-02	\N	as
BX 456	2019-04-19	\N	as
BX 457	2019-05-09	\N	as
BX 458	2019-07-02	2019-07-05	as
BX 459	2019-07-05	2019-07-06	as
BX 460	2019-07-06	\N	as
BX 461	2019-07-22	\N	as
BX 462	2019-08-25	2019-08-26	as
BX 463b	2019-11-03	2019-11-06	jmg
BX 463s	2019-11-03	2019-11-06	jmg
\.


--
-- Data for Name: bx_items; Type: TABLE DATA; Schema: bx; Owner: gastil
--

COPY bx.bx_items (bx_id, category, item, taxon, donor, notes, photo_link, season, of) FROM stdin;
BX 301	SEEDS	1	Haemanthus albiflos	Richard Hart	\N	\N	\N	\N
BX 301	BULBS	2	Nerine laticoma	Ellen Hornig	\N	\N	\N	\N
BX 301	SEEDS	6	Nothoscordum bivalve	Jerry Lehmann	(few)	\N	\N	\N
BX 301	SEEDS	11	Aster macrophyllus	Jerry Lehmann	\N	\N	\N	\N
BX 301	SEEDS	14	Habranthus tubispathus var roseus	Ina Crossley	\N	\N	\N	\N
BX 301	SEEDS	15	Zephyranthes verecunda white	Ina Crossley	\N	\N	\N	\N
BX 301	SEEDS	16	Zephyranthes verecunda rosea	Ina Crossley	\N	\N	\N	\N
BX 301	SEEDS	17	Zephyranthes drummondii	Ina Crossley	\N	\N	\N	\N
BX 301	SEEDS	7	Iris versicolor	Jerry Lehmann	collected in Two Inlets, MN	\N	\N	\N
BX 302	BULBS	1	Amorphophallus albus	Bonaventure Magrys	Small tubers	\N	\N	\N
BX 302	BULBS	2	Amorphophallus bulbifer	Bonaventure Magrys	Small tubers	\N	\N	\N
BX 302	SEEDS	4	Ennealophus euryandrus	Lee Poulsen	\N	\N	\N	\N
BX 302	SEEDS	5	Cypella peruviana	Lee Poulsen	\N	\N	\N	\N
BX 302	SEEDS	6	Cypella coelestis	Lee Poulsen	\N	\N	\N	\N
BX 302	SEEDS	8	Bowiea volubilis	Kipp McMichael	\N	\N	\N	\N
BX 302	SEEDS	9	Habranthus tubispathus rosea	Ina Crossley	\N	\N	\N	\N
BX 302	SEEDS	10	Zephyranthes 'Hidalgo'	Ina Crossley	\N	\N	\N	\N
BX 302	SEEDS	11	Zephyranthes drummondii	Ina Crossley	\N	\N	\N	\N
BX 302	SEEDS	12	Zephyranthes lindleyana (morrisclintii)	Ina Crossley	\N	\N	\N	\N
BX 302	SEEDS	13	Zephyranthes primulina	Ina Crossley	\N	\N	\N	\N
BX 302	SEEDS	14	Zephyranthes verecunda rosea	Ina Crossley	\N	\N	\N	\N
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
BX 301	SEEDS	18	Hippeastrum calyptratum	Dave Boucher	\N	\N	\N	\N
BX 302	SEEDS	15	Freesia laxa, blue	M Gastil-Buhl	\N	\N	\N	\N
BX 303	SEEDS	10	Ceropegia ampliata	Fereydoun Sharifi	 (Asclepidaceae)	\N	\N	\N
BX 301	BULBS	4	Albuca nelsonii	Pamela Slate	\N	\N	\N	\N
BX 301	SEEDS	9	Liatris 'Kobold'	Jerry Lehmann	 in bloom at the same time as L. spicata 'Alba'	\N	\N	\N
BX 301	SEEDS	10	Liatris spicata 'Alba'	Jerry Lehmann	 in bloom at the same time as L. spicata 'Alba'	\N	\N	\N
BX 301	BULBS	13	Bessera elegans	Jerry Lehmann	Small	\N	\N	\N
BX 302	SEEDS	3	Larsenianthus careyanus	Fred Thorne	 (Zingiberaceae)	\N	\N	\N
BX 302	BULBS	7	Ipheion sessile	Lee Poulsen	Small bulbs	\N	\N	\N
BX 302	BULBS	16	Freesia laxa	M Gastil-Buhl	Corms/cormels, pale lavender blue	\N	\N	\N
BX 302	SEEDS	17	Biophytum sensitivum	Dennis Kramb	 (Oxalidaceae)	\N	\N	\N
BX 302	SEEDS	18	Gloxinella lindeniana	Dennis Kramb	 (Gesneriaceae)	\N	\N	\N
BX 302	SEEDS	19	Primulina tamiana	Dennis Kramb	 (Gesneriaceae), formerly Chirita tamiana	\N	\N	\N
BX 301	BULBS	5	Zephyranthes mixed	Pamela Slate	\N	\N	\N	\N
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
BX 304	BULBS	16	Achimenes 'Desiree'	Dennis Kramb	Propagules (aerial rhizomes)	\N	\N	\N
BX 304	BULBS	17	Eucrosia bicolor	Monica Swartz	Small bulbs	\N	\N	\N
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
BX 301	SEEDS	8	Anemone virginica	Jerry Lehmann	and/or A. cylindrica "Thimbleweed"; collected in Becker Co., MN	\N	\N	\N
BX 301	BULBS	12	Ornithogalum caudatum (longibracteatum), 	Jerry Lehmann	mix of two forms, Bulblets, one with rounder, more green leaves	\N	\N	Bulblets
BX 304	BULBS	12	Achimenes erecta	Dennis Kramb	\N	\N	\N	Rhizomes
BX 304	BULBS	13	Diastema vexans	Dennis Kramb	\N	\N	\N	Rhizomes
BX 304	BULBS	14	Gloxinella lindeniana	Dennis Kramb	\N	\N	\N	Rhizomes
BX 304	SEEDS	15	Gloxinella lindeniana	Dennis Kramb	\N	\N	\N	Seeds
BX 307	SEEDS	3	Babiana mixed	SIGNA	Babiana, mixed\n	\N	\N	\N
BX 322	SEEDS	5	Asarum caudatum album	Roland de Boer	\N	\N	\N	\N
BX 304	SEEDS	18	Agapanthus campanulatus	Pacific Bulb Society	\N	\N	\N	\N
BX 304	SEEDS	19	Cyrtanthus epiphyticus	Pacific Bulb Society	\N	\N	\N	\N
BX 304	SEEDS	20	Dierama trichorhizum?	Pacific Bulb Society	\N	\N	\N	\N
BX 304	SEEDS	21	Dierama dracomontanum	Pacific Bulb Society	\N	\N	\N	\N
BX 304	SEEDS	22	Kniphofia ichopensis	Pacific Bulb Society	\N	\N	\N	\N
BX 304	SEEDS	23	Kniphofia ritualis	Pacific Bulb Society	\N	\N	\N	\N
BX 306	BULBS	16	Achimenes	Joyce Miller	mixed	\N	\N	Rhizomes
BX 309	SEEDS	20	Galanthus reginae-olgae ssp reginae-olgae	Roland de Boer	 ex Sicily (more than one order available)	\N	\N	\N
BX 386	BULBS	1	Eucharis sp.?	Rimmer deVries	\N	\N	\N	Bulbs and offsets
BX 309	BULBS	9	Gladiolus flanaganii	Paul Otto	Small corms	\N	\N	\N
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
BX 315	SEEDS	7	Baeometra uniflora	Lee Poulsen	\N	\N	\N	\N
BX 315	SEEDS	8	Lapeirousia enigmata	Lee Poulsen	\N	\N	\N	\N
BX 315	SEEDS	9	Nothoscordum montevidense	Lee Poulsen	few	\N	\N	\N
BX 315	SEEDS	10	Tropaeolum azureum	Lee Poulsen	(few)	\N	\N	\N
BX 316	SEEDS	1	Crinum bulbispermum	Jay Yourch	all from Jumbo selections. Very cold hardy.	\N	\N	\N
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
BX 315	SEEDS	6	Strumaria discifera	Lee Poulsen	ex Nieuwoudtville. AMARYLLIDS: (LIMITED SUPPLIES)	\N	\N	\N
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
BX 318	BULBS	20	Oxalis bowiei	Mary Sue Ittner	very tall fall bloomer with pink flowers, best I suspect in deep pot	\N	w	\N
BX 306	SEEDS	10	Haemanthus humilis	Pacific Bulb Society	red stem	\N	\N	\N
BX 314	BULBS	25	Habranthus magnoi	Pamela Slate	\N	\N	\N	\N
BX 314	BULBS	26	Oxalis stenorhyncha	Pamela Slate	\N	\N	\N	\N
BX 314	BULBS	27	Oxalis regnellii	Pamela Slate	\N	\N	\N	\N
BX 314	BULBS	13	Oxalis purpurea 'Skar'	Mary Sue Ittner	(pink flowers) Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers)	\N	w	\N
BX 314	BULBS	14	Oxalis zeekoevleyensis	Mary Sue Ittner	(one of the first to start into growth) Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers)	\N	w	\N
BX 314	BULBS	15	Tulipa batalini	Mary Sue Ittner	Very small bulbs	\N	w	\N
BX 314	SEEDS	16	Haemanthus albiflos	Mary Sue Ittner	evergreen	\N	e	\N
BX 314	BULBS	17	Narcissus 'Nylon'	Jim Jones	Small bulbs	\N	\N	\N
BX 314	SEEDS	18	Crinum bulbispermum 'Jumbo'	Jim Waddick	This was originated from the late Crinum expert Les Hannibal and distributed by Marcelle Sheppard. This species does not pup a lot, so must be grown from seed for practical purposes. Totally hardy here in Kansas City Zone 5/6. Flowers open well in shades of light to dark pink. recommended and easy.	\N	\N	\N
BX 314	SEEDS	19	Fritillaria persica	Jim Waddick	This is a tall clone with rich purple/brown flowers. Does not pup freely here, but quite hardy in Kansas City.	\N	\N	\N
BX 314	SEEDS	20	Camassia 'Sacajewea'	Jim Waddick	Flowers creamy white, foliage white thin white edges. Of 3 or 4 species grown, only this one has made seed. A good size plant may be a form of C. leichtlinii.	\N	\N	\N
BX 317	SEEDS	2	Albuca spiralis	Nhu Nguyen	semi lax form	http://flickr.com/photos/xerantheum/…	\N	\N
BX 317	SEEDS	3	Albuca spiralis	Nhu Nguyen	lax form. Barely curly at the tips of the leaves	\N	\N	\N
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
BX 314	BULBS	21	Rhodophiala bifida	Rodney Barton	triploid Rhodophiala bifida heirloom. It's a veritable weed here in North Texas.	\N	\N	\N
BX 317	SEEDS	4	Zephyranthes 'datensis'	Nhu Nguyen	control pollinated. I got seeds of this species from Brazil. It was called "datensis" but it does not appear to be a validly published name. Not winter growing.	http://flickr.com/photos/xerantheum/…	\N	\N
BX 317	SEEDS	5	Cyrtanthus brachyscyphus	Nhu Nguyen	control pollinated. This is a lovely orange form of the species and one of the easiest species of Cyrtanthus to grow. Not winter growing.	http://flickr.com/photos/xerantheum/…	\N	\N
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
BX 314	BULBS	22	Lycoris radiata	Pamela Slate	\N	\N	\N	\N
BX 314	BULBS	23	Zephyranthes (Cooperia) drummondii	Pamela Slate	\N	\N	\N	\N
BX 314	BULBS	24	Zephyranthes 'Labuffarosea'	Pamela Slate	\N	\N	\N	\N
BX 318	BULBS	21	Oxalis caprina	Mary Sue Ittner	this one has a reputation as being weedy, but hasn't been any worse than some of the others, lilac flowers, late fall	\N	w	\N
BX 318	BULBS	22	Oxalis flava	Mary Sue Ittner	there are lots of different flava forms, this one has yellow flowers, fall bloomer	\N	w	\N
BX 318	BULBS	23	Oxalis flava (as namaquana)	Mary Sue Ittner	purchased as namaquana, but is flava, I think it is different than the one above, but can't remember exactly how	\N	w	\N
BX 318	BULBS	24	Oxalis gracilis	Mary Sue Ittner	orange flowers late fall, nicely divided leaves, short bloomer for me	\N	w	\N
BX 318	BULBS	25	Oxalis livida	Mary Sue Ittner	fall bloomer, very different leaves, check it out on the wiki, purple flowers	\N	w	\N
BX 318	BULBS	26	Oxalis namaquana	Mary Sue Ittner	small bulbs, bright yellow flowers in winter, low, seen in Namaqualand in mass in a wet spot	\N	w	\N
BX 318	BULBS	27	Oxalis obtusa	Mary Sue Ittner	winter blooming, didn't make a note of color	\N	w	\N
BX 318	BULBS	28	Oxalis obtusa MV 6341	Mary Sue Ittner	Nieuwoudtville. 1.5" bright yellow flowers. Tight, compact plants. Winter blooming	\N	w	\N
BX 318	BULBS	29	Oxalis polyphylla v heptaphylla MV6396	Mary Sue Ittner	fall bloomer, lavender flowers	\N	w	\N
BX 318	BULBS	30	Oxalis imbricata	Mary Sue Ittner	\N	\N	w	\N
BX 319	BULBS	1	Narcissus 'Stockens Gib'	Roy Herold	Another mystery from Lt Cdr Chris M Stocken. This one came to me from a friend who received it from a grower in Belgium. It was listed by the RHS as last being commercially available in 2005. The term 'gib' was a mystery to me, and originally I thought it to be an alternate spelling of a 'jib' sail. Google told me that a 'gib' is a castrated male cat or ferret. No thanks, but it also told me that 'gib' is short for Gibraltar. Stocken also collected in the Ronda mountains of Spain, and Gibraltar is just to the south, so is the probable origin of these bulbs. As for the bulb itself, it has never bloomed for me in ~8 years, but has multiplied like crazy. It has received the summer treatment recommended for plain old 'Stockens', but to no avail. Let me know how it turns out	\N	w	\N
BX 319	BULBS	2	Narcissus mixed seedlings	Roy Herold	These date back to a mass sowing in 2004 of seed from moderately controlled crosses of romieuxii, cantabricus, albidus, zaianicus, and similar early blooming sorts of the bulbocodium group. Colors tend to be light yellow through cream to white, and flowers are large, much larger than the little gold colored bulbocodiums of spring. These have been selected three times, and the keepers are choice. There is the odd runt, but 95% look to be blooming size	\N	w	\N
BX 375	SEEDS	13	Clivia hybrid	Rimmer deVries	? of Clivia caulescens X Clivia miniata-yellow Clivia caulescens -(JES # Clivia caulescens Woodbush)= pod parant flower: https://www.flickr.com/photos/32952654@N06/16964393666/in/album-72157651257749069/ x pollen from Clivia miniata-yellow- seed received from Maris Andersons 2007 flower: https://www.flickr.com/photos/32952654@N06/15859590245/in/album-72157647104139113/ seed:;	https://www.flickr.com/photos/32952654@N06/16782956697/in/album-72157651257749069/	\N	\N
BX 426	BULBS	4	Lilium 'Tiger Lily'	Chad Cox	Bulbils of 'Tiger Lily', double form	\N	\N	Bulbils
BX 394	SEEDS	4	Nerine Zinkowski hybrids	Mary Sue Ittner	Zinkowski Nerine hybrids (mostly sarniensis heritage) - open pollinated	\N	\N	Seeds
BX 358	SEEDS	32	Hippeastrum papilio x S. 'Durgha-Pradham'	Tim Eck	Hippeastrum x Sprekelia	\N	\N	\N
BX 319	BULBS	8	Lilium tigrinum	Jerry Lehmann	Bulbils	\N	\N	\N
BX 319	BULBS	9	Gladiolus murielae	Jonathan Lubar	\N	\N	\N	\N
BX 319	BULBS	10	Babiana sp.	Mary Sue Ittner	Corms. These have naturalized in my Northern California garden and are probably a form of Babiana stricta. Originally grown from mixed seed more than twenty years ago. Winter growing	\N	w	\N
BX 319	BULBS	11	Oxalis pulchella var tomentosa	Mary Sue Ittner	ex BX 221 and Ron Vanderhoff - Low, pubescent, mat forming foliage and large very pale salmon colored flowers. Fall blooming. This one hasn't bloomed for me yet, but I hope it will this year.	\N	w	\N
BX 319	BULBS	12	Oxalis semiloba	Mary Sue Ittner	originally from Uli, this is supposed to be a summer rainfall species, but grows for me in winter and dormant in summer. It never bloomed but the leaves reminded me of Oxalis boweii.  Chuck Powell provided me with some photos of this species he grow successfully (also on a winter growing schedule) and I added them to the wiki. I can't confirm the identity of these.	\N	w	\N
BX 319	BULBS	13	Oxalis obtusa	Mary Sue Ittner	Oxalis obtusa (peach flowers), winter-growing	\N	w	\N
BX 319	BULBS	14	Oxalis flava	Mary Sue Ittner	Oxalis flava (lupinifolia form), winter-growing	\N	w	\N
BX 319	BULBS	15	Ammocharis longifolia	Mary Sue Ittner	syn. Cybistetes longifolia, (survivors from seed sown from Silverhill Seed in 2000 and 2005). It can take 8 to 10 years to flower so I may be giving up too soon, but I suspect they need more summer heat and bright light than I can provide so I'm letting someone else have a crack at them.	\N	\N	\N
BX 358	SEEDS	33	Hippeastrum 'Emerald' x S. 'Durgha-Pradham'	Tim Eck	Hippeastrum x Sprekelia	\N	\N	\N
BX 358	SEEDS	34	Hippeastrum papilio x S. formosissima	Tim Eck	Hippeastrum x Sprekelia	\N	\N	\N
BX 322	SEEDS	4	Gladiolus caucasicus	Roland de Boer	\N	\N	\N	\N
BX 319	BULBS	3	Albuca sp.	Roy Herold	north of Calitzdorp, 12-18". Wild collected seed	\N	\N	\N
BX 320	SEEDS	1	Ipheion uniflorum 'Charlotte Bishop'	Kathleen Sayce	pink	\N	w	\N
BX 320	SEEDS	2	Arum palaestinum	Arnold Trachtenberg	\N	\N	\N	\N
BX 320	SEEDS	3	Arum korolkowii	Arnold Trachtenberg	\N	\N	\N	\N
BX 320	SEEDS	5	Camassia 'Sacajawea'	Jerry Lehmann	Mine is in full sun until 3 pm. Then light shade. Holds foliage color well.	\N	\N	\N
BX 317	SEEDS	27	Babiana pulchra	M Gastil-Buhl	white, seeds from 2011 corms ex JimDuggan	http://www.flickr.com/photos/gastils_garden/7475677940/in/set-72157630359362966/	w	\N
BX 317	SEEDS	28	Babiana purpurea	M Gastil-Buhl	some pinkish-purple, some bluish-purple, ex Jim Duggan	http://www.flickr.com/photos/gastils_garden/7475678438/in/set-72157630359362966/	w	\N
BX 317	SEEDS	29	Babiana 'Purple Haze'	M Gastil-Buhl	ex EasyToGrow	http://www.flickr.com/photos/gastils_garden/7475762562/in/set-72157630359362966/	w	\N
BX 319	BULBS	16	Gladiolus flanaganii	Pacific Bulb Society	small corms	\N	\N	\N
BX 319	BULBS	17	Zephyranthes 'Labuffarosea'	Pacific Bulb Society	small bulbs	\N	\N	\N
BX 319	BULBS	18	Tigridia pavonia	Pacific Bulb Society	small corms	\N	\N	\N
BX 319	BULBS	19	Gladiolus dalenii	Pacific Bulb Society	small corms	\N	\N	\N
BX 336	BULBS	7	Zephyranthes	Lynn Makela	ex Jacala, Mexico, wine-red flowers	\N	\N	\N
BX 320	SEEDS	23	Worsleya procera	Fereydoun Sharifi	4 seeds (3 from Brazilian plant + 1 from Australian plant)	\N	\N	\N
BX 320	SEEDS	24	Nerine humilis	Fereydoun Sharifi	Nerine humilis: Early season/large flower/pale pink	\N	\N	\N
BX 320	SEEDS	25	Nerine humilis	Fereydoun Sharifi	Nerine humilis: Mid season/dark pink	\N	\N	\N
BX 320	SEEDS	26	Nerine humilis	Fereydoun Sharifi	Nerine humilis: Late season/small flower	\N	\N	\N
BX 320	SEEDS	27	Nerine filifolia	Fereydoun Sharifi	\N	\N	\N	\N
BX 320	SEEDS	28	Nerine undulata	Fereydoun Sharifi	\N	\N	\N	\N
BX 320	SEEDS	29	Nerine undulata alta	Fereydoun Sharifi	\N	\N	\N	\N
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
BX 320	SEEDS	42	Freesia laxa, blue	M Gastil-Buhl	\N	\N	\N	\N
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
BX 332	SEEDS	3	Albuca nelsonii	Stephen Gregg	ex Silverhill. Grows 2 metres high	\N	\N	\N
BX 324	BULBS	14	Watsonia hybrids	Pamela Slate	Mixed corms of Watsonia mixed hybrids (Snow Queen, Flamboyant and Double Vision) and Ixia (Giant)	\N	\N	\N
BX 325	SEEDS	44	Lilium kelloggi white	Gene Mirro	320: blooms early summer; rare white form; 2 - 3 feet tall; water lightly after bloom time. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/motie42/kelloggiwhite_zps6668f279.jpg	\N	\N
BX 325	SEEDS	45	Lilium medeoloides	Gene Mirro	682: blooms midsummer; downfacing orange flowers; 2 - 3 feet tall; needs summer water. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/motie42/medeoloides_zpsf4f30b16.jpg	\N	\N
BX 325	SEEDS	46	Lilium parryi	Gene Mirro	1070: blooms early summer; 3 feet tall; outfacing yellow flowers; needs summer water. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/motie42/parryismall.jpg	\N	\N
BX 325	SEEDS	47	Lilium lijiangense	Gene Mirro	1174: blooms early summer; 3 - 4 feet tall; needs summer water. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/motie42/lijiangense_zps0056afef.jpg	\N	\N
BX 325	SEEDS	50	Trillium rivale	Gene Mirro	706: unmarked white form. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	\N	\N	\N
BX 330	SEEDS	2	Dichelostemma ida-maia	Bob Werra	\N	\N	\N	\N
BX 342	SEEDS	4	Crinum bulbispermum 'Jumbo'	Jay Yourch	\N	\N	\N	\N
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
BX 339	SEEDS	1	Freesia laxa ssp. cruenta)	M Gastil-Buhl	Primarily winter grower but also grows and blooms some year round. Not as easy to grow as the red ones. Easier to grow than the white ones.	\N	w	\N
BX 339	SEEDS	2	Chasmanthe sp.	M Gastil-Buhl	Winter grower / Summer deciduous Very weedy in Southern California. (Too easy to grow.)	\N	w	\N
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
BX 343	SEEDS	6	Hippeastrum stylosum	Stephen Putman	\N	\N	\N	\N
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
BX 342	BULBS	5	Oxalis bowiei	Rimmer deVries	ex BX 251	\N	\N	\N
BX 344	BULBS	16	Oxalis sp., MV 4674	Mike Mace	\N	\N	\N	\N
BX 344	BULBS	17	Oxalis sp., MV 4719D	Mike Mace	\N	\N	\N	\N
BX 344	BULBS	18	Oxalis sp., MV 4871	Mike Mace	\N	\N	\N	\N
BX 344	BULBS	19	Oxalis sp., MV 4960B	Mike Mace	\N	\N	\N	\N
BX 344	BULBS	20	Oxalis sp., MV 5117	Mike Mace	\N	\N	\N	\N
BX 344	BULBS	21	Oxalis sp., MV 5180	Mike Mace	\N	\N	\N	\N
BX 344	BULBS	22	Oxalis sp., MV 5532	Mike Mace	\N	\N	\N	\N
BX 344	BULBS	23	Oxalis sp., MV 5630A	Mike Mace	\N	\N	\N	\N
BX 344	BULBS	24	Oxalis sp., MV 5752	Mike Mace	\N	\N	\N	\N
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
BX 346	BULBS	5	Lachenalia sargeantii	Colin Davis	Offset bulblets	\N	\N	\N
BX 346	BULBS	6	Haemanthus coccineus x H. albiflos	Jim Shields	Good sized (few)	\N	\N	\N
BX 346	BULBS	7	Haemanthus coccineus	Jim Shields	ex Bokkeveld Escarpment (few) Good sized	\N	\N	\N
BX 346	BULBS	8	Haemanthus barkerae	Jim Shields	Various sized (few)	\N	\N	\N
BX 346	BULBS	9	Lachenalia mutabilis	Arnold Trachtenberg	Bulblets of	\N	\N	\N
BX 346	BULBS	10	Lachenalia juncifolia	Arnold Trachtenberg	Bulblets of	\N	\N	\N
BX 346	BULBS	11	Ferraria divaricata	Arnold Trachtenberg	Small corms	\N	\N	\N
BX 346	BULBS	12	Ferraria densipunctulata	Mary Sue Ittner	Corms of	\N	\N	\N
BX 346	BULBS	13	Ambrosina bassii	Roy Herold	Small offsets	\N	\N	\N
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
BX 346	BULBS	3	Gladiolus italicus	M Gastil-Buhl	Corms of mixed sizes	\N	w	Corms
BX 346	BULBS	4	Moraea bellendenii	M Gastil-Buhl	ID not confirmed. Corms	\N	w	\N
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
BX 347	SEEDS	18	Pamianthe peruviana	Dave Boucher	\N	\N	\N	\N
BX 347	SEEDS	19	Lilium longiflorum	Dave Boucher	ex Okinawa	\N	\N	\N
BX 347	SEEDS	20	Scilla haemorrhoidalis	Dave Boucher	\N	\N	\N	\N
BX 347	SEEDS	21	Herbertia lahue	Dave Boucher	\N	\N	\N	\N
BX 347	SEEDS	22	Albuca shawii	Jerry Lehmann	\N	\N	\N	\N
BX 347	SEEDS	23	Ornithogalum viridiflorum	Jerry Lehmann	\N	\N	\N	\N
BX 347	SEEDS	24	Ornithogalum fimbrimarginatum	Karl Church	HRG 118287, ISI 2013-27, S. Hammer and C. Barnhill. Tall inflorescense with white, narcissus-like flowers, open pollinated	\N	\N	\N
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
BX 347	SEEDS	16	Albuca spiralis	Chris Elwell	Unsure of donor name	\N	\N	\N
BX 348	BULBS	2	Oxalis conorrhiza	Ernie DeMarie	(syn. O. andicola), ex Chile Flora	\N	\N	\N
BX 347	SEEDS	15	Aristea capitata	M Gastil-Buhl	\N	\N	\N	\N
BX 347	SEEDS	14	Gladiolus italicus	M Gastil-Buhl	\N	\N	w	\N
BX 348	BULBS	27	Narcissus jonquilla subsp. cordubensis	Arnold Trachtenberg	\N	\N	\N	\N
BX 348	BULBS	28	Narcissus 'Firelight Gold'	Arnold Trachtenberg	\N	\N	\N	\N
BX 348	BULBS	29	Narcissus cantabricus 'Peppermint'	Arnold Trachtenberg	\N	\N	\N	\N
BX 348	BULBS	30	Narcissus bulbocodium subsp. praecox	Arnold Trachtenberg	\N	\N	\N	\N
BX 348	BULBS	31	Narcissus romieuxii 'Julia Jane'	Arnold Trachtenberg	\N	\N	\N	\N
BX 348	BULBS	32	Narcissus romieuxii var. mesatlanticus	Arnold Trachtenberg	\N	\N	\N	\N
BX 348	BULBS	33	Narcussus romieuxii x N. cantabricus	Arnold Trachtenberg	\N	\N	\N	\N
BX 348	SEEDS	35	Crinum macowanii	Tony Avent	ex Malawi	\N	\N	\N
BX 351	BULBS	15	Albuca circinata	Ernie DeMarie		\N	\N	Bulblets
BX 351	BULBS	16	Amaryllis belladonna	Ernie DeMarie	hybrids; white, ex BX 227	\N	\N	Bulblets
BX 351	BULBS	17	Amaryllis belladonna	Ernie DeMarie	hybrids; pinks, ex BX 227	\N	\N	Bulblets
BX 351	BULBS	18	Amaryllis belladonna	Ernie DeMarie	hybrids; many buds per umble, ex BX 262	\N	\N	Bulblets
BX 351	BULBS	19	Ferraria cf. schaeferi	Ernie DeMarie		\N	\N	Bulblets/Cormlets
BX 351	BULBS	20	Freesia grandilora	Ernie DeMarie	ex Malawi	\N	\N	Cormlets
BX 361	BULBS	3	Arisaema flavum	Jyl Tuck		\N	\N	\N
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
BX 351	BULBS	31	Othonna sp.	Ernie DeMarie	?; Simonsvlei, white flowers	\N	\N	Bulblets/Cormlets
BX 351	BULBS	11	Eucomis comosa	Dee Foster	mixed colors: white, pink, purple. open-pollinated	\N	\N	Small bulbs
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
BX 353	BULBS	22	Iris mixed bearded	Jude Platteborze	mixed bearded iris	\N	\N	Small rhizomes
BX 353	BULBS	9	Moraea setifolia	Rodney Barton	from SIGNA seed	\N	\N	\N
BX 353	BULBS	10	Freesia viridis	Rodney Barton	from SIGNA seed	\N	\N	\N
BX 353	BULBS	11	Gladiolus dalenii var. garnieri Madagascar form	Rodney Barton	ex seeds from Maurice Boussard (Gladiolus garneri / Gladiolus watsonioides)	\N	\N	\N
BX 353	BULBS	14	Melasphaerula ramosa	Mary Sue Ittner		\N	\N	Bulblets
BX 353	BULBS	15	Calochortus argillosus	Mary Sue Ittner		\N	\N	Bulblets
BX 353	BULBS	17	Lachenalia vanzyliae	Monica Swartz		\N	\N	Small bulbs
BX 353	BULBS	18	Lachenalia mutabilis	Monica Swartz	electric blue	\N	\N	Bulbs
BX 353	BULBS	19	Lachenalia quadricolor	Monica Swartz		\N	\N	Bulbs
BX 353	BULBS	20	Lachenalia unicolor	Monica Swartz		\N	\N	Bulbs
BX 353	BULBS	23	Convallaria	Jude Platteborze	- mixed white, pink and double. Initially listed as 'Roots or Aspidistra sp.'	\N	\N	\N
BX 353	BULBS	24	Rohdea japonica	Jude Platteborze		\N	\N	Rhizomes
BX 354	BULBS	1	Hippeastrum hybrids	Jude Platteborze	Bulbs of Hippeastrum commercial hybrids. Varying from 2 - 6 cm diameter. Only one available of most of these. SPECIFY A QUANTITY OF ASSORTED BULBS. ($1 apiece) Varieties include: Joker, Desire, Exotica, Harlequin, Grand Cru, Scarlet Baby, Night Star, Jewel, Little Devil, United Nations, Donau, Pavlova, Pizzazz, Celica, Monte Carlo, President Johnson, Ragtime, Fanfare, Aphrodite, Lovely Garden, Temptation, Mega Star, Novella, Giraffe, Flamenco Queen.	\N	\N	Bulbs
BX 354	SEEDS	2	Zephyranthes smallii	Jim Shields (and Charles Crane)	original seed collected near airport at Brownsville, TX	\N	\N	Seeds
BX 354	SEEDS	3	Chlorogalum pomeridianum	Mary Sue Ittner	- winter growing	\N	w	\N
BX 354	SEEDS	4	Eucomis comosa	Mary Sue Ittner	- summer growing, purple leaves	\N	s	\N
BX 354	SEEDS	5	Nerine angustifolia	Mary Sue Ittner	(already sprouting), open pollinated so likely hybrid	\N	\N	\N
BX 354	SEEDS	6	Nerine sarniensis	Mary Sue Ittner	(mixed colors)	\N	\N	\N
BX 354	SEEDS	7	Polianthes geminiflora	Mary Sue Ittner	- summer growing	\N	s	\N
BX 354	SEEDS	8	Tigridia vanhouttei	Mary Sue Ittner	- summer growing	\N	s	\N
BX 354	SEEDS	9	Arisaema triphyllum	Nicholas Plummer	- these are seeds from plants grown in my garden and are two generations removed from seed originally collected in Wake Co, NC. I usually observe good germination after cold, moist stratification.	\N	\N	Seeds
BX 357	SEEDS	11	Lilium	Uli Urban	White Tetra Trumpets';like a giant version of Lilium regale but lacking its elegance.	\N	\N	\N
BX 358	SEEDS	26	Tigridia pavonia	Ina Crossley	white	\N	\N	\N
BX 358	SEEDS	27	Kniphofia typhoides	Ina Crossley		\N	\N	\N
BX 353	BULBS	13	Lapeirousia neglecta	Ernie DeMarie		\N	\N	Cormlets
BX 353	SEEDS	27	Lilium regale 'Alba'	Rimmer deVries		\N	\N	\N
BX 353	SEEDS	28	Allium senescens subsp. montanum	Rimmer deVries		\N	\N	\N
BX 353	SEEDS	29	Iris delavayi	Rimmer deVries		\N	\N	\N
BX 354	SEEDS	10	Lilium formosanum	Nicholas Plummer	- these are the tall standard variety originally purchased from Niche Gardens. They were pollinated by moths in the open garden, but I did not have any other Lilium species blooming at the time. I think the chance of hybrids is minimal. These plants volunteer readily, so I have never attempted controlled germination. Consequently, I do not know what percentage of seeds are viable.	\N	\N	Seeds
BX 354	SEEDS	11	Calochortus venustus	Chris Elwell	burgundy (OP)	\N	\N	\N
BX 354	SEEDS	12	Calochortus venustus	Chris Elwell	var. sanguineus (OP)	\N	\N	\N
BX 354	SEEDS	13	Habranthus gracilifolius	Chris Elwell		\N	\N	\N
BX 354	SEEDS	14	Gloriosa superba	Dee Foster		\N	\N	Seeds
BX 354	SEEDS	15	Eucomis comosa	Dee Foster	pink, purple, white mix (OP)	\N	\N	Seeds
BX 354	SEEDS	16	Eucomis comosa	Dee Foster	dwarf purple (OP)	\N	\N	Seeds
BX 354	SEEDS	17	Lycoris	Jim Waddick	- L. chinensis, L. longituba, L. longituba flava and hybrids all mixed	\N	\N	Seeds
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
BX 357	SEEDS	2	Albuca aurea	Uli Urban	not really yellow, rather greenish yellow upright flowers, stout evergreen plant, flowers in spring 50cm tall. Always looks somewhat untidy.	\N	\N	\N
BX 357	SEEDS	3	Albuca shawii	Uli Urban	(Ornithogalum shawii, Albuca tenuifolia) 40cm tall, summer growing, winter dormant, nodding yellow unscented flowers, pleasantly fragrant foliage	\N	\N	\N
BX 357	SEEDS	6	Allium cernuum	Uli Urban	charming inflorescence of many dangling purple urns, stamens protruding. 60cm tall, very hardy, summer flowering	\N	\N	\N
BX 357	SEEDS	7	Arisaema cf	Uli Urban	. consanguineum; from Chiltern seeds, tall plant, many leaflets arranged radially, green flowers, enormous bright red fruit. Not tested for hardiness. 1.2m tall.	\N	\N	\N
BX 357	SEEDS	8	Canna paniculata	Uli Urban	(?) evergreen, no rest period, it will die if you keep it as a dry rhizome. flowers in spring rather insignificant. But magnificent foliage plant. Identity not certain, from a few grains from Bolivia.	\N	\N	\N
BX 357	SEEDS	9	Dahlia coccinea	Uli Urban	(var palmeri) (open pollinated, may not come true) The original seed was from Harry Hay. Collecting data available. Fantastic plant, likes cool summers and/or semi shade. best in September when it cools down. 2,5m tall, very elegant, finely dissected foliage, horizontal bright orange single flowers. Seeds germinate best in cool conditions. Some plants may flower yellow, also attractive. VERY IMPORTANT: the tubers will form at a good distance from the main stem, only attached by a thin string-like root. It DOES form tubers, take care when digging it up for winter storage. Does not reach its adult size the first year from seed.	\N	\N	\N
BX 357	SEEDS	10	Ipomoea lindheimeri	Uli Urban	not a tuber but a fleshy rhizome. Pretty light blue flowers with a cream throat, slighty scented. A US native. Easy.	\N	\N	\N
BX 358	SEEDS	25	Zephyranthes reginae	Ina Crossley		\N	\N	\N
BX 357	SEEDS	4	Albuca sp.	Uli Urban	.;?. bought as shawii but distinct. Leaves not fragrant, scented yellow nodding flowers, 40cm, possibly a variation of shawii	\N	\N	\N
BX 355	SEEDS	1	Clivia miniata	Rimmer deVries	yellow	\N	\N	\N
BX 355	SEEDS	2	Iris 'Dunshanbe'	Rimmer deVries	OP- few seeds	\N	\N	\N
BX 355	SEEDS	3	Iris hoogiana 'Bronze Beauty' x Iris hoogiana	Rimmer deVries	(med blue color)- quite a few seeds	\N	\N	\N
BX 355	SEEDS	4	Barnardia japonica	Rimmer deVries	(Scilla) japonica; (There is much confusion about the correct name)	\N	\N	\N
BX 357	SEEDS	12	Mirabilis jalapa	Uli Urban	tall form much taller than the trade form. Up to 1,8m. large mostly purple flowers. The tuber is so big that I can hardly carry it when I dig it up for winter storage. From cultivated plants in Bolivia.	\N	\N	\N
BX 357	SEEDS	13	Nerine bowdenii	Uli Urban	Typ Oswald From Mr Oswald in the former East-Germany. The origin of this plant is obscure. Looks like ordinary N. bowdenii but much hardier. Mr Oswald grows his stock plants among the beans and strawberries in his garden, heavily mulched in winter. (Zone 7) Seed has sprouted and is forming small bulbs. Should be planted immediately on receipt. Summer growing, it should still form a small plant this season.	\N	\N	\N
BX 357	SEEDS	14	Nerine alta	Uli Urban	(N. undulata)(?) Bought as N. bowdenii seed from David Human in South Africa but is so distinct that I doubt. Very frilled narrow petals, many more flowers per stem than bowdenii. Has proved extremely hardy (Zone 7, Temps can go down to -20°C) with winter mulch and protection from winter wet. Takes a long time to establish. Very attractive. Seed has sprouted as well, see above.	\N	\N	\N
BX 357	SEEDS	15	Tradescantia boliviana	Uli Urban	Only recently described. 80cm tall upright perennial, summer growing, strictly and completely dry winter dormancy. Needs full sun to remain upright, masses of medium sized purple triangles along the shoots, very attractive. Bolivian native.	\N	\N	\N
BX 357	SEEDS	33	Hippeastrum heirloom	Ann Patterson	Heirloom Hippeastrum that was discussed on the list a while back. One order only.	\N	\N	Seeds
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
BX 358	SEEDS	28	Hippeastrum 'Emerald' x H. 'Grandeur'	Tim Eck	Hippeastrum crosses	\N	\N	\N
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
BX 360	SEEDS	20	Clivia miniata	Rimmer deVries	hybrid; small red, OP, from B&O pastel x large Belgian	\N	\N	\N
BX 359	BULBS	1	Crinum 'Menehune'	Lynn Makela	deep wine-color leaves (Crinum oliganthum x C. asiaticum?)	\N	\N	\N
BX 359	BULBS	2	Talinum sp.	Lynn Makela	from Yucca Do, ex Salta City, Argentina. Looks like 'Eyerdamii'? 12 inches	\N	\N	\N
BX 359	BULBS	3	Zephyranthes verecunda rosea	Lynn Makela	(Zephyranthes minuta 'Rosea')	\N	\N	\N
BX 358	SEEDS	29	Hippeastrum 'Lima' x (H. papilio x H. mandonii)	Tim Eck	Hippeastrum crosses	\N	\N	\N
BX 358	SEEDS	30	Hippeastrum 'Evergreen' x (H.papilio x (H. cybister x H. papilio))	Tim Eck	Hippeastrum crosses	\N	\N	\N
BX 362	BULBS	5	Oxalis fabifolia	John Wickham		\N	\N	\N
BX 362	BULBS	6	Oxalis cathara	John Wickham		\N	\N	\N
BX 362	BULBS	8	Oxalis bowiei	John Wickham		\N	\N	\N
BX 362	BULBS	9	Oxalis namaquana	John Wickham		\N	\N	\N
BX 362	BULBS	10	Oxalis glabra	John Wickham		\N	\N	\N
BX 362	BULBS	11	Oxalis polyphylla heptaphylla	John Wickham	(again!, don't worry about it)	\N	\N	\N
BX 362	BULBS	12	Lachenalia aloides var. quadricolor	John Wickham		\N	\N	\N
BX 362	BULBS	13	Lachenalia pallida	John Wickham		\N	\N	\N
BX 362	BULBS	14	Lachenalia pendula	John Wickham	(syn. L. bulbifera)	\N	\N	\N
BX 362	BULBS	15	Gladiolus cunonius	John Wickham		\N	\N	\N
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
BX 362	BULBS	7	Oxalis sp.	John Wickham	?, MV 5117	\N	\N	\N
BX 363	SEEDS	15	Canna sp.	Shawn Pollard	small yellow flowers, maybe a few red, in great abundance	\N	\N	\N
BX 363	SEEDS	1	Clivia hybrid	Rimmer deVries	F2 from deep red, tulip-form , large Belgian, 2 - 3 inch wide leaves (Seed pods were very red)	\N	\N	\N
BX 363	SEEDS	2	Clivia hybrid	Rimmer deVries	yellow (Vico yellow x Solomone yellow) open-pollinated (Seed pods were very yellow	\N	\N	\N
BX 369	BULBS	1	Brodiaea pallida	Mary Sue Ittner		\N	\N	\N
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
BX 383	BULBS	6	Triteleia hyacinthina	Jim Barton		\N	\N	\N
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
BX 372	BULBS	18	Clinanthus incarnatus	Giovanni Curci	yellow form (VERY FEW)	\N	\N	Small bulbs
BX 370	BULBS	5	Cyclamen graecum	Tom Glavich from the collection of the late Charles Hardman	good sized tubers	\N	\N	\N
BX 370	BULBS	6	Haemanthus humilis subsp. hirsutus	Tom Glavich from the collection of the late Charles Hardman	small bulbs	\N	\N	\N
BX 371	BULBS	9	Geissorhiza? or Hesperantha?	Mary Sue Ittner	Geissorhiza? or Hesperantha?	\N	\N	Small corms
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
BX 371	BULBS	3	Arum palaestinum	Arnold Trachtenberg	(few)	\N	\N	Tubers
BX 371	BULBS	4	Freesia 'Red River'	Judy Glattstein	red	\N	\N	Small corms
BX 371	BULBS	5	Freesia 'Port Salut'	Judy Glattstein	yellow	\N	\N	Small corms
BX 371	BULBS	6	Freesia 'Ambiance'	Judy Glattstein	white	\N	\N	Small corms
BX 371	BULBS	7	Blooming size	Mary Sue Ittner	corms of Watsonia aletroides, 'my most dependably blooming watsonia'	\N	\N	corms
BX 371	BULBS	8	Geissorhiza imbricata	Mary Sue Ittner		\N	\N	Cormlets
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
BX 372	BULBS	8	Alocasia x amazonica	Monica Swartz	an easy and common house plant (A. x mortfontanensis)?	\N	\N	Tubers
BX 372	BULBS	13	Arisaema amurense	Jyl Tuck		\N	\N	Small tubers
BX 372	BULBS	14	Lilium lancifolium	Francisco Lopez		\N	\N	Bulbils
BX 372	BULBS	15	Allium roseum	Francisco Lopez		\N	\N	Small bulbs
BX 372	BULBS	16	Ornithogalum caudatum	Francisco Lopez	(Albuca bracteata?) (Lonocornelos caudatum?)	\N	\N	Small bulbs
BX 371	BULBS	1	Lachenalia rubida	Fred Thorne		\N	\N	Small bulbs
BX 371	BULBS	2	Fritillaria uva-vulpis	Fred Thorne		\N	\N	Offsets
BX 372	BULBS	10	Oxalis obtusa	Rimmer deVries	pink	\N	\N	Small bulbs
BX 372	BULBS	12	Pancratium zeylanicum	Rimmer deVries	only one bulb	\N	\N	\N
BX 372	BULBS	19	Phaedranassa viridiflora	Giovanni Curci		\N	\N	Small bulbs
BX 372	SEEDS	20	Lycoris chinensis	Jim Waddick	These seed are from fairly isolated parents with this name, but it hybridizes readily with other fertile species. Expect flowers that are yellow to gold in color, somewhat 'spidery' in form and around 30 in tall. These are both Spring foliage species NOT suited to Mediterranean or South eastern climates. Do best north of zone 7 into Zone 4 and 5. NOT recommended for Southern CA. Plant seeds immediately on receipt as they do not have a long shelf life. They do poorly in pots for long term and rarely bloom in pots.	\N	\N	\N
BX 372	SEEDS	21	Lycoris hybrids	Jim Waddick	These are a mix of L. chinensis and L. longituba. Flowers will be smooth or spidery, from white to gold and may have some pink tints. Easy and hardy in Zone 5/6. These are both Spring foliage species NOT suited to Mediterranean or South eastern climates. Do best north of zone 7 into Zone 4 and 5. NOT recommended for Southern CA. Plant seeds immediately on receipt as they do not have a long shelf life. They do poorly in pots for long term and rarely bloom in pots.	\N	\N	\N
BX 373	BULBS	1	Cyrtanthus hybrid	Arnold Trachtenberg	orange-scarlet trumpets.	\N	\N	Bulbs
BX 373	SEEDS	2	Clivia 'Solomone light orange x yellow'	Dell Sherk	selfed	\N	\N	Seeds
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
BX 383	BULBS	5	Calochortus luteus	Jim Barton		\N	\N	\N
BX 373	BULBS	3	Tulipa sylvestris	Rimmer deVries		\N	\N	Small bulbs
BX 375	BULBS	1	Eucharis amazonica	Rimmer deVries	- as stated in prior BXs these are presumed to carry a virus load but they bloom nicely-see photos;	https://www.flickr.com/photos/32952654@N06/sets/72157651609454716/	\N	\N
BX 379	BULBS	5	mixed four taxa	Scott VanGerpen	One order, only. All four in a lot: 1 bulb of Biarum marmarisense; 1 cormlet of Geissorhiza radians, 1 bulb of Massonia pygmaea subsp. kamiesbergensis; and 1 bulb of Lachenalia trichophylla	\N	\N	\N
BX 376	BULBS	1	Haemanthus humilis ssp. hirsutus	Jill Peterson	Small bulbs	\N	\N	\N
BX 376	SEEDS	2	Clivia	Jill Peterson	seeds from a plant with deep orange flowers	\N	\N	\N
BX 376	SEEDS	3	Clivia	Jill Peterson	seeds from a variegated plant with orange flowers.	\N	\N	\N
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
BX 379	BULBS	6	Chasmanthe floribunda 'Duckittii'	Arnold Trachtenberg		\N	\N	Corms
BX 379	SEEDS	3	xHippeastrelia	Pamela Slate	selfed. ex Buried Treasures, Valrico, FL	\N	\N	Seed
BX 375	BULBS	3	Massonia echinata	Rimmer deVries	ex NARGS 2012/13 #1684;	https://www.flickr.com/photos/32952654@N06/sets/72157649341793814/	\N	\N
BX 375	BULBS	6	Albuca nelsonii	Rimmer deVries	PBS seed sale Feb 2014	\N	\N	\N
BX 380	BULBS	1	Lachenalia punctata	Uli Urban	(syn. L. rubida) bulbili. The plant is quite showy with red tubular flowers in early spring and is strictly winter growing. The bulbili form at the leaf bases and on the midrib like structure of the leaf.The mother plant was given to me by Dietrich Müller-Doblis but I do not have the collection data.	\N	\N	\N
BX 380	BULBS	2	Gladiolus flanaganii	Uli Urban	cormlets and small corms. It grows very vigorously with me but is a little shy to flower, easy, summer growing and winter dry.	\N	\N	\N
BX 380	BULBS	3	Tropical waterlily	Uli Urban	Tubers of my blue tropical waterlily. I posted those before. I lost the mother tubers in winter due to rot but the small tubers that formed in the center of the leaves were kept in moist Sphagnum with some fungicide at a temperature around 10°C. They kept very well, I started 2 of them at the end of April and all sprouted. I had kept one in unheated water in my frost free but cold greenhouse. It is sprouting, too. They should be started immediately in warm water, give them as much light and warmth as possible, fertilize well (Osmocote is best) and then they will grow VERY quickly. Purple-blue flowers with yellow centre held above the water, very scented. Will form new tubers or even small plants on the leaves (viviparous) Identity is uncertain, I got it as an exchange from the Strasbourg Botanical Garden in France under the name of Nymphaea daubeniana which it is definitely not. It comes closest to the Hybrid 'Tina'	\N	\N	Tubers
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
BX 381	BULBS	13	Oxalis pardalis	Mary Sue Ittner	MV7632	\N	\N	\N
BX 381	BULBS	14	Oxalis obtusa 'Peaches & Cream'	Mary Sue Ittner		\N	\N	\N
BX 381	BULBS	15	Oxalis versicolor	Mary Sue Ittner		\N	\N	\N
BX 381	BULBS	16	Tulipa linifolia	Mary Sue Ittner	(yellow, form known by most at Tulipa batalinii), small bulbs	\N	\N	\N
BX 381	BULBS	17	Tulipa linifolia	Mary Sue Ittner	(red), small bulbs	\N	\N	\N
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
BX 382	SEEDS	16	Clivia caulescens	Ray Talley	ONE ORDER ONLY - seeds	\N	\N	Seeds
BX 383	BULBS	1	Hippeastrum striatum 'Saltao'	Nicholas Plummer		\N	\N	Bulblets
BX 383	BULBS	2	Hippeastrum striatum	Nicholas Plummer	from a single clone, ex BX 341	\N	\N	Bulblets
BX 383	BULBS	3	Amaryllis belladonna	Jim Barton	One-yr-old bulblets	\N	\N	\N
BX 383	BULBS	4	Dichelostemma capitatum	Jim Barton		\N	\N	\N
BX 381	BULBS	12	Oxalis sp.	Mary Sue Ittner	. MV4674	\N	\N	\N
BX 383	BULBS	7	Triteleia ixioides	Jim Barton		\N	\N	\N
BX 383	BULBS	8	Triteleia laxa	Jim Barton		\N	\N	\N
BX 383	SEEDS	9	Trillium kurabayashii	Kathleen Sayce	Fresh moist seeds. Red flowers and nicely mottled foliage, grown from seeds from NARGS seed exchange.	\N	\N	\N
BX 384	BULBS	1	Crocus ochroleucus	Mary Sue Ittner	- small cormlets	\N	\N	\N
BX 384	BULBS	2	Freesia laxa	Mary Sue Ittner	blue - cormlets	\N	\N	\N
BX 384	BULBS	3	Freesia sparrmanii	Mary Sue Ittner	- cormlets	\N	\N	\N
BX 384	BULBS	4	Oxalis depressa	Mary Sue Ittner	MV4871 - bulbs	\N	\N	\N
BX 384	BULBS	5	Tristagma uniflorum	Mary Sue Ittner	(Ipheion uniflorum?), white - bulbs	\N	\N	\N
BX 384	SEEDS	10	Cyrtanthus mackenii	Ray Talley		\N	\N	Seed
BX 384	BULBS	11	Amaryllis belladonna	Jim Barton	One year old small bulbs	\N	\N	\N
BX 384	BULBS	12	Lilium sargentiae	Arnold Trachtenberg	Stem bulbils	\N	\N	\N
BX 385	SEEDS	6	Pamianthe peruviana	Paul Matthews		\N	\N	Seeds
BX 385	BULBS	7	Sinningia leucotricha 'Max Dekking'	Dennis Kramb	ONE tuber	\N	\N	Tuber
BX 385	BULBS	8	Oxalis bowiei	John Willis		\N	\N	\N
BX 385	BULBS	9	Lachenalia contaminata	John Willis		\N	\N	\N
BX 385	BULBS	10	Lachenalia liliiflora	John Willis		\N	\N	\N
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
BX 386	BULBS	22	Gethyllis grandiflora	Arcangelo Wessells	ex Silverhill; bulbs went to the bottom of one gallon pot	\N	\N	Small bulbs
BX 387	BULBS	5	Allium acuminatum	Nhu Nguyen	NNBH853	\N	\N	\N
BX 387	BULBS	6	Allium amplectens	Nhu Nguyen	pink form NNBH849	\N	\N	\N
BX 387	BULBS	7	Allium campanulatum	Nhu Nguyen	NNBH850	\N	\N	\N
BX 387	BULBS	8	Allium hickmanii	Nhu Nguyen	NNBH1	\N	\N	\N
BX 386	BULBS	18	Sinningia eumorpha 'Roxa Clenilson'	Dennis Kramb	(small tubers, purple variant of Sinn. eumorpha, recently discovered in the wild by Clenilson Souza of Brazil, 'roxa' is Portuguese for 'purple', the name 'Roxa Clenilson' is not a registered name, but just a descriptor for the discoverer & color variant.)	\N	\N	\N
BX 386	BULBS	19	Sinningia cardinalis	Dennis Kramb	(small tubers, most of them roughly pea-sized or smaller, should be planted & watered once, new growth should happen quickly)	\N	\N	\N
BX 386	BULBS	20	Sinningia cardinalis	Dennis Kramb	(few, large tubers, recently bloomed this summer, may require a period of dormancy before resprouting, or might re-sprout immediately)	\N	\N	\N
BX 384	SEEDS	6	Habranthus robustus	Rimmer deVries	- Telos, .	https://flic.kr/p/xmZDVu/ -short lived seed	\N	Seed
BX 384	SEEDS	8	Leucojum aestivum	Rimmer deVries	- moist packed - short lived seed.	\N	\N	Seed
BX 384	SEEDS	9	Sprekelia formosissima	Rimmer deVries		\N	\N	Seed
BX 385	BULBS	1	Scilla lingulata	Rimmer deVries	var. ciliolata (syn.? Hyacinthoides lingulata) (syn. H, ciliolata) ex Jane McGary. late flowering Late October - December and later, pale blue flowers have dark blue ovary and blue pollen- hardy outside in Zone 4 in a cold frame but excellent for a cold greenhouse	https://flic.kr/p/pXC9pV/	\N	\N
BX 385	BULBS	2	Scilla lingulata	Rimmer deVries	var. ciliolata (syn. ? Hyacinthoides lingulata) (syn. H, ciliolata) - ex Paul Otto- probably the same as above, though there are many forms of this plant with different leaves and flowers and flowering times.	\N	\N	\N
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
BX 392	BULBS	7	Babiana thunbergii	Mike Mace	(B. hirsuta)	\N	\N	\N
BX 392	BULBS	8	Geissorhiza inaequalis	Mike Mace		\N	\N	\N
BX 392	BULBS	11	Gladiolus watsonius	Mike Mace		\N	\N	\N
BX 392	BULBS	12	Moraea 'Zoe'	Mike Mace	second generation seedlings	http://growingcoolplants.blogspot.com/	\N	\N
BX 392	BULBS	13	Moraea aristata	Mike Mace		\N	\N	\N
BX 392	BULBS	14	Moraea fugax	Mike Mace	purple	\N	\N	\N
BX 392	BULBS	15	Moraea gigandra	Mike Mace		\N	\N	\N
BX 392	BULBS	16	Moraea lurida	Mike Mace	pale yellow/maroon	\N	\N	\N
BX 393	BULBS	6	Moraea neopavonia	Mike Mace	(M. tulbaghensis)	\N	\N	\N
BX 393	BULBS	7	Moraea saxicola	Mike Mace		\N	\N	\N
BX 393	BULBS	8	Moraea schlechteri	Mike Mace		\N	\N	\N
BX 393	BULBS	9	Moraea setifolia	Mike Mace		\N	\N	\N
BX 393	BULBS	10	Moraea tripetala	Mike Mace		\N	\N	\N
BX 393	BULBS	11	Moraea tulbaghensis	Mike Mace	(tulbaghensis form)	\N	\N	\N
BX 392	BULBS	2	Nerine angustifolia	Joyce Miller	.	\N	\N	\N
BX 392	BULBS	3	Nerine masonorum	Joyce Miller	. These bloomed for me in Sacramento, CA where summer nights are hot.	\N	\N	\N
BX 392	BULBS	4	Sinningia sp.	Joyce Miller	from BX seed donated by Nhu Nguyen.	\N	\N	\N
BX 392	BULBS	5	Griffinia espiritensis	Rimmer deVries	ex Eden's Blooms; good, strong, freely blooming clone	\N	\N	\N
BX 392	BULBS	6	Cyrtanthus labiatus	Rimmer deVries	ex BX; offsets freely, but does not grow to blooming size	\N	\N	\N
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
BX 394	BULBS	5	Barnardia japonica	John Willis	ex BX 355	\N	\N	Bulbs
BX 394	SEEDS	6	Narcissus viridiflorus	Arnold Trachtenberg	(FEW)	\N	\N	Seed
BX 394	SEEDS	7	Hippeastrum iguazuanum	Andres Pontieri	(priority will go to those who did not receive this species in an earlier BX)	\N	\N	Seed
BX 394	SEEDS	8	Ipheion uniflorum 'Rolf Fiedler'	Andres Pontieri		\N	\N	Seed
BX 394	SEEDS	3	Nerine 'Wombe' x 'Carmenita'	Mary Sue Ittner	Zinkowski Nerine - light pink small ruffled flowers that are darker pink in bud and on the back, but open pollinated - very few seeds	http://www.pacificbulbsociety.org/pbswiki/index.php/NerineZinkowskiHybrids	\N	Seeds
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
BX 326	BULBS	7	Oxalis glabra	Nhu Nguyen	- W	\N	w	\N
BX 395	BULBS	24	Hippeastrum 'Pink Garden'	Aad van Beek	Bulblets (1 - 4 cm) of Hippeastrum garden hybrids	\N	\N	\N
BX 395	BULBS	25	Hippeastrum 'White Garden'	Aad van Beek	Bulblets (1 - 4 cm) of Hippeastrum garden hybrids	\N	\N	\N
BX 395	BULBS	26	Sinningia warmingii	Dell Sherk	Seedling tubers	\N	\N	\N
BX 396	BULBS	6	Bessera elegans	Fred Biasella	red	\N	\N	Small bulbs
BX 396	BULBS	7	Eucomis comosa	Fred Biasella	green/white	\N	\N	Bulbs
BX 396	BULBS	9	Cyrtanthus suaveolens	Fred Biasella		\N	\N	Small bulbs
BX 396	SEEDS	10	Pamianthe peruviana	Paul Matthews		\N	\N	Seed
BX 396	SEEDS	11	Eucrosia mirabilis	Nick Plummer		\N	\N	Seed
BX 396	BULBS	12	Gloxinella lindeniana	Dennis Kramb		\N	\N	Rhizomes
BX 397	SEEDS	3	Haemanthus albiflos	Mary Sue Ittner		\N	\N	\N
BX 397	BULBS	5	Oxalis bowiei	Mary Sue Ittner	- Winter growing: plant late summer northern hemisphere	\N	w	\N
BX 397	BULBS	6	Oxalis callosa	Mary Sue Ittner	- Winter growing: plant late summer northern hemisphere	\N	w	\N
BX 397	BULBS	7	Oxalis commutata	Mary Sue Ittner	- Winter growing: plant late summer northern hemisphere	\N	w	\N
BX 397	BULBS	8	Oxalis depressa	Mary Sue Ittner	MV4871 - Winter growing: plant late summer northern hemisphere	\N	w	\N
BX 397	BULBS	9	Oxalis engleriana	Mary Sue Ittner	- Winter growing: plant late summer northern hemisphere	\N	w	\N
BX 397	BULBS	10	Oxalis flava	Mary Sue Ittner	(yellow) - Winter growing: plant late summer northern hemisphere	\N	w	\N
BX 397	BULBS	11	Oxalis hirta 'Gothenburg'	Mary Sue Ittner	(very large bulbs) - Winter growing: plant late summer northern hemisphere	\N	w	\N
BX 397	BULBS	12	Oxalis hirta	Mary Sue Ittner	(mauve) - Winter growing: plant late summer northern hemisphere	\N	w	\N
BX 397	BULBS	13	Oxalis hirta	Mary Sue Ittner	(pink) - Winter growing: plant late summer northern hemisphere	\N	w	\N
BX 397	BULBS	15	Oxalis obtusa	Mary Sue Ittner	MV6341 - Winter growing: plant late summer northern hemisphere	\N	w	\N
BX 397	BULBS	16	Tulipa turkestanica	Mary Sue Ittner		\N	w	\N
BX 398	BULBS	8	Spathantheum orbignyanum	Uli Urban	a deciduous Aroid from Bolivia. It is incredibly prolific. This plant produces large leaves in summer similar to those of Acanthus. The flowers appear before the leaves and look like a long-stemmed thin leaf, only if you look at the underside one will see it is in fact a flower. The smell is strange, not on the pleasant side.... It likes full sun and lots of water and fertilize when in growth and takes a totally dry rest in winter, easy to grow.	\N	\N	Tubers
BX 398	BULBS	9	Lachenalia rubida var. bulbifera	Uli Urban	A nice and easy to grow plant, the bulbili are fresh and were harvested today. It is a winter growing plant with early spring flowers.	\N	\N	Bulbili
BX 398	SEEDS	10	Hippeastrum vittatum	Ralph Carpenter		\N	\N	Seeds
BX 398	SEEDS	11	Hippeastrum blossfeldiae	Ralph Carpenter		\N	\N	Seeds
BX 399	BULBS	8	Drimia haworthioides	Monica Swartz	ex Huntington Botanic Gardens Collection #49314, this fun and easy plant has bulb scales that look like the leaves of a Haworthia when planted at the surface, then it grows fur-edged leaves in winter (they should be dying back now). One of my most requested plants. Doesn't mind year-round water with good drainage. Seems quite freeze hardy in my 8b climate but I have yet to try it in the ground. If one of the loose scales falls off, it will make bulblets on its edges if lightly buried.	\N	\N	Small bulbs
BX 399	BULBS	9	Cyrtanthus mackenii	Monica Swartz	ex Buried Treasures, yellow or orange flowered	\N	\N	Small bulbs
BX 399	BULBS	10	Hippeastrum vittatum	Dell Sherk		\N	\N	Small bulbs
BX 397	BULBS	1	Eucrosia bicolor	Monica Swartz		\N	\N	\N
BX 397	BULBS	2	Cyrtanthus brachyscyphus	Monica Swartz		\N	\N	\N
BX 396	BULBS	1	Habranthus tubispathus	Rimmer deVries	ex Jim Shields	\N	\N	Seedling bulbs
BX 396	BULBS	2	Haemanthus albiflos	Rimmer deVries	one-year bulblets; self-polinated; some fuzzy, some smooth	\N	\N	\N
BX 396	SEEDS	3	Phaedranassa cinerea	Rimmer deVries	OP, leaves, petioles, and scapes somewhat glaucous, ex BX 347	\N	\N	Seed
BX 396	BULBS	4	Achimenes pedunculata	Rimmer deVries	ex BX 357	\N	\N	Stem bulbils
BX 396	BULBS	5	Clinanthus variegatus	Rimmer deVries	apricot, ex Telos	\N	\N	Offsets
BX 398	BULBS	1	Clivia sp.	Rimmer deVries	yellow Clivia sp.: 1 yr old seedings (VERY FEW) These are all Type 1 yellow clivia- that means they always make yellow seedlings no matter what pollen parent you use. The pale yellow flower flower is rather large and loose.	\N	\N	\N
BX 306	SEEDS	3	Schizocarphus nervosa	Pieter van der Walt	 (Syn. Scilla nervosa).W/C Broederstroom, Gauteng	\N	\N	\N
BX 325	SEEDS	35	Camassia leichtlini v. suksdorfi	Gene Mirro	90: very vigorous, tall dark blue from Linn County, OR. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/motie42/camassialeichtvsuks_zpse7a6323b.jpg	\N	\N
BX 325	SEEDS	37	Camassia quamash ssp azurea	Gene Mirro	light blue form; grows near Chehalis, WA. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/motie42/camassiaquamashazurea_zpsf9b594dd.jpg	\N	\N
BX 327	SEEDS	14	Galtonia regalis	Sylvia Sykora	\N	\N	\N	Seeds
BX 327	SEEDS	16	Fritillaria camschatensis	Richard Haard	\N	\N	\N	Seeds
BX 327	SEEDS	17	Veratrum californicum	Richard Haard	\N	\N	\N	Seed
BX 327	SEEDS	19	Albuca namaquensis	Kipp McMichael	\N	\N	\N	\N
BX 327	SEEDS	20	Daubenya comata	Kipp McMichael	\N	\N	\N	\N
BX 327	SEEDS	21	Massonia depressa	Kipp McMichael	several forms	\N	\N	\N
BX 327	SEEDS	22	Massonia pustulata	Kipp McMichael	purple and mostly purple	\N	\N	\N
BX 327	SEEDS	23	Orbea variegata	Kipp McMichael	\N	\N	\N	\N
BX 327	SEEDS	24	Ornithogalum fimbrimarginatum	Kipp McMichael	ex Steve Hammer	\N	\N	\N
BX 328	SEEDS	1	Lilium parvum	Nhu Nguyen	- Sp WC, Nevada Co., CA about 5000ft (1500m), stratification recommended.	\N	Sp	\N
BX 328	SEEDS	2	Lilium sp. (washingtonianum?)	Nhu Nguyen	- Sp WC, Nevada Co., CA about 3500ft (~1000). I found this only in seed so no guarantee of the actual species, but based on location and elevation, it could very well be L. washingtonianum. Stratification recommended although probably not necessary.	\N	Sp	\N
BX 421	SEEDS	15	Habranthus martinezii	Mike Kent	\N	\N	\N	Seeds
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
BX 317	SEEDS	32	Dierama	M Gastil-Buhl	more than 5ft tall, white from UCSB seed in 1990s	http://www.flickr.com/photos/gastils_garden/7475678760/in/set-72157630359362966/	\N	\N
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
BX 328	SEEDS	20	Haemanthus coccineus	Kipp McMichael	ex Arid Lands, Outshoorn	\N	\N	Seeds
BX 328	SEEDS	22	Ornithogalum fimbrimarginatum	Kipp McMichael	\N	\N	\N	Seed
BX 328	SEEDS	17	Diplarrhena moraea	Kathleen Sayce	parent is white flowered, selfed (no other Diplarrhenas for males)	\N	\N	\N
BX 326	BULBS	18	Chlorogalum pomeridianum	Kipp McMichael	. From seed collected on Mt Diablo, Contra Costa County, California	\N	\N	Small bulbs
BX 326	BULBS	19	Massonia pustulata	Kipp McMichael	solid purple or mostly purple leaves	\N	\N	Small bulbs
BX 329	SEEDS	1	Rhodophiala bifida	Tony Avent and Plants Delights Nursery	carmine	\N	\N	Seed
BX 329	SEEDS	2	Lilium leichtlinii	Tony Avent and Plants Delights Nursery	var maximowiczh ?	\N	\N	Seed
BX 329	SEEDS	3	Crinum	Tony Avent and Plants Delights Nursery	PDN#015 [(C. forb x mac) x (mac x acaule)] - already germinating	\N	\N	Seed
BX 329	SEEDS	4	Crinum variabile	Tony Avent and Plants Delights Nursery	(already germinating)	\N	\N	Seed
BX 329	BULBS	5	Ismene 'Festalis'	Kathleen Sayce	\N	\N	\N	ONE bulb
BX 329	BULBS	6	Albuca nelsonii	Kathleen Sayce	from BX 301 ex Pam Slate	\N	\N	ONE bulb
BX 329	SEEDS	7	Cardiocrinum giganteum	Paige Woodward	\N	\N	\N	Seed
BX 329	SEEDS	8	Cardiocrinum cordatum var glehnii	Paige Woodward	\N	\N	\N	Seed
BX 329	SEEDS	9	Allium subhirsutum	Donald Leevers	\N	\N	\N	\N
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
BX 313	SEEDS	23.2	Tigridia pavonia mixed	Gordon Julian	Second item #23	\N	\N	\N
BX 311	SEEDS	1	Narcissus cantabricus 'Silver Palace'	Arnold Trachtenberg	(OP)	\N	\N	\N
BX 311	SEEDS	2	Narcissus cordubensis	Arnold Trachtenberg	? (OP)	\N	\N	\N
BX 311	SEEDS	3	Narcissus cantabricus clusii	Arnold Trachtenberg	? (OP)	\N	\N	\N
BX 311	SEEDS	4	Narcissus romieuxii mesatlanticus	Arnold Trachtenberg	? (OP)	\N	\N	\N
BX 311	SEEDS	5	Narcissus romieuxii 'Julia Jane'	Arnold Trachtenberg	(OP)	\N	\N	\N
BX 329	SEEDS	10	Anomatheca laxa	Donald Leevers	\N	\N	\N	\N
BX 329	SEEDS	11	Gladiolus tristis	Donald Leevers	\N	\N	\N	\N
BX 329	SEEDS	12	Habranthus martinezii	Donald Leevers	\N	\N	\N	\N
BX 329	SEEDS	13	Habranthus brachyandrus	Donald Leevers	\N	\N	\N	\N
BX 329	SEEDS	14	Habranthus andersonii	Donald Leevers	\N	\N	\N	\N
BX 311	SEEDS	6	Narcissus assoanus minutus	Arnold Trachtenberg	? (OP)	\N	\N	\N
BX 311	SEEDS	7	Narcissus bulbocodium	Arnold Trachtenberg	(OP)	\N	\N	\N
BX 311	SEEDS	8	Gladiolus maculatus	Arnold Trachtenberg	\N	\N	\N	\N
BX 311	SEEDS	9	Massonia echinata	Arnold Trachtenberg	ex BX 247	\N	\N	\N
BX 311	SEEDS	10	Cyclamen coum 'Yayladgi'	Arnold Trachtenberg	(may only be shipped to US members because of CITES regulations). Yaylada is a city in Turkey near the Syrian border. 	http://pacificbulbsociety.org/pbswiki/index.php/CyclamenSpeciesOne#coum	\N	\N
BX 402	BULBS	7	Gladiolus sericeo-villosus	Uli Urban	ONE corm	\N	\N	Corm
BX 336	SEEDS	9	Crinum herbertii	Lynn Makela	\N	\N	\N	\N
BX 401	SEEDS	1	Zephyranthes fosteri	Ina Crossley	pink/white mix	\N	\N	\N
BX 401	SEEDS	2	Zephyranthes katheriniae 'Rubra'	Ina Crossley	\N	\N	\N	\N
BX 401	SEEDS	3	Zephyranthes minuta	Ina Crossley	\N	\N	\N	\N
BX 401	SEEDS	4	Zephyranthes verecunda	Ina Crossley	(Mexican), syn. Z. minuta	\N	\N	\N
BX 401	SEEDS	5	Zephyranthes citrina	Ina Crossley	\N	\N	\N	\N
BX 401	SEEDS	6	Zephyranthes minima	Ina Crossley	\N	\N	\N	\N
BX 401	SEEDS	7	Zephyranthes mesochloa	Ina Crossley	\N	\N	\N	\N
BX 401	SEEDS	8	Zephyranthes lindleyana	Ina Crossley	\N	\N	\N	\N
BX 401	SEEDS	9	Zephyranthes morrisclintii 'Red Neck Romance'	Ina Crossley	\N	\N	\N	\N
BX 401	SEEDS	10	Zephyranthes macrosiphon	Ina Crossley	\N	\N	\N	\N
BX 401	SEEDS	11	Zephyranthes 'Pink Beauty'	Ina Crossley	\N	\N	\N	\N
BX 401	SEEDS	12	Zephyranthes dichromantha	Ina Crossley	\N	\N	\N	\N
BX 401	SEEDS	13	Zephyranthes verecunda 'Rosea'	Ina Crossley	\N	\N	\N	\N
BX 401	SEEDS	14	Zephyranthes primulina	Ina Crossley	\N	\N	\N	\N
BX 401	SEEDS	15	Zephyranthes smallii	Ina Crossley	\N	\N	\N	\N
BX 401	SEEDS	16	Zephyranthes reginae	Ina Crossley	\N	\N	\N	\N
BX 401	SEEDS	17	Zephyranthes miradorensis	Ina Crossley	\N	\N	\N	\N
BX 401	SEEDS	18	x Hippeastrelia	Ina Crossley	\N	\N	\N	\N
BX 401	SEEDS	19	Clivia miniata	Jill Peterson	from a variegated orange flowered clivia crossed with a yellow flowered non-variegated one.	\N	\N	\N
BX 401	SEEDS	20	Clivia nobilis	Marvin Ellenbecker	\N	\N	\N	\N
BX 401	SEEDS	21	Hippeastrum papilio	Marvin Ellenbecker	\N	\N	\N	\N
BX 422	SEEDS	1	Brodiaea californica	Jim Barton	\N	\N	\N	\N
BX 402	BULBS	6	Begonia falciloba	Uli Urban	\N	\N	\N	Tubers
BX 402	SEEDS	8	Thunia marshalliana	Uli Urban	Thunia marshalliana is a terrestrial orchid which can be grown exactly like a geophyte. It needs a warm and sunny place in summer (I grow it in the greenhouse in hot conditions) in the open if it is warm and humid enough. Lots of water and fertilizer, the reed like plant becomes quite big. clusters of big white flowers on top of the cane. Totally dry winter dormancy. I repot every year as the roots are also dying off in winter. After the shoot has emerged in spring about 1 or 2 inches long everything is taken apart, the 2-year-old dried up pseudobulb and dead roots cut off and last year's very turgid pseudobulb with the emerging shoot is planted. Compost rich in humus with some amount of powered clay added, lots of water and fertiizer. Dry rest after the leaves start to fall. Orchid seed is for the specialist, it normally needs either the symbiosis with the fungus from the mother plant's soil to germinate or artificial lab sowing on synthetic Agar under sterile condition. I have never done this. Some Orchid seed can germinate like ordinary seed but I do not know if Thunia will do so.	\N	\N	Seed
BX 402	BULBS	9	Zephyranthes pulchella	Charles Crane	Blooming-size Bulbs: (let Dell know if you want detailed information about collection locations.)	\N	\N	\N
BX 402	BULBS	10	Zephyranthes smallii	Charles Crane	Blooming-size Bulbs: (let Dell know if you want detailed information about collection locations.)	\N	\N	\N
BX 402	BULBS	11	Habranthus tubispathus	Charles Crane	Blooming-size Bulbs: (let Dell know if you want detailed information about collection locations.)	\N	\N	\N
BX 402	BULBS	12	Albuca 'Augrabies Hills'	Pamela Slate	Blooming-size Bulbs:	\N	\N	\N
BX 402	BULBS	13	Albuca sp.	Pamela Slate	? from a Tucson grower named Dorothy Pasek (Plantas del Sol) who worked at The HBG at one time. It came labeled as Albuca sp. (Pachuis Pass, S. Africa). The small bulbs are mostly flowering size and plant growth is grassy. Blooming-size Bulbs:	\N	\N	\N
BX 402	BULBS	14	Hippeastrum 'Sydney'	Sophie Dixon	selfed	\N	\N	Seeds
BX 402	BULBS	15	Hippeastrum 'Emerald' x 'Apple Blossom' x 'Sovereign'	Sophie Dixon	\N	\N	\N	Seeds
BX 403	BULBS	1	Oxalis bifurca	Mary Sue Ittner	\N	\N	\N	\N
BX 403	BULBS	2	Oxalis caprina	Mary Sue Ittner	\N	\N	\N	\N
BX 311	SEEDS	13	Narcissus minor	Rimmer deVries	hybs, parents include 'Weebee','Mite', 'Small Talk', etc.	\N	\N	Seed
BX 311	SEEDS	14	Polyxena	Rimmer deVries	ex Silverhill 11152- from BX 240 previously from NARGS 07/08 donated by Mike Slater	\N	\N	Seed
BX 402	BULBS	1	Notholirion thomsonianum	Rimmer deVries	ex Illhea Bulbs - basal bulblets.	\N	\N	\N
BX 402	BULBS	2	Gloxinia sylvatica	Rimmer deVries	or Seemannia sylvatica ( Bolivian sunset )- rhizomes, plant 1 inch deep each piece will become a new plant	\N	\N	\N
BX 402	SEEDS	4	Phaedranassa sp.	Rimmer deVries	ex BX 335 came as P. tunguraguae - cross between sister seedlings.	\N	\N	\N
BX 403	BULBS	3	Oxalis compressa	Mary Sue Ittner	\N	\N	\N	\N
BX 403	BULBS	4	Oxalis flava	Mary Sue Ittner	(lupinifolia)	\N	\N	\N
BX 403	BULBS	5	Oxalis imbricata	Mary Sue Ittner	\N	\N	\N	\N
BX 403	BULBS	6	Oxalis livida	Mary Sue Ittner	\N	\N	\N	\N
BX 403	BULBS	7	Oxalis massoniana	Mary Sue Ittner	\N	\N	\N	\N
BX 403	BULBS	8	Oxalis melanosticta 'Ken Aslet'	Mary Sue Ittner	\N	\N	\N	\N
BX 403	BULBS	9	Oxalis obtusa	Mary Sue Ittner	(coral)	\N	\N	\N
BX 403	BULBS	10	Oxalis obtusa	Mary Sue Ittner	MV5005A	\N	\N	\N
BX 403	BULBS	11	Oxalis obtusa	Mary Sue Ittner	MV5051	\N	\N	\N
BX 403	BULBS	12	Oxalis obtusa	Mary Sue Ittner	MV6235	\N	\N	\N
BX 403	BULBS	13	Oxalis obtusa	Mary Sue Ittner	MV7085A	\N	\N	\N
BX 403	BULBS	14	Oxalis obtusa 'Peaches & Cream'	Mary Sue Ittner	\N	\N	\N	\N
BX 403	BULBS	15	Oxalis obtusa	Mary Sue Ittner	(pink)	\N	\N	\N
BX 403	BULBS	16	Oxalis pardalis	Mary Sue Ittner	MV7632	\N	\N	\N
BX 403	BULBS	17	Oxalis polyphylla var. heptaphylla	Mary Sue Ittner	MV6396 (there is disagreement about this name)	\N	\N	\N
BX 403	BULBS	18	Oxalis purpurea 'Lavender & White'	Mary Sue Ittner	\N	\N	\N	\N
BX 403	BULBS	19	Oxalis purpurea 'Skar'	Mary Sue Ittner	\N	\N	\N	\N
BX 403	BULBS	20	Oxalis purpurea	Mary Sue Ittner	(white)	\N	\N	\N
BX 403	BULBS	21	Oxalis zeekoevleyensis	Mary Sue Ittner	\N	\N	\N	\N
BX 403	BULBS	22	Tulipa batalinii	Mary Sue Ittner	(yellow form of T. linifolia)	\N	\N	\N
BX 403	BULBS	23	Tulipa humilis 'Red Cup'	Mary Sue Ittner	(don't know if this tulip is correctly named; see wiki for description	\N	\N	\N
BX 403	BULBS	24	Tulipa linifolia	Mary Sue Ittner	\N	\N	\N	\N
BX 403	BULBS	25	Pamianthe peruviana	Paul Matthews	\N	\N	\N	Seeds
BX 404	BULBS	1	Hymenocallis guerreroensis	Monica Swartz	ex BX 209, though some H. phalangides seed may have gotten mixed in since they were both dropping seed all over the place	\N	\N	Seeds
BX 404	BULBS	2	Massonia echinata	Monica Swartz	Mesa Gardens form ex BX 247	\N	\N	Bulbs
BX 404	BULBS	3	Massonia echinata	Monica Swartz	ex Roy Herold labeled M28 'depressa'	\N	\N	Bulbs
BX 404	BULBS	4	Tritonia crocata	John Wickham	ex UC Berkeley Bot Gar.	\N	\N	\N
BX 404	BULBS	5	Freesia elimensis	John Wickham	(syn.? F. caryophyllacea)	\N	\N	\N
BX 404	BULBS	6	Tritonia 'Rosy Picture'	John Wickham	\N	\N	\N	\N
BX 404	BULBS	7	Tritonia 'Bermuda Sands'	John Wickham	\N	\N	\N	\N
BX 404	BULBS	8	Tritonia crocata	John Wickham	white, ex Annies Annuals	\N	\N	\N
BX 404	BULBS	9	Freesia fucata	John Wickham	ex UC Berkeley Bot. Gar.	\N	\N	\N
BX 404	BULBS	10	Tritonia hybrid	John Wickham	pink, ex The Bulb Man	\N	\N	\N
BX 404	BULBS	11	Tritonia 'Salmon'	John Wickham	\N	\N	\N	\N
BX 404	BULBS	12	Tritonia 'Charles Puddles'	John Wickham	\N	\N	\N	\N
BX 404	BULBS	13	Tritonia 'Avalanche'	John Wickham	\N	\N	\N	\N
BX 404	BULBS	14	Tritonia deusta subsp. miniata	John Wickham	\N	\N	\N	\N
BX 404	BULBS	15	Tritonia parvula	John Wickham	\N	\N	\N	\N
BX 404	BULBS	16	Tritonia lineata	John Wickham	\N	\N	\N	\N
BX 404	BULBS	17	Tritonia flabellifolia	John Wickham	\N	\N	\N	\N
BX 404	BULBS	18	Nerine sarniensis 'Miss Fraunce Clarke'	Pamela Slate	\N	\N	\N	\N
BX 404	BULBS	19	Ixia flexuosa	Pamela Slate	pink, ex BX 292 from Mike Mace, ex Jim Duggan	\N	\N	\N
BX 404	BULBS	20	Lachenalia aloides var. quadricolor	Pamela Slate	ex Plants for the Southwest	\N	\N	\N
BX 404	BULBS	21	Lachenalia contaminata	Pamela Slate	\N	\N	\N	\N
BX 404	BULBS	22	Cyclamen graecum	Ruth Jones	\N	\N	\N	Small tubers
BX 422	SEEDS	2	Brodiaea elegans	Jim Barton	\N	\N	\N	\N
BX 405	BULBS	3	Cyclamen rohlfsianum	Roy Herold	93-14, large dark green, reniform leaves heavily marked with silver. Pink flowers. Pea-size tubers, one year old	\N	\N	Small tubers
BX 405	BULBS	4	Cyclamen rohlfsianum	Roy Herold	93-8, medium green maple leaf shaped leaves, well marked. Pink flowers.	\N	\N	Small tubers
BX 405	BULBS	5	Leucojum aestivum 'Gravetye Giant'	Pamela Slate	\N	\N	\N	\N
BX 405	BULBS	6	Watsonia 'Flamboyant'	Pamela Slate	brilliant deep coral flower	\N	\N	\N
BX 405	BULBS	7	Ferraria schaeferi	Pamela Slate	ex BX 292 Mace	\N	\N	\N
BX 405	BULBS	8	Ferraria crispa	Pamela Slate	ssp. nortieri	\N	\N	\N
BX 405	BULBS	9	Albuca sp.	Pamela Slate	finally ID'd as A. acuminata, epigeal	\N	\N	\N
BX 405	SEEDS	10	Crinum lugardiae	Tim Eck	\N	\N	\N	Seed
BX 405	SEEDS	11	Eucrosia aurantiaca	Alberto Grossi	\N	\N	\N	Seeds
BX 405	SEEDS	12	Chlorophytum saundersiae	Alberto Grossi	\N	\N	\N	Seeds
BX 405	BULBS	13	Zephyranthes candida	Judy Glattstein	\N	\N	\N	Bulbs
BX 406	BULBS	1	Cyrtanthus epiphyticus	Roy Herold	ex BX154	\N	\N	\N
BX 406	BULBS	2	Freesia laxa 'Joan Evans'	Roy Herold	\N	\N	\N	\N
BX 404	BULBS	24	Scilla	Rimmer deVries	(Hyacinthoides) lingulata ex Paul Otto- late fall blooming, zone 7 (or zone 4 in a cold frame)	\N	\N	Bulbs
BX 405	SEEDS	1	Hymenocallis harrisiana	Rimmer deVries	\N	\N	\N	Seeds
BX 405	BULBS	2	Nothoscordum gracile var. macrostemon	Rimmer deVries	Chile, ex Harry Hay ex MSI	\N	\N	Bulbs
BX 406	BULBS	3	Lapeirousia jacquinii	Roy Herold	\N	\N	\N	\N
BX 406	BULBS	4	Massonia sp.	Roy Herold	\N	\N	\N	\N
BX 406	BULBS	5	Narcissus 'albidus occidentalis' N028	Roy Herold	N028	\N	\N	\N
BX 406	BULBS	6	Narcissus 'albidus zaianicus'	Roy Herold	\N	\N	\N	\N
BX 406	BULBS	7	Narcissus bulbocodium	Roy Herold	ex Morocco, few	\N	\N	\N
BX 406	BULBS	8	Narcissus bulbocodium var. graellsii	Roy Herold	N007	\N	\N	\N
BX 406	BULBS	9	Narcissus bulbocodium	Roy Herold	N020	\N	\N	\N
BX 406	BULBS	10	Narcissus bulbocodium var. obesus	Roy Herold	N024	\N	\N	\N
BX 406	BULBS	11	Narcissus bulbocodium subsp. praecox	Roy Herold	(paucinervis) ex BX348	\N	\N	\N
BX 406	BULBS	12	Narcissus bulbocodium var. tenuifolius	Roy Herold	N022	\N	\N	\N
BX 406	BULBS	13	Narcissus cantabricus var. foliosus	Roy Herold	N001	\N	\N	\N
BX 406	BULBS	14	Narcissus cantabricus 'Peppermint'	Roy Herold	\N	\N	\N	\N
BX 406	BULBS	15	Narcissus 'Joy Bishop'	Roy Herold	N068	\N	\N	\N
BX 406	BULBS	16	Narcissus 'Julia Jane'	Roy Herold	#1, N106, ex McGary. The three types of Julia Jane are slightly different from one another.	\N	\N	\N
BX 406	BULBS	17	Narcissus 'Julia Jane'	Roy Herold	#2, ex Odyssey. The three types of Julia Jane are slightly different from one another.	\N	\N	\N
BX 406	BULBS	18	Narcissus 'Julia Jane'	Roy Herold	#3, ex SRGC. The three types of Julia Jane are slightly different from one another.	\N	\N	\N
BX 406	BULBS	19	Narcissus nevadensis	Roy Herold	N087	\N	\N	\N
BX 406	BULBS	20	Narcissus romieuxii 'Atlas Gold'	Roy Herold	JCA805Y, few	\N	\N	\N
BX 406	BULBS	21	Narcissus romieuxii subsp. albidus var. tananicus	Roy Herold	N002	\N	\N	\N
BX 406	BULBS	23	Narcissus 'Stockens Gib'	Roy Herold	\N	\N	\N	\N
BX 406	BULBS	24	Narcissus 'Tarlatan'	Roy Herold	\N	\N	\N	\N
BX 406	BULBS	25	Narcissus 'Treble Chance'	Roy Herold	JCA805, N066	\N	\N	\N
BX 406	BULBS	26	Narcissus 'Mixed Seedlings'	Roy Herold	These date back to a mass sowing in 2004 of seed from moderately controlled crosses of romieuxii, cantabricus, albidus, zaianicus, and similar early blooming sorts of the bulbocodium group. Colors tend to be light yellow through cream to white, and flowers are large, much larger than the little gold colored bulbocodiums of spring. These have been selected four times, and the keepers are choice. Similar to my 2012 and 2014 PBS offerings.	\N	\N	\N
BX 407	BULBS	1	Nerine 'humilis breachiae	Roy Herold	ex BX 214, offsets	\N	\N	\N
BX 407	BULBS	2	Nerine hybrid	Roy Herold	G36 ex BX214, offsets	\N	\N	\N
BX 407	BULBS	3	Nerine 'November Cheer'	Roy Herold	\N	\N	\N	\N
BX 407	BULBS	4	Nerine sarniensis	Roy Herold	screaming orange, offsets	\N	\N	\N
BX 407	BULBS	5	Ornithogalum osmynellum	Roy Herold	(Albuca osmynella) ex Hammer	\N	\N	\N
BX 407	BULBS	6	Oxalis bowiei	Roy Herold	\N	\N	\N	\N
BX 407	BULBS	7	Oxalis flava	Roy Herold	(lupinifolia) ex BX152	\N	\N	\N
BX 407	BULBS	8	Oxalis gracilis	Roy Herold	BX207, ex Uli	\N	\N	\N
BX 407	BULBS	10	Oxalis polyphylla var. heptaphylla	Roy Herold	\N	\N	\N	\N
BX 407	BULBS	11	Oxalis sp.	Roy Herold	RH11, Silvermine. Found growing in running water, in shade. Flower similar to O. versicolor, but blooms in spring and is a much smaller plant.	\N	\N	\N
BX 407	BULBS	12	Oxalis sp.	Roy Herold	flava group, big yellow fl, succulent blue lf, ex Uli Bx 183	\N	\N	\N
BX 407	BULBS	13	Oxalis	Roy Herold	Uli 69 (flava?), ex BX152	\N	\N	\N
BX 407	BULBS	14	Tecophilaea cyanocrocus var. leichtlinii	Roy Herold	ex McGary, few	\N	\N	\N
BX 407	BULBS	15	Tecophilaea hybrid	Roy Herold	(cyanocrocus var. leichtlinii x cyanocrocus), few. Result of hand pollinated, controlled greenhouse crosses. Curiously, most of the seedlings from the straight cyanocrocus parent look like leichtlinii. Perhaps the latter is dominant?	\N	\N	\N
BX 407	BULBS	16	Tecophilaea hybrid	Roy Herold	(cyanocrocus x cyanocrocus var. leichtlinii), few. Result of hand pollinated, controlled greenhouse crosses. Curiously, most of the seedlings from the straight cyanocrocus parent look like leichtlinii. Perhaps the latter is dominant?	\N	\N	\N
BX 407	SEEDS	17	Cyclamen rohlfsianum	Roy Herold	93-14, large dark green, reniform leaves heavily marked with silver. Pink flowers. (PLANT IMMEDIATELY)	\N	\N	Fresh seeds
BX 407	SEEDS	18	Cyclamen rohlfsianum	Roy Herold	93-8, medium green maple leaf shaped leaves, well marked. Pink flowers. (PLANT IMMEDIATELY)	\N	\N	Fresh seeds
BX 407	SEEDS	19	Cyclamen graecum	Roy Herold	92-2, dark green leaves with bright silver markings. Pink flowers. (PLANT IMMEDIATELY)	\N	\N	Fresh seeds
BX 407	BULBS	20	Oxalis bowiei	John Willis	\N	\N	\N	\N
BX 407	BULBS	21	Oxalis hirta	John Willis	pink	\N	\N	\N
BX 407	BULBS	22	Oxalis luteola	John Willis	glauca	\N	\N	\N
BX 407	BULBS	23	Oxalis polyphylla var. heptaphylla	John Willis	\N	\N	\N	\N
BX 407	BULBS	24	Oxalis purpurea cv.	John Willis	\N	\N	\N	\N
BX 407	BULBS	25	Oxalis purpurea 'Skar'	John Willis	\N	\N	\N	\N
BX 408	BULBS	1	Iris tuberosa	Jane McGary	(syn. Hermodactylus tuberosum), small bulbs	\N	\N	\N
BX 408	BULBS	2	Acis valentina	Jane McGary	(syn. Leucojum valentinum.), fall-flowering	\N	\N	\N
BX 408	BULBS	3	Hyacinthoides lingulata	Jane McGary	(subsp. ciliolata), late fall flowering, blue, 6-8 cm tall, best frost-free	\N	\N	\N
BX 408	BULBS	4	Acis tingitana	Jane McGary	(syn. Leucojum tingitanum), North Africa, 30 cm, probably best frost-free	\N	\N	\N
BX 408	BULBS	5	Notholirion thomsonianum	Jane McGary	fragrant pale lavender trumpet flowers on tall stems, tolerant of various conditions in the Pacific Coast garden given some drainage	\N	\N	\N
BX 408	BULBS	6	Colchicum boissieri	Jane McGary	pink, fall-flowering miniature species, corms extend horizontally, plant flat with any visible roots on the underside. Quite hardy.	\N	\N	\N
BX 408	BULBS	7	Sternbergia lutea	Jane McGary	typical form, fall-flowering, requires excellent drainage and a warm, dry summer. In spring, protect from bulb fly! NOTE: In conformity with CITES guidelines, Sternbergia spp., cannot be sent outside the US.	\N	\N	\N
BX 408	BULBS	8	Sternbergia lutea	Jane McGary	small form. About half the size of the typical plant, but free flowering and fast increasing. May be the form reported from Crete. Same requirements as typical form. NOTE: In conformity with CITES guidelines, Sternbergia spp., cannot be sent outside the US.	\N	\N	\N
BX 408	BULBS	9	Oxalis hirta	Nhu Nguyen	\N	\N	\N	\N
BX 408	BULBS	10	Oxalis hirta	Nhu Nguyen	mauve	\N	\N	\N
BX 408	BULBS	11	Oxalis flava	Nhu Nguyen	\N	\N	\N	\N
BX 408	BULBS	12	Oxalis massoniana	Nhu Nguyen	\N	\N	\N	\N
BX 408	BULBS	13	Oxalis cathara	Nhu Nguyen	\N	\N	\N	\N
BX 408	BULBS	14	Oxalis bowiei	Nhu Nguyen	\N	\N	\N	\N
BX 408	BULBS	15	Oxalis polyphylla	Nhu Nguyen	\N	\N	\N	\N
BX 408	BULBS	16	Lachenalia multifolia	Nhu Nguyen	\N	\N	\N	\N
BX 408	BULBS	17	Allium amplectens	Nhu Nguyen	\N	\N	\N	\N
BX 408	BULBS	18	Lachenalia ensifolia	Nhu Nguyen	(Polyxena pygmaea)	\N	\N	\N
BX 408	BULBS	19	Strumaria tenella	Nhu Nguyen	\N	\N	\N	\N
BX 408	BULBS	20	Narcissus bulbocodium	Nhu Nguyen	\N	\N	\N	\N
BX 408	BULBS	21	Gladiolus alatus	Nhu Nguyen	\N	\N	\N	\N
BX 408	BULBS	22	Ferraria crispa	Nhu Nguyen	\N	\N	\N	\N
BX 408	BULBS	23	Lapeirousia plicata	Nhu Nguyen	\N	\N	\N	\N
BX 409	BULBS	1	Oxalis versicolor	John Willis	.	\N	\N	Bulbs
BX 409	BULBS	2	Moraea sp.	Nhu Nguyen	light yellow	\N	\N	\N
BX 409	BULBS	3	Hesperantha pauciflora	Nhu Nguyen	\N	\N	\N	\N
BX 409	BULBS	4	Gladiolus arcuatus	Nhu Nguyen	\N	\N	\N	\N
BX 409	BULBS	5	Sparaxis grandiflora	Nhu Nguyen	\N	\N	\N	\N
BX 409	BULBS	6	Sparaxis tricolor	Nhu Nguyen	\N	\N	\N	\N
BX 409	BULBS	7	Ferraria divaricata	Dee Foster	\N	\N	\N	\N
BX 409	BULBS	8	Freesia viridis	Dee Foster	\N	\N	\N	\N
BX 409	BULBS	9	Babiana ecklonii	Dee Foster	\N	\N	\N	\N
BX 409	BULBS	10	Lachenalia aloides var. quadricolor	Dee Foster	\N	\N	\N	\N
BX 409	BULBS	11	Moraea ciliata	Robert Werra	tall blue	\N	\N	Cormlets
BX 409	BULBS	12	Moraea ciliata	Robert Werra	short white	\N	\N	Cormlets
BX 409	BULBS	13	Lilium bulbiferum	Robert Werra	\N	\N	\N	Bulbils
BX 409	SEEDS	14	Boophone 'Sp. Aus.'	Kipp McMichael	very wavy gray leaves	\N	\N	Seeds
BX 409	BULBS	15	Lilium lancifolium	Joyce Miller	\N	\N	\N	Bulbils
BX 409	BULBS	16	Rhodophiala bifida	Judy Glattstein	\N	\N	\N	Small bulbs
BX 409	BULBS	17	Freesia 'Port Salut'	Judy Glattstein	\N	\N	\N	Small corms
BX 409	BULBS	18	Freesia 'Red River'	Judy Glattstein	few	\N	\N	Small corms
BX 410	BULBS	1	Allium subvillosum	Mary Sue Ittner	\N	\N	\N	\N
BX 410	BULBS	2	Baeometra uniflora	Mary Sue Ittner	\N	\N	\N	\N
BX 410	BULBS	3	Dichelostemma multiflorum	Mary Sue Ittner	\N	\N	w	\N
BX 410	BULBS	4	Ferraria crispa	Mary Sue Ittner	\N	\N	\N	\N
BX 410	BULBS	5	Ferraria crispa subsp. nortieri	Mary Sue Ittner	\N	\N	\N	\N
BX 410	BULBS	6	Freesia caryophyllacea	Mary Sue Ittner	(fall blooming)	\N	w	\N
BX 410	BULBS	7	Freesia fergusoniae	Mary Sue Ittner	(hybrid?)	\N	\N	\N
BX 410	BULBS	8	Freesia laxa subsp. azurea	Mary Sue Ittner	(winter growing)	\N	w	\N
BX 410	BULBS	9	Lachenalia bulbifera	Mary Sue Ittner	\N	\N	\N	\N
BX 410	BULBS	10	Moraea bellendenii	Mary Sue Ittner	\N	\N	w	\N
BX 410	BULBS	11	Moraea ciliata	Mary Sue Ittner	\N	\N	w	\N
BX 410	BULBS	12	Moraea lurida	Mary Sue Ittner	\N	\N	w	\N
BX 410	BULBS	13	Moraea 'Zoe'	Mary Sue Ittner	offsets and offspring	\N	w	\N
BX 410	BULBS	14	Narcissus romieuxii	Mary Sue Ittner	\N	\N	w	\N
BX 410	BULBS	15	Oxalis flava	Mary Sue Ittner	(mostly pink?)	\N	w	\N
BX 410	BULBS	16	Oxalis luteola	Mary Sue Ittner	MV 5567	\N	w	\N
BX 410	BULBS	17	Spiloxene capensis	Mary Sue Ittner	\N	\N	w	\N
BX 410	BULBS	18	Oxalis imbricata	Fred Thorne	\N	\N	\N	Bulbs
BX 411	SEEDS	1	Nerine angustifolia	Kathleen Sayce	(FEW)	\N	\N	Seeds
BX 411	BULBS	4	Albuca clanwilliamae	Karl Church	-gloria	\N	\N	Small bulbs or comes
BX 411	BULBS	5	Gladiolus tristis	Karl Church	\N	\N	\N	Small bulbs or comes
BX 411	BULBS	6	Oxalis glabra	Karl Church	\N	\N	\N	Small bulbs or comes
BX 411	BULBS	7	Oxalis purpurea	Karl Church	pink	\N	\N	Small bulbs or comes
BX 411	BULBS	8	Tritonia laxifolia	Karl Church	\N	\N	\N	Small bulbs or comes
BX 411	BULBS	9	Ixia longituba var. bellendenii	Karl Church	\N	\N	\N	Small bulbs or comes
BX 411	BULBS	10	Lachenalia mutabilis	Karl Church	ex Swartz, BX 181	\N	\N	Small bulbs or comes
BX 411	BULBS	11	Lachenalia mutabilis	Karl Church	ex CSSA	\N	\N	Small bulbs or comes
BX 411	BULBS	12	Lachenalia mutabilis	Karl Church	ex BX 353	\N	\N	Small bulbs or comes
BX 411	BULBS	13	Oxalis caprina	Karl Church	ex Ittner	\N	\N	Small bulbs or comes
BX 411	BULBS	14	Oxalis bowiei	Karl Church	pink, ex BX 338	\N	\N	Small bulbs or comes
BX 411	BULBS	15	Tritonia deusta	Karl Church	selfed	\N	\N	Small bulbs or comes
BX 411	BULBS	16	Freesia laxa	Karl Church	\N	\N	\N	Small bulbs or comes
BX 411	BULBS	17	Lachenalia mediana	Karl Church	\N	\N	\N	Small bulbs or comes
BX 411	BULBS	18	Lachenalia viridiflora	Karl Church	\N	\N	\N	Small bulbs or comes
BX 411	BULBS	19	Gladiolus uysiae	Karl Church	\N	\N	\N	Small bulbs or comes
BX 411	BULBS	20	Babiana 'Purple Haze'	Karl Church	ex Wickham	\N	\N	Small bulbs or comes
BX 411	BULBS	21	Lachenalia aloides	Karl Church	\N	\N	\N	Small bulbs or comes
BX 411	BULBS	22	Ferraria divaricata subsp. arenosa	Karl Church	ex Telos	\N	\N	Small bulbs or comes
BX 411	BULBS	23	Ferraria crispa	Karl Church	dark form, ex BX 343	\N	\N	Small bulbs or comes
BX 412	BULBS	1	Oxalis caprina	Jim Barton	\N	\N	\N	Small bulbs or comes
BX 412	BULBS	2	Conanthera trimaculata	Jim Barton	\N	\N	\N	Small bulbs or comes
BX 412	BULBS	3	Babiana sp.	Jim Barton	\N	\N	\N	Small bulbs or comes
BX 412	BULBS	4	Ornithogalum maculatum	Jim Barton	\N	\N	\N	Small bulbs or comes
BX 412	BULBS	5	Oxalis obtusa	Jim Barton	\N	\N	\N	Small bulbs or comes
BX 412	BULBS	6	Oxalis obtusa	Jim Barton	MV 5414A	\N	\N	Small bulbs or comes
BX 412	BULBS	7	Oxalis fabifolia	Jim Barton	\N	\N	\N	Small bulbs or comes
BX 412	BULBS	8	Lachenalia anguinea	Jim Barton	\N	\N	\N	Small bulbs or comes
BX 412	BULBS	9	Gladiolus tristis	Jim Barton	x alatus	\N	\N	Small bulbs or comes
BX 412	BULBS	10	Gladiolus virescens	Jim Barton	\N	\N	\N	Small bulbs or comes
BX 412	BULBS	11	Gladiolus alatus	Jim Barton	\N	\N	\N	Small bulbs or comes
BX 412	BULBS	12	Gladiolus cf	Jim Barton	. violaceo-lineatus	\N	\N	Small bulbs or comes
BX 412	BULBS	13	Chasmanthe floribunda	Jim Barton	\N	\N	\N	Small bulbs or comes
BX 412	BULBS	14	Sparaxis hybrids	Jim Barton	from Hadeco	\N	\N	Small bulbs or comes
BX 412	BULBS	15	Amaryllis belladonna	Jim Barton	hyb, mixed	\N	\N	Small bulbs or comes
BX 412	BULBS	16	Sparaxis grandiflora subsp. violacea	Jim Barton	\N	\N	\N	Small bulbs or comes
BX 412	SEEDS	17	Paeonia cambessedesii	Jane McGary	\N	\N	\N	Seeds
BX 412	SEEDS	18	Cyclamen graecum	Jane McGary	\N	\N	\N	Seeds
BX 412	SEEDS	19	Paeonia mascula 'Gargano'	Angelo Porcelli	\N	\N	\N	Seeds
BX 412	SEEDS	20	Calostemma purpureum	Angelo Porcelli	\N	\N	\N	Seeds
BX 412	BULBS	21	Globba schomburgkii	Keshab Pradhan	(Zingiberaceae)	\N	\N	Bulbils
BX 412	SEEDS	22	Amaryllis belladonna	Kathleen Sayce	dark pink (FEW)	\N	\N	Seeds
BX 412	BULBS	23	Begonia gracilis var. martiana	Uli Urban	. BULBILS They look like seed but are miniature tubers which are produced in large numbers on the nodes. They should not dry out completely but best 'sown' now in a small pot and kept just a little moist from time to time. They will eventually sprout fairly late in May or June, flower the second year. Beautiful upright plant to 75cm tall with large slightly fragrant pink flowers. fully dormant in winter, prone to mildew in autumn.	\N	\N	\N
BX 413	BULBS	8	mixed bulbs	Mary Sue Ittner	mixed lot of small cormlets/bulblets - winter rainfall, probably most from either California or South Africa	\N	\N	\N
BX 412	BULBS	25	Cyrtanthus labiatus	Uli Urban	not flowered for me so far, fleshy bulbs above ground, produces lots and lots of bulbils. From the Muller-Doblies couple. Identity is certain.	\N	\N	\N
BX 412	BULBS	26	Cyrtanthus sp.	Uli Urban	\N	\N	\N	\N
BX 412	SEEDS	27	Scadoxus multiflorus	Uli Urban	subsp katharinae. From Essen Botanical Garden, they have a most impressive giant specimen in a huge tub and sell young seedlings. Slow at first but worth the patience. Big red flower heads in spring. Not fully dormant in winter with me, makes a flush of new stemmed foliage in spring.	\N	\N	Seeds
BX 416	BULBS	14	Gladiolus dalenii 'Boone'	Uli Urban	a straightforward and easy summer grower. The interesting thing about this form is that it has branching inflorescences. These are very small bulbils for obvious reasons. Sometimes they do not sprout, this can be overcome by soaking them overnight in lukewarm water with a small amount of dish washing liquid. This helps the water to penetrate the hard shell to break dormancy.	\N	\N	\N
BX 422	SEEDS	3	Calochortus luteus	Jim Barton	\N	\N	\N	\N
BX 412	BULBS	28	Nymphaea sp.	Uli Urban	tropical blue viviparous. Forms small leaf tubers at the end of the season when the water gets cooler. These LEAF TUBERS can be stored in moist sphagnum, I treated them with a whiff of fungicide before posting, Leaf tubers are much easier to store than adult tubers. Start in spring in a heated aquarium with extra light and plant into a warm pond or large container in full sun when spring weather has warmed up, late May or early June with me. Feed with Osmocote, this does not trouble the water. I have had better results storing the adult potted tubers with almost all the foliage cut off. Stood in a large bucket in a frost free greenhouse in unheated water it made almost no growth until the days got longer and the temperature rose. Adult tubers stored in sphagnum ALWAYS rotted. Beautiful purplish-blue flowers above the water, exquisitely scented.	\N	\N	Leaf tubers
BX 413	SEEDS	7	Hippeastrum calyptratum	Andres Pontieri	\N	\N	\N	Seeds
BX 413	BULBS	9	Nothoscorum dialystemon	Mary Sue Ittner	or Ipheion dialystemon, offset bulblets	\N	\N	\N
BX 413	BULBS	10	Triteleia peduncularis	Mary Sue Ittner	cormlets	\N	\N	\N
BX 413	SEEDS	11	Clivia miniata	Mary Sue Ittner	(light yellow), FEW - recalcitrant- most are already sprouting	\N	\N	\N
BX 413	SEEDS	12	Nerine angustifolia	Mary Sue Ittner	- recalcitrant- most are already sprouting	\N	\N	\N
BX 413	SEEDS	13	Nerine bowdenii	Mary Sue Ittner	- recalcitrant- most are already sprouting	\N	\N	\N
BX 413	SEEDS	14	Nerine platypetala	Mary Sue Ittner	- recalcitrant- most are already sprouting	\N	\N	\N
BX 414	SEEDS	1	Habranthus robustus var. biflorus	Uli Urban	\N	http://www.pacificbulbsociety.org/pbslist/old.php/2007-July/017460.html	\N	\N
BX 414	SEEDS	2	Clivia gardenii x C. miniata	Arnold Trachtenberg	yellow Two photo links: www.srgc.net/forum/index.php?topic=13939.msg348441#msg348441 and	http://www.srgc.net/forum/index.php?topic=11227.msg290033#msg290033	\N	\N
BX 418	BULBS	32	Phaedranassa carmiolii	Rimmer deVries	from Jude H In 3 years these just offset and never got big enough to bloom for me. Last summer I planted them in the garden to try to bulk up and that may be the solution. Lift and pot up before frost.	\N	\N	\N
BX 414	SEEDS	3	Rhodophiala bifida	Cynthia Mueller	pink, very nice vigorous strain that enjoys alkaline soil and can withstand winter cold to Zone 7/6	\N	\N	\N
BX 414	SEEDS	4	Rhodophiala bifida	Cynthia Mueller	larger, redder than usual R. bifida	\N	\N	\N
BX 414	SEEDS	5	Rhodophiala bifida	Cynthia Mueller	typical x #4	\N	\N	\N
BX 414	SEEDS	6	Zephyranthes jonesii	Cynthia Mueller	\N	\N	\N	\N
BX 414	SEEDS	7	Zephyranthes smallii	Cynthia Mueller	\N	\N	\N	\N
BX 414	SEEDS	8	Zephyranthes pulchella	Cynthia Mueller	\N	\N	\N	\N
BX 414	SEEDS	9	Cooperia drummondii	Cynthia Mueller	flowers in mid March (in Cynthia's Texas)	\N	\N	\N
BX 415	SEEDS	5	Habranthus brachyandrus	Brad Maygers	\N	\N	\N	\N
BX 415	SEEDS	6	Zephyranthes primulina	Brad Maygers	\N	\N	\N	\N
BX 415	SEEDS	7	Cardiocrinum giganteum	Don Leevers	\N	\N	\N	\N
BX 415	SEEDS	8	Lilium ledebourii	Pamela Harlow	ex Archibald. 2014 seed	\N	\N	\N
BX 415	SEEDS	9	Bellevalia pycnantha	Pamela Harlow	(B. paradoxa?)	\N	\N	\N
BX 415	SEEDS	10	Paradisea liliastrum	Pamela Harlow	\N	\N	\N	\N
BX 415	SEEDS	11	Arisaema tortuosum	Uli Urban	\N	\N	\N	\N
BX 415	SEEDS	12	Arisaema flavum	Uli Urban	\N	\N	\N	\N
BX 415	SEEDS	13	Hedychium yunnanense	Uli Urban	\N	\N	\N	\N
BX 415	SEEDS	14	Ipomoea lindheimeri	Uli Urban	\N	\N	\N	\N
BX 416	BULBS	1	Achimenes 'Pink Cloud'	Mary Sue Ittner	- from earlier BX, originally was soft pink; later years a bright pink appeared in the middle of the soft pink	\N	\N	\N
BX 416	BULBS	2	Gloxinella lindeniana	Mary Sue Ittner	- from earlier BX	\N	\N	\N
BX 416	BULBS	3	Oxalis sp.	Mary Sue Ittner	Mexico - summer growing - originally from Uli Urban	http://www.pacificbulbsociety.org/pbswiki/index.php/MiscellaneousOxalis#sp	s	\N
BX 416	BULBS	4	Tigridia pavonia 'Sunset in Oz'	Mary Sue Ittner	- bulbs grown from seed with this name	\N	\N	\N
BX 416	BULBS	5	Zantedeschia 'Blaze'	Mary Sue Ittner	\N	\N	\N	\N
BX 416	BULBS	6	Achimenes 'Rosy Frost'	Dennis Kramb	\N	\N	\N	Rhizomes
BX 416	BULBS	7	Achimenes 'Summer Sunset'	Dennis Kramb	\N	\N	\N	Rhizomes
BX 416	BULBS	10	Achimenes patens	Uli Urban	. These are stem bulbils which are much smaller than normal rhizomes and therefore easier to ship. They would benefit from an overnight soak in lukewarm water before planting. The plant itself becomes fairly big, best in a hanging basket. Has a long vegetative period. Large showy purple flowers.	\N	\N	Stem bulbils
BX 416	BULBS	11	Arisaema consanguineum 'The Perfect Wave '	Uli Urban	Arisaema consanguineum 'The Perfect Wave ' and 'Wild Blue Yonder' mixed small tubers. Both are offsets from the original plants, selected by Ellen Hornig. Very beautiful and good performers. Hardy but pot grown with me, performance is better this way. Thanks again to Ellen for sharing these many years ago.	\N	\N	Small tubers
BX 416	BULBS	12	Arisaema tortuosum	Uli Urban	small tubers. Can become very big, mine are seed grown and have flowered and made offsets for the first time last summer. Pot grown and not tested for hardiness.	\N	\N	Small tubers
BX 416	BULBS	13	Gladiolus cruentus	Uli Urban	. Summer growing but has a long growing cycle and flowers late in the season, sometimes spoiled by bad weather. Multiplies well.	\N	\N	Small corms
BX 416	BULBS	15	Sauromatum horsfieldii	Uli Urban	a small and charming plant except for its flowers. They do not smell like rotten meat like most of the family does but their smell seems fairly inoffensive first but is very irritating on the long run. The charm is the foliage: dense low (max 25cm) shining velvety green with some patterns. Best in partial shade. Multiplies rapidly so better keep an eye on it. Mine are pot grown and not yet tested for hardiness.	\N	\N	\N
BX 416	BULBS	16	Sauromatum giganteum	Uli Urban	or Typhonium giganteum: Deep blackish purple spathes before the leaves, I did not notice any offensive smell (no guarantee given). Elegant shiny bright green leaves, arrow shaped appear very late in the season. Not tested for hardiness, full sun.	\N	\N	\N
BX 416	BULBS	17	Scadoxus multiflorus	Uli Urban	. Few seeds only. I had a big infructescense but unfortunately was not aware they would germinate inside the berry if left for too long. I had to sow the germinated seeds for myself. Summer growing, easy, big plants with big red flower balls.	\N	\N	\N
BX 416	BULBS	18	Spathantheum orbignyanum	Uli Urban	. Summer growing Bolivian Aroid with big tubers. Flowers before the leaves. Strange smell. Lush foliage a little like Acanthus. Many people mistake the flowers for thin leaves, the true flowers are arranged toothbrush like UNDER the spathe and not visible from above. Multiplies well, definitely not hardy.	\N	\N	\N
BX 416	BULBS	19	Nymphaea sp.	Uli Urban	not least a few leaf tubers of my lovely blue waterlily (Nymphaea sp.) I wrote an article for the bulb garden on them so will only say: start them now in 25 deg centigrade warm water with maximum light and plant into a warm pond once the weather in your climate gets warm.	\N	\N	Leaf tubers
BX 416	BULBS	20	Haemanthus albiflos	Dell Sherk	\N	\N	\N	\N
BX 416	BULBS	21	Haemanthus pauculifolius	Dell Sherk	originally from Telos	\N	\N	\N
BX 416	BULBS	22	Eucharis amazonica	Dell Sherk	originally from Marie-Paule Opdenakker	\N	\N	\N
BX 416	BULBS	23	Hippeastrum papilio	Bob Hoel	\N	\N	\N	Small bulbs
BX 416	BULBS	24	Ornithogalum saundersiae	Bob Hoel	\N	\N	\N	Small bulbs
BX 417	BULBS	1	Sandersonia aurantiaca	Mary Sue Ittner	\N	\N	\N	\N
BX 417	BULBS	2	Gloriosa modesta	Mary Sue Ittner	(Littonia)	\N	\N	\N
BX 417	BULBS	3	Gloriosa superba	Mary Sue Ittner	\N	\N	\N	\N
BX 417	BULBS	4	Oxalis zeekoevleyensis	Mary Sue Ittner	\N	\N	\N	\N
BX 417	BULBS	5	Oxalis hirta	Mary Sue Ittner	mauve	\N	\N	\N
BX 417	BULBS	6	Oxalis melanosticta 'Ken Aslet'	Mary Sue Ittner	\N	\N	\N	\N
BX 417	BULBS	7	Amorphophallus yuloensis	Fred Thorne	\N	\N	\N	\N
BX 417	BULBS	8	Amorphophallus rivierei	Fred Thorne	(A. konjac)	\N	\N	\N
BX 415	SEEDS	1	Haemanthus albiflos	Rimmer deVries	\N	\N	\N	\N
BX 415	SEEDS	2	Rhodophiala araucana	Rimmer deVries	very few	\N	\N	\N
BX 417	BULBS	9	Amorphophallus bulbifer	Fred Thorne	\N	\N	\N	\N
BX 417	BULBS	10	Amorphophallus albus	Fred Thorne	\N	\N	\N	\N
BX 417	BULBS	11	Amorphophallus symonianus	Fred Thorne	\N	\N	\N	\N
BX 417	BULBS	12	Amorphophallus sp.	Fred Thorne	ex John Mood	\N	\N	\N
BX 417	BULBS	13	Sauromatum venosum	Fred Thorne	(Typhonium)	\N	\N	\N
BX 417	BULBS	14	Zantedeschia hybrids	Fred Thorne	mixed colors	\N	\N	\N
BX 417	BULBS	15	Gloriosa lutea	Fred Thorne	(G. superba)	\N	\N	\N
BX 417	BULBS	16	Oxalis sp.	Fred Thorne	ex Oxaca from Mary Sue Ittner	\N	\N	\N
BX 418	BULBS	2	Oxalis bifurca	Mary Sue Ittner	\N	\N	\N	\N
BX 418	BULBS	3	Oxalis engleriana	Mary Sue Ittner	\N	\N	\N	\N
BX 418	BULBS	4	Oxalis flava	Mary Sue Ittner	(lupinifolia)	\N	\N	\N
BX 418	BULBS	5	Oxalis luteola	Mary Sue Ittner	MV 5567	\N	\N	\N
BX 418	BULBS	6	Oxalis obtusa	Mary Sue Ittner	MV7085	\N	\N	\N
BX 418	BULBS	7	Oxalis obtusa	Mary Sue Ittner	pink	\N	\N	\N
BX 418	BULBS	8	Oxalis purpurea 'Skar'	Mary Sue Ittner	\N	\N	\N	\N
BX 418	BULBS	9	Tulipa linifolia	Mary Sue Ittner	\N	\N	\N	\N
BX 418	BULBS	10	Tulipa sylvestris	Mary Sue Ittner	\N	\N	\N	\N
BX 418	BULBS	11	Oxalis bowiei	Mary Sue Ittner	\N	\N	\N	\N
BX 418	BULBS	12	Oxalis imbricata	Mary Sue Ittner	\N	\N	\N	\N
BX 418	BULBS	13	Oxalis massoniana	Mary Sue Ittner	\N	\N	\N	\N
BX 418	BULBS	14	Oxalis obtusa	Mary Sue Ittner	(coral)	\N	w	\N
BX 418	BULBS	15	Oxalis obtusa 'Peaches & Cream'	Mary Sue Ittner	\N	\N	w	\N
BX 418	BULBS	16	Tulipa clusiana	Mary Sue Ittner	(offsets)	\N	w	Offsets
BX 418	BULBS	17	Tulipa clusiana cultivar	Mary Sue Ittner	(offsets), could be 'Cynthia', pale yellow, outer tepals rose colored, see wiki for photos	http://www.pacificbulbsociety.org/pbswiki/index.php/TulipaSpeciesOne#clusiana	w	Offsets
BX 418	BULBS	18	Oxalis hirta	Mary Sue Ittner	\N	\N	w	\N
BX 418	BULBS	19	Oxalis hirta 'Gothenberg'	Mary Sue Ittner	\N	\N	w	\N
BX 418	BULBS	20	Oxalis flava	Mary Sue Ittner	pink	\N	\N	\N
BX 418	BULBS	21	Oxalis flava	Mary Sue Ittner	yellow	\N	\N	\N
BX 418	BULBS	22	Oxalis commutata	Mary Sue Ittner	\N	\N	\N	\N
BX 418	BULBS	23	Oxalis	Mary Sue Ittner	MV 5051	\N	\N	\N
BX 418	BULBS	24	Oxalis	Mary Sue Ittner	MV 4674	\N	\N	\N
BX 418	BULBS	25	Oxalis obtusa	Mary Sue Ittner	MV 6341	\N	\N	\N
BX 418	SEEDS	26	Clivia miniata	Mary Sue Ittner	pale yellow (VERY FEW)	\N	\N	\N
BX 419	SEEDS	2	Hymenocallis guerreroensis	Monica Swartz	ex BX 243 (mostly, may have a few harrisiana and phalangidis, a storm knocked them to the ground)	\N	\N	Seeds
BX 419	SEEDS	4	Clivia miniata 'Kaguyahime' x ('Vico Yellow' x F2 cross)	Roy Herold	ex Nakamura	\N	\N	Seed
BX 419	BULBS	5	Cyrtanthus elatus x C. montanus	Mary Sue Ittner	small offsets that formed on top next to the larger bulbs (see photos on the wiki; flowers are quite striking once bulbs are flowering size)	\N	\N	Small offsets
BX 419	BULBS	6	Oxalis namaquana	Mary Sue Ittner	- winter growing, bright yellow, flowering sized bulbs are very small	\N	w	\N
BX 419	BULBS	7	Oxalis purpurea	Mary Sue Ittner	- lavender and white - winter growing	\N	w	\N
BX 419	BULBS	8	Oxalis purpurea	Mary Sue Ittner	(white flowers) - blooms for many months when happy, but if planted in the ground in climates where it is happy, it can spread more than you might want	\N	w	\N
BX 419	BULBS	10	Albuca 'Augrabies Hills'	Jim Waddick	Bulbs are best planted with most of bulb above ground.	\N	\N	Bulbs
BX 419	BULBS	11	Hippeastrum hybrid 'Dancing Queen'	Bob Hoel	\N	\N	\N	Small bulbs
BX 419	BULBS	12	Hippeastrum hybrid 'Carmen'	Bob Hoel	(only one)	\N	\N	Small bulbs
BX 419	BULBS	13	Hippeastrum hybrid	Bob Hoel	red/white striped flower	\N	\N	Small bulbs
BX 419	BULBS	14	Hippeastrum hybrid 'Rilona'	Bob Hoel	\N	\N	\N	Small bulbs
BX 419	BULBS	15	Hippeastrum hybrid 'Evergreen'	Bob Hoel	(only one)	\N	\N	Small bulbs
BX 419	BULBS	16	Hippeastrum hybrid	Bob Hoel	unknown mix, mostly red single	\N	\N	Small bulbs
BX 419	BULBS	17	Neomarica candida	Bob Hoel	\N	\N	\N	Leafed propagules
BX 420	SEEDS	1	Rhodophiala bifida	Ina Crossley	pink	\N	\N	\N
BX 420	SEEDS	2	Habranthus brachyandrus	Ina Crossley	\N	\N	\N	\N
BX 420	SEEDS	3	Habranthus tubispathus var. roseum	Ina Crossley	\N	\N	\N	\N
BX 418	BULBS	1	Seemania nematanthodes	Dennis Kramb	\N	\N	\N	Rhizomes
BX 418	SEEDS	27	Phaedranassa cinerea	Rimmer deVries	? from BX 347 (Mary Sue Ittner, September 2013), she informed me she received her plant (or seeds) from Bill Dijk. up to 6 flowers on up to 3 foot tall stems. These have grown well and fast and flowered in 2016 and again in 2017 in 4 inch pots. it does best in decayed basalt grit. These seeds are from 4 plants with up to 6 flowers in each umbel were harvested in May 2017 and can be started on the soil surface (if seed is fresh) or floated in water if left for a while. but don't wait too long seed is short lived.	\N	\N	Seeds
BX 418	BULBS	28	Sinningia cardinalis	Rimmer deVries	ex SX2 seed started 28 march 2015- seedlings lifted and trimmed of growth	\N	\N	\N
BX 420	SEEDS	4	Habranthus tubispathus	Ina Crossley	\N	\N	\N	\N
BX 420	SEEDS	5	Habranthus robustus 'Russell Manning'	Ina Crossley	\N	\N	\N	\N
BX 420	SEEDS	6	Habranthus magnoi	Ina Crossley	\N	\N	\N	\N
BX 420	SEEDS	7	Habranthus tubispathus	Ina Crossley	blue	\N	\N	\N
BX 420	SEEDS	8	Habranthus x floryi	Ina Crossley	green throat	\N	\N	\N
BX 420	SEEDS	9	Zephyranthes jonesii	Ina Crossley	\N	\N	\N	\N
BX 420	SEEDS	10	Zephyranthes pulchella	Ina Crossley	\N	\N	\N	\N
BX 420	SEEDS	11	Zephyranthes huastacana	Ina Crossley	\N	\N	\N	\N
BX 420	SEEDS	12	Zephyranthes fosteri	Ina Crossley	pale pink	\N	\N	\N
BX 420	SEEDS	13	Zephyranthes fosteri	Ina Crossley	white	\N	\N	\N
BX 420	SEEDS	14	Zephyranthes 'Pink Beauty'	Ina Crossley	\N	\N	\N	\N
BX 420	SEEDS	15	Zephyranthes citrina	Ina Crossley	\N	\N	\N	\N
BX 420	SEEDS	16	Zephyranthes katheriniae	Ina Crossley	red	\N	\N	\N
BX 420	SEEDS	17	Zephyranthes lagesiana	Ina Crossley	\N	\N	\N	\N
BX 420	SEEDS	18	Zephyranthes dichromantha	Ina Crossley	\N	\N	\N	\N
BX 420	SEEDS	19	Zephyranthes 'Sunset Strain'	Ina Crossley	\N	\N	\N	\N
BX 420	SEEDS	20	Zephyranthes reginae	Ina Crossley	\N	\N	\N	\N
BX 420	SEEDS	21	Zephyranthes chlorosolen	Ina Crossley	\N	\N	\N	\N
BX 420	SEEDS	22	Zephyranthes refugiensis	Ina Crossley	\N	\N	\N	\N
BX 420	SEEDS	23	Zephyranthes 'Paul Niemi'	Ina Crossley	\N	\N	\N	\N
BX 420	SEEDS	24	Zephyranthes 'Labufarosea'	Ina Crossley	\N	\N	\N	\N
BX 420	SEEDS	25	Zephyranthes fluvialis	Ina Crossley	(Z. flavissima??)	\N	\N	\N
BX 420	SEEDS	26	Zephyranthes smallii	Ina Crossley	\N	\N	\N	\N
BX 420	SEEDS	27	Zephyranthes miradorensis	Ina Crossley	\N	\N	\N	\N
BX 420	SEEDS	28	Zephyranthes mesochloa	Ina Crossley	\N	\N	\N	\N
BX 420	SEEDS	29	Zephyranthes macrosiphon 'Hidalgo'	Ina Crossley	\N	\N	\N	\N
BX 420	SEEDS	30	Zephyranthes fosteri	Ina Crossley	pink	\N	\N	\N
BX 420	SEEDS	31	Zephyranthes verecunda 'rosea' ( Z. miniata)	Ina Crossley	\N	\N	\N	\N
BX 420	SEEDS	32	Zephyranthes verecunda	Ina Crossley	Mexican (Z. miniata)	\N	\N	\N
BX 420	SEEDS	33	Zephyranthes verecunda	Ina Crossley	pale pink (Z. miniata)	\N	\N	\N
BX 420	SEEDS	34	Zephyranthes primulina	Ina Crossley	\N	\N	\N	\N
BX 420	SEEDS	35	Zephyranthes drummondii	Ina Crossley	\N	\N	\N	\N
BX 421	SEEDS	1	Crinum stuhlmannii subsp. delagoense	George Dees	. (syn. Crinum delagoense)	\N	\N	\N
BX 421	SEEDS	2	Crinum macowanii	George Dees	from Kenya	\N	\N	\N
BX 421	SEEDS	3	Crinum macowanii	George Dees	from Malawi	\N	\N	\N
BX 421	SEEDS	4	Crinum bulbispermum 'Marcel Sheppards Jumbo'	George Dees	bred from crosses made with Hannibal's stock. Wide range of colors: pink, red, white, mixed and green flowers.	\N	\N	\N
BX 421	SEEDS	5	Crinum bulbispermum 'Jumbo'	George Dees	directly from Les Hannibal	\N	\N	\N
BX 421	SEEDS	6	Crinum (macowanii x acaule) x (macowanii x acaule)	George Dees	\N	\N	\N	\N
BX 421	SEEDS	7	Ammocharis coranica	George Dees	mixed seeds from pink, red, and white flowers	\N	\N	\N
BX 421	SEEDS	8	Pamianthe peruviana	Paul Matthews	\N	\N	\N	Seed
BX 421	SEEDS	11	Scilla peruviana	Shmuel Silinsky	ex hort	\N	\N	\N
BX 421	SEEDS	12	Gladiolus carneus	Shmuel Silinsky	ex hort	\N	\N	\N
BX 421	SEEDS	13	Moraea sisyrinchium	Shmuel Silinsky	(Gynandriris) sisyrinchium, wild collected near Jerusalem	\N	\N	\N
BX 421	SEEDS	14	Erythrina herbacea	Monica Swartz	\N	\N	\N	Seeds
BX 422	SEEDS	4	Calochortus superbus	Jim Barton	\N	\N	\N	\N
BX 422	SEEDS	5	Calochortus venustus	Jim Barton	\N	\N	\N	\N
BX 422	SEEDS	6	Chlorogalum pomeridianum	Jim Barton	\N	\N	\N	\N
BX 422	SEEDS	7	Dichelostemma capitatum	Jim Barton	\N	\N	\N	\N
BX 422	SEEDS	8	Dichelostemma multiflorum	Jim Barton	\N	\N	\N	\N
BX 422	SEEDS	9	Triteleia hyacinthina	Jim Barton	\N	\N	\N	\N
BX 422	SEEDS	10	Triteleia ixioides	Jim Barton	\N	\N	\N	\N
BX 422	SEEDS	11	Triteleia laxa	Jim Barton	\N	\N	\N	\N
BX 422	SEEDS	12	Triteleia peduncularis	Jim Barton	\N	\N	\N	\N
BX 422	BULBS	16	Oxalis obtusa	Mary Sue Ittner	coral	\N	\N	\N
BX 422	BULBS	17	Oxalis luteola	Mary Sue Ittner	MV5567	\N	\N	\N
BX 422	BULBS	18	Oxalis flava	Mary Sue Ittner	(lupinifolia)	\N	\N	\N
BX 422	BULBS	19	Hyacinthoides lingulata	Mary Sue Ittner	\N	\N	\N	\N
BX 422	BULBS	20	Brunsvigia grandiflora	Mary Sue Ittner	- started from seed in 2003, 3 big bulbs. Contrary to advice in Grow Bulbs, these have been in a large pot outside exposed to winter rainfall (sometimes a lot of it) and seem to have adapted to a winter rainfall growing season without any signs of distress except they haven't flowered yet. Native to summer rainfall areas.	\N	\N	\N
BX 422	BULBS	21	Lachenalia bulbifera	Mary Sue Ittner	- small offsets mostly	\N	\N	\N
BX 422	BULBS	22	Moraea simulans	Mary Sue Ittner	\N	\N	\N	\N
BX 422	BULBS	23	Nerine sarniensis	Mary Sue Ittner	- grown from seed from a red flowered Zinkowski rescue plant in 2002, the ones that have flowered so far have been both red and pink\\	\N	\N	\N
BX 423	BULBS	1	Acis trichophylla	Fred Thorne	\N	\N	\N	\N
BX 423	BULBS	2	Albuca namaquensis	Fred Thorne	\N	\N	\N	\N
BX 423	BULBS	3	Albuca sp. 'Augrabies Hills'	Fred Thorne	\N	\N	\N	\N
BX 423	BULBS	4	Allium albopilosum	Fred Thorne	(A. christophii)	\N	\N	\N
BX 423	BULBS	5	Allium cernuum	Fred Thorne	\N	\N	\N	\N
BX 423	BULBS	6	Amaryllis belladonna	Fred Thorne	\N	\N	\N	\N
BX 423	SEEDS	7	Ammocharis coranica	Fred Thorne	seed	\N	\N	Seeds
BX 423	BULBS	8	Arisaema triphyllum	Fred Thorne	\N	\N	\N	\N
BX 423	BULBS	9	Boophone disticha	Fred Thorne	\N	\N	\N	\N
BX 423	BULBS	10	Brunsvigia bosmaniae	Fred Thorne	\N	\N	\N	\N
BX 422	BULBS	13	Triteleia laxa 'Queen Fabiola'	Jim Barton	mixed sizes	\N	\N	Corms
BX 421	SEEDS	9	Hippeastrum 'Purple Estrella'	Karl Church	only one order	\N	\N	\N
BX 423	BULBS	11	Brunsvigia josephiniae	Fred Thorne	\N	\N	\N	\N
BX 423	BULBS	12	Brunsvigia orientalis	Fred Thorne	\N	\N	\N	\N
BX 423	BULBS	13	Calochortus argillosus	Fred Thorne	\N	\N	\N	\N
BX 423	BULBS	14	Chasmanthe floribunda 'Duckittii'	Fred Thorne	\N	\N	\N	\N
BX 423	BULBS	15	Crinum lugardiae	Fred Thorne	\N	\N	\N	\N
BX 423	BULBS	16	Crinum razafindratsiraea	Fred Thorne	\N	\N	\N	\N
BX 423	BULBS	17	Crocus chrysanthus	Fred Thorne	\N	\N	\N	\N
BX 423	BULBS	18	Crocus mix	Fred Thorne	\N	\N	\N	\N
BX 423	BULBS	19	Cyanella orchidiformis	Fred Thorne	\N	\N	\N	\N
BX 423	BULBS	20	Cyrtanthus epiphyticus	Fred Thorne	ex BX 154	\N	\N	\N
BX 423	BULBS	21	Cyrtanthus loddigesianus	Fred Thorne	\N	\N	\N	\N
BX 423	BULBS	22	Cyrtanthus mackenii	Fred Thorne	\N	\N	\N	\N
BX 423	BULBS	23	Eucharis x	Fred Thorne	grandiflora	\N	\N	\N
BX 423	BULBS	24	Freesia viridis	Fred Thorne	\N	\N	\N	\N
BX 423	BULBS	25	Gladiolus cardinalis	Fred Thorne	\N	\N	\N	\N
BX 423	BULBS	26	Gladiolus cunonius	Fred Thorne	\N	\N	\N	\N
BX 423	BULBS	27	Gladiolus huttonii	Fred Thorne	\N	\N	\N	\N
BX 423	BULBS	28	Gladiolus splendens	Fred Thorne	\N	\N	\N	\N
BX 423	BULBS	29	Gladiolus tristis 'Moonlight'	Fred Thorne	\N	\N	\N	\N
BX 424	BULBS	1	Habranthus brachyandrus	Fred Thorne	\N	\N	\N	\N
BX 424	BULBS	2	Habranthus robustus	Fred Thorne	\N	\N	\N	\N
BX 424	BULBS	3	Habranthus tubispathus	Fred Thorne	\N	\N	\N	\N
BX 424	BULBS	4	Habranthus tubispathus	Fred Thorne	typical Texas form	\N	\N	\N
BX 424	BULBS	5	Habranthus x floryi	Fred Thorne	green base	\N	\N	\N
BX 424	BULBS	6	Habranthus x floryi	Fred Thorne	purple base	\N	\N	\N
BX 424	BULBS	7	Haemanthus albiflos	Fred Thorne	\N	\N	\N	\N
BX 424	BULBS	8	Haemanthus barkerae	Fred Thorne	\N	\N	\N	\N
BX 424	BULBS	9	Haemanthus pauculifolius	Fred Thorne	\N	\N	\N	\N
BX 424	BULBS	10	Hippeastrum striatum	Fred Thorne	\N	\N	\N	\N
BX 424	BULBS	11	Hippeastrum vittatum	Fred Thorne	\N	\N	\N	\N
BX 424	BULBS	12	Hyacinthoides lingulata	Fred Thorne	\N	\N	\N	\N
BX 424	BULBS	13	Ipheion uniflorum	Fred Thorne	\N	\N	\N	\N
BX 424	BULBS	14	Lachenalia alba	Fred Thorne	\N	\N	\N	\N
BX 424	BULBS	15	Lachenalia aloides var. quadricolor	Fred Thorne	\N	\N	\N	\N
BX 424	BULBS	16	Lachenalia bulbifera	Fred Thorne	\N	\N	\N	\N
BX 424	BULBS	17	Lachenalia mutabilis	Fred Thorne	electric blue	\N	\N	\N
BX 424	BULBS	18	Lachenalia orchioides var. glaucina	Fred Thorne	\N	\N	\N	\N
BX 424	BULBS	19	Lachenalia pallida	Fred Thorne	\N	\N	\N	\N
BX 424	BULBS	20	Lachenalia pusilla	Fred Thorne	\N	\N	\N	\N
BX 424	BULBS	21	Lachenalia pustulata	Fred Thorne	\N	\N	\N	\N
BX 424	BULBS	22	Lachenalia rubida	Fred Thorne	\N	\N	\N	\N
BX 424	BULBS	23	Lachenalia unicolor	Fred Thorne	\N	\N	\N	\N
BX 424	BULBS	24	Lachenalia unifolia	Fred Thorne	ex Telos	\N	\N	\N
BX 424	BULBS	25	Lachenalia viridiflora	Fred Thorne	\N	\N	\N	\N
BX 424	BULBS	26	Lachenalia juncifolia	Fred Thorne	\N	\N	\N	\N
BX 424	BULBS	27	Massonia depressa	Fred Thorne	\N	\N	\N	\N
BX 424	BULBS	28	Massonia depressa	Fred Thorne	M51 Modderfontein	\N	\N	\N
BX 424	BULBS	29	Massonia pustulata	Fred Thorne	M41 ex Cumbleton	\N	\N	\N
BX 424	BULBS	30	Massonia pygmaea	Fred Thorne	Modderfontein, Renosterveld	\N	\N	\N
BX 425	BULBS	1	Moraea tripetala	Fred Thorne	\N	\N	w	\N
BX 425	BULBS	2	Muscari armeniacum	Fred Thorne	\N	\N	w	\N
BX 425	BULBS	3	Narcissus 'Nylon'	Fred Thorne	\N	\N	w	\N
BX 425	BULBS	4	Nerine masonorum	Fred Thorne	\N	\N	\N	\N
BX 425	BULBS	5	Nerine bowdenii	Fred Thorne	\N	\N	\N	\N
BX 425	BULBS	6	Ornithogalum schmalhausenii	Fred Thorne	ex Ruksans (O. balansae)	\N	\N	\N
BX 425	BULBS	7	Ornithogalum umbellatum	Fred Thorne	Common name 'Star of Bethlehem'	\N	\N	\N
BX 425	BULBS	8	Oxalis caprina	Fred Thorne	lilac	\N	\N	\N
BX 425	BULBS	9	Oxalis depressa	Fred Thorne	MV 4871	\N	\N	\N
BX 425	BULBS	10	Oxalis flava	Fred Thorne	yellow	\N	\N	\N
BX 425	BULBS	11	Oxalis imbricata	Fred Thorne	\N	\N	\N	\N
BX 425	BULBS	12	Oxalis namaquana	Fred Thorne	yellow	\N	\N	\N
BX 425	BULBS	13	Oxalis sp.	Fred Thorne	?, yellow, ex BX 313	\N	\N	\N
BX 425	BULBS	14	Rhodophiala bifida	Fred Thorne	\N	\N	\N	\N
BX 425	BULBS	15	Scilla siberica	Fred Thorne	\N	\N	\N	\N
BX 425	BULBS	16	Strumaria tenella	Fred Thorne	\N	\N	\N	\N
BX 425	BULBS	17	Tristagma 'Rolf Fiedler'	Fred Thorne	\N	\N	\N	\N
BX 425	BULBS	18	Veltheimia bracteata	Fred Thorne	\N	\N	\N	\N
BX 425	BULBS	19	Zephyranthes candida	Fred Thorne	\N	\N	\N	\N
BX 425	BULBS	20	Zephyranthes citrina	Fred Thorne	\N	\N	\N	\N
BX 425	BULBS	21	Zephyranthes minima	Fred Thorne	\N	\N	\N	\N
BX 425	BULBS	22	Zephyranthes 'Prairie Sunset'	Fred Thorne	\N	\N	\N	\N
BX 425	BULBS	23	Zephyranthes primulina	Fred Thorne	\N	\N	\N	\N
BX 425	BULBS	24	Zephyranthes reginae	Fred Thorne	\N	\N	\N	\N
BX 425	BULBS	25	Zephyranthes smallii	Fred Thorne	\N	\N	\N	\N
BX 425	BULBS	26	Zephyranthes 'Tenexio Apricot'	Fred Thorne	\N	\N	\N	\N
BX 425	BULBS	27	Zephyranthes grandiflora	Fred Thorne	(Z. minuta)	\N	\N	\N
BX 426	BULBS	1	Drimiopsis maculata	Brad King	ex Waddick/Mazer	\N	\N	Small offsets
BX 426	SEEDS	2	Calostemma purpureum	Chad Cox	\N	\N	\N	Seed
BX 426	BULBS	3	Gladiolus grandiflorus	Chad Cox	mostly red, some pink	\N	\N	Corms
BX 426	BULBS	5	Ferraria crispa	Mary Sue Ittner	\N	\N	\N	\N
BX 426	BULBS	6	Nerine sarniensis	Mary Sue Ittner	from Zinkowski rescue Meditation X Joan Tonkin	\N	\N	\N
BX 426	BULBS	7	Nerine sarniensis	Mary Sue Ittner	(from seeds from pink flowers, ones blooming so far have been pink)	\N	\N	\N
BX 426	BULBS	8	Oxalis purpurea 'Garnet'	Mary Sue Ittner	\N	\N	\N	\N
BX 426	BULBS	9	Tropaeolum tricolor	Mary Sue Ittner	\N	\N	\N	\N
BX 426	BULBS	10	Lilium lancifolium	Dan Fetty	Lilium lancifolium, (Tiger Lily), 60-yr old clone, 6' - 8' tall	\N	\N	Bulbils
BX 426	BULBS	11	Orienpet lily	Dan Fetty	white/rose, fragrant, 5' - 6' tall	\N	\N	Bulbils
BX 426	BULBS	12	Oxalis namaquana	John Wickham	\N	\N	\N	\N
BX 426	BULBS	13	Oxalis fabifolia	John Wickham	ex BX 275	\N	\N	\N
BX 426	BULBS	14	Oxalis bowiei	John Wickham	\N	\N	\N	\N
BX 426	BULBS	15	Lachenalia aloides	John Wickham	('Pearsonii')	\N	\N	\N
BX 426	BULBS	16	Lachenalia pustulata	John Wickham	blue	\N	\N	\N
BX 426	BULBS	17	Ferraria uncinata	John Wickham	ex UCBBG	\N	\N	\N
BX 426	BULBS	18	Moraea edulis	John Wickham	(M. fugax?)	\N	\N	\N
BX 426	BULBS	19	Watsonia aletroides	John Wickham	\N	\N	\N	\N
BX 426	BULBS	20	Tritonia crocata	John Wickham	selection	\N	\N	\N
BX 426	BULBS	21	Tritonia hybrid	John Wickham	pink	\N	\N	\N
BX 426	BULBS	22	Watsonia 'Ablaze'	John Wickham	\N	\N	\N	\N
BX 426	BULBS	23	Lachenalia bulbifera	John Wickham	deep red, ex BX 271	\N	\N	\N
BX 426	BULBS	24	Tritonia hybrid	John Wickham	pastel	\N	\N	\N
BX 426	BULBS	25	Watsonia 'Flamboyant'	John Wickham	ex Monterey Bay Nursery	\N	\N	\N
BX 426	BULBS	26	Lachenalia mutabilis	John Wickham	electric blue	\N	\N	\N
BX 426	BULBS	27	Lachenalia corymbosa	John Wickham	(Polyxena)	\N	\N	\N
BX 426	BULBS	28	Tritonia hyalina	John Wickham	(T. crocata?)	\N	\N	\N
BX 427	BULBS	17	Spilenecapensis	Dee Foster	mgb note: possibly Silene capensis or Spiloxene capensis?	\N	\N	Small bulbs or cormlets
BX 427	SEEDS	5	Amaryllis belladonna	Ann Rametta	hot pink & white and raspberry, mixed.	\N	\N	Seeds
BX 427	BULBS	6	Crinum sp.	Ann Rametta	pink	\N	\N	Small bulbs
BX 427	BULBS	7	Albuca 'Giant Slime Lily'	Ann Rametta	\N	\N	\N	Large bulbs
BX 427	BULBS	8	Babiana rubrocyanea	Dee Foster	\N	\N	\N	Small bulbs or cormlets
BX 427	BULBS	9	Ferraria crispa 'Form A'	Dee Foster	\N	\N	\N	Small bulbs or cormlets
BX 427	BULBS	10	Ixia flexuosa	Dee Foster	\N	\N	\N	Small bulbs or cormlets
BX 427	BULBS	11	Babiana 'Jims Choice'	Dee Foster	\N	\N	\N	Small bulbs or cormlets
BX 427	BULBS	12	Lachenalia aloides var. quadricolor	Dee Foster	\N	\N	\N	Small bulbs or cormlets
BX 427	BULBS	13	Gladiolus carneus 'Kleinmond'	Dee Foster	\N	\N	\N	Small bulbs or cormlets
BX 427	BULBS	14	Moraea villosa	Dee Foster	\N	\N	\N	Small bulbs or cormlets
BX 427	BULBS	15	Lachenalia mutabilis	Dee Foster	\N	\N	\N	Small bulbs or cormlets
BX 427	BULBS	16	Ixia monadelpha	Dee Foster	\N	\N	\N	Small bulbs or cormlets
BX 428	BULBS	1	Notholirion thomsonianum	Terry Laskiewicz	\N	\N	\N	\N
BX 428	BULBS	2	Hyacinthoides mauritanica	Terry Laskiewicz	\N	\N	\N	\N
BX 428	BULBS	3	Narcissus romieuxii 'Julia Jane'	Terry Laskiewicz	\N	\N	\N	\N
BX 428	BULBS	4	Oxalis bowiei	Terry Laskiewicz	\N	\N	\N	\N
BX 428	BULBS	5	Stenomesson sp.	Lee Poulsen	\N	\N	\N	\N
BX 428	BULBS	6	Haemanthus pauculifolius	Lee Poulsen	\N	\N	\N	\N
BX 428	BULBS	7	Moraea ciliata	Bob Werra	:	\N	\N	Cormlets
BX 429	BULBS	1	Sinningia cardinalis 'Innocent'	Dennis Kramb	The cardinalis were approaching their natural dormancy. They should be only lightly watered until growth resumes, which could take a couple months. The 'Peridots Sand Pebbles' were in rampant growth & will probably grow vigorously immediately once repotted. To my knowledge this hybrid never goes dormant (probably inherited from its Sinningia bullata ancestry).	\N	\N	Tubers
BX 429	BULBS	2	Sinningia cardinalis	Dennis Kramb	The cardinalis were approaching their natural dormancy. They should be only lightly watered until growth resumes, which could take a couple months. The 'Peridots Sand Pebbles' were in rampant growth & will probably grow vigorously immediately once repotted. To my knowledge this hybrid never goes dormant (probably inherited from its Sinningia bullata ancestry).	\N	\N	Tubers
BX 429	BULBS	3	Sinningia 'Peridots Sand Pebbles'	Dennis Kramb	\N	\N	\N	Tubers
BX 429	BULBS	4	Babiana sp.	Mary Sue Ittner	- low growing, purple flowers	\N	w	\N
BX 429	BULBS	5	Calochortus vestae	Mary Sue Ittner	\N	\N	\N	\N
BX 429	BULBS	6	Geissorhiza sp.	Mary Sue Ittner	(probably inaequalis)	\N	w	\N
BX 429	BULBS	7	Spiloxene capensis	Mary Sue Ittner	\N	\N	w	\N
BX 429	BULBS	8	Watsonia humilis	Mary Sue Ittner	\N	\N	w	\N
BX 429	SEEDS	9	Gloriosa modesta	Mary Sue Ittner	(Littonia modesta)	\N	\N	\N
BX 429	SEEDS	10	Nerine platypetala	Mary Sue Ittner	\N	\N	\N	\N
BX 429	SEEDS	11	Sandersonia aurantiaca	Mary Sue Ittner	\N	\N	\N	\N
BX 430	BULBS	1	Oxalis bowiei	Karl Church	pink	\N	\N	\N
BX 430	BULBS	2	Oxalis caprina	Karl Church	ex BX 364	\N	\N	\N
BX 430	BULBS	3	Oxalis cathara	Karl Church	ex BX 362	\N	\N	\N
BX 430	BULBS	4	Oxalis commutata	Karl Church	ex BX 364	\N	\N	\N
BX 430	BULBS	5	Oxalis compressa	Karl Church	double flower, ex BX 364	\N	\N	\N
BX 430	BULBS	6	Oxalis engleriana	Karl Church	ex BX 338	\N	\N	\N
BX 430	BULBS	7	Oxalis flava	Karl Church	yellow	\N	\N	\N
BX 430	BULBS	8	Oxalis glabra	Karl Church	ex BX 362	\N	\N	\N
BX 430	BULBS	9	Oxalis hirta	Karl Church	pink, ex BX 338	\N	\N	\N
BX 430	BULBS	10	Oxalis luteola	Karl Church	MV5567, ex BX 364	\N	\N	\N
BX 430	BULBS	11	Oxalis obtusa	Karl Church	MV 5005A, ex BX 364	\N	\N	\N
BX 430	BULBS	12	Oxalis obtusa	Karl Church	MV 5051, ex BX 338	\N	\N	\N
BX 430	BULBS	13	Oxalis purpurea	Karl Church	lavender and white, ex BX 338	\N	\N	\N
BX 430	BULBS	14	Oxalis purpurea	Karl Church	pink, ex BX 338	\N	\N	\N
BX 430	BULBS	15	Oxalis palmifrons	Karl Church	ex BX 338	\N	\N	\N
BX 430	BULBS	16	Oxalis polyphylla	Karl Church	MV 6396, ex BX 338	\N	\N	\N
BX 430	BULBS	17	Oxalis polyphylla	Karl Church	MV 3816, ex BX 338	\N	\N	\N
BX 430	BULBS	18	Ferraria uncinata	Karl Church	\N	\N	\N	\N
BX 430	BULBS	19	Ferraria divaricata	Karl Church	ex BX 346	\N	\N	\N
BX 430	BULBS	20	Ferraria schaeferi	Karl Church	\N	\N	\N	\N
BX 430	BULBS	21	Ferraria divaricata	Karl Church	subsp.. arenosa	\N	\N	\N
BX 430	BULBS	22	Ferraria crispa form A	Karl Church	form A	\N	\N	\N
BX 430	BULBS	23	Ferraria crispa form B	Karl Church	form B, ex Telos	\N	\N	\N
BX 430	BULBS	24	Ferraria crispa	Karl Church	form 2	\N	\N	\N
BX 430	BULBS	25	Ferraria crispa	Karl Church	dark form	\N	\N	\N
BX 431	BULBS	1	Aristea capitata	Linda Wulf	(A. major) (very few)	\N	\N	Rhizomes
BX 431	BULBS	2	Watsonia pillansi 'West Hills Strraspberry'	Linda Wulf	Str/raspberry	\N	\N	Corms
BX 431	BULBS	3	Smithiantha 'Pats Pet Lemur'	Dennis Kramb	(very few)	\N	\N	Rhizomes
BX 431	BULBS	4	Gloxinia erinoides	Dennis Kramb	\N	\N	\N	Rhizomes
BX 431	BULBS	5	x Achimenantha 'Inferno'	Dennis Kramb	\N	\N	\N	Rhizomes
BX 431	BULBS	6	Seemannia gymnostoma	Dennis Kramb	(aerial rhizomes)	\N	\N	Aerial rhizomes
BX 431	BULBS	7	Seemannia nematanthodes 'Evita'	Dennis Kramb	(aerial rhizomes)	\N	\N	Aerial rhizomes
BX 433	BULBS	16	Polianthes tuberosa	Chad Cox	double	\N	\N	Small offset bulbs
BX 431	BULBS	9	Chasmanthe 'Mystery'	Karl Church	(FEW), ex BX 340	\N	\N	Corms
BX 431	BULBS	10	Geissorhiza or Hesperantha	Karl Church	Geissorhiza? or Hesperantha? ex BX 371	\N	\N	Corms
BX 431	BULBS	11	Gelasine elongata	Karl Church	ex SX 3	\N	\N	Corms
BX 431	BULBS	12	Gladiolus tristis	Karl Church	ex BX 345	\N	\N	Corms
BX 431	BULBS	13	Gladiolus uysiae	Karl Church	ex UC Davis	\N	\N	Corms
BX 431	BULBS	14	Homoglad hybrids	Karl Church	\N	\N	\N	Corms
BX 431	BULBS	15	Ixia longituba var. bellendenii	Karl Church	\N	\N	\N	Corms
BX 431	BULBS	16	Sparaxis elegans	Karl Church	\N	\N	\N	Corms
BX 431	BULBS	17	Tritonia laxifolia	Karl Church	\N	\N	\N	Corms
BX 431	BULBS	18	Tritonia 'Salmon Run'	Karl Church	ex BX 368	\N	\N	Corms
BX 431	BULBS	19	Tritonia deusta	Karl Church	\N	\N	\N	Corms
BX 431	BULBS	20	Tritonia 'Jims Select'	Karl Church	\N	\N	\N	Corms
BX 431	BULBS	21	Tritonia 'Princess Beatrix'	Karl Church	\N	\N	\N	Corms
BX 431	BULBS	22	Watsonia aletroides	Karl Church	ex BX 371	\N	\N	Corms
BX 431	BULBS	23	Cyanella orchidiformis	Karl Church	ex BX 308	\N	\N	Corms
BX 431	BULBS	24	Freesia laxa	Karl Church	\N	\N	\N	Corms
BX 431	BULBS	25	Freesia laxa	Karl Church	red	\N	\N	Corms
BX 432	BULBS	1	Babiana 'Blue Gem'	Karl Church	ex BX 367	\N	\N	\N
BX 432	BULBS	2	Babiana 'Deep Dreams'	Karl Church	ex BX 367	\N	\N	\N
BX 432	BULBS	3	Babiana 'Mighty Magenta'	Karl Church	ex BX 367	\N	\N	\N
BX 432	BULBS	4	Babiana rubrocyanea	Karl Church	ex BX 367	\N	\N	\N
BX 432	BULBS	5	Babiana 'Brilliant Blue'	Karl Church	ex BX 367	\N	\N	\N
BX 432	BULBS	6	Babiana 'Purple Haze'	Karl Church	ex BX 367	\N	\N	\N
BX 432	BULBS	7	Lachenalia reflexa	Karl Church	\N	\N	\N	\N
BX 432	BULBS	8	Lachenalia mutabilis	Karl Church	ex BX 353	\N	\N	\N
BX 432	BULBS	9	Lachenalia mutabilis	Karl Church	ex Fred Gaumer	\N	\N	\N
BX 432	BULBS	10	Lachenalia mutabilis	Karl Church	ex UC Davis	\N	\N	\N
BX 445	BULBS	8	Ferraria crispa	Mary Sue Ittner	\N	\N	\N	\N
BX 432	BULBS	11	Lachenalia mutabilis 'Electric Blue'	Karl Church	ex BX 372	\N	\N	\N
BX 432	BULBS	12	Lachenalia unicolor	Karl Church	ex Fred Gaumer	\N	\N	\N
BX 432	BULBS	13	Lachenalia liliiflora	Karl Church	ex Fred Gaumer	\N	\N	\N
BX 432	BULBS	14	Lachenalia aloides	Karl Church	ex Fred Gaumer	\N	\N	\N
BX 432	BULBS	15	Lachenalia aloides var. quadricolor	Karl Church	ex Fred Gaumer	\N	\N	\N
BX 432	BULBS	16	Lachenalia rubida	Karl Church	\N	\N	\N	\N
BX 432	BULBS	17	Lachenalia viridiflora	Karl Church	ex Fred Gaumer	\N	\N	\N
BX 432	BULBS	18	Albuca acuminata	Karl Church	ex BX 378, ex BX 351	\N	\N	\N
BX 432	BULBS	19	Albuca sp.	Karl Church	ex BX 372, ex BX 178	\N	\N	\N
BX 432	BULBS	20	Ornithogalum candicans	Karl Church	(Galtonia), ex SX 5	\N	\N	\N
BX 432	BULBS	21	Rhodophiala bifida	Karl Church	\N	\N	\N	\N
BX 432	BULBS	22	Rhodophiala bifida	Karl Church	pink, ex SX 2	\N	\N	\N
BX 432	BULBS	23	Dichelostemma multiflorum	Karl Church	ex SX 4	\N	\N	\N
BX 432	BULBS	24	Dichelostemma multiflorum	Karl Church	ex SX 3	\N	\N	\N
BX 432	BULBS	25	Dichelostemma multiflorum	Karl Church	ex BX 140	\N	\N	\N
BX 433	BULBS	1	Moraea bellendenii	Karl Church	ex BX 410	\N	\N	\N
BX 433	BULBS	2	Moraea lurida	Karl Church	\N	\N	\N	\N
BX 433	BULBS	3	Moraea polystachya	Karl Church	ex BX 345	\N	\N	\N
BX 433	BULBS	4	Moraea setifolia	Karl Church	ex BX 393	\N	\N	\N
BX 433	BULBS	5	Moraea sp.	Karl Church	M9400A x M. gigandra, ex Mace (MM 11-33)	\N	\N	\N
BX 433	BULBS	6	Moraea villosa	Karl Church	x M. tulbaghensis, ex Mace	\N	\N	\N
BX 433	BULBS	7	Moraea tricolor	Karl Church	ex Telos	\N	\N	\N
BX 433	BULBS	8	Moraea tripetala	Karl Church	ex Mace	\N	\N	\N
BX 433	BULBS	9	Moraea villosa A	Karl Church	A, ex Mace	\N	\N	\N
BX 433	BULBS	10	Moraea villosa B	Karl Church	B, ex Mace	\N	\N	\N
BX 433	BULBS	11	Dichelostemma ida-maia	Karl Church	ex Annie's	\N	\N	\N
BX 433	BULBS	12	Habranthus x	Karl Church	floryi, green base, ex SX 2	\N	\N	\N
BX 433	BULBS	13	Habranthus tubispathus 'Texanus'	Karl Church	ex BX 341	\N	\N	\N
BX 433	BULBS	14	Tulipa clusiana	Karl Church	ex BX 339	\N	\N	\N
BX 433	BULBS	15	Zephyranthes smallii	Karl Church	ex BX 355	\N	\N	\N
BX 435	BULBS	8	Nymphaea viviparous	Uli Urban	hybrid, blue, leaf tubers. After my observation after one summer in Portugal, I would now like to stress that it should not be allowed to escape into natural ponds as it might become invasive in an apropriate climate. Every leaf is able to become a new plant.	\N	\N	\N
BX 435	BULBS	9	Sinningia bullata x S. conspicua	Dennis Kramb	The plants have a growth habit like S. bullata which means they ramble & need lots of room. That's why I'm donating them. I have too many and need to thin out my collection. The bulbs are roughly 5 years old. They can grow in full sun & do not go dormant if watered regularly. These tubers are roughly plum-sized and will continue increasing in size. The mother bullata tuber is larger than a grapefruit. The flowers seem to be fertile. I'm growing some F2's.	\N	\N	\N
BX 436	BULBS	1	Dioscorea japonica	Francisco Lopez	bulbils	\N	\N	Bulbils
BX 436	SEEDS	2	Crinum erubescens	Francisco Lopez	Seed	\N	\N	\N
BX 436	SEEDS	3	Euryale ferox	Francisco Lopez	seed - These have started to germinate and will need to be planted ASAP	\N	\N	\N
BX 436	SEEDS	4	Habranthus itaobinus 'Cardoso Moreira'	Pacific Bulb Society	\N	\N	\N	\N
BX 436	SEEDS	5	Habranthus martinezii	Pacific Bulb Society	\N	\N	\N	\N
BX 436	SEEDS	6	Hippeastrum aulicum 'Biritiba'	Pacific Bulb Society	\N	\N	\N	\N
BX 436	SEEDS	7	Hippeastrum blossfeldiae 'Sao Sebastiao'	Pacific Bulb Society	\N	\N	\N	\N
BX 436	SEEDS	8	Hippeastrum blossfeldiae 'Guaeca'	Pacific Bulb Society	\N	\N	\N	\N
BX 436	SEEDS	9	Hippeastrum calyptratum 'Biritiba'	Pacific Bulb Society	\N	\N	\N	\N
BX 436	SEEDS	10	Hippeastrum glaucescens	Pacific Bulb Society	\N	\N	\N	\N
BX 436	SEEDS	11	Hippeastrum glaucescens 'Alto do Rio Perdido'	Pacific Bulb Society	\N	\N	\N	\N
BX 436	SEEDS	12	Hippeastrum morelianum 'Atibaia'	Pacific Bulb Society	\N	\N	\N	\N
BX 436	SEEDS	13	Hippeastrum papilio	Pacific Bulb Society	\N	\N	\N	\N
BX 436	SEEDS	14	Hippeastrum psittacinum 'Atibaia'	Pacific Bulb Society	\N	\N	\N	\N
BX 436	SEEDS	15	Hippeastrum solandriflorum 'Jaiba'	Pacific Bulb Society	\N	\N	\N	\N
BX 436	SEEDS	16	Hippeastrum striatum 'Saltao'	Pacific Bulb Society	\N	\N	\N	\N
BX 436	SEEDS	17	Hippeastrum stylosum	Pacific Bulb Society	\N	\N	\N	\N
BX 436	SEEDS	18	Phaedranassa tunguraguae	Pacific Bulb Society	\N	\N	\N	\N
BX 436	SEEDS	19	Hippeastrum aulicum x H. papilio	Nick Plummer	\N	\N	\N	Seed
BX 437	BULBS	11	Cyrtanthus elatus x C. montanus	Jill Peterson	offset bulbs - ex. PBS BX 359	\N	\N	Offsets
BX 437	SEEDS	12	Eucrosia mirabilis	Nick Plummer	seed	\N	\N	\N
BX 437	SEEDS	13	Zephyranthes 'Sunset Strain'	Susan Clark	seed	\N	\N	\N
BX 438	BULBS	1	Oxalis callosa	Mary Sue Ittner	\N	\N	\N	\N
BX 438	BULBS	2	Oxalis sp.	Mary Sue Ittner	Oaxaca, Mx.	\N	\N	\N
BX 438	BULBS	3	Oxalis zeekoevleyensis	Mary Sue Ittner	\N	\N	w	\N
BX 438	BULBS	4	Smithiantha zebrina	Dennis Kramb	\N	\N	\N	Rhizomes
BX 438	BULBS	5	Achimenes misera	Dennis Kramb	\N	\N	\N	Rhizomes
BX 438	BULBS	6	Achimenes dulcis	Dennis Kramb	\N	\N	\N	Rhizomes
BX 438	BULBS	7	xGloximannia 'Circle' x 'Evita'	Dennis Kramb	\N	\N	\N	Rhizomes
BX 438	BULBS	8	Achimenes 'Forget Me Not'	Dennis Kramb	\N	\N	\N	Rhizomes
BX 438	BULBS	9	Achimenes 'Caligula'	Dennis Kramb	\N	\N	\N	Rhizomes
BX 438	BULBS	10	Achimenes 'Platinum'	Dennis Kramb	\N	\N	\N	Rhizomes
BX 439	BULBS	1	Oxalis flava	Mary Sue Ittner	- yellow fall blooming	\N	\N	\N
BX 439	BULBS	2	Oxalis melanosticta 'Ken Aslet'	Mary Sue Ittner	fall blooming	\N	\N	\N
BX 439	BULBS	3	Oxalis obtusa	Mary Sue Ittner	MV5005a Winter flowering.	\N	\N	\N
BX 439	BULBS	4	Oxalis pardalis	Mary Sue Ittner	MV7632 fall blooming	\N	\N	\N
BX 439	BULBS	5	Oxalis livida	Mary Sue Ittner	fall blooming	\N	\N	\N
BX 439	BULBS	6	Oxalis hirta 'Gothenburg'	Mary Sue Ittner	fall blooming	\N	\N	\N
BX 439	BULBS	7	Oxalis hirta	Mary Sue Ittner	fall blooming	\N	\N	\N
BX 439	BULBS	8	Oxalis hirta	Mary Sue Ittner	- mauve fall blooming	\N	\N	\N
BX 439	BULBS	9	Oxalis commutata	Mary Sue Ittner	fall blooming	\N	\N	\N
BX 439	BULBS	10	Oxalis engleriana	Mary Sue Ittner	fall blooming	\N	\N	\N
BX 443	BULBS	22	Oxalis melanosticta 'Ken Aslet'	Karl Church	\N	\N	\N	\N
BX 435	BULBS	4	Amorphophallus konjac	Albert Stella	small corms	\N	\N	Small corms
BX 435	BULBS	5	Amorphophallus krausei	Albert Stella	corms	\N	\N	Corms
BX 435	BULBS	2	Hippeastrum x ackermanii	Albert Stella	\N	\N	\N	\N
BX 437	BULBS	7	Crocosmia hybrid	Cody Hinchliff	- Hardy, Orange	\N	\N	\N
BX 437	BULBS	8	Lilium sargentiae	Cody Hinchliff	bulbils	\N	\N	Bulbils
BX 437	BULBS	9	Gladiolus tristis x G. alatus	Cody Hinchliff	ex PBS BX412 #4	\N	\N	\N
BX 437	BULBS	10	Gladiolus carinatus	Cody Hinchliff	ex PBS SX7 #941	\N	\N	\N
BX 437	BULBS	1	Pamianthe peruviana	Rimmer deVries	- small offset bulbs	\N	\N	Small offsets
BX 437	SEEDS	2	Haemanthus albiflos	Rimmer deVries	seeds	\N	\N	\N
BX 437	SEEDS	3	Clivia 'Sahin Twin'	Rimmer deVries	seeds - Open Pollinated	\N	\N	\N
BX 438	BULBS	11	Clivia 'Sahin Twin'	Rimmer deVries	\N	\N	\N	\N
BX 438	BULBS	12	Cyrtanthus elatus x C. montana	Rimmer deVries	offsets ex Mary Sue Ittner BX 330	\N	\N	Offsets
BX 438	BULBS	13	Phaedranassa dubia	Rimmer deVries	? seedlings ex Ornduff 9674 Imbabua, Ecuador	\N	\N	Seedlings
BX 440	BULBS	1	Nymphaea x	Uli Urban	- blue, viviparous	\N	\N	\N
BX 440	BULBS	2	Cyrtanthus sp.	Uli Urban	ex. John Lavranos	\N	\N	\N
BX 440	BULBS	3	Oxalis bifurca	Mary Sue Ittner	\N	\N	\N	\N
BX 440	BULBS	4	Oxalis flava	Mary Sue Ittner	(lupinifolia)	\N	\N	\N
BX 440	BULBS	5	Oxalis flava	Mary Sue Ittner	- mostly pink	\N	\N	\N
BX 440	BULBS	6	Oxalis imbricata	Mary Sue Ittner	\N	\N	\N	\N
BX 440	BULBS	7	Oxalis obtusa	Mary Sue Ittner	MV5051	\N	\N	\N
BX 440	BULBS	8	Oxalis obtusa	Mary Sue Ittner	MV6341	\N	\N	\N
BX 440	BULBS	9	Oxalis obtusa 'Peaches & Cream'	Mary Sue Ittner	\N	\N	\N	\N
BX 440	BULBS	10	Tulipa clusiana var. chrysantha	Mary Sue Ittner	- sm. bulbs	\N	\N	\N
BX 440	BULBS	11	Tulipa 'Daydream'	Mary Sue Ittner	- Darwin hybrid	\N	\N	\N
BX 440	BULBS	12	Tulipa 'Little Beauty'	Mary Sue Ittner	(pulchella?, humilis?) Bulblets	\N	\N	\N
BX 440	BULBS	13	Oxalis purpurea 'Skar'	Mary Sue Ittner	\N	\N	\N	\N
BX 441	BULBS	1	Zephyranthes grandiflora	Bob Hoel	\N	\N	\N	\N
BX 441	BULBS	2	Ismene sp.	Bob Hoel	\N	\N	\N	\N
BX 441	BULBS	3	Cyrtanthus brachyscyphus	Bob Hoel	\N	\N	\N	\N
BX 441	BULBS	4	Zephyranthes drummondii	Bob Hoel	\N	\N	\N	\N
BX 441	BULBS	5	Freesia laxa	Marvin Ellenbecker	bulbs	\N	\N	\N
BX 441	BULBS	6	Tulipa 'Red Cup'	Mary Sue Ittner	\N	\N	\N	\N
BX 441	BULBS	7	Tulipa batalinii	Mary Sue Ittner	\N	\N	\N	\N
BX 441	BULBS	8	Tulipa linifolia	Mary Sue Ittner	\N	\N	\N	\N
BX 441	BULBS	9	Oxalis purpurea 'Lavender and White'	Mary Sue Ittner	\N	\N	\N	\N
BX 441	BULBS	10	Oxalis purpurea	Mary Sue Ittner	- white	\N	\N	\N
BX 441	BULBS	11	Oxalis bowiei	Mary Sue Ittner	\N	\N	\N	\N
BX 441	BULBS	12	Oxalis riparia	Mary Sue Ittner	\N	\N	\N	\N
BX 441	BULBS	13	Oxalis obtusa	Mary Sue Ittner	MV6341	\N	\N	\N
BX 441	BULBS	14	Oxalis obtusa	Mary Sue Ittner	MV7085	\N	\N	\N
BX 441	BULBS	15	Oxalis obtusa	Mary Sue Ittner	- pink	\N	\N	\N
BX 441	BULBS	16	Oxalis obtusa	Mary Sue Ittner	- coral	\N	\N	\N
BX 441	BULBS	17	Oxalis depressa	Mary Sue Ittner	MV4871	\N	\N	\N
BX 441	BULBS	18	Gloriosa superba	Mary Sue Ittner	- Very few, smaller offsets	\N	\N	\N
BX 441	BULBS	19	Ipheion sessile	Mary Sue Ittner	- Tristagma recurvifolium ?? (received from BX as Ipheion, but there is a note on the wiki that what goes around is probably Tristagma and the few times it flowered it looked like the photos from John Lonsdale on the wiki)	\N	\N	\N
BX 441	BULBS	20	Moraea vegeta	Mary Sue Ittner	\N	\N	\N	\N
BX 442	BULBS	1	Albuca 'Blue Curls'	Pamela Slate	ex. Monica Swartz seed 07/2010	\N	\N	\N
BX 442	BULBS	2	Ferraria schaeferi	Pamela Slate	\N	\N	\N	\N
BX 442	BULBS	3	Ferraria densipunctulata	Pamela Slate	ex. John Wickham BX 368 08/2014	\N	\N	\N
BX 442	BULBS	4	Ferraria crispa subsp. nortieri	Pamela Slate	\N	\N	\N	\N
BX 442	BULBS	5	Ixia paniculata	Pamela Slate	\N	\N	\N	\N
BX 442	BULBS	6	Lachenalia aloides	Pamela Slate	ex. Karl Church BX 432 11/2017	\N	\N	\N
BX 442	BULBS	7	Lachenalia bachmannii	Pamela Slate	ex. Monica Swartz BX 485 09/2011	\N	\N	\N
BX 442	BULBS	8	Lachenalia contaminata	Pamela Slate	ex. BX 296 12/2011	\N	\N	\N
BX 442	BULBS	9	Lachenalia mutabilis	Pamela Slate	ex. Monica Swartz BX 273 04/2011	\N	\N	\N
BX 442	BULBS	10	Lachenalia namaquensis	Pamela Slate	ex. Monica Swartz BX? 10/2010	\N	\N	\N
BX 442	BULBS	11	Lachenalia quadricolor	Pamela Slate	\N	\N	\N	\N
BX 442	BULBS	12	Lachenalia thomasiae	Pamela Slate	ex. Silver Hill	\N	\N	\N
BX 442	BULBS	13	Lachenalia viridiflora	Pamela Slate	ex. Hammer - some from leaf cuttings	\N	\N	\N
BX 442	BULBS	14	Lachenalia 'Rupert'	Pamela Slate	ex. Brent an Becky's 10/2009, GORGEOUS!	\N	\N	\N
BX 442	SEEDS	15	Scilla madeirensis	Pamela Slate	seed ex Longfield Gardens 10/2014	\N	\N	Seeds
BX 443	SEEDS	1	Clivia nobilis	Marvin Ellenbecker	\N	\N	\N	\N
BX 443	SEEDS	2	Hippeastrum papilio	Marvin Ellenbecker	\N	\N	\N	\N
BX 443	SEEDS	3	Pamianthe peruviana	Paul Matthews	seed	\N	\N	\N
BX 443	BULBS	7	Babiana 'Purple Haze'	Karl Church	\N	\N	\N	\N
BX 443	BULBS	8	Lachenalia quadricolor	Karl Church	\N	\N	\N	\N
BX 443	BULBS	9	Moraea villosa	Karl Church	MM71-32	\N	\N	\N
BX 443	BULBS	10	Oxalis asinina	Karl Church	\N	\N	\N	\N
BX 443	BULBS	11	Oxalis bowiei	Karl Church	- pink	\N	\N	\N
BX 443	BULBS	12	Oxalis cathara	Karl Church	\N	\N	\N	\N
BX 443	BULBS	13	Oxalis caprina	Karl Church	\N	\N	\N	\N
BX 443	BULBS	14	Oxalis commutata	Karl Church	MV4674	\N	\N	\N
BX 443	BULBS	15	Oxalis compressa	Karl Church	- double flower	\N	\N	\N
BX 443	BULBS	16	Oxalis engleriana	Karl Church	\N	\N	\N	\N
BX 443	BULBS	17	Oxalis flava	Karl Church	\N	\N	\N	\N
BX 443	BULBS	18	Oxalis flava	Karl Church	- yellow	\N	\N	\N
BX 443	BULBS	19	Oxalis hirta	Karl Church	- pink	\N	\N	\N
BX 443	BULBS	20	Oxalis flava	Karl Church	(lupinifolia)	\N	\N	\N
BX 443	BULBS	21	Oxalis luteola	Karl Church	MV5567	\N	\N	\N
BX 443	BULBS	4	Albuca osmynella	Pamela Slate	(Ornithogalum) osmynella ex Steve Hammer - Redlist Species	\N	\N	\N
BX 443	BULBS	5	Ferraria divaricata subsp. arenosa	Pamela Slate	\N	\N	\N	\N
BX 443	BULBS	6	Watsonia humilis	Pamela Slate	- has not flowered in 3 years in Arizona	\N	\N	\N
BX 439	BULBS	11	Clinanthus incarnatus	Rimmer deVries	- yellow [Often sold as Stenomesson (Clinanthus) variegatum]	\N	\N	\N
BX 443	BULBS	23	Oxalis obtusa	Karl Church	MV6235	\N	\N	\N
BX 443	BULBS	24	Oxalis tomentosa	Karl Church	\N	\N	\N	\N
BX 443	BULBS	25	Oxalis sp.	Karl Church	\N	\N	\N	\N
BX 443	BULBS	26	Oxalis polyphylla	Karl Church	MV6396	\N	\N	\N
BX 443	BULBS	27	Oxalis purpurea	Karl Church	- pink	\N	\N	\N
BX 443	BULBS	28	Oxalis sp.	Karl Church	\N	\N	\N	\N
BX 443	BULBS	29	Oxalis zeekoevleyensis	Karl Church	\N	\N	\N	\N
BX 444	BULBS	8	Brodiaea californica	Jane McGary	- Light purple trumpets in umbel on tall stems, July. Dry summer.	\N	\N	\N
BX 444	BULBS	9	Hyacinthoides cedretorum	Jane McGary	(syn. H. algeriensis, H. hispanica ssp. algeriensis). Smaller than H. hispanica, tepals more reflexed. Source, Archibald collection from Morocco. WARNING: Might become invasive in mild climates; prevent seed from dispersing.	\N	\N	\N
BX 444	BULBS	10	Narcissus bulbocodium subsp. praecox	Jane McGary	- Light yellow flowers on 15 cm stems, flowering Jan.-Feb., well before other *N. bulbocodium.*	\N	\N	\N
BX 444	BULBS	11	Narcissus cantabricus subsp. cantabricus	Jane McGary	- Cream-white flowers in December and January. Hardy to about 20 F. Dry summer.	\N	\N	\N
BX 444	BULBS	12	Narcissus 'Chinese Ivory'	Jane McGary	- Probably a selection of *N. cantabricus*, grown by Walter Blom. Flowers January. A little shorter than species.	\N	\N	\N
BX 444	BULBS	13	Narcissus romieuxii	Jane McGary	- wild-collected seed, but indistinguishable from 'Julia Jane'.	\N	\N	\N
BX 444	BULBS	14	Narcissus romieuxii mix with N. 'Julia Jane'	Jane McGary	- Light yellow flowers January-February. This donation includes the clone 'Julia Jane' and its seedlings; do not sell under clone name. Hardy to about 20 F.	\N	\N	\N
BX 444	BULBS	15	Notholirion thomsonianum	Jane McGary	- Large lavender trumpet flowers, late spring, on 15 cm+ stems. Small bulblets will flower in about 3 to 4 years. Bulb is monocarpic but produces many offsets. Very adaptable in gardens but prefers a dryish summer dormancy. Long, lax foliage.	\N	\N	\N
BX 444	BULBS	16	Triteleia hyacinthina	Jane McGary	- Spherical umbel of white flowers, mid spring; Pacific Northwest native.	\N	\N	\N
BX 444	SEEDS	17	Amorphophallus kiusianus	Albert Stella	\N	\N	\N	\N
BX 444	SEEDS	18	Hymenocallis imperialis	Albert Stella	\N	\N	\N	\N
BX 444	BULBS	19	Cyrtanthus labiatus	Monica Swartz	bulbs	\N	\N	\N
BX 444	BULBS	20	Cyrtanthus montanus	Monica Swartz	bulbs	\N	\N	\N
BX 444	SEEDS	21	Hymenocallis phalangidis	Monica Swartz	seed	\N	\N	\N
BX 444	SEEDS	22	Hymenocallis guerreroensis	Monica Swartz	seed	\N	\N	\N
BX 444	SEEDS	23	Manfreda rubescens	Monica Swartz	seed	\N	\N	\N
BX 444	BULBS	24	Lilium sargentiae	Arnold Trachtenberg	bulbils	\N	\N	Bulbils
BX 445	SEEDS	1	Monopyle sp.	Dennis Kramb	GRE 12131 seeds	\N	\N	\N
BX 445	BULBS	3	Ixia hybrids	Mary Sue Ittner	?	\N	\N	Corms
BX 445	BULBS	4	Allium subvillosum	Mary Sue Ittner	\N	\N	\N	\N
BX 445	SEEDS	5	Cyrtanthus brachyscyphus	Mary Sue Ittner	seeds	\N	\N	\N
BX 445	BULBS	6	Oxalis obtusa	Mary Sue Ittner	\N	\N	\N	\N
BX 445	BULBS	7	Hyacinthoides lingulata	Mary Sue Ittner	(Scilla) lingulata	\N	\N	\N
BX 445	SEEDS	9	Phaedranassa sp.	Mary Sue Ittner	Seeds	\N	\N	\N
BX 445	BULBS	10	Muscari armeniacum 'Canteb'	Mary Sue Ittner	\N	\N	\N	\N
BX 445	BULBS	11	Nerine 'Pearl Blush'	Mary Sue Ittner	x H40 - Zinkowski rescues	\N	\N	\N
BX 445	BULBS	12	Barnardia japonica	Mary Sue Ittner	(Scilla scilloides)	\N	\N	\N
BX 446	BULBS	1	Babiana framesii	Mary Sue Ittner	\N	\N	\N	\N
BX 446	BULBS	2	Ferraria variabilis	Mary Sue Ittner	\N	\N	\N	\N
BX 446	BULBS	3	Nerine sarniensis hybrids	Mary Sue Ittner	\N	\N	\N	\N
BX 446	BULBS	4	Nerine 'Hybrid Pink' x 'Aristocrat'	Mary Sue Ittner	- Zinkowski rescues	\N	\N	\N
BX 446	BULBS	5	Nerine 'Wombe' x 'Carmenita'	Mary Sue Ittner	\N	\N	\N	\N
BX 446	BULBS	6	Ferraria crispa subsp. nortieri	Mary Sue Ittner	\N	\N	\N	\N
BX 446	BULBS	7	Lachenalia longituba	Mary Sue Ittner	(Polyxena) longituba	\N	\N	\N
BX 446	BULBS	8	Lachenalia quadricolor	Mary Sue Ittner	\N	\N	\N	\N
BX 446	BULBS	9	Geissorhiza inaequalis	Mary Sue Ittner	- each produces tiny offsets around the mother corm like Gladiolus tristis so if you reuse soil you planted it in you'll probably see it in other pots. Still I think it is unlikely to crowd out more important bulbs as flowering sized corms are tiny and dwindle over time	\N	\N	\N
BX 446	BULBS	10	Moraea bellendenii	Mary Sue Ittner	\N	\N	\N	\N
BX 446	BULBS	11	Moraea lurida	Mary Sue Ittner	\N	\N	\N	\N
BX 446	BULBS	12	Tritonia deusta	Mary Sue Ittner	\N	\N	\N	\N
BX 446	BULBS	13	Tritonia flabellifolia	Mary Sue Ittner	\N	\N	\N	\N
BX 447	BULBS	1	Griffinia aracensis	Mary Sue Ittner	- few, many small	\N	\N	\N
BX 447	BULBS	2	Oxalis palmifrons	Mary Sue Ittner	\N	\N	\N	\N
BX 447	BULBS	3	Brodiaea pallida	Mary Sue Ittner	- very rare plant, grows in wet spot so needs to be watered until it flowers (often it stops raining in California before then). Offsets from corms or seed I don't remember which I obtained from the Robinetts in the 1980s.	\N	\N	\N
BX 447	BULBS	4	Haemanthus humilis subsp. humilis	Mary Sue Ittner	ex. Thomas River form	\N	\N	\N
BX 447	BULBS	6	Allium amplectens	Mary Sue Ittner	\N	\N	\N	\N
BX 445	BULBS	2	Haemanthus coccineus	Arcangelo Wessells	- big offsets from plants originally obtained from Strybing.	\N	\N	Big offsets
BX 444	SEEDS	1	Echeandia scabrella	Rimmer deVries	ex Hannon - Mexico, near Huajuapan de Leon	\N	\N	\N
BX 444	SEEDS	2	Habranthus tubispathus	Rimmer deVries	pink	\N	\N	\N
BX 444	SEEDS	3	Rhodophiala chilensis	Rimmer deVries	ex Telos ex Osmani Baulosa	\N	\N	\N
BX 447	BULBS	7	Babiana vanzijliae	Mary Sue Ittner	\N	\N	\N	\N
BX 447	BULBS	8	Brodiaea minor	Mary Sue Ittner	(B. purdyi)	\N	\N	\N
BX 447	BULBS	9	Spiloxene capensis	Mary Sue Ittner	\N	\N	\N	\N
BX 447	BULBS	10	Narcissus romieuxii	Mary Sue Ittner	\N	\N	\N	\N
BX 447	BULBS	12	Romulea ramiflora	Mary Sue Ittner	\N	\N	\N	\N
BX 447	BULBS	13	Tritonia crocata	Mary Sue Ittner	\N	\N	\N	\N
BX 447	BULBS	14	Dichelostemma sp.	Kipp McMichael	(capitatum?) K1210P.D?01 Nevada County	\N	\N	\N
BX 447	BULBS	15	Ferraria crispa	Kipp McMichael	K1308P.FC01 - Duggan	\N	\N	\N
BX 447	BULBS	16	Brodiaea terrestris	Kipp McMichael	K11P.BT01 - Carolina St. serpentine, Potrero Hill, SF	\N	\N	\N
BX 447	BULBS	17	Dichelostemma volubile	Kipp McMichael	K11P.DV01 - HWY 90 Tulare County, 2011	\N	\N	\N
BX 447	BULBS	18	Tritonia crispa	Kipp McMichael	K10S.TC01 - SilverHill	\N	\N	\N
BX 447	BULBS	19	Allium falcifolium	Kipp McMichael	? K11P.A?01 - Fairfax Bolinas serpentine, 2011	\N	\N	\N
BX 447	BULBS	20	Freesia caryophyllaceae	Kipp McMichael	K10P.FC01	\N	\N	\N
BX 447	BULBS	21	Babiana ringens	Kipp McMichael	K11P.BR01 - SilverHill	\N	\N	\N
BX 447	BULBS	22	Gladiolus equitans	Kipp McMichael	K13105.GE01	\N	\N	\N
BX 447	BULBS	23	Ferraria uncinata	Kipp McMichael	K1308P.FU01 - Duggan	\N	\N	\N
BX 447	BULBS	24	Triteleia laxa	Kipp McMichael	K10P.TL01 - Nevada County	\N	\N	\N
BX 447	BULBS	25	DIchelostemma capitatum	Kipp McMichael	K10P.DC01 - Nevada County	\N	\N	\N
BX 447	BULBS	26	Ferraria divaricata	Kipp McMichael	K1308P.FD02 - Duggan	\N	\N	\N
BX 447	BULBS	27	Daubenya zeyheri	Kipp McMichael	K12105,DZ01	\N	\N	\N
BX 447	BULBS	28	Ferraria ferrariola	Kipp McMichael	K1308P.FF01 - Duggan	\N	\N	\N
BX 447	BULBS	29	DIchelostemma congestum	Kipp McMichael	? K10P.DC02 - Nevada County	\N	\N	\N
BX 447	BULBS	30	Lachenalia reflexa	Kipp McMichael	KB105.LR01	\N	\N	\N
BX 447	BULBS	31	Massonia pustulata	Kipp McMichael	K11S.MP01 - Duggan	\N	\N	\N
BX 447	BULBS	32	Calochortus kennedyi	Kipp McMichael	1509.CK01	\N	\N	\N
BX 447	BULBS	33	Calochortus amoenus	Kipp McMichael	- Camp Nelson, 2011	\N	\N	\N
BX 447	BULBS	34	Calochortus luteus	Kipp McMichael	? - Mt. Tamalpais, serpemtime rock springs	\N	\N	\N
BX 447	BULBS	35	Polyxena sp.	Kipp McMichael	- SilverHill (Most of Polyxena has been moved to Lachenalia with a few now in Massonia and Daubenya	\N	\N	\N
BX 447	BULBS	36	Veltheimia capensis	Kipp McMichael	\N	\N	\N	\N
BX 448	BULBS	1	Calochortus albus	Kipp McMichael	collected Nevada County	\N	\N	\N
BX 448	BULBS	2	Calochortus albus	Kipp McMichael	collected Yuba County	\N	\N	\N
BX 448	BULBS	3	Calochortus albus	Kipp McMichael	collected Tuolumne County	\N	\N	\N
BX 448	BULBS	4	Calochortus albus	Kipp McMichael	collected Monterey County	\N	\N	\N
BX 448	BULBS	5	Calochortus albus	Kipp McMichael	collected San Luis Obispo County. Different listings of the same species from the same location represent collections in different years. A data spreadsheet with Kipp's ID numbers (with associated years) will accompany all orders.	\N	\N	\N
BX 448	BULBS	6	Calochortus albus	Kipp McMichael	collected San Luis Obispo County. Different listings of the same species from the same location represent collections in different years. A data spreadsheet with Kipp's ID numbers (with associated years) will accompany all orders.	\N	\N	\N
BX 448	BULBS	7	Calochortus albus var. rubellus	Kipp McMichael	collected San Luis Obispo County	\N	\N	\N
BX 448	BULBS	8	Calochortus albus	Kipp McMichael	collected San Luis Obispo County	\N	\N	\N
BX 448	BULBS	9	Calochortus albus	Kipp McMichael	(var. rubellus?) collected San Luis Obispo County	\N	\N	\N
BX 448	BULBS	10	Calochortus amabilis	Kipp McMichael	collected Solano County	\N	\N	\N
BX 448	BULBS	11	Calochortus amabilis	Kipp McMichael	Nathan Lange collected Lake County	\N	\N	\N
BX 448	BULBS	12	Calochortus amabilis	Kipp McMichael	collected Napa County	\N	\N	\N
BX 448	BULBS	13	Calochortus amoenus	Kipp McMichael	collected Tulare County	\N	\N	\N
BX 448	BULBS	14	Calochortus catalinae	Kipp McMichael	collected San Luis Obispo County	\N	\N	\N
BX 448	BULBS	15	Calochortus clavatus	Kipp McMichael	collected San Luis Obispo County	\N	\N	\N
BX 448	BULBS	16	Calochortus clavatus var. clavatus	Kipp McMichael	collected San Luis Obispo County	\N	\N	\N
BX 448	BULBS	17	Calochortus clavatus var. avius	Kipp McMichael	collected Eldorado County. Different listings of the same species from the same location represent collections in different years. A data spreadsheet with Kipp's ID numbers (with associated years) will accompany all orders.	\N	\N	\N
BX 448	BULBS	18	Calochortus clavatus var. recurvifolius	Kipp McMichael	collected San Luis Obispo County	\N	\N	\N
BX 448	BULBS	19	Calochortus clavatus var. avius	Kipp McMichael	collected Eldorado County. Different listings of the same species from the same location represent collections in different years. A data spreadsheet with Kipp's ID numbers (with associated years) will accompany all orders.	\N	\N	\N
BX 448	BULBS	20	Calochortus davidsonianus	Kipp McMichael	collected Orange County	\N	\N	\N
BX 448	BULBS	21	Calochortus davidsonianus	Kipp McMichael	collected Riverside County	\N	\N	\N
BX 448	BULBS	22	Calochortus davidsonianus	Kipp McMichael	collected Lake County	\N	\N	\N
BX 448	BULBS	23	Calochortus fimbriatus	Kipp McMichael	collected Monterey County	\N	\N	\N
BX 448	BULBS	24	Calochortus fimbriatus	Kipp McMichael	collected Santa Barbara County. Different listings of the same species from the same location represent collections in different years. A data spreadsheet with Kipp's ID numbers (with associated years) will accompany all orders.	\N	\N	\N
BX 448	BULBS	25	Calochortus fimbriatus	Kipp McMichael	collected Santa Barbara County. Different listings of the same species from the same location represent collections in different years. A data spreadsheet with Kipp's ID numbers (with associated years) will accompany all orders.	\N	\N	\N
BX 448	BULBS	26	Calochortus luteus	Kipp McMichael	collected Marin County	\N	\N	\N
BX 448	BULBS	27	Calochortus luteus	Kipp McMichael	collected San Luis Obispo County	\N	\N	\N
BX 448	BULBS	28	Calochortus luteus	Kipp McMichael	collected Monterey County	\N	\N	\N
BX 448	BULBS	29	Calochortus monophyllus	Kipp McMichael	collected Amador County	\N	\N	\N
BX 448	BULBS	30	Calochortus obispoensis	Kipp McMichael	collected San Luis Obispo County	\N	\N	\N
BX 448	BULBS	31	Calochortus obispoensis	Kipp McMichael	BX 352 #4	\N	\N	\N
BX 448	BULBS	32	Calochortus plummerae	Kipp McMichael	collected Los Angeles County	\N	\N	\N
BX 448	BULBS	33	Calochortus pulchellus	Kipp McMichael	collected Contra Costa County	\N	\N	\N
BX 448	BULBS	34	Chlorogalum purpureum var. purpureum	Kipp McMichael	collected Monterey County	\N	\N	\N
BX 448	BULBS	35	Calochortus simulans	Kipp McMichael	collected San Luis Obispo County	\N	\N	\N
BX 448	BULBS	42	Calochortus splendens	Kipp McMichael	collected Ventura County	\N	\N	\N
BX 448	BULBS	43	Calochortus tiburonensis	Kipp McMichael	ex hort. Different listings of the same species from the same location represent collections in different years. A data spreadsheet with Kipp's ID numbers (with associated years) will accompany all orders.	\N	\N	\N
BX 448	BULBS	44	Calochortus tiburonensis	Kipp McMichael	ex hort. Different listings of the same species from the same location represent collections in different years. A data spreadsheet with Kipp's ID numbers (with associated years) will accompany all orders.	\N	\N	\N
BX 448	BULBS	45	Calochortus tolmiei	Kipp McMichael	collected San Mateo County	\N	\N	\N
BX 448	BULBS	46	Calochortus umbellatus	Kipp McMichael	collected Marin County	\N	\N	\N
BX 448	BULBS	47	Calochortus umbellatus	Kipp McMichael	collected Marin County	\N	\N	\N
BX 448	BULBS	48	Calochortus uniflorus	Kipp McMichael	collected Santa Cruz County	\N	\N	\N
BX 448	BULBS	49	Calochortus venustus	Kipp McMichael	collected Tuolumne County	\N	\N	\N
BX 448	BULBS	50	Calochortus weedii var. intermedius	Kipp McMichael	collected Orange County	\N	\N	\N
BX 448	BULBS	51	Calochortus weedii var. weedii	Kipp McMichael	collected Riverside County	\N	\N	\N
BX 448	BULBS	52	Calochortus splendens	Kipp McMichael	collected Riverside County	\N	\N	\N
BX 449	BULBS	12	Arisaema candidissimum	Bridget Wycozna	bulbs	\N	\N	\N
BX 449	BULBS	13	Fritillaria atropurpurea	Robin Hansen	bulbs	\N	\N	\N
BX 449	BULBS	14	Crinum 'Menehune'	Jim Waddick	bulbs	\N	\N	\N
BX 449	BULBS	15	Phaedranassa viridiflora	Jim Waddick	bulbs	\N	\N	\N
BX 449	BULBS	16	Polianthes x	Jim Waddick	tubers - maybe P. x bundrantii?	\N	\N	Tubers
BX 450	BULBS	1	Gladiolus patersoniae	Kipp McMichael	\N	\N	\N	\N
BX 450	BULBS	2	Romulea tortuosa	Kipp McMichael	\N	\N	\N	\N
BX 450	BULBS	3	Moraea pritzeliana	Kipp McMichael	\N	\N	\N	\N
BX 450	BULBS	4	Ferraria crispa form A	Dee Foster	- form A	\N	\N	\N
BX 450	BULBS	5	Ferraria crispa	Dee Foster	\N	\N	\N	\N
BX 450	BULBS	6	Babiana ecklonii	Dee Foster	\N	\N	\N	\N
BX 450	BULBS	7	Lachenalia liliiflora	Dee Foster	\N	\N	\N	\N
BX 450	BULBS	8	Moraea villosa	Dee Foster	\N	\N	\N	\N
BX 450	BULBS	9	Calochortus uniflorus	Mary Sue Ittner	\N	\N	\N	\N
BX 450	BULBS	10	Calochortus vestae	Mary Sue Ittner	\N	\N	\N	\N
BX 450	BULBS	11	Cyrtanthus brachyscyphus	Mary Sue Ittner	\N	\N	\N	\N
BX 450	BULBS	12	Tropaeolum tricolor	Mary Sue Ittner	few	\N	\N	\N
BX 450	BULBS	13	Dioscoraea bulbifera	Albert Stella	? bulbils - Rarotonga, 2002	\N	\N	Bulbils
BX 451	BULBS	13	Calochortus vestae	Jim Barton	\N	\N	\N	\N
BX 451	BULBS	14	Dichelostemma volubile	Jim Barton	\N	\N	\N	\N
BX 451	BULBS	15	Brodiaea elegans	Jim Barton	\N	\N	\N	\N
BX 451	BULBS	1	Herbertia lahue	Cody Hinchliff	- PBS SX7	\N	\N	\N
BX 451	BULBS	2	Herbertia lahue	Cody Hinchliff	- PBS SX8	\N	\N	\N
BX 451	BULBS	3	Moraea bellendenii	Cody Hinchliff	\N	\N	\N	\N
BX 451	BULBS	4	Moraea polyanthos	Cody Hinchliff	\N	\N	\N	\N
BX 451	BULBS	5	Oxalis fabifolia	Cody Hinchliff	\N	\N	\N	\N
BX 451	BULBS	6	Oxalis flava	Cody Hinchliff	\N	\N	\N	\N
BX 451	BULBS	7	Sparaxis metelerkampiae	Cody Hinchliff	\N	\N	\N	\N
BX 451	BULBS	8	Sparaxis parviflora	Cody Hinchliff	\N	\N	\N	\N
BX 451	BULBS	9	Tritonia dubia	Cody Hinchliff	\N	\N	\N	\N
BX 451	BULBS	10	Tritonia x	Cody Hinchliff	\N	\N	\N	\N
BX 451	BULBS	11	Tritonia x	Cody Hinchliff	\N	\N	\N	\N
BX 451	BULBS	12	Tritonia hyalina	Cody Hinchliff	(T. crocata?)	\N	\N	\N
BX 449	SEEDS	1	Iris foetidissima	Rimmer deVries	seed	\N	\N	\N
BX 449	BULBS	2	Hymenocallis leavenworthii	Rimmer deVries	bulbs ex. Telos	\N	\N	\N
BX 449	BULBS	3	Massonia pustulata	Rimmer deVries	bulbs	\N	\N	\N
BX 449	BULBS	4	Albuca 'Petite'	Rimmer deVries	bulbs	\N	\N	\N
BX 449	SEEDS	5	Zephyranthes pulchella	Rimmer deVries	seed ex. Refugio, Texas. Wade Roitsch collection	\N	\N	\N
BX 449	SEEDS	6	Zephyranthes smallii	Rimmer deVries	seed ex Brownsville, Texas. Charles Crane collection	\N	\N	\N
BX 449	SEEDS	7	Zephyranthes primulina	Rimmer deVries	seed ex Uli Urban ex NARGS Lynn Makilka	\N	\N	\N
BX 449	SEEDS	8	Zephyranthes reginae	Rimmer deVries	seed ex Lynn Makilka NARGS 2015	\N	\N	\N
BX 449	SEEDS	9	Zephyranthes 'Pink Beauty'	Rimmer deVries	seed ex Ina C.	\N	\N	\N
BX 451	BULBS	16	Calochortus venustus	Jim Barton	\N	\N	\N	\N
BX 451	BULBS	17	Calochortus superbus	Jim Barton	? C. superbus x luteus?	\N	\N	\N
BX 451	BULBS	18	Triteleia hyacinthina	Jim Barton	\N	\N	\N	\N
BX 451	BULBS	19	Triteleia laxa	Jim Barton	\N	\N	\N	\N
BX 451	SEEDS	20	Habranthus tubispathus	Michael Kent	\N	\N	\N	\N
BX 451	SEEDS	21	Zephyranthes citrina	Michael Kent	\N	\N	\N	\N
BX 451	SEEDS	22	Zephyranthes minima	Michael Kent	\N	\N	\N	\N
BX 451	SEEDS	23	Zephyranthes x	Michael Kent	\N	\N	\N	\N
BX 451	BULBS	24	Crocus sp.	Joyce Miller	\N	\N	\N	\N
BX 451	SEEDS	33	Haemanthus coccineus	Terry Laskiewicz	\N	\N	\N	\N
BX 451	SEEDS	34	Crinum macowanii	Terry Laskiewicz	- These have germinated and produced little bulbs	\N	\N	\N
BX 451	BULBS	35	Moraea ciliata	Robert Werra	- tall	\N	\N	\N
BX 451	BULBS	36	Moraea ciliata	Robert Werra	- short	\N	\N	\N
BX 452	SEEDS	1	Amaryllis belladonna	Linda Wulf	seed	\N	\N	\N
BX 452	SEEDS	2	Amaryllis belladonna	Marvin Ellenbecker	seed	\N	\N	\N
BX 452	BULBS	3	Tritoniopsis sp.	Marvin Ellenbecker	syn. Anapalina - Red flowers w/ yellow markings **Best in Pots - CAN BE INVASIVE IN MILD CLIMATES**	\N	\N	\N
BX 452	BULBS	4	Haemanthus pauculifolius	Dave Brastow	\N	\N	\N	\N
BX 452	BULBS	5	Arum dioscoridis	Dave Brastow	\N	\N	\N	\N
BX 452	BULBS	6	Rhodophiala sp.  'Granatifolia'	Dave Brastow	\N	\N	\N	\N
BX 452	BULBS	12	Strumaria discifera	Dylan Hannon	? - Pakhuis Pass, South Africa	\N	\N	\N
BX 452	BULBS	13	Strumaria discifera	Dylan Hannon	- Nieuwoudtville, South Africa	\N	\N	\N
BX 452	BULBS	14	Cyrtanthus sp.	Uli Urban	- ex. John Lavranos	\N	\N	\N
BX 452	BULBS	15	Amaryllis belladonna	Bob Hoel	- small bulbs	\N	\N	\N
BX 452	BULBS	16	Amaryllis belladonna	Bob Hoel	- large bulbs	\N	\N	\N
BX 452	BULBS	17	Hippeastrum puniceum	Bob Hoel	\N	\N	\N	\N
BX 452	BULBS	18	Hippeastrum x	Bob Hoel	- unknown	\N	\N	\N
BX 452	BULBS	19	Hippeastrum x	Bob Hoel	- unknown	\N	\N	\N
BX 452	BULBS	20	[Hippeastrum papilio x H. mandonii] x H. 'Evergreen'	Bob Hoel	\N	\N	\N	\N
BX 452	BULBS	21	Hippeastrum 'Basuto'	Bob Hoel	\N	\N	\N	\N
BX 452	BULBS	22	Hippeastrum 'Lemon and Lime'	Bob Hoel	\N	\N	\N	\N
BX 452	BULBS	23	Hippeastrum 'Gervase'	Bob Hoel	\N	\N	\N	\N
BX 452	BULBS	24	Hippeastrum x	Bob Hoel	- Salmon-colored flower	\N	\N	\N
BX 452	BULBS	25	Hippeastrum 'Carmen'	Bob Hoel	\N	\N	\N	\N
BX 452	BULBS	26	Hippeastrum 'Minerva'	Bob Hoel	\N	\N	\N	\N
BX 452	BULBS	27	Hippeastrum x	Bob Hoel	- unknown	\N	\N	\N
BX 452	BULBS	28	Hippeastrum 'Dancing Queen'	Bob Hoel	\N	\N	\N	\N
BX 452	BULBS	29	Hippeastrum x	Bob Hoel	- Red w/ white stripes	\N	\N	\N
BX 452	BULBS	30	Hippeastrum 'Double Record'	Bob Hoel	\N	\N	\N	\N
BX 452	BULBS	31	Hippeastrum x	Bob Hoel	- single, tall, red	\N	\N	\N
BX 452	BULBS	32	Hippeastrum 'Minerva' x H. 'Black Pearl'	Bob Hoel	\N	\N	\N	\N
BX 452	BULBS	33	Hippeastrum 'Nymph'	Bob Hoel	\N	\N	\N	\N
BX 452	BULBS	34	Hippeastrum x	Bob Hoel	- white w/ green throat	\N	\N	\N
BX 452	BULBS	35	Hippeastrum 'Rilona'	Bob Hoel	\N	\N	\N	\N
BX 452	BULBS	36	Hippeastrum papilio	Bob Hoel	\N	\N	\N	\N
BX 453	BULBS	1	Gladiolus communis	Dennis Van Landuyt	?	\N	\N	\N
BX 453	BULBS	2	Tritonia lineata	Dennis Van Landuyt	(syn. Tritonia gladiolaris)	\N	\N	\N
BX 453	BULBS	3	Gladiolus tristis	Dennis Van Landuyt	ex Signa 3z323 & 11xx315	\N	\N	\N
BX 453	BULBS	4	Freesia alba	Dennis Van Landuyt	ex Signa 13xx324	\N	\N	\N
BX 453	BULBS	5	Tritonia deusta	Dennis Van Landuyt	ex Signa 7xx258	\N	\N	\N
BX 453	BULBS	6	Tritonia pallida	Dennis Van Landuyt	ex SHS	\N	\N	\N
BX 453	BULBS	7	Ornithogalum longibracteatum	Charles Powne	(syn. Albuca bracteata)	\N	\N	\N
BX 453	BULBS	8	Amorphophallus konjac	Charles Powne	\N	\N	\N	\N
BX 453	SEEDS	9	Amaryllis belladonna	Francisco Lopez	\N	\N	\N	\N
BX 453	SEEDS	10	Nerine bowdenii	Francisco Lopez	\N	\N	\N	\N
BX 453	SEEDS	11	Albuca sp.	Mary Sue Ittner	\N	\N	\N	\N
BX 453	SEEDS	12	Amaryllis belladonna	Mary Sue Ittner	seed OP	\N	\N	\N
BX 453	SEEDS	13	Nerine sarniensis	Mary Sue Ittner	seed OP	\N	\N	\N
BX 453	SEEDS	14	Nerine bowdenii	Mary Sue Ittner	seed OP	\N	\N	\N
BX 453	SEEDS	15	Nerine humilis	Mary Sue Ittner	seed OP	\N	\N	\N
BX 453	SEEDS	16	Watsonia beatricis	Linda Wulf	(syn. Watsonia pillansii)	\N	\N	\N
BX 454	BULBS	6	Oziroe arida	Monica Swartz	\N	\N	\N	\N
BX 454	SEEDS	7	Hippeastrum 'Minerva'	Karl Church	\N	\N	\N	\N
BX 451	BULBS	25	Lachenalia pallida	Rimmer deVries	- Northern purple/mauve form	\N	\N	\N
BX 454	SEEDS	11	Bessera elegans	Chad Cox	- red	\N	\N	\N
BX 454	SEEDS	12	Cyrtanthus epiphyticus	Chad Cox	\N	\N	\N	\N
BX 454	SEEDS	13	Globba schomburgkii	Francisco Lopez	seeds	\N	\N	\N
BX 454	BULBS	15	Eucrosia bicolor	Dennis Kramb	\N	\N	\N	\N
BX 454	BULBS	16	Seemannia 'Pepper'	Dennis Kramb	\N	\N	\N	\N
BX 454	BULBS	17	Niphaea oblonga	Dennis Kramb	\N	\N	\N	\N
BX 454	BULBS	18	Gloxinia erinoides	Dennis Kramb	\N	\N	\N	\N
BX 454	BULBS	19	Gloxinia erinoides 'Teresina de Goias'	Dennis Kramb	\N	\N	\N	\N
BX 454	BULBS	20	Gloxinia erinoides	Dennis Kramb	ex Mountain Orchids	\N	\N	\N
BX 454	BULBS	21	Diastema vexans	Dennis Kramb	\N	\N	\N	\N
BX 454	BULBS	22	Achimenes misera	Dennis Kramb	\N	\N	\N	\N
BX 454	BULBS	23	Achimenes erecta	Dennis Kramb	\N	\N	\N	\N
BX 454	BULBS	24	Eucodonia andrieuxii 'Cathy'	Dennis Kramb	\N	\N	\N	\N
BX 454	BULBS	25	Eucodonia verticillata	Dennis Kramb	\N	\N	\N	\N
BX 454	BULBS	26	Eucodonia 'Adele'	Dennis Kramb	\N	\N	\N	\N
BX 455	BULBS	1	Oxalis triangularis	Mary Sue Ittner	\N	\N	\N	\N
BX 455	BULBS	2	Gloriosa modesta	Mary Sue Ittner	\N	\N	\N	\N
BX 455	BULBS	3	Oxalis sp.	Mary Sue Ittner	L96-42, Mexico	\N	\N	\N
BX 455	BULBS	5	Hippeastrum aulicum	Mary Sue Ittner	ex. Uli Urban offset - (f. robusta)	\N	\N	\N
BX 455	BULBS	6	Pamianthe peruviana	Mary Sue Ittner	offsets	\N	\N	Offsets
BX 455	BULBS	7	Hippeastrum striatum	Mary Sue Ittner	JES2146 Cianorte, Brazil offsets	\N	\N	Offsets
BX 455	SEEDS	8	Hippeastrum 'Emerald'	Anita Ketcham	seeds	\N	\N	\N
BX 455	SEEDS	9	Hippeastrum 'Lemon and Lime'	Anita Ketcham	seeds	\N	\N	\N
BX 455	SEEDS	10	Liatris mucronata	Crystal Fisher	seed	\N	\N	\N
BX 455	SEEDS	11	Freesia laxa	Chad Cox	seed	\N	\N	\N
BX 455	SEEDS	12	Arisaema sikkokianum	Kenton Seth	seed	\N	\N	\N
BX 455	SEEDS	13	Iris lineata	Kenton Seth	seeds (1 share)	\N	\N	\N
BX 455	SEEDS	14	Erythronium grandiflorum	Kenton Seth	- Carbon Co., CO. Seed	\N	\N	\N
BX 455	SEEDS	15	Iris sogdiana	Kenton Seth	seed	\N	\N	\N
BX 456	SEEDS	2	Clivia x - 'Anna's Yellow'	Roy Herold	[OP]	\N	\N	\N
BX 456	SEEDS	3	Clivia x - 'Belgian Hybrid' x 'Anna's Yellow'	Roy Herold	[OP]	\N	\N	\N
BX 456	SEEDS	4	Clivia 'Monk' x 'Daruma'	Roy Herold	- Nakamura [OP]	\N	\N	\N
BX 456	SEEDS	5	Clivia S-06-1 (wv)	Roy Herold	- ex China [OP]	\N	\N	\N
BX 456	SEEDS	6	Clivia x - 'Shortleaf Yellow' x 'Shortleaf Yellow'	Roy Herold	- Nakamura [OP]	\N	\N	\N
BX 456	SEEDS	7	Clivia x - 'Multipetal' x self	Roy Herold	- Nakamura [OP]	\N	\N	\N
BX 456	SEEDS	8	Habranthus robustus	Mike Kent	\N	\N	\N	\N
BX 456	SEEDS	9	Massonia echinata	Cody Hinchliff	\N	\N	\N	\N
BX 456	SEEDS	10	Moraea polyanthos	Cody Hinchliff	\N	\N	\N	\N
BX 456	SEEDS	11	Romulea flava	Cody Hinchliff	\N	\N	\N	\N
BX 456	SEEDS	12	Herbertia lahue	Cody Hinchliff	\N	\N	\N	\N
BX 456	SEEDS	13	Ornithogalum candicans	Cody Hinchliff	\N	\N	\N	\N
BX 456	SEEDS	14	Habranthus robustus	Cody Hinchliff	\N	\N	\N	\N
BX 456	SEEDS	15	Zephyranthes smallii	Cody Hinchliff	\N	\N	\N	\N
BX 456	SEEDS	16	Habranthus robustus 'Russell Manning'	Cody Hinchliff	\N	\N	\N	\N
BX 456	SEEDS	17	Habranthus x fioryi	Cody Hinchliff	- green throat	\N	\N	\N
BX 456	SEEDS	18	Zephyranthes fosteri	Cody Hinchliff	\N	\N	\N	\N
BX 456	SEEDS	19	Zephyranthes 'Sunset Strain'	Cody Hinchliff	\N	\N	\N	\N
BX 456	SEEDS	20	Zephyranthes refugiensis	Cody Hinchliff	\N	\N	\N	\N
BX 456	SEEDS	21	Zephyranthes reginae	Cody Hinchliff	\N	\N	\N	\N
BX 456	SEEDS	22	Zephyranthes pulchella	Cody Hinchliff	\N	\N	\N	\N
BX 456	SEEDS	23	Rhodophiala bifida	Cody Hinchliff	- Pink	\N	\N	\N
BX 456	SEEDS	24	Rhodophiala bifida	Cody Hinchliff	\N	\N	\N	\N
BX 456	SEEDS	25	Tigridia vanhouttei	Cody Hinchliff	\N	\N	\N	\N
BX 456	SEEDS	26	Zephyranthes verecunda	Cody Hinchliff	\N	\N	\N	\N
BX 456	SEEDS	27	Gladiolus primulinus 'Atomic'	Cody Hinchliff	\N	\N	\N	\N
BX 456	SEEDS	28	Gladiolus oppositiflorus subsp. salmoneus	Cody Hinchliff	\N	\N	\N	\N
BX 456	SEEDS	29	Gladiolus dalenii 'Carolina Primrose'	Cody Hinchliff	\N	\N	\N	\N
BX 456	SEEDS	30	Gladiolus callianthus	Cody Hinchliff	\N	\N	\N	\N
BX 456	SEEDS	31	Gladiolus dalenii 'Boone'	Cody Hinchliff	\N	\N	\N	\N
BX 456	SEEDS	32	Gladiolus papilio	Cody Hinchliff	\N	\N	\N	\N
BX 457	SEEDS	3	Hippeastrum calyptratum	Dylan Hannon	- Macae de Cima, Brazil (red streaks)	\N	\N	\N
BX 457	SEEDS	4	Drimia platyphylla	Dylan Hannon	(syn. Rhadamanthus platyphyllus) - Lambert's Bay, South Africa	\N	\N	\N
BX 457	SEEDS	5	Romulea hantamensis	Dylan Hannon	- Clavinia, South Africa Lavranos30400	\N	\N	\N
BX 457	SEEDS	6	Gladiolus watsonius	Dylan Hannon	-11058	\N	\N	\N
BX 457	SEEDS	7	Gilliesia graminea	Dylan Hannon	OP	\N	\N	\N
BX 457	SEEDS	8	Lachenalia kliprandensis	Dylan Hannon	\N	\N	\N	\N
BX 457	SEEDS	9	Pelargonium barklyi	Dylan Hannon	- Garies, South Africa	\N	\N	\N
BX 457	SEEDS	10	Scilla haemorrhoidalis	Dylan Hannon	\N	\N	\N	\N
BX 457	SEEDS	11	Leucocoryne vittata	Dylan Hannon	OP	\N	\N	\N
BX 457	BULBS	12	Smithiantha hybrid	Dennis Kramb	These are Denniss own crosses. One share of each variety. Each order will receive a single share at random.	\N	\N	Seedlings
BX 457	SEEDS	13	Haemanthus albiflos	Mary Sue Ittner	\N	\N	\N	\N
BX 457	SEEDS	14	Haemanthus pauculifolius	Mary Sue Ittner	\N	\N	\N	\N
BX 455	SEEDS	4	Cyrtanthus mackenii	Mary Sue Ittner	seed	\N	\N	Seeds
BX 454	SEEDS	8	Hippeastrum 'Purple Estella'	Karl Church	\N	\N	\N	\N
BX 456	BULBS	1	Clinanthus incarnatus	Rimmer deVries	- apricot ex Arepu, Peru: Garden Origin	\N	\N	\N
BX 457	BULBS	1	Clinanthus variegatus	Rimmer deVries	- Telos	\N	\N	\N
BX 458	BULBS	1	Oxalis hirta	Chad Cox	\N	\N	\N	\N
BX 458	BULBS	2	Lachenalia quadricolor	Chad Cox	\N	\N	\N	\N
BX 458	SEEDS	3	Clivia miniata	Chad Cox	hybrid (seed)	\N	\N	Seed
BX 458	BULBS	11	Dioscorea discolor	Uli Urban	\N	\N	\N	Bulb
BX 458	SEEDS	12	Hedychium rubrum	Uli Urban	seeds	\N	\N	Seeds
BX 458	SEEDS	13	Hippeastrum papilio	Marvin Ellenbecker	seeds	\N	\N	\N
BX 458	BULBS	14	Gloriosa superba	Mary Sue Ittner	\N	\N	\N	\N
BX 458	BULBS	15	Oxalis engleriana	Mary Sue Ittner	\N	\N	\N	\N
BX 458	BULBS	16	Tulipa orphanidea 'Flava'	Mary Sue Ittner	\N	\N	\N	\N
BX 458	BULBS	17	Oxalis zeekoevleyensis	Mary Sue Ittner	\N	\N	\N	\N
BX 458	BULBS	18	Oxalis flava	Mary Sue Ittner	(lupinifolia)	\N	\N	\N
BX 458	BULBS	19	Oxalis hirta	Mary Sue Ittner	\N	\N	\N	\N
BX 458	BULBS	20	Tulipa sylvestris	Mary Sue Ittner	\N	\N	\N	\N
BX 458	BULBS	21	Oxalis livida	Mary Sue Ittner	\N	\N	\N	\N
BX 458	BULBS	22	Oxalis commutata	Mary Sue Ittner	\N	\N	\N	\N
BX 458	BULBS	23	Oxalis luteola	Mary Sue Ittner	MV5567	\N	\N	\N
BX 458	BULBS	24	Oxalis callosa	Mary Sue Ittner	\N	\N	\N	\N
BX 458	BULBS	25	Oxalis flava	Mary Sue Ittner	- pink	\N	\N	\N
BX 458	BULBS	26	Oxalis melanosticta 'Ken Aslet'	Mary Sue Ittner	\N	\N	\N	\N
BX 458	BULBS	27	Tulipa 'Little Beauty'	Mary Sue Ittner	\N	\N	\N	\N
BX 458	SEEDS	29	Crinum bulbispermum 'Jumbo'	Jim Waddick	seeds	\N	\N	\N
BX 459	BULBS	1	Freesia laxa	Marilynne Mellander	\N	\N	\N	\N
BX 459	BULBS	2	Crocosmia x	Marilynne Mellander	- mixed orange varieties	\N	\N	\N
BX 459	BULBS	5	Albuca namaquensis	Mary Sue Ittner	\N	\N	\N	\N
BX 459	BULBS	6	Oxalis hirta 'Gothenburg'	Mary Sue Ittner	\N	\N	\N	\N
BX 459	BULBS	7	Tulipa batalinii	Mary Sue Ittner	\N	\N	\N	\N
BX 459	BULBS	8	Oxalis imbricata	Mary Sue Ittner	\N	\N	\N	\N
BX 459	BULBS	9	Oxalis hirta	Mary Sue Ittner	- mauve	\N	\N	\N
BX 459	BULBS	10	Oxalis bifurca	Mary Sue Ittner	\N	\N	\N	\N
BX 459	BULBS	11	Oxalis obtusa	Mary Sue Ittner	- coral	\N	\N	\N
BX 459	BULBS	12	Oxalis purpurea	Mary Sue Ittner	- lavender and white	\N	\N	\N
BX 459	BULBS	13	Tulipa clusiana	Mary Sue Ittner	\N	\N	\N	\N
BX 459	BULBS	14	Oxalis bowiei	Mary Sue Ittner	\N	\N	\N	\N
BX 459	BULBS	15	Oxalis pardalis	Mary Sue Ittner	MV7632	\N	\N	\N
BX 459	BULBS	16	Oxalis obtusa	Mary Sue Ittner	MV6341	\N	\N	\N
BX 459	BULBS	17	Oxalis obtusa	Mary Sue Ittner	MV6235	\N	\N	\N
BX 459	BULBS	18	Oxalis purpurea 'Skar'	Mary Sue Ittner	\N	\N	\N	\N
BX 459	BULBS	20	Tulipa linifolia	Mary Sue Ittner	\N	\N	\N	\N
BX 460	BULBS	1	Hippeastrum striatum	Chad Cox	- small offsets	\N	\N	Small offsets
BX 459	SEEDS	21	Zephyranthes fosteri	Ina Crossley	\N	\N	\N	\N
BX 458	BULBS	4	Sinningia tubiflora	Rimmer deVries	\N	\N	\N	\N
BX 458	SEEDS	5	Phaedranassa dubia	Rimmer deVries	seeds	\N	\N	\N
BX 458	SEEDS	6	Hippeastrum papilio	Rimmer deVries	seeds - seed from Telos Seedling 'A' - possible mates: self, Paramongaia, Urceolina microcrater	\N	\N	\N
BX 458	BULBS	7	Ornithogalum saundersiae	Rimmer deVries	\N	\N	\N	\N
BX 458	SEEDS	8	Scilla haemorrhoidalis	Rimmer deVries	seeds	\N	\N	Seed
BX 458	BULBS	9	Notholirion thomsonianum	Rimmer deVries	\N	\N	\N	\N
BX 458	BULBS	10	Cyrtanthus montanus x elatus	Rimmer deVries	\N	\N	\N	\N
BX 459	BULBS	3	Hippeastrum striatum	Rimmer deVries	- Cianorte, Brazil	\N	\N	\N
BX 459	BULBS	4	Hippeastrum 'Evergreen' x H. papilio	Rimmer deVries	\N	\N	\N	\N
BX 460	SEEDS	2	Hippeastrun algaia	Jim Shields	- yellow form ex #2107	\N	\N	\N
BX 460	SEEDS	3	Hippeastrum psittacinum	Jim Shields	\N	\N	\N	\N
BX 460	SEEDS	4	Hippeastrum brasilianum	Jim Shields	- #2247.C x #2103.B	\N	\N	\N
BX 460	SEEDS	5	Hippeastrum iguazuanum	Jim Shields	- #2854.A x self	\N	\N	\N
BX 460	SEEDS	6	Hipprastrum evansiae	Jim Shields	\N	\N	\N	\N
BX 460	SEEDS	7	Hippeastrum bukasovii	Jim Shields	\N	\N	\N	\N
BX 461	SEEDS	1	Crinum 'African Queen'	John Barnes	Seeds	\N	\N	\N
BX 461	SEEDS	2	Crinum macowanii	Nick Plummer	seeds - ex. Zambia	\N	\N	\N
BX 461	SEEDS	3	Crinum bulbispermum 'Jumbo'	Jim Waddick	seeds	\N	\N	\N
BX 461	SEEDS	4	Pamianthe peruviana	Paul Matthews	seeds	\N	\N	\N
BX 461	SEEDS	5	Zephyranthes primulina	Anita Ketcham	seeds	\N	\N	\N
BX 462	BULBS	1	Freesia laxa	Marvin Ellenbecker	bulbs	\N	\N	\N
BX 462	BULBS	2	Amaryllis belladonna	Marvin Ellenbecker	(1 share)	\N	\N	\N
BX 462	SEEDS	3	Zephyranthes primulina	Michael Kent	seeds OP	\N	\N	\N
BX 462	BULBS	5	Oxalis palmifrons	John Willis	\N	\N	\N	\N
BX 462	BULBS	6	Oxalis flava var. fabifolia	John Willis	\N	\N	\N	\N
BX 462	BULBS	7	Oxalis caprina	John Willis	\N	\N	\N	\N
BX 462	BULBS	8	Oxalis hirta 'Gothenburg'	John Willis	\N	\N	\N	\N
BX 462	BULBS	9	Oxalis purpurea 'Skar'	John Willis	\N	\N	\N	\N
BX 462	BULBS	10	Oxalis flava	John Willis	- yellow	\N	\N	\N
BX 462	BULBS	11	Ferraria sp.	John Willis	\N	\N	\N	\N
BX 462	BULBS	12	Ferraria crispa	John Willis	- dark form	\N	\N	\N
BX 462	BULBS	13	Ferraria ferrariola	John Willis	\N	\N	\N	\N
BX 462	BULBS	14	Ferraria punctata	John Willis	\N	\N	\N	\N
BX 462	BULBS	15	Ferraria uncinata	John Willis	\N	\N	\N	\N
BX 462	SEEDS	4	Zephyranthes drummondii 'San Carlos Form'	Michael Kent	seeds OP	\N	\N	\N
BX 462	BULBS	28	Watsonia aletroides	Mary Sue Ittner	\N	\N	\N	\N
BX 462	BULBS	29	Nerine x	Mary Sue Ittner	- Zinkowski Rescue (tag missing letters) 'Hud'? 'Bet'?	\N	\N	\N
BX 462	BULBS	30	Hyacinthoides lingulata	Mary Sue Ittner	\N	\N	\N	\N
BX 462	BULBS	31	Narcissus bulbocodium subsp. tenuifolius	Mary Sue Ittner	\N	\N	\N	\N
BX 462	BULBS	32	Nerine sarniensis	Mary Sue Ittner	(grown from seed of red flowers)	\N	\N	\N
BX 462	BULBS	33	Nerine	Mary Sue Ittner	81-10 x 82-11 - Zinkowski Rescue	\N	\N	\N
BX 462	BULBS	34	Nerine 'Jenny Wren'	Mary Sue Ittner	- Zinkowski Rescue	\N	\N	\N
BX 462	BULBS	35	Lachenalia longituba	Mary Sue Ittner	(Polyxena)	\N	\N	\N
BX 462	BULBS	36	Oxalis namaquana	Mary Sue Ittner	\N	\N	\N	\N
BX 462	BULBS	37	Oxalis caprina	Mary Sue Ittner	\N	\N	\N	\N
BX 462	BULBS	38	Gloriosa modesta	Mary Sue Ittner	(probably)	\N	\N	\N
BX 462	BULBS	39	Ipheion uniflorum	Mary Sue Ittner	\N	\N	\N	\N
BX 462	SEEDS	40	Ammocharis nerinoides	Jim Shields	seeds	\N	\N	\N
BX 462	SEEDS	41	Hymenocallis franklinensis	Jim Shields	seeds	\N	\N	\N
BX 462	SEEDS	42	Hymenocallis eucharidifolia	Jim Shields	seeds	\N	\N	\N
BX 462	SEEDS	43	Hymenocallis durangoensis	Jim Shields	seeds	\N	\N	\N
BX 462	SEEDS	44	Hymenocallis phalangidis	Jim Shields	seeds	\N	\N	\N
BX 462	SEEDS	45	Habranthus caeruleus	Jim Shields	seeds	\N	\N	\N
BX 462	SEEDS	46	Zephyranthes 'Shandsii'	Jim Shields	seeds	\N	\N	\N
BX 462	SEEDS	47	Zephyranthes reginae	Jim Shields	seeds	\N	\N	\N
BX 462	BULBS	48	Hippeastrum striatum	Jim Shields	- Cianorte small offset bulbs	\N	\N	Small offset bulbs
BX 462	BULBS	49	Haemanthus albiflos	Jim Shields	bulbs	\N	\N	\N
BX 434	BULBS	1	Moraea aristata	Mike Mace	\N	\N	w	Corms
BX 434	BULBS	2	Moraea GK1212	Mike Mace	(Moraea villosa form C x Moraea villosa form F)	\N	w	Corms
BX 434	BULBS	3	Moraea villosa form A	Mike Mace	\N	\N	w	Corms
BX 434	BULBS	4	Moraea villosa form B	Mike Mace	\N	\N	w	Corms
BX 434	BULBS	5	Moraea MM12-55	Mike Mace	(M. tricolor x M. macronyx) cormlets	\N	w	Corms
BX 434	BULBS	6	Moraea MM12-67	Mike Mace	(M. villosa form B x M. villosa form D)	\N	w	Corms
BX 434	BULBS	7	Moraea GK 1303_6	Mike Mace	(Moraea MM09-02c x M. villosa form D)	\N	w	Corms
BX 434	BULBS	8	Moraea GK1213	Mike Mace	(M. villosa form F offspring)	\N	w	Corms
BX 434	BULBS	9	Moraea GK1303	Mike Mace	(Moraea MM09-02c x M. villosa form D)	\N	w	Corms
BX 434	BULBS	10	Moraea GK1303_7	Mike Mace	(Moraea MM09-02c x M. villosa form D)	\N	w	Corms
BX 434	BULBS	11	Moraea GK1211	Mike Mace	(M. villosa form E x M. villosa form C)	\N	w	Corms
BX 434	BULBS	12	Moraea GK1329	Mike Mace	(Moraea MM09-02c x M. atropunctata)	\N	w	Corms
BX 434	BULBS	13	Moraea GK1305	Mike Mace	(M. villosa form A x M. villosa form D)	\N	w	Corms
BX 462	SEEDS	16	Hymenocallis harrisiana	Rimmer deVries	seeds	\N	\N	\N
BX 462	SEEDS	17	Hymenocallis cf. guerreroensis	Rimmer deVries	seeds ex. Guerrero; NW of Chilpancingo	\N	\N	\N
BX 462	SEEDS	18	Hymenocallis aff. Phalangidis	Rimmer deVries	- ex. S. of Tepic, Nayarit	\N	\N	\N
BX 462	SEEDS	19	Zephyranthes miradorensis	Rimmer deVries	\N	\N	\N	\N
BX 434	SEEDS	14	Hippeastrum harrisonii	William Hoffman	ex. Jim Shields	\N	\N	\N
BX 434	SEEDS	15	Zephyranthes atamasco	William Hoffman	ex. Wake Co., NC	\N	\N	\N
BX 434	SEEDS	16	Habranthus brachyandrus	William Hoffman	\N	\N	\N	\N
BX 434	SEEDS	17	Lilium formosanum	William Hoffman	\N	\N	\N	\N
BX 434	SEEDS	18	Hippeastrum striatum 'Soltao'	William Hoffman	ex. Mauro Peixoto	\N	\N	\N
BX 463b	BULBS	2	Allium amplectens	Mary Sue Ittner	\N	\N	\N	\N
BX 463b	BULBS	3	Allium 'Silver Spring'	John Barnes	\N	\N	\N	\N
BX 463b	BULBS	4	Allium sativum 'SpanishRoja'	Jim Barton	\N	\N	\N	\N
BX 463b	BULBS	5	Allium sativum 'Late Pink'	Jim Barton	\N	\N	\N	\N
BX 463b	BULBS	6	Amorphophallus bulbifer	John Barnes	\N	\N	\N	\N
BX 463b	BULBS	7	Ammocharis coranica	Mary Sue Ittner	limit 1	\N	\N	\N
BX 463b	BULBS	8	Brodiaea aff. leptandra	Mary Sue Ittner	\N	\N	\N	\N
BX 463b	BULBS	9	Brodiaea pallida	Mary Sue Ittner	\N	\N	\N	\N
BX 463b	BULBS	10	Calochortus superbus	Jim Barton	\N	\N	\N	\N
BX 463b	BULBS	11	Calochortus vestae	Jim Barton	\N	\N	\N	\N
BX 463b	BULBS	12	Camassia leichtlinii white form	Mary Sue Ittner	\N	\N	\N	\N
BX 463b	BULBS	13	Cyrtanthus elatus x montanus	Chad Cox	\N	\N	\N	\N
BX 463b	BULBS	14	Dichelostemma multiflorum	Mary Sue Ittner	\N	\N	\N	\N
BX 463b	BULBS	15	Ferraria crispa	Pamela Slate	\N	\N	\N	\N
BX 463b	BULBS	16	Ferraria crispa ssp. nortieri	Pamela Slate	\N	\N	\N	\N
BX 463b	BULBS	17	Gladiolus cardinalis	Chad Cox	\N	\N	\N	\N
BX 463b	BULBS	18	Ismene or Hymenocallis	John Barnes	\N	\N	\N	\N
BX 463b	BULBS	19	Lachenalia aloides f. quadricolor	Monica Swartz	\N	\N	\N	\N
BX 463b	BULBS	20	Lachenalia bulbifera	Monica Swartz	\N	\N	\N	\N
BX 463b	BULBS	21	Lachenalia pusilla	Hans Callebaut	\N	\N	\N	\N
BX 463b	BULBS	22	Lilium lancifolium Double	Chad Cox	in growth	\N	\N	\N
BX 463b	BULBS	25	Moraea aristata	Mary Sue Ittner	\N	\N	\N	\N
BX 463b	BULBS	26	Moraea bellendenii	Mary Sue Ittner	\N	\N	\N	\N
BX 463b	BULBS	27	Narcissus 'Stocked'	Chad Cox	in growth	\N	\N	\N
BX 463b	BULBS	28	Narcissus cantabricus	Arcangelo Wessells	in growth	\N	\N	\N
BX 463b	BULBS	29	Nerine humilis x undulata	Mary Sue Ittner	limit 1	\N	\N	\N
BX 463b	BULBS	30	Nerine humilis	Mary Sue Ittner	\N	\N	\N	\N
BX 463b	BULBS	31	Ornithogalum sp.	Pamela Slate	Alberto Castillo	\N	\N	\N
BX 463b	BULBS	32	Othonna sp.	Monica Swartz	\N	\N	\N	\N
BX 463b	BULBS	33	Oxalis gracilis	Arcangelo Wessells	Dylan Hannon	\N	\N	\N
BX 463b	BULBS	34	Oxalis gracilis	Chad Cox	\N	\N	\N	\N
BX 463b	BULBS	35	Oxalis palmifrons	Mary Sue Ittner	\N	\N	\N	\N
BX 463b	BULBS	36	Oxalis perdicaria	Mary Sue Ittner	\N	\N	\N	\N
BX 463b	BULBS	37	Pauridia capensis	Mary Sue Ittner	(Spiloxene) capensis	\N	\N	\N
BX 463b	BULBS	38	Pinellia pedatisecta	John Barnes	potentially invasive	\N	\N	\N
BX 463b	BULBS	39	Rhodophiala bifida	Judy Glattstein	in growth	\N	\N	\N
BX 463b	BULBS	41	Triteleia hyacinthina	Jim Barton	\N	\N	\N	\N
BX 463b	BULBS	42	Triteleia ixioides	Jim Barton	\N	\N	\N	\N
BX 463b	BULBS	43	Triteleia laxa	Jim Barton	(commercial strain)	\N	\N	\N
BX 463b	BULBS	44	Tulbaghia simmerli	Chad Cox	(sp?)	\N	\N	\N
BX 463s	SEEDS	2	Agapanthus 'Queen Mum'	John Barnes	\N	\N	\N	\N
BX 463s	SEEDS	6	Allium christophii	Albertus Vos	\N	\N	\N	\N
BX 463s	SEEDS	8	Allium neapolitanum	Albertus Vos	potentially invasive	\N	\N	\N
BX 463s	SEEDS	9	Allium obliquum	Albertus Vos	\N	\N	\N	\N
BX 463s	SEEDS	10	Allium siculum ssp dioscoridis	Albertus Vos	\N	\N	\N	\N
BX 463s	SEEDS	15	Amaryllis belladonna	Jim Barton	\N	\N	\N	\N
BX 463s	SEEDS	23	Bloomeria crocea	Arcangelo Wessells	\N	\N	\N	\N
BX 463s	SEEDS	24	Brodiaea elegans	Jim Barton	\N	\N	\N	\N
BX 463s	SEEDS	25	Brodiaea leptandra	Arcangelo Wessells	Napa, CA	\N	\N	\N
BX 463s	SEEDS	26	Calochortus amabilis	Robert Werra	\N	\N	\N	\N
BX 463s	SEEDS	27	Calochortus catalinae	George Goldsmith	\N	\N	\N	\N
BX 463s	SEEDS	28	Calochortus catalinae	Jim Barton	\N	\N	\N	\N
BX 463s	SEEDS	29	Calochortus luteus	Jim Barton	\N	\N	\N	\N
BX 463s	SEEDS	30	Calochortus luteus	Arcangelo Wessells	Mare Island	\N	\N	\N
BX 463s	SEEDS	31	Calochortus obispoensis	Arcangelo Wessells	\N	\N	\N	\N
BX 463s	SEEDS	32	Calochortus obispoensis	Jane McGary	\N	\N	\N	\N
BX 463s	SEEDS	33	Calochortus pulchellus	Jim Barton	\N	\N	\N	\N
BX 463b	BULBS	1	Albuca sp.	Rimmer deVries	Plettensburg Bay. Roy Herold BX 178	\N	\N	\N
BX 463s	SEEDS	1	Agapanthus evergreen hybrid, white	Johannes-Ulrich Urban	spring sowing tender perennial 	\N	\N	\N
BX 463b	BULBS	23	Massonia echinata	Rimmer deVries	Mesa Gardens, SX 9	\N	\N	\N
BX 463b	BULBS	24	Massonia pustulata	Rimmer deVries	SX 9	\N	\N	\N
BX 463s	SEEDS	5	Allium amethystinum	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	7	Allium hyalinum	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	34	Calochortus superbus	Jim Barton	\N	\N	\N	\N
BX 463s	SEEDS	35	Calochortus superbus	Arcangelo Wessells	American Canyon	\N	\N	\N
BX 463s	SEEDS	36	Calochortus uniflorus	Robert Werra	\N	\N	\N	\N
BX 463s	SEEDS	37	Calochortus venustus	Jim Barton	\N	\N	\N	\N
BX 463s	SEEDS	38	Calochortus venustus, red	Jane McGary	\N	\N	\N	\N
BX 463s	SEEDS	39	Calochortus weedii	Robert Werra	\N	\N	\N	\N
BX 463s	SEEDS	40	Calochortus weedii ssp. intermedius	George Goldsmith	\N	\N	\N	\N
BX 463s	SEEDS	41	Calostemma purpureum	Chad Cox	in growth	\N	\N	\N
BX 463s	SEEDS	42	Canna flaccida	Dennis Kramb	\N	\N	\N	\N
BX 463s	SEEDS	48.1	Crinum asiaticum var. japonicum	John Barnes	First of two item number 48	\N	\N	\N
BX 463s	SEEDS	48.2	Crinum asiaticum 'Ben Ire'	James Waddick	Second of two item number 48	\N	\N	\N
BX 463s	SEEDS	49	Crinum macowanii hybr	Unknown	\N	\N	\N	\N
BX 463s	SEEDS	50	Crinum moorei	John Barnes	already germinated	\N	\N	\N
BX 463s	SEEDS	51	Cyclamen graecum	Jane McGary	\N	\N	\N	\N
BX 463s	SEEDS	54	Dichelostemma capitatum	Jim Barton	\N	\N	\N	\N
BX 463s	SEEDS	56	Dichelostemma ida-maia	Jim Barton	\N	\N	\N	\N
BX 463s	SEEDS	57	Dichelostemma multiflorum	Jim Barton	\N	\N	\N	\N
BX 463s	SEEDS	58	Dichelostemma volubile	Jim Barton	\N	\N	\N	\N
BX 463s	SEEDS	59	Ennealophys euryandrus	Unknown	\N	\N	\N	\N
BX 463s	SEEDS	60	Eucomis autumnalis	John Barnes	\N	\N	\N	\N
BX 463s	SEEDS	61	Freesia laxa, salmon	Michael Kent	open pollinated	\N	\N	\N
BX 463s	SEEDS	63	Freesia laxa blue	John Barnes	 'blue' (lavender)	\N	\N	\N
BX 463s	SEEDS	64	Fritillaria affinis	Terry Laskiewicz	wild collected Cowlitz Co WA	\N	\N	\N
BX 463s	SEEDS	65	Fritillaria affinis	Robert Werra	\N	\N	\N	\N
BX 463s	SEEDS	66	Fritillaria crassifolia ssp kurdica	Jane McGary	\N	\N	\N	\N
BX 463s	SEEDS	67	Fritillaria raddeana	Jane McGary	\N	\N	\N	\N
BX 463s	SEEDS	68	Fritillaria rhodocanakis	Jane McGary	\N	\N	\N	\N
BX 463s	SEEDS	69	Fritillaria sewerzowii	Jane McGary	\N	\N	\N	\N
BX 463s	SEEDS	70	Fritillaria stenanthera	Jane McGary	\N	\N	\N	\N
BX 463s	SEEDS	71	Fritillaria striata	Jane McGary	Tejon Ranch, Kern County, CA	\N	\N	\N
BX 463s	SEEDS	76	Habranthus robustus	Michael Kent	open pollinated	\N	\N	\N
BX 463s	SEEDS	78	Habranthus robustus	John Barnes	\N	\N	\N	\N
BX 463s	SEEDS	79	Haemanthus humilis	Mary Sue Ittner	\N	\N	\N	\N
BX 463s	SEEDS	83	Iris 'Cythe'	Jane McGary	Regeliocyclus hybr	\N	\N	\N
BX 463s	SEEDS	85	Ixia polystachya	Chad Cox	\N	\N	\N	\N
BX 463s	SEEDS	87	Leucojum aestivum	Albertus Vos	\N	\N	\N	\N
BX 463s	SEEDS	89	Lilium candidum	Albertus Vos	\N	\N	\N	\N
BX 463s	SEEDS	91	Lilium philippinense	John Barnes	\N	\N	\N	\N
BX 463s	SEEDS	92	Manfreda sp.	John Barnes	\N	\N	\N	\N
BX 463s	SEEDS	94	Mirabilis jalapa	Michael Kent	magenta	\N	\N	\N
BX 463s	SEEDS	95	Moraea aristata	Robert Werra	\N	\N	\N	\N
BX 463s	SEEDS	96	Moraea ciliata	Robert Werra	\N	\N	\N	\N
BX 463s	SEEDS	98	Moraea polyanthos	Robert Werra	\N	\N	\N	\N
BX 463s	SEEDS	99	Moraea vegeta	Robert Werra	\N	\N	\N	\N
BX 463s	SEEDS	100	Crinum asiaticum	Robert Werra	\N	\N	\N	\N
BX 463s	SEEDS	101	Moraea villosa	Robert Werra	\N	\N	\N	\N
BX 463s	SEEDS	104	Narcissus dubius	Albertus Vos	\N	\N	\N	\N
BX 463s	SEEDS	106	Narcissus tazetta hybrs	William Welch	Autumn Colors' strain	\N	\N	\N
BX 463s	SEEDS	107	Narcissus tazetta hybrs	William Welch	3N/4N' strain	\N	\N	\N
BX 463s	SEEDS	108	Nerine kriegii	Mary Sue Ittner	\N	\N	\N	\N
BX 463s	SEEDS	112	Oncostemma peruviana	John Barnes	Oncostemma (Scilla) peruviana	\N	\N	\N
BX 463s	SEEDS	103	Narcissus cordubensis	Johannes-Ulrich Urban	E-E 4-19 jonquilla type with several flowers per stems. Needs moist conditions during growth. Sow immediately.	\N	\N	\N
BX 463s	SEEDS	55	Dichelostemma capitatum	M Gastil-Buhl	\N	\N	w	\N
BX 463s	SEEDS	111	Oncostemma peruviana 'Grand Bleu'	Johannes-Ulrich Urban	Scilla peruviana ex 'Grand Bleu', from cultivated plants, magnificent deep blue form.\nSow immediately, keep green in the first summer as long as possible. May take time to flower from seed but very rewarding, beginniner’s choice.	\N	\N	\N
BX 463s	SEEDS	52	Cypella gigantea	Johannes-Ulrich Urban	spring sowing, evergreen. Tall inflorescence high above the leaves, wonderful patterned blue. Beginniner’s choice.	\N	\N	\N
BX 463s	SEEDS	105	Narcissus papyraceus	Johannes-Ulrich Urban	wild collected. wc splendid local plant, occurrs in masses in some places, first Narcissus to flower here, some people dislike the smell. Likes moist conditions in spring. sow immediately, beginniner‘s choice.	\N	\N	\N
BX 463s	SEEDS	43	Cardiodrinum giganteum	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	44	Corydalis cheilanthifolia	Rimmer deVries	not geophytic	\N	\N	\N
BX 463s	SEEDS	45	Corydalis heterocarpa japonica	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	46	Corydalis schanginii mixed subspp	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	47	Corydalis sibirica	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	120	Pancratium maritimum	Albertus Vos	\N	\N	\N	\N
BX 463s	SEEDS	121	Rhodophiala bagnoldii	Arcangelo Wessells	Chile	\N	\N	\N
BX 463s	SEEDS	128	Triteleia ixioides	Jim Barton	\N	\N	\N	\N
BX 463s	SEEDS	130	Triteleia laxa	Jim Barton	\N	\N	\N	\N
BX 463s	SEEDS	131	Triteleia lugens	Arcangelo Wessells	Napa, CA, 2018	\N	\N	\N
BX 463s	SEEDS	132	Triteleia peduncularis	Jim Barton	\N	\N	\N	\N
BX 463s	SEEDS	133	Tropaeolum brachyceras	Chad Cox	\N	\N	\N	\N
BX 463s	SEEDS	135	Tropaeaolum hookerianum var. austropurpureum	Chad Cox	\N	\N	\N	\N
BX 463s	SEEDS	137	Tulbaghia violacea	Albertus Vos	potentially invasive	\N	\N	\N
BX 463s	SEEDS	138	Tulipa vvedenskyi	Albertus Vos	\N	\N	\N	\N
BX 463s	SEEDS	141	Veltheimia bracteata	Marvin Ellenbecker	\N	\N	\N	\N
BX 463s	SEEDS	145	Zephyranthes 'Capricorn'	John Barnes	\N	\N	\N	\N
BX 463s	SEEDS	146	Zephyranthes drummondii	John Barnes	\N	\N	\N	\N
BX 463s	SEEDS	147	Zephyranthes Labuffarosea	John Barnes	\N	\N	\N	\N
BX 463s	SEEDS	149	Zephyranthes minima	Michael Kent	open pollinated	\N	\N	\N
BX 463s	SEEDS	150	Zephyranthes primulina	Michael Kent	open pollinated	\N	\N	\N
BX 463s	SEEDS	151	Zephyranthes smallii	Michael Kent	open pollinated	\N	\N	\N
BX 419	SEEDS	3	Hymenocallis phalangidis	Roy Herold	ex BX 209	\N	\N	Seed
BX 422	BULBS	14	Tritonia crocata 'Princess Beatrix'	Karl Church	\N	\N	\N	Cormlets
BX 311	BULBS	11	Cyrtanthus montanus x C. elatus	Robin Bell	\N	\N	\N	Small bulbs
BX 311	BULBS	12	Lachenalia	Robin Bell	pink ex BX 183 (#21) possible hybrid?	\N	\N	Small bulbs
BX 311	BULBS	16	Cyrtanthus hybrids	Jim Waddick	They seem close to CyrtanthusHybrids on the wiki but I have lost the label - or maybe these vigorous bulbs 'ate' the label. They are easy to grow, prolific and bloom easily. Color is bright orange red, Bulbs range from 'big blooming size' to mini starts. Mine grow in a sand based mix with irregular fertilizing and do well. 	http://www.pacificbulbsociety.org/pbswiki/index.php/CyrtanthusHybrids	\N	Bulbs
BX 327	BULBS	15	Zigadenus venosus	Richard Haard	\N	\N	\N	Bulblets
BX 327	BULBS	18	Pinellia pedatisecta	Jerry Lehmann	\N	\N	\N	Seedling tubers
BX 328	BULBS	21	Dichelostemma capitatum	Kipp McMichael	from San Francisco serpentine	\N	\N	Bulblets
BX 353	BULBS	8	Eucomis vandermerwei	Arnold Trachtenberg		\N	\N	Small bulbs
BX 353	SEEDS	12	Pancratium maritimum	Francisco Torres		\N	\N	Seed
BX 353	SEEDS	16	Manfreda undulata	Monica Swartz		\N	\N	Seed
BX 353	SEEDS	21	Brunsvigia bosmaniae	Monica Swartz		\N	\N	Seeds
BX 353	SEEDS	25	Rhodophiala bifida	Cynthia Mueller	pink	\N	\N	Seed
BX 353	SEEDS	26	Rhodophiala bifida	Cynthia Mueller	pink with star in throat	\N	\N	Seed
BX 354	BULBS	18	Hippeastrum papilio	Marvin Ellenbecker	(2 - 6 cm dia.)	\N	\N	Bulbs
BX 381	SEEDS	18	Crinum bulbispermum	Tim Eck	Jumbo strain	\N	\N	Seeds
BX 389	BULBS	24	Caliphruria subedentata	Ivor Tyndal		\N	\N	Bulbs
BX 395	BULBS	11	Unidentified	Nhu Nguyen	Grab bag various bulbs (unidentified)	\N	\N	\N
BX 404	SEEDS	23	Cyclamen graecum	Ruth Jones	\N	\N	\N	Seed
BX 412	SEEDS	24	Clivia miniata 'Belgian Strain'	Uli Urban	In the family for well over hundred years.... This is the broad leaved and large flowered form. I grow another more dainty form with narrow leaves and smaller flowers from another branch of the family.... as old. Easy but slow from seed. (FEW)	\N	\N	Seeds
BX 463s	SEEDS	114	Ornithogalum orthophyllum ssp. baeticum	Johannes-Ulrich Urban	wild collected. similar to O. umbellatum. Sow immediately	\N	\N	\N
BX 301	BULBS	3	Talinum paniculatum	Pamela Slate	small tubers	\N	\N	Small tubers
BX 463s	SEEDS	116	Orthrosanthes chimboracensis	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	117	Orthrosanthes laxus	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	118	Orthrosanthes sp.	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	119	Oxalis squamata	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	122	Sinningia eumorpha	Rimmer deVries	\N	\N	\N	\N
BX 419	BULBS	1	Brunsvigia bosmaniae	Monica Swartz	ex Telos (small bulbs from the seed I didn't send in time)	\N	\N	Seedling bulblets
BX 419	SEEDS	9	Crinum bulbispermum 'Jumbo'	Jim Waddick	Germination: Large seeds are pushed about 1/2 way into damp sand. Germination is usually fast and total. If the seed has started to germinate orient the emerging root downwards. Add a bit of soil as it burrows down. Keep in bright light. In my cold climate I protect the first year seedlings in a frost free place and then pot them into gallon pots for their 2nd year of growth. By fall they can be planted in the garden slightly deeper than they are growing in the pot. Plant in full sun. These have proven easy and both drought and flood tolerant, and extremes of heat and cold in my Zone 5/6 garden. Expect bloom in 3 or 4 years (or more) and plant will get larger, but does not pup much. Enjoy.	\N	\N	Seeds
BX 349	SEEDS	26	Tulbaghia simmleri	Nhu Nguyen	(fragrans), purple form	\N	\N	\N
BX 348	SEEDS	36	Crinum bulbispermum	Tony Avent	ex 'Jumbo Champagne'	\N	\N	\N
BX 348	SEEDS	37	Crinum bulbispermum	Tony Avent	ex Orange River form	\N	\N	\N
BX 348	SEEDS	38	Crinum bulbispermum	Tony Avent	ex 'Wow'	\N	\N	\N
BX 348	SEEDS	39	Crinum [(forbesii x macowanii) x (macowanii x acaule)]	Tony Avent	\N	\N	\N	\N
BX 348	SEEDS	40	Ammocharis coranica	Tony Avent	\N	\N	\N	\N
BX 349	SEEDS	1	Albuca albucoides	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEEDS	2	Albuca namaquensis	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEEDS	3	Allium dichlamydeum	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEEDS	4	Allium unifolium	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEEDS	5	Alstroemeria ligtu subsp. simsii	Nhu Nguyen	a lovely orange form of the subspecies. Seeds self pollinated from the same plant shown on the wiki.	http://pacificbulbsociety.org/pbswiki/index.php/Alstroemeria#ligtu	\N	\N
BX 349	SEEDS	6	Brodiaea coronaria	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEEDS	7	Brodiaea elegans	Nhu Nguyen	- a wonderful and rewarding species. It is also easy to grow, although very prone to virus infections.	\N	\N	\N
BX 349	SEEDS	8	Bulbine aff. diphylla	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEEDS	9	Calochortus luteus	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEEDS	10	Calochortus vestae	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEEDS	11	Chlorogalum pomeridianum	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEEDS	12	Cyclamen africanum	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEEDS	13	Dichelostemma multiflorum	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEEDS	14	Drimia platyphylla	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEEDS	15	Erythronium pusaterii	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEEDS	16	Iris douglasiana	Nhu Nguyen	wild collected from Marin County, California. These seeds should produce progeny with a a wide variety of colors from bright purple to lilac and almost white.	\N	\N	\N
BX 349	SEEDS	17	Ixia viridiflora var. minor	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEEDS	18	Lachenalia mathewsii	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEEDS	19	Lachenalia viridiflora	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEEDS	20	Massonia sp.	Nhu Nguyen	NNBH385, open pollinated	\N	\N	\N
BX 349	SEEDS	21	Lachenalia (Polyxena) sp.	Nhu Nguyen	NNBH1779	\N	\N	\N
BX 349	SEEDS	22	Triteleia hyacinthina	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEEDS	23	Triteleia laxa	Nhu Nguyen	mixed forms	\N	\N	\N
BX 349	SEEDS	24	Triteleia laxa	Nhu Nguyen	Tilden form	\N	\N	\N
BX 349	SEEDS	25	Tulbaghia dregeana	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEEDS	27	Umbilicus rupestris	Nhu Nguyen	- this is a really nice species, but be warned, the plants produce copious seeds and can run amok in succulent collections. Not recommended for countries/areas where invasive plants	\N	\N	\N
BX 349	SEEDS	28	Xeronema callistemon	Nhu Nguyen	\N	\N	\N	\N
BX 349	SEEDS	29	Zephyranthes sp.	Nhu Nguyen	Guatamala City, white	\N	\N	\N
BX 349	SEEDS	30	Zephyranthes sp.	Nhu Nguyen	NNBH1050	\N	\N	\N
BX 349	SEEDS	31	Amoreuxia gonzalezii	Leo Martin	\N	\N	\N	\N
BX 349	SEEDS	32	Allium peninsulare	Jane McGary	Ratko coll., rare CA sp.	\N	\N	\N
BX 349	SEEDS	33	Allium praecox	Jane McGary	Ratko coll. from CA	\N	\N	\N
BX 349	SEEDS	34	Allium scorzonerifolium subsp. xericense	Jane McGary	bright yellow	\N	\N	\N
BX 349	SEEDS	35	Alstroemeria hookeri	Jane McGary	small, low species	\N	\N	\N
BX 349	SEEDS	36	Calochortus argillosus	Jane McGary	southern form, white	\N	\N	\N
BX 349	SEEDS	37	Calochortus clavatus var. gracilis	Jane McGary	\N	\N	\N	\N
BX 349	SEEDS	38	Calochortus longebarbatus	Jane McGary	interior NW species	\N	\N	\N
BX 349	SEEDS	39	Calochortus monophyllus	Jane McGary	short, early yellow	\N	\N	\N
BX 349	SEEDS	40	Calochortus obispoensis	Jane McGary	rare endemic, curious	\N	\N	\N
BX 349	SEEDS	41	Calochortus plummerae	Jane McGary	late-blooming, rare in cult.	\N	\N	\N
BX 349	SEEDS	42	Calochortus venustus	Jane McGary	red forms from 2 populations	\N	\N	\N
BX 349	SEEDS	43	Calochortus venustus	Jane McGary	pretty pink forms	\N	\N	\N
BX 349	SEEDS	44	Camassia quamash subsp. maxima	Jane McGary	very large form sometimes called `Puget Blue'	\N	\N	\N
BX 349	SEEDS	46	Crocus oreocreticus	Jane McGary	autumnal	\N	\N	\N
BX 349	SEEDS	47	Cyclamen graecum	Jane McGary	from Greek collections	\N	\N	\N
BX 349	SEEDS	48	Fritillaria sewerzowi	Jane McGary	Central Asian, give plenty of room	\N	\N	\N
BX 349	SEEDS	49	Narcissus obvallaris	Jane McGary	Tenby daffodil of Britain	\N	\N	\N
BX 349	SEEDS	50	Sisyrinchium macrocarpum	Jane McGary	little plant with big yellow/brown fls	\N	\N	\N
BX 349	SEEDS	51	Triteleia ixioides	Jane McGary	coll. Salinas Co., CA	\N	\N	\N
BX 349	SEEDS	52	Triteleia laxa	Jane McGary	giant form from Mariposa Co. CA	\N	\N	\N
BX 349	SEEDS	53	Triteleia peduncularis	Jane McGary	striking inflorescence	\N	\N	\N
BX 349	SEEDS	54	Tropaeolum tricolor	Jane McGary	hardy strain	\N	\N	\N
BX 349	SEEDS	55	Tulipa sprengeri	Jane McGary	\N	\N	\N	\N
BX 350	SEEDS	39	Calochortus argillosus	Mike Mace	\N	\N	\N	\N
BX 350	SEEDS	40	Calochortus luteus	Mike Mace	- striations but no spot	\N	\N	\N
BX 454	BULBS	14	Remusatia vivipara	Francisco Lopez	bulbils	\N	\N	Bulbils
BX 349	SEEDS	45	Colchicum sp.	Jane McGary	SBL 412, fairly small sp.	\N	\N	\N
BX 350	SEEDS	41	Calochortus uniflorus	Mike Mace	(few seeds)	\N	\N	\N
BX 350	SEEDS	42	Calochortus weedii	Mike Mace	\N	\N	\N	\N
BX 350	SEEDS	43	Ferraria crispa	Mike Mace	maroon/olive	\N	\N	\N
BX 350	SEEDS	1	Ornithogalum muitifolium	Dylan Hannon	ex Nieuwoudtville, collected 2006. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEEDS	2	Bessera elegans	Dylan Hannon	purple, collected 2006. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEEDS	3	Cyclamen rohlfsianum	Dylan Hannon	selfed, collected 2003. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEEDS	4	Daubenya alba	Dylan Hannon	ex Sutherland, Bu Visririer, 2007. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEEDS	5	Daubenya stylosa	Dylan Hannon	collected 2004. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEEDS	6	Dipcadi serotinum	Dylan Hannon	ex Portugal:  Quinta do Lago, collected 2006. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEEDS	7	Drimia anomala	Dylan Hannon	ex Grahamstown, collected 2004. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEEDS	8	Gladiolus equitans	Dylan Hannon	ex Kamieskroon, collected 2004. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEEDS	9	Hyacinthoides vincentina	Dylan Hannon	ex Portugal:  Cabo San Vicente, collected 2006. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEEDS	10	Iris planifolia	Dylan Hannon	ex Portugal:  west of Loule, collected 2011. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEEDS	11	Lapeirousia oreogena	Dylan Hannon	ex Nieuwoudtville, collected 2006. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEEDS	44	Ferraria crispa	Mike Mace	subsp. nortieri	\N	\N	\N
BX 350	SEEDS	45	Ferraria undulata	Mike Mace	(F. crispa subsp crispa?), olive/brown	\N	\N	\N
BX 350	SEEDS	46	Geissorhiza aspera	Mike Mace	\N	\N	\N	\N
BX 350	SEEDS	12	Lapeirousia plicata	Dylan Hannon	ex Calvinia, Lavranos 30401, collected 2001. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEEDS	13	Leucocoryne vittata	Dylan Hannon	collected 2006. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEEDS	14	Massonia depressa	Dylan Hannon	ex N of Steinkopf, collected 2006. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEEDS	15	Massonia echinata	Dylan Hannon	ex Nieuwoudtville, collected 2007. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEEDS	16	Moraea ciliata	Dylan Hannon	ex Sutherland, Lavranos 30469, collected 2008. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEEDS	17	Muilla maritima	Dylan Hannon	dwarf form, ex Baja CA, road to La  Zorra, collected 2003. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEEDS	18	Ornithogalum polyphyllum	Dylan Hannon	ex Kamieskroon, collected 2006. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEEDS	19	Ornithogalum reverchonii	Dylan Hannon	ex Spain:  Grazalema, collected 2006. Dylan Hannon has donated a batch of seeds that have been in cold dry storage for a considerable amount of time. Our hope is that those of you who receive these seeds will keep a record of germination rates and share it with the rest of us via the list. Our hunch is that, when some kinds of seeds are properly stored, they may retain viability for much longer than common wisdom dictates. Most of these seeds come with provenance information and the date of collection. ONE packet which contains a generous number of seeds is available of each taxon. $2 per pkt.	\N	\N	\N
BX 350	SEEDS	21	Calochortus ambiguus	Ellen Watrous	wild-collected in Yavapai County, Arizona	\N	\N	\N
BX 350	SEEDS	22	Calochortus kennedyi	Ellen Watrous	wild-collected in Yavapai County, Arizona, mixed collection of orange and yellow pod parents.	\N	\N	\N
BX 350	SEEDS	23	Calochortus nuttallii	Ellen Watrous	wild-collected in Utah	\N	\N	\N
BX 350	SEEDS	24	Eucomis comosa	Dee Foster	various colors	\N	\N	\N
BX 350	SEEDS	25	Freesia viridis	Dee Foster	open-pollinated	\N	\N	\N
BX 350	SEEDS	26	Veltheimia  bracteata	Dee Foster	pink	\N	\N	\N
BX 350	SEEDS	27	Allium cyrilli	Angelo Porcelli	\N	\N	\N	\N
BX 350	SEEDS	28	Allium nigrum	Angelo Porcelli	\N	\N	\N	\N
BX 350	SEEDS	29	Asphodelus liburnicus	Angelo Porcelli	(Asphodeline?) liburnicus	\N	\N	\N
BX 350	SEEDS	30	Narcissus broussonetii	Angelo Porcelli	\N	\N	\N	\N
BX 350	SEEDS	31	Narcissus bertolonii	Angelo Porcelli	(N. tazetta subsp. aureus?)	\N	\N	\N
BX 350	SEEDS	32	Pancratium illyricum	Angelo Porcelli	\N	\N	\N	\N
BX 350	SEEDS	33	Sprekelia formosissima 'Orient Red'  x 'superba'	Angelo Porcelli	\N	\N	\N	\N
BX 350	SEEDS	34	Allium dichlamydeum	Mike Mace	\N	\N	\N	\N
BX 350	SEEDS	35	Allium unifolium	Mike Mace	(few seeds)	\N	\N	\N
BX 350	SEEDS	36	Babiana rubrocyanea	Mike Mace	\N	\N	\N	\N
BX 350	SEEDS	37	Bloomeria crocea	Mike Mace	\N	\N	\N	\N
BX 350	SEEDS	38	Calochortus amabilis	Mike Mace	(few seeds)	\N	\N	\N
BX 350	SEEDS	47	Geissorhiza monanthos	Mike Mace	\N	\N	\N	\N
BX 350	SEEDS	48	Gladiolus trichonemifolius	Mike Mace	\N	\N	\N	\N
BX 350	SEEDS	49	Gladiolus violaceolineatus	Mike Mace	\N	\N	\N	\N
BX 350	SEEDS	50	Moraea aristata	Mike Mace	\N	\N	\N	\N
BX 350	SEEDS	51	Moraea bellendenii	Mike Mace	\N	\N	\N	\N
BX 350	SEEDS	52	Moraea elegans	Mike Mace	orange/green/yellow	\N	\N	\N
BX 350	SEEDS	53	Moraea elegans	Mike Mace	yellow/green	\N	\N	\N
BX 350	SEEDS	54	Moraea fugax	Mike Mace	yellow	\N	\N	\N
BX 350	SEEDS	55	Moraea loubseri	Mike Mace	\N	\N	\N	\N
BX 350	SEEDS	56	Moraea lurida	Mike Mace	(pale yellow/maroon)	\N	\N	\N
BX 350	SEEDS	57	Moraea macrocarpa	Mike Mace	\N	\N	\N	\N
BX 350	SEEDS	58	Moraea polyanthos	Mike Mace	\N	\N	\N	\N
BX 350	SEEDS	59	Moraea tripetala	Mike Mace	\N	\N	\N	\N
BX 350	SEEDS	60	Moraea tulbaghensis	Mike Mace	(tulbaghensis form, with dark orange tepals/dark gray eye)	\N	\N	\N
BX 350	SEEDS	61	Moraea villosa 'A'	Mike Mace	form A	\N	\N	\N
BX 350	SEEDS	62	Moraea villosa 'B'	Mike Mace	form B	\N	\N	\N
BX 350	SEEDS	63	Moraea villosa	Mike Mace	mixed colors	\N	\N	\N
BX 350	SEEDS	64	Onixotis triquetra	Mike Mace	(Wurmbea stricta?)	\N	\N	\N
BX 350	SEEDS	65	Romulea camerooniana	Mike Mace	pink	\N	\N	\N
BX 350	SEEDS	66	Romulea camerooniana	Mike Mace	white	\N	\N	\N
BX 350	SEEDS	67	Romulea eximia	Mike Mace	\N	\N	\N	\N
BX 350	SEEDS	68	Romulea tabularis	Mike Mace	\N	\N	\N	\N
BX 350	SEEDS	69	Sprarxis metelerkampiae	Mike Mace	\N	\N	\N	\N
BX 350	SEEDS	70	Alstromeria sp.	Dylan Hannon	sp?, magenta, 2013	\N	\N	\N
BX 350	SEEDS	71	Albuca concordiana	Dylan Hannon	(Ornithogalum), 2013	\N	\N	\N
BX 447	SEEDS	5	Nerine krigei	Mary Sue Ittner	seed	\N	\N	\N
BX 447	SEEDS	11	Veltheimia bracteata	Mary Sue Ittner	seed - OP, from forms with yellow and red flowers (see wiki)	\N	\N	\N
BX 348	SEEDS	34	Crinum macowanii	Tony Avent	ex Zambia	\N	\N	\N
BX 312	BULBS	1	Crinum x 'Menehune'	Joe Gray of Hines Horticultural	Growing plants of Crinum x 'Menehune'. This is a mostly aquatic crinum that... 17 small bulbs (1 - 1.5 cm diameter)	\N	\N	Small bulbs
BX 312	BULBS	2	Crinum x 'Menehune'	Joe Gray of Hines Horticultural	Growing plants of Crinum x 'Menehune'. This is a mostly aquatic crinum that... 3 large bulbs (3 - 4 cm diameter) with offsets	\N	\N	Large bulbs
BX 357	BULBS	1	Achimenes pedunculata	Uli Urban	aerial bulbili summer growing winter dormant Gesneriad, upright plant to 1m tall, lots of small orange-red flowers, needs good light	\N	\N	Aerial bulbils
BX 463s	BULBS	97	Moraea macronyx	Robert Werra	cormlets	\N	\N	Cormlets
BX 330	BULBS	7	Moraea ciliata	Bob Werra	(CORMLETS)	\N	\N	Cormlets
BX 454	BULBS	5	Pamianthe peruviana	Rimmer deVries	offset	\N	\N	Offset
BX 411	BULBS	3	Ornithogalum caudatum	Rimmer deVries	- aka False sea onion or pregnant onion. (Albuca bracteata?) offsets and bulbils. these bulblets will form a 2-3 inches dia surface mounted bulbs in a year or 2 and send up a 24 inch flower stalk of small whitish flowers in winter. keep moist while in growth, never full dormant but less water in summer.	\N	\N	Offsets and bulbils
BX 358	SEEDS	31	Hippeastrum (H. neopardinum x H. papilio) x (H. cybister x H. papilio) F2	Tim Eck	 (H. neopardinum x H. papilio) x (H. cybister x H. papilio) F2; cv ‘Jade Dragon’ (one parent was 7 ½ ” and the other 8”).	\N	\N	\N
BX 366	BULBS	1	Albuca acuminata	Roy Herold	Plettenberg Bay small offsets	\N	\N	\N
BX 366	BULBS	3	Ambrosina bassii	Roy Herold		\N	\N	\N
BX 366	BULBS	4	Daubenya marginata	Roy Herold	Fransplaas MX21, small seedlings	\N	\N	\N
BX 366	BULBS	5	Daubenya stylosa	Roy Herold	MX20, small seedlings	\N	\N	\N
BX 366	BULBS	6	Lachenalia pusilla	Roy Herold	ex Hannon, small seedlings	\N	\N	\N
BX 366	BULBS	7	Massonia depressa	Roy Herold	Carolusberg Mine M49. The following Massonias are from my 2011 seed collections in South Africa. These are one to two years old seedlings, some very small, and in very limited quantities.	\N	\N	\N
BX 366	BULBS	8	Massonia depressa	Roy Herold	Kamieskroon Church M57. The following Massonias are from my 2011 seed collections in South Africa. These are one to two years old seedlings, some very small, and in very limited quantities.	\N	\N	\N
BX 366	BULBS	9	Massonia depressa	Roy Herold	large Modderfontein M51. The following Massonias are from my 2011 seed collections in South Africa. These are one to two years old seedlings, some very small, and in very limited quantities.	\N	\N	\N
BX 366	BULBS	10	Massonia depressa	Roy Herold	near Kamieskroon Hotel M56. The following Massonias are from my 2011 seed collections in South Africa. These are one to two years old seedlings, some very small, and in very limited quantities.	\N	\N	\N
BX 366	BULBS	11	Massonia depressa	Roy Herold	Nieuwoudtville waterfall, reddest M48. The following Massonias are from my 2011 seed collections in South Africa. These are one to two years old seedlings, some very small, and in very limited quantities.	\N	\N	\N
BX 366	BULBS	12	Massonia depressa	Roy Herold	small Modderfontein M53. The following Massonias are from my 2011 seed collections in South Africa. These are one to two years old seedlings, some very small, and in very limited quantities.	\N	\N	\N
BX 366	BULBS	13	Massonia pygmaea	Roy Herold	5km S Elands Bay M59. The following Massonias are from my 2011 seed collections in South Africa. These are one to two years old seedlings, some very small, and in very limited quantities.	\N	\N	\N
BX 366	BULBS	14	Massonia pygmaea	Roy Herold	Modderfontein renosterveld M54. The following Massonias are from my 2011 seed collections in South Africa. These are one to two years old seedlings, some very small, and in very limited quantities.	\N	\N	\N
BX 366	BULBS	15	Massonia pygmaea	Roy Herold	Modderfontein wet pasture M55. The following Massonias are from my 2011 seed collections in South Africa. These are one to two years old seedlings, some very small, and in very limited quantities.	\N	\N	\N
BX 366	BULBS	16	Massonia echinata	Roy Herold	Napier ex McMaster. These Massonias are also small seedlings.	\N	\N	\N
BX 366	BULBS	17	Massonia hirsuta	Roy Herold	MG2712. These Massonias are also small seedlings.	\N	\N	\N
BX 366	BULBS	18	Massonia jasminiflora	Roy Herold	Modder River. These Massonias are also small seedlings.	\N	\N	\N
BX 366	BULBS	19	Massonia jasminiflora	Roy Herold	Smithfield. These Massonias are also small seedlings.	\N	\N	\N
BX 366	BULBS	20	Massonia pustulata	Roy Herold	very pustulate parents M41 ex Cumbleton. These Massonias are also small seedlings.	\N	\N	\N
BX 366	BULBS	21	Oxalis bowiei	Roy Herold		\N	\N	\N
BX 366	BULBS	22	Oxalis luteola	Roy Herold	MV5567	\N	\N	\N
BX 366	BULBS	23	Oxalis melanosticta 'Ken Aslet'	Roy Herold		\N	\N	\N
BX 366	BULBS	24	Oxalis obtusa 'Heirloom Pink'	Roy Herold	best bloomer	\N	\N	\N
BX 366	BULBS	25	Oxalis palmifrons	Roy Herold		\N	\N	\N
BX 366	BULBS	26	Oxalis 'perdicaria var malacoides'	Roy Herold	ex BX183-13	\N	\N	\N
BX 366	BULBS	27	Oxalis 'polyphylla heptaphylla'	Roy Herold		\N	\N	\N
BX 366	BULBS	30	Polyxena ensifolia	Roy Herold	blooming size. Polyxenas are small seedlings unless noted. [NOTE: most Polyxenas are currently considered to be Lachenalias]	\N	\N	\N
BX 366	BULBS	31	Polyxena longituba	Roy Herold	Polyxenas are small seedlings unless noted. [NOTE: most Polyxenas are currently considered to be Lachenalias]	\N	\N	\N
BX 366	BULBS	32	Polyxena maughanii	Roy Herold	Silverhill. Polyxenas are small seedlings unless noted. [NOTE: most Polyxenas are currently considered to be Lachenalias]	\N	\N	\N
BX 366	BULBS	33	Polyxena odorata	Roy Herold	(Lachenalia ensifolia) Polyxenas are small seedlings unless noted. [NOTE: most Polyxenas are currently considered to be Lachenalias]	\N	\N	\N
BX 357	SEEDS	16	Tropaeolum pentaphyllum subsp. megapetalum	Uli Urban	The summer growing and winter dormant version of T. pentaphyllum, Has two relatively large bright red ears. Difficult and slow to germinate, sometimes germinating very easily. Forms very large sausage shaped tubers, strictly winter dormant. Very vigorous climber. Bolivia	\N	\N	\N
BX 459	SEEDS	19	Clivia robusta	Mary Sue Ittner	seeds	\N	\N	\N
BX 319	BULBS	4	Albuca sp.	Roy Herold	Paardepoort, north of Herold. Wild collected seed	\N	\N	\N
BX 319	BULBS	5	Albuca sp.	Roy Herold	De Rust. Wild collected seed	\N	\N	\N
BX 319	BULBS	6	Albuca sp.	Roy Herold	Volmoed, southwest of Oudtshoorn, only a couple. Wild collected seed	\N	\N	\N
BX 319	BULBS	7	Albuca sp.	Roy Herold	Uniondale, 1 or 2 flowers per scape. Wild collected seed	\N	\N	\N
BX 324	BULBS	15	Babiana sp.	Kathleen Sayce	? Small corms	\N	\N	\N
BX 343	SEEDS	7	Albuca sp.	Leo Martin	? yellow and green	\N	\N	\N
BX 344	BULBS	25	Oxalis sp.	Mike Mace	probably O. hirta, pink	\N	\N	\N
BX 448	BULBS	39	Calochortus sp.	Kipp McMichael	(vestae?) collected Napa County. Different listings of the same species from the same location represent collections in different years. A data spreadsheet with Kipp's ID numbers (with associated years) will accompany all orders.	\N	\N	\N
BX 366	BULBS	2	Albuca sp.	Roy Herold	. Silverhill 14088, small seedlings	\N	\N	\N
BX 366	BULBS	28	Oxalis sp.	Roy Herold	. Uli69	\N	\N	\N
BX 346	BULBS	14	Drimia sp.	Roy Herold	(formerly Rhadamanthus)--ex Tom Glavich, BX214-19. This is indeed quite different from D. platyphylla, although the leaves are similar. The bulbs are two to three times the size of platyphylla, it emerges a month sooner (in full leaf now), and it has the curious habit of forming little bulbils at the soil surface at the top of the bulb neck. It has yet to bloom for me. Only a few.	\N	\N	\N
BX 357	SEEDS	5	Albuca sp.	Uli Urban	.;? tall white inflorescence, evergreen tidy foliage, very lush plant. bought as a very small offset in a California rare plant fair, 1,5m tall.	\N	\N	\N
BX 364	BULBS	13	Oxalis sp.	Mary Sue Ittner	. MV 4674 (perhaps O. commutata?)	\N	\N	\N
BX 369	BULBS	17	Ornothogalum sp.	Roy Herold	., short, ex McGary (FEW)	\N	\N	\N
BX 370	BULBS	7	Ferraria sp.	Tom Glavich from the collection of the late Charles Hardman	. ex Michael Vassar 55 km north of Port Nolloti? in pure white sand in full sun, sand dune near ocean; 60 cm long lvs; corms grow very deep. small corms	\N	\N	\N
BX 372	BULBS	7	Albuca sp.	Monica Swartz	. Plettenberg Bay ex BX 178 ex Roy Herold who wrote the following: 'from seed collected in November, 2006 from a plant growing in pure sand at the edge of the beach, perhaps 50 meters from the high waterline. This plant had gone dormant, and only the scape and seed pods remained, approximately 20-30cm high. Seedlings grew strongly through last summer and winter, and went dormant in May, stretching to go deeply into the pot.'	\N	\N	Bulbs
BX 372	BULBS	9	Ferraria sp.	Mary Sue Ittner	? Corms	\N	\N	Corms
BX 372	BULBS	17	Watsonia sp.	Francisco Lopez	?	\N	\N	Small corms
BX 374	BULBS	6	Camassia sp.	Joyce Miller	? Various sized bulbs	\N	\N	\N
BX 374	SEEDS	7	Scadoxus sp.	Uli Urban	? My Scadoxus plant came from a plant sale in a Botanical Garden in Germany where they had an old plant of amazing size in a very large tub, this plant was full of spent flowers and must have looked magnificent when it was in flower. Unfortunately there was no name on the plant. They said the seedlings they were selling came from this plant. It flowered for the very first time last year, I handpollinated the flowers and got a handful of berries. It could be the old Hybrid 'King Albert'	\N	\N	Seeds
BX 386	BULBS	23	Gethyllis sp.	Arcangelo Wessells	.?, ex Silverhill	\N	\N	Small bulbs
BX 388	BULBS	6	Geissorhiza sp.	Mary Sue Ittner	. (probably Geissorhiza inaequalis or G. heterostyla (G. rosea) or both))	\N	\N	\N
BX 390	SEEDS	16	Moraea sp.	Bob Werra	.?, large orange	\N	w	\N
BX 391	SEEDS	27	Calochortus sp.	Kipp McMichael	.?, maybe simulans, Hi Mtn. Rd.	\N	\N	\N
BX 392	BULBS	9	Gladiolus sp.	Mike Mace	. MM 00-00a (very nice mottled magenta and yellow flowers)	http://growingcoolplants.blogspot.com/	\N	\N
BX 392	BULBS	10	Gladiolus sp.	Mike Mace	. MM 00-00d (similar to 00-00a, but less mottling)	http://growingcoolplants.blogspot.com/	\N	\N
BX 392	BULBS	17	Moraea sp.	Mike Mace	. MM 03-04a	http://growingcoolplants.blogspot.com/	\N	\N
BX 392	BULBS	18	Moraea sp.	Mike Mace	. MM 03-04b	http://growingcoolplants.blogspot.com/	\N	\N
BX 392	BULBS	19	Moraea sp.	Mike Mace	. MM 03-07a	http://growingcoolplants.blogspot.com/	\N	\N
BX 392	BULBS	20	Moraea sp.	Mike Mace	. MM 03-07b	http://growingcoolplants.blogspot.com/	\N	\N
BX 392	BULBS	21	Moraea sp.	Mike Mace	. MM 03-98b	http://growingcoolplants.blogspot.com/	\N	\N
BX 392	BULBS	22	Moraea sp.	Mike Mace	. MM 03-98c	http://growingcoolplants.blogspot.com/	\N	\N
BX 392	BULBS	23	Moraea sp.	Mike Mace	. MM 03-98d	http://growingcoolplants.blogspot.com/	\N	\N
BX 392	BULBS	24	Moraea sp.	Mike Mace	. 03-99a	http://growingcoolplants.blogspot.com/	\N	\N
BX 392	BULBS	25	Moraea sp.	Mike Mace	. MM 09-01	http://growingcoolplants.blogspot.com/	\N	\N
BX 392	BULBS	26	Moraea sp.	Mike Mace	. MM 09-04	http://growingcoolplants.blogspot.com/	\N	\N
BX 393	BULBS	1	Moraea sp.	Mike Mace	. MM 10-04a	http://growingcoolplants.blogspot.com/	\N	\N
BX 393	BULBS	2	Moraea sp.	Mike Mace	. MM 10-25	http://growingcoolplants.blogspot.com/	\N	\N
BX 393	BULBS	3	Moraea sp.	Mike Mace	. MM 11-19	http://growingcoolplants.blogspot.com/	\N	\N
BX 393	BULBS	4	Moraea sp.	Mike Mace	. MM 11-20	http://growingcoolplants.blogspot.com/	\N	\N
BX 393	BULBS	5	Moraea sp.	Mike Mace	. MM 99-00	http://growingcoolplants.blogspot.com/	\N	\N
BX 394	SEEDS	9	Albuca sp.	Uli Urban	.: tall white inflorescence, large fleshy green bulbs above soil level, evergreen with attractive shiny green leaves, spring flowering.	\N	\N	\N
BX 396	BULBS	8	Zephyranthes sp.	Fred Biasella	.?, possibly Z. candida; white flowers, grasslike foliage; offsets like mad!	\N	\N	Small bulbs
BX 397	BULBS	4	Oxalis sp.	Mary Sue Ittner	. L 96/42- summer growing from Mexico, Plant now in northern hemisphere. See wiki for photos:	http://www.pacificbulbsociety.org/pbswiki/index.php/MiscellaneousOxalis#sp	s	\N
BX 397	BULBS	14	Oxalis sp.	Mary Sue Ittner	. MV4674 (commutata?) - Winter growing: plant late summer northern hemisphere	\N	w	\N
BX 406	BULBS	22	Narcissus sp.	Roy Herold	w/c Oukaimeden N086	\N	\N	\N
BX 448	BULBS	36	Calochortus sp.	Kipp McMichael	(luteus?) collected Eldorado County	\N	\N	\N
BX 448	BULBS	37	Calochortus sp.	Kipp McMichael	(simulans?) collected San Luis Obispo County	\N	\N	\N
BX 448	BULBS	38	Calochortus sp.	Kipp McMichael	(splendens?) collected San Benito County	\N	\N	\N
BX 448	BULBS	40	Calochortus sp.	Kipp McMichael	(vestae?) collected Lake County	\N	\N	\N
BX 320	SEEDS	6	Zigadenus nuttallii	Jerry Lehmann	ex Riley County, Kansas	\N	\N	\N
BX 372	BULBS	11	Eucharis sp.	Rimmer deVries	? , only one bulb	\N	\N	\N
BX 448	BULBS	41	Calochortus sp.	Kipp McMichael	(vestae?) collected Napa County. Different listings of the same species from the same location represent collections in different years. A data spreadsheet with Kipp's ID numbers (with associated years) will accompany all orders.	\N	\N	\N
BX 366	BULBS	29	Oxalis sp.	Roy Herold	. Sutherland ex Hannon, like Ken Aslet with larger flowers	\N	\N	\N
BX 366	BULBS	34	Polyxena sp.	Roy Herold	. Silverhill 4748. Polyxenas are small seedlings unless noted. [NOTE: most Polyxenas are currently considered to be Lachenalias]	\N	\N	\N
BX 308	SEEDS	1	Massonia depressa	Sophie Dixon	\N	\N	\N	\N
BX 308	SEEDS	2	Clivia miniata, yellow hybrids	Peter Taggart	\N	\N	\N	\N
BX 308	SEEDS	3	Fritillaria pallida	Peter Taggart	\N	\N	\N	\N
BX 308	SEEDS	4	Fritillaria sewerzowi	Peter Taggart	\N	\N	\N	\N
BX 308	SEEDS	5	Iris magnifica	Peter Taggart	ex Agalik	\N	\N	\N
BX 308	SEEDS	6	Iris Pacific Coast hybrids	Peter Taggart	\N	\N	\N	\N
BX 308	SEEDS	7	Corydalis	Peter Taggart	Leontocoides section, probably C. popovii or else mixed hybrids including genes from popovii, maracandica, and ledbouriana. Fresh seed which should be sown as quickly as possible	\N	\N	\N
BX 308	SEEDS	8	Tulipa binutans	Peter Taggart	(OP) ex Ruksans	\N	\N	\N
BX 308	SEEDS	9	Tulipa ferghanica	Peter Taggart	? (OP)	\N	\N	\N
BX 308	SEEDS	10	Tulipa biebersteiniana	Peter Taggart	(OP)	\N	\N	\N
BX 308	SEEDS	11	Tulipa turkestanica	Peter Taggart	(OP)	\N	\N	\N
BX 308	SEEDS	12	Tulipa kolpakowskiana	Peter Taggart	(OP)	\N	\N	\N
BX 308	SEEDS	13	Tulipa sprengeri	Peter Taggart	(OP), goes very deep and will grow on acid sand	\N	\N	\N
BX 308	SEEDS	14	Tulipa vvedenskyi	Peter Taggart	(OP)	\N	\N	\N
BX 308	SEEDS	15	Tulipa vvedenskyi	Peter Taggart	(OP) large form	\N	\N	\N
BX 308	SEEDS	16	Paeonia mascula	Peter Taggart	?	\N	\N	\N
BX 308	BULBS	17	Nothoscordum bivalve	Peter Taggart	BULBILS	\N	\N	\N
BX 308	BULBS	18	Triteleia hyacinthina	Peter Taggart	BULBILS	\N	\N	\N
BX 308	BULBS	20	Achimenes ‘Pink Cloud’	Lynn Makela	\N	\N	\N	\N
BX 308	BULBS	21	Eucodonia verticillata	Lynn Makela	\N	\N	\N	\N
BX 308	BULBS	22	Sinningia amambayensis	Lynn Makela	\N	\N	\N	\N
BX 308	BULBS	23	Crinum `menehume'	Lynn Makela	(C. oliganthum x C. procerum)? 2', red leaves, pink flowers, Z 8b. "I grow it in full sun with average water. A very nice plant that can be grown in bog conditions" FEW	\N	\N	\N
BX 308	BULBS	24	Hippeastrum 'San Antonio Rose'	Lynn Makela	\N	\N	\N	\N
BX 308	BULBS	25	Nothoscordum felippenei	Lynn Makela	\N	\N	\N	\N
BX 308	BULBS	26	Onixotis stricta	Lynn Makela	\N	\N	\N	\N
BX 308	BULBS	27	Oxalis goniorhiza	Lynn Makela	VERY FEW	\N	\N	\N
BX 309	BULBS	1	Drimiopsis maculata	Roy Herold	Offsets and near-blooming size.	\N	\N	\N
BX 309	BULBS	2	Drimiopsis kirkii	Roy Herold	Offsets and near-blooming size.	\N	\N	\N
BX 309	SEEDS	3	Eucomis zambesiaca	Roy Herold	outside chance some are crossed with E. vandermervii.	\N	\N	\N
BX 309	SEEDS	4	Ophiopogon umbraticola	Roy Herold	received as O. chingii, new ID by Mark McDonough. Berries have been left uncleaned so you can admire the iridescent blue color. Clean before planting.	\N	\N	\N
BX 309	SEEDS	5	Clivia 'Anna's Yellow'	Roy Herold	OP; from the magnificent garden of my wife's aunt in Hilton, KZN.	\N	\N	\N
BX 309	BULBS	6	Clivia 'Shortleaf Yellow x Shortleaf Yellow' OP	Roy Herold	OP; from seedlings grown from Nakamura seed by Matt Mattus and Joe Philip.	\N	\N	\N
BX 309	BULBS	7	Clivia 'Monk x Daruma' OP	Roy Herold	OP; from seedlings grown from Nakamura seed by Matt Mattus and Joe Philip.	\N	\N	\N
BX 309	BULBS	8	Clivia 'Multipetal x Self'	Roy Herold	OP--this one tends to throw interesting crested offsets. from seedlings grown from Nakamura seed by Matt Mattus and Joe Philip.	\N	\N	\N
BX 309	SEEDS	11	Brachylaena discolor	Roland de Boer	(only one order of each)	\N	\N	\N
BX 309	SEEDS	12	Dietes butcheriana	Roland de Boer	(only one order of each)	\N	\N	\N
BX 309	SEEDS	14	Kniphofia uvaria	Roland de Boer	(only one order of each)	\N	\N	\N
BX 309	SEEDS	15	Monopsis lutea	Roland de Boer	(only one order of each)	\N	\N	\N
BX 309	SEEDS	16	Polyxena ensifolia var ensifolia	Roland de Boer	(only one order of each)	\N	\N	\N
BX 309	SEEDS	17	Gentiana flavida	Roland de Boer	(more than one order available)	\N	\N	\N
BX 309	SEEDS	18	Aeonium hierrense	Roland de Boer	(more than one order available)	\N	\N	\N
BX 309	SEEDS	19	Colchicum corsicum ?	Roland de Boer	(more than one order available)	\N	\N	\N
BX 309	SEEDS	21	Polygonatum alte-lobatum	Roland de Boer	(more than one order available)	\N	\N	\N
BX 310	SEEDS	1	Hippeastrum striatum	Jim Jones	\N	\N	\N	\N
BX 310	SEEDS	2	Narcissus 'Nylon'	Jim Jones	\N	\N	\N	\N
BX 310	SEEDS	3	Hippeastrum papilio	Marvin Ellenbecker	\N	\N	\N	\N
BX 310	SEEDS	4	Gladiolus dalenii	Jonathan Lubar	\N	\N	\N	\N
BX 310	SEEDS	5	Freesia laxa, blue	Jonathan Lubar	\N	\N	\N	\N
BX 310	BULBS	6	Oxalis hirta	Jonathan Lubar	\N	\N	\N	\N
BX 310	BULBS	7	Neomarica gracilis	Dell Sherk	\N	\N	\N	\N
BX 310	BULBS	8	Agapanthus	Fred Biasella	light blue, dwarf form	\N	\N	\N
BX 310	BULBS	9	Hymenocallis	Fred Biasella	Small bulbs of Hymenocallis (Ismene), fragrant white flowers, "Peruvian daffodil"	\N	\N	\N
BX 310	BULBS	10	Eucomis comosa	Fred Biasella	white/green flowers, coconut fragrance	\N	\N	\N
BX 310	BULBS	11	Cyranthus mackenii	Fred Biasella	Small bulbs, yellow	\N	\N	\N
BX 320	BULBS	4	Arisaema draconitum 'Green Dragon'	Jerry Lehmann	Seedling tubers. Collected seed "cluster" fall of 2 from habitat. Placed in protected location on soilsurface at my house over winter, cleaned and separated seeds and immediately sowed at the end of March 2011.	\N	\N	\N
BX 308	BULBS	19	Achimenes grandiflora 'Robert Dressler'	Lynn Makela	\N	\N	\N	\N
BX 309	SEEDS	10	Bomarea sp. 	Max Withers	(acutifolia?) ex Nhu Nguyen OP, probably selfed	\N	\N	Seed
BX 309	SEEDS	13	Eucomis mixed spp	Roland de Boer	(only one order of each)	\N	\N	\N
BX 320	SEEDS	7	Hippeastrum stylosum	Stephen Putman	\N	\N	\N	\N
BX 320	SEEDS	8	Allium 'Globemaster'	Phil Andrews	and similar white alliums. Both have identical leaf forms and flower stalk heights, so they go well together. I don't know if they come true from seed yet.	\N	\N	\N
BX 320	SEEDS	9	Arum purpureospathum	Mary Sue Ittner	\N	\N	\N	\N
BX 320	SEEDS	10	Cyrtanthus mackenii	Mary Sue Ittner	not sure which color form	\N	\N	\N
BX 320	SEEDS	11	Manfreda erubescens	Shawn Pollard	I got the seeds for my plants from the BX years ago and this is the most beautiful and successful of the Manfredas inmy Yuma garden.	\N	\N	\N
BX 320	SEEDS	12	Nyctaginia capitata	Shawn Pollard	This tuberous-rooted ground cover (scarletmuskflower or ramillete del diablo) from West Texas doesn't mind Yuma'ssummer heat one bit. Yes, the flowers are musky, like a carob.	\N	\N	\N
BX 320	SEEDS	13	Amoreuxia palmatifida	Shawn Pollard	(Mexican yellowshow).	\N	\N	\N
BX 320	SEEDS	14	Amoreuxia gonzalezii	Shawn Pollard	(Santa Rita yellowshow).	\N	\N	\N
BX 320	SEEDS	15	Ascelpias albicans	Shawn Pollard	A stem-succulent relative of the tuberous milkweeds, this is a hard-core xerophyte with no frost tolerance that grows on rocky slopes from where all cold air drains away in winter. Tarantula hawks love the flowers	\N	\N	\N
BX 320	SEEDS	16	Bowiea volubilis	Shirley Meneice	\N	\N	\N	\N
BX 320	SEEDS	17	Anomatheca laxa, red	Shirley Meneice	that is a Lapeirousia or some other Irid now	\N	\N	\N
BX 320	SEEDS	18	Hymenocallis astrostephana	Dave Boucher	\N	\N	\N	\N
BX 320	SEEDS	19	Lilium formosanum	Steven Hart	\N	\N	\N	\N
BX 320	SEEDS	20	Habranthus robustus	Steven Hart	\N	\N	\N	\N
BX 320	SEEDS	21	Veltheimia bracteata	Richard Hart	\N	\N	w	\N
BX 320	SEEDS	22	Datura sp. "Moonflower"	Richard Hart	\N	\N	\N	\N
BX 320	SEEDS	30	Pucara leucantha	Dell Sherk	(few)	\N	\N	\N
BX 320	SEEDS	31	Cyrtanthus	Dell Sherk	\N	\N	\N	\N
BX 320	SEEDS	32	Lewisia brachycalyx	Nhu Nguyen	OP, W, no other species blooming at the same time, probably pure	\N	\N	\N
BX 320	SEEDS	33	Lapeirousia corymbosa	Nhu Nguyen	OP, W, although no other Lapeirousia blooming at the same time, probably pure	\N	\N	\N
BX 320	SEEDS	34	Babiana ringens	Nhu Nguyen	OP, W, nice red form	\N	\N	\N
BX 320	SEEDS	35	Calochortus luteus NNBH69.1	Nhu Nguyen	OP, W	\N	\N	\N
BX 320	SEEDS	36	Calochortus luteus NNBH2	Nhu Nguyen	OP, W, collected from a native patch in a friend's yard in the foothills of the Sierra Nevada. These are supposed to have nice brown markings. I have some extra so I'm sharing them.	\N	\N	\N
BX 320	SEEDS	37	Solenomelus pedunculatus	Nhu Nguyen	OP, W, probably pure since no other irids were blooming at the same time.	\N	\N	\N
BX 320	SEEDS	38	Allium unifolium	Nhu Nguyen	OP, W.	\N	\N	\N
BX 320	SEEDS	39	Tulbaghia acutiloba	Nhu Nguyen	cross pollinated between two forms, S	\N	\N	\N
BX 320	SEEDS	40	Herbertia lahue	Nhu Nguyen	OP, S	\N	\N	\N
BX 320	SEEDS	41	Impatiens gomphophylla	Nhu Nguyen	OP, S, winter dormant, tuberous. High chance of hybridization with other impatiens species.	\N	\N	\N
BX 332	SEEDS	4	Erythronium elegans	Kathleen Sayce	wild collected Mt Hebo, Tillamook County, Oregon	\N	\N	\N
BX 330	SEEDS	1	Calochortus amabilis	Bob Werra	Bob says, It's not too late to plant winter rainfall species.	\N	\N	\N
BX 330	SEEDS	3	Fritillaria affinis	Bob Werra	ex Ukiah, CA	\N	\N	\N
BX 330	SEEDS	4	Fritillaria liliaceae	Bob Werra	\N	\N	\N	\N
BX 330	SEEDS	5	Gladiolus huttonii	Bob Werra	\N	\N	\N	\N
BX 330	SEEDS	6	Gladiolus priori	Bob Werra	\N	\N	\N	\N
BX 330	SEEDS	8	Moraea ciliate	Bob Werra	\N	\N	\N	\N
BX 330	SEEDS	9	Moraea elegans	Bob Werra	\N	\N	\N	\N
BX 330	SEEDS	10	Moraea graminicola	Bob Werra	ex Eastern Cape, RSA	\N	\N	\N
BX 330	SEEDS	11	Moraea pendula	Bob Werra	\N	\N	\N	\N
BX 330	SEEDS	12	Moraea polyanthus	Bob Werra	\N	\N	\N	\N
BX 330	SEEDS	13	Moraea polystachya	Bob Werra	\N	\N	\N	\N
BX 330	SEEDS	14	Moraea vegeta	Bob Werra	\N	\N	\N	\N
BX 330	SEEDS	15	Moraea vespertina	Bob Werra	\N	\N	\N	\N
BX 330	SEEDS	16	Moraea villosa	Bob Werra	\N	\N	\N	\N
BX 330	SEEDS	17	Rhodophiala	Bob Werra	pink	\N	\N	\N
BX 330	SEEDS	18	Rhodophiala	Bob Werra	dark maroon	\N	\N	\N
BX 330	SEEDS	19	Sandersonia aurantiaca	Bob Werra	\N	\N	\N	\N
BX 330	SEEDS	20	Crotolaria capensis	Roland de Boer	\N	\N	\N	\N
BX 330	SEEDS	21	Cyclamen hederifolium	Roland de Boer	mixed pink forms	\N	\N	\N
BX 330	SEEDS	22	Galtonia viridiflora	Roland de Boer	tall form	\N	\N	\N
BX 330	SEEDS	23	Kochia scoparia	Roland de Boer	\N	\N	\N	\N
BX 330	SEEDS	24	Leucocoryne purpurea	Roland de Boer	\N	\N	\N	\N
BX 330	SEEDS	25	Malcomia maritima	Roland de Boer	\N	\N	\N	\N
BX 330	SEEDS	26	Massonia echinata	Roland de Boer	\N	\N	\N	\N
BX 330	SEEDS	27	Massonia pustulata	Roland de Boer	\N	\N	\N	\N
BX 330	SEEDS	28	Paradisia lusitanicum	Roland de Boer	\N	\N	\N	\N
BX 330	SEEDS	29	Eucomis comosa	Dee Foster	green/white	\N	\N	\N
BX 330	SEEDS	30	Eucomis comosa	Dee Foster	mixed colors, mostly pink	\N	\N	\N
BX 330	SEEDS	31	Eucomis cv	Dee Foster	dwarf purple flower, green foliage	\N	\N	\N
BX 330	SEEDS	32	Gloriosa superba	Dee Foster	(rotschildiana)	\N	\N	\N
BX 330	SEEDS	33	Veltheimia bracteata	Dee Foster	pink	\N	\N	\N
BX 330	SEEDS	34	Mirabilis jalapa	Dee Foster	Four O'clocks, magenta	\N	\N	\N
BX 330	SEEDS	35	Amaryllis belladonna	Mary Sue Ittner	OP	\N	winter growing	\N
BX 330	SEEDS	36	Cyrtanthus elatus x montanus	Mary Sue Ittner	(all OP)	\N	evergreen	\N
BX 330	BULBS	37	Cyrtanthus elatus x montanus	Mary Sue Ittner	Bulblets	\N	evergreen	\N
BX 330	SEEDS	38	Eucomis bicolor	Mary Sue Ittner	(all OP)	\N	summer growing	\N
BX 330	SEEDS	39	Nerine bowdenii	Mary Sue Ittner	confused about when it should grow (all OP)	\N	\N	\N
BX 330	SEEDS	40	Nerine sarninesis hybrid	Mary Sue Ittner	(had red flowers) (all OP)	\N	w	\N
BX 330	SEEDS	41	Nerine sarniensis hybrid	Mary Sue Ittner	(seed from rescue bulb) (all OP)	\N	w	\N
BX 330	SEEDS	42	Polianthes geminiflora	Mary Sue Ittner	(all OP)	\N	s	\N
BX 331	SEEDS	1	Dracunculus vulgaris	Richard Hart	\N	\N	\N	\N
BX 331	SEEDS	2	Haemanthus albiflos	Richard Hart	\N	\N	\N	\N
BX 331	SEEDS	3	Tigridia pavonia, yellow	Richard Hart	\N	\N	\N	\N
BX 331	SEEDS	4	Dietes grandiflora	Guy L'Eplattenier	\N	\N	\N	\N
BX 331	SEEDS	5	Lapiedra martinezii	Guy L'Eplattenier	(for those who did not get any the last time)	\N	\N	\N
BX 331	SEEDS	6	Pancratium canariense	Guy L'Eplattenier	\N	\N	\N	\N
BX 331	SEEDS	7	Dichelostemma volubile	Gene Mirro	\N	http://i232.photobucket.com/albums/ee69/#	\N	\N
BX 331	SEEDS	8	Lilium auratum rubrovittatum	Gene Mirro	\N	\N	\N	\N
BX 331	SEEDS	9	Lilium henryi citrinum`	Gene Mirro	\N	\N	\N	\N
BX 331	BULBS	10	Lilium sulphureum	Gene Mirro	1139: blooms late summer; 5 - 8 ft. tall, large fragrant flowers with white/green inside, white/purple outside; strong straight stems; needs summer water; purple stem bulbils.	http://s232.photobucket.com/albums/ee69/# 39_zps217d838f.jpg	\N	\N
BX 331	BULBS	11	Lilium sulphureum	Gene Mirro	1469: blooms late summer; 5 - 8 ft. tall, large fragrant flowers with white/yellow inside, white/purple outside; strong straight stems; lives 15 years or more; needs summer water. Bulbils	\N	\N	\N
BX 332	BULBS	1	Watsonia sp. aff. fulgens. Cormlets	Kipp McMichael	red	\N	\N	\N
BX 332	SEEDS	2	Massonia pustulata	Kipp McMichael	purple and mottled purple	\N	\N	\N
BX 332	SEEDS	5	Asphodelus acaulis	Angelo Porcelli	\N	\N	\N	\N
BX 332	SEEDS	6	Iris coccina	Angelo Porcelli	\N	\N	\N	\N
BX 332	SEEDS	7	Iris planifolia	Angelo Porcelli	\N	\N	\N	\N
BX 332	SEEDS	8	Paeonia mascula ssp mascula	Angelo Porcelli	\N	\N	\N	\N
BX 332	SEEDS	9	Pancratium canariense	Angelo Porcelli	\N	\N	\N	\N
BX 332	SEEDS	10	Pancratium parviflorum	Angelo Porcelli	\N	\N	\N	\N
BX 332	SEEDS	11	Ceropegia ballyana	Sophie Dixon	\N	\N	\N	\N
BX 332	SEEDS	12	Dietes grandiflora	Guy L'Eplattenier	\N	\N	\N	\N
BX 332	SEEDS	13	Lapiedra martinezii	Guy L'Eplattenier	\N	\N	\N	\N
BX 332	SEEDS	14	Pancratium canariense	Guy L'Eplattenier	\N	\N	\N	\N
BX 332	SEEDS	15	Narcissus serotinus	Donald Leevers	\N	\N	\N	\N
BX 333	SEEDS	1	Sprekelia cv, 'Orient Red'	Stephen Gregg	repeat bloomer, prominent white stripe	\N	\N	\N
BX 333	SEEDS	2	Fritillaria meleagris	David Pilling	\N	\N	\N	\N
BX 333	SEEDS	3.1	Lilium formosanum	David Pilling	\N	\N	\N	\N
BX 333	SEEDS	3.2	Lilium regale	David Pilling	\N	\N	\N	\N
BX 333	SEEDS	4	Zantedeschia aethiopica	David Pilling	\N	\N	\N	\N
BX 333	SEEDS	5	Manfreda undulata 'Chocolate Chips'	Dennis Kramb	\N	\N	\N	\N
BX 333	SEEDS	6	Sinningia speciosa	Dennis Kramb	\N	\N	\N	\N
BX 333	SEEDS	7	Zephyranthes hidalgo x Z. grandiflora	Ina Crossley	could not be verified	\N	\N	\N
BX 333	SEEDS	8	Zephyranthes 'Pink Beauty'	Ina Crossley	\N	\N	\N	\N
BX 333	SEEDS	9	Zephyranthes drummondii	Ina Crossley	\N	\N	\N	\N
BX 333	SEEDS	10	Zephyranthes dichromantha	Ina Crossley	\N	\N	\N	\N
BX 333	SEEDS	11	Zephyranthes flavissima	Ina Crossley	\N	\N	\N	\N
BX 333	SEEDS	12	Zephyranthes lindleyana	Ina Crossley	\N	\N	\N	\N
BX 333	SEEDS	13	Zephyranthes hidalgo 'John Fellers'	Ina Crossley	could not be verified	\N	\N	\N
BX 333	SEEDS	14	Zephyranthes jonesii	Ina Crossley	\N	\N	\N	\N
BX 333	SEEDS	15	Zephyranthes fosteri	Ina Crossley	\N	\N	\N	\N
BX 333	SEEDS	16	Zephyranthes primulina	Ina Crossley	\N	\N	\N	\N
BX 333	SEEDS	17	Zephyranthes reginae	Ina Crossley	\N	\N	\N	\N
BX 333	SEEDS	18	Zephyranthes tenexico	Ina Crossley	apricot. could not be verified	\N	\N	\N
BX 333	SEEDS	19	Zephyranthes verecunda rosea	Ina Crossley	could not be verified	\N	\N	\N
BX 333	BULBS	20	Achimenes erecta 'Tiny Red'	Dennis Kramb	RHIZOMES/TUBERS	\N	\N	\N
BX 333	BULBS	21	Achimenes 'Desiree'	Dennis Kramb	RHIZOMES/TUBERS	\N	\N	\N
BX 333	BULBS	22	Gloxinella lindeniana	Dennis Kramb	RHIZOMES/TUBERS	\N	\N	\N
BX 333	BULBS	23	Niphaea oblonga	Dennis Kramb	RHIZOMES/TUBERS	\N	\N	\N
BX 333	BULBS	24	Sinningia eumorpha 'Saltao'	Dennis Kramb	RHIZOMES/TUBERS	\N	\N	\N
BX 333	BULBS	25	Sinningia speciosa	Dennis Kramb	RHIZOMES/TUBERS	\N	\N	\N
BX 334	SEEDS	1	Gloriosa modesta	Mary Sue Ittner	(Littonia modesta)	\N	summer growing	\N
BX 334	SEEDS	2	Tigridia vanhouttei	Mary Sue Ittner	\N	\N	summer growing	\N
BX 334	BULBS	3	Oxalis triangularis	Mary Sue Ittner	evergreen if you keep watering it	\N	\N	\N
BX 334	BULBS	4	Oxalis sp. Mexico	Mary Sue Ittner	\N	\N	summer growing	\N
BX 334	SEEDS	5	Habranthus martinezii x H. robustus	Stephen Gregg	\N	\N	\N	\N
BX 334	SEEDS	6	Moraea polystachya	Jim Waddick and SIGNA	\N	\N	\N	\N
BX 334	SEEDS	7	Iris tectorum	Jim Waddick and SIGNA	Album'	\N	\N	\N
BX 334	SEEDS	8	Iris tectorum, mixed	Jim Waddick and SIGNA	\N	\N	\N	\N
BX 334	SEEDS	9	Geissorhiza	Jim Waddick and SIGNA	falcata (???)	\N	\N	\N
BX 334	SEEDS	10	Herbertia lahue	Jim Waddick and SIGNA	\N	\N	\N	\N
BX 334	SEEDS	11	Crocosmia	Jim Waddick and SIGNA	ex 'Lucifer'	\N	\N	\N
BX 334	SEEDS	12	Calydorea amabilis	Jim Waddick and SIGNA	\N	\N	\N	\N
BX 334	SEEDS	13	Cypella coelestis	Jim Waddick and SIGNA	(syn Phalocallis coelestis)	\N	\N	\N
BX 334	SEEDS	14	Dietes iridioides	Jim Waddick and SIGNA	\N	\N	\N	\N
BX 334	SEEDS	15	Romulea monticola	Jim Waddick and SIGNA	\N	\N	\N	\N
BX 334	SEEDS	16	Herbertia pulchella	Jim Waddick and SIGNA	\N	\N	\N	\N
BX 334	SEEDS	17	Dietes bicolor	Jim Waddick and SIGNA	\N	\N	\N	\N
BX 334	SEEDS	18	Freesia laxa, blue	Jim Waddick and SIGNA	\N	\N	\N	\N
BX 334	SEEDS	19	Watsonia	Jim Waddick and SIGNA	ex 'Frosty Morn'	\N	\N	\N
BX 334	SEEDS	20	Crocosmia paniculata	Jim Waddick and SIGNA	\N	\N	\N	\N
BX 334	SEEDS	21	Gelasine elongata	Jim Waddick and SIGNA	\N	\N	\N	\N
BX 335	SEEDS	1	Phaedranassa tunguraguae	Bjorn Wretman	\N	\N	\N	\N
BX 335	SEEDS	2	Hippeastrum nelsonii	Stephen Putman	\N	\N	\N	\N
BX 335	SEEDS	3	Zephyranthes fosteri	Ina Crossley	\N	\N	\N	\N
BX 335	SEEDS	4	Zephyranthes dichromantha	Ina Crossley	\N	\N	\N	\N
BX 335	SEEDS	5	Zephyranthes 'Hidalgo'	Ina Crossley	\N	\N	\N	\N
BX 335	SEEDS	6	Zephyranthes reginae	Ina Crossley	\N	\N	\N	\N
BX 335	SEEDS	7	Zephyranthes 'Tenexico'	Ina Crossley	apricot	\N	\N	\N
BX 335	SEEDS	8	Tigridia pavonia	Ina Crossley	pure white	\N	\N	\N
BX 335	SEEDS	9	Zephyranthes citrina	Ina Crossley	\N	\N	\N	\N
BX 335	SEEDS	10	Zephyranthes primulina	Ina Crossley	\N	\N	\N	\N
BX 335	SEEDS	11	Zephyranthes 'Ajax'	Ina Crossley	\N	\N	\N	\N
BX 335	SEEDS	12	Habranthus tubispathus	Ina Crossley	Texensis'	\N	\N	\N
BX 335	SEEDS	13	Habranthus brachyandrus	Ina Crossley	\N	\N	\N	\N
BX 335	SEEDS	14	Habranthus tubispathusvar. roseus	Ina Crossley	\N	\N	\N	\N
BX 335	SEEDS	15	Zephyranthes 'Sunset Strain'	Ina Crossley	\N	\N	\N	\N
BX 335	SEEDS	16	Tigridia pavonia	Nhu Nguyen	- S, OP	\N	s	\N
BX 335	SEEDS	17	Herbertia tigridioides	Nhu Nguyen	- S, OP	\N	s	\N
BX 335	SEEDS	18	Calydorea amabilis	Nhu Nguyen	- S, OP	\N	s	\N
BX 335	SEEDS	19	Cypella herbertii	Nhu Nguyen	- S, OP	\N	s	\N
BX 335	SEEDS	20	Ornithogalum regale	Nhu Nguyen	- W, control pollinated	\N	w	\N
BX 335	BULBS	21	Oxalis lasiandra	Nhu Nguyen	\N	\N	s	\N
BX 335	BULBS	22	Oxalis tetraphylla 'Reverse Iron Cross'	Nhu Nguyen	\N	\N	s	\N
BX 335	BULBS	23	Oxalis sp.	Nhu Nguyen	Durango, Mexico	\N	s	\N
BX 336	BULBS	1	Achimenes grandiflora	Lynn Makela	Robert Dressler'	\N	\N	\N
BX 336	BULBS	2	Achimenes 'Purple King'	Lynn Makela	\N	\N	\N	\N
BX 336	BULBS	3	Crinum 'Menehune' dwarf	Lynn Makela	purple leaves, pink flowers	\N	\N	\N
BX 336	BULBS	4	Eucodonia andrieuxii	Lynn Makela	hybrids (few)	\N	\N	\N
BX 336	BULBS	5	xGlokohleria 'Pink Heaven'	Lynn Makela	\N	\N	\N	\N
BX 336	BULBS	6	Sinningia bullata	Lynn Makela	bright red flowers (few)	\N	\N	\N
BX 336	BULBS	8	Zephyranthes traubii	Lynn Makela	Carlos form	\N	\N	\N
BX 336	SEEDS	10	Burchardia congesta	Don Leevers	(syn B. umbellata)	\N	\N	\N
BX 336	SEEDS	11	Caesia parviflora	Don Leevers	\N	\N	\N	\N
BX 336	SEEDS	12	Xyris lanata	Don Leevers	\N	\N	\N	\N
BX 336	SEEDS	13	Xyris operculata	Don Leevers	\N	\N	\N	\N
BX 336	BULBS	14	Hippeastrum cybister	Dell Sherk	Bulblets	\N	\N	\N
BX 336	BULBS	15	Strumaria truncata	Dell Sherk	Bulblets	\N	\N	\N
BX 336	BULBS	16	Strumaria discifera	Dell Sherk	Bulblets. (very few)	\N	\N	\N
BX 336	BULBS	17	Nerine pudica	Dell Sherk	Bulblets	\N	\N	\N
BX 337	SEEDS	1	Hippeastrum striatum	Stephen Putman	\N	\N	\N	\N
BX 337	SEEDS	2	Narcissus cantabricus	Arnold Trachtenberg	clusii. Per TPL and IPNI, there is no listing for this. Per TPL, N. clusii is a synonym of N. cantabricus var. cantabricus.  Per IPNI, N. cantabricus and N. clusii are two separate species.	\N	\N	\N
BX 337	SEEDS	3	Narcissus romieuxii	Arnold Trachtenberg	\N	\N	\N	\N
BX 337	SEEDS	4	Narcissus romieuxii	Arnold Trachtenberg	var mesatlanticus. Per TPL and IPNI, there is no listing for this. Also no listing under N. mesatlanticus.  PBS lists it as a synonym for N. romieuxii ssp. romieuxii var. romieuxii (also not a valid name per TPL & IPNI), but does not indicate where it is validly described.The Alpine Garden Society states, in part, 'or the dubiously distinct variety mesatlanticus..'	(http://alpinegardensociety.net/plants/#ii/12/)	\N	\N
BX 337	SEEDS	5	Narcissus cantabricus	Arnold Trachtenberg	\N	\N	\N	\N
BX 337	SEEDS	6	Narcissus romieuxii 'Julia Jane'	Arnold Trachtenberg	\N	\N	\N	\N
BX 337	SEEDS	7	Narcissus romieuxii 'Jessamy'	Arnold Trachtenberg	\N	\N	\N	\N
BX 337	SEEDS	8	Massonia pustulata	Arnold Trachtenberg	\N	\N	\N	\N
BX 337	SEEDS	9	Massonia pustulata	Arnold Trachtenberg	purple leaves	\N	\N	\N
BX 337	BULBS	10	Freesia elimensis	Arnold Trachtenberg	(syn? F. caryophyllacea)	\N	\N	\N
BX 337	BULBS	11	Freesia fucata	Arnold Trachtenberg	\N	\N	\N	\N
BX 337	BULBS	12	Lachenalia liliflora	Arnold Trachtenberg	\N	\N	\N	\N
BX 337	BULBS	13	Leucocoryne purpurea	Arnold Trachtenberg	\N	\N	\N	\N
BX 337	BULBS	14	Freesia sp.	Arnold Trachtenberg	?	\N	\N	\N
BX 337	BULBS	15	Arum	Arnold Trachtenberg	unidentified	\N	\N	\N
BX 337	BULBS	16	Ferraria uncinata	Arnold Trachtenberg	\N	\N	\N	\N
BX 337	BULBS	17	Babiana rubrocyanea	Arnold Trachtenberg	\N	\N	\N	\N
BX 337	SEEDS	18	Massonia pustulata	Antigoni Rentzeperis	\N	\N	\N	\N
BX 338	SEEDS	1	Schizobasis intricata	Monica Swartz	ex Huntington Botanic Gardens (ISI 2004-36),	\N	\N	\N
BX 338	SEEDS	2	Ornithogalum glandulosum	Monica Swartz	ex Jim Duggan Flower Nursery, the earliest winter flower I grow,	\N	\N	\N
BX 338	BULBS	3	Alocasia hypnosa	Monica Swartz	Small tubers of Alocasia hypnosa, a recently described (2005) species from China. Big light green leaves that give a tropical look to a shady area. Winter dormant. I store the big tubers in a bucket of dry sand in a cold garage every winter, but small tubers have over-wintered fine in ground in my 8b garden. I suspect the big tubers would do the same if buried in well-drained soil. They are waking now, so plant right away.	\N	\N	\N
BX 338	SEEDS	4	Freesia viridis	Antigoni Rentzeperis	\N	\N	\N	\N
BX 338	SEEDS	5	Lachenalia viridiflora	Antigoni Rentzeperis	\N	\N	\N	\N
BX 338	SEEDS	6	Pelargonium appendiculatum	Ruth Jones	Per TPL, Geraniospermum appendiculatum is the accepted name; P. appendiculatum is the synonym. Per IPNI, each name is a separate species.	\N	\N	\N
BX 338	SEEDS	7	Clivia miniata	Mary Sue Ittner	from two plants, both very light yellow flowers Bulbs: all winter growing, may not all be blooming size	\N	\N	\N
BX 338	BULBS	8	Oxalis assinia	Mary Sue Ittner	(syn. O. fabaefolia)	\N	\N	\N
BX 338	BULBS	9	Oxalis bowiei	Mary Sue Ittner	Oxalis bowiei This made the favorite pink category of a couple of us.  This is a fall blooming, tall, big gorgeous plant.	\N	\N	\N
BX 338	BULBS	10	Oxalis engleriana	Mary Sue Ittner	South African, fall blooming, linear leaves	\N	\N	\N
BX 338	BULBS	11	Oxalis flava	Mary Sue Ittner	yellow, winter growing, fall blooming	\N	w	\N
BX 338	BULBS	12	Oxalis flava	Mary Sue Ittner	received as O. namaquana, but is this species, yellow flowers	\N	\N	\N
BX 338	BULBS	13	Oxalis flava	Mary Sue Ittner	(lupinifolia) -- lupine like leaves and pink flowers, fall blooming	\N	\N	\N
BX 338	BULBS	14	Oxalis flava	Mary Sue Ittner	(pink) -- leaves low to ground, attractive, one year some of the flowers were also yellow (along with the pink), but usually it has pink flowers, no guarantee about the color but the leaves are nice and it doesn't offset a lot	\N	\N	\N
BX 338	BULBS	15	Oxalis hirta	Mary Sue Ittner	(mauve) received from Ron Vanderhoff, definitely a different color from the pink ones I grow, really pretty, fall blooming	\N	\N	\N
BX 338	BULBS	16	Oxalis hirta	Mary Sue Ittner	(pink) From South Africa, blooms late fall, early winter, bright pink flowers. Increases rapidly. does better for me in deep pot, fall blooming	\N	\N	\N
BX 338	BULBS	17	Oxalis hirta	Mary Sue Ittner	Gothenburg'- a hirta on steroids, gets to be a very large plant and does best with a deep pot	\N	\N	\N
BX 338	BULBS	18	Oxalis imbricata	Mary Sue Ittner	-recycled from the BX. This one has pink flowers even though Cape Plants says the flowers are white. The one shown on the web that everyone grows has hairy leaves, pink flowers. Fall into winter blooming	\N	\N	\N
BX 338	BULBS	19	Oxalis luteola	Mary Sue Ittner	MV 5567 60km s of Clanwilliam. 1.25 inch lt yellow flrs, darker ctr. This one has been very reliable for me in Northern California	\N	\N	\N
BX 338	BULBS	20	Oxalis melanosticta	Mary Sue Ittner	Ken Aslet' -- has a reputation for not blooming and originally I grew it for its hairy soft leaves that make you want to touch it, but grown in a deep pot it has been blooming the last several years in the fall	\N	\N	\N
BX 338	BULBS	21	Oxalis obtusa	Mary Sue Ittner	MV 5051 Vanrhynshoek. 2 inch lt copper-orange, darker veining, yellow ctr.	\N	\N	\N
BX 338	BULBS	22	Oxalis palmifrons	Mary Sue Ittner	-grown for the leaves, mine have never flowered, but the leaves I like	\N	\N	\N
BX 338	BULBS	23	Oxalis polyphylla	Mary Sue Ittner	var heptaphylla MV 4381B - 4km into Skoemanskloof from Oudtshoorn. Long, succulent, thread-like leaves	\N	\N	\N
BX 338	BULBS	24	Oxalis polyphylla	Mary Sue Ittner	var heptaphylla MV6396 Vanrhynsdorp. Succulent thread-like leaves. Winter growing, blooms fall	\N	\N	\N
BX 338	BULBS	25	Oxalis pulchella	Mary Sue Ittner	var tomentosa - ex BX 221 and Ron Vanderhoff - Low, pubescent, mat forming foliage and large very pale salmon colored flowers. Fall blooming. This one hasn't bloomed for me yet, but I keep hoping as the bulbs are getting bigger and bigger	\N	\N	\N
BX 338	BULBS	26	Oxalis purpurea (white)	Mary Sue Ittner	(white) winter growing, long blooming, but beware of planting in the ground in a Mediterranean climate unless you don't care if it takes over as it expands dramatically, a lot.	\N	w	\N
BX 338	BULBS	27	Oxalis purpurea 'Lavender & White'	Mary Sue Ittner	Lavender & White'	\N	\N	\N
BX 338	BULBS	28	Oxalis purpurea 'Skar'	Mary Sue Ittner	originally from Bill Baird, long blooming, pink flowers	\N	\N	\N
BX 338	BULBS	29	Oxalis versicolor	Mary Sue Ittner	--lovely white with candy stripe on back, winter blooming	\N	\N	\N
BX 338	BULBS	30	Tulipa humilis	Mary Sue Ittner	Red Cup' - received as this from Brent & Becky's, but I can't find validation about the name. There is a Tulipa hageri 'Red Cup'. I'd love to know what the name should be. I've added photos to the wiki	\N	\N	\N
BX 338	BULBS	31	Tulipa turkestanica	Mary Sue Ittner	\N	\N	\N	\N
BX 338	BULBS	32	Oxalis zeekoevleyensis	Mary Sue Ittner	blooms early fall, lavender flowers	\N	\N	\N
BX 338	BULBS	33	Ferraria sp.	Arnold Trachtenberg	? Small corms	\N	\N	\N
BX 339	BULBS	3	Oxalis obtusa	Mary Sue Ittner	MV5005a 10km n of Matjiesfontein. Red-orange	\N	\N	\N
BX 339	BULBS	4	Tulipa clusiana	Mary Sue Ittner	small bulbs, not blooming size	\N	\N	\N
BX 339	BULBS	5	Oxalis depressa	Mary Sue Ittner	MV 4871	\N	\N	\N
BX 339	SEEDS	6	Tritonia dubia	Monica Swartz	\N	\N	\N	\N
BX 339	SEEDS	7	Romulea gigantea	Monica Swartz	\N	\N	\N	\N
BX 339	SEEDS	8	Albuca suaveolens	Monica Swartz	\N	\N	\N	\N
BX 339	SEEDS	9	Freesia refracta	Monica Swartz	\N	\N	\N	\N
BX 339	BULBS	10	Cyrtanthus elatus x montanus	Monica Swartz	Bulblets	\N	\N	\N
BX 339	BULBS	11	Cyrtanthus sanguineus	Monica Swartz	Bulblets	\N	\N	\N
BX 339	BULBS	12	Lachenalia orchioidesr var. glaucina	Arnold Trachtenberg	Bulblets	\N	\N	\N
BX 339	BULBS	13	Lachenalia glauca	Arnold Trachtenberg	Bulblets	\N	\N	\N
BX 339	BULBS	14	Lachenalia namaquensis	Arnold Trachtenberg	Bulblets	\N	\N	\N
BX 339	BULBS	15	Lachenalia aloides var. quadricolor	Arnold Trachtenberg	Bulblets	\N	\N	\N
BX 339	BULBS	16	Lachenalia viridiflora	Arnold Trachtenberg	Bulblets	\N	\N	\N
BX 339	BULBS	17	Lachenalia comptonii	Arnold Trachtenberg	Bulblets	\N	\N	\N
BX 339	BULBS	18	Cyrtanthus labiatus	Arnold Trachtenberg	Bulblets	\N	\N	\N
BX 339	BULBS	19	Stenomesson pearcei	Arnold Trachtenberg	Bulblets	\N	\N	\N
BX 339	SEEDS	20	Lachenalia reflexa	Arnold Trachtenberg	\N	\N	\N	\N
BX 339	SEEDS	21	Tristagma uniflorum 'Charlotte Bishop'	Kathleen Sayce	formerly Ipheion, has large pink flowers. Plants should not completely dry out during summer dormancy. (few)	\N	\N	\N
BX 437	BULBS	4	Crinum 'JC Harvey'	JT and Anne Sessions	bulbs	\N	\N	\N
BX 437	BULBS	5	Crinum 'Milk & Wine'	JT and Anne Sessions	bulbs	\N	\N	\N
BX 437	BULBS	6	Lycoris radiata	JT and Anne Sessions	bulbs	\N	\N	\N
BX 446	SEEDS	14	Calostemma purpureum	RImmer de Vries	seed	\N	\N	\N
BX 446	SEEDS	15	Lachenalia contaminata	RImmer de Vries	\N	\N	\N	\N
BX 446	SEEDS	16	Haemanthus humilis	RImmer de Vries	seed - giant form, 13-15 inch leaves	\N	\N	\N
BX 454	SEEDS	9	Hippeastrum 'Blue Dream'	Karl Church	\N	\N	\N	\N
BX 454	SEEDS	10	Habranthus tubispathus	Karl Church	\N	\N	\N	\N
BX 392	BULBS	1	Amorphophallus sp.	Joyce Miller	.. grown from BX seeds.	\N	\N	\N
BX 328	SEEDS	18	Romulea autumnalis	Kathleen Sayce	\N	\N	\N	\N
BX 328	SEEDS	19	Acis autumnalis	Kathleen Sayce	syn. Leucojum autumnale	\N	\N	\N
BX 329	SEEDS	15	Lilium candidum	Donald Leevers	\N	\N	\N	\N
BX 329	SEEDS	16	Ornithogalum caudatum	Donald Leevers	\N	\N	\N	\N
BX 329	SEEDS	17	Pancratium maritimum	Donald Leevers	\N	\N	\N	\N
BX 329	SEEDS	18	Tulbaghia maritima	Donald Leevers	\N	\N	\N	\N
BX 329	SEEDS	19	Urginea maritima	Donald Leevers	\N	\N	\N	\N
BX 329	SEEDS	20	Watsonia latifolia	Donald Leevers	\N	\N	\N	\N
BX 329	SEEDS	21	Zephyranthes reginae	Donald Leevers	\N	\N	\N	\N
BX 329	SEEDS	22	Allium obliquum	Roland de Boer	\N	\N	\N	\N
BX 329	SEEDS	23	Allium victorialis	Roland de Boer	form 1	\N	\N	\N
BX 329	SEEDS	24	Allium victorialis	Roland de Boer	form 2	\N	\N	\N
BX 329	SEEDS	25	Lilium columbianum	Roland de Boer	ex N. Rocky Mountains	\N	\N	\N
BX 329	SEEDS	26	Tropaeolum brachyceras	Roland de Boer	\N	\N	\N	\N
BX 421	SEEDS	10	Hippeastrum 'Evergreen'	Karl Church	\N	\N	\N	\N
BX 301	SEEDS	19	Anchomanes difformis var welwitschii	Dave Boucher	, a close relative of Amorphophallus from Africa. Has spines, but most of the stink is not present	\N	\N	\N
BX 347	SEEDS	17	Lachenalia hirta	Chris Elwell	Unsure of donor name	\N	\N	\N
BX 435	BULBS	6	Pancratium sickenbergeri	Albert Stella	small bulbs - these are offsets of bulbs grown from wild collected (2010) seed.	\N	\N	\N
BX 435	BULBS	7	Sprekelia formosissima	Albert Stella	small bulbs	\N	\N	\N
BX 435	BULBS	1	Barnardia numidica	Albert Stella	(Scilla) numidica bulbs	\N	\N	\N
BX 435	BULBS	3	x Amarcrinum memoria-corsii	Albert Stella	Amarcrinum memoria-corsii bulbs	\N	\N	\N
BX 462	BULBS	52	Narcissus cantabricus	Arcangelo Wessells	ex. Archibald	\N	\N	\N
BX 462	SEEDS	53	Rhodophiala bagnoldii	Arcangelo Wessells	seeds ex. Chile	\N	\N	\N
BX 462	BULBS	50	Oxalis gracilis	Arcangelo Wessells	ex. Dylan Hannon	\N	\N	\N
BX 462	BULBS	51	Calochortus superbus	Arcangelo Wessells	ex. American Canyon	\N	\N	\N
BX 386	BULBS	21	Sinningia 'Deep Purple Dreaming'	Dennis Kramb	(few, large tubers, these were harvested when fully dormant, but this cultivar has a long dormancy for me, so plant immediately but water sparingly until new growth naturally resumes)	\N	\N	\N
BX 348	BULBS	3	Oxalis caprina	Ernie DeMarie	\N	\N	\N	\N
BX 348	BULBS	4	Oxalis compressa	Ernie DeMarie	ex BX 218	\N	\N	\N
BX 348	BULBS	5	Oxalis bifurca	Ernie DeMarie	\N	\N	\N	\N
BX 348	BULBS	6	Oxalis dichotoma	Ernie DeMarie	\N	\N	\N	\N
BX 348	BULBS	7	Oxalis fabifolia	Ernie DeMarie	ex BX 218	\N	\N	\N
BX 348	BULBS	8	Oxalis hirta	Ernie DeMarie	\N	\N	\N	\N
BX 348	BULBS	9	Oxalis luteola	Ernie DeMarie	MV 5090	\N	\N	\N
BX 348	BULBS	10	Oxalis obtusa	Ernie DeMarie	no label	\N	\N	\N
BX 348	BULBS	11	Oxalis obtusa	Ernie DeMarie	two forms?	\N	\N	\N
BX 348	BULBS	12	Oxalis obtusa	Ernie DeMarie	no data	\N	\N	\N
BX 348	BULBS	13	Oxalis 'polyphylla var. heptaphylla'	Ernie DeMarie	\N	\N	\N	\N
BX 348	BULBS	14	Oxalis simplex	Ernie DeMarie	\N	\N	\N	\N
BX 348	BULBS	15	Oxalis	Ernie DeMarie	no label, probably O. stenorhynca	\N	\N	\N
BX 348	BULBS	16	Oxalis sp.	Ernie DeMarie	MV 7088	\N	\N	\N
BX 318	BULBS	1	Moraea ciliate	M Gastil-Buhl	Cormlets. Miss-spelling of Moraea ciliata	\N	w	\N
BX 318	BULBS	2	Babiana pulchra	M Gastil-Buhl	white, corms ex Jim Duggan	\N	w	\N
BX 318	BULBS	3	Sparaxis tricolor hybrid	M Gastil-Buhl	ex UCSB, dk velvet red with yellow+black markings, corms	\N	w	\N
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
BX 463b	BULBS	40	Stenomesson pearcei	M Gastil-Buhl	\N	\N	\N	\N
BX 463s	SEEDS	82	Ipheion uniflorum	M Gastil-Buhl	\N	\N	w	\N
BX 442	SEEDS	16	Hymenocallis aff. phalangidis	Rimmer deVries	seeds - ex. D. Hannon, South of Tepic, Nayarit ~7000' elevation	\N	\N	Seeds
BX 442	BULBS	17	Ledebouria sudanica	Rimmer deVries	(Tentative ID) offsets - ex. D. Hannon - Gamba, Gabon	\N	\N	Offsets
BX 442	SEEDS	18	Phaedranassa tunguraguae	Rimmer deVries	seed ex BX 375	\N	\N	\N
BX 463s	SEEDS	86	Lachenalia orchidioides	M Gastil-Buhl	\N	\N	w	\N
BX 463s	SEEDS	136	Tropaeolum hookerianum var. austropurpureum	M Gastil-Buhl	\N	\N	w	\N
BX 463s	SEEDS	140	Veltheimia bracteata	M Gastil-Buhl	\N	\N	w	\N
BX 459	SEEDS	22	Zephyranthes miradorensis	Ina Crossley	\N	\N	\N	\N
BX 459	SEEDS	23	Zephyranthes drummondii	Ina Crossley	\N	\N	\N	\N
BX 459	SEEDS	24	Zephyranthes fluvialis	Ina Crossley	\N	\N	\N	\N
BX 459	SEEDS	25	Zephyranthes macrosiphon	Ina Crossley	\N	\N	\N	\N
BX 459	SEEDS	26	Zephyranthes lagesiana	Ina Crossley	\N	\N	\N	\N
BX 459	SEEDS	27	Zephyranthes 'Labuffarosea'	Ina Crossley	\N	\N	\N	\N
BX 459	SEEDS	28	Zephyranthes clintiae	Ina Crossley	\N	\N	\N	\N
BX 459	SEEDS	29	Zephyranthes morrisclintii	Ina Crossley	\N	\N	\N	\N
BX 459	SEEDS	30	Zephyranthes reginae	Ina Crossley	\N	\N	\N	\N
BX 459	SEEDS	31	Zephyranthes verecunda	Ina Crossley	- pale pink	\N	\N	\N
BX 459	SEEDS	32	Zephyranthes verecunda	Ina Crossley	- white	\N	\N	\N
BX 459	SEEDS	33	Zephyranthes verecunda	Ina Crossley	- dark pink	\N	\N	\N
BX 459	SEEDS	34	Zephyranthes primulina	Ina Crossley	\N	\N	\N	\N
BX 459	SEEDS	35	Zephyranthes jonesii	Ina Crossley	\N	\N	\N	\N
BX 459	SEEDS	36	Zephyranthes sp.	Ina Crossley	\N	\N	\N	\N
BX 459	SEEDS	37	Zephyranthes nymphaea	Ina Crossley	\N	\N	\N	\N
BX 459	SEEDS	38	Zephyranthes citrina	Ina Crossley	\N	\N	\N	\N
BX 459	SEEDS	39	Zephyranthes katheriniae 'rubra'	Ina Crossley	\N	\N	\N	\N
BX 459	SEEDS	40	Zephyranthes katheriniae 'lutea'	Ina Crossley	\N	\N	\N	\N
BX 459	SEEDS	41	Zephyranthes mesochloa	Ina Crossley	\N	\N	\N	\N
BX 459	SEEDS	42	Zephyranthes 'Pink Beauty'	Ina Crossley	\N	\N	\N	\N
BX 459	SEEDS	43	Zephyranthes 'Sunset Strain'	Ina Crossley	\N	\N	\N	\N
BX 459	SEEDS	44	Zephyranthes x	Ina Crossley	- pink	\N	\N	\N
BX 459	SEEDS	45	Habranthus brachyandrus 'Jumbo'	Ina Crossley	\N	\N	\N	\N
BX 459	SEEDS	46	Habranthus brachyandrus	Ina Crossley	\N	\N	\N	\N
BX 459	SEEDS	47	Habranthus estensis	Ina Crossley	\N	\N	\N	\N
BX 459	SEEDS	48	Habranthus x floryi	Ina Crossley	green throat	\N	\N	\N
BX 459	SEEDS	49	Habranthus gracilifolius	Ina Crossley	\N	\N	\N	\N
BX 459	SEEDS	50	Habranthus tubispathus 'Cupreus'	Ina Crossley	\N	\N	\N	\N
BX 459	SEEDS	51	Habranthus tubispathus var. roseus	Ina Crossley	\N	\N	\N	\N
BX 459	SEEDS	52	Habranthus sp.	Ina Crossley	blue - 'Probably a form of H. tubispathus'	\N	\N	\N
BX 459	SEEDS	53	Rhodophiala bifida subsp. granatiflora	Ina Crossley	\N	\N	\N	\N
BX 459	SEEDS	54	Rhodophiala bifida	Ina Crossley	\N	\N	\N	\N
BX 463s	SEEDS	3	Albuca aurea	Johannes-Ulrich Urban	Winter growing, evergreen, greenish yellow upright flower spikes about 60cm tall. Forms vigorous clumps in the garden, can be pot grown. Beginniner’s choice.	\N	\N	\N
BX 463s	SEEDS	4	Albuca canadense	Johannes-Ulrich Urban	Tall winter growing, summer dormant, greenish white upright flowers, may not go fully dormant in its first summer. Beginniner’s choice.	\N	\N	\N
BX 463s	SEEDS	16	Anemone palmata	Johannes-Ulrich Urban	wc beautiful local spring flowers, shiny bright yellow, horizontal brittle rhizomes, sow immediately	\N	\N	\N
BX 463s	SEEDS	19	Asphodeline liburnica	Johannes-Ulrich Urban	hardy perennial, yellow, summer dormant in dry conditions.	\N	\N	\N
BX 463s	SEEDS	22	Babiana sp. blue	Johannes-Ulrich Urban	Babiana brightest blue Hybr? spec? Sow immediately, summer dormant South African	\N	\N	\N
BX 463s	SEEDS	62	Freesia laxa f. aurea	Johannes-Ulrich Urban	Freesia laxa azurea, ex Monica Swartz small dainty blue version, sow immediately. Beginniner’s choice. The blue, not the yellow one is my donation.	\N	\N	\N
BX 463s	SEEDS	72	Galtonia candicans	Johannes-Ulrich Urban	summer growing, spring sowing. Tall inflorescence with many white nodding flowers. Seed grown plants are virus free. Easy and straightforward, beginner‘s choice.	\N	\N	\N
BX 463s	SEEDS	74	Gladiolus dalenii	Johannes-Ulrich Urban	ex Silverhill, summer growing, spring sowing. Dainty salmon red to orange flowers, easy and straightforward. A beginniner‘s choice.	\N	\N	\N
BX 463s	SEEDS	75	Gladiolus illyricus	Johannes-Ulrich Urban	wc. Pretty local pink gladiolus, 50 or 60cm, summer dormant, sow immediately.	\N	\N	\N
BX 463s	SEEDS	77	Habranthus robustus var. biflorus	Johannes-Ulrich Urban	ex PBS 2008, Lynn Makela. summer growing but not sure for how long the seed can be stored. Better sown immediately with bottoms heat and good light.	\N	\N	\N
BX 463s	SEEDS	84	Iris xiphium	Johannes-Ulrich Urban	wild collected. Looks like an elegant version of the Dutch iris, good blue, 1m tall, sow immediately, takes time to flower from seed.	\N	\N	\N
BX 463s	SEEDS	90	Lilium longiflorum	Johannes-Ulrich Urban	ex ‘White Triumphator’ spring sowing, magnificent wax like scented pure white trumpets. Easy and fast from seed, beginner‘s choice.	\N	\N	\N
BX 463s	SEEDS	102	Narcissus bulbocodium ssp. obesus	Johannes-Ulrich Urban	wild collected. wc dainty small hoop petticoat narcissus on lime free soil, cannot tolerate competition from vigorous plants. Sow immediately.	\N	\N	\N
BX 463s	SEEDS	115	Ornithogalum richtersvendensis	Johannes-Ulrich Urban	A dainty dwarf gem, max 10cm tall. Large white flowers. Flat rosette of greenish blue leaves. Best grown in very well draining substrate. Winter growing but does not tolerate winter rain on the foliage, alpine house, frost free. Sow immediately, for the advanced grower.	\N	\N	\N
BX 463s	SEEDS	134	Tropaeolum hookerianum	Johannes-Ulrich Urban	ex Chileflora. The easiest blue Tropaeolum with me. Flowers the first year from seed. Sow IMMEDIATELY, soak the seed over night before sowing. Dislikes hot weather in spring which will induce premature dormancy, keep it as cool as possible and partially shaded. Frost free. Good in deep pots. In the open garden tubers will disappear deep down somewhere. The emerging shoot of mature tubers is hairlike and almost invisible, prone to damage. Needs something finely structured to climb on.	\N	\N	\N
BX 463s	SEEDS	144	Zantedeschia aethiopica	Johannes-Ulrich Urban	large form. From a cultivated plant of wild origin. Taller and larger leaved than ordinary form, flowers white like the well known ones. Winter growing, summer dormant without water in Mediterranean climates but lush, big and evergreen with summer water. Enjoys water and fertilizer when in growth. Can be grown in pots.	\N	\N	\N
BX 350	SEEDS	20	Brunsvigia litoralis	Kipp McMichael	\N	\N	\N	\N
BX 306	SEEDS	11	Haemanthus humilis	Pacific Bulb Society	yellow throat	\N	\N	\N
BX 306	SEEDS	12	Nerine laticoma	Pacific Bulb Society	short stem	\N	\N	\N
BX 306	SEEDS	13	Nerine laticoma	Pacific Bulb Society	with red stripe	\N	\N	\N
BX 306	SEEDS	14	Scadoxus puniceus	Pacific Bulb Society	light pink	\N	\N	\N
BX 306	SEEDS	15	Scadoxus puniceus	Pacific Bulb Society	dark pink stripe	\N	\N	\N
BX 379	BULBS	4	Ornithogallum osmynellum	Pamela Slate	(Albuca osmynella); ex BX 148, ex Steve Hammer, ex Noreogas	\N	\N	Small bulbs
BX 343	SEEDS	4	Scilla cilicica	Rimmer deVries	\N	\N	\N	\N
BX 343	SEEDS	5	Cyclamen hederifolium	Rimmer deVries	\N	\N	\N	\N
BX 355	SEEDS	5	Tigridia pavonia	Rimmer deVries	seeds from the 'Sunset in Oz' plants came From Ellen Hornig in BX 272 #10. Parent plants pictured in the Sept 2013 International rock Gardener	http://srgc.org.uk/logs/logdir/#	\N	\N
BX 375	BULBS	2	Othonna aff. perfoliata	Rimmer deVries	ex Mike Vassar 7454, Simonsviel- (ex BX 353 as Othonna Sp? white) these have large fleshy leaves with purple backs and small yellow florets without ray petals, (ex BX 353 as Othonna Sp? white) these do very well if occasionally watered well while in growth in fall- winter see photos;	https://www.flickr.com/photos/32952654@N06/sets/72157651257523029/	\N	\N
BX 375	BULBS	4	Albuca humilis	Rimmer deVries	JCA 15.856 - collected at 3,000M on gravelly ledges and pockets below cliffs in the Drakensberg- Mont aux Source collected on 25th March 1996 (Trip 30 field notes), see http://files.srgc.net/archibald/fieldnotes/30JCASAfrica1996.pdf;	https://www.flickr.com/photos/32952654@N06/sets/72157646437270133/	\N	\N
BX 375	BULBS	5	Albuca namaquensis	Rimmer deVries	ex BX 351 bloomed winter 2014-15 ;	https://www.flickr.com/photos/32952654@N06/sets/72157649471752610/	\N	\N
BX 375	BULBS	7	Cyclamen seedlings	Rimmer deVries	probably persicum ex rock or alpine society seed ex.;	https://www.flickr.com/photos/32952654@N06/16964424816/	\N	\N
BX 375	BULBS	8	Cyclamen graecum	Rimmer deVries		\N	\N	\N
BX 375	BULBS	9	Lachenalia pendula	Rimmer deVries	(AKA L.bulbifera) ex BX 362	\N	\N	\N
BX 375	BULBS	10	Cyrtanthus elatus 'Pink Diamond'	Rimmer deVries	from Glasshouse Works -few small bulbs or offsets, some in leaf	\N	\N	\N
BX 375	SEEDS	11	Clivia miniata	Rimmer deVries	hybrid yellow;	https://www.flickr.com/photos/32952654@N06/16988983822/in/album-72157651257749069/	\N	\N
BX 375	SEEDS	12	Clivia miniata	Rimmer deVries	red Nakumura type ex Kevin Akers;	https://www.flickr.com/photos/32952654@N06/16370236073/in/album-72157651257749069/	\N	\N
BX 376	BULBS	4	Haemanthus albiflos	Rimmer deVries	wide green leaves, white flower - germinated seedlings from my plant- started in Jan 2015.;	https://www.flickr.com/photos/32952654@N06/sets/72157651531259990/	\N	\N
BX 376	BULBS	5	Albuca suaveolens	Rimmer deVries	1 yrs old seedlings grown from PBS seed sale Feb 2014- blooms in 1 yrs from seed;	https://www.flickr.com/photos/32952654@N06/sets/72157649619924043/	\N	\N
BX 378	BULBS	1	Albuca juncifolia	Rimmer deVries	ex BX 351 #1	\N	\N	\N
BX 378	BULBS	2	Albuca clanwilliamae-gloria	Rimmer deVries	from Feb 2014 PBX seed sale	\N	\N	\N
BX 378	BULBS	3	Albuca acuminata	Rimmer deVries	ex BX 351 #9 blooming size bulbs and lots of small bulbs.	\N	\N	\N
BX 379	BULBS	7	Albuca suaveolens	Rimmer deVries		\N	\N	Bulbs
BX 380	SEEDS	4	Cyclamen graecum	Rimmer deVries	fresh seeds moist packed in vermiculite.	\N	\N	\N
BX 380	SEEDS	5	Clivia miniata	Rimmer deVries	hyb; Seeds of hyb- ex Maris Andersons- blooms as Salmon D4 to Apricot D6 (VERY FEW)	\N	\N	\N
BX 382	SEEDS	13	Trillium viride	Rimmer deVries	ex Jefferson Co. Mo. packed in damp vermiculite- these were taken from the fruits, washed and mailed to you in minutes and may mold up if not opened upon arrival. Pics of the trillium at the link below. These are hardy in Michigan. https://www.flickr.com/gp/32952654@N06/nF8tog/	https://flic.kr/s/aHskdyUcQ8/	\N	\N
BX 382	SEEDS	14	Clivia miniata	Rimmer deVries	hybrid Nakamura type with short wide leaves, orange flowers, big red fruits. pic of the red fruits on flicker	https://flickr.com/photos/32952654@N06/#	\N	\N
BX 382	SEEDS	15	Habranthus robustus	Rimmer deVries	ex BX 316 #6 came as Bulbs of Notholirion thompsonianum, these were hardy in a cold frame in Michigan for several years but really took off when I brought the pot inside. big pink flowers with dark throat. flowers everytime it rains all summer. some are red and some are green.	\N	\N	\N
BX 385	BULBS	3	Massonia echinata	Rimmer deVries	- 2 yr old seedlings from NARGS 2012-13 seed ex # 1684 donated by Corina Rieder started 18 March 2013-	https://flic.kr/p/rTo7VD/	\N	\N
BX 385	BULBS	4	Massonia pustulata	Rimmer deVries	- 2 yr old seedlings from BX 337 Arnold's purple leaved plants, seed started 12 May 2013	\N	\N	\N
BX 385	BULBS	5	Habranthus tubispathus	Rimmer deVries	ex Jim Shelids, pot full of 1 yr old seedlings - seed collected 7/15/2014, started 7/16/2014	\N	\N	\N
BX 386	BULBS	2	Cyrtanthus elatus	Rimmer deVries	x montanus -ex BX 330	\N	\N	Bulblets
BX 386	BULBS	3	Tulipa sylvestris	Rimmer deVries	- few small bulbs	\N	\N	\N
BX 386	SEEDS	4	Habranthus tubispathus	Rimmer deVries	ex Telos	\N	\N	Seeds
BX 386	SEEDS	5	Habranthus robustus	Rimmer deVries	ex Telos	\N	\N	Seeds
BX 387	SEEDS	1	Paeonia lactiflora	Rimmer deVries	-The parents of the seeds area collection of singles and semi doubles in white, pinks, and reds grown from a mix of OP seedlings Color Magnet and Minnie Shaylor.	\N	\N	Seeds
BX 387	BULBS	2	Phaedranassa viridiflora	Rimmer deVries	(VERY FEW)	\N	\N	\N
BX 387	BULBS	3	Eucrosia bicolor	Rimmer deVries		\N	\N	\N
BX 387	BULBS	4	Clivia miniata	Rimmer deVries	hybrids misc. 1-2 yr seedlings. appear to be reds.	\N	\N	\N
BX 398	BULBS	2	Clivia sp.	Rimmer deVries	yellow Clivia sp.: 3 yr old seedlings (FEW) These are all Type 1 yellow clivia- that means they always make yellow seedlings no matter what pollen parent you use. The pale yellow flower flower is rather large and loose.	\N	\N	\N
BX 398	BULBS	3	Ornithogalum caudatum	Rimmer deVries	(Albuca bracteata) (FEW) half-inch bulb offsets	\N	\N	\N
BX 398	SEEDS	4	Clivia hyb	Rimmer deVries	Salmon D4- Apricot D6 color, salmon colored fruits, ex Maris Andersons. (VERY FEW)	\N	\N	Seeds
BX 399	BULBS	1	Massonia pustulata	Rimmer deVries	bulbs from BX 337 donor's mother plant from Jim Digger had purple leaves, these don't	\N	\N	\N
BX 399	BULBS	2	Massonia echinata	Rimmer deVries	bulbs from NARGS 13 #1684, bright green leaves smallish white flowers with yellow pollen.	\N	\N	\N
BX 399	BULBS	3	Massonia hyb	Rimmer deVries	. came as depressa from NARGS 13 #1683 but not, big wide leaves,	\N	\N	\N
BX 402	BULBS	3	Othonna sp.	Rimmer deVries	possibly Othonna aff. perfoliata ex Mike Vassar 7454, Simonsviel- yellow florets with no petals. good increaser in damp sand in later fall to winter- dry summer	\N	\N	\N
BX 402	SEEDS	5	Cyclamen hederifolium	Rimmer deVries	mix of many types	\N	\N	\N
BX 311	SEEDS	15	Scilla sp.	Rimmer deVries	? ex collected in Jebl Nusairi, Syria by R&R Wallis- previously donated to RHS LG by Alan Edwards of UK- I treat as tender in an unheated cold frame and they do well so maybe they are not so tender.	\N	\N	Seed
BX 411	SEEDS	2	Calostemma purpureum	Rimmer deVries	seed. these germinate quickly in the fall on the ground. i start them outside in a plunged pot and bring the pot in when it gets cold before freezing, plants keep leaves until about June - July when the leaves start to fade, mature plants send up flower stems in August and drop big fat seeds in September, some leaves may stay while flowering but new ones emerge at or after flowering	\N	\N	\N
BX 413	BULBS	1	Sinningia cardinalis	Rimmer deVries	small tubers	\N	\N	\N
BX 413	BULBS	2	Phaedranassa carmiolii	Rimmer deVries	small bulbs, from Jude Platteborze (FEW)	\N	\N	\N
BX 413	BULBS	3	Hymenocallis harrisiana	Rimmer deVries	seedlings	\N	\N	\N
BX 413	BULBS	4	Crinum oliganthum x asiaticum 'Menehune'	Rimmer deVries	x asiaticum 'Menehune' ONE Clump, only	\N	\N	\N
BX 413	BULBS	5	Eucharis plicata	Rimmer deVries	small bulbs (FEW)	\N	\N	\N
BX 413	BULBS	6	Cyrtanthus mackenii var. cooperii	Rimmer deVries	small bulbs (FEW)	\N	\N	\N
BX 415	SEEDS	4	Phaedranassa dubia	Rimmer deVries	(ex Telos, but in bloom near P. dubia, Ornduff 9674, Ecuador)	\N	\N	\N
BX 416	BULBS	8	Haemanthus albiflos	Rimmer deVries	seedings 2 yrs old (FEW)	\N	\N	\N
BX 416	SEEDS	9	Haemanthus pauculifolius	Rimmer deVries	seeds (VERY FEW)	\N	\N	\N
BX 418	BULBS	29	Sinningia eumorpha	Rimmer deVries	-purple collected by Clenilson Souze, seedlings ex BX 388,	\N	\N	\N
BX 418	BULBS	30	Zantedeschia jucunda	Rimmer deVries	from BX 357 #17 (March 2014). Zantedeschia jucunda, originally from Chiltern seeds, summer growing winter dormant species. Attractive foliage is bright green with white dots and the flowers are of a very thick wax like texture	\N	s	Small corms
BX 427	BULBS	1	Haemanthus albiflos	Rimmer deVries	\N	\N	\N	Small bulbs
BX 427	BULBS	2	Phaedranassa dubia	Rimmer deVries	seedlings started Jan 2017- about 3/4 inch size- pod parent was Ph. dubia from Telos, pollen parent was Ph dubia Ornduff 9674 Imbabua, Ecuador	\N	\N	Seedlings
BX 427	BULBS	3	Tulbaghia acutiloba	Rimmer deVries	started in March 2016 palish pink purple color. (ONLY 2)	\N	\N	Robust seedlings
BX 427	BULBS	4	Nothoscordum dialystemon	Rimmer deVries	Nothoscordum (Ipheion) dialystemon (8 tepals).	\N	\N	Small offset bulblets
BX 431	BULBS	8	Haemanthus albiflos	Rimmer deVries	3-yr old seedling bulbs	\N	\N	Seedling bulbs
BX 438	BULBS	14	Phaedranassa cinerea	Rimmer deVries	F2 seedlings ex Mary Sue Ittner BX 347	\N	\N	\N
BX 438	BULBS	15	Phaedranassa dubia	Rimmer deVries	ex. Telos x P. sp. (dubia?) ex Ornduff 9674 Imbabua, Ecuador - seedlings	\N	\N	\N
BX 444	SEEDS	4	Zephyranthes katherina	Rimmer deVries	rubrum	\N	\N	\N
BX 444	SEEDS	5	Zephyranthes 'Pink Beauty'	Rimmer deVries	ex Ina C.	\N	\N	\N
BX 444	SEEDS	6	Zephyranthes primulina	Rimmer deVries	ex L. Mackula	\N	\N	\N
BX 444	SEEDS	7	Zephyranthes primulina	Rimmer deVries	ex Uli Urban	\N	\N	\N
BX 449	SEEDS	10	Habranthus magnoi	Rimmer deVries	seed ex Ina C.	\N	\N	\N
BX 449	BULBS	11	Pelargonium alchemilloides	Rimmer deVries	seedlings	\N	\N	Seedlings
BX 451	BULBS	26	Albuca sp.	Rimmer deVries	\N	\N	\N	\N
BX 451	BULBS	27	Othonna sp.	Rimmer deVries	\N	\N	\N	\N
BX 451	BULBS	28	Hippeastrum blossfeldiae	Rimmer deVries	\N	\N	\N	\N
BX 451	BULBS	29	Hippeastrum striatum 'Cianorte'	Rimmer deVries	JES2146	\N	\N	\N
BX 451	BULBS	30	Phaedranassa viridiflora	Rimmer deVries	ex Telos	\N	\N	\N
BX 451	BULBS	31	Hippeastrum papilio	Rimmer deVries	\N	\N	\N	\N
BX 451	BULBS	32	Caliphruria subedentata	Rimmer deVries	\N	\N	\N	\N
BX 452	BULBS	7	Pelargonium aridum	Rimmer deVries	\N	\N	\N	\N
BX 452	BULBS	8	Lachenalia aloides	Rimmer deVries	\N	\N	\N	\N
BX 452	BULBS	9	Lachenalia mutabilis	Rimmer deVries	\N	\N	\N	\N
BX 452	SEEDS	10	Clivia miniata 'Sahin Twin'	Rimmer deVries	seed - red	\N	\N	\N
BX 452	SEEDS	11	Strumaria truncata	Rimmer deVries	seed	\N	\N	\N
BX 454	SEEDS	1	Clivia 'Sahin Yellow'	Rimmer deVries	seeds- always produces yellow seedlings	\N	\N	\N
BX 454	SEEDS	2	Clivia 'Sahin Treasure Chest'	Rimmer deVries	seeds - can be yellow, red, orange, peach, etc.	\N	\N	\N
BX 454	SEEDS	3	Clivia 'Vivo Yellow' x 'Solomon Yellow'	Rimmer deVries	- ex Jim Shields	\N	\N	\N
BX 454	SEEDS	4	Haemanthus albiflos	Rimmer deVries	seed	\N	\N	\N
BX 457	BULBS	2	Clinanthus incarnatus	Rimmer deVries	- red	\N	\N	\N
BX 462	SEEDS	20	Zephyranthes mesochloa	Rimmer deVries	\N	\N	\N	\N
BX 462	SEEDS	21	Zephyranthes dichromantha	Rimmer deVries	\N	\N	\N	\N
BX 462	SEEDS	22	Zephyranthes primulina	Rimmer deVries	\N	\N	\N	\N
BX 462	SEEDS	23	Zephyranthes minuta	Rimmer deVries	\N	\N	\N	\N
BX 462	SEEDS	24	Zephyranthes 'Pink Beauty'	Rimmer deVries	\N	\N	\N	\N
BX 462	SEEDS	25	Zephyranthes macrosiphon	Rimmer deVries	\N	\N	\N	\N
BX 462	SEEDS	26	Habranthus tubispathus	Rimmer deVries	\N	\N	\N	\N
BX 462	SEEDS	27	Zephyranthes x	Rimmer deVries	floryi	\N	\N	\N
BX 463s	SEEDS	11	Alluim subhirsutum	Rimmer deVries	potentially invasive	\N	\N	\N
BX 463s	SEEDS	12	Allium 'cheolutum'	Rimmer deVries	 'cheolutum' (sp?)	\N	\N	\N
BX 463s	SEEDS	13	Allium subhirsutum	Rimmer deVries	potentially invasive	\N	\N	\N
BX 463s	SEEDS	14	Allium w	Rimmer deVries	Allium w?	\N	\N	\N
BX 463s	SEEDS	17	Anthericum liliago	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	18	Anticlea elegans	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	20	Babiana rubrocyanea	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	21	Babiana sambucina	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	53	Cyrtanthus brachyscyphus	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	73	Gladiolus caryophyllaceus	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	80	Herbertia lahue	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	81	Hesperantha nuttallii	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	88	Lilium 'Arabian Nights'	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	93	Massonia bredasdorpensis	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	109	Pauridia capensis	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	110	Pelargonium mollicomum	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	113	Ornithogalum candicans	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	123	Sinningia larae	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	124	Sinningia micans	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	125	Sinningia tubiflora	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	126	Sinningia warmingii	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	127	Triteleia hyacinthina	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	129	Triteleia ixioides	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	139	Urginea undulata	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	142	Veltheimia bracteata	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	143	Wachendorfia thyrsiflora	Rimmer deVries	\N	\N	\N	\N
BX 463s	SEEDS	148	Zephyranthes macrosiphon	Rimmer deVries	\N	\N	\N	\N
BX 415	SEEDS	3	Rhodophiala andicola	Rimmer deVries	few	\N	\N	\N
BX 404	SEEDS	25	Hymenocallis maximiliani	Rimmer deVries	(i) ex Telos (distinctly petiolate leaves that are thin in texture with a pronounced mid rib, up to 1.5 inch wide and a little glaucescent) very nice plant about 12 inches tall loves water while in growth, winter dormant/ dry. blooms in mid June in Michigan. Plants form basal offsets. Blooms a week so before the glaucous H. harrisiana (offered by Dutch importers) that has wider tepals. Blooms a full month before the H. leavenworthii offered by Telos (which looks similar but blooms 4-5 weeks later). Flowers similar to those pictured in the PBS wiki http://pacificbulbsociety.org/pbswiki/index.php/Hymenocallis However, leaves and flowers do not match the original description published in (Plant Life 38: 41, 1982) which describes linear or strap like leaves, a flatter staminal cup and narrower tepals. also leaves are much shorter than the 3 foot tall leaves described on the Plant Delights Perennial Encyclopedia for Hymenocallis maximiliani	http://www.plantdelights.com/Hymenocallis-maximiliani-for-sale/Buy-Maximilians-Spider-Lilies/	\N	Seeds
BX 418	BULBS	31	Alocasia hypnosa	Rimmer deVries	several corms ex Arnold Trachtenburg	\N	\N	Corms
BX 379	BULBS	8	Othonna sp.	Rimmer deVries	?	\N	\N	Tubers
BX 376	BULBS	6	Albuca sp.	Rimmer deVries	?, green and white - 1 yr old seedlings grown from PBS seed sale Feb 2014.	\N	\N	\N
BX 384	SEEDS	7	Habranthus sp.	Rimmer deVries	.. came as something else in BX 316 #16- i listed this as H. robustus on the seed packet but i have been told this is not the correct name. these are big plants with big flowers and like lots of water. This is seed from the same plants as BX 382 #15. Please note the correction. These were hardy in a cold frame in Michigan for several years but the plants really took off when I brought the pot inside. Big pink flowers flowers everytime it rains all summer. here is a link to photos of the plant and flowers.	https://flic.kr/s/aHskhHDZN9/ -short lived seed.	\N	Seed
BX 399	BULBS	4	Albuca humilis	Rimmer deVries	ex JCA 15856 Drakensburg Mtns. from NARGS 2012-#83	\N	\N	Small bulbs
BX 399	BULBS	5	Habranthus hyb 'Jumbo Purple'	Rimmer deVries	offsets	\N	\N	\N
BX 399	BULBS	6	Haemanthus pauculifolius	Rimmer deVries	seedlings 2 yrs old	\N	\N	\N
BX 399	SEEDS	7	Clivia 'Sahin Twins'	Rimmer deVries	- deep red with big red berries, 'twins' means in ideal situations it blooms 2x a year.	\N	\N	Seeds
BX 442	SEEDS	19	Sinningia cardinalis	Rimmer deVries	seed	\N	\N	\N
BX 442	SEEDS	20	Sinningia iarae	Rimmer deVries	seed ex. SX 6	\N	\N	\N
BX 442	BULBS	21	Sinningia warmingii	Rimmer deVries	seedlings ex. Dell Sherk	\N	\N	Seedlings
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

