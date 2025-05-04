-- Tax History
-- Create the stored procedure for tax_history
CREATE OR REPLACE FUNCTION insert_tax_history(input_property_realtor_id BIGINT,
                                              input_year INTEGER,
                                              input_tax INTEGER,
                                              input_building_assessment INTEGER,
                                              input_land_assessment INTEGER,
                                              input_total_assessment INTEGER,
                                              input_market_building INTEGER,
                                              input_market_land INTEGER,
                                              input_market_total INTEGER)
    RETURNS VOID
    LANGUAGE plpgsql
AS
$$
DECLARE
    input_property_id BIGINT;
BEGIN
    IF NOT EXISTS(SELECT 1
                  FROM property.tax_history
                           JOIN property.properties p on property.tax_history.property_id = p.property_id
                  WHERE p.property_realtor_id = input_property_realtor_id
                    and year = input_year) THEN

        SELECT property_id
        INTO input_property_id
        FROM property.properties
        WHERE property_realtor_id = input_property_realtor_id;


        INSERT INTO property.tax_history (property_id, year, tax, building_assessment,
                                          land_assessment, total_assessment, market_building,
                                          market_land, market_total)
        VALUES (input_property_id, input_year, input_tax, input_building_assessment,
                input_land_assessment, input_total_assessment, input_market_building,
                input_market_land, input_market_total);
    END IF;
END;
$$;

-- Property History
-- Create the stored procedure for events
CREATE OR REPLACE FUNCTION insert_events(input_event TEXT)
    RETURNS INTEGER
    LANGUAGE plpgsql
AS
$$
DECLARE
    returning_id INTEGER;
BEGIN
    -- Check if the value already exists
    IF EXISTS(SELECT 1
              FROM property.events
              WHERE event = COALESCE(input_event, 'Null')) THEN
        -- If it exists, return a message and the existing ID
        SELECT event_id
        INTO returning_id
        FROM property.events
        WHERE event = COALESCE(input_event, 'Null');

        RETURN returning_id;

    ELSE
        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.events (event)
        VALUES (COALESCE(input_event, 'Null'))
        RETURNING event_id INTO returning_id;

        RETURN returning_id;
    END IF;
END;
$$;

-- Create the stored procedure for property_history
CREATE OR REPLACE FUNCTION insert_property_history(
    input_property_realtor_id BIGINT,
    input_event TEXT,
    input_date DATE,
    input_price integer,
    input_price_change integer,
    input_price_sqft float,
    input_source_listing_id TEXT,
    input_source_name text,
    ---
    input_list_price integer,
    input_last_status_change_date DATE,
    input_last_update_date DATE,
    input_status TEXT,
    input_list_date DATE,
    input_listing_id BIGINT
)
    RETURNS VOID
    LANGUAGE plpgsql AS
$$
DECLARE
    input_event_id    INTEGER;
    input_status_id   INTEGER;
    input_source_id   INTEGER;
    input_property_id BIGINT;
BEGIN
    SELECT property.insert_events(input_event) INTO input_event_id;
    SELECT property.insert_statuses(input_status) INTO input_status_id;
    SELECT property.insert_sources(input_source_name) INTO input_source_id;

    -- Check if the value already exists
    IF NOT EXISTS(SELECT 1
                  FROM property.property_history
                           JOIN property.properties p on property.property_history.property_id = p.property_id
                  WHERE p.property_realtor_id = input_property_realtor_id
                    and event_id = input_event_id
                    and date = input_date) THEN

        SELECT property_id
        INTO input_property_id
        FROM property.properties
        WHERE property_realtor_id = input_property_realtor_id;

        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.property_history (property_id, event_id, date,
                                               price, price_change, price_sqft,
                                               source_listing_id, source_id, list_price,
                                               last_status_change_date, last_update_date, status_id,
                                               list_date, listing_id)
        VALUES (input_property_id, input_event_id, input_date,
                input_price, input_price_change, input_price_sqft,
                input_source_listing_id, input_source_id, input_list_price,
                input_last_status_change_date, input_last_update_date, input_status_id,
                input_list_date, input_listing_id);
    ELSE

        SELECT property_id
        INTO input_property_id
        FROM property.properties
        WHERE property_realtor_id = input_property_realtor_id;

        UPDATE property.property_history
        SET price                   = input_price,
            price_change            = input_price_change,
            price_sqft              = input_price_sqft,
            source_listing_id       = input_source_listing_id,
            source_id               = input_source_id,
            list_price              = input_list_price,
            last_status_change_date = input_last_status_change_date,
            last_update_date        = input_last_update_date,
            status_id               = input_status_id,
            list_date               = input_list_date,
            listing_id              = input_listing_id

        WHERE property_id = input_property_id
          and event_id = input_event_id
          and date = input_date;
    END if;
END;
$$;
