# AirlineCustomerDB

## Ariel Blumstein & Binyamin Klein

## Project Proposal

The goal of our database is to support the operations related to airlines and customers.

The general operations that are supported for customers are:

- Customer Relations
- Rewards System
- Special Needs
- Pet Customers
- Review System
- Outfacing Informational Screens

In any system handling customers, we must have a ‘Customer’ entity. In our system, we expect that we will have customers that are not part of our rewards system so they will be stored in the Customer table. However, to support a rewards system we have a RewardsCustomer, which has a IS-A relationship to customer and contains the additional information of ‘MemberID’, which will be unique to the customer, miles flown and status. To support pet customers, we have the entity PetCustomer which has an IS-A relationship with Customer, and has the extra attribute ‘species’.
In a system supporting airline customers, we seek to store identification for them, hence this led to the entity ‘Identification’, which has a many-to-one relationship with ‘Customer’ (An Identification must be in the relationship a single customer, and one customer only, yet a customer can have multiple forms of identification).
When handling Customers, we seek to allow them to purchase tickets for flights which led to the creation of a ‘Ticket’ entity and a ‘Flight’ entity. Ticket has a many-to-one relationship with both Customer and Flight, as a Ticket must have one customer and flight, yet a customer can have multiple tickets, and a flight also has multiple tickets.

In reviewing our entity for Flight, we found that though we were in Second-Normal-Form, as all attributes has a value, and the key was made up of a single attribute, we were not in Third-Normal-Form as the flights ID formed a functional dependency with the ‘FlightCode’, and flight code formed a functional dependency with ‘Destination’, ‘Origin’ and ‘DepartureTime’.      (FlightID->FlightCode and FlightCode->Destination,Origin,DepatureTime). This was a transitive dependency. So, in order to comply with Third-Normal-Form, we created a new entity called FlightInfo that stores the flight code, destination, origin and departure time attribute, and Flight will remain with just flight code and date. Flight forms a One-To-Many relationship with FlightInfo (A flight must be associated with one FlightInfo entity, however a FlightInfo entity can be associated with many flights). This change is reflected in the ERD diagram.

To handle the review operations, we created an entity known as Review, which has a one-to-one relationship with a ticket, as we only want one review per ticket, and a ticket can have max one review.
All of these entities together can support the outfacing information if a customer would want to request such.

Enums were created when we created the tables to support different value type that expect certain values. 

A feature of our system also allows any value for the country field, to allow any country they may come into existance in the future.

![ERDimage](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/ERD.png?raw=true)

![DSDimage](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/DSDimage.png?raw=true)


## Repository Files

This repository includes the following files to run to set up the database

-[AirlineCustomerCreateTable.sql](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/AirlineCustomerCreateTable.sql)- this file contains the script that creates the relations in necessary for the database and should be run first.

-[AirlineCustomerDropTabe.sql](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/AirlineCustomerDropTable.sql) - this file contains the script to drop the relations in the proper order, should not be run unless you want to delete the database.

-[my_own_sql_data_generator.py](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/my_own_sql_data_generator.py) - this will create csv files with random generated data, the files will be called 
“relation_name”.csv. To run this python script, make sure to install pandas, faker, and tqdm. You should copy the files into the database in this order: Customers.csv, Flight_Info.csv, Flights.csv, Tickets.csv,  Pet_Customers.csv, Indetification.csv, Rewards_Customers.csv, Reviews.csv. This order will prevent the import from failing based on foreign key constraints. NOTE: These files contain headers. A sample set of the copy commands to run in the psql command line is included in the file [import_data.txt](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/import_data.txt). Be sure to update the path to where the csv file is stored.

## Dump Command:

We were successfully able to dump the data and restore it on another computer, using commandline. Here is the command: 

```sh
pg_dump --file "backupSQL.sql" --host "localhost" --port "5432" 
--username "postgres" --format=c --large-objects 
--verbose "AirlineCustomer"
```

After the command, enter your password for your postgres user.

## Restore Command:

We ran into an issue when restoring, due to foreigh key constraints not necessarily being met when the running commands in different orders, so we enabled the  "disable triggers" option which solved this issue.

```sh
pg_restore --host "localhost" --port "5432" --username "postgres"
--dbname "AirlineCustomer" --clean --if-exists --disable-triggers 
--verbose "backupSQL.sql"
```

After the command, enter your password for your postgres user.

### Output Log for Dump and Restore

[backupPSQL.log](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/backupPSQL.log)

