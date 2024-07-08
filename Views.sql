-- View 1: Customer Details and Their Tickets (for Customer Service Representatives)
CREATE OR REPLACE VIEW CustomerTickets AS
SELECT C.CustomerID, C.Name, T.TicketID, F.DepartureDate
FROM Customer C
JOIN Ticket T ON C.CustomerID = T.CustomerID
JOIN Flight F ON T.FlightID = F.FlightID;

-- View 2: Flight Details and the Number of Tickets (for Flight Managers)
CREATE OR REPLACE VIEW FlightTicketCounts AS
SELECT F.FlightID, F.DepartureDate, FI.Destination, COUNT(T.TicketID) AS NumTickets
FROM Flight F
JOIN FlightInfo FI ON F.FlightCode = FI.FlightCode
LEFT JOIN Ticket T ON F.FlightID = T.FlightID
GROUP BY F.FlightID, F.DepartureDate, FI.Destination;

-- View 3: Flights with the Number of Customers from our Hub, ZMB (for Hub Flight Analysts)
CREATE OR REPLACE VIEW HubFlightCustomers AS
SELECT F.FlightID, F.DepartureDate, FI.Destination, COUNT(T.CustomerID) AS NumCustomers
FROM Flight F
JOIN FlightInfo FI ON F.FlightCode = FI.FlightCode
JOIN Ticket T ON F.FlightID = T.FlightID
WHERE FI.Origin = 'ZMB'
GROUP BY F.FlightID, F.DepartureDate, FI.Origin, FI.Destination;

-- View 4: Detailed Flight Schedules (for Flight Schedulers)
CREATE OR REPLACE VIEW FlightSchedules AS
SELECT F.FlightID, F.DepartureDate, FI.Origin, FI.Destination, F.FlightCode
FROM Flight F
JOIN FlightInfo FI ON F.FlightCode = FI.FlightCode;