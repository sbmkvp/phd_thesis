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

config <- fromJSON("../../config.json", simplify = FALSE)
con <- dbConnect(dbDriver('PostgreSQL'),
                 dbname = config$dbname,
                 user = config$dbuser,
                 password = config$dbpassword,
                 host = config$dbhost )
query <- "select id as location,city,region,lat,lon from locations;"
locations <- dbGetQuery(con, query)

query <- "select 
            location,
            date_trunc('week', timestamp),
            sum(counts_global+adjusted_local) as counts
          from counts where
            date(timestamp) between '2018-01-01' and '2018-12-31'
          group by 1;"
counts <- dbGetQuery(con,query)

final <- counts %>%
  left_join(locations) %>%
  mutate(city = ifelse(region=="Greater London","London",city)) %>%
  group_by(city) %>%
  summarise(counts = mean(counts)/100000,
            lat = mean(lat), lon = mean(lon)) %>% ungroup() %>%
  filter(!is.na(counts),!is.na(city))

boundary <- readOGR('../../../data/maps','ultra-generalised')
boundary <- unionSpatialPolygons(boundary,rep("UK",4))

coords <- cbind(lng = as.numeric(as.character(final$lon)),
                lat = as.numeric(as.character(final$lat)))
map_data <- SpatialPointsDataFrame(coords,data=final,proj4string = CRS("+init=epsg:4326"))

map <- tm_shape(boundary) + tm_borders() +
  tm_shape(map_data) + 
  tm_symbols(size = "counts", col="orange", border.col = "black",
             scale = 1, border.lwd = 0.1,
             title.size = "Average footfall per location",
             alpha = 0.5, border.alpha = 1) + 
  tm_text("city", size="counts",scale=0.5,root=5,
          ymod = 0.5,
          legend.size.show = FALSE) +
  tm_layout(frame = FALSE, 
            legend.title.size = 1,
            legend.text.size = 1,
            legend.title.fontfamily = "Helvetica")
print(map)

tmap_save(map,"../../../images/applications_cities_rank.png",width=210,height=297,units="cm")
