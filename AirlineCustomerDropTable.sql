-- Then drop the tables
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS Ticket;
DROP TABLE IF EXISTS Flight;
DROP TABLE IF EXISTS FlightInfo;
DROP TABLE IF EXISTS PetCustomer;
DROP TABLE IF EXISTS RewardsCustomer;
DROP TABLE IF EXISTS Identification;
DROP TABLE IF EXISTS Customer;

-- Finally, drop the custom enum types
DROP TYPE IF EXISTS dietaryRestriction;
DROP TYPE IF EXISTS IDType;
DROP TYPE IF EXISTS ticketClass;
DROP TYPE IF EXISTS status;
DROP TYPE IF EXISTS species;
DROP TYPE IF EXISTS assistance;