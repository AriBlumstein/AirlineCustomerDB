-- Break the unique seat constraint that no two customers can have the same seat on a flight
INSERT INTO Ticket VALUES
(3, 'Business', '10B', 'None', 0, 0, 22202, 200703, 'A', 'None');

--Beak the the identification constraints
--issue date is after expiration date
INSERT INTO Identification VALUES
('ID', 1, '1998-10-10', '2022-10-10', '2022-9-9', 876873, 'USA', 32051);

--Birthdate is not in the past
INSERT INTO Identification VALUES
('ID', 1, '2998-10-10', '2022-10-10', '2024-9-9', 876873, 'USA', 32051);


--Break the rewards customer constraint that the signup date cannot be in the future
INSERT INTO RewardsCustomer VALUES
(111111, 'None', '2025-10-10', 0, 32051);


--Break the seat number constraint that it matches a standard pattern
INSERT INTO Ticket VALUES
(3, 'Business', '1', 'None', 0, 0, 22202, 200703, 'A', 'None');






