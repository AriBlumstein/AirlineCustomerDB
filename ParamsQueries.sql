--Parameterized queries

--Get the total number of flights to a specific destination within a specifc time range.
PREPARE Flights_To_Destination (text, date, date) AS
(
    SELECT $1 AS Destination, $2 AS start_date, $3 AS end_date, 
           COALESCE(COUNT(f.FlightCode), 0) AS total_flights
    FROM (SELECT $1 AS Destination) AS d
    LEFT JOIN Flight f ON f.DepartureDate BETWEEN $2 AND $3
                       AND f.FlightCode IN (
                           SELECT FlightCode 
                           FROM FlightInfo 
                           WHERE Destination = $1
                       )
    GROUP BY d.Destination
);
EXECUTE Flights_To_Destination('EGY', '2023-07-30', '2024-07-31');


--Get The rewards customers on a specific flight with a minimum status.
PREPARE Customer_With_Status(int, status) AS (
	SELECT *
	FROM RewardsCustomer
	WHERE Status >= $2 
	AND CustomerID IN (SELECT CustomerID 
						FROM Ticket 
						WHERE FlightID=$1)
);



EXECUTE Customer_With_Status(200399, 'Silver');






