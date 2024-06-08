-- Index Creation

CREATE INDEX idx_ticket_flightid ON Ticket(FlightID);

CREATE INDEX idx_ticket_customerid ON Ticket(CustomerID);

CREATE INDEX idx_ticket_customerid_flightid ON Ticket(CustomerID, FlightID);

CREATE INDEX idx_flight_flightcode on Flight(FlightCode);

CREATE INDEX idx_flight_departuredate on Flight(DepartureDate);

CREATE INDEX idx_review_ticketid on Review(TicketID);

CREATE INDEX idx_identification_customerid on Identification(CustomerID);