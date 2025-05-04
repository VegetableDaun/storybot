REASSIGN OWNED BY scraper TO reader; -- some trusted role
DROP OWNED BY scraper;
DROP USER scraper;
-------------------------------------------------------------------------------------------
CREATE USER scraper
    PASSWORD 'scraper2024test';

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO scraper;
GRANT EXECUTE ON ALL ROUTINES IN SCHEMA public to scraper;
GRANT CONNECT ON DATABASE real_estate to scraper;

GRANT SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO scraper;
GRANT USAGE ON SCHEMA public TO scraper;

-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA property TO scraper;
-- GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA property TO scraper;
-- GRANT ALL PRIVILEGES ON DATABASE real_estate TO scraper;

-------------------------------------------------------------------------------------------
CREATE USER api
    PASSWORD 'api2024test';

GRANT SELECT ON ALL TABLES IN SCHEMA property_test TO api;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA property_test TO api;
GRANT CONNECT ON DATABASE real_estate TO api;
GRANT USAGE ON SCHEMA property_test TO api;

-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA property TO api;
-- GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA property TO api;
-- GRANT ALL PRIVILEGES ON DATABASE real_estate TO api;





