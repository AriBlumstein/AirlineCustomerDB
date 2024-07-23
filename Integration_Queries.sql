-- Queries for view 1
-- Select query to get the top 5 most profitable codeshare flights
SELECT 
    CodeShareID, MarketingAirline, FlightNumber, FlightDate, Origin, Destination, TotalRevenue
FROM 
    CodeShareRevenue
ORDER BY 
    TotalRevenue DESC
LIMIT 5;

-- Update query to adjust the marketing airline for a specific codeshare flight:
UPDATE CodeShareRevenue
SET MarketingAirline = 'New Airline Partner'
WHERE CodeShareID = 8 AND FlightNumber = 4;

-- Insert query to add a new codeshare flight:
INSERT INTO CodeShareRevenue (CodeShareID, MarketingAirline, FlightNumber, FlightDate, FlightCode, Origin, Destination, TicketsSold, TotalRevenue)
VALUES (123, 'Partner Airlines', 243234, '2024-08-16', 'CH1704', 'JFK', 'TLV', 178, 18000);

-- Delete the record with codeshare id 3895
DELETE FROM CodeShareRevenue
WHERE CodeShareID = 3895;


-- Queries for view 2
-- Select query to retrieve Current Capacity and Status for All Flights
SELECT
	bookingID,
    flightNumber, 
    departureDate, 
    capacity, 
    status 
FROM 
    FlightCapacityInfo;

-- Update query to Change the Capacity and Status of an Existing Flight
UPDATE flightCapacityInfo
SET capacity = 180, status = 'Cancelled'
WHERE flightNumber = 147 and DepartureDate = '2024-12-11';

-- Insert query to Add a New Flight and Its Capacity
INSERT INTO flightCapacityInfo (flightNumber, departureDate, capacity, status, bookingID, price)
VALUES (23534, '2024-08-01', 201, 'Booked', 83811, 360);

-- Delete a Flight from the Schedule
DELETE FROM flightCapacityInfo
WHERE FlightNumber = 147;



-- Extra Select query for View 1: Calculate the average revenue per ticket for each marketing airline
SELECT 
    MarketingAirline, 
    AVG(TotalRevenue / TicketsSold) AS AvgRevenuePerTicket
FROM 
    CodeShareRevenue
GROUP BY 
    MarketingAirline
ORDER BY 
    AvgRevenuePerTicket DESC;



-- Extra Select query for View 2: Retrieve Tickets for Flights with status of Booked
SELECT 
    flightNumber, 
    departureDate, 
    capacity, 
    status 
FROM 
    FlightCapacityInfo
WHERE 
    status = 'Booked';


