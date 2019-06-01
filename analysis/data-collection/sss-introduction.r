library(RPostgreSQL)
library(tidyverse)
library(RJSONIO)
library(ggplot2)
library(rgdal)
library(rgeos)
library(maptools)
library(tmap)
library(sf)
library(showtext)

font_add('Helvetica', '/usr/share/fonts/OTF/Helvetica-Light.otf')
font_add('Futura', '/usr/share/fonts/TTF/futura-poster-light.ttf')


config <- fromJSON("../config.json", simplify = FALSE)
con <- dbConnect(dbDriver('PostgreSQL'),
                 dbname = config$dbname,
                 user = config$dbuser,
                 password = config$dbpassword,
                 host = config$dbhost )
query <- "select city,region from locations;"
data <- dbGetQuery(con, query)
locations <- data %>% group_by(city) %>% summarize(locations = length(city))
boundary <- readOGR('../../data/maps','ultra-generalised')
boundary <- unionSpatialPolygons(boundary,rep("UK",4))
tm_shape(boundary) + tm_borders() + tm_layout(frame = FALSE)
places <- read.csv("../../data/maps/place_names/pop.list", header = FALSE) %>%
  rename(city = V1) %>% filter(city %in% data$city) %>%
  group_by(city) %>% summarise(eastings=V2[1],northings=V3[1])

coords <- cbind(Easting = as.numeric(as.character(places$eastings)),
                Northing = as.numeric(as.character(places$northings)))
places_shp <- SpatialPointsDataFrame(coords,data=places,proj4string = CRS("+init=epsg:27700"))
places_shp <- spTransform(places_shp, CRS("+init=epsg:4326"))
places_shp@data <- merge(places_shp@data,locations,by="city")

map <- tm_shape(boundary) + tm_borders() +
  tm_shape(places_shp) + 
  tm_symbols(size = "locations", col="#E68E22", border.col = "red", 
             scale = 1.4, sizes.legend = c(10,50,150,300),
             title.size = "No. of Locations", alpha = 0.5, border.alpha = 1) + 
  tm_layout(frame = FALSE, 
            legend.height = 0.14,
            legend.title.fontfamily = "Helvetica")

tmap_save(map,"../../images/sss-locations.png",width=2.25,height=4.5,units="in")

dbDisconnect(con)
