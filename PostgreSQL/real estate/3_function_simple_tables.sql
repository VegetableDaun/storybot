-- Create the stored procedure for cities
CREATE OR REPLACE FUNCTION insert_cities(input_city_name TEXT)
    RETURNS INTEGER
    LANGUAGE plpgsql
AS
$$
DECLARE
    returning_id INTEGER;
BEGIN
    -- Check if the value already exists
    IF EXISTS(SELECT 1
              FROM property.cities
              WHERE city_name = COALESCE(input_city_name, 'Null')) THEN
        -- If it exists, return a message and the existing ID
        SELECT city_id
        INTO returning_id
        FROM property.cities
        WHERE city_name = COALESCE(input_city_name, 'Null');

        RETURN returning_id;

    ELSE
        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.cities (city_name)
        VALUES (COALESCE(input_city_name, 'Null'))
        RETURNING city_id INTO returning_id;

        RETURN returning_id;
    END IF;
END;
$$;


-- Create the stored procedure for states
CREATE OR REPLACE FUNCTION insert_states(input_state_code TEXT, input_state_name TEXT)
    RETURNS INTEGER
    LANGUAGE plpgsql
AS
$$
DECLARE
    returning_id INTEGER;
BEGIN
    -- Check if the value already exists
    IF EXISTS(SELECT 1
              FROM property.states
              WHERE state_code = COALESCE(input_state_code, 'Null')
                and state_name = COALESCE(input_state_name, 'Null')) THEN

        -- If it exists, return a message and the existing ID
        SELECT state_code_id
        INTO returning_id
        FROM property.states
        WHERE state_code = COALESCE(input_state_code, 'Null')
          and state_name = COALESCE(input_state_name, 'Null');

        RETURN returning_id;

    ELSE
        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.states (state_code, state_name)
        VALUES (COALESCE(input_state_code, 'Null'), COALESCE(input_state_name, 'Null'))
        RETURNING state_code_id INTO returning_id;

        RETURN returning_id;
    END IF;
END;
$$;


-- Create the stored procedure for street_names
CREATE OR REPLACE FUNCTION insert_street_names(input_street_name TEXT)
    RETURNS INTEGER
    LANGUAGE plpgsql
AS
$$
DECLARE
    returning_id INTEGER;
BEGIN
    -- Check if the value already exists
    IF EXISTS(SELECT 1
              FROM property.street_names
              WHERE street_name = COALESCE(input_street_name, 'Null')) THEN
        -- If it exists, return a message and the existing ID
        SELECT street_name_id
        INTO returning_id
        FROM property.street_names
        WHERE street_name = COALESCE(input_street_name, 'Null');

        RETURN returning_id;

    ELSE
        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.street_names (street_name)
        VALUES (COALESCE(input_street_name, 'Null'))
        RETURNING street_name_id INTO returning_id;

        RETURN returning_id;
    END IF;
END;
$$;



-- Create the stored procedure for postal_codes
CREATE OR REPLACE FUNCTION insert_postal_codes(input_postal_code TEXT)
    RETURNS INTEGER
    LANGUAGE plpgsql
AS
$$
DECLARE
    returning_id INTEGER;
BEGIN
    -- Check if the value already exists
    IF EXISTS(SELECT 1
              FROM property.postal_codes
              WHERE postal_code = COALESCE(input_postal_code, 'Null')) THEN
        -- If it exists, return a message and the existing ID
        SELECT postal_code_id
        INTO returning_id
        FROM property.postal_codes
        WHERE postal_code = COALESCE(input_postal_code, 'Null');

        RETURN returning_id;

    ELSE
        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.postal_codes (postal_code)
        VALUES (COALESCE(input_postal_code, 'Null'))
        RETURNING postal_code_id INTO returning_id;

        RETURN returning_id;
    END IF;
END;
$$;


-- Create the stored procedure for countries
CREATE OR REPLACE FUNCTION insert_countries(input_country TEXT)
    RETURNS INTEGER
    LANGUAGE plpgsql
AS
$$
DECLARE
    returning_id INTEGER;
BEGIN
    -- Check if the value already exists
    IF EXISTS(SELECT 1
              FROM property.countries
              WHERE country = COALESCE(input_country, 'Null')) THEN
        -- If it exists, return a message and the existing ID
        SELECT country_id
        INTO returning_id
        FROM property.countries
        WHERE country = COALESCE(input_country, 'Null');

        RETURN returning_id;

    ELSE
        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.countries (country)
        VALUES (COALESCE(input_country, 'Null'))
        RETURNING country_id INTO returning_id;

        RETURN returning_id;
    END IF;
END;
$$;


-- Create the stored procedure for listing_agent
CREATE OR REPLACE FUNCTION insert_listing_agents(input_agent_name TEXT,
                                                 input_agent_phone TEXT,
                                                 input_agent_email TEXT,
                                                 input_agent_brokerage TEXT)
    RETURNS INTEGER
    LANGUAGE plpgsql
AS
$$
DECLARE
    returning_id INTEGER;
