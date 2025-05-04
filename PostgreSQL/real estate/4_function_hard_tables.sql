-- Keywords
-- Create the stored procedure for keywords_list
CREATE OR REPLACE FUNCTION insert_keywords_list(input_keyword TEXT)
    RETURNS INTEGER
    LANGUAGE plpgsql
AS
$$
DECLARE
    returning_id INTEGER;
BEGIN
    -- Check if the value already exists
    IF EXISTS(SELECT 1
              FROM property.keywords_list
              WHERE keyword = COALESCE(input_keyword, 'Null')) THEN
        -- If it exists, return a message and the existing ID
        SELECT keyword_id
        INTO returning_id
        FROM property.keywords_list
        WHERE keyword = COALESCE(input_keyword, 'Null');

        RETURN returning_id;

    ELSE
        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.keywords_list (keyword)
        VALUES (COALESCE(input_keyword, 'Null'))
        RETURNING keyword_id INTO returning_id;

        RETURN returning_id;
    END IF;
END;
$$;

-- Create the stored procedure for properties_keywords
CREATE OR REPLACE FUNCTION insert_property_keyword(input_property_id BIGINT, input_keyword TEXT)
    RETURNS VOID
    LANGUAGE plpgsql AS
$$
DECLARE
    input_keyword_id INTEGER;
BEGIN
    SELECT property.insert_keywords_list(input_keyword) INTO input_keyword_id;

    -- Check if the value already exists
    IF NOT EXISTS(SELECT 1
                  FROM property.properties_keywords
                  WHERE property_id = input_property_id
                    and keyword_id = input_keyword_id) THEN

        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.properties_keywords (keyword_id, property_id)
        VALUES (input_keyword_id, input_property_id);
    END IF;
END;
$$;



-- Heating and Cooling
-- Create the stored procedure for heating_cooling_list
CREATE OR REPLACE FUNCTION insert_heating_cooling_list(input_heating_cooling TEXT)
    RETURNS INTEGER
    LANGUAGE plpgsql
AS
$$
DECLARE
    returning_id INTEGER;
BEGIN
    -- Check if the value already exists
    IF EXISTS(SELECT 1
              FROM property.heating_cooling_list
              WHERE heating_cooling = COALESCE(input_heating_cooling, 'Null')) THEN
        -- If it exists, return a message and the existing ID
        SELECT heating_cooling_id
        INTO returning_id
        FROM property.heating_cooling_list
        WHERE heating_cooling = COALESCE(input_heating_cooling, 'Null');

        RETURN returning_id;

    ELSE
        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.heating_cooling_list (heating_cooling)
        VALUES (COALESCE(input_heating_cooling, 'Null'))
        RETURNING heating_cooling_id INTO returning_id;

        RETURN returning_id;
    END IF;
END;
$$;

-- Create the stored procedure for heating_cooling_features
CREATE OR REPLACE FUNCTION insert_heating_cooling_features(input_property_id BIGINT, input_heating_cooling TEXT)
    RETURNS VOID
    LANGUAGE plpgsql AS
$$
DECLARE
    input_heating_cooling_id INTEGER;
BEGIN
    SELECT property.insert_heating_cooling_list(input_heating_cooling) INTO input_heating_cooling_id;

    -- Check if the value already exists
    IF NOT EXISTS(SELECT 1
                  FROM property.heating_cooling_features
                  WHERE property_id = input_property_id
                    and heating_cooling_id = input_heating_cooling_id) THEN

        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.heating_cooling_features (property_id, heating_cooling_id)
        VALUES (input_property_id, input_heating_cooling_id);
    END IF;
END;
$$;


-- Interior features
-- Create the stored procedure for interior_features_list
CREATE OR REPLACE FUNCTION insert_interior_features_list(input_interior_feature TEXT)
    RETURNS INTEGER
    LANGUAGE plpgsql
AS
$$
DECLARE
    returning_id INTEGER;
BEGIN
    -- Check if the value already exists
    IF EXISTS(SELECT 1
              FROM property.interior_features_list
              WHERE interior_feature = COALESCE(input_interior_feature, 'Null')) THEN
        -- If it exists, return a message and the existing ID
        SELECT interior_id
        INTO returning_id
        FROM property.interior_features_list
        WHERE interior_feature = COALESCE(input_interior_feature, 'Null');

        RETURN returning_id;

    ELSE
        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.interior_features_list (interior_feature)
        VALUES (COALESCE(input_interior_feature, 'Null'))
        RETURNING interior_id INTO returning_id;

        RETURN returning_id;
    END IF;
