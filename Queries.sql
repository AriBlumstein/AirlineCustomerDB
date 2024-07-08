-- Query 1 - Retrieve a list of all flights including their departure and arrival locations, and scheduled times.
SELECT fi.FlightCode, FlightID, Origin, Destination, DepartureTime, DepartureDate
FROM FlightInfo fi INNER JOIN Flight f ON (fi.FlightCode=f.FlightCode)
ORDER BY fi.FlightCode ASC, DepartureDate ASC;

-- Query 2 -Find the total number of bookings made by each customer, including the customer's name.
SELECT c.CustomerID, c.Name, Count(t.FlightID) as NumFlights
FROM Customer c INNER JOIN Ticket t  ON (c.CustomerID=t.CustomerID)
GROUP BY c.CustomerID
ORDER BY c.CustomerID ASC;

-- Query 3 - Get the average rating from each rewards customers
SELECT CustomerID, ROUND(AVG(Rating),1) AS AvgRating
FROM RewardsTickets() INNER JOIN Review ON (RewardsTickets.TicketID=Review.TicketID)
GROUP BY CustomerID
ORDER BY CustomerID ASC;

-- Query 4 - List all customers who have traveled more than five times, including their total number of flights and the most frequent destination.
SELECT cf.CustomerID, cf.Name, cf.total_flights, td.Destination AS most_frequent_destination
FROM CustomerFlights(5) cf
JOIN TicketDetails() td ON cf.CustomerID = td.CustomerID AND td.rn = 1
ORDER BY cf.total_flights DESC;


-- Query 5 - Reschedule all flights with the flight code GW8225 to 11:15:00
UPDATE FlightInfo
SET DepartureTime = '11:15:00'
WHERE FlightCode = 'GW8225';

-- Query 6 - Reschedule all flights that were scheduled to depart on July 22nd, 2024 to the next day.
UPDATE Flight
SET DepartureDate = '2024-7-23'
WHERE DepartureDate = '2024-7-22';

-- Query 7 - Delete all flights that were completed before July 1st, 2024.
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


-- Query 8 - Delete customer records who have not flown in the past month and has no future flights.
BEGIN;

	DELETE FROM PetCustomer
	WHERE CustomerID NOT IN (SELECT CustomerID FROM FlyingCustomers('1 month'))
	AND CustomerID NOT IN (SELECT CustomerID 
	                		FROM RewardsCustomer);

	DELETE FROM Identification 
	WHERE CustomerID NOT IN (SELECT CustomerID FROM FlyingCustomers('1 month'))
	AND CustomerID NOT IN (SELECT CustomerID 
	                		FROM RewardsCustomer);

	DELETE FROM Customer
	WHERE CustomerID NOT IN (SELECT CustomerID FROM FlyingCustomers('1 month'))
	AND CustomerID NOT IN (SELECT CustomerID 
	                		FROM RewardsCustomer);

COMMIT;


-- Query 9 - Retrieve customer details along with their flight information
SELECT c.CustomerID, c.Name, f.FlightId, fi.DepartureDate, fi.Origin, fi.Destination
FROM Customer c
JOIN Ticket t ON c.CustomerID = t.CustomerID
JOIN Flight f ON t.FlightId = f.FlightId
JOIN FlightInfo fi ON fi.FlightCode = f.FlightCode;


-- Query 10 - Retrieve flights with the number of customers booked from JPN
SELECT f.FlightId, f.DepartureDate, fi.Origin, fi.Destination, COUNT(t.CustomerId) AS num_customers
FROM Flight f
JOIN Ticket t ON f.FlightId = t.FlightId
JOIN FlightInfo fi ON fi.FlightCode = f.FlightCode
WHERE fi.Origin = 'JPN'
GROUP BY f.FlightId, f.DepartureDate, fi.Origin, fi.Destination;


-- Query 11 - Retrieve flights and the number of bookings for each flight
SELECT f.FlightId, f.DepartureDate, fi.Destination, COUNT(t.CustomerId) AS num_bookings
FROM Flight f
LEFT JOIN Ticket t ON f.FlightId = t.FlightId
JOIN FlightInfo fi ON fi.FlightCode = f.FlightCode
GROUP BY f.FlightId, f.DepartureDate, fi.Destination;
