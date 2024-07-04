-- View 1: CustomerTickets
-- SELECT query
SELECT * FROM CustomerTickets WHERE CustomerID = 1;

-- INSERT
INSERT INTO CustomerTickets (CustomerID, Name, TicketID, DepartureDate)
VALUES (50001, 'John Doe', 101, '2024-12-21');

-- UPDATE
UPDATE CustomerTickets
SET Name = 'Jane Doe'
WHERE CustomerID = 1;

-- DELETE
DELETE FROM CustomerTickets WHERE TicketID = 101;

-- View 2: FlightTicketCounts
-- SELECT query
SELECT * FROM FlightTicketCounts WHERE NumTickets > 130;


-- View 3: OriginFlightCustomers
-- SELECT query
SELECT * FROM JPNFlightCustomers WHERE NumCustomers > 50;


-- View 4: FlightSchedules
-- SELECT query
SELECT * FROM FlightSchedules WHERE Origin = 'JPN';

-- INSERT
INSERT INTO FlightSchedules (FlightID, DepartureDate, Origin, Destination, FlightCode)
VALUES (1, '2024-07-01', 'JPN', 'LON', 'JP1234');

-- UPDATE
UPDATE FlightSchedules
SET Destination = 'PAR'
WHERE FlightID = 1;

-- DELETE
DELETE FROM FlightSchedules WHERE FlightID = 1;