## Dump Command with Drop, Create and Insert:

We were successfully able to dump the data and restore it on another computer, using commandline. Here is the command:

```sh
pg_dump --file "backupSQLinserts.sql" --host "localhost" --port "5432" 
--username "postgres" --format=c --large-objects --inserts 
--rows-per-insert "1000" --create --clean --if-exists 
--verbose "AirlineCustomer"
```

After the command, enter your password for your postgres user.

## Restore Command:

We ran into an issue when restoring, due to foreigh key constraints not necessarily being met when the running commands in different orders, so we enabled the  "disable triggers" option which solved this issue.

```sh
pg_restore --host "localhost" --port "5432" --username "postgres" 
--dbname "AirlineCustomer" --clean --if-exists --disable-triggers
--verbose "backupSQLinserts.sql
```

### Output Log for Dump and Restore

[backupPSQLinserts.log](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/backupPSQLinserts.log)


## Queries
### Regular Queries in Plain English
SELECT Queries:

1. (Query number 1) Retrieve a list of all flights including their departure and arrival locations, and scheduled times.
2. (Query number 2) Find the total number of bookings made by each customer, including the customer's name.
3. (Query number 3) Get the average rating from each rewards customers
4. (Query number 4) List all customers who have traveled more than five times, including their total number of flights and the most frequent destination.

### Additional Queries added in stage 3
5. (Query number 9) Retrieve Customer Details along with their flight information
6. (Query number 10) Retrieve flights with the number of customers booked from JPN
7. (Query number 11) Retrieve flights and the number of bookings for each flight

UPDATE Queries:

1. (Query number 5) Reschedule all flights with the flight code GW8225 to 11:15:00.
2. (Query number 6) Reschedule all flights that were scheduled to depart on July 22nd, 2024 to the next day.

DELETE Queries:

1. (Query number 7) Delete all flights that were completed before July 1st, 2024.
2. (Query number 8) Delete customer records who have not flown in the past month and has no future flights.

As we do not have "On Delete Cascade" on any of our foreign key constraints, we needed to handle deleting from other relations before preforming our main deletes. This is a feature to maintain transparency. All such grouped queries are within a begin-commit block so they will run in an all-or-none fashion to better maintain data integrity. 

### The above queries are written in SQL here: [Queries](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/Queries.sql)
### The analysis for these queries is here: [QueryTiming](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/QueryTiming.log)

### Parameterized Queries:
1. Get the total number of flights to a specific destination within a specifc time range.
2. Get The rewards customers on a specific flight with a minimum status.
3. Update the seat of a specific customer on a specific flight.
4. Remove all bookings associated with a specific flight that has been canceled.

### The above queries are written in SQL here: [ParamsQueries](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/ParamsQueries.sql)
### The analysis for these queries is here: [ParamQueryTiming](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/ParamQueryTiming.log)


## [Indexes](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/indexes.sql)

### We created index to speed up query processing. We created the following indexes:
### Ticket Table

- FlightID
- CustomerID
- CustomerID, FlightID

### Flight Table

- FlightCode
- DepartureDate

### Review Table

- TicketID

### Identification Table

- CustomerID

### Index Naming Convention
idx\_*TableName*\_*Attribute*

### The logs for analysis and timing of regular queries are [here](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/QueryTimingIndexes.log) and for parameterized queries are [here](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/ParamQueryTimingIndexes.log)

### Runtime Log Summaries

#### Regular Queries
| Query Number | Runtime Without Indexing (ms) | Runtime With Indexing (ms) | Indexes used                                     |
|--------------|-------------------------------|----------------------------|--------------------------------------------------|
| 1            | 6.455                         | 5.277                      |                                                  |
| 2            | 111.229                       | 103.584                    |                                                  |
| 3            | 11.391                        | 1.61                       | idx\_review\_ticket\_id                          |
| 4            | 412.055                       | 319.23                     | idx\_ticket\_customerid\_flight\_id              |
| 5            | 0.602                         | 0.121                      |                                                  |
| 6            | 0.846                         | 0.686                      | idx\_flight\_departuredate                       |
| 7            | 1588.249                      | 141.302                    | idx\_review\_ticket\_id, idx\_flight\_departuredate(2)|
| 8            | 7377.054                      | 261.332                    | idx\_ticket\_customerid, idx\_identification\_customer |
| 9            | N/A                           | 139.802                    |                                                  |
| 10           | N/A                           | 6.581                      | idx\_flight\_flightcode, idx\_ticket\_flightid   |
| 11           | N/A                           | 85.197                     |                                                  |



