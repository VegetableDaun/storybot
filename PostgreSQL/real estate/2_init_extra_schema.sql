/* Keyword list */
CREATE TABLE keywords_list
(
    keyword_id SERIAL PRIMARY KEY,
    keyword    text UNIQUE
);

CREATE TABLE properties_keywords
(
    id          BIGSERIAL PRIMARY KEY,
    property_id BIGSERIAL,
    keyword_id  SERIAL,

    CONSTRAINT property_keyword_constrain
        FOREIGN KEY (property_id) REFERENCES property.properties (property_id),

    CONSTRAINT keyword_constrain
        FOREIGN KEY (keyword_id) REFERENCES keywords_list (keyword_id)
);

/* Interior features */
CREATE TABLE interior_features_list
(
    interior_id      SERIAL PRIMARY KEY,
    interior_feature text UNIQUE
);

CREATE TABLE interior_features
(
    id          BIGSERIAL PRIMARY KEY,
    property_id BIGSERIAL,
    interior_id SERIAL,

    CONSTRAINT property_interior_constrain
        FOREIGN KEY (property_id) REFERENCES property.properties (property_id),

    CONSTRAINT interior_constrain
        FOREIGN KEY (interior_id) REFERENCES interior_features_list (interior_id)
);


/* Heating and Cooling */
CREATE TABLE heating_cooling_list
(
    heating_cooling_id SERIAL PRIMARY KEY,
    heating_cooling    text UNIQUE
);

CREATE TABLE heating_cooling_features
(
    id                 BIGSERIAL PRIMARY KEY,
    property_id        BIGSERIAL,
    heating_cooling_id SERIAL,

    CONSTRAINT property_heating_cooling_constrain
        FOREIGN KEY (property_id) REFERENCES property.properties (property_id),

    CONSTRAINT heating_cooling_constrain
        FOREIGN KEY (heating_cooling_id) REFERENCES heating_cooling_list (heating_cooling_id)
);

/* Building and Construction */
CREATE TABLE building_construction_list
(
    building_construction_id SERIAL PRIMARY KEY,
    building_construction    text UNIQUE
);

CREATE TABLE building_construction_features
(
    id                       BIGSERIAL PRIMARY KEY,
    property_id              BIGSERIAL,
    building_construction_id SERIAL,

    CONSTRAINT property_building_construction_constrain
        FOREIGN KEY (property_id) REFERENCES property.properties (property_id),

    CONSTRAINT building_construction_constrain
        FOREIGN KEY (building_construction_id) REFERENCES building_construction_list (building_construction_id)
);


/* Exterior and lot features */
CREATE TABLE exterior_list
(
    exterior_id SERIAL PRIMARY KEY,
    exterior    text UNIQUE
);

CREATE TABLE exterior_features
(
    id          BIGSERIAL PRIMARY KEY,
    property_id BIGSERIAL,
    exterior_id SERIAL,

    CONSTRAINT property_exterior_constrain
        FOREIGN KEY (property_id) REFERENCES property.properties (property_id),

    CONSTRAINT exterior_constrain
        FOREIGN KEY (exterior_id) REFERENCES exterior_list (exterior_id)
);

/* School information */
/* Schools */
CREATE TABLE schools_list
(
    school_id BIGSERIAL PRIMARY KEY,
    school    text UNIQUE
);

CREATE TABLE nearby_school
(
    id          BIGSERIAL PRIMARY KEY,
    property_id BIGSERIAL,
    school_id   BIGSERIAL,

    CONSTRAINT property_school_constrain
        FOREIGN KEY (property_id) REFERENCES property.properties (property_id),

    CONSTRAINT school_constrain
        FOREIGN KEY (school_id) REFERENCES schools_list (school_id)
);