END;
$$;

-- Create the stored procedure for interior_features
CREATE OR REPLACE FUNCTION insert_interior_features(input_property_id BIGINT, input_interior_feature TEXT)
    RETURNS VOID
    LANGUAGE plpgsql AS
$$
DECLARE
    input_interior_feature_id INTEGER;
BEGIN
    SELECT property.insert_interior_features_list(input_interior_feature) INTO input_interior_feature_id;

    -- Check if the value already exists
    IF NOT EXISTS(SELECT 1
                  FROM property.interior_features
                  WHERE property_id = input_property_id
                    and interior_id = input_interior_feature_id) THEN

        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.interior_features (property_id, interior_id)
        VALUES (input_property_id, input_interior_feature_id);
    END IF;
END;
$$;



-- Building and Construction
-- Create the stored procedure for building_construction_list
CREATE OR REPLACE FUNCTION insert_building_construction_list(input_building_construction TEXT)
    RETURNS INTEGER
    LANGUAGE plpgsql
AS
$$
DECLARE
    returning_id INTEGER;
BEGIN
    -- Check if the value already exists
    IF EXISTS(SELECT 1
              FROM property.building_construction_list
              WHERE building_construction = COALESCE(input_building_construction, 'Null')) THEN
        -- If it exists, return a message and the existing ID
        SELECT building_construction_id
        INTO returning_id
        FROM property.building_construction_list
        WHERE building_construction = COALESCE(input_building_construction, 'Null');

        RETURN returning_id;

    ELSE
        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.building_construction_list (building_construction)
        VALUES (COALESCE(input_building_construction, 'Null'))
        RETURNING building_construction_id INTO returning_id;

        RETURN returning_id;
    END IF;
END;
$$;

-- Create the stored procedure for building_construction_features
CREATE OR REPLACE FUNCTION insert_building_construction_features(input_property_id BIGINT, input_building_construction TEXT)
    RETURNS VOID
    LANGUAGE plpgsql AS
$$
DECLARE
    input_building_construction_id INTEGER;
BEGIN
    SELECT property.insert_building_construction_list(input_building_construction) INTO input_building_construction_id;

    -- Check if the value already exists
    IF NOT EXISTS(SELECT 1
                  FROM property.building_construction_features
                  WHERE property_id = input_property_id
                    and building_construction_id = input_building_construction_id) THEN

        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.building_construction_features (property_id, building_construction_id)
        VALUES (input_property_id, input_building_construction_id);
    END IF;
END;
$$;


-- School Information
-- Create the stored procedure for schools_list
CREATE OR REPLACE FUNCTION insert_schools_list(input_school TEXT)
    RETURNS BIGINT
    LANGUAGE plpgsql
AS
$$
DECLARE
    returning_id BIGINT;
BEGIN
    -- Check if the value already exists
    IF EXISTS(SELECT 1
              FROM property.schools_list
              WHERE school = COALESCE(input_school, 'Null')) THEN
        -- If it exists, return a message and the existing ID
        SELECT school_id
        INTO returning_id
        FROM property.schools_list
        WHERE school = COALESCE(input_school, 'Null');

        RETURN returning_id;

    ELSE
        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.schools_list (school)
        VALUES (COALESCE(input_school, 'Null'))
        RETURNING school_id INTO returning_id;

        RETURN returning_id;
    END IF;
END;
$$;

-- Create the stored procedure for nearby_school
CREATE OR REPLACE FUNCTION insert_nearby_school(input_property_id BIGINT, input_school TEXT)
    RETURNS VOID
    LANGUAGE plpgsql AS
$$
DECLARE
    input_school_id BIGINT;
BEGIN
    SELECT property.insert_schools_list(input_school) INTO input_school_id;

    -- Check if the value already exists
    IF NOT EXISTS(SELECT 1
                  FROM property.nearby_school
                  WHERE property_id = input_property_id
                    and school_id = input_school_id) THEN

        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.nearby_school (property_id, school_id)
        VALUES (input_property_id, input_school_id);
    END IF;
END;
$$;



