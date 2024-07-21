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








