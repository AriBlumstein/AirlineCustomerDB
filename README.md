# AirlineCustomerDB

## Project Proposal

The goal of our database is to support the operations related to airlines and customers.
The general operations that are supported for customers are:
-Customer Relations
-Rewards System
-Special Needs
-Pet Customers
-Review System
-Outfacing Informational Screens

In any system handling customers, we must have a ‘Customer’ entity. In our system, we expect that we will have customers that are not part of our rewards system so they will be stored in the Customer table. However, to support a rewards system we have a RewardsCustomer, which has a IS-A relationship to customer and contains the additional information of ‘MemberID’, which will be unique to the customer, miles flown and status. To support pet customers, we have the entity PetCustomer which has an IS-A relationship with Customer, and has the extra attribute ‘species’.
In a system supporting airline customers, we seek to store identification for them, hence this led to the entity ‘Identification’, which has a many-to-one relationship with ‘Customer’ (An Identification must be in the relationship a single customer, and one customer only, yet a customer can have multiple forms of identification).
When handling Customers, we seek to allow them to purchase tickets for flights which led to the creation of a ‘Ticket’ entity and a ‘Flight’ entity. Ticket has a many-to-one relationship with both Customer and Flight, as a Ticket must have one customer and flight, yet a customer can have multiple tickets, and a flight also has multiple tickets.

In reviewing our entity for Flight, we found that though we were in Second-Normal-Form, as all attributes has a value, and the key was made up of a single attribute, we were not in Third-Normal-Form as the flights ID formed a functional dependency with the ‘FlightCode’, and flight code formed a functional dependency with ‘Destination’, ‘Origin’ and ‘DepartureTime’.      (FlightID->FlightCode and FlightCode->Destination,Origin,DepatureTime). This was a transitive dependency. So, in order to comply with Third-Normal-Form, we created a new entity called FlightInfo that stores the flight code, destination, origin and departure time attribute, and Flight will remain with just flight code and date. Flight forms a One-To-Many relationship with FlightInfo (A flight must be associated with one FlightInfo entity, however a FlightInfo entity can be associated with many flights). This change is reflected in the ERD diagram.

To handle the review operations, we created an entity known as Review, which has a one-to-one relationship with a ticket, as we only want one review per ticket, and a ticket can have max one review.
All of these entities together can support the outfacing information if a customer would want to request such.

Enums were created when we created the tables to support different value type that expect certain values. 



![ERDimage](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/ERD.png?raw=true)

![DSDimage](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/DSDimage.png?raw=true)


## Repository Files
This repository includes the following files to run to set up the database
-AirlineCustomerCreateTable.sql- this file contains the script that creates the relations in necessary for the database and should be run first.

-[AirlineCustomerDropTabe.sql] - this file contains the script to drop the relations in the proper order, should not be run unless you want to delete the database.

-[my_own_sql_data_generator.py] - this will create csv files with random generated data, the files will be called 
“relation_name”.csv. To run this python script, make sure to install pandas,, faker, and tqdm. You should copy the files into the database in this order: Customers.csv, Flight_Info.csv, Flights.csv, Tickets.csv,  Pet_Customers.csv, Indetification.csv, Rewards_Customers.csv, Reviews.csv. This order will prevent the import from failing based on foreign key constraints. 

