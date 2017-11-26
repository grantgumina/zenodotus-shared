--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: links; Type: TABLE; Schema: public; Owner: zeno
--

CREATE TABLE links (
    id integer NOT NULL,
    url text NOT NULL
);


ALTER TABLE links OWNER TO zeno;

--
-- Name: links_id_seq; Type: SEQUENCE; Schema: public; Owner: zeno
--

CREATE SEQUENCE links_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE links_id_seq OWNER TO zeno;

--
-- Name: links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: zeno
--

ALTER SEQUENCE links_id_seq OWNED BY links.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: zeno
--

CREATE TABLE messages (
    id integer NOT NULL,
    body text NOT NULL,
    sender text NOT NULL,
    channel text NOT NULL
);


ALTER TABLE messages OWNER TO zeno;

--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: zeno
--

CREATE SEQUENCE messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE messages_id_seq OWNER TO zeno;

--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: zeno
--

ALTER SEQUENCE messages_id_seq OWNED BY messages.id;


--
-- Name: tagged-links; Type: TABLE; Schema: public; Owner: zeno
--

CREATE TABLE "tagged-links" (
    id integer NOT NULL,
    tagid integer,
    linkid integer
);


ALTER TABLE "tagged-links" OWNER TO zeno;

--
-- Name: tagged-links_id_seq; Type: SEQUENCE; Schema: public; Owner: zeno
--

CREATE SEQUENCE "tagged-links_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "tagged-links_id_seq" OWNER TO zeno;

--
-- Name: tagged-links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: zeno
--

ALTER SEQUENCE "tagged-links_id_seq" OWNED BY "tagged-links".id;


--
-- Name: tagged-messages; Type: TABLE; Schema: public; Owner: zeno
--

CREATE TABLE "tagged-messages" (
    id integer NOT NULL,
    messageid integer,
    tagid integer
);


ALTER TABLE "tagged-messages" OWNER TO zeno;

--
-- Name: tagged-messages_id_seq; Type: SEQUENCE; Schema: public; Owner: zeno
--

CREATE SEQUENCE "tagged-messages_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "tagged-messages_id_seq" OWNER TO zeno;

--
-- Name: tagged-messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: zeno
--

ALTER SEQUENCE "tagged-messages_id_seq" OWNED BY "tagged-messages".id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: zeno
--

CREATE TABLE tags (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE tags OWNER TO zeno;

--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: zeno
--

CREATE SEQUENCE tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tags_id_seq OWNER TO zeno;

--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: zeno
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: links id; Type: DEFAULT; Schema: public; Owner: zeno
--

ALTER TABLE ONLY links ALTER COLUMN id SET DEFAULT nextval('links_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: zeno
--

ALTER TABLE ONLY messages ALTER COLUMN id SET DEFAULT nextval('messages_id_seq'::regclass);


--
-- Name: tagged-links id; Type: DEFAULT; Schema: public; Owner: zeno
--

ALTER TABLE ONLY "tagged-links" ALTER COLUMN id SET DEFAULT nextval('"tagged-links_id_seq"'::regclass);


--
-- Name: tagged-messages id; Type: DEFAULT; Schema: public; Owner: zeno
--

ALTER TABLE ONLY "tagged-messages" ALTER COLUMN id SET DEFAULT nextval('"tagged-messages_id_seq"'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: zeno
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: links link_url_unique; Type: CONSTRAINT; Schema: public; Owner: zeno
--

ALTER TABLE ONLY links
    ADD CONSTRAINT link_url_unique UNIQUE (url);


--
-- Name: links links_pkey; Type: CONSTRAINT; Schema: public; Owner: zeno
--

ALTER TABLE ONLY links
    ADD CONSTRAINT links_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: zeno
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: tags tag_name_unique; Type: CONSTRAINT; Schema: public; Owner: zeno
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tag_name_unique UNIQUE (name);


--
-- Name: tagged-links tagged-links_pkey; Type: CONSTRAINT; Schema: public; Owner: zeno
--

ALTER TABLE ONLY "tagged-links"
    ADD CONSTRAINT "tagged-links_pkey" PRIMARY KEY (id);


--
-- Name: tagged-messages tagged-messages_pkey; Type: CONSTRAINT; Schema: public; Owner: zeno
--

ALTER TABLE ONLY "tagged-messages"
    ADD CONSTRAINT "tagged-messages_pkey" PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: zeno
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: tagged-links tagged-links_linkid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: zeno
--

ALTER TABLE ONLY "tagged-links"
    ADD CONSTRAINT "tagged-links_linkid_fkey" FOREIGN KEY (linkid) REFERENCES links(id);


--
-- Name: tagged-links tagged-links_tagid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: zeno
--

ALTER TABLE ONLY "tagged-links"
    ADD CONSTRAINT "tagged-links_tagid_fkey" FOREIGN KEY (tagid) REFERENCES tags(id);


--
-- Name: tagged-messages tagged-messages_messageid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: zeno
--

ALTER TABLE ONLY "tagged-messages"
    ADD CONSTRAINT "tagged-messages_messageid_fkey" FOREIGN KEY (messageid) REFERENCES messages(id);


--
-- Name: tagged-messages tagged-messages_tagid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: zeno
--

ALTER TABLE ONLY "tagged-messages"
    ADD CONSTRAINT "tagged-messages_tagid_fkey" FOREIGN KEY (tagid) REFERENCES tags(id);


--
-- PostgreSQL database dump complete
--

