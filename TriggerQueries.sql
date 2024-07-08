-- Insert a new ticket (this will trigger both the miles update and the journal entry):
INSERT INTO Ticket (TicketID, CustomerID, FlightID, TicketClass, SeatNumber, Zone, DietaryRestriction, LuggageNumber, OversizedLuggage, Assistance)
VALUES (1001, 2, 200005, 'Business', '10B', 'A', 'None', 2, 1, 'None');

-- Update an existing ticket (this will trigger the journal entry):
UPDATE Ticket
SET TicketClass = 'FirstClass', SeatNumber = '16B'
WHERE TicketID = 1001;

-- Delete a ticket (this will trigger the journal entry)
DELETE FROM Ticket WHERE TicketID = 1001;