-- Garage and Parking
-- Create the stored procedure for garage_parking_list
CREATE OR REPLACE FUNCTION insert_garage_parking_list(input_garage_parking TEXT)
    RETURNS INTEGER
    LANGUAGE plpgsql
AS
$$
DECLARE
    returning_id INTEGER;
BEGIN
    -- Check if the value already exists
    IF EXISTS(SELECT 1
              FROM property.garage_parking_list
              WHERE garage_parking = COALESCE(input_garage_parking, 'Null')) THEN
        -- If it exists, return a message and the existing ID
        SELECT garage_parking_id
        INTO returning_id
        FROM property.garage_parking_list
        WHERE garage_parking = COALESCE(input_garage_parking, 'Null');

        RETURN returning_id;

    ELSE
        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.garage_parking_list (garage_parking)
        VALUES (COALESCE(input_garage_parking, 'Null'))
        RETURNING garage_parking_id INTO returning_id;

        RETURN returning_id;
    END IF;
END;
$$;


-- Create the stored procedure for properties_garage_parking
CREATE OR REPLACE FUNCTION insert_properties_garage_parking(input_property_id BIGINT, input_garage_parking TEXT)
    RETURNS VOID
    LANGUAGE plpgsql AS
$$
DECLARE
    input_garage_parking_id INTEGER;
BEGIN
    SELECT property.insert_garage_parking_list(input_garage_parking) INTO input_garage_parking_id;

    -- Check if the value already exists
    IF NOT EXISTS(SELECT 1
                  FROM property.properties_garage_parking
                  WHERE property_id = input_property_id
                    and garage_parking_id = input_garage_parking_id) THEN

        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.properties_garage_parking (property_id, garage_parking_id)
        VALUES (input_property_id, input_garage_parking_id);
    END IF;
END;
$$;


-- Exterior and lot features
-- Create the stored procedure for exterior_list
CREATE OR REPLACE FUNCTION insert_exterior_list(input_exterior TEXT)
    RETURNS INTEGER
    LANGUAGE plpgsql
AS
$$
DECLARE
    returning_id INTEGER;
BEGIN
    -- Check if the value already exists
    IF EXISTS(SELECT 1
              FROM property.exterior_list
              WHERE exterior = COALESCE(input_exterior, 'Null')) THEN
        -- If it exists, return a message and the existing ID
        SELECT exterior_id
        INTO returning_id
        FROM property.exterior_list
        WHERE exterior = COALESCE(input_exterior, 'Null');

        RETURN returning_id;

    ELSE
        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.exterior_list (exterior)
        VALUES (COALESCE(input_exterior, 'Null'))
        RETURNING exterior_id INTO returning_id;

        RETURN returning_id;
    END IF;
END;
$$;

-- Create the stored procedure for exterior_features
CREATE OR REPLACE FUNCTION insert_exterior_features(input_property_id BIGINT, input_exterior TEXT)
    RETURNS VOID
    LANGUAGE plpgsql AS
$$
DECLARE
    input_exterior_id INTEGER;
BEGIN
    SELECT property.insert_exterior_list(input_exterior) INTO input_exterior_id;

    -- Check if the value already exists
    IF NOT EXISTS(SELECT 1
                  FROM property.exterior_features
                  WHERE property_id = input_property_id
                    and exterior_id = input_exterior_id) THEN

        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.exterior_features (property_id, exterior_id)
        VALUES (input_property_id, input_exterior_id);
    END IF;
END;
$$;


-- Land Info
-- Create the stored procedure for land_info_list
CREATE OR REPLACE FUNCTION insert_land_info_list(input_land_info TEXT)
    RETURNS INTEGER
    LANGUAGE plpgsql
AS
$$
DECLARE
    returning_id INTEGER;
BEGIN
    -- Check if the value already exists
    IF EXISTS(SELECT 1
              FROM property.land_info_list
              WHERE land_info = COALESCE(input_land_info, 'Null')) THEN
        -- If it exists, return a message and the existing ID
        SELECT land_info_id
        INTO returning_id
        FROM property.land_info_list
        WHERE land_info = COALESCE(input_land_info, 'Null');

        RETURN returning_id;

    ELSE
        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.land_info_list (land_info)
        VALUES (COALESCE(input_land_info, 'Null'))
        RETURNING land_info_id INTO returning_id;

        RETURN returning_id;
    END IF;
END;
$$;

