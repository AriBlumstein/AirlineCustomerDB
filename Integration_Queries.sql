-- Queries for view 1
-- Query 1: Select query to get the top 5 most profitable codeshare flights
SELECT 
    CodeShareID, MarketingAirline, FlightNumber, FlightDate, Origin, Destination, TotalRevenue
FROM 
    CodeShareRevenue
ORDER BY 
    TotalRevenue DESC
LIMIT 5;

-- Query 2: Update query to adjust the marketing airline for a specific codeshare flight:
UPDATE CodeShareRevenue
SET MarketingAirline = 'New Airline Partner'
WHERE CodeShareID = 8 AND FlightNumber = 4;

-- Query 3: Insert query to add a new codeshare flight:
INSERT INTO CodeShareRevenue (CodeShareID, MarketingAirline, FlightNumber, FlightDate, FlightCode, Origin, Destination, TicketsSold, TotalRevenue)
VALUES (123, 'Partner Airlines', 243234, '2024-08-16', 'CH1704', 'JFK', 'TLV', 178, 18000);

-- Query 4: Delete the record with codeshare id 3895
DELETE FROM CodeShareRevenue
WHERE CodeShareID = 3895;


-- Queries for view 2
-- Query 5: Select query to retrieve current capacity and statuses of the customers for all flights
SELECT
	bookingID,
    flightNumber, 
    departureDate, 
    capacity, 
    status 
FROM 
    FlightCapacityInfo;

-- Query 6: Update query to change the capacity and status for all customers of an existing flight
UPDATE flightCapacityInfo
SET capacity = 180, status = 'Cancelled'
WHERE flightNumber = 147 and DepartureDate = '2024-12-11';

-- Query 7: Insert query to add a new flight and its capacity
INSERT INTO flightCapacityInfo (flightNumber, departureDate, capacity, status, bookingID, price)
VALUES (23534, '2024-08-01', 201, 'Booked', 83811, 360);

-- Query 8: Delete a flight from the schedule
DELETE FROM flightCapacityInfo
WHERE FlightNumber = 147;


-- Query 9
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

-- Query 10
-- Extra query for View 1: Find the total revenue for the year 2024
SELECT SUM(TotalRevenue) AS TotalRevenueInRange
FROM CodeShareRevenue
WHERE FlightDate BETWEEN '2024-01-01' AND '2024-12-31';

-- Query 11
-- Extra Select query for View 2: Retrieve bookings for flights with status of booked
SELECT 
    flightNumber, 
    departureDate, 
    capacity, 
    status 
FROM 
    FlightCapacityInfo
WHERE 
    status = 'Booked';

-- Query 12
-- Extra Select query for View 2: Retrieve flights with bookings with a price above $800
SELECT 
    flightNumber, 
    departureDate, 
    capacity, 
    status, 
    bookingID, 
    price 
FROM 
    FlightCapacityInfo
WHERE 
    price > 800;

