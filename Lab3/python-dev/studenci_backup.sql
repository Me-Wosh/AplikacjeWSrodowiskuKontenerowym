--
-- PostgreSQL database dump
--

\restrict 67JuliIjbkhMgsMYpWT9Rzjrwy5Oa5NbGhygvc3rGi7p4usPeoqSmtNuKVgCVcR

-- Dumped from database version 16.15
-- Dumped by pg_dump version 16.15

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: studenci; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.studenci (
    id integer NOT NULL,
    imie character varying(50),
    nazwisko character varying(50),
    nr_indeksu character varying(10)
);


ALTER TABLE public.studenci OWNER TO postgres;

--
-- Name: studenci_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.studenci_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.studenci_id_seq OWNER TO postgres;

--
-- Name: studenci_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.studenci_id_seq OWNED BY public.studenci.id;


--
-- Name: studenci id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.studenci ALTER COLUMN id SET DEFAULT nextval('public.studenci_id_seq'::regclass);


--
-- Data for Name: studenci; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.studenci (id, imie, nazwisko, nr_indeksu) FROM stdin;
1	Jan	Kowalski	123456
2	Anna	Nowak	654321
\.


--
-- Name: studenci_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.studenci_id_seq', 2, true);


--
-- Name: studenci studenci_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.studenci
    ADD CONSTRAINT studenci_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

\unrestrict 67JuliIjbkhMgsMYpWT9Rzjrwy5Oa5NbGhygvc3rGi7p4usPeoqSmtNuKVgCVcR

