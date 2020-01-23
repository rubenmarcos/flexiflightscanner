library(tidyverse)
require("httr")
require("jsonlite")


# Defining a random number useful for merging results of queries

id <- sample(1:100000, 1)


# Defining cities and first and last dates required on the search and creating a data frame with all the combinations

origin <- c("MAD","BCN")
destination <- c("LIS","OPO","ROM")

first_date <- "2020-08-04"
last_date <- "2020-08-15"

dates <- seq(as.Date(first_date),as.Date(last_date), by = "days")

airports <- merge(origin,destination) %>% dplyr::rename(Origin = x, Destination = y) %>% lapply(as.character) 

routes <- merge(airports,dates) %>% dplyr::rename(Dates = y) %>% mutate(URL = "", Origin = as.character(Origin), Destination = as.character(Destination))


# API Connection details

base <- "https://partners.api.skyscanner.net/apiservices/browsedates/v1.0/ES/EUR/es-ES"
key <- "?apiKey=insert_your_SkyScanner_api_key_here"


# Loop for checking every combination of places and dates

for (i in 1:nrow(routes)) {

routes$URL[i] <- paste(base,routes$Origin[i],routes$Destination[i],routes$Dates[i],key,sep = "/")

call1 <- fromJSON(content(GET(routes$URL[i], type = "basic"),"text", encoding = "UTF-8"), flatten = TRUE)

assign(paste(id,"fares",routes$Origin[i],routes$Destination[i],routes$Dates[i],sep="-"), as.data.frame(call1[["Quotes"]]))

assign(paste(id,"places",routes$Origin[i],routes$Destination[i],routes$Dates[i],sep="-"), as.data.frame(call1[["Places"]]))

assign(paste(id,"carriers",routes$Origin[i],routes$Destination[i],routes$Dates[i],sep="-"), as.data.frame(call1[["Carriers"]]))

}


# Merging all data on global data frames for quotes, cities and carriers

total <- mget(ls(pattern=paste0(id,"\\-fares"))) %>% bind_rows() %>% unnest(cols = c(OutboundLeg.CarrierIds))

total_places <- mget(ls(pattern=paste0(id,"\\-places"))) %>% bind_rows() %>% select(PlaceId,IataCode,CityName) %>% distinct(PlaceId, .keep_all = TRUE)

total_carriers <- mget(ls(pattern=paste0(id,"\\-carriers"))) %>% bind_rows() %>% select(CarrierId,CarrierName = Name)  %>% distinct(CarrierId, .keep_all = TRUE)


#Cleaning single results
rm(list = ls(pattern=paste0(id,"\\-fares")))
rm(list = ls(pattern=paste0(id,"\\-places")))
rm(list = ls(pattern=paste0(id,"\\-carriers")))


# Merging Fares, Destinations and Airports on a single data frame and preparing for final presentation
total <- merge(total, total_carriers, by.y = "CarrierId", by.x = "OutboundLeg.CarrierIds")
total <- merge(total, total_places, by.y = "PlaceId", by.x = "OutboundLeg.OriginId")
total <- merge(total, total_places, by.y = "PlaceId", by.x = "OutboundLeg.DestinationId")


total <- total %>% mutate(QuoteDateTime = as.POSIXct(QuoteDateTime), OutboundLeg.DepartureDate = as.Date(OutboundLeg.DepartureDate)) %>% select(Fare = MinPrice, Direct_Flight = Direct, Date_Obtained_Quote = QuoteDateTime, Departure_Date = OutboundLeg.DepartureDate, Carrier = CarrierName, Departure_Airport = IataCode.x, Departure_City = CityName.x, Destination_Airport = IataCode.y, Destination_City = CityName.y)


# Export to .csv file for using it on visualisation tools.
# Using this as a source for a Shiny App, is also an option.

write.csv(total,paste("FlexiFlightScanner",first_date,last_date,"fares.csv", sep ="-"), row.names = FALSE)