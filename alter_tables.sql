-- Alter our flight_info table to add capacity
ALTER TABLE flightInfo ADD COLUMN capacity INTEGER;

WITH numbered_flightInfo AS (
  SELECT 
    *,
    ROW_NUMBER() OVER (ORDER BY flightcode) AS row_num
  FROM flightInfo   -- this adds a row number to the flightinfo table
),
numbered_foreign_flight AS (
  SELECT 
    capacity,
    ROW_NUMBER() OVER (ORDER BY flightnumber) AS row_num
  FROM foreign_flight --this adds a row number to the foreign flight table
)
UPDATE flightInfo fi --we add the capacity to our flightinfo table
SET capacity = ff.capacity
FROM numbered_flightInfo nfi
JOIN numbered_foreign_flight ff ON nfi.row_num = ff.row_num --where the row numbers are the same
WHERE fi.flightcode = nfi.flightcode;


--Alter our flight info to add flight numbers from their flight table
ALTER TABLE flight
ADD COLUMN flightnumber INTEGER;
WITH flight_details AS (
    -- Combine flight and flightInfo to get destination and origin codes
    SELECT 
        f.departuredate,
        f.flightid,
        f.flightcode,
        fi.destination AS destination_code,
        fi.origin AS origin_code,
        fi.departuretime
    FROM 
        flight f
    JOIN 
        flightInfo fi ON (f.flightcode = fi.flightcode)
),
flight_locations AS (
    -- Add location names for destination and origin
    SELECT 
        fd.*, --everything from previous table
        dest.city AS destination_location,
        orig.city AS origin_location
    FROM 
        flight_details fd
    INNER JOIN 
        CodeToLocation dest ON (fd.destination_code = dest.citycode)
    INNER JOIN CodeToLocation orig ON (fd.origin_code = orig.citycode)
),
matching_foreign_flights AS (
    -- Find matching flights in foreign_flight based on locations
    SELECT 
        fl.*,
        ff.flightnumber
    FROM 
        flight_locations fl
    LEFT JOIN 
        foreign_flight ff ON  (fl.destination_location = ff.arrivalLocation
                               AND fl.origin_location = ff.departureLocation)
),
ranked_flights AS (
    -- Assign a row number to each flightid to keep only the first occurrence
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY flightid ORDER BY departuredate, flightcode) AS rn
    FROM 
        matching_foreign_flights
)
-- Final Update
UPDATE flight f
SET flightnumber = rf.flightnumber
FROM (
    SELECT 
        flightid,
        flightnumber
    FROM 
        ranked_flights
    WHERE 
        rn = 1
) rf
WHERE f.flightid = rf.flightid;








