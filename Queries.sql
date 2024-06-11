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


-- Reschedule all flights with the flight code GW8225 to 11:15:00
UPDATE FlightInfo
SET DepartureTime = '11:15:00'
WHERE FlightCode = 'GW8225';

-- Reschedule all flights that were scheduled to depart on July 22nd, 2024 to the next day.
UPDATE Flight
SET DepartureDate = '2024-7-23'
WHERE DepartureDate = '2024-7-22';

-- Delete all flights that were completed before July 1st, 2024.

BEGIN;
	DELETE FROM Review 
	WHERE TicketID IN (
		SELECT TicketID FROM Ticket WHERE FlightID IN (
			SELECT FlightID FROM Flight WHERE DepartureDate < '2024-7-1'
		)
	);
	DELETE FROM Ticket
	WHERE FlightID IN (
		SELECT FlightID FROM Flight WHERE DepartureDate < '2024-7-1'
	);
	DELETE FROM Flight
	WHERE DepartureDate < '2024-7-1';

COMMIT;



-- Delete customer records who have not flown in the past month and has no future flights.
BEGIN;

	CREATE TEMPORARY TABLE FlyingCustomers as(
  		SELECT CustomerID 
  		FROM Ticket INNER JOIN Flight ON (Ticket.FlightID = Flight.FlightID)
  		WHERE (Flight.DepartureDate > current_date - interval '1 month')
		);
	
	DELETE FROM PetCustomer
	WHERE CustomerID NOT IN (SELECT CustomerID FROM FlyingCustomers)
	AND CustomerID NOT IN (SELECT CustomerID 
	                		FROM RewardsCustomer);

	DELETE FROM Identification 
	WHERE CustomerID NOT IN (SELECT CustomerID FROM FlyingCustomers)
	AND CustomerID NOT IN (SELECT CustomerID 
	                		FROM RewardsCustomer);

	DELETE FROM Customer
	WHERE CustomerID NOT IN (SELECT CustomerID FROM FlyingCustomers)
	AND CustomerID NOT IN (SELECT CustomerID 
	                		FROM RewardsCustomer);

	DROP TABLE FlyingCustomers;

COMMIT;




