-- Retrieve a list of all flights including their departure and arrival locations, and scheduled times.
SELECT fi.FlightCode, FlightID, Origin, Destination, DepartureTime, DepartureDate
FROM FlightInfo fi INNER JOIN Flight f ON (fi.FlightCode=f.FlightCode)
ORDER BY fi.FlightCode ASC, DepartureDate ASC;


SELECT c.CustomerID, c.Name, Count(t.FlightID) as NumFlights
FROM Customer c INNER JOIN Ticket t  ON (c.CustomerID=t.CustomerID)
GROUP BY c.CustomerID
ORDER BY c.CustomerID ASC;


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