/* Tax history */
CREATE TABLE tax_history
(
    id                  BIGSERIAL PRIMARY KEY,
    property_id         BIGSERIAL,
    year                integer CHECK (year >= 0 AND year <= 9999),
    tax                 integer,

    building_assessment integer,
    land_assessment     integer,
    total_assessment    integer,

    market_building     integer,
    market_land         integer,
    market_total        integer,

--     land             integer,
--     additions        integer,

    CONSTRAINT property_tax_history_constrain
        FOREIGN KEY (property_id) REFERENCES property.properties (property_id)
);


/* Property history */
CREATE TABLE events
(
    event_id SERIAL PRIMARY KEY,
    event    text UNIQUE
);
CREATE TABLE property_history
(
    id                      BIGSERIAL PRIMARY KEY,
    property_id             BIGSERIAL,
    event_id                integer,
    date                    DATE,
    price                   integer,
    price_change            integer,
    price_sqft              integer,
    source_listing_id       TEXT,
    source_id               integer,

    list_price              integer,
    last_status_change_date DATE,
    last_update_date        DATE,
    status_id               integer,
    list_date               DATE,
    listing_id              BIGINT,

    CONSTRAINT property_history_constrain
        FOREIGN KEY (property_id) REFERENCES property.properties (property_id),

    CONSTRAINT event_constrain
        FOREIGN KEY (event_id) REFERENCES events (event_id),

    CONSTRAINT status_constrain
        FOREIGN KEY (status_id) REFERENCES property.statuses (status_id),

    CONSTRAINT source_name_constrain
        FOREIGN KEY (source_id) REFERENCES property.sources (source_id)
);

/* Estimated values */
CREATE TABLE estimate_source
(
    source_id SERIAL PRIMARY KEY,
    source    text UNIQUE
);

CREATE TABLE estimates
(
    id          BIGSERIAL PRIMARY KEY,
    property_id BIGSERIAL,
    source_id   SERIAL,
    estimate    integer NOT NULL,
    date        DATE    NOT NULL,

    CONSTRAINT property_estimates_constrain
        FOREIGN KEY (property_id) REFERENCES property.properties (property_id),

    CONSTRAINT estimate_source_constrain
        FOREIGN KEY (source_id) REFERENCES estimate_source (source_id)
);


/*Styles*/
CREATE TABLE styles_list
(
    style_id SERIAL PRIMARY KEY,
    style    text UNIQUE
);

CREATE TABLE properties_styles
(
    id          BIGSERIAL PRIMARY KEY,
    property_id BIGSERIAL,
    style_id    SERIAL,

    CONSTRAINT property_styles_constrain
        FOREIGN KEY (property_id) REFERENCES property.properties (property_id),

    CONSTRAINT styles_constrain
        FOREIGN KEY (style_id) REFERENCES styles_list (style_id)
);


/*Garage and Parking*/
CREATE TABLE garage_parking_list
(
    garage_parking_id SERIAL PRIMARY KEY,
    garage_parking    text UNIQUE
);

CREATE TABLE properties_garage_parking
(
    id                BIGSERIAL PRIMARY KEY,
    property_id       BIGSERIAL,
    garage_parking_id SERIAL,

    CONSTRAINT property_garage_parking_constrain
        FOREIGN KEY (property_id) REFERENCES property.properties (property_id),

    CONSTRAINT garage_parking_constrain
        FOREIGN KEY (garage_parking_id) REFERENCES garage_parking_list (garage_parking_id)
);


/*Land Info*/
CREATE TABLE land_info_list
(
    land_info_id SERIAL PRIMARY KEY,
    land_info    text UNIQUE
);

CREATE TABLE properties_land_info
(
    id           BIGSERIAL PRIMARY KEY,
    property_id  BIGSERIAL,
    land_info_id SERIAL,

    CONSTRAINT property_land_info_constrain
        FOREIGN KEY (property_id) REFERENCES property.properties (property_id),

    CONSTRAINT land_info_constrain
        FOREIGN KEY (land_info_id) REFERENCES land_info_list (land_info_id)
);


/* Comparable */
