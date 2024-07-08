-- Function to update miles flown
CREATE OR REPLACE FUNCTION update_miles_flown()
RETURNS TRIGGER AS $$
DECLARE
    flight_distance INT;
    customer_id INT;
BEGIN
    -- Get the flight distance (this is a placeholder - you'd need to calculate this based on origin and destination)
    SELECT 1000 INTO flight_distance;  -- Placeholder: assume all flights are 1000 miles

    -- Get the customer ID
    SELECT CustomerID INTO customer_id FROM Ticket WHERE TicketID = NEW.TicketID;

    -- Update MilesFlown in RewardsCustomer table
    UPDATE RewardsCustomer
    SET MilesFlown = MilesFlown + flight_distance
    WHERE CustomerID = customer_id;

    -- Update Status based on new MilesFlown
    UPDATE RewardsCustomer
    SET Status = 
        CASE 
            WHEN MilesFlown >= 100000 THEN 'Gold'::status
            WHEN MilesFlown >= 50000 THEN 'Silver'::status
            ELSE 'None'::status
        END
    WHERE CustomerID = customer_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update miles flown after insert
DROP TRIGGER IF EXISTS update_miles_flown_trigger ON Ticket;

CREATE TRIGGER update_miles_flown_trigger
AFTER INSERT ON Ticket
FOR EACH ROW
EXECUTE FUNCTION update_miles_flown();

-- Create journal table
CREATE TABLE IF NOT EXISTS TicketChangeJournal (
    JournalID SERIAL PRIMARY KEY,
    TicketID INT NOT NULL,
    ChangeType VARCHAR(10) NOT NULL,
    ChangeTimestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    OldTicketClass ticketClass,
    NewTicketClass ticketClass,
    OldSeatNumber VARCHAR(3),
    NewSeatNumber VARCHAR(3)
);

-- Function to journal ticket changes
CREATE OR REPLACE FUNCTION journal_ticket_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO TicketChangeJournal (TicketID, ChangeType, NewTicketClass, NewSeatNumber)
        VALUES (NEW.TicketID, 'INSERT', NEW.TicketClass, NEW.SeatNumber);
    ELSIF TG_OP = 'UPDATE' THEN
        IF OLD.TicketClass != NEW.TicketClass OR OLD.SeatNumber != NEW.SeatNumber THEN
            INSERT INTO TicketChangeJournal (TicketID, ChangeType, OldTicketClass, NewTicketClass, OldSeatNumber, NewSeatNumber)
            VALUES (NEW.TicketID, 'UPDATE', OLD.TicketClass, NEW.TicketClass, OLD.SeatNumber, NEW.SeatNumber);
        END IF;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO TicketChangeJournal (TicketID, ChangeType, OldTicketClass, OldSeatNumber)
        VALUES (OLD.TicketID, 'DELETE', OLD.TicketClass, OLD.SeatNumber);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to journal ticket changes after insert, update, or delete
DROP TRIGGER IF EXISTS journal_ticket_changes_trigger ON Ticket;

CREATE TRIGGER journal_ticket_changes_trigger
AFTER INSERT OR UPDATE OR DELETE ON Ticket
FOR EACH ROW
EXECUTE FUNCTION journal_ticket_changes();