CREATE TABLE CodeToLocation
(
	CityCode varchar(3),
	City varchar
);

CREATE TABLE CustomerToPassenger
(
	CustomerID INTEGER,
	PassengerID INTEGER
)

CREATE TABLE Local_Booking (
    BookingID SERIAL PRIMARY KEY,
    BookingDate DATE,
    Status booking_status,
    Cost FLOAT,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE Local_CodeShare (
    CodeShareID SERIAL PRIMARY KEY,
    FlightNumber INT,
    MarketingAirline VARCHAR NOT NULL,
    Restrictions VARCHAR NOT NULL
);

CREATE TABLE Local_Package (
    PackageID SERIAL PRIMARY KEY,
    PackageName VARCHAR NOT NULL,
    Price FLOAT NOT NULL,
    StartDate DATE NOT NULL,
    CarModel VARCHAR NOT NULL,
    ReturnDate DATE NOT NULL
);

CREATE TABLE Local_Passenger (
    PassengerID SERIAL PRIMARY KEY,
    Name VARCHAR NOT NULL,
    ContactInfo VARCHAR NOT NULL
);