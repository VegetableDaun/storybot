SELECT insert_cities(Null);
SELECT insert_states('FL', 'Florida');
SELECT insert_street_names('Kukola');
SELECT insert_postal_codes('89383244');
SELECT insert_countries('CANADA');
SELECT insert_listing_agents('Kirill Ilenkov', '3534', '@mail', 'Batum');
SELECT insert_types('Sold');
SELECT insert_statuses('Sold');

INSERT INTO properties (source_listing_id, city_id, state_code_id, country_id, street_name_id, postal_code_id,
                        status_id, type_id, agent_id)
VALUES ('345643', 1, 1, 1, 1, 1, 1, 1, 1);

SELECT *
FROM properties;

SELECT insert_property_keyword(12, 'muda');
SELECT insert_heating_cooling_features(12, 'Cooling Features: Central AC');
SELECT insert_interior_features(4, 'Laminate');
-- SELECT insert_building_construction_features(10, );
SELECT insert_nearby_school(10, 'garage 1');
SELECT insert_properties_garage_parking(12, 'garage 2');
SELECT insert_exterior_features(12, 'Deck1');
SELECT insert_properties_land_info(12, 'mda3');
SELECT insert_properties_styles(12, 'mda4');
SELECT insert_estimates(10, 'Estimater5', 4000000, DATE('05-12-2024'));

SELECT insert_tax_history(12, 2022, 1966,
                          75164, 7429, 82593,
                          187911, 18573, 206484);

SELECT ('2024-12-05T12:34:56Z'::timestamp AT TIME ZONE 'UTC');
SELECT to_timestamp('2024-12-05T12:34:56Z', 'YYYY-MM-DD"T"HH24:MI:SS"Z"') AT TIME ZONE 'UTC';
SELECT Date('2017-01-04');

SELECT property.insert_properties(input_property_realtor_id := 6196451489,
                                  input_source_listing_id := 912841,
                                  input_source_name := 'Moultrie',
                                  input_agent_name := 'Sonny Gay',
                                  input_agent_phone := Null,
                                  input_agent_email := Null,
                                  input_agent_brokerage := 'Birch & Pine Real Estate',
                                  input_state_code := 'GA',
                                  input_state_name := 'Georgia',
                                  input_city_name := 'Moultrie',
                                  input_street_name := 'Tom Smith',
                                  input_line := '715 Tom Smith Rd',
                                  input_postal_code := 31768,
                                  input_country := 'USA',
                                  input_APN := Null,
                                  input_lat := 31.251046,
                                  input_lon := -83.904841,
                                  input_stories := 1,
                                  input_status := 'for_sale',
                                  input_type := 'single_family',
                                  input_garage := 2,
                                  input_baths := 4,
                                  input_beds := 4,
                                  input_year_built := 2005,
                                  input_sold_price := 220000,
                                  input_sold_date := Date('2017-01-04'),
                                  input_list_price := 479000,
                                  input_lot_sqft := 217800,
                                  input_sqft := 3171,
                                  input_hoa_fee := Null,
                                  input_pending := Null,
                                  input_contingent := Null,
                                  input_foreclosure := Null,
                                  input_new_construction := Null,
                                  input_list_date :=
                                          to_timestamp('2024-07-13T07:34:45Z', 'YYYY-MM-DD"T"HH24:MI:SS"Z"') AT TIME ZONE
                                          'UTC',
                                  input_date_last_update := Null,
                                  input_primary_photo := 'https://ap.rdcpix.com/b758b87fb6c159baec165a1a2be06ed5l-m3587095548s.jpg',
                                  input_href := 'https://www.realtor.com/realestateandhomes-detail/715-Tom-Smith-Rd_Moultrie_GA_31768_M61964-51489');

DELETE
FROM properties
WHERE property_id = 3;

SELECT
FROM properties
         JOIN properties_styles on properties.property_id = properties_styles.property_id
         JOIN styles_list on properties_styles.style_id = styles_list.style_id;

SELECT *
FROM properties
WHERE href = 'https://www.realtor.com/realestateandhomes-detail/1894-GA-Highway-111_Moultrie_GA_31768_M54623-52010';

SELECT *
FROM properties_styles;

SELECT *
FROM estimate_source;

