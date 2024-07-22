--drop the foreign tables when they are no longer needed
DROP FOREIGN TABLE booking;
DROP FOREIGN TABLE bookingpackage;
DROP FOREIGN TABLE codeshare;
DROP FOREIGN TABLE foreign_flight;
DROP FOREIGN TABLE foreign_ticket;
DROP FOREIGN TABLE package;
DROP FOREIGN TABLE passenger;
DROP FOREIGN TABLE passengerbooking;
DROP FOREIGN TABLE seat;

--rename the added tables
ALTER TABLE local_booking RENAME TO Booking;
ALTER TABLE local_codeshare RENAME TO Codeshare;
ALTER TABLE local_package RENAME TO Package;
ALTER TABLE local_passenger RENAME TO Passenger;