#### Parameterized Queries
| Query Number | Runtime Without Indexing (ms) | Runtime With Indexing (ms) | Index Used            |
|--------------|-------------------------------|----------------------------|-----------------------|
| 1            | 0.735                         | 0.104                      | idx\_flight\_flightcode |
| 2            | 28.801                        | 7.086                      | idx\_ticket\_flightid   |
| 3            | 0.739                         | 2.601                      |                       |
| 4            | 27.853                        | 5.836                      | id\_ticket\_flightid    |

## Constraints

### We added the following constraints to make our database more robust:

1. Prevent two customers from having the same seat on a flight
2. Identification is valid such that the expiration date is after the issue date
3. Identification is valid such that the birthdate is in the past
4. Signup Date for for Rewards Customer is not in the future
5. The seat number is of a valid format

#### The commands for altering the tables to add these constraints is in [Constraints](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/Constraints.sql)

### The following are [test queries](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/ConstraintBreakers.sql) to try to break the constraints to make sure they're working:

1. Break the unique seat constraint that no two customers can have the same seat on a flight
2. Beak the the identification constraint: issue date is after expiration date
3. Beak the the identification constraint: Birthdate is not in the past
4. Break the rewards customer constraint that the signup date cannot be in the future
5. Break the seat number constraint that it matches a standard pattern

### The error messages produced by each of these queries is [here](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/ConstraintBreakers.log).

## Views

We created views for different user subgroups:

#### User Sub-Groups:

1.	**Customer Service Representatives**: Need details on customers and their bookings to assist with customer inquiries. View Name: CustomerTickets.
2.	**Flight Managers**: Need to know the number of bookings for each flight to manage capacity and resources. View Name: FlightTicketCounts.
3.	**Hub Flight Analysts**: Need to analyze the number of customers flying from ZMB, because this is a major hub for our airline. View Name: HubFlightCustomers
4.	**Flight Schedulers**: Need detailed schedules for all flights. View Name: FlightSchedules

#### We created the views [here](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/Views.sql).

To test these views we implemented various SELECT, UPDATE, and DELETE queries on each view. The queries are **[here](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/ViewQueries.sql).**

For views 1 and 4 we were not sure if UPDATE or DELETE queries would fail, so we tried them, and they ended up failing due to the fact that they were based on multiple tables. 
For views 2 and 3, we knew the UPDATE and DELETE queries would not work because they contained aggregates, so we did not even try those.

The logs and explanations of what the queries were trying to accomplish are **[here](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/viewQueryLogs.log).**

## Visualizations

### Visualization for View 2: FlightTicketCounts

This query shows the total number of tickets sold for each destination for upcoming flights. It's useful for understanding popular destinations and allocating resources.

``` SQL
SELECT Destination, SUM(NumTickets) AS TotalTickets
FROM FlightTicketCounts
WHERE DepartureDate >= CURRENT_DATE
GROUP BY Destination
ORDER BY TotalTickets DESC;
```

![View2BarChart](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/View2BarChart.png?raw=true)

### Visualization for View 3: HubFlightCustomers

This query shows the number of customers flying from our hub, ZMB, to various destinations for upcoming flights. It's helpful for analyzing the market and planning routes from our hub.

``` SQL
SELECT Destination, SUM(NumCustomers) AS TotalCustomers
FROM HubFlightCustomers
WHERE DepartureDate >= CURRENT_DATE
GROUP BY Destination
ORDER BY TotalCustomers DESC;
```

![View3PieChart](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/View3PieChart.png?raw=true)


## Functions

To make our queries more readable, we created functions that decreased their complexity.

The various functions created accomplish the following:

1. Function 1: FlyingCustomers(interval) Return all customers that have flown within a specific time range (from now minus the pass parameter to now) and have no future flights. (Used in Query 8)
2. Function 2: RewardsTickets() - Return all of the tickets purchased by rewards customers (Used in Query 3)
3. Function 3: TicketDetails() - Return the ticket details for each customer, finding how many times they flew to each destination, and ranking each destination by how many times they flew there. (Used in Query 4)
4. Function 4: CustomerFlights(integer) Return the customer details of customers that have flown more than a specific amount of flights (Used in Query 4)

The creation of the functions can be viewed **[here](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/Functions.sql).**