SELECT pg_size_pretty(pg_database_size('real_estate'));
SELECT pg_size_pretty(pg_total_relation_size('properties'));

SELECT pr.property_id, pr.property_realtor_id, pr.href
FROM properties as pr
         JOIN statuses s on pr.status_id = s.status_id
--          JOIN tax_history th on pr.property_id = th.property_id
--          JOIN property_history ph on pr.property_id = ph.property_id
WHERE status != 'for_rent'
  and NOT EXISTS(SELECT 1
                 FROM tax_history as th
                 WHERE th.property_id = pr.property_id)
  and NOT EXISTS(SELECT 1
                 FROM property_history as ph
                 WHERE ph.property_id = pr.property_id);

SELECT *
FROM properties
LIMIT 1 OFFSET 4;

SELECT *
FROM properties as pr
         JOIN statuses s on pr.status_id = s.status_id
     --          JOIN types tp on pr.type_id = tp.type_id

--          JOIN cities c on c.city_id = pr.city_id
--          JOIN countries c2 on c2.country_id = pr.country_id
--          JOIN states s2 on pr.state_code_id = s2.state_code_id
--          JOIN postal_codes pc on pr.postal_code_id = pc.postal_code_id
--          JOIN street_names sn on pr.street_name_id = sn.street_name_id
WHERE s.status in ('for_sale');

SELECT pr.property_id, sqft
FROM property.properties as pr
         JOIN properties_keywords pk on pr.property_id = pk.property_id
         JOIN keywords_list kl ON pk.keyword_id = kl.keyword_id
GROUP BY pr.property_id
HAVING ARRAY ['swimming_pool'] <@ ARRAY_AGG(kl.keyword)
ORDER BY sqft DESC
LIMIT 300 OFFSET 0;

SELECT DISTINCT property_id
FROM properties_keywords as pk
         JOIN keywords_list kl on pk.keyword_id = kl.keyword_id
WHERE kl.keyword = 'swimming_pool';

SELECT *
FROM properties_keywords as pk
         JOIN keywords_list kl on pk.keyword_id = kl.keyword_id
WHERE pk.property_id = 186;


SELECT property_id
FROM properties_keywords as pk
         JOIN keywords_list kl ON pk.keyword_id = kl.keyword_id
GROUP BY pk.property_id
HAVING ARRAY ['swimming_pool', 'modern_kitchen'] <@ ARRAY_AGG(kl.keyword);


-- SELECT FROM DB

SELECT pr.property_id,
       pr.property_realtor_id,
       pr.source_listing_id,
       pr.line,
       pr.apn,
       pr.lat,
       pr.lon,
       pr.stories,
       pr.garage,
       pr.baths,
       pr.beds,
       pr.year_built,
       pr.sold_price,
       pr.sold_date,
       pr.lot_sqft,
       pr.sqft,
       pr.hoa_fee,
       pr.pending,
       pr.contingent,
       pr.foreclosure,
       pr.new_construction,
       pr.date_last_update,
       pr.primary_photo,
       pr.href,
       pr.list_date,
       pr.list_price,
       la.agent_name,
       la.agent_email,
       la.agent_phone,
       la.agent_brokerage,
       ra.provided_by,
       ra.provider_phone,
       ra.managed_by,
       ra.manager_phone,
       ra.advertiser_phone,
       s.status,
       tp.type,
       c.city_name,
       c2.country,
       sn.street_name,
       pc.postal_code,
       s2.state_code,
       s2.state_name,
       s3.source_name

FROM property.properties as pr
         JOIN listing_agents la on la.agent_id = pr.agent_id
         JOIN rental_agents ra on pr.rental_agent_id = ra.rental_agent_id

         JOIN property.statuses s on pr.status_id = s.status_id
         JOIN property.types tp on tp.type_id = pr.type_id
         JOIN property.cities c on c.city_id = pr.city_id
         JOIN property.countries c2 on c2.country_id = pr.country_id
         JOIN property.street_names sn on pr.street_name_id = sn.street_name_id
         JOIN property.postal_codes pc on pr.postal_code_id = pc.postal_code_id
         JOIN property.states s2 on pr.state_code_id = s2.state_code_id
         JOIN property.sources s3 on pr.source_id = s3.source_id
WHERE pr.property_id = 1;

