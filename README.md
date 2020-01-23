# FlexiFlightScanner
R script for checking air fares from/to several origins/destination on a custom range of dates, based on the Skyscanner API


## - Main goal:
Searching for flights on Skyscanner it's an easy task if certain about origin, destination and travel dates. But if you are flexible about dates or you would be open to travel to a different destination if the cost is cheaper, making a different search for every single combination can be a pain in the ass.

This R scripts allows you to query the Skyscanner API for several destinations and a custom range of dates and presents the results on the form of a .csv file ready to be used on any visualisation tools or imported to Excel or Google Docs.


## - Potential users:

The idea behind the script is presenting at once the cheapest possible fare for a certain segment on a certain date, saving us a lot of single searches. Could be specially useful in certain cases:

- The traveller is looking for a short vacation and has some destinations in mind, but would like to check which destination is the cheapest to fly to.
 
- We are certain about our origin and destination, but we are very flexible about dates and would like to check the rates for a certain period in order to decide when to fly.
 
- Our origin or destination could be server by different airports and we would like to check which one has the most convenient flights.

- We need to flight to a small destination served from few origins and not daily and would like to know when and where would be the best option for a connection.

- Can also be used as a basis for creating basic flight search engines for personal or commercial uses.


## - Example of needs solved by this script:
As our family often needs to fly to a small airport in Greece served occasionaly by low cost airlines from certain european destinations, we need to check which is the cheapest fare for all the origins at once so we can decide in which city we do want to connect and which dates are the best.


## - Requirements:
- R
- Packages: tidyverse, httr, jsonlite
- Skyscanner API key

## - How does it work?:
- Insert the Skyscanner API Key.
- Modify the vectors named origin or destination with the desired places (IATA codes).
- Modify the first_date and last_date variable in order to set the range of dates.
- By default, the API is queried for the Spanish Market, using es-ES local and EUR as currency. Change those parametres on base if required (Documentation: https://skyscanner.github.io/slate/#browse-quotes)
- A .csv file named with the data range will be availableon the home directory if the last line is executed. Use Excel, Google Spreadheets, OpenOffice or any visualisation tool for view and sorting.





