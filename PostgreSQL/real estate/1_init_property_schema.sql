CREATE database real_estate;

CREATE SCHEMA property;

-- TODO capitalize-independence

CREATE TABLE listing_agents
(
    agent_id        SERIAL PRIMARY KEY,
    agent_name      TEXT,
    agent_phone     TEXT,
    agent_email     TEXT,
    agent_brokerage TEXT
);

CREATE TABLE rental_agents
(
    rental_agent_id  SERIAL PRIMARY KEY,
    provided_by      TEXT,
    provider_phone   TEXT,

    managed_by       TEXT,
    manager_phone    TEXT,

    advertiser_phone TEXT
);


CREATE TABLE states
(
    state_code_id SERIAL PRIMARY KEY,
    state_code    text UNIQUE,
    state_name    text UNIQUE
);

CREATE TABLE cities
(
    city_id   SERIAL PRIMARY KEY,
    city_name text UNIQUE
);

CREATE TABLE street_names
(
    street_name_id SERIAL PRIMARY KEY,
    street_name    text UNIQUE
);

CREATE TABLE postal_codes
(
    postal_code_id SERIAL PRIMARY KEY,
    postal_code    TEXT UNIQUE
);

CREATE TABLE countries
(
    country_id SERIAL PRIMARY KEY,
    country    text UNIQUE
);

CREATE TABLE statuses
(
    status_id SERIAL PRIMARY KEY,
    status    text UNIQUE
);

CREATE TABLE types
(
    type_id SERIAL PRIMARY KEY,
    type    text UNIQUE
);

CREATE TABLE sources
(
    source_id   SERIAL PRIMARY KEY,
    source_name text UNIQUE
);

CREATE TABLE properties
(
    property_id         BIGSERIAL PRIMARY KEY,
    property_realtor_id BIGINT,
    source_listing_id   TEXT,
    source_id           SERIAL,

    agent_id            SERIAL,
    rental_agent_id     SERIAL,

    state_code_id       SERIAL,
    city_id             SERIAL,
    street_name_id      SERIAL,
    line                text,
    postal_code_id      SERIAL,
    country_id          SERIAL,
    APN                 text,

    lat                 float,
    lon                 float,

    stories             integer,

    status_id           SERIAL,
    type_id             SERIAL,

    garage              integer,
    baths               integer,
    beds                integer,
    year_built          integer CHECK (year_built >= 0 AND year_built <= 9999),
    sold_price          integer,
    sold_date           DATE,
    list_price          integer,
    lot_sqft            integer,
    sqft                integer,
    hoa_fee             float,

    pending             bool,
    contingent          bool,
    foreclosure         bool,
    new_construction    bool,

    list_date           DATE,
--     date_marked_pending DATE, --TODO
    date_last_update    DATE,

    primary_photo       text,
    href                text,

    CONSTRAINT state_constrain
        FOREIGN KEY (state_code_id) REFERENCES states (state_code_id),

    CONSTRAINT city_constrain
        FOREIGN KEY (city_id) REFERENCES cities (city_id),

    CONSTRAINT street_name_constrain
        FOREIGN KEY (street_name_id) REFERENCES street_names (street_name_id),

    CONSTRAINT postal_code_constrain
        FOREIGN KEY (postal_code_id) REFERENCES postal_codes (postal_code_id),

    CONSTRAINT country_constrain
        FOREIGN KEY (country_id) REFERENCES countries (country_id),

    CONSTRAINT statuses_constrain
        FOREIGN KEY (status_id) REFERENCES statuses (status_id),

    CONSTRAINT type_constrain
        FOREIGN KEY (type_id) REFERENCES types (type_id),

    CONSTRAINT agent_constrains
        FOREIGN KEY (agent_id) REFERENCES listing_agents (agent_id),

    CONSTRAINT rental_agent_id_constrains
        FOREIGN KEY (rental_agent_id) REFERENCES rental_agents (rental_agent_id),

    CONSTRAINT source_constrain
        FOREIGN KEY (source_id) REFERENCES sources (source_id)

);

SELECT *
FROM properties;