-- Create the stored procedure for properties_land_info
CREATE OR REPLACE FUNCTION insert_properties_land_info(input_property_id BIGINT, input_land_info TEXT)
    RETURNS VOID
    LANGUAGE plpgsql AS
$$
DECLARE
    input_land_info_id INTEGER;
BEGIN
    SELECT property.insert_land_info_list(input_land_info) INTO input_land_info_id;

    -- Check if the value already exists
    IF NOT EXISTS(SELECT 1
                  FROM property.properties_land_info
                  WHERE property_id = input_property_id
                    and land_info_id = input_land_info_id) THEN

        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.properties_land_info (property_id, land_info_id)
        VALUES (input_property_id, input_land_info_id);
    END IF;
END;
$$;


-- Styles
-- Create the stored procedure for styles_list
CREATE OR REPLACE FUNCTION insert_styles_list(input_style TEXT)
    RETURNS INTEGER
    LANGUAGE plpgsql
AS
$$
DECLARE
    returning_id INTEGER;
BEGIN
    -- Check if the value already exists
    IF EXISTS(SELECT 1
              FROM property.styles_list
              WHERE style = COALESCE(input_style, 'Null')) THEN
        -- If it exists, return a message and the existing ID
        SELECT style_id
        INTO returning_id
        FROM property.styles_list
        WHERE style = COALESCE(input_style, 'Null');

        RETURN returning_id;

    ELSE
        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.styles_list (style)
        VALUES (COALESCE(input_style, 'Null'))
        RETURNING style_id INTO returning_id;

        RETURN returning_id;
    END IF;
END;
$$;

-- Create the stored procedure for properties_styles
CREATE OR REPLACE FUNCTION insert_properties_styles(input_property_id BIGINT, input_style TEXT)
    RETURNS VOID
    LANGUAGE plpgsql AS
$$
DECLARE
    input_style_id INTEGER;
BEGIN
    SELECT property.insert_styles_list(input_style) INTO input_style_id;

    -- Check if the value already exists
    IF NOT EXISTS(SELECT 1
                  FROM property.properties_styles
                  WHERE property_id = input_property_id
                    and style_id = input_style_id) THEN

        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.properties_styles (property_id, style_id)
        VALUES (input_property_id, input_style_id);
    END IF;
END;
$$;


-- Estimated values
-- Create the stored procedure for estimate_source
CREATE OR REPLACE FUNCTION insert_estimate_source(input_source TEXT)
    RETURNS INTEGER
    LANGUAGE plpgsql
AS
$$
DECLARE
    returning_id INTEGER;
BEGIN
    -- Check if the value already exists
    IF EXISTS(SELECT 1
              FROM property.estimate_source
              WHERE source = COALESCE(input_source, 'Null')) THEN
        -- If it exists, return a message and the existing ID
        SELECT source_id
        INTO returning_id
        FROM property.estimate_source
        WHERE source = COALESCE(input_source, 'Null');

        RETURN returning_id;

    ELSE
        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.estimate_source (source)
        VALUES (COALESCE(input_source, 'Null'))
        RETURNING source_id INTO returning_id;

        RETURN returning_id;
    END IF;
END;
$$;

-- Create the stored procedure for estimates
CREATE OR REPLACE FUNCTION insert_estimates(input_property_id BIGINT,
                                            input_source TEXT,
                                            input_estimate INTEGER,
                                            input_date DATE
)
    RETURNS VOID
    LANGUAGE plpgsql AS
$$
DECLARE
    input_source_id     INTEGER;
BEGIN
    SELECT property.insert_estimate_source(input_source) INTO input_source_id;

    -- Check if the value already exists
    IF NOT EXISTS(SELECT 1
                  FROM property.estimates
                  WHERE property_id = input_property_id
                    and source_id = input_source_id
                    and date = input_date) THEN

        -- If it doesn't exist, insert the value and return success
        INSERT INTO property.estimates (property_id, source_id, date, estimate)
        VALUES (input_property_id, input_source_id, input_date, input_estimate);
    ELSE
        IF EXISTS(SELECT 1
                  FROM property.estimates
                  WHERE property_id = input_property_id
                    and source_id = input_source_id
                    and date = input_date
                    and estimate != input_estimate) THEN

            UPDATE property.estimates
            SET estimate = input_estimate
            WHERE property_id = input_property_id
              and source_id = input_source_id
              and date = input_date;
        end if;
    END if;
END;
$$;
