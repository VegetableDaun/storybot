CREATE OR REPLACE FUNCTION insert_properties(
    input_property_realtor_id BIGINT,
    input_source_listing_id TEXT,
    input_source_name TEXT,
---
    input_agent_name TEXT,
    input_agent_phone TEXT,
    input_agent_email TEXT,
    input_agent_brokerage TEXT,
---
    input_provided_by TEXT,
    input_provider_phone TEXT,
    input_managed_by TEXT,
    input_manager_phone TEXT,
    input_advertiser_phone TEXT,
---
    input_state_code TEXT,
    input_state_name TEXT,
    input_city_name TEXT,
    input_street_name TEXT,
    input_line TEXT,
    input_postal_code TEXT,
    input_country TEXT,
    input_APN TEXT,
---
    input_lat float,
    input_lon float,
---
    input_stories INTEGER,
---
    input_status TEXT,
    input_type TEXT,
---
    input_garage INTEGER,
    input_baths INTEGER,
    input_beds INTEGER,
    input_year_built INTEGER,
    input_sold_price INTEGER,
    input_sold_date DATE,
    input_list_price INTEGER,
    input_lot_sqft INTEGER,
    input_sqft INTEGER,
    input_hoa_fee float,
---
    input_pending bool,
    input_contingent bool,
    input_foreclosure bool,
    input_new_construction bool,
---
    input_list_date DATE,
--     input_date_marked_pending DATE, --TODO
    input_date_last_update DATE, --TODO
---
    input_primary_photo TEXT,
    input_href TEXT)
    RETURNS BIGINT
    LANGUAGE plpgsql
AS
$$
DECLARE
    input_city_id         INTEGER;
    input_state_code_id   INTEGER;
    input_street_name_id  INTEGER;
    input_postal_code_id  INTEGER;
    input_country_id      INTEGER;
    input_agent_id        INTEGER;
    input_type_id         INTEGER;
    input_status_id       INTEGER;
    input_source_id       INTEGER;
    input_rental_agent_id INTEGER;
    returning_property_id BIGINT;
BEGIN
    SELECT property.insert_cities(input_city_name) INTO input_city_id;
    SELECT property.insert_states(input_state_code, input_state_name) INTO input_state_code_id;
    SELECT property.insert_street_names(input_street_name) INTO input_street_name_id;
    SELECT property.insert_postal_codes(input_postal_code) INTO input_postal_code_id;
    SELECT property.insert_countries(input_country) INTO input_country_id;
    SELECT property.insert_listing_agents(input_agent_name,
                                          input_agent_phone,
                                          input_agent_email,
                                          input_agent_brokerage)
    INTO input_agent_id;

    SELECT property.insert_rental_agents(input_provided_by,
                                         input_provider_phone,
                                         input_managed_by,
                                         input_manager_phone,
                                         input_advertiser_phone)
    INTO input_rental_agent_id;


    SELECT property.insert_types(input_type) INTO input_type_id;
    SELECT property.insert_statuses(input_status) INTO input_status_id;
    SELECT property.insert_sources(input_source_name) INTO input_source_id;


    IF NOT EXISTS(SELECT 1
                  FROM property.properties
                  WHERE property_realtor_id = input_property_realtor_id) THEN

        INSERT INTO property.properties (property_realtor_id, source_listing_id, source_id,
                                         agent_id, state_code_id, city_id, street_name_id, line,
                                         postal_code_id, country_id, apn, lat, lon, stories, status_id,
                                         type_id, garage, baths, beds, year_built, sold_price, sold_date,
                                         list_price, lot_sqft, sqft, hoa_fee, pending,
                                         contingent, foreclosure, new_construction, list_date,
                                         rental_agent_id, date_last_update, primary_photo, href)
        VALUES (input_property_realtor_id, input_source_listing_id, input_source_id,
                input_agent_id, input_state_code_id, input_city_id, input_street_name_id, input_line,
                input_postal_code_id, input_country_id, input_apn, input_lat, input_lon,
                input_stories, input_status_id, input_type_id, input_garage, input_baths, input_beds,
                input_year_built, input_sold_price, input_sold_date,
                input_list_price, input_lot_sqft, input_sqft, input_hoa_fee,
                input_pending, input_contingent, input_foreclosure, input_new_construction,
                input_list_date, input_rental_agent_id, input_date_last_update, input_primary_photo,
                input_href)
        RETURNING property_id INTO returning_property_id;
    ELSE
        UPDATE property.properties
        SET property_realtor_id = input_property_realtor_id,
            source_listing_id   = input_source_listing_id,
            source_id           = input_source_id,
            agent_id            = input_agent_id,
            state_code_id       = input_state_code_id,
            city_id             = input_city_id,
            street_name_id      = input_street_name_id,
            line                = input_line,
            postal_code_id      = input_postal_code_id,
            country_id          = input_country_id,
            apn                 = input_apn,
            lat                 = input_lat,
            lon                 = input_lon,
            stories             = input_stories,
            status_id           = input_status_id,
            type_id             = input_type_id,
            garage              = input_garage,
            baths               = input_baths,
            beds                = input_beds,
            year_built          = input_year_built,
            sold_price          = input_sold_price,
            sold_date           = input_sold_date,
            list_price          = input_list_price,
            lot_sqft            = input_lot_sqft,
            sqft                = input_sqft,
            hoa_fee             = input_hoa_fee,
            pending             = input_pending,
            contingent          = input_contingent,
            foreclosure         = input_foreclosure,
            new_construction    = input_new_construction,
            list_date           = input_list_date,
            rental_agent_id     = input_rental_agent_id,
            date_last_update    = input_date_last_update,
            primary_photo       = input_primary_photo,
            href                = input_href
        WHERE property_realtor_id = input_property_realtor_id
        RETURNING property_id INTO returning_property_id;
    end if;

    RETURN returning_property_id;
END;
$$;