SELECT kl.keyword
FROM properties_keywords as pk
         JOIN property.keywords_list kl on pk.keyword_id = kl.keyword_id
WHERE property_id = 1;

SELECT ifl.interior_feature
FROM property.interior_features
         JOIN interior_features_list ifl on ifl.interior_id = interior_features.interior_id
WHERE property_id = 1;

SELECT hcl.heating_cooling
FROM property.heating_cooling_features as hcf
         JOIN heating_cooling_list hcl on hcl.heating_cooling_id = hcf.heating_cooling_id
WHERE property_id = 1;

SELECT bcl.building_construction
FROM property.building_construction_features as bcf
         JOIN property.building_construction_list bcl on bcf.building_construction_id = bcl.building_construction_id
WHERE bcf.property_id = 1;

SELECT el.exterior
FROM property.exterior_features as ex
         JOIN property.exterior_list el on el.exterior_id = ex.exterior_id
WHERE ex.property_id = 1;

SELECT sl.school
FROM property.nearby_school as ns
         JOIN property.schools_list sl on ns.school_id = sl.school_id
WHERE ns.property_id = 1;

SELECT th.property_id,
       th.year,
       th.tax,
       th.building_assessment,
       th.land_assessment,
       th.total_assessment,
       th.market_building,
       th.market_land,
       th.market_total
FROM property.tax_history as th
WHERE th.property_id = 1;

SELECT ph.property_id,
       ph.date,
       ph.price,
       ph.price_change,
       ph.price_sqft,
       ph.source_listing_id,
       sr.source_name,
       e.event,

       ph.list_price,
       ph.last_status_change_date,
       ph.last_update_date,
       ph.list_date,
       ph.listing_id,
       st.status

FROM property.property_history as ph
         JOIN property.events e on e.event_id = ph.event_id
         JOIN property.sources sr on ph.source_id = sr.source_id
         JOIN property.statuses st on ph.status_id = st.status_id
WHERE ph.property_id = 1;

SELECT es.property_id, es.estimate, es.date, e.source
FROM property.estimates as es
         JOIN estimate_source e on es.source_id = e.source_id
WHERE es.property_id = 186;

SELECT ps.property_id, sl.style
FROM property.properties_styles as ps
         JOIN property.styles_list sl on ps.style_id = sl.style_id
WHERE ps.property_id = 1;

SELECT pgp.property_id, gpl.garage_parking
FROM property.properties_garage_parking as pgp
         JOIN garage_parking_list gpl on pgp.garage_parking_id = gpl.garage_parking_id
WHERE pgp.property_id = 1;

SELECT pli.property_id, lil.land_info
FROM property.properties_land_info as pli
         JOIN land_info_list lil on lil.land_info_id = pli.land_info_id
WHERE pli.property_id = 1;

SELECT if.property_id, ifl.interior_feature
FROM property.interior_features as if
         JOIN property.interior_features_list ifl on ifl.interior_id = if.interior_id
WHERE property_id = 1;


SELECT ph.property_id,
       ph.date,
       ph.price,
       ph.price_change,
       ph.price_sqft,
       ph.source_listing_id,
       sr.source_name,
       e.event,
       ph.list_price,
       ph.last_status_change_date,
       ph.last_update_date,
       ph.list_date,
       ph.listing_id,
       st.status
FROM property.property_history as ph
         JOIN property.events e
              on e.event_id = ph.event_id
         JOIN property.sources sr on ph.source_id = sr.source_id
         JOIN property.statuses st on ph.status_id = st.status_id
WHERE ph.property_id = 186;

SELECT *
FROM properties
         JOIN statuses s on properties.status_id = s.status_id
WHERE status != 'for_rent';


SELECT count(*), state
FROM pg_stat_activity
GROUP BY state;

SELECT *
FROM properties
         JOIN exterior_features ef on properties.property_id = ef.property_id;

SELECT *
FROM tax_history;