BEGIN
    -- Check if the value already exists
    IF EXISTS(SELECT 1
              FROM property.listing_agents
              WHERE agent_name = COALESCE(input_agent_name, 'Null')
                and agent_brokerage = COALESCE(input_agent_brokerage, 'Null')) THEN
        -- If it exists, return a message and the existing ID
        SELECT agent_id
        INTO returning_id
        FROM property.listing_agents
        WHERE agent_name = COALESCE(input_agent_name, 'Null')
          and agent_brokerage = COALESCE(input_agent_brokerage, 'Null');

        IF input_agent_phone IS NOT NULL THEN
            UPDATE property.listing_agents
            SET agent_phone = input_agent_phone
            WHERE agent_id = returning_id;
        end if;

        IF input_agent_email IS NOT NULL THEN
            UPDATE property.listing_agents
            SET agent_email = input_agent_email
            WHERE agent_id = returning_id;
        end if;

        RETURN returning_id;

    ELSE
        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.listing_agents (agent_name, agent_phone, agent_email, agent_brokerage)
        VALUES (COALESCE(input_agent_name, 'Null'), input_agent_phone, input_agent_email,
                COALESCE(input_agent_brokerage, 'Null'))
        RETURNING agent_id INTO returning_id;

        RETURN returning_id;
    END IF;
END;
$$;


-- Create the stored procedure for rental_agents
CREATE OR REPLACE FUNCTION insert_rental_agents(input_provided_by TEXT,
                                                input_provider_phone TEXT,
                                                input_managed_by TEXT,
                                                input_manager_phone TEXT,
                                                input_advertiser_phone TEXT)
    RETURNS INTEGER
    LANGUAGE plpgsql
AS
$$
DECLARE
    input_rental_agent_id INTEGER;
BEGIN
    -- Check if the value already exists
    IF EXISTS(SELECT 1
              FROM property.rental_agents
              WHERE provided_by = COALESCE(input_provided_by, 'Null')
                and provider_phone = COALESCE(input_provider_phone, 'Null')
                and managed_by = COALESCE(input_managed_by, 'Null')
                and manager_phone = COALESCE(input_manager_phone, 'Null')
                and advertiser_phone = COALESCE(input_advertiser_phone, 'Null')) THEN

        -- If it exists, return a message and the existing ID
        SELECT rental_agent_id
        INTO input_rental_agent_id
        FROM property.rental_agents
        WHERE provided_by = COALESCE(input_provided_by, 'Null')
          and provider_phone = COALESCE(input_provider_phone, 'Null')
          and managed_by = COALESCE(input_managed_by, 'Null')
          and manager_phone = COALESCE(input_manager_phone, 'Null')
          and advertiser_phone = COALESCE(input_advertiser_phone, 'Null');

        RETURN input_rental_agent_id;

    ELSE

        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.rental_agents (provided_by, provider_phone, managed_by, manager_phone,
                                            advertiser_phone)
        VALUES (COALESCE(input_provided_by, 'Null'),
                COALESCE(input_provider_phone, 'Null'),
                COALESCE(input_managed_by, 'Null'),
                COALESCE(input_manager_phone, 'Null'),
                COALESCE(input_advertiser_phone, 'Null'))
        RETURNING rental_agent_id INTO input_rental_agent_id;

        RETURN input_rental_agent_id;
    END if;
END;
$$;



-- Create the stored procedure for types
CREATE OR REPLACE FUNCTION insert_types(input_type TEXT)
    RETURNS INTEGER
    LANGUAGE plpgsql
AS
$$
DECLARE
    returning_id INTEGER;
BEGIN
    -- Check if the value already exists
    IF EXISTS(SELECT 1
              FROM property.types
              WHERE type = COALESCE(input_type, 'Null')) THEN
        -- If it exists, return a message and the existing ID
        SELECT type_id
        INTO returning_id
        FROM property.types
        WHERE type = COALESCE(input_type, 'Null');

        RETURN returning_id;

    ELSE
        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.types (type)
        VALUES (COALESCE(input_type, 'Null'))
        RETURNING type_id INTO returning_id;

        RETURN returning_id;
    END IF;
END;
$$;


-- Create the stored procedure for statuses
CREATE OR REPLACE FUNCTION insert_statuses(input_status TEXT)
    RETURNS INTEGER
    LANGUAGE plpgsql
AS
$$
DECLARE
    returning_id INTEGER;
BEGIN
    -- Check if the value already exists
    IF EXISTS(SELECT 1
              FROM property.statuses
              WHERE status = COALESCE(input_status, 'Null')) THEN
        -- If it exists, return a message and the existing ID
        SELECT status_id
        INTO returning_id
        FROM property.statuses
        WHERE status = COALESCE(input_status, 'Null');

        RETURN returning_id;

    ELSE
        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.statuses (status)
        VALUES (COALESCE(input_status, 'Null'))
        RETURNING status_id INTO returning_id;

        RETURN returning_id;
    END IF;
END;
$$;

-- Create the stored procedure for sources
CREATE OR REPLACE FUNCTION insert_sources(input_source_name TEXT)
    RETURNS INTEGER
    LANGUAGE plpgsql
AS
$$
DECLARE
    returning_id INTEGER;
BEGIN
    -- Check if the value already exists
    IF EXISTS(SELECT 1
              FROM property.sources
              WHERE source_name = COALESCE(input_source_name, 'Null')) THEN
        -- If it exists, return a message and the existing ID
        SELECT source_id
        INTO returning_id
        FROM property.sources
        WHERE source_name = COALESCE(input_source_name, 'Null');

        RETURN returning_id;

    ELSE
        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.sources (source_name)
        VALUES (COALESCE(input_source_name, 'Null'))
        RETURNING source_id INTO returning_id;

        RETURN returning_id;
    END IF;
END;
$$;

