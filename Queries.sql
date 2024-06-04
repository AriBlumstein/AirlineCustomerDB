--Regular quieries

-- Retrieve a list of all flights including their departure and arrival locations, and scheduled times.
SELECT fi.FlightCode, FlightID, Origin, Destination, DepartureTime, DepartureDate
FROM FlightInfo fi INNER JOIN Flight f ON (fi.FlightCode=f.FlightCode)
ORDER BY fi.FlightCode ASC, DepartureDate ASC;

--Find the total number of bookings made by each customer, including the customer's name.
SELECT c.CustomerID, c.Name, Count(t.FlightID) as NumFlights
FROM Customer c INNER JOIN Ticket t  ON (c.CustomerID=t.CustomerID)
GROUP BY c.CustomerID
ORDER BY c.CustomerID ASC;

--Get the average rating from each rewards customers
WITH RewardsTickets as (    
	SELECT TicketID, CustomerID 
	FROM Ticket                      
	WHERE CustomerID in (Select CustomerID
	                     FROM RewardsCustomer)
	)
SELECT CustomerID, ROUND(AVG(Rating),1) AS AvgRating
FROM RewardsTickets INNER JOIN Review ON (RewardsTickets.TicketID=Review.TicketID)
GROUP BY CustomerID
ORDER BY CustomerID ASC;

--List all customers who have traveled more than five times, including their total number of flights and the most frequent destination.
WITH TicketDetails AS (
    SELECT t.CustomerID, fi.Destination, COUNT(*) AS destination_count, ROW_NUMBER() OVER (PARTITION BY t.CustomerID ORDER BY COUNT(*) DESC) AS rn
    FROM Ticket t
    JOIN Flight f ON (t.FlightID = f.FlightID) JOIN FlightInfo fi ON (f.FlightCode = fi.FlightCode)
    GROUP BY t.CustomerID, fi.Destination
),
	CustomerFlights AS (
    SELECT c.CustomerID, c.Name, COUNT(t.TicketID) AS total_flights
    FROM Customer c
    INNER JOIN Ticket t ON (c.CustomerID = t.CustomerID)
    GROUP BY c.CustomerID, c.Name
    HAVING COUNT(t.TicketID) > 5
)
SELECT cf.CustomerID, cf.Name, cf.total_flights, td.Destination AS most_frequent_destination
FROM CustomerFlights cf
JOIN TicketDetails td ON cf.CustomerID = td.CustomerID AND td.rn = 1
ORDER BY cf.total_flights DESC;




--Parameterized queries
PREPARE Flights_To_Destination (text, date, date) as(
	SELECT $1 as Destination, $2 as start_date, $3 as end_date, COUNT(*)  as total_flights
	FROM Flight
	WHERE DepartureDate BETWEEN $2 and $3
	AND FlightCode in   (Select FlightCode 
	                     FROM FlightInfo
	                     WHERE Destination=$1)
	GROUP BY Destination
	);

execute Flights_To_Destination('EGY', '2023-7-30', '2024-7-31'); 

CREATE OR REPLACE FUNCTION update_flight_info(flight_code TEXT, new_departure_time TIME) RETURNS VOID AS $$
BEGIN
    UPDATE FlightInfo
    SET DepartureTime = new_departure_time
    WHERE FlightCode = flight_code;
END;
$$ LANGUAGE plpgsql;


PREPARE Update_Flights(text, time) AS
    SELECT update_flight_info($1, $2);

Execute Update_Flights('an7575', '9:00:00')