SELECT property.properties.property_id,
       property.properties.property_realtor_id,
       property.properties.source_listing_id,
       property.properties.source_id,
       property.properties.agent_id,
       property.properties.rental_agent_id,
       property.properties.state_code_id,
       property.properties.city_id,
       property.properties.street_name_id,
       property.properties.line,
       property.properties.postal_code_id,
       property.properties.country_id,
       property.properties.apn,
       property.properties.lat,
       property.properties.lon,
       property.properties.stories,
       property.properties.status_id,
       property.properties.type_id,
       property.properties.garage,
       property.properties.baths,
       property.properties.beds,
       property.properties.year_built,
       property.properties.sold_price,
       property.properties.sold_date,
       property.properties.list_price,
       property.properties.lot_sqft,
       property.properties.sqft,
       property.properties.hoa_fee,
       property.properties.pending,
       property.properties.contingent,
       property.properties.foreclosure,
       property.properties.new_construction,
       property.properties.list_date,
       property.properties.date_last_update,
       property.properties.primary_photo,
       property.properties.href,
       sources_1.source_id             AS source_id_1,
       sources_1.source_name,
       listing_agents_1.agent_id       AS agent_id_1,
       listing_agents_1.agent_name,
       listing_agents_1.agent_phone,
       listing_agents_1.agent_email,
       listing_agents_1.agent_brokerage,
       rental_agents_1.rental_agent_id AS rental_agent_id_1,
       rental_agents_1.provided_by,
       rental_agents_1.provider_phone,
       rental_agents_1.managed_by,
       rental_agents_1.manager_phone,
       rental_agents_1.advertiser_phone,
       states_1.state_code_id          AS state_code_id_1,
       states_1.state_code,
       states_1.state_name,
       cities_1.city_id                AS city_id_1,
       cities_1.city_name,
       street_names_1.street_name_id   AS street_name_id_1,
       street_names_1.street_name,
       postal_codes_1.postal_code_id   AS postal_code_id_1,
       postal_codes_1.postal_code,
       countries_1.country_id          AS country_id_1,
       countries_1.country,
       statuses_1.status_id            AS status_id_1,
       statuses_1.status,
       types_1.type_id                 AS type_id_1,
       types_1.type
FROM property.properties
         LEFT OUTER JOIN property.sources AS sources_1 ON sources_1.source_id = property.properties.source_id
         LEFT OUTER JOIN property.listing_agents AS listing_agents_1
                         ON listing_agents_1.agent_id = property.properties.agent_id
         LEFT OUTER JOIN property.rental_agents AS rental_agents_1
                         ON rental_agents_1.rental_agent_id = property.properties.rental_agent_id
         LEFT OUTER JOIN property.states AS states_1 ON states_1.state_code_id = property.properties.state_code_id
         LEFT OUTER JOIN property.cities AS cities_1 ON cities_1.city_id = property.properties.city_id
         LEFT OUTER JOIN property.street_names AS street_names_1
                         ON street_names_1.street_name_id = property.properties.street_name_id
         LEFT OUTER JOIN property.postal_codes AS postal_codes_1
                         ON postal_codes_1.postal_code_id = property.properties.postal_code_id
         LEFT OUTER JOIN property.countries AS countries_1 ON countries_1.country_id = property.properties.country_id
         LEFT OUTER JOIN property.statuses AS statuses_1 ON statuses_1.status_id = property.properties.status_id
         LEFT OUTER JOIN property.types AS types_1 ON types_1.type_id = property.properties.type_id;

SELECT properties.property_id, status
FROM properties
         JOIN statuses ON properties.status_id = statuses.status_id
WHERE status != 'for_rent';

SELECT properties.property_id, properties.property_realtor_id, properties.href
FROM properties
         JOIN statuses ON properties.status_id = statuses.status_id
WHERE statuses.status != 'for_rent'
  AND NOT EXISTS(SELECT *
             FROM tax_history
             WHERE properties.property_id = tax_history.property_id)
  AND NOT EXISTS(SELECT *
             FROM property_history
             WHERE properties.property_id = property_history.property_id);


SELECT pr.property_id, pr.property_realtor_id, pr.href
FROM properties as pr
         JOIN statuses s on pr.status_id = s.status_id
WHERE status != 'for_rent'
  and NOT EXISTS(SELECT 1
                 FROM tax_history as th
                 WHERE th.property_id = pr.property_id)
  and NOT EXISTS(SELECT 1
                 FROM property_history as ph
                 WHERE ph.property_id = pr.property_id);


DELETE
FROM property_history
WHERE property_id = property_id;




