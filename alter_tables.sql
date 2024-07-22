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


--Alter our flightInfo to add flight numbers from their flight table
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



--Alter Ticket table and add booking
-- Step 1: Create a new local Booking table in the customers database
-- This command is in Added_Tables_Integration_stage.sql

-- Step 2: Alter the existing Ticket table in the customers database
ALTER TABLE Ticket
ADD COLUMN OriginalTicketNumber INT,
ADD COLUMN Price FLOAT,
ADD COLUMN Status ticket_status,
ADD COLUMN BookingID INT,
ADD FOREIGN KEY (BookingID) REFERENCES Local_Booking(BookingID);

ALTER TABLE Ticket DROP CONSTRAINT unique_seat;

-- Step 3: Insert data into the new Local_Booking table
INSERT INTO Local_Booking (BookingDate, Status, Cost, CustomerID)
SELECT 
    b.BookingDate,
    b.Status::booking_status,
    b.Cost,
    COALESCE(ctp.CustomerID, b.PassengerID) -- Use existing CustomerID if available, otherwise use PassengerID
FROM 
    Booking b -- This refers to the foreign Booking table
LEFT JOIN 
    CustomerToPassenger ctp ON (ctp.PassengerID = b.PassengerID);

-- Step 4: Insert data from foreign_ticket into the customers Ticket table
INSERT INTO Ticket (
    TicketID, 
    TicketClass, 
    SeatNumber, 
    CustomerID, 
    FlightID, 
    Zone,
    OriginalTicketNumber,
    Price,
    Status,
    BookingID
)
SELECT 
    nextval('ticket_id_seq'), -- Assuming you have a sequence for TicketID
    CASE 
        WHEN ft.Class = 'Economy' THEN 'Economy'::ticketClass
        WHEN ft.Class = 'EconPlus' THEN 'Premium'::ticketClass
        WHEN ft.Class = 'Business' THEN 'Business'::ticketClass
        WHEN ft.Class = 'First' THEN 'FirstClass'::ticketClass
        ELSE 'Economy'::ticketClass -- Default to Economy if there's an unexpected value
    END AS TicketClass,
    ft.SeatNumber,
    COALESCE(ctp.CustomerID, ft.PassengerID), -- Use existing CustomerID if available, otherwise use PassengerID
    f.FlightID,    -- Assuming we have a way to map FlightNumber to FlightID
    (ARRAY['A', 'B', 'C', 'D'])[FLOOR(RANDOM() * 4) + 1],  -- Pick random zone
    ft.TicketNumber,
    ft.Price,
    ft.Status::ticket_status,
    lb.BookingID
FROM 
    foreign_ticket ft
LEFT JOIN 
    CustomerToPassenger ctp ON (ctp.PassengerID = ft.PassengerID)
JOIN 
    Foreign_Flight ff ON ft.FlightNumber = ff.FlightNumber
JOIN 
    Flight f ON f.flightNumber = ff.FlightNumber
LEFT JOIN LATERAL (
    SELECT BookingID
    FROM Local_Booking
    WHERE CustomerID = COALESCE(ctp.CustomerID, ft.PassengerID)
    AND BookingDate = (
        SELECT BookingDate 
        FROM Booking 
        WHERE TicketNumber = ft.TicketNumber 
        ORDER BY BookingDate DESC 
        LIMIT 1
    )
    LIMIT 1
) lb ON true;





-- Copy data from foreign CodeShare table to Local_CodeShare
INSERT INTO Local_CodeShare (FlightNumber, MarketingAirline, Restrictions)
SELECT FlightNumber, MarketingAirline, Restrictions
FROM CodeShare;



-- Copy data from foreign Package table to Local_Package
INSERT INTO Local_Package (PackageName, Price, StartDate, CarModel, ReturnDate)
SELECT PackageName, Price, StartDate, CarModel, ReturnDate
FROM Package;



-- Copy data from foreign Passenger table to Local_Passenger
INSERT INTO Local_Passenger (Name, ContactInfo)
SELECT Name, ContactInfo
FROM Passenger;
