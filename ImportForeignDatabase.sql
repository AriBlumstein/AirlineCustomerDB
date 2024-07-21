IMPORT FOREIGN SCHEMA public 
LIMIT TO (booking, bookingpackage, codeshare, package, passenger, passengerbooking, seat)
FROM SERVER TicketingServer 
INTO public;

CREATE FOREIGN TABLE foreign_flight (
  FlightNumber SERIAL,
    DepartureLocation VARCHAR NOT NULL,
    ArrivalLocation VARCHAR NOT NULL,
    DepartureTime TIMESTAMP NOT NULL,
    ArrivalTime TIMESTAMP NOT NULL,
    Capacity INT NOT NULL
)
 SERVER foreign_server
 OPTIONS (schema_name 'public',
 table_name 'flight');



CREATE FOREIGN TABLE foreign_ticket (
 	TicketNumber SERIAL PRIMARY KEY,
    FlightNumber INT,
    SeatNumber VARCHAR(3),
    Price FLOAT,
    Status ticket_status,
    Class ticket_class,
    PassengerID INT
)
 SERVER foreign_server
 OPTIONS (schema_name 'public',
 table_name 'ticket');






