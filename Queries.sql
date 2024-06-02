-- Retrieve a list of all flights including their departure and arrival locations, and scheduled times.
SELECT A.FlightCode, FlightID, Origin, Destination, DepartureTime, DepartureDate
FROM FlightInfo A INNER JOIN Flight B ON (A.FlightCode=B.FlightCode)
ORDER BY A.FlightCode ASC, DepartureDate ASC;

SELECT A.CustomerID, A.Name, Count(B.FlightID) as NumFlights
FROM Customer A INNER JOIN Ticket B ON (A.CustomerID=B.CustomerID)
GROUP BY A.CustomerID
ORDER BY A.CustomerID ASC;


WITH RewardsTickets as (
	SELECT TicketID, B.CustomerID 
	FROM Ticket A INNER JOIN Customer B on (A.CustomerID=B.CustomerID)
	WHERE B.CustomerID in (SELECT CustomerID
	                  	FROM RewardsCustomer)
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















