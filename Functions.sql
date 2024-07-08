
-- Function 1: return all customers that have flown within a specific time range (from now-i to now) and have no future flights
CREATE OR REPLACE FUNCTION FlyingCustomers (i interval) 
	RETURNS TABLE 
	(
		CustomerID integer
	) 
	AS
	$$
	BEGIN
	    RETURN QUERY
  		SELECT DISTINCT t.CustomerID 
  		FROM Ticket t INNER JOIN Flight f ON (t.FlightID = f.FlightID)
  		WHERE (f.DepartureDate > current_date - i); --this point we find where the actual if there is a flight within the time range or after it
    END;
    $$
LANGUAGE plpgsql;

SELECT * from FlyingCustomers('1 day');

--Function 2: Return all of the tickets purchased by rewards customers
CREATE OR REPLACE FUNCTION RewardsTickets()
	RETURNS TABLE
	(
		TicketID integer,
		CustomerID integer
	)
	AS
	$$
	BEGIN
		RETURN QUERY
		SELECT t.TicketID, t.CustomerID 
		FROM Ticket t                      
		WHERE t.CustomerID in (Select rc.CustomerID
	                     		FROM RewardsCustomer rc);
	END;
	$$
LANGUAGE plpgsql;

SELECT * FROM RewardsTickets();


-- Function 3: Return the ticket details for each customer, finding how many times they flew to each destination, and ranking each destination by how many times they flew there (which is represented by rn)
CREATE OR REPLACE FUNCTION TicketDetails() 
	RETURNS TABLE
	(
		CustomerID integer,
		Destination varchar(3),
		Destination_Count bigint,
		rn bigint	
	)
	AS
	$$
	BEGIN
		RETURN QUERY
    	SELECT t.CustomerID, fi.Destination, COUNT(*) AS destination_count, ROW_NUMBER() OVER (PARTITION BY t.CustomerID ORDER BY COUNT(*) DESC) AS rn
	    -- we order the info about a customer by his most frequent destination (his top destination will be listed first)
    	FROM Ticket t
    	JOIN Flight f ON (t.FlightID = f.FlightID) 
		JOIN FlightInfo fi ON (f.FlightCode = fi.FlightCode) -- this gets us the info from the lookup table for flights
    	GROUP BY t.CustomerID, fi.Destination; --group by the customer and the destination
	END;
	$$
LANGUAGE plpgsql;

SELECT * FROM TicketDetails();

-- Function 4: Return the customer details of customers that have flown more than a specific amount of flights
CREATE OR REPLACE FUNCTION CustomerFlights(num_flights integer) 
	RETURNS TABLE
	(
		CustomerID integer,
		Name varchar(50),
		total_flights bigint
	)
	AS
	$$
	BEGIN
		RETURN QUERY
    	SELECT c.CustomerID, c.Name, COUNT(t.TicketID) AS total_flights --count the total number of flights
    	FROM Customer c
    	INNER JOIN Ticket t ON (c.CustomerID = t.CustomerID) -- match customers to their tickets
    	GROUP BY c.CustomerID, c.Name
    	HAVING COUNT(t.TicketID) > num_flights;
	END;
	$$
LANGUAGE plpgsql;

SELECT * FROM CustomerFlights(5);







	






		