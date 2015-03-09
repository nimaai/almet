--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: check_existence_of_reservations(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION check_existence_of_reservations() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
          BEGIN
            IF NOT EXISTS (
              SELECT *
              FROM reservations
              WHERE visitor_id = NEW.id )
            THEN
              RAISE EXCEPTION 'Visitor must have some reservations';
            END IF;

            RETURN NEW;
          END;
          $$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: reservations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE reservations (
    id integer NOT NULL,
    arrival date NOT NULL,
    departure date NOT NULL,
    adults integer DEFAULT 1 NOT NULL,
    visitor_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    children integer DEFAULT 0 NOT NULL,
    bedclothes_service boolean DEFAULT true NOT NULL
);


--
-- Name: reservations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reservations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reservations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reservations_id_seq OWNED BY reservations.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: visitors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE visitors (
    id integer NOT NULL,
    firstname character varying NOT NULL,
    lastname character varying NOT NULL,
    street character varying NOT NULL,
    zip character varying NOT NULL,
    city character varying NOT NULL,
    country character varying NOT NULL,
    phone character varying,
    mobile character varying,
    email character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT either_phone_or_mobile_must_be_set CHECK (((phone IS NOT NULL) OR (mobile IS NOT NULL)))
);


--
-- Name: visitors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE visitors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: visitors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE visitors_id_seq OWNED BY visitors.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reservations ALTER COLUMN id SET DEFAULT nextval('reservations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY visitors ALTER COLUMN id SET DEFAULT nextval('visitors_id_seq'::regclass);


--
-- Name: reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reservations
    ADD CONSTRAINT reservations_pkey PRIMARY KEY (id);


--
-- Name: visitors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY visitors
    ADD CONSTRAINT visitors_pkey PRIMARY KEY (id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: trigger_existence_of_reservations; Type: TRIGGER; Schema: public; Owner: -
--

CREATE CONSTRAINT TRIGGER trigger_existence_of_reservations AFTER INSERT OR UPDATE ON visitors DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE PROCEDURE check_existence_of_reservations();


--
-- Name: fk_rails_b8a7414b9d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reservations
    ADD CONSTRAINT fk_rails_b8a7414b9d FOREIGN KEY (visitor_id) REFERENCES visitors(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20131025210455');

INSERT INTO schema_migrations (version) VALUES ('20131025210541');

INSERT INTO schema_migrations (version) VALUES ('20131223141559');

INSERT INTO schema_migrations (version) VALUES ('20131223141824');

INSERT INTO schema_migrations (version) VALUES ('20131223152029');

INSERT INTO schema_migrations (version) VALUES ('20131223160925');

INSERT INTO schema_migrations (version) VALUES ('20150222103040');

INSERT INTO schema_migrations (version) VALUES ('20150222120950');

