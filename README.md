# AirlineCustomerDB

## Ariel Blumstein & Binyamin Klein

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

-[AirlineCustomerCreateTable.sql](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/AirlineCustomerCreateTable.sql)- this file contains the script that creates the relations in necessary for the database and should be run first.

-[AirlineCustomerDropTabe.sql](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/AirlineCustomerCreateTable.sql) - this file contains the script to drop the relations in the proper order, should not be run unless you want to delete the database.

-[my_own_sql_data_generator.py](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/my_own_sql_data_generator.py) - this will create csv files with random generated data, the files will be called 
“relation_name”.csv. To run this python script, make sure to install pandas, faker, and tqdm. You should copy the files into the database in this order: Customers.csv, Flight_Info.csv, Flights.csv, Tickets.csv,  Pet_Customers.csv, Indetification.csv, Rewards_Customers.csv, Reviews.csv. This order will prevent the import from failing based on foreign key constraints. NOTE: These files contain headers. A sample set of the copy commands to run in the psql command line is included in the file [import_data.txt](https://github.com/AriBlumstein/AirlineCustomerDB/blob/main/import_data.txt). Be sure to update the path to where the csv file is stored.

## Dump Command:
We were successfully able to dump the data and restore it on another computer, using commandline. Here is the command: 
### pg_dump --file "path_to_file.sql" --host "localhost" --port "5432" --username "postgres" --format=c --large-objects --verbose "AirlineCustomer"

After the command, enter your password for your postgres user.

### Output:
pg_dump: last built-in OID is 16383\
pg_dump: reading extensions\
pg_dump: identifying extension members\
pg_dump: reading schemas\
pg_dump: reading user-defined tables\
pg_dump: reading user-defined functions\
pg_dump: reading user-defined types\
pg_dump: reading procedural languages\
pg_dump: reading user-defined aggregate functions\
pg_dump: reading user-defined operators\
pg_dump: reading user-defined access methods\
pg_dump: reading user-defined operator classes\
pg_dump: reading user-defined operator families\
pg_dump: reading user-defined text search parsers\
pg_dump: reading user-defined text search templates\
pg_dump: reading user-defined text search dictionaries\
pg_dump: reading user-defined text search configurations\
pg_dump: reading user-defined foreign-data wrappers\
pg_dump: reading user-defined foreign servers\
pg_dump: reading default privileges\
pg_dump: reading user-defined collations\
pg_dump: reading user-defined conversions\
pg_dump: reading type casts\
pg_dump: reading transforms\
pg_dump: reading table inheritance information\
pg_dump: reading event triggers\
pg_dump: finding extension tables\
pg_dump: finding inheritance relationships\
pg_dump: reading column info for interesting tables\
pg_dump: finding table default expressions\
pg_dump: finding table check constraints\
pg_dump: flagging inherited columns in subtables\
pg_dump: reading partitioning data\
pg_dump: reading indexes\
pg_dump: flagging indexes in partitioned tables\
pg_dump: reading extended statistics\
pg_dump: reading constraints\
pg_dump: reading triggers\
pg_dump: reading rewrite rules\
pg_dump: reading policies\
pg_dump: reading row-level security policies\
pg_dump: reading publications\
pg_dump: reading publication membership of tables\
pg_dump: reading publication membership of schemas\
pg_dump: reading subscriptions\
pg_dump: reading large objects\
pg_dump: reading dependency data\
pg_dump: saving encoding = UTF8\
pg_dump: saving standard_conforming_strings = on\
pg_dump: saving search_path =\
pg_dump: saving database definition\
pg_dump: dumping contents of table "public.customer"\
pg_dump: dumping contents of table "public.flight"\
pg_dump: dumping contents of table "public.flightinfo"\
pg_dump: dumping contents of table "public.identification"\
pg_dump: dumping contents of table "public.petcustomer"\
pg_dump: dumping contents of table "public.review"

## Restore Command:
We ran into an issue when restoring, due to foreigh key constraints not necessarily being met when the running commands in different orders, so we enabled the  "disable triggers" option which solved this issue.
### pg_restore --host "localhost" --port "5432" --username "postgres" --dbname "AirlineCustomer" --clean --if-exists --disable-triggers --verbose "path_to_file.sql"

After the command, enter your password for your postgres user.

### output
pg_restore: dropping FK CONSTRAINT ticket ticket_flightid_fkey\
pg_restore: dropping FK CONSTRAINT ticket ticket_customerid_fkey\
pg_restore: dropping FK CONSTRAINT rewardscustomer rewardscustomer_customerid_fkey\
pg_restore: dropping FK CONSTRAINT review review_ticketid_fkey\
pg_restore: dropping FK CONSTRAINT petcustomer petcustomer_customerid_fkey\
pg_restore: dropping FK CONSTRAINT identification identification_customerid_fkey\
pg_restore: dropping FK CONSTRAINT flight flight_flightcode_fkey\
pg_restore: dropping CONSTRAINT ticket ticket_pkey\
pg_restore: dropping CONSTRAINT rewardscustomer rewardscustomer_pkey\
pg_restore: dropping CONSTRAINT rewardscustomer rewardscustomer_memberid_key\
pg_restore: dropping CONSTRAINT review review_ticketid_key\
pg_restore: dropping CONSTRAINT review review_pkey\
pg_restore: dropping CONSTRAINT petcustomer petcustomer_pkey\
pg_restore: dropping CONSTRAINT identification identification_pkey\
pg_restore: dropping CONSTRAINT flightinfo flightinfo_pkey\
pg_restore: dropping CONSTRAINT flight flight_pkey\
pg_restore: dropping CONSTRAINT customer customer_pkey\
pg_restore: dropping TABLE ticket\
pg_restore: dropping TABLE rewardscustomer\
pg_restore: dropping TABLE review\
pg_restore: dropping TABLE petcustomer\
pg_restore: dropping TABLE identification\
pg_restore: dropping TABLE flightinfo\
pg_restore: dropping TABLE flight\
pg_restore: dropping TABLE customer\
pg_restore: dropping TYPE ticketclass\
pg_restore: dropping TYPE status\
pg_restore: dropping TYPE species\
pg_restore: dropping TYPE idtype\
pg_restore: dropping TYPE dietaryrestriction\
pg_restore: dropping TYPE assistance\
pg_restore: creating TYPE "public.assistance"\
pg_restore: creating TYPE "public.dietaryrestriction"\
pg_restore: creating TYPE "public.idtype"\
pg_restore: creating TYPE "public.species"\
pg_restore: creating TYPE "public.status"\
pg_restore: creating TYPE "public.ticketclass"\
pg_restore: creating TABLE "public.customer"\
pg_restore: creating TABLE "public.flight"\
pg_restore: creating TABLE "public.flightinfo"\
pg_restore: creating TABLE "public.identification"\
pg_restore: creating TABLE "public.petcustomer"\
pg_restore: creating TABLE "public.review"\
pg_restore: creating TABLE "public.rewardscustomer"\
pg_restore: creating TABLE "public.ticket"\
pg_restore: processing data for table "public.customer"\
pg_restore: processing data for table "public.flight"\
pg_restore: processing data for table "public.flightinfo"\
pg_restore: processing data for table "public.identification"\
pg_restore: processing data for table "public.petcustomer"\
pg_restore: processing data for table "public.review"\
pg_restore: processing data for table "public.rewardscustomer"\
pg_restore: processing data for table "public.ticket"\
pg_restore: creating CONSTRAINT "public.customer customer_pkey"\
pg_restore: creating CONSTRAINT "public.flight flight_pkey"\
pg_restore: creating CONSTRAINT "public.flightinfo flightinfo_pkey"\
pg_restore: creating CONSTRAINT "public.identification identification_pkey"\
pg_restore: creating CONSTRAINT "public.petcustomer petcustomer_pkey"\
pg_restore: creating CONSTRAINT "public.review review_pkey"\
pg_restore: creating CONSTRAINT "public.review review_ticketid_key"\
pg_restore: creating CONSTRAINT "public.rewardscustomer rewardscustomer_memberid_key"\
pg_restore: creating CONSTRAINT "public.rewardscustomer rewardscustomer_pkey"\
pg_restore: creating CONSTRAINT "public.ticket ticket_pkey"\
pg_restore: creating FK CONSTRAINT "public.flight flight_flightcode_fkey"\
pg_restore: creating FK CONSTRAINT "public.identification identification_customerid_fkey"\
pg_restore: creating FK CONSTRAINT "public.petcustomer petcustomer_customerid_fkey"\
pg_restore: creating FK CONSTRAINT "public.review review_ticketid_fkey"\
pg_restore: creating FK CONSTRAINT "public.rewardscustomer rewardscustomer_customerid_fkey"\
pg_restore: creating FK CONSTRAINT "public.ticket ticket_customerid_fkey"\
pg_restore: creating FK CONSTRAINT "public.ticket ticket_flightid_fkey"\
pg_restore: creating ACL "SCHEMA public"

