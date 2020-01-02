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
-- Name: scratch; Type: SCHEMA; Schema: -; Owner: gastil
--

CREATE SCHEMA scratch;


ALTER SCHEMA scratch OWNER TO gastil;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: dives; Type: TABLE; Schema: scratch; Owner: gastil
--

CREATE TABLE scratch.dives (
    dive_id character(4) NOT NULL,
    dive_date date
);


ALTER TABLE scratch.dives OWNER TO gastil;

--
-- Name: fish; Type: TABLE; Schema: scratch; Owner: gastil
--

CREATE TABLE scratch.fish (
    dive_id character(4) NOT NULL,
    obs_id integer NOT NULL,
    taxon character(1)
);


ALTER TABLE scratch.fish OWNER TO gastil;

--
-- Name: vw_date_accum_ntaxa; Type: VIEW; Schema: scratch; Owner: gastil
--

CREATE VIEW scratch.vw_date_accum_ntaxa AS
 SELECT d.dive_date,
    count(DISTINCT f.taxon) AS n_taxa
   FROM (scratch.dives d
     JOIN scratch.fish f ON ((d.dive_id >= f.dive_id)))
  GROUP BY d.dive_date
  ORDER BY d.dive_date;


ALTER TABLE scratch.vw_date_accum_ntaxa OWNER TO gastil;

--
-- Data for Name: dives; Type: TABLE DATA; Schema: scratch; Owner: gastil
--

COPY scratch.dives (dive_id, dive_date) FROM stdin;
di01	2019-01-01
di02	2019-01-02
di03	2019-01-03
di04	2019-01-04
di05	2019-01-05
di06	2019-01-06
di07	2019-01-07
di08	2019-01-08
di09	2019-01-09
\.


--
-- Data for Name: fish; Type: TABLE DATA; Schema: scratch; Owner: gastil
--

COPY scratch.fish (dive_id, obs_id, taxon) FROM stdin;
di09	2	a
di01	1	a
di01	2	b
di02	1	c
di02	2	a
di03	1	b
di03	2	d
di03	3	a
di04	1	e
di04	2	f
di04	3	b
di04	4	c
di04	5	g
di05	1	a
di05	2	h
di06	1	d
di07	1	i
di07	2	c
di08	1	j
di09	1	b
\.


--
-- Name: dives dives_pk; Type: CONSTRAINT; Schema: scratch; Owner: gastil
--

ALTER TABLE ONLY scratch.dives
    ADD CONSTRAINT dives_pk PRIMARY KEY (dive_id);


--
-- Name: fish fish_pk; Type: CONSTRAINT; Schema: scratch; Owner: gastil
--

ALTER TABLE ONLY scratch.fish
    ADD CONSTRAINT fish_pk PRIMARY KEY (dive_id, obs_id);


--
-- PostgreSQL database dump complete
--

