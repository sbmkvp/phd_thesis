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
library(lubridate)
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
            date_trunc('week',timestamp) as week,
            sum(counts_global+adjusted_local) as counts
          from counts where
            date(timestamp) between '2017-01-01' and '2018-12-31'
          group by 1,2;"
counts <- dbGetQuery(con,query)

before <- counts %>% filter(year(ymd(week)) == 2017) %>% 
  select(location,week,before=counts) %>% group_by(location) %>%
  summarise(before=mean(before))
after <- counts %>% filter(year(ymd(week)) == 2018) %>% 
  select(location,week,after=counts) %>% group_by(location) %>%
  summarise(after=mean(after))
final <- left_join(before, after) %>%
  left_join(locations) %>%
  mutate(city = ifelse(region=="Greater London","London",city)) %>%
  group_by(city) %>%
  summarise(change = mean((after-before)/before*100), lat = mean(lat), lon = mean(lon)) %>%
  mutate(direction = ifelse(change<0,"down","up")) %>%
  mutate(change = abs(change)) %>%
  filter(!is.na(change),!is.na(city))

boundary <- readOGR('../../../data/maps','ultra-generalised')
boundary <- unionSpatialPolygons(boundary,rep("UK",4))
coords <- cbind(lng = as.numeric(as.character(final$lon)),
                lat = as.numeric(as.character(final$lat)))
map_data <- SpatialPointsDataFrame(coords,data=final,proj4string = CRS("+init=epsg:4326"))

map <- tm_shape(boundary) + tm_borders(col="black") +
  tm_shape(map_data) + 
  tm_symbols(size = "change", col="direction", border.col = "black",
             scale = 1.2, border.lwd = 0.1,
             palette = c("#E74C3C","#28B463"),
             title.size = "Average change in footfall\n 2017-18 (%)",
             # sizes.legend = c(1,2,4,6,8,10),
             alpha = 0.90, border.alpha = 1) + 
  tm_text("city", size="change",scale=1,root=2,
          remove.overlap = TRUE,
          col = "#666666",
          ymod = map_data@data$change/55,
          legend.size.show = FALSE) +
  tm_layout(frame = FALSE, 
            legend.title.size = 1,
            legend.text.size = 1,
            legend.title.fontfamily = "Helvetica")
tmap_save(map,"../../../images/applications-cities-rank.png",width=210,height=297,units="mm")
