--Prevent two customers from having the same seat on a flight
ALTER TABlE Ticket
ADD CONSTRAINT unique_seat UNIQUE (FlightID,SeatNumber);

--Identification is valid such that the expiration date is after the issue date
ALTER TABLE Identification
ADD CONSTRAINT expire_later CHECK (ExpirationDate > IssueDate);

--Identification is valid such that the birthdate is in the past
ALTER TABLE Identification
ADD CONSTRAINT birth_date_in_past CHECK (BirthDate < CURRENT_DATE);

--Signup Date for for Rewards Customer is not in the future
ALTER TABLE RewardsCustomer
ADD CONSTRAINT sign_up_in_past CHECK (SignUpDate<=CURRENT_DATE);

--The seat number is of a valid format
ALTER TABLE Ticket
ADD CONSTRAINT check_seat_format CHECK (SeatNumber ~ '^[0-9]+[A-Z]');


