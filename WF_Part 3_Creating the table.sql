-- Table: public.query

-- DROP TABLE IF EXISTS public.query;

CREATE TABLE IF NOT EXISTS public.query
(
    searchid integer,
    year integer,
    month integer,
    day integer,
    userid integer,
    ts numeric,
    devicetype character varying COLLATE pg_catalog."default",
    deviceid integer,
    query character varying COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.query
    OWNER to postgres;