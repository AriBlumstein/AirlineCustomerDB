
CREATE TYPE species AS ENUM ('Dog', 'Cat', 'Other');
CREATE TYPE status AS ENUM ('None', 'Silver', 'Gold');
CREATE TYPE ticketClass AS ENUM ('Economy', 'Premium', 'Business', 'FirstClass');
CREATE TYPE IDType AS ENUM ('IDCard', 'DriversLicence', 'Passport');
CREATE TYPE dietaryRestriction AS ENUM ('Kosher', 'Vegan', 'GlutenFree', 'DairyFree', 'Diabetes', 'NutFree');
							

	
CREATE TABLE Customer
(
  CustomerID INT NOT NULL,
  Name VARCHAR(25) NOT NULL,
  PRIMARY KEY (CustomerID),
  CHECK (CustomerID>=1)
);

CREATE TABLE Identification
(
  Category IDtype  NOT NULL,
  IdentificationID INT NOT NULL,
  BirthDate DATE NOT NULL,
  IssueDate DATE NOT NULL,
  ExpirationDate DATE NOT NULL,
  IDnumber INT NOT NULL,
  Country VARCHAR(25) NOT NULL,
  CustomerID INT NOT NULL,
  PRIMARY KEY (IdentificationID),
  FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
  CHECK (IDnumber>=1)
);

CREATE TABLE RewardsCustomer
(
  MemberID INT NOT NULL,
  Status status  NOT NULL,
  SignUpDate DATE NOT NULL,
  MilesFlown INT NOT NULL,
  CustomerID INT NOT NULL,
  PRIMARY KEY (CustomerID),
  FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
  UNIQUE (MemberID),
  CHECK (MemberID>=1),
  CHECK (MilesFlown>=1)	
);

CREATE TABLE PetCustomer
(
  Species species  NOT NULL,
  CustomerID INT NOT NULL,
  PRIMARY KEY (CustomerID),
  FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE FlightInfo
(
  FlightCode VARCHAR(6) NOT NULL,
  Destination VARCHAR(3) NOT NULL,
  Origin VARCHAR(3) NOT NULL,
  DepatureTime DATE NOT NULL,
  PRIMARY KEY (FlightCode)
);

CREATE TABLE Flight
(
  DepartureDate DATE NOT NULL,
  FlightID INT NOT NULL,
  FlightCode VARCHAR(6) NOT NULL,
  PRIMARY KEY (FlightID),
  FOREIGN KEY (FlightCode) REFERENCES FlightInfo(FlightCode),
  CHECK(FlightID>=1)
);

CREATE TABLE Ticket
(
  TicketID INT NOT NULL,
  TicketClass ticketClass NOT NULL,
  SeatNumber VARCHAR(3) NOT NULL,
  DietaryRetriction dietaryRestriction  NOT NULL,
  LuggageNumber INT NOT NULL,
  OversizedLuggage INT NOT NULL,
  CustomerID INT NOT NULL,
  FlightID INT NOT NULL,
  Zone Char(1) Not NULL,
  PRIMARY KEY (TicketID),
  FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
  FOREIGN KEY (FlightID) REFERENCES Flight(FlightID),
  CHECK(TicketID>=1),
  CHECK(LuggageNumber>=0),
  CHECK(OversizedLuggage>=0),
  CHECK(Zone='A' OR Zone='B' OR Zone='C' OR Zone='D')
);

CREATE TABLE Review
(
  ReviewID INT NOT NULL,
  Rating INT NOT NULL,
  Comments VARCHAR(200) NOT NULL,
  TicketID INT NOT NULL,
  PRIMARY KEY (ReviewID),
  FOREIGN KEY (TicketID) REFERENCES Ticket(TicketID),
  CHECK (RATING>=1 AND RATING<=5),
  CHECK(ReviewID>=1)
);