#### Query timing analyzation for queries that used functions
| Query Number | Runtime Without Functions (ms) | Runtime With Functions (ms)| Functions Used         |
|--------------|-------------------------------|----------------------------|-----------------------|
| 3            | 1.61                          | 47.59                      | RewardsTickets()      |
| 4            | 319.23                        | 389.99                     | CustomerFlights(integer), TicketDetails() |
| 8            | 261.332                       | 357.995                    | FlyingCustomers(interval) (3)                      |

We also observed that the new constraints that we added to these tables caused a longer execution time.

Full timing logs for these 3 queries can be found **[here](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/FunctionTiming.log).**

## Triggers

We implemented two triggers to enhance the functionality of the airline database: The Triggers are created in **[this](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/Triggers.sql)** file.

### 1. Update Miles Flown Trigger

This trigger automatically updates the MilesFlown and Status for a RewardsCustomer when a new ticket is purchased.

- **Trigger Name**: `update_miles_flown_trigger`
- **Activated**: After INSERT on the Ticket table
- **Function**: `update_miles_flown()`

The trigger performs the following actions:

- Adds the flight distance to the customer's MilesFlown (currently uses a placeholder of 1000 miles per flight)
- Updates the customer's Status based on their new MilesFlown:
  - Gold: 100,000 miles or more
  - Silver: 50,000 to 99,999 miles
  - None: Less than 50,000 miles

### 2. Ticket Change Journal Trigger

This trigger maintains a journal of all changes made to tickets, including inserts, updates, and deletes.

- **Trigger Name**: `journal_ticket_changes_trigger`
- **Activated**: After INSERT, UPDATE, or DELETE on the Ticket table
- **Function**: `journal_ticket_changes()`

The trigger logs the following information in the TicketChangeJournal table:

- TicketID
- Type of change (INSERT, UPDATE, or DELETE)
- Timestamp of the change
- Old and new values for TicketClass and SeatNumber (for updates)

### Example Outputs

After running the queries in [TriggerQueries.sql](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/TriggerQueries.sql), here are the results:

1. After inserting a new ticket:

RewardsCustomer table: 

| MemberID   | Status | SignUpDate  | MilesFlown | CustomerID |
|------------|--------|-------------|------------|------------|    Previously, Customer2 had 7264 miles.
| 43570443   | None   | 2021-11-23  | 8264       |  2         |

Ticket table:

| TicketID | TicketClass | SeatNumber | DietaryRestriction | LuggageNumber | OversizedLuggage | CustomerID | FlightID | Zone | Assistance |
|----------|-------------|------------|---------------------|---------------|------------------|------------|----------|------|------------|
| 1001     | Business    | 10B        | None                | 2             | 1                | 2          | 200005   | A    | None       |

2. After updating the ticket:

Ticket table:

| TicketID | TicketClass | SeatNumber | DietaryRestriction | LuggageNumber | OversizedLuggage | CustomerID | FlightID | Zone | Assistance |
|----------|-------------|------------|---------------------|---------------|------------------|------------|----------|------|------------|
| 1001     | FirstClass  | 16B        | None                | 2             | 1                | 2          | 200005   | A    | None       |

3. After deleting the ticket, the TicketChangeJournal shows:

| JournalID | TicketID | ChangeType | ChangeTimestamp           | OldTicketClass | NewTicketClass | OldSeatNumber | NewSeatNumber |
|-----------|----------|------------|---------------------------|----------------|----------------|----------------|---------------|
| 1         | 1001     | INSERT     | 2024-07-08 22:35:01.60726 | NULL           | Business       | NULL           | 10B           |
| 2         | 1001     | UPDATE     | 2024-07-08 22:36:47.04075 | Business       | FirstClass     | 10B            | 16B           |
| 3         | 1001     | DELETE     | 2024-07-08 22:37:25.781621| FirstClass     | NULL           | 16B            | NULL          |

These results demonstrate the effectiveness of our triggers:

1. The INSERT operation added a new ticket to the Ticket table, and added 1000 miles to the rewards customer with ID 2.

2. The UPDATE operation successfully changed the TicketClass from 'Business' to 'FirstClass' and the SeatNumber from '10B' to '16B'.

3. The DELETE operation removed the ticket from the Ticket table.

4. The TicketChangeJournal recorded all three operations (INSERT, UPDATE, and DELETE) with their respective details and timestamps.

Note: The Update Miles Flown trigger currently uses a placeholder value of 1000 miles for all flights. In a real-world scenario, we would calculate the actual distance based on the flight's origin and destination.

