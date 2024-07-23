-- View 1: The CodeShareRevenue view allows the revenue management team to analyze
-- the performance of codeshare flights, identify the most profitable routes,
-- and make informed decisions about airline partnerships.
CREATE OR REPLACE VIEW CodeShareRevenue AS
	SELECT 
	    cs.CodeShareID,
	    cs.MarketingAirline,
	    f.FlightNumber,
	    f.DepartureDate AS FlightDate,
	    fi.FlightCode,
	    fi.Origin,
	    fi.Destination,
	    COUNT(t.TicketID) AS TicketsSold,
	    SUM(t.Price) AS TotalRevenue
	FROM 
	    CodeShare cs
	    JOIN Flight f ON cs.FlightNumber = f.FlightNumber
	    JOIN FlightInfo fi ON f.FlightCode = fi.FlightCode
	    JOIN Ticket t ON f.FlightID = t.FlightID
	GROUP BY 
	    cs.CodeShareID, cs.MarketingAirline, f.FlightNumber, f.DepartureDate, fi.FlightCode, fi.Origin, fi.Destination;


-- View 2: Flight Information and Capacity
-- Enable flight management teams to monitor and manage flight capacities and booking statuses.
CREATE OR REPLACE VIEW FlightCapacityInfo AS
	SELECT 
	    f.FlightNumber,
	    f.DepartureDate,
	    fi.capacity,
	    t.status,
	    t.bookingID,
	    t.price
	FROM 
	    flight f
	JOIN 
	    flightInfo fi ON f.FlightCode = fi.FlightCode
	JOIN 
	    ticket t ON f.FlightID = t.FlightID
	WHERE Status IS NOT null and BookingID IS NOT null;