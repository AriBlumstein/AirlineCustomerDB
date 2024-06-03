-- Retrieve a list of all flights including their departure and arrival locations, and scheduled times.
SELECT fi.FlightCode, FlightID, Origin, Destination, DepartureTime, DepartureDate
FROM FlightInfo fi INNER JOIN Flight f ON (fi.FlightCode=f.FlightCode)
ORDER BY fi.FlightCode ASC, DepartureDate ASC;

SELECT c.CustomerID, c.Name, Count(t.FlightID) as NumFlights
FROM Customer c INNER JOIN Ticket t  ON (c.CustomerID=t.CustomerID)
GROUP BY c.CustomerID
ORDER BY c.CustomerID ASC;


WITH RewardsTickets as (
	SELECT TicketID, rc.CustomerID 
	FROM Ticket t INNER JOIN RewardsCustomer rc on (t.CustomerID=rc.CustomerID)
	)
SELECT CustomerID, ROUND(AVG(Rating),1) AS AvgRating
FROM RewardsTickets INNER JOIN Review ON (RewardsTickets.TicketID=Review.TicketID)
GROUP BY CustomerID
ORDER BY CustomerID ASC;


SELECT 
    c.CustomerID, 
    c.Name, 
    COUNT(t.TicketID) AS total_flights, 
    (SELECT fi.Destination 
     FROM Ticket t2 JOIN Flight f ON (t2.FlightID = f.FlightID) JOIN FlightInfo fi ON (f.FlightCode = fi.FlightCode)
     WHERE t2.CustomerID = c.CustomerID 
     GROUP BY fi.Destination 
     ORDER BY COUNT(*) DESC 
     LIMIT 1) AS most_frequent_destination
FROM Customer c 
INNER JOIN Ticket t ON c.CustomerID = t.CustomerID
GROUP BY c.CustomerID
HAVING COUNT(t.TicketID) > 5
ORDER BY total_flights DESC;















