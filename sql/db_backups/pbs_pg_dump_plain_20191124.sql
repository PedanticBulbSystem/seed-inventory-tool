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
    season character varying(100)
);


ALTER TABLE bx.bx_items OWNER TO gastil;

--
-- Data for Name: bx_dates; Type: TABLE DATA; Schema: bx; Owner: gastil
--

COPY bx.bx_dates (bx_id, date_open, date_close, director_initials) FROM stdin;
\.


--
-- Data for Name: bx_items; Type: TABLE DATA; Schema: bx; Owner: gastil
--

COPY bx.bx_items (bx_id, category, item, taxon, donor, notes, photo_link, season) FROM stdin;
BX 301	SEEDS	1	Haemanthus albiflos	Richard Hart	\N	\N	\N
BX 301	BULBS	2	Nerine laticoma	Ellen Hornig	\N	\N	\N
BX 301	BULBS	3	Talinum paniculatum	Pam Slate	small tubers	\N	\N
BX 301	BULBS	4	Albuca nelsonii	Pam Slate	\N	\N	\N
BX 301	BULBS	5	mixed zephyranthes	Pam Slate	\N	\N	\N
BX 301	SEEDS	6	Nothoscordum bivalve (few)	Jerry Lehmann	\N	\N	\N
BX 301	SEEDS	7	Iris versicolor, collected in Two Inlets, MN	Jerry Lehmann	\N	\N	\N
BX 301	SEEDS	8	Anemone virginica and/or A. cylindrica "Thimbleweed"	Jerry Lehmann	collected in Becker Co., MN	\N	\N
BX 301	SEEDS	9	Liatris 'Kobold' in bloom at the same time as L. spicata 'Alba'	Jerry Lehmann	\N	\N	\N
BX 301	SEEDS	10	Liatris spicata 'Alba', ditto	Jerry Lehmann	\N	\N	\N
BX 301	SEEDS	11	Aster macrophyllus	Jerry Lehmann	\N	\N	\N
BX 301	BULBS	12	Ornithogalum caudatum (longibracteatum), mix of two forms,	Jerry Lehmann	Bulblets, one with rounder, more green leaves	\N	\N
BX 301	BULBS	13	Small Bessera elegans	Jerry Lehmann	\N	\N	\N
BX 301	SEEDS	14	Habranthus tubispathus var roseus	Ina Crossley	\N	\N	\N
BX 301	SEEDS	15	Zephyranthes verecunda white	Ina Crossley	\N	\N	\N
BX 301	SEEDS	16	Zephyranthes verecunda rosea	Ina Crossley	\N	\N	\N
BX 301	SEEDS	17	Zephyranthes drummondii	Ina Crossley	\N	\N	\N
BX 301	SEEDS	18	Hippeastrum calyptratum	David Boucher	\N	\N	\N
BX 301	SEEDS	19	Anchomanes difformis var welwitschii, a close relative of	David Boucher	Amorphophallus from Africa. Has spines, but most of the stink is not present	\N	\N
BX 302	BULBS	1	Amorphophallus albus	Bonaventure Magrys	Small tubers	\N	\N
BX 302	BULBS	2	Amorphophallus bulbifer	Bonaventure Magrys	Small tubers	\N	\N
BX 302	SEEDS	3	Larsenianthus careyanus (Zingiberaceae)	Fred Thorne	\N	\N	\N
BX 302	SEEDS	4	Ennealophus euryandrus	Lee Poulsen	\N	\N	\N
BX 302	SEEDS	5	Cypella peruviana	Lee Poulsen	\N	\N	\N
BX 302	SEEDS	6	Cypella coelestis	Lee Poulsen	\N	\N	\N
BX 302	BULBS	7	Small bulbs of Ipheion sessile	Lee Poulsen	Small bulbs	\N	\N
BX 302	SEEDS	8	Bowiea volubilis	Kipp McMichael	\N	\N	\N
BX 302	SEEDS	9	Habranthus tubispathus rosea	Ina Crossley	\N	\N	\N
BX 302	SEEDS	10	Zephyranthes 'Hidalgo'	Ina Crossley	\N	\N	\N
BX 302	SEEDS	11	Zephyranthes drummondii	Ina Crossley	\N	\N	\N
BX 302	SEEDS	12	Zephyranthes lindleyana (morrisclintii)	Ina Crossley	\N	\N	\N
BX 302	SEEDS	13	Zephyranthes primulina	Ina Crossley	\N	\N	\N
BX 302	SEEDS	14	Zephyranthes verecunda rosea	Ina Crossley	\N	\N	\N
BX 302	SEEDS	15	Freesia laxa, blue	Mary Gastil-Buhl	\N	\N	\N
BX 302	BULBS	16	Freesia laxa, pale lavender blue	Mary Gastil-Buhl	Corms/cormels	\N	\N
BX 302	SEEDS	17	Biophytum sensitivum (Oxalidaceae)	Dennis Kramb	\N	\N	\N
BX 302	SEEDS	18	Gloxinella lindeniana (Gesneriaceae)	Dennis Kramb	\N	\N	\N
BX 302	SEEDS	19	Primulina tamiana (Gesneriaceae), formerly Chirita tamiana	Dennis Kramb	\N	\N	\N
BX 302	SEEDS	20	Hesperantha coccinea 'Oregon Sunset'	Randy Linke	\N	\N	\N
BX 302	SEEDS	21	Dietes grandiflora	Mary Sue Ittner	evergreen, long blooming in mild climates in a sunny location	\N	\N
BX 302	SEEDS	22	Hesperoxiphion peruvianum	Mary Sue Ittner	summer growing, fall blooming for me. This plant has a spectacular flower, but each flower is very short lived opening in the am and fading before the day is over (faster on This plant has a spectacular flower, but each flower is very short).  This plant has a spectacular flower, but each flower is very short	\N	\N
BX 302	SEEDS	23	Moraea polystachya	Mary Sue Ittner	winter growing, long season of bloom in fall, best with some water during dormancy	\N	\N
BX 303	BULBS	1	Alocasia X Mark Campbell	Jude Platteborze	Tubers various sizes	\N	\N
BX 303	SEEDS	2	Hippeastrum nelsonii	Stephen Putman	(LIMITED SUPPLY)	\N	\N
BX 303	BULBS	3	Ledebouria cooperi	Monica Swartz	ex BX 169	\N	\N
BX 303	SEEDS	4	Ornithogalum glandulosum	Monica Swartz	ex Jim Duggan Flower Nursery	\N	\N
BX 303	SEEDS	5	Chlorophytum orchidantheroides or amaniense	Monica Swartz	Yes the Chlorophytum is geophytic. They have big fat storage roots and some individuals die back to the ground in winter. I recommend that this species NOT be grown in frost free areas because it is very fecund and could become invasive. Sow seeds thinly because most seeds germinate and since most of the plant is below ground, the pot will get too crowded very fast. The flashy orange leaf bases will develop after the first year.	\N	\N
BX 303	SEEDS	6	Boophane disticha	Fereydoun Sharifi	\N	\N	\N
BX 303	SEEDS	7	Boophane haemanthoides	Fereydoun Sharifi	\N	\N	\N
BX 303	SEEDS	8	Brunsvigia radulosa	Fereydoun Sharifi	\N	\N	\N
BX 303	SEEDS	9	Calydorea amabilis	Fereydoun Sharifi	\N	\N	\N
BX 303	SEEDS	10	Ceropegia ampliata (Asclepidaceae)	Fereydoun Sharifi	\N	\N	\N
BX 303	SEEDS	11	Ceropegia macmasteri	Fereydoun Sharifi	\N	\N	\N
BX 303	SEEDS	12	Cipura paludosa	Fereydoun Sharifi	\N	\N	\N
BX 303	SEEDS	13	Cyclamen graecum anatolicum	Fereydoun Sharifi	\N	\N	\N
BX 303	SEEDS	14	Cyclamen hederifolium 'Perlenteppich'	Fereydoun Sharifi	\N	\N	\N
BX 303	SEEDS	15	Cyclamen x hildebrandtii	Fereydoun Sharifi	\N	\N	\N
BX 303	SEEDS	16	Cyrtanthus falcatus	Fereydoun Sharifi	\N	\N	\N
BX 303	SEEDS	17	Cyrtanthus galpinii	Fereydoun Sharifi	\N	\N	\N
BX 303	SEEDS	18	Diplarrhena moraea	Fereydoun Sharifi	\N	\N	\N
BX 303	SEEDS	19	Gladiolus miniatus	Fereydoun Sharifi	\N	\N	\N
BX 303	SEEDS	20	Gladiolus sericeo-villosus	Fereydoun Sharifi	\N	\N	\N
BX 303	SEEDS	21	Gladiolus vandermerwei	Fereydoun Sharifi	\N	\N	\N
BX 303	SEEDS	22	Iris (Juno) albomarginata	Fereydoun Sharifi	\N	\N	\N
BX 303	SEEDS	23	Iris (Juno) aucheri, white and dark	Fereydoun Sharifi	\N	\N	\N
BX 303	SEEDS	24	Iris (Juno) zenaidae	Fereydoun Sharifi	\N	\N	\N
BX 303	SEEDS	25	Narcissus miniatus	Fereydoun Sharifi	ex Seville, Spain	\N	\N
BX 303	SEEDS	26	Scadoxus puniceus	Fereydoun Sharifi	\N	\N	\N
BX 303	SEEDS	27	Zephyra elegans	Fereydoun Sharifi	\N	\N	\N
BX 304	BULBS	1	Crinum 'digweedii'	Mark Lysne	\N	\N	\N
BX 304	BULBS	2	Crinum 'Purple Prince'	Mark Lysne	\N	\N	\N
BX 304	BULBS	3	Hymenocallis probably 'Tropical Giant'	Mark Lysne	\N	\N	\N
BX 304	SEEDS	4	Zephyranthes dichromantha	Ina Crossley	\N	\N	\N
BX 304	SEEDS	5	Zephyranthes 'Hidalgo'	Ina Crossley	\N	\N	\N
BX 304	SEEDS	6	Zephyranthes "Hidalgo 'John Fellers'"	Ina Crossley	\N	\N	\N
BX 304	SEEDS	7	Zephyranthes primulina	Ina Crossley	\N	\N	\N
BX 304	SEEDS	8	Habranthus robusta 'Russell Manning'	Ina Crossley	\N	\N	\N
BX 304	SEEDS	9	Zephyranthes citrina	Ina Crossley	\N	\N	\N
BX 304	SEEDS	10	Zephyranthes flavissima	Ina Crossley	\N	\N	\N
BX 304	SEEDS	11	Zephyranthes drummondii	Ina Crossley	\N	\N	\N
BX 304	BULBS	12	Rhizomes of Achimenes erecta	Dennis Kramb	\N	\N	\N
BX 304	BULBS	13	Rhizomes of Diastema vexans	Dennis Kramb	\N	\N	\N
BX 304	BULBS	14	Rhizomes of Gloxinella lindeniana	Dennis Kramb	\N	\N	\N
BX 304	SEEDS	15	Seeds of Gloxinella lindeniana	Dennis Kramb	\N	\N	\N
BX 304	BULBS	16	Achimenes 'Desiree'	Dennis Kramb	Propagules (aerial rhizomes)	\N	\N
BX 304	BULBS	17	Eucrosia bicolor	Monica Swartz	Small bulbs	\N	\N
BX 304	SEEDS	18	Agapanthus campanulatus	PBS	\N	\N	\N
BX 304	SEEDS	19	Cyrtanthus epiphyticus	PBS	\N	\N	\N
BX 304	SEEDS	20	Dierama trichorhizum?	PBS	\N	\N	\N
BX 304	SEEDS	21	Dierama dracomontanum	PBS	\N	\N	\N
BX 304	SEEDS	22	Kniphofia ichopensis	PBS	\N	\N	\N
BX 304	SEEDS	23	Kniphofia ritualis	PBS	\N	\N	\N
BX 305	BULBS	1	Ledebouria cooperi	Mary Sue Ittner	a small summer grower from South Africa	\N	\N
BX 305	BULBS	2	Oxalis sp.	Mary Sue Ittner	from Ul. collected in Oaxaca, Mexico. It is summer growing and blooming	\N	\N
BX 305	BULBS	3	Polianthes gemiflora	Mary Sue Ittner	syn Bravoa geminiflora - summer growing and flowering	\N	\N
BX 305	BULBS	4	Zephyranthes candida	Jim Waddick	This is the starter drug for Rain lily fans. Among the easiest, most vigorous and available of all rain lilies. Single white 6 petal flowers appear by 'magic' during and after summer rain. Very easy. Hrdiness? Zone 6/7	\N	\N
BX 305	BULBS	5	Oxalis tetraphylla 'Iron Cross'	Nhu Nguyen	this is one of those widespread plants with nice leaves and prolific flowers. It is larger so it can be grown in the ground with other landscaping plants. It doesn't mind winter water as long as the media is really well drained.	\N	\N
BX 305	BULBS	6	Gladiolus dalenii	Nhu Nguyen	grown from seeds, 2 years old	\N	\N
BX 305	BULBS	7	Tigridia pavonia	Nhu Nguyen	typical red/orange form, grown from seeds, 2 years old, should bloom in the 3rd or 4th year.	\N	\N
BX 305	SEEDS	8	Cyrtanthus galpinii	Nhu Nguyen	wild collected seeds from KwaZulu-Natal South Africa	\N	\N
BX 305	SEEDS	9	Melasphaerula ramosa	Nhu Nguyen	I got these from a friend but I already have some so I'm passing them on.	\N	\N
BX 305	SEEDS	10	Triteleia clementina	Nhu Nguyen	\N	\N	\N
BX 305	SEEDS	11	Lapeirousia aff. jacquinii	Nhu Nguyen	\N	\N	\N
BX 305	SEEDS	12	Hesperoxiphion peruvianum	Nhu Nguyen	\N	\N	\N
BX 305	SEEDS	13	Calochortus catalinae	Bob Werra	\N	\N	\N
BX 305	SEEDS	14	Moraea ciliate, blue	Bob Werra	\N	\N	\N
BX 305	SEEDS	15	Moraea macrocarpa	Bob Werra	\N	\N	\N
BX 305	SEEDS	16	Moraea pendula	Bob Werra	\N	\N	\N
BX 305	SEEDS	17	Moraea polyanthus	Bob Werra	\N	\N	\N
BX 305	SEEDS	18	Moraea tripetala	Bob Werra	\N	\N	\N
BX 305	SEEDS	19	Moraea vegeta	Bob Werra	\N	\N	\N
BX 305	SEEDS	20	Moraea vespertina	Bob Werra	\N	\N	\N
BX 305	SEEDS	21	Romulea grandiscapa	Bob Werra	? uncertain	\N	\N
BX 307	SEEDS	1	Hippeastrum striatum	Stephen Putman	\N	\N	\N
BX 307	SEEDS	2	Aristea ecklonii	SIGNA	The following seeds were donated by the Species Iris Group of North America	\N	\N
BX 307	SEEDS	3	Babiana, mixed	SIGNA	\N	\N	\N
BX 307	SEEDS	4	Cipura paludosa	SIGNA	\N	\N	\N
BX 307	SEEDS	5	Crocus versicolor	SIGNA	\N	\N	\N
BX 307	SEEDS	6	Cypella herbertii	SIGNA	\N	\N	\N
BX 307	SEEDS	7	Dietes grandiflora	SIGNA	\N	\N	\N
BX 307	SEEDS	9	Dietes iridioides	SIGNA	\N	\N	\N
BX 307	SEEDS	10	Gladiolus tristis	SIGNA	\N	\N	\N
BX 307	SEEDS	11	Moraea huttonii	SIGNA	\N	\N	\N
BX 307	SEEDS	12	Moraea polystachya	SIGNA	\N	\N	\N
BX 307	SEEDS	13	Moraea setifolia	SIGNA	\N	\N	\N
BX 307	SEEDS	14	Moraea vegeta	SIGNA	\N	\N	\N
BX 307	SEEDS	15	Sisyrinchium angustifolium	SIGNA	\N	\N	\N
BX 307	SEEDS	16	Sisyrinchium bermudianum	SIGNA	\N	\N	\N
BX 307	SEEDS	17	Sisyrinchium idahoense	SIGNA	\N	\N	\N
BX 307	SEEDS	18	Sparaxis caryophyllacea	SIGNA	\N	\N	\N
BX 307	SEEDS	19	Sparaxis tricolor	SIGNA	\N	\N	\N
BX 308	SEEDS	1	Massonia depressa	From Sophie Dixon:	\N	\N	\N
BX 308	SEEDS	2	Clivia miniata, yellow hybrids	From Peter Taggart:	\N	\N	\N
BX 308	SEEDS	3	Fritillaria pallida	From Peter Taggart:	\N	\N	\N
BX 308	SEEDS	4	Fritillaria sewerzowi	From Peter Taggart:	\N	\N	\N
BX 308	SEEDS	5	Iris magnifica	From Peter Taggart:	ex Agalik	\N	\N
BX 308	SEEDS	6	Iris Pacific Coast hybrids	From Peter Taggart:	\N	\N	\N
BX 308	SEEDS	7	Corydalis	From Peter Taggart:	Leontocoides section, probably C. popovii or else mixed hybrids including genes from popovii, maracandica, and ledbouriana. Fresh seed which should be sown as quickly as possible	\N	\N
BX 308	SEEDS	8	Tulipa binutans	From Peter Taggart:	(OP) ex Ruksans	\N	\N
BX 308	SEEDS	9	Tulipa ferghanica	From Peter Taggart:	? (OP)	\N	\N
BX 308	SEEDS	10	Tulipa biebersteiniana	From Peter Taggart:	(OP)	\N	\N
BX 308	SEEDS	11	Tulipa turkestanica	From Peter Taggart:	(OP)	\N	\N
BX 308	SEEDS	12	Tulipa kolpakowskiana	From Peter Taggart:	(OP)	\N	\N
BX 308	SEEDS	13	Tulipa sprengeri	From Peter Taggart:	(OP), goes very deep and will grow on acid sand	\N	\N
BX 308	SEEDS	14	Tulipa vvedenskyi	From Peter Taggart:	(OP)	\N	\N
BX 308	SEEDS	15	Tulipa vvedenskyi	From Peter Taggart:	(OP) large form	\N	\N
BX 308	SEEDS	16	Paeonia mascula	From Peter Taggart:	?	\N	\N
BX 308	BULBS	17	Nothoscordum bivalve	From Peter Taggart:	BULBILS	\N	\N
BX 308	BULBS	18	Triteleia hyacinthina	From Peter Taggart:	BULBILS	\N	\N
BX 308	BULBS	19	Achimenes grandiflora ‘Robert Dressler’	From Lynn Makela:	\N	\N	\N
BX 308	BULBS	20	Achimenes ‘Pink Cloud’	From Lynn Makela:	\N	\N	\N
BX 308	BULBS	21	Eucodonia verticillata	From Lynn Makela:	\N	\N	\N
BX 308	BULBS	22	Sinningia amambayensis	From Lynn Makela:	\N	\N	\N
BX 308	BULBS	23	Crinum `menehume'	From Lynn Makela:	(C. oliganthum x C. procerum)? 2', red leaves, pink flowers, Z 8b. "I grow it in full sun with average water. A very nice plant that can be grown in bog conditions" FEW	\N	\N
BX 308	BULBS	24	Hippeastrum 'San Antonio Rose'	From Lynn Makela:	\N	\N	\N
BX 308	BULBS	25	Nothoscordum felippenei	From Lynn Makela:	\N	\N	\N
BX 308	BULBS	26	Onixotis stricta	From Lynn Makela:	\N	\N	\N
BX 308	BULBS	27	Oxalis goniorhiza	From Lynn Makela:	VERY FEW	\N	\N
BX 309	BULBS	1	Drimiopsis maculata	From Roy Herold:	Offsets and near-blooming size.	\N	\N
BX 309	BULBS	2	Drimiopsis kirkii	From Roy Herold:	Offsets and near-blooming size.	\N	\N
BX 309	SEEDS	3	Eucomis zambesiaca	From Roy Herold:	outside chance some are crossed with E. vandermervii.	\N	\N
BX 309	SEEDS	4	Ophiopogon umbraticola	From Roy Herold:	received as O. chingii, new ID by Mark McDonough. Berries have been left uncleaned so you can admire the iridescent blue color. Clean before planting.	\N	\N
BX 309	SEEDS	5	Clivia 'Anna's Yellow'	From Roy Herold:	OP; from the magnificent garden of my wife's aunt in Hilton, KZN.	\N	\N
BX 309	BULBS	6	Clivia 'Shortleaf Yellow x Shortleaf Yellow' OP	From Roy Herold:	OP; from seedlings grown from Nakamura seed by Matt Mattus and Joe Philip.	\N	\N
BX 309	BULBS	7	Clivia 'Monk x Daruma' OP	From Roy Herold:	OP; from seedlings grown from Nakamura seed by Matt Mattus and Joe Philip.	\N	\N
BX 309	BULBS	8	Clivia 'Multipetal x Self'	From Roy Herold:	OP--this one tends to throw interesting crested offsets. from seedlings grown from Nakamura seed by Matt Mattus and Joe Philip.	\N	\N
BX 309	BULBS	9	Gladiolus flanaganii	Paul Otto	Small corms	\N	\N
BX 309	SEEDS	10	Seed of Bomarea sp. (acutifolia?)	From Max Withers:	ex Nhu Nguyen OP, probably selfed	\N	\N
BX 309	SEEDS	11	Brachylaena discolor	From Roland de Boer:	(only one order of each)	\N	\N
BX 309	SEEDS	12	Dietes butcheriana	From Roland de Boer:	(only one order of each)	\N	\N
BX 309	SEEDS	13	Eucomis, mixed spp	From Roland de Boer:	(only one order of each)	\N	\N
BX 309	SEEDS	14	Kniphofia uvaria	From Roland de Boer:	(only one order of each)	\N	\N
BX 309	SEEDS	15	Monopsis lutea	From Roland de Boer:	(only one order of each)	\N	\N
BX 309	SEEDS	16	Polyxena ensifolia var ensifolia	From Roland de Boer:	(only one order of each)	\N	\N
BX 309	SEEDS	17	Gentiana flavida	From Roland de Boer:	(more than one order available)	\N	\N
BX 309	SEEDS	18	Aeonium hierrense	From Roland de Boer:	(more than one order available)	\N	\N
BX 309	SEEDS	19	Colchicum corsicum ?	From Roland de Boer:	(more than one order available)	\N	\N
BX 309	SEEDS	20	Galanthus reginae-olgae ssp reginae-olgae ex Sicily	From Roland de Boer:	(more than one order available)	\N	\N
BX 309	SEEDS	21	Polygonatum alte-lobatum	From Roland de Boer:	(more than one order available)	\N	\N
BX 310	SEEDS	1	Hippeastrum striatum	From Jim Jones:	\N	\N	\N
BX 310	SEEDS	2	Narcissus 'Nylon'	From Jim Jones:	\N	\N	\N
BX 310	SEEDS	3	Hippeastrum papilio	From Marvin Ellenbecker:	\N	\N	\N
BX 310	SEEDS	4	Gladiolus dalenii	From Jonathan Lubar:	\N	\N	\N
BX 310	SEEDS	5	Freesia laxa, blue	From Jonathan Lubar:	\N	\N	\N
BX 310	BULBS	6	Oxalis hirta	From Jonathan Lubar:	\N	\N	\N
BX 310	BULBS	7	Neomarica gracilis	From Dell Sherk:	\N	\N	\N
BX 310	BULBS	8	Agapanthus	From Fred Biasella:	light blue, dwarf form	\N	\N
BX 310	BULBS	9	Hymenocallis	From Fred Biasella:	Small bulbs of Hymenocallis (Ismene), fragrant white flowers, "Peruvian daffodil"	\N	\N
BX 310	BULBS	10	Eucomis comosa	From Fred Biasella:	white/green flowers, coconut fragrance	\N	\N
BX 310	BULBS	11	Cyranthus mackenii	From Fred Biasella:	Small bulbs, yellow	\N	\N
BX 313	SEEDS	1	Allium christophii	Gordon Julian	\N	\N	\N
BX 313	SEEDS	2	Arthropodium candidum 'Bronze'	Gordon Julian	\N	\N	\N
BX 313	SEEDS	3	Arum creticum	Gordon Julian	\N	\N	\N
BX 313	SEEDS	4	Arum purpureospathum	Gordon Julian	\N	\N	\N
BX 313	SEEDS	5	Babiana stricta hybrids	Gordon Julian	\N	\N	\N
BX 313	SEEDS	6	Colchicum corsicum	Gordon Julian	\N	\N	\N
BX 313	SEEDS	7	Cyclamen coum ex CSE	Gordon Julian	\N	\N	\N
BX 313	SEEDS	8	Cyclamen graecum	Gordon Julian	\N	\N	\N
BX 313	SEEDS	9	Cyclamen hederifolium	Gordon Julian	\N	\N	\N
BX 313	SEEDS	10	Cyclamen libanoticum	Gordon Julian	\N	\N	\N
BX 313	SEEDS	11	Cyclamen persicum	Gordon Julian	\N	\N	\N
BX 313	SEEDS	12	Cyclamen purpurascens	Gordon Julian	\N	\N	\N
BX 313	SEEDS	13	Dierama pulcherrimum purple form	Gordon Julian	\N	\N	\N
BX 313	SEEDS	14	Dierama trichorrhizum	Gordon Julian	\N	\N	\N
BX 313	SEEDS	15	Fritillaria acmopetala	Gordon Julian	\N	\N	\N
BX 313	SEEDS	16	Fritillaria affinis	Gordon Julian	\N	\N	\N
BX 313	SEEDS	17	Fritillaria biflora	Gordon Julian	\N	\N	\N
BX 313	SEEDS	18	Galtonia candicans	Gordon Julian	\N	\N	\N
BX 313	SEEDS	19	Galtonia regalis	Gordon Julian	\N	\N	\N
BX 313	SEEDS	20	Gladiolus carneus	Gordon Julian	\N	\N	\N
BX 313	SEEDS	21	Gladiolus geardii	Gordon Julian	\N	\N	\N
BX 313	SEEDS	22	Gladiolus oppositiflorus ssp.salmonoides	Gordon Julian	\N	\N	\N
BX 313	SEEDS	23	Gladiolus tristis	Gordon Julian	First item #23	\N	\N
BX 313	SEEDS	23.0001	Tigridia pavonia mixed	Gordon Julian	Second item #23	\N	\N
BX 313	SEEDS	24	Veltheimia bracteata, soft pink color	Gordon Julian	\N	\N	\N
BX 313	SEEDS	25	Griffinia espiritensis var. espiritensis	Dave Boucher	\N	\N	\N
BX 313	SEEDS	26	Hippeastrum brasilianum	Dave Boucher	\N	\N	\N
BX 315	SEEDS	1	Ammocharis tinneana	Lee Poulsen	AMARYLLIDS: (LIMITED SUPPLIES)	\N	\N
BX 315	SEEDS	2	Brunsvigia littoralis	Lee Poulsen	AMARYLLIDS: (LIMITED SUPPLIES)	\N	\N
BX 315	SEEDS	3	Gethyllis villosa	Lee Poulsen	AMARYLLIDS: (LIMITED SUPPLIES)	\N	\N
BX 315	SEEDS	4	Haemanthus nortieri	Lee Poulsen	AMARYLLIDS: (LIMITED SUPPLIES)	\N	\N
BX 315	SEEDS	5	Nerine laticoma	Lee Poulsen	AMARYLLIDS: (LIMITED SUPPLIES)	\N	\N
BX 315	SEEDS	6	Strumaria discifera, ex Nieuwoudtville	Lee Poulsen	AMARYLLIDS: (LIMITED SUPPLIES)	\N	\N
BX 315	SEEDS	7	Baeometra uniflora	Lee Poulsen	\N	\N	\N
BX 315	SEEDS	8	Lapeirousia enigmata	Lee Poulsen	\N	\N	\N
BX 315	SEEDS	9	Nothoscordum montevidense	Lee Poulsen	few	\N	\N
BX 315	SEEDS	10	Tropaeolum azureum	Lee Poulsen	(few)	\N	\N
BX 316	SEEDS	1	Crinum bulbispermum	Jay Yourch	all from Jumbo selections. Very cold hardy.	\N	\N
BX 314	BULBS	25	Habranthus magnoi	Pam Slate	\N	\N	\N
BX 314	BULBS	26	Oxalis stenorhyncha	Pam Slate	\N	\N	\N
BX 314	BULBS	27	Oxalis regnellii	Pam Slate	\N	\N	\N
BX 317	SEEDS	1	Albuca spiralis	Nhu Nguyen	tight curly form, OP	http://flickr.com/photos/xerantheum/…	\N
BX 316	BULBS	2	Crinum bulbispermum 'Wide Open White' x C. 'Spring Joy'	Jay Yourch	from crosses which I made in 2006. Their flowers are variable, showing the diversity of genes present in their parents. They should be very cold hardy, likely doing well into zone 6. They start flowering before any other Crinum in my garden, usually April here in central North Carolina, although they got started in March this year and continued into June. There are bulbs with white flowers and bulbs with pale pink flowers, and they are labeled.hey are labeled.	\N	\N
BX 316	BULBS	3	Crinum pedunculatum	Jay Yourch	Fairly tender, Zone 8, but does well in colder areas if grown in a large container and protected from freezing temperatures. A greenhouse is not required, my spends each winter in a cool garage (above freezing) and looks nearly as good in early spring as it did the previous autumn. While I enjoy its spidery, white flowers, Isenjoy its architectural foliage even more.	\N	\N
BX 316	BULBS	4	Cyrtanthus loddigesianus	Terry Laskiewicz	clear pink, original seed from SGRC. Plant immediately.	\N	\N
BX 316	BULBS	5	Hyacinthoides lingulata	Terry Laskiewicz	fall blooming, "perfect leaves"	\N	\N
BX 316	BULBS	6	Notholirion thompsonianum	Terry Laskiewicz	from Jane McGary	\N	\N
BX 306	SEEDS	1	Nerine rehmannii	Pieter van der Walt	W/C Johannesburg, Gauteng	\N	\N
BX 306	SEEDS	2	Moraea stricta	Pieter van der Walt	W/C Broederstroom, Gauteng	\N	\N
BX 306	SEEDS	3	Schizochillus nervosa (Syn. Scilla nervosa)	Pieter van der Walt	W/C Broederstroom, Gauteng	\N	\N
BX 306	SEEDS	4	Xerophyta retinervis	Pieter van der Walt	W/C Muldersdrift, Gauteng	\N	\N
BX 306	SEEDS	5	Asclepidaceae sp.	Pieter van der Walt	W/C Malolotja, Swaziland (Flowers not seen)	\N	\N
BX 306	SEEDS	6	Adenium swazicum	Pieter van der Walt	Ex Hort.	\N	\N
BX 306	BULBS	7	Polianthes x bundrantii	Jim Waddick	See Polianthes wiki page. These are offsets from mature blooming bulbs and few will bloom soon, others take a bit. An interesting cross with tall spikes of tubular red-pink flowers. No scent. I keep them almost totally dry all winter in cool storage indoors here.	\N	\N
BX 306	BULBS	8	Sprekelia formosissima	Jim Waddick	See Sprekelia wiki page. These are a mix of two clones mostly the typical and a couple 'Orient Red'. Both bloom and get treated like typical Hippeastrum cvs.	\N	\N
BX 306	SEEDS	10	Haemanthus humilis	PBS	red stem	\N	\N
BX 306	SEEDS	11	Haemanthus humilis	PBS	yellow throat	\N	\N
BX 306	SEEDS	12	Nerine laticoma	PBS	short stem	\N	\N
BX 306	SEEDS	13	Nerine laticoma	PBS	with red stripe	\N	\N
BX 306	SEEDS	14	Scadoxus puniceus	PBS	light pink	\N	\N
BX 306	SEEDS	15	Scadoxus puniceus	PBS	dark pink stripe	\N	\N
BX 306	BULBS	16	Rhizomes of Achimenes	From Joyce Miller:	mixed	\N	\N
BX 314	BULBS	1	Oxalis callosa	Mary Sue Ittner	Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers).	\N	w
BX 314	BULBS	2	Oxalis commutata	Mary Sue Ittner	Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers).	\N	w
BX 314	BULBS	3	Oxalis depressa MV4871	Mary Sue Ittner	Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers).	\N	w
BX 314	BULBS	4	Oxalis engleriana	Mary Sue Ittner	Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers).	\N	w
BX 314	BULBS	5	Oxalis fabaefolia	Mary Sue Ittner	(Christiaan says this is now considered a form of flava) Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers).	\N	w
BX 314	BULBS	6	Oxalis hirta	Mary Sue Ittner	Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers).	\N	w
BX 314	BULBS	7	Oxalis hirta	Mary Sue Ittner	(mauve form) Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers)	\N	w
BX 314	BULBS	8	Oxalis hirta 'Gothenburg'	Mary Sue Ittner	(giant form) Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers).	\N	w
BX 314	BULBS	9	Oxalis melanosticta 'Ken Aslet'	Mary Sue Ittner	(blooms best in deep pot) Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers)	\N	w
BX 314	BULBS	10	Oxalis palmifrons	Mary Sue Ittner	(grown for the leaves as most of us never see any flowers) Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers)	\N	w
BX 314	BULBS	11	Oxalis purpurea	Mary Sue Ittner	(white flowers) Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers)	\N	w
BX 314	BULBS	12	Oxalis purpurea 'Lavender & White'	Mary Sue Ittner	Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers).	\N	w
BX 314	BULBS	13	Oxalis purpurea 'Skar'	Mary Sue Ittner	(pink flowers) Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers)	\N	w
BX 314	BULBS	14	Oxalis zeekoevleyensis	Mary Sue Ittner	(one of the first to start into growth) Winter rainfall South African Oxalis bulbs (I usually plant and start watering in August as many of these are fall bloomers)	\N	w
BX 314	BULBS	15	Tulipa batalini	Mary Sue Ittner	Very small bulbs	\N	w
BX 314	SEEDS	16	Haemanthus albiflos	Mary Sue Ittner	evergreen	\N	e
BX 314	BULBS	17	Narcissus 'Nylon'	Jim Jones	Small bulbs	\N	\N
BX 314	SEEDS	18	Crinum bulbispermum 'Jumbo'	Jim Waddick	This was originated from the late Crinum expert Les Hannibal and distributed by Marcelle Sheppard. This species does not pup a lot, so must be grown from seed for practical purposes. Totally hardy here in Kansas City Zone 5/6. Flowers open well in shades of light to dark pink. recommended and easy.	\N	\N
BX 314	SEEDS	19	Fritillaria persica	Jim Waddick	This is a tall clone with rich purple/brown flowers. Does not pup freely here, but quite hardy in Kansas City.	\N	\N
BX 314	SEEDS	20	Camassia 'Sacajewea'	Jim Waddick	Flowers creamy white, foliage white thin white edges. Of 3 or 4 species grown, only this one has made seed. A good size plant may be a form of C. leichtlinii.	\N	\N
BX 314	BULBS	21	Rhodophiala bifida	Rod Barton	triploid Rhodophiala bifida heirloom. It's a veritable weed here in North Texas.	\N	\N
BX 314	BULBS	22	Lycoris radiata	Pam Slate	\N	\N	\N
BX 314	BULBS	23	Zephyranthes (Cooperia) drummondii	Pam Slate	\N	\N	\N
BX 314	BULBS	24	Zephyranthes 'Labuffarosea'	Pam Slate	\N	\N	\N
BX 317	SEEDS	2	Albuca spiralis	Nhu Nguyen	semi lax form	http://flickr.com/photos/xerantheum/…	\N
BX 317	SEEDS	3	Albuca spiralis	Nhu Nguyen	lax form. Barely curly at the tips of the leaves	\N	\N
BX 317	SEEDS	4	Zephyranthes "datensis"	Nhu Nguyen	control pollinated. I got seeds of this species from Brazil. It was called "datensis" but it does not appear to be a validly published name. Not winter growing.	http://flickr.com/photos/xerantheum/…	\N
BX 317	SEEDS	5	Cyrtanthus brachyscyphus control pollinated	Nhu Nguyen	control pollinated. This is a lovely orange form of the species and one of the easiest species of Cyrtanthus to grow. Not winter growing.	http://flickr.com/photos/xerantheum/…	\N
BX 317	SEEDS	6	Romulea bulbocodium	Nhu Nguyen	OP	http://flickr.com/photos/xerantheum/…	\N
BX 317	SEEDS	7	Massonia pustulata NNBH2151.1	Nhu Nguyen	OP	http://flickr.com/photos/xerantheum/…	\N
BX 317	SEEDS	8	Massonia pustulata NNBH2153.1	Nhu Nguyen	OP	http://flickr.com/photos/xerantheum/…	\N
BX 317	SEEDS	9	Massonia depressa NNBH1222.1	Nhu Nguyen	OP	http://flickr.com/photos/xerantheum/…	\N
BX 317	SEEDS	10	Lachenalia longituba	Nhu Nguyen	OP. From Mary Sue Ittner. It is the form depicted on the Wiki	\N	\N
BX 317	SEEDS	11	Sprekelia formosissima	Nhu Nguyen	OP. Not winter growing.	http://flickr.com/photos/xerantheum/…	s
BX 317	SEEDS	12	Toxicoscordon freemontii Bear Valley Form	Nhu Nguyen	OP. This is a robust and very ornamental form of the species.	\N	\N
BX 317	SEEDS	13	Babiana longituba	Nhu Nguyen	OP. It can flower in 3 years from seeds.	http://flickr.com/photos/xerantheum/…	\N
BX 317	SEEDS	14	Sparaxis grandiflora ssp. grandiflora	Nhu Nguyen	OP	\N	\N
BX 317	SEEDS	15	Sparaxis elegans	Nhu Nguyen	OP	\N	\N
BX 317	SEEDS	16	Sparaxis tricolor	Nhu Nguyen	OP	\N	\N
BX 317	SEEDS	17	Geissorhiza aspera	Nhu Nguyen	OP	\N	\N
BX 317	SEEDS	18	Romulea hirta	Nhu Nguyen	OP	\N	\N
BX 317	SEEDS	19	Geissorhiza corrugata	Nhu Nguyen	OP	\N	\N
BX 317	SEEDS	20	Ferraria crispa	Nhu Nguyen	OP	\N	\N
BX 317	SEEDS	21	Allium hyalinum	Nhu Nguyen	OP. white form	\N	\N
BX 317	SEEDS	22	Hesperantha bachmanii	Nhu Nguyen	OP	\N	\N
BX 317	SEEDS	23	Triteleia laxa	Nhu Nguyen	typical violet form - OP	\N	\N
BX 317	SEEDS	24	Pelargonium appendiculatum	Terry Laskiewicz	winter blooming in cool greenhouse, for me	\N	\N
BX 317	SEEDS	25	Romulea rohlfsianum	Terry Laskiewicz	from SGRC 2008, ex Croatia, wild collected, white, graceful	\N	\N
BX 317	SEEDS	26	Rauhia decora	Colin Davis	\N	\N	\N
BX 317	SEEDS	27	Babiana pulchra	M Gastil-Buhl	white, seeds from 2011 corms ex JimDuggan	\N	\N
BX 317	SEEDS	28	Babiana purpurea	M Gastil-Buhl	some pinkish-purple, some bluish-purple, ex Jim Duggan	\N	\N
BX 317	SEEDS	29	Babiana 'Purple Haze'	M Gastil-Buhl	ex EasyToGrow	\N	\N
BX 317	SEEDS	30	Camassia leichtlinii	M Gastil-Buhl	white-cream, single, tall, from McL&Z mid 1990s	\N	\N
BX 317	SEEDS	31	Chasmanthe	M Gastil-Buhl	(either bicolor or floribunda) blooms Nov-Dec; weedy	\N	\N
BX 317	SEEDS	32	Dierama	M Gastil-Buhl	more than 5ft tall, white from UCSB seed in 1990s	\N	\N
BX 317	SEEDS	33	Freesia laxa, blue	M Gastil-Buhl	\N	\N	\N
BX 317	SEEDS	34	Lachenalia	M Gastil-Buhl	unidentified, blue-purple with violet marks, likely L. unicolor	\N	\N
BX 317	SEEDS	35	Romulea	M Gastil-Buhl	tentatively identified as R. linaresii from photos; ID not confirmed	\N	\N
BX 317	SEEDS	36	Romulea ramiflora	M Gastil-Buhl	(identified from photos)	\N	\N
BX 317	SEEDS	37	Scilla hyacinthoides	M Gastil-Buhl	up to 5 ft tall from UCSB	\N	\N
BX 317	SEEDS	38	Scilla peruviana	M Gastil-Buhl	\N	\N	\N
BX 317	SEEDS	39	Sparaxis tricolor hybrid	M Gastil-Buhl	ex UCSB, dk velvet red with yellow+black markings	\N	\N
BX 317	SEEDS	40	Tecophilaea cyanocrocus Violacea	M Gastil-Buhl	ex Brent&Beckys	\N	\N
BX 317	SEEDS	41	Tropaeolum hookerianum subsp. austropurpureum	M Gastil-Buhl	ex Telos	\N	\N
BX 317	SEEDS	42	Boophane disticha	Ken Blackford	summer-blooming	\N	\N
BX 318	BULBS	1	Moraea ciliate	M Gastil-Buhl	Cormlets. Miss-spelling of Moraea ciliata	\N	w
BX 318	BULBS	2	Babiana pulchra	M Gastil-Buhl	white, corms ex Jim Duggan	\N	w
BX 318	BULBS	3	Sparaxis tricolor hybrid	M Gastil-Buhl	ex UCSB, dk velvet red with yellow+black markings, corms	\N	w
BX 318	BULBS	4	Haemanthus humilis humilis	Jim Shields	I assume these are all the pink flowered form, but they are not yet bloom size so I'm not sure.	\N	\N
BX 318	BULBS	5	Chlorogalum pomeridianum	Shawn Pollard	Small bulbs	\N	\N
BX 318	BULBS	6	Babiana 'Deep Dreams'	John Wickham	CORMS	\N	w
BX 318	BULBS	7	Babiana 'Purple Haze'	John Wickham	CORMS	\N	w
BX 318	BULBS	8	Babiana 'Brilliant Blue'	John Wickham	CORMS	\N	w
BX 318	BULBS	9	Babiana 'Midnight Blues'	John Wickham	CORMS	\N	w
BX 318	BULBS	10	Babiana 'Bright Eyes'	John Wickham	CORMS	\N	w
BX 318	BULBS	11	Babiana angustifolia	John Wickham	CORMS	\N	w
BX 318	BULBS	12	Babiana odorata	John Wickham	CORMS	\N	w
BX 318	BULBS	13	Ipheion 'Rolf Fiedler'	John Wickham	CORMS. ex UCI	\N	w
BX 318	BULBS	14	Tritonia 'Charles Puddles'	John Wickham	CORMS	\N	\N
BX 318	BULBS	15	Tritonia hyalina	John Wickham	CORMS	\N	\N
BX 318	BULBS	16	Tritonia 'Rosy Picture'	John Wickham	CORMS	\N	\N
BX 318	BULBS	17	Ferraria ferrariola	Mary Sue Ittner	grown from seed, never bloomed so can't confirm identity (few)	\N	w
BX 318	BULBS	18	Ferraria variabilis	Mary Sue Ittner	descendents from Robinett give-away marked F. divaricata. They have never bloomed and I'm giving up and hoping someone in a warmer climate in summer than mine will have success. I suspect that these are F. variabilis as F. divaricata has been reduced, part of it is not considered F. variabilis	\N	w
BX 318	BULBS	19	Lachenalia aloides var. quadricolor	Mary Sue Ittner	mostly the small bulblets that form around the bulb	\N	w
BX 318	BULBS	20	Oxalis bowiei	Mary Sue Ittner	very tall fall bloomer with pink flowers, best I suspect in deep pot	\N	w
BX 318	BULBS	21	Oxalis caprina	Mary Sue Ittner	this one has a reputation as being weedy, but hasn't been any worse than some of the others, lilac flowers, late fall	\N	w
BX 318	BULBS	22	Oxalis flava	Mary Sue Ittner	there are lots of different flava forms, this one has yellow flowers, fall bloomer	\N	w
BX 318	BULBS	23	Oxalis flava (as namaquana)	Mary Sue Ittner	purchased as namaquana, but is flava, I think it is different than the one above, but can't remember exactly how	\N	w
BX 318	BULBS	24	Oxalis gracilis	Mary Sue Ittner	orange flowers late fall, nicely divided leaves, short bloomer for me	\N	w
BX 318	BULBS	25	Oxalis livida	Mary Sue Ittner	fall bloomer, very different leaves, check it out on the wiki, purple flowers	\N	w
BX 318	BULBS	26	Oxalis namaquana	Mary Sue Ittner	small bulbs, bright yellow flowers in winter, low, seen in Namaqualand in mass in a wet spot	\N	w
BX 318	BULBS	27	Oxalis obtusa	Mary Sue Ittner	winter blooming, didn't make a note of color	\N	w
BX 318	BULBS	28	Oxalis obtusa MV 6341	Mary Sue Ittner	Nieuwoudtville. 1.5" bright yellow flowers. Tight, compact plants. Winter blooming	\N	w
BX 318	BULBS	29	Oxalis polyphylla v heptaphylla MV6396	Mary Sue Ittner	fall bloomer, lavender flowers	\N	w
BX 318	BULBS	30	Oxalis imbricata	Mary Sue Ittner	\N	\N	w
BX 319	BULBS	1	Narcissus 'Stockens Gib'	Roy Herold	Another mystery from Lt Cdr Chris M Stocken. This one came to me from a friend who received it from a grower in Belgium. It was listed by the RHS as last being commercially available in 2005. The term 'gib' was a mystery to me, and originally I thought it to be an alternate spelling of a 'jib' sail. Google told me that a 'gib' is a castrated male cat or ferret. No thanks, but it also told me that 'gib' is short for Gibraltar. Stocken also collected in the Ronda mountains of Spain, and Gibraltar is just to the south, so is the probable origin of these bulbs. As for the bulb itself, it has never bloomed for me in ~8 years, but has multiplied like crazy. It has received the summer treatment recommended for plain old 'Stockens', but to no avail. Let me know how it turns out	\N	w
BX 319	BULBS	2	Narcissus mixed seedlings	Roy Herold	These date back to a mass sowing in 2004 of seed from moderately controlled crosses of romieuxii, cantabricus, albidus, zaianicus, and similar early blooming sorts of the bulbocodium group. Colors tend to be light yellow through cream to white, and flowers are large, much larger than the little gold colored bulbocodiums of spring. These have been selected three times, and the keepers are choice. There is the odd runt, but 95% look to be blooming size	\N	w
BX 319	BULBS	3	Albuca sp	Roy Herold	north of Calitzdorp, 12-18". Wild collected seed	\N	\N
BX 319	BULBS	4	Albuca sp	Roy Herold	Paardepoort, north of Herold. Wild collected seed	\N	\N
BX 319	BULBS	5	Albuca sp	Roy Herold	De Rust. Wild collected seed	\N	\N
BX 319	BULBS	6	Albuca sp	Roy Herold	Volmoed, southwest of Oudtshoorn, only a couple. Wild collected seed	\N	\N
BX 319	BULBS	7	Albuca sp	Roy Herold	Uniondale, 1 or 2 flowers per scape. Wild collected seed	\N	\N
BX 319	BULBS	8	Lilium tigrinum	Jerry Lehmann	Bulbils	\N	\N
BX 319	BULBS	9	Gladiolus murielae	Jonathan Lubar	\N	\N	\N
BX 319	BULBS	10	Babiana sp.	Mary Sue Ittner	Corms. These have naturalized in my Northern California garden and are probably a form of Babiana stricta. Originally grown from mixed seed more than twenty years ago. Winter growing	\N	w
BX 319	BULBS	11	Oxalis pulchella var tomentosa	Mary Sue Ittner	ex BX 221 and Ron Vanderhoff - Low, pubescent, mat forming foliage and large very pale salmon colored flowers. Fall blooming. This one hasn't bloomed for me yet, but I hope it will this year.	\N	w
BX 319	BULBS	12	Oxalis semiloba	Mary Sue Ittner	originally from Uli, this is supposed to be a summer rainfall species, but grows for me in winter and dormant in summer. It never bloomed but the leaves reminded me of Oxalis boweii.  Chuck Powell provided me with some photos of this species he grow successfully (also on a winter growing schedule) and I added them to the wiki. I can't confirm the identity of these.	\N	w
BX 319	BULBS	13	Oxalis obtusa	Mary Sue Ittner	Oxalis obtusa (peach flowers), winter-growing	\N	w
BX 319	BULBS	14	Oxalis flava	Mary Sue Ittner	Oxalis flava (lupinifolia form), winter-growing	\N	w
BX 319	BULBS	15	Ammocharis longifolia	Mary Sue Ittner	syn. Cybistetes longifolia, (survivors from seed sown from Silverhill Seed in 2000 and 2005). It can take 8 to 10 years to flower so I may be giving up too soon, but I suspect they need more summer heat and bright light than I can provide so I'm letting someone else have a crack at them.	\N	\N
BX 319	BULBS	16	Gladiolus flanaganii	PBS	small corms	\N	\N
BX 319	BULBS	17	Zephyranthes 'Labuffarosea'	PBS	small bulbs	\N	\N
BX 319	BULBS	18	Tigridia pavonia	PBS	small corms	\N	\N
BX 319	BULBS	19	Gladiolus dalenii	PBS	small corms	\N	\N
BX 320	SEEDS	1	Ipheion uniflorum 'Charlotte Bishop'	Kathleen Sayce:	pink	\N	w
BX 320	SEEDS	2	Arum palaestinum	From Arnold Trachtenberg:	\N	\N	\N
BX 320	SEEDS	3	Arum korolkowii	From Arnold Trachtenberg:	\N	\N	\N
BX 320	BULBS	4	Arisaema draconitum 'Green Dragon'	From Jerry Lehmann:	Seedling tubers. Collected seed "cluster" fall of 2 from habitat. Placed in protected location on soilsurface at my house over winter, cleaned and separated seeds and immediately sowed at the end of March 2011.	\N	\N
BX 320	SEEDS	5	Camassia 'Sacajawea'	From Jerry Lehmann:	Mine is in full sun until 3 pm. Then light shade. Holds foliage color well.	\N	\N
BX 320	SEEDS	6	Zigadenus nuttallii	From Jerry Lehmann:	ex Riley County, Kansas	\N	\N
BX 320	SEEDS	7	Hippeastrum stylosum	From Stephen Putman:	\N	\N	\N
BX 320	SEEDS	8	Allium 'Globemaster'	From Phil Andrews:	and similar white alliums. Both have identical leaf forms and flower stalk heights, so they go well together. I don't know if they come true from seed yet.	\N	\N
BX 320	SEEDS	9	Arum purpureospathum	From Mary Sue Ittner:	\N	\N	\N
BX 320	SEEDS	10	Cyrtanthus mackenii	From Mary Sue Ittner:	not sure which color form	\N	\N
BX 320	SEEDS	11	Manfreda erubescens	From Shawn Pollard:	I got the seeds for my plants from the BX years ago and this is the most beautiful and successful of the Manfredas inmy Yuma garden.	\N	\N
BX 320	SEEDS	12	Nyctaginia capitata	From Shawn Pollard:	This tuberous-rooted ground cover (scarletmuskflower or ramillete del diablo) from West Texas doesn't mind Yuma'ssummer heat one bit. Yes, the flowers are musky, like a carob.	\N	\N
BX 320	SEEDS	13	Amoreuxia palmatifida	From Shawn Pollard:	(Mexican yellowshow).	\N	\N
BX 320	SEEDS	14	Amoreuxia gonzalezii	From Shawn Pollard:	(Santa Rita yellowshow).	\N	\N
BX 320	SEEDS	15	Ascelpias albicans	From Shawn Pollard:	A stem-succulent relative of the tuberous milkweeds, this is a hard-core xerophyte with no frost tolerance that grows on rocky slopes from where all cold air drains away in winter. Tarantula hawks love the flowers	\N	\N
BX 320	SEEDS	16	Bowiea volubilis	From Shirley Meneice:	\N	\N	\N
BX 320	SEEDS	17	Anomatheca laxa, red	From Shirley Meneice:	that is a Lapeirousia or some other Irid now	\N	\N
BX 320	SEEDS	18	Hymenocallis astrostephana	From Dave Boucher:	\N	\N	\N
BX 320	SEEDS	19	Lilium formosanum	From Steven Hart:	\N	\N	\N
BX 320	SEEDS	20	Habranthus robustus	From Steven Hart:	\N	\N	\N
BX 320	SEEDS	21	Veltheimia bracteata	From Richard Hart:	\N	\N	w
BX 320	SEEDS	22	Datura sp. "Moonflower"	From Richard Hart:	\N	\N	\N
BX 320	SEEDS	23	Worsleya procera	Fereydoun Sharifi	4 seeds (3 from Brazilian plant + 1 from Australian plant)	\N	\N
BX 320	SEEDS	24	Nerine humilis	Fereydoun Sharifi	Nerine humilis: Early season/large flower/pale pink	\N	\N
BX 320	SEEDS	25	Nerine humilis	Fereydoun Sharifi	Nerine humilis: Mid season/dark pink	\N	\N
BX 320	SEEDS	26	Nerine humilis	Fereydoun Sharifi	Nerine humilis: Late season/small flower	\N	\N
BX 320	SEEDS	27	Nerine filifolia	Fereydoun Sharifi	\N	\N	\N
BX 320	SEEDS	28	Nerine undulata	Fereydoun Sharifi	\N	\N	\N
BX 320	SEEDS	29	Nerine undulata alta	Fereydoun Sharifi	\N	\N	\N
BX 320	SEEDS	30	Pucara leucantha	From Dell Sherk:	(few)	\N	\N
BX 320	SEEDS	31	Cyrtanthus	From Dell Sherk:	\N	\N	\N
BX 320	SEEDS	32	Lewisia brachycalyx	From Nhu Nguyen:	OP, W, no other species blooming at the same time, probably pure	\N	\N
BX 320	SEEDS	33	Lapeirousia corymbosa	From Nhu Nguyen:	OP, W, although no other Lapeirousia blooming at the same time, probably pure	\N	\N
BX 320	SEEDS	34	Babiana ringens	From Nhu Nguyen:	OP, W, nice red form	\N	\N
BX 320	SEEDS	35	Calochortus luteus NNBH69.1	From Nhu Nguyen:	OP, W	\N	\N
BX 320	SEEDS	36	Calochortus luteus NNBH2	From Nhu Nguyen:	OP, W, collected from a native patch in a friend's yard in the foothills of the Sierra Nevada. These are supposed to have nice brown markings. I have some extra so I'm sharing them.	\N	\N
BX 320	SEEDS	37	Solenomelus pedunculatus	From Nhu Nguyen:	OP, W, probably pure since no other irids were blooming at the same time.	\N	\N
BX 320	SEEDS	38	Allium unifolium	From Nhu Nguyen:	OP, W.	\N	\N
BX 320	SEEDS	39	Tulbaghia acutiloba	From Nhu Nguyen:	cross pollinated between two forms, S	\N	\N
BX 320	SEEDS	40	Herbertia lahue	From Nhu Nguyen:	OP, S	\N	\N
BX 320	SEEDS	41	Impatiens gomphophylla	From Nhu Nguyen:	OP, S, winter dormant, tuberous. High chance of hybridization with other impatiens species.	\N	\N
BX 320	SEEDS	42	Freesia laxa, blue	M Gastil-Buhl	\N	\N	\N
BX 321	BULBS	1	Oxalis bowiei	Jim Waddick	\N	\N	\N
BX 321	BULBS	2	Oxalis compressa 'Flore Plena'	Jim Waddick	\N	\N	\N
BX 321	BULBS	3	Oxalis gracilis	Jim Waddick	\N	\N	\N
BX 321	BULBS	4	Oxalis hirta 'Gothenberg'	Jim Waddick	\N	\N	\N
BX 321	BULBS	5	Oxalis luteola	Jim Waddick	\N	\N	\N
BX 321	BULBS	6	Oxalis melanosticta 'Ken Aslet'	Jim Waddick	\N	\N	\N
BX 321	BULBS	7	Brodiaea terrestris	Nhu Nguyen	NNBH1205	\N	w
BX 321	BULBS	8	Calochortus vestae	Nhu Nguyen	pink form ex Mary Sue Ittner, originally from Bob Werra. This is a very vigorous pupping form.	\N	w
BX 321	BULBS	9	Sparaxis elegans	Nhu Nguyen	NNBH627. offsets, grown from Silverhill Seeds	\N	w
BX 321	BULBS	10	Sparaxis grandiflora ssp. grandiflora	Nhu Nguyen	NNBH628. offsets, grown from Silverhill Seeds	\N	w
BX 321	BULBS	11	Sparaxis tricolor	Nhu Nguyen	NNBH629. offsets, grown from Silverhill Seeds	\N	w
BX 321	BULBS	12	Moraea lurida	Nhu Nguyen	NNBH198. originally from a BX	\N	w
BX 321	BULBS	13	Oxalis commutata	Nhu Nguyen	MV5117	\N	w
BX 321	BULBS	14	Oxalis melanosticta 'Ken Aslet'	Nhu Nguyen	NNBH776. these are early responders and have started sprouting.	\N	w
BX 321	BULBS	15	Oxalis polyphylla var. heptaphylla	Nhu Nguyen	\N	\N	w
BX 321	BULBS	16	Oxalis hirta	Nhu Nguyen	\N	\N	w
BX 321	BULBS	17	Chasmanthe bicolor	Randy Linke	Seedling corms	\N	\N
BX 321	BULBS	18	Rhodophiala bifida	Judy Glattstein	Small bulbs	\N	\N
BX 321	BULBS	19	Lilium lanceifolium	Joyce Miller	Bulbils	\N	\N
BX 321	BULBS	20	Oxalis fabaefolia	Lynn Makela	\N	\N	\N
BX 321	BULBS	21	Oxalis namaquana	Lynn Makela	\N	\N	\N
BX 321	BULBS	22	Oxalis perdicaria v. malecobubos	Lynn Makela	\N	\N	\N
BX 321	BULBS	23	Oxalis purpurea 'Garnet'	Lynn Makela	\N	\N	\N
BX 321	BULBS	24	Oxalis purpurea	Lynn Makela	salmon	\N	\N
BX 321	BULBS	25	Oxalis virginea	Lynn Makela	\N	\N	\N
BX 321	BULBS	26	Oxalis x 'Omel'	Lynn Makela	a rapid producer of bulbs, but oh so pretty	\N	\N
BX 321	BULBS	27	Sinningia warminginii	Lynn Makela	few	\N	\N
BX 321	BULBS	28	Amaryllis belladonna	Kathleen Sayce	ex Mike Mace seed from BX 262, dark pink	\N	\N
BX 321	BULBS	29	Amaryllis belladonna	Kathleen Sayce	ex Mary Sue Ittner seed from BX 259, pink	\N	\N
BX 321	BULBS	30	Colchicum autumnale	Kathleen Sayce	\N	\N	\N
BX 322	SEEDS	1	Arum nigrum	Jim Waddick	Hardy in Kansas City, Black spathe originally from Denver Bot Gard.	\N	\N
BX 322	SEEDS	2	Paramongaia weberbauri	Bill McLauglin	\N	\N	\N
BX 322	SEEDS	3	Crocus longiflorus	Roland de Boer	?, N. Sicily, rich flowering	\N	\N
BX 322	SEEDS	4	Gladiolus caucasicus	Roland de Boer	\N	\N	\N
BX 322	SEEDS	5	Asarum caudatum album	Roland de Boer	\N	\N	\N
BX 322	SEEDS	6	Tulipa turkestanica	Roland de Boer	\N	\N	\N
BX 322	SEEDS	7	Colchicum autumnale	Jane McGary	NARGS exchange w/c in France	\N	\N
BX 322	SEEDS	8	Colchicum bivonae	Jane McGary	Jane has provenance data for almost all these plants, including original collector's numbers and sites, so if this information is important for you, please contact her at janemcgary@earthlink.net and she will retrieve it for you.	\N	\N
BX 322	SEEDS	9	Colchicum hungaricum	Jane McGary	Jane has provenance data for almost all these plants, including original collector's numbers and sites, so if this information is important for you, please contact her at janemcgary@earthlink.net and she will retrieve it for you.	\N	\N
BX 322	SEEDS	10	Colchicum sfikasianum	Jane McGary	Jane has provenance data for almost all these plants, including original collector's numbers and sites, so if this information is important for you, please contact her at janemcgary@earthlink.net and she will retrieve it for you.	\N	\N
BX 322	SEEDS	11	Cyclamen graecum	Jane McGary	mixture from the Peloponnese and the Aegean island of Gaiduronisi	\N	\N
BX 322	BULBS	12	Fritillaria camtschatcensis	Jane McGary	bulblets, from Southeast Alaska	\N	\N
BX 322	SEEDS	13	Fritillaria agrestis	Jane McGary	Archibald collection	\N	\N
BX 322	SEEDS	14	Fritillaria biflora 'grayana'	Jane McGary	hort.	\N	\N
BX 322	SEEDS	15	Fritillaria biflora	Jane McGary	various sources	\N	\N
BX 325	SEEDS	1	Amaryllis belladonna	Penny Sommerville	pink, Fresh seed	\N	\N
BX 325	SEEDS	2	Hippeastrum striatum	Stephen Putman	few Seeds	\N	\N
BX 322	SEEDS	16	Fritillaria bithynica	Jane McGary	Jane has provenance data for almost all these plants, including original collector's numbers and sites, so if this information is important for you, please contact her at janemcgary@earthlink.net and she will retrieve it for you.	\N	\N
BX 322	SEEDS	17	Fritillaria liliacea	Jane McGary	Robinett collection	\N	\N
BX 322	SEEDS	18	Fritillaria purdyi x biflora	Jane McGary	McGary hybrid	\N	\N
BX 322	SEEDS	19	Fritillaria raddeana	Jane McGary	Jane has provenance data for almost all these plants, including original collector's numbers and sites, so if this information is important for you, please contact her at janemcgary@earthlink.net and she will retrieve it for you.	\N	\N
BX 322	SEEDS	20	Fritillaria rhodocanakis	Jane McGary	Jane has provenance data for almost all these plants, including original collector's numbers and sites, so if this information is important for you, please contact her at janemcgary@earthlink.net and she will retrieve it for you.	\N	\N
BX 322	SEEDS	21	Fritillaria stenanthera	Jane McGary	Halda collection	\N	\N
BX 322	SEEDS	22	Fritillaria viridea	Jane McGary	Robinett collection	\N	\N
BX 322	SEEDS	23	Gymnospermium albertii	Jane McGary	J. Halda collection	\N	\N
BX 322	SEEDS	24	Hyacinthella heldreichii	Jane McGary	Archibald collection	\N	\N
BX 322	SEEDS	25	Hyacinthoides algeriense	Jane McGary	Salmon collection	\N	\N
BX 322	SEEDS	26	Nectaroscordum tripedale	Jane McGary	Jane has provenance data for almost all these plants, including original collector's numbers and sites, so if this information is important for you, please contact her at janemcgary@earthlink.net and she will retrieve it for you.	\N	\N
BX 322	SEEDS	27	Romulea nivalis	Jane McGary	Jane has provenance data for almost all these plants, including original collector's numbers and sites, so if this information is important for you, please contact her at janemcgary@earthlink.net and she will retrieve it for you.	\N	\N
BX 322	SEEDS	28	Romulea requienii	Jane McGary	Salmon collection	\N	\N
BX 322	SEEDS	29	Triteleia hyacinthina	Jane McGary	Jane has provenance data for almost all these plants, including original collector's numbers and sites, so if this information is important for you, please contact her at janemcgary@earthlink.net and she will retrieve it for you.	\N	\N
BX 322	SEEDS	30	Triteleia ixioides subsp. scabra	Jane McGary	McGary collection, hills W of Salinas CA	\N	\N
BX 322	SEEDS	31	Triteleia laxa 'giant form'	Jane McGary	McGary collection from Mariposa County CA	\N	\N
BX 323	SEEDS	1	Allium abramsii	Jane McGary	Ratko collection	\N	\N
BX 323	SEEDS	2	Allium campanulatum	Jane McGary	Ratko collection	\N	\N
BX 323	SEEDS	3	Allium diabloense	Jane McGary	Ratko collection	\N	\N
BX 323	SEEDS	4	Allium douglasii	Jane McGary	Ratko collection	\N	\N
BX 323	SEEDS	5	Allium hyalinum	Jane McGary	pink form, Ratko collection	\N	\N
BX 323	SEEDS	6	Allium oreophilum ex 'Samur'	Jane McGary	Ruksans selection	\N	\N
BX 323	SEEDS	7	Allium peninsulare	Jane McGary	Ratko collection	\N	\N
BX 323	SEEDS	8	Allium praecox	Jane McGary	Ratko collection	\N	\N
BX 323	SEEDS	9	Allium scorzoneriifolium subsp. xericense	Jane McGary	Salmon collection	\N	\N
BX 323	SEEDS	10	Allium serra	Jane McGary	Ratko collection	\N	\N
BX 323	SEEDS	11	Anemone palmata	Jane McGary	M. Salmon collection	\N	\N
BX 323	SEEDS	12	Calochortus amabilis	Jane McGary	Robinett collection	\N	\N
BX 323	SEEDS	13	Calochortus catalinae	Jane McGary	\N	\N	\N
BX 323	SEEDS	14	Calochortus clavatus subsp. gracilis	Jane McGary	Ratko collection	\N	\N
BX 323	SEEDS	15	Calochortus dunnii	Jane McGary	Ratko collection	\N	\N
BX 323	SEEDS	16	Calochortus elegans	Jane McGary	McGary collection, Siskiyou Mts	\N	\N
BX 323	SEEDS	17	Calochortus longebarbatus	Jane McGary	Leach Botanical Garden collection	\N	\N
BX 323	SEEDS	18	Calochortus monophyllus	Jane McGary	\N	\N	\N
BX 323	SEEDS	19	Calochortus striatus	Jane McGary	Ratko collection	\N	\N
BX 323	SEEDS	20	Calochortus superbus	Jane McGary	Archibald collection (probably a from a hybrid swarm with C. luteus)	\N	\N
BX 323	SEEDS	21	Calochortus venustus	Jane McGary	red forms from various collections	\N	\N
BX 323	SEEDS	22	Calochortus venustus	Jane McGary	white forms, from various seed sources	\N	\N
BX 323	SEEDS	23	Camassia quamash subsp. breviflora	Jane McGary	Phyllis Gustafson collection	\N	\N
BX 323	SEEDS	24	Camassia quamash subsp. maxima 'Puget Blue'	Jane McGary	\N	\N	\N
BX 323	SEEDS	25	Alophia drummondii	Rodney Barton	\N	\N	\N
BX 323	SEEDS	26	Habranthus tubispathus var. texensis	Rodney Barton	\N	\N	\N
BX 323	SEEDS	27	Herbertia lahue ssp caerulea	Rodney Barton	\N	\N	\N
BX 323	SEEDS	28	Lilium humboldtii	Mary Sue Ittner	\N	\N	\N
BX 323	SEEDS	29	Lilium pardalinum 'Giganteum'	Mary Sue Ittner	\N	\N	\N
BX 323	SEEDS	30	Haemanthus humilis	Mary Sue Ittner	\N	\N	\N
BX 323	SEEDS	31	Veltheimia bracteata	Mary Sue Ittner	\N	\N	\N
BX 323	SEEDS	32	Pelargonium barkleyi	Mary Sue Ittner	\N	\N	\N
BX 323	SEEDS	33	Triteleia peduncularis	Mary Sue Ittner	\N	\N	\N
BX 323	SEEDS	34	Pelargonium appendiculatum	Terry Laskiewicz	\N	\N	\N
BX 324	BULBS	1	Babiana framesii	Mary Sue Ittner	various sizes, some small cormlets	\N	\N
BX 324	BULBS	2	Ferraria crispa ssp. nortieri	Mary Sue Ittner	\N	\N	\N
BX 324	BULBS	3	Ferraria variabilis	Mary Sue Ittner	(from seed labeled F. divaricarta, never bloomed, I suspect is F. variabilis)	\N	\N
BX 324	BULBS	4	Freesia caryophyllacea	Mary Sue Ittner	mostly cormlets	\N	\N
BX 324	BULBS	5	Oxalis flava	Mary Sue Ittner	(lupinifolia)	\N	\N
BX 324	BULBS	6	Oxalis obtusa	Mary Sue Ittner	(copper color)	\N	\N
BX 324	BULBS	7	Ferraria crispa	Mary Sue Ittner	this one smells like vanilla, has been spreading planted in the ground	\N	\N
BX 324	BULBS	8	Herbertia lahue	Mary Sue Ittner	\N	\N	\N
BX 324	BULBS	9	Muscari pallens	Mary Sue Ittner	\N	\N	\N
BX 324	BULBS	10	Oxalis polyphylla var heptaphylla	Mary Sue Ittner	MV 4381B, 4km into Skoemanskloof from Oudtshoorn. Long, succulent, thread-like leaves.	\N	\N
BX 324	BULBS	11	Chasmanthe bicolor	Randy Linke	Cormlets	\N	\N
BX 324	BULBS	12	Arum palaestinum	Arnold Trachtenberg	Tubers	\N	\N
BX 324	BULBS	13	Arum korolkowii	Arnold Trachtenberg	Tubers	\N	\N
BX 324	BULBS	14	Watsonia hybrids	Pam Slate	Mixed corms of Watsonia mixed hybrids (Snow Queen, Flamboyant and Double Vision) and Ixia (Giant)	\N	\N
BX 324	BULBS	15	Babiana sp	Kathleen Sayce	? Small corms	\N	\N
BX 325	SEEDS	3	Hippeastrum neopardinum	Stephen Putman	Seeds (only three shares)	\N	\N
BX 325	SEEDS	4	Cyclamen hederifolium	Kathleen Sayce	mixed leaf forms	\N	\N
BX 325	SEEDS	5	Urginea (Scilla) maritima	Richard Wagner	Very fresh seed. Needs to be fresh for germination	\N	\N
BX 325	SEEDS	6	Pancratium maritimum	Richard Wagner	\N	\N	\N
BX 325	SEEDS	7	Sisyrinchium californicum	Shirley Meneice	\N	\N	\N
BX 325	SEEDS	8	Sisyrinchium bellum	Shirley Meneice	\N	\N	\N
BX 325	SEEDS	9	Sisyrinchium angustifolium	Shirley Meneice	\N	\N	\N
BX 325	SEEDS	10	Schizostylis coccinea	Shirley Meneice	\N	\N	\N
BX 325	SEEDS	11	Tigridia pavonia	Shirley Meneice	\N	\N	\N
BX 325	SEEDS	12	Ornithogalum saundersiae	Jerry Lehmann	\N	\N	\N
BX 325	SEEDS	13	Liatris pychostachya	Jerry Lehmann	ex Becker County, MN, open pollinated	\N	\N
BX 325	SEEDS	14	Iris versicolor	Jerry Lehmann	ex Becker County, MN	\N	\N
BX 325	SEEDS	15	Uvularia sessilifolia	Jerry Lehmann	ex Becker County, MN	\N	\N
BX 325	SEEDS	16	Heracleum lanatum	Jerry Lehmann	I have never had success with these from seed. They tend to grow in sandy ditches, but where water is funneled to the ditch sides, not really in water.	\N	\N
BX 325	SEEDS	17	Allium sanbornii	Nhu Nguyen	W, OP, pink form	\N	W
BX 325	SEEDS	18	Allium jepsonii	Nhu Nguyen	W, OP	\N	W
BX 325	SEEDS	19	Brodiaea elegans	Nhu Nguyen	W, OP	\N	W
BX 325	SEEDS	20	Iris douglasiana	Nhu Nguyen	W wild collected, Marin Co., California - this comes from a variable population so you may get a mix of colors and forms	\N	W
BX 325	SEEDS	21	Triteleia laxa	Nhu Nguyen	W, OP deep purple, coastal Marin Co., California form	\N	W
BX 325	SEEDS	22	Chlorogalum sp.	Nhu Nguyen	W wild collected, Placer Co., form, Sierra Nevada, about 4500ft (1370m)	\N	W
BX 325	SEEDS	23	Chlorogalum pomeridianum	Nhu Nguyen	W wild collected, Santa Cruz, California, near sea level	\N	W
BX 325	SEEDS	24	Alstroemeria ligtu ssp. simsii	Nhu Nguyen	W, CP	\N	W
BX 325	SEEDS	25	Allium sp.	Nhu Nguyen	W, CP. Chiapas, Mexico	http://flickr.com/photos/xerantheum/#	W
BX 325	SEEDS	26	Allium carinatum var. pulchellum	Nhu Nguyen	W, CP	\N	W
BX 325	SEEDS	27	Albuca shawii	Nhu Nguyen	SU, OP	\N	S
BX 325	SEEDS	28	Cyclamen africanum	Nhu Nguyen	W, CP	\N	W
BX 325	SEEDS	29	Galtonia viridiflora	Nhu Nguyen	SU, CP	\N	S
BX 325	SEEDS	30	Gladiolus flanaganii	Nhu Nguyen	SU, CP	\N	S
BX 325	SEEDS	31	Veltheimia bracteata	Nhu Nguyen	W/SU, OP	\N	W
BX 325	SEEDS	32	Tulbaghia galpinii	Nhu Nguyen	S, OP	\N	S
BX 325	SEEDS	33	Ixia viridiflora	Nhu Nguyen	W, OP	\N	W
BX 325	SEEDS	34	Calydorea amabilis	Nhu Nguyen	S, CP	\N	S
BX 325	SEEDS	35	Camassia leichtlini v. suksdorfi	Gene Mirro	90: very vigorous, tall dark blue from Linn County, OR. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/#23b.jpg	\N
BX 325	SEEDS	36	Camassia quamash	Gene Mirro	182: Willamette Valley, OR form. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	\N	\N
BX 325	SEEDS	37	Camassia quamash ssp azurea	Gene Mirro	light blue form; grows near Chehalis, WA. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/#594dd.jpg	\N
BX 325	SEEDS	38	Colchicum	Gene Mirro	garden forms mixed. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	\N	\N
BX 325	SEEDS	39	Dichelostemma ida-maia	Gene Mirro	All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/#dc762.jpg	\N
BX 325	SEEDS	40	Erythronium revolutum	Gene Mirro	25: All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	\N	\N
BX 325	SEEDS	41	Lilium bulbiferum croceum	Gene Mirro	1052: blooms early summer; 2 feet tall; upfacing red/orange flowers; needs summer water; does not make stem bulbils. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/#5.jpg	\N
BX 325	SEEDS	42	Lilium canadense	Gene Mirro	15: blooms midsummer; 3 - 4 feet tall; downfacing red/yellow flowers; needs summer water. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/#g	\N
BX 325	SEEDS	43	Lilium kelloggi	Gene Mirro	545: pink; blooms early summer; 2 - 4 feet tall; water lightly after bloom time. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	\N	\N
BX 325	SEEDS	44	Lilium kelloggi white	Gene Mirro	320: blooms early summer; rare white form; 2 - 3 feet tall; water lightly after bloom time. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/#g	\N
BX 325	SEEDS	45	Lilium medeoloides	Gene Mirro	682: blooms midsummer; downfacing orange flowers; 2 - 3 feet tall; needs summer water. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/#	\N
BX 325	SEEDS	46	Lilium parryi	Gene Mirro	1070: blooms early summer; 3 feet tall; outfacing yellow flowers; needs summer water. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/#	\N
BX 325	SEEDS	47	Lilium lijiangense	Gene Mirro	1174: blooms early summer; 3 - 4 feet tall; needs summer water. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/#	\N
BX 325	SEEDS	48	Lilium wigginsi	Gene Mirro	1268: blooms early summer; 3 - 4 feet tall; needs summer water. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	\N	\N
BX 325	SEEDS	49	Notholirion bulbuliferum	Gene Mirro	193: blooms early summer; 3 - 4 feet tall; monocarpic. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/#b75ed8f.jpg	\N
BX 325	SEEDS	50	Trillium rivale	Gene Mirro	706: unmarked white form. All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	\N	\N
BX 325	SEEDS	51	Tritelia bridgesi	Gene Mirro	111: All these plants grow very well in SW Washington state in a cool microclimate, in full sun, in heavy clay loam soil amended with lots of coarse sand.	http://i232.photobucket.com/albums/ee69/#.jpg	\N
BX 330	SEEDS	1	Calochortus amabilis	From Bob Werra:	Bob says, It's not too late to plant winter rainfall species.	\N	\N
BX 330	SEEDS	2	Dichelostemma ida-maia	From Bob Werra:	\N	\N	\N
BX 330	SEEDS	3	Fritillaria affinis	From Bob Werra:	ex Ukiah, CA	\N	\N
BX 330	SEEDS	4	Fritillaria liliaceae	From Bob Werra:	\N	\N	\N
BX 330	SEEDS	5	Gladiolus huttonii	From Bob Werra:	\N	\N	\N
BX 330	SEEDS	6	Gladiolus priori	From Bob Werra:	\N	\N	\N
BX 330	SEEDS	7	Moraea ciliata	From Bob Werra:	(CORMLETS)	\N	\N
BX 330	SEEDS	8	Moraea ciliate	From Bob Werra:	\N	\N	\N
BX 330	SEEDS	9	Moraea elegans	From Bob Werra:	\N	\N	\N
BX 330	SEEDS	10	Moraea graminicola	From Bob Werra:	ex Eastern Cape, RSA	\N	\N
BX 330	SEEDS	11	Moraea pendula	From Bob Werra:	\N	\N	\N
BX 330	SEEDS	12	Moraea polyanthus	From Bob Werra:	\N	\N	\N
BX 330	SEEDS	13	Moraea polystachya	From Bob Werra:	\N	\N	\N
BX 330	SEEDS	14	Moraea vegeta	From Bob Werra:	\N	\N	\N
BX 330	SEEDS	15	Moraea vespertina	From Bob Werra:	\N	\N	\N
BX 330	SEEDS	16	Moraea villosa	From Bob Werra:	\N	\N	\N
BX 330	SEEDS	17	Rhodophiala	From Bob Werra:	pink	\N	\N
BX 330	SEEDS	18	Rhodophiala	From Bob Werra:	dark maroon	\N	\N
BX 330	SEEDS	19	Sandersonia aurantiaca	From Bob Werra:	\N	\N	\N
BX 330	SEEDS	20	Crotolaria capensis	From Roland de Boer:	\N	\N	\N
BX 330	SEEDS	21	Cyclamen hederifolium	From Roland de Boer:	mixed pink forms	\N	\N
BX 330	SEEDS	22	Galtonia viridiflora	From Roland de Boer:	tall form	\N	\N
BX 330	SEEDS	23	Kochia scoparia	From Roland de Boer:	\N	\N	\N
BX 330	SEEDS	24	Leucocoryne purpurea	From Roland de Boer:	\N	\N	\N
BX 330	SEEDS	25	Malcomia maritima	From Roland de Boer:	\N	\N	\N
BX 330	SEEDS	26	Massonia echinata	From Roland de Boer:	\N	\N	\N
BX 330	SEEDS	27	Massonia pustulata	From Roland de Boer:	\N	\N	\N
BX 330	SEEDS	28	Paradisia lusitanicum	From Roland de Boer:	\N	\N	\N
BX 330	SEEDS	29	Eucomis comosa	From Dee Foster:	green/white	\N	\N
BX 330	SEEDS	30	Eucomis comosa	From Dee Foster:	mixed colors, mostly pink	\N	\N
BX 330	SEEDS	31	Eucomis cv	From Dee Foster:	dwarf purple flower, green foliage	\N	\N
BX 330	SEEDS	32	Gloriosa superba	From Dee Foster:	(rotschildiana)	\N	\N
BX 330	SEEDS	33	Veltheimia bracteata	From Dee Foster:	pink	\N	\N
BX 330	SEEDS	34	Mirabilis jalapa	From Dee Foster:	Four O'clocks, magenta	\N	\N
BX 330	SEEDS	35	Amaryllis belladonna	From Mary Sue Ittner:	OP	\N	winter growing
BX 330	SEEDS	36	Cyrtanthus elatus x montanus	From Mary Sue Ittner:	(all OP)	\N	evergreen
BX 330	BULBS	37	Cyrtanthus elatus x montanus	From Mary Sue Ittner:	Bulblets	\N	evergreen
BX 330	SEEDS	38	Eucomis bicolor	From Mary Sue Ittner:	(all OP)	\N	summer growing
BX 330	SEEDS	39	Nerine bowdenii	From Mary Sue Ittner:	confused about when it should grow (all OP)	\N	\N
BX 330	SEEDS	40	Nerine sarninesis hybrid	From Mary Sue Ittner:	(had red flowers) (all OP)	\N	w
BX 330	SEEDS	41	Nerine sarniensis hybrid	From Mary Sue Ittner:	(seed from rescue bulb) (all OP)	\N	w
BX 330	SEEDS	42	Polianthes geminiflora	From Mary Sue Ittner:	(all OP)	\N	s
BX 331	SEEDS	1	Dracunculus vulgaris	From Richard Hart:	\N	\N	\N
BX 331	SEEDS	2	Haemanthus albiflos	From Richard Hart:	\N	\N	\N
BX 331	SEEDS	3	Tigridia pavonia, yellow	From Richard Hart:	\N	\N	\N
BX 331	SEEDS	4	Dietes grandiflora	From Guy L'Eplattenier:	\N	\N	\N
BX 331	SEEDS	5	Lapiedra martinezii	From Guy L'Eplattenier:	(for those who did not get any the last time)	\N	\N
BX 331	SEEDS	6	Pancratium canariense	From Guy L'Eplattenier:	\N	\N	\N
BX 331	SEEDS	7	Dichelostemma volubile	From Gene Mirro:	\N	http://i232.photobucket.com/albums/ee69/#	\N
BX 331	SEEDS	8	Lilium auratum rubrovittatum	From Gene Mirro:	\N	\N	\N
BX 331	SEEDS	9	Lilium henryi citrinum`	From Gene Mirro:	\N	\N	\N
BX 331	BULBS	10	Lilium sulphureum	From Gene Mirro:	1139: blooms late summer; 5 - 8 ft. tall, large fragrant flowers with white/green inside, white/purple outside; strong straight stems; needs summer water; purple stem bulbils.	http://s232.photobucket.com/albums/ee69/# 39_zps217d838f.jpg	\N
BX 331	BULBS	11	Lilium sulphureum	From Gene Mirro:	1469: blooms late summer; 5 - 8 ft. tall, large fragrant flowers with white/yellow inside, white/purple outside; strong straight stems; lives 15 years or more; needs summer water. Bulbils	\N	\N
BX 332	BULBS	1	Watsonia sp. aff. fulgens. Cormlets	From Kipp McMichael:	red	\N	\N
BX 332	SEEDS	2	Massonia pustulata	From Kipp McMichael:	purple and mottled purple	\N	\N
BX 332	SEEDS	3	Albuca nelsonii	From Stephen Gregg:	ex Silverhill. Grows 2 metres high	\N	\N
BX 332	SEEDS	4	Erythronium elegans	From Kathleen Sayce:	wild collected Mt Hebo, Tillamook County, Oregon	\N	\N
BX 332	SEEDS	5	Asphodelus acaulis	From Angelo Porcelli:	\N	\N	\N
BX 332	SEEDS	6	Iris coccina	From Angelo Porcelli:	\N	\N	\N
BX 332	SEEDS	7	Iris planifolia	From Angelo Porcelli:	\N	\N	\N
BX 332	SEEDS	8	Paeonia mascula ssp mascula	From Angelo Porcelli:	\N	\N	\N
BX 332	SEEDS	9	Pancratium canariense	From Angelo Porcelli:	\N	\N	\N
BX 332	SEEDS	10	Pancratium parviflorum	From Angelo Porcelli:	\N	\N	\N
BX 332	SEEDS	11	Ceropegia ballyana	From Sophie Dixon:	\N	\N	\N
BX 332	SEEDS	12	Dietes grandiflora	From Guy L'Eplattenier:	\N	\N	\N
BX 332	SEEDS	13	Lapiedra martinezii	From Guy L'Eplattenier:	\N	\N	\N
BX 332	SEEDS	14	Pancratium canariense	From Guy L'Eplattenier:	\N	\N	\N
BX 332	SEEDS	15	Narcissus serotinus	From Donald Leevers:	\N	\N	\N
BX 333	SEEDS	1	Sprekelia cv, 'Orient Red'	From Stephen Gregg:	repeat bloomer, prominent white stripe	\N	\N
BX 333	SEEDS	2	Fritillaria meleagris	From David Pilling:	\N	\N	\N
BX 333	SEEDS	3.1	Lilium formosanum	From David Pilling:	\N	\N	\N
BX 333	SEEDS	3.2	Lilium regale	From David Pilling:	\N	\N	\N
BX 333	SEEDS	4	Zantedeschia aethiopica	From David Pilling:	\N	\N	\N
BX 333	SEEDS	5	Manfreda undulata 'Chocolate Chips'	From Dennis Kramb:	\N	\N	\N
BX 333	SEEDS	6	Sinningia speciosa	From Dennis Kramb:	\N	\N	\N
BX 333	SEEDS	7	Zephyranthes hidalgo x Z. grandiflora	From Ina Crossley:	could not be verified	\N	\N
BX 333	SEEDS	8	Zephyranthes 'Pink Beauty'	From Ina Crossley:	\N	\N	\N
BX 333	SEEDS	9	Zephyranthes drummondii	From Ina Crossley:	\N	\N	\N
BX 333	SEEDS	10	Zephyranthes dichromantha	From Ina Crossley:	\N	\N	\N
BX 333	SEEDS	11	Zephyranthes flavissima	From Ina Crossley:	\N	\N	\N
BX 333	SEEDS	12	Zephyranthes lindleyana	From Ina Crossley:	\N	\N	\N
BX 333	SEEDS	13	Zephyranthes hidalgo 'John Fellers'	From Ina Crossley:	could not be verified	\N	\N
BX 333	SEEDS	14	Zephyranthes jonesii	From Ina Crossley:	\N	\N	\N
BX 333	SEEDS	15	Zephyranthes fosteri	From Ina Crossley:	\N	\N	\N
BX 333	SEEDS	16	Zephyranthes primulina	From Ina Crossley:	\N	\N	\N
BX 333	SEEDS	17	Zephyranthes reginae	From Ina Crossley:	\N	\N	\N
BX 333	SEEDS	18	Zephyranthes tenexico	From Ina Crossley:	apricot. could not be verified	\N	\N
BX 333	SEEDS	19	Zephyranthes verecunda rosea	From Ina Crossley:	could not be verified	\N	\N
BX 333	BULBS	20	Achimenes erecta 'Tiny Red'	From Dennis Kramb:	RHIZOMES/TUBERS	\N	\N
BX 333	BULBS	21	Achimenes 'Desiree'	From Dennis Kramb:	RHIZOMES/TUBERS	\N	\N
BX 333	BULBS	22	Gloxinella lindeniana	From Dennis Kramb:	RHIZOMES/TUBERS	\N	\N
BX 333	BULBS	23	Niphaea oblonga	From Dennis Kramb:	RHIZOMES/TUBERS	\N	\N
BX 333	BULBS	24	Sinningia eumorpha 'Saltao'	From Dennis Kramb:	RHIZOMES/TUBERS	\N	\N
BX 333	BULBS	25	Sinningia speciosa	From Dennis Kramb:	RHIZOMES/TUBERS	\N	\N
BX 334	SEEDS	1	Gloriosa modesta	From Mary Sue Ittner:	(Littonia modesta)	\N	summer growing
BX 334	SEEDS	2	Tigridia vanhouttei	From Mary Sue Ittner:	\N	\N	summer growing
BX 334	BULBS	3	Oxalis triangularis	From Mary Sue Ittner:	evergreen if you keep watering it	\N	\N
BX 334	BULBS	4	Oxalis sp. Mexico	From Mary Sue Ittner:	\N	\N	summer growing
BX 334	SEEDS	5	Habranthus martinezii x H. robustus	From Stephen Gregg	\N	\N	\N
BX 334	SEEDS	6	Moraea polystachya	From Jim Waddick and SIGNA:	\N	\N	\N
BX 334	SEEDS	7	Iris tectorum	From Jim Waddick and SIGNA:	Album'	\N	\N
BX 334	SEEDS	8	Iris tectorum, mixed	From Jim Waddick and SIGNA:	\N	\N	\N
BX 334	SEEDS	9	Geissorhiza	From Jim Waddick and SIGNA:	falcata (???)	\N	\N
BX 334	SEEDS	10	Herbertia lahue	From Jim Waddick and SIGNA:	\N	\N	\N
BX 334	SEEDS	11	Crocosmia	From Jim Waddick and SIGNA:	ex 'Lucifer'	\N	\N
BX 334	SEEDS	12	Calydorea amabilis	From Jim Waddick and SIGNA:	\N	\N	\N
BX 334	SEEDS	13	Cypella coelestis	From Jim Waddick and SIGNA:	(syn Phalocallis coelestis)	\N	\N
BX 334	SEEDS	14	Dietes iridioides	From Jim Waddick and SIGNA:	\N	\N	\N
BX 334	SEEDS	15	Romulea monticola	From Jim Waddick and SIGNA:	\N	\N	\N
BX 334	SEEDS	16	Herbertia pulchella	From Jim Waddick and SIGNA:	\N	\N	\N
BX 334	SEEDS	17	Dietes bicolor	From Jim Waddick and SIGNA:	\N	\N	\N
BX 334	SEEDS	18	Freesia laxa, blue	From Jim Waddick and SIGNA:	\N	\N	\N
BX 334	SEEDS	19	Watsonia	From Jim Waddick and SIGNA:	ex 'Frosty Morn'	\N	\N
BX 334	SEEDS	20	Crocosmia paniculata	From Jim Waddick and SIGNA:	\N	\N	\N
BX 334	SEEDS	21	Gelasine elongata	From Jim Waddick and SIGNA:	\N	\N	\N
BX 335	SEEDS	1	Phaedranassa tunguraguae	From Bjorn Wretman:	\N	\N	\N
BX 335	SEEDS	2	Hippeastrum nelsonii	From Stephen Putman:	\N	\N	\N
BX 335	SEEDS	3	Zephyranthes fosteri	From Ina Crossley:	\N	\N	\N
BX 335	SEEDS	4	Zephyranthes dichromantha	From Ina Crossley:	\N	\N	\N
BX 335	SEEDS	5	Zephyranthes 'Hidalgo'	From Ina Crossley:	\N	\N	\N
BX 335	SEEDS	6	Zephyranthes reginae	From Ina Crossley:	\N	\N	\N
BX 335	SEEDS	7	Zephyranthes 'Tenexico'	From Ina Crossley:	apricot	\N	\N
BX 335	SEEDS	8	Tigridia pavonia	From Ina Crossley:	pure white	\N	\N
BX 335	SEEDS	9	Zephyranthes citrina	From Ina Crossley:	\N	\N	\N
BX 335	SEEDS	10	Zephyranthes primulina	From Ina Crossley:	\N	\N	\N
BX 335	SEEDS	11	Zephyranthes 'Ajax'	From Ina Crossley:	\N	\N	\N
BX 335	SEEDS	12	Habranthus tubispathus	From Ina Crossley:	Texensis'	\N	\N
BX 335	SEEDS	13	Habranthus brachyandrus	From Ina Crossley:	\N	\N	\N
BX 335	SEEDS	14	Habranthus tubispathusvar. roseus	From Ina Crossley:	\N	\N	\N
BX 335	SEEDS	15	Zephyranthes 'Sunset Strain'	From Ina Crossley:	\N	\N	\N
BX 335	SEEDS	16	Tigridia pavonia	From Nhu Nguyen:	- S, OP	\N	s
BX 335	SEEDS	17	Herbertia tigridioides	From Nhu Nguyen:	- S, OP	\N	s
BX 335	SEEDS	18	Calydorea amabilis	From Nhu Nguyen:	- S, OP	\N	s
BX 335	SEEDS	19	Cypella herbertii	From Nhu Nguyen:	- S, OP	\N	s
BX 335	SEEDS	20	Ornithogalum regale	From Nhu Nguyen:	- W, control pollinated	\N	w
BX 335	BULBS	21	Oxalis lasiandra	From Nhu Nguyen:	\N	\N	s
BX 335	BULBS	22	Oxalis tetraphylla 'Reverse Iron Cross'	From Nhu Nguyen:	\N	\N	s
BX 335	BULBS	23	Oxalis sp.	From Nhu Nguyen:	Durango, Mexico	\N	s
BX 336	BULBS	1	Achimenes grandiflora	From Lynn Makela:	Robert Dressler'	\N	\N
BX 336	BULBS	2	Achimenes 'Purple King'	From Lynn Makela:	\N	\N	\N
BX 336	BULBS	3	Crinum 'Menehune' dwarf	From Lynn Makela:	purple leaves, pink flowers	\N	\N
BX 336	BULBS	4	Eucodonia andrieuxii	From Lynn Makela:	hybrids (few)	\N	\N
BX 336	BULBS	5	xGlokohleria 'Pink Heaven'	From Lynn Makela:	\N	\N	\N
BX 336	BULBS	6	Sinningia bullata	From Lynn Makela:	bright red flowers (few)	\N	\N
BX 336	BULBS	7	Zephyranthesr	From Lynn Makela:	ex Jacala, Mexico, wine-red flowers	\N	\N
BX 336	BULBS	8	Zephyranthes traubii	From Lynn Makela:	Carlos form	\N	\N
BX 336	SEEDS	10	Burchardia congesta	From Don Leevers:	(syn B. umbellata)	\N	\N
BX 336	SEEDS	11	Caesia parviflora	From Don Leevers:	\N	\N	\N
BX 336	SEEDS	12	Xyris lanata	From Don Leevers:	\N	\N	\N
BX 336	SEEDS	13	Xyris operculata	From Don Leevers:	\N	\N	\N
BX 336	BULBS	14	Hippeastrum cybister	From Dell Sherk:	Bulblets	\N	\N
BX 336	BULBS	15	Strumaria truncata	From Dell Sherk:	Bulblets	\N	\N
BX 336	BULBS	16	Strumaria discifera	From Dell Sherk:	Bulblets. (very few)	\N	\N
BX 336	BULBS	17	Nerine pudica	From Dell Sherk:	Bulblets	\N	\N
BX 337	SEEDS	1	Hippeastrum striatum	From Stephen Putman:	\N	\N	\N
BX 337	SEEDS	2	Narcissus cantabricus	From Arnold Trachtenberg:	clusii. Per TPL and IPNI, there is no listing for this. Per TPL, N. clusii is a synonym of N. cantabricus var. cantabricus.  Per IPNI, N. cantabricus and N. clusii are two separate species.	\N	\N
BX 337	SEEDS	3	Narcissus romieuxii	From Arnold Trachtenberg:	\N	\N	\N
BX 337	SEEDS	4	Narcissus romieuxii	From Arnold Trachtenberg:	var mesatlanticus. Per TPL and IPNI, there is no listing for this. Also no listing under N. mesatlanticus.  PBS lists it as a synonym for N. romieuxii ssp. romieuxii var. romieuxii (also not a valid name per TPL & IPNI), but does not indicate where it is validly described.The Alpine Garden Society states, in part, 'or the dubiously distinct variety mesatlanticus..'	(http://alpinegardensociety.net/plants/#ii/12/)	\N
BX 337	SEEDS	5	Narcissus cantabricus	From Arnold Trachtenberg:	\N	\N	\N
BX 337	SEEDS	6	Narcissus romieuxii 'Julia Jane'	From Arnold Trachtenberg:	\N	\N	\N
BX 337	SEEDS	7	Narcissus romieuxii 'Jessamy'	From Arnold Trachtenberg:	\N	\N	\N
BX 337	SEEDS	8	Massonia pustulata	From Arnold Trachtenberg:	\N	\N	\N
BX 337	SEEDS	9	Massonia pustulata	From Arnold Trachtenberg:	purple leaves	\N	\N
BX 337	BULBS	10	Freesia elimensis	From Arnold Trachtenberg:	(syn? F. caryophyllacea)	\N	\N
BX 337	BULBS	11	Freesia fucata	From Arnold Trachtenberg:	\N	\N	\N
BX 337	BULBS	12	Lachenalia liliflora	From Arnold Trachtenberg:	\N	\N	\N
BX 337	BULBS	13	Leucocoryne purpurea	From Arnold Trachtenberg:	\N	\N	\N
BX 337	BULBS	14	Freesia sp.	From Arnold Trachtenberg:	?	\N	\N
BX 337	BULBS	15	Arum	From Arnold Trachtenberg:	unidentified	\N	\N
BX 337	BULBS	16	Ferraria uncinata	From Arnold Trachtenberg:	\N	\N	\N
BX 337	BULBS	17	Babiana rubrocyanea	From Arnold Trachtenberg:	\N	\N	\N
BX 337	SEEDS	18	Massonia pustulata	From Antigoni Rentzeperis:	\N	\N	\N
BX 338	SEEDS	1	Schizobasis intricata	From Monica Swartz:	ex Huntington Botanic Gardens (ISI 2004-36),	\N	\N
BX 338	SEEDS	2	Ornithogalum glandulosum	From Monica Swartz:	ex Jim Duggan Flower Nursery, the earliest winter flower I grow,	\N	\N
BX 338	BULBS	3	Alocasia hypnosa	From Monica Swartz:	Small tubers of Alocasia hypnosa, a recently described (2005) species from China. Big light green leaves that give a tropical look to a shady area. Winter dormant. I store the big tubers in a bucket of dry sand in a cold garage every winter, but small tubers have over-wintered fine in ground in my 8b garden. I suspect the big tubers would do the same if buried in well-drained soil. They are waking now, so plant right away.	\N	\N
BX 338	SEEDS	4	Freesia viridis	From Antigoni Rentzeperis:	\N	\N	\N
BX 338	SEEDS	5	Lachenalia viridiflora	From Antigoni Rentzeperis:	\N	\N	\N
BX 338	SEEDS	6	Pelargonium appendiculatum	From Ruth Jones:	Per TPL, Geraniospermum appendiculatum is the accepted name; P. appendiculatum is the synonym. Per IPNI, each name is a separate species.	\N	\N
BX 338	SEEDS	7	Clivia miniata	From Mary Sue Ittner:	from two plants, both very light yellow flowers Bulbs: all winter growing, may not all be blooming size	\N	\N
BX 338	BULBS	8	Oxalis assinia	From Mary Sue Ittner:	(syn. O. fabaefolia)	\N	\N
BX 338	BULBS	9	Oxalis bowiei	From Mary Sue Ittner:	Oxalis bowiei This made the favorite pink category of a couple of us.  This is a fall blooming, tall, big gorgeous plant.	\N	\N
BX 338	BULBS	10	Oxalis engleriana	From Mary Sue Ittner:	South African, fall blooming, linear leaves	\N	\N
BX 338	BULBS	11	Oxalis flava	From Mary Sue Ittner:	yellow, winter growing, fall blooming	\N	w
BX 338	BULBS	12	Oxalis flava	From Mary Sue Ittner:	received as O. namaquana, but is this species, yellow flowers	\N	\N
BX 338	BULBS	13	Oxalis flava	From Mary Sue Ittner:	(lupinifolia) -- lupine like leaves and pink flowers, fall blooming	\N	\N
BX 338	BULBS	14	Oxalis flava	From Mary Sue Ittner:	(pink) -- leaves low to ground, attractive, one year some of the flowers were also yellow (along with the pink), but usually it has pink flowers, no guarantee about the color but the leaves are nice and it doesn't offset a lot	\N	\N
BX 338	BULBS	15	Oxalis hirta	From Mary Sue Ittner:	(mauve) received from Ron Vanderhoff, definitely a different color from the pink ones I grow, really pretty, fall blooming	\N	\N
BX 338	BULBS	16	Oxalis hirta	From Mary Sue Ittner:	(pink) From South Africa, blooms late fall, early winter, bright pink flowers. Increases rapidly. does better for me in deep pot, fall blooming	\N	\N
BX 338	BULBS	17	Oxalis hirta	From Mary Sue Ittner:	Gothenburg'- a hirta on steroids, gets to be a very large plant and does best with a deep pot	\N	\N
BX 338	BULBS	18	Oxalis imbricata	From Mary Sue Ittner:	-recycled from the BX. This one has pink flowers even though Cape Plants says the flowers are white. The one shown on the web that everyone grows has hairy leaves, pink flowers. Fall into winter blooming	\N	\N
BX 338	BULBS	19	Oxalis luteola	From Mary Sue Ittner:	MV 5567 60km s of Clanwilliam. 1.25 inch lt yellow flrs, darker ctr. This one has been very reliable for me in Northern California	\N	\N
BX 338	BULBS	20	Oxalis melanosticta	From Mary Sue Ittner:	Ken Aslet' -- has a reputation for not blooming and originally I grew it for its hairy soft leaves that make you want to touch it, but grown in a deep pot it has been blooming the last several years in the fall	\N	\N
BX 338	BULBS	21	Oxalis obtusa	From Mary Sue Ittner:	MV 5051 Vanrhynshoek. 2 inch lt copper-orange, darker veining, yellow ctr.	\N	\N
BX 338	BULBS	22	Oxalis palmifrons	From Mary Sue Ittner:	-grown for the leaves, mine have never flowered, but the leaves I like	\N	\N
BX 338	BULBS	23	Oxalis polyphylla	From Mary Sue Ittner:	var heptaphylla MV 4381B - 4km into Skoemanskloof from Oudtshoorn. Long, succulent, thread-like leaves	\N	\N
BX 338	BULBS	24	Oxalis polyphylla	From Mary Sue Ittner:	var heptaphylla MV6396 Vanrhynsdorp. Succulent thread-like leaves. Winter growing, blooms fall	\N	\N
BX 338	BULBS	25	Oxalis pulchella	From Mary Sue Ittner:	var tomentosa - ex BX 221 and Ron Vanderhoff - Low, pubescent, mat forming foliage and large very pale salmon colored flowers. Fall blooming. This one hasn't bloomed for me yet, but I keep hoping as the bulbs are getting bigger and bigger	\N	\N
BX 338	BULBS	26	Oxalis purpurea (white)	From Mary Sue Ittner:	(white) winter growing, long blooming, but beware of planting in the ground in a Mediterranean climate unless you don't care if it takes over as it expands dramatically, a lot.	\N	w
BX 338	BULBS	27	Oxalis purpurea 'Lavender & White'	From Mary Sue Ittner:	Lavender & White'	\N	\N
BX 338	BULBS	28	Oxalis purpurea 'Skar'	From Mary Sue Ittner:	originally from Bill Baird, long blooming, pink flowers	\N	\N
BX 338	BULBS	29	Oxalis versicolor	From Mary Sue Ittner:	--lovely white with candy stripe on back, winter blooming	\N	\N
BX 338	BULBS	30	Tulipa humilis	From Mary Sue Ittner:	Red Cup' - received as this from Brent & Becky's, but I can't find validation about the name. There is a Tulipa hageri 'Red Cup'. I'd love to know what the name should be. I've added photos to the wiki	\N	\N
BX 338	BULBS	31	Tulipa turkestanica	From Mary Sue Ittner:	\N	\N	\N
BX 338	BULBS	32	Oxalis zeekoevleyensis	From Mary Sue Ittner:	blooms early fall, lavender flowers	\N	\N
BX 338	BULBS	33	Ferraria sp.	From Arnold Trachtenberg:	? Small corms	\N	\N
BX 339	SEEDS	1	Freesia laxa ssp. cruenta)	M Gastil-Buhl	Primarily winter grower but also grows and blooms some year round. Not as easy to grow as the red ones. Easier to grow than the white ones.	\N	w
BX 339	SEEDS	2	Chasmanthe sp.	M Gastil-Buhl	Winter grower / Summer deciduous Very weedy in Southern California. (Too easy to grow.)	\N	w
BX 339	BULBS	3	Oxalis obtusa	From Mary Sue Ittner:	MV5005a 10km n of Matjiesfontein. Red-orange	\N	\N
BX 339	BULBS	4	Tulipa clusiana	From Mary Sue Ittner:	small bulbs, not blooming size	\N	\N
BX 339	BULBS	5	Oxalis depressa	From Mary Sue Ittner:	MV 4871	\N	\N
BX 339	SEEDS	6	Tritonia dubia	From Monica Swartz:	\N	\N	\N
BX 339	SEEDS	7	Romulea gigantea	From Monica Swartz:	\N	\N	\N
BX 339	SEEDS	8	Albuca suaveolens	From Monica Swartz:	\N	\N	\N
BX 339	SEEDS	9	Freesia refracta	From Monica Swartz:	\N	\N	\N
BX 339	BULBS	10	Cyrtanthus elatus x montanus	From Monica Swartz:	Bulblets	\N	\N
BX 339	BULBS	11	Cyrtanthus sanguineus	From Monica Swartz:	Bulblets	\N	\N
BX 339	BULBS	12	Lachenalia orchioidesr var. glaucina	From Arnold Trachtenberg	Bulblets	\N	\N
BX 339	BULBS	13	Lachenalia glauca	From Arnold Trachtenberg	Bulblets	\N	\N
BX 339	BULBS	14	Lachenalia namaquensis	From Arnold Trachtenberg	Bulblets	\N	\N
BX 339	BULBS	15	Lachenalia aloides var. quadricolor	From Arnold Trachtenberg	Bulblets	\N	\N
BX 339	BULBS	16	Lachenalia viridiflora	From Arnold Trachtenberg	Bulblets	\N	\N
BX 339	BULBS	17	Lachenalia comptonii	From Arnold Trachtenberg	Bulblets	\N	\N
BX 339	BULBS	18	Cyrtanthus labiatus	From Arnold Trachtenberg	Bulblets	\N	\N
BX 339	BULBS	19	Stenomesson pearcei	From Arnold Trachtenberg	Bulblets	\N	\N
BX 339	SEEDS	20	Lachenalia reflexa	From Arnold Trachtenberg	\N	\N	\N
BX 339	SEEDS	21	Tristagma uniflorum 'Charlotte Bishop'	From Kathleen Sayce:	formerly Ipheion, has large pink flowers. Plants should not completely dry out during summer dormancy. (few)	\N	\N
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

