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
query <- "select location, extract(month from timestamp) as month, sum(counts_global+adjusted_local) as counts
          from counts where date(timestamp) between '2017-03-01' and '2017-05-31'
          group by 1,2;"
counts <- dbGetQuery(con,query)
query <- "select location, extract(month from timestamp) as month, sum(counts_global+adjusted_local) as counts2 
          from counts where date(timestamp) between '2018-03-01' and '2018-05-31'
          group by 1,2;"
counts2 <- dbGetQuery(con,query)
dbDisconnect(con)

final <- counts %>%
  left_join(counts2) %>% left_join(locations) %>%
  mutate(city = ifelse(region=="Greater London","London",city)) %>%
  group_by(city,month) %>%
  summarise(counts = ((mean(counts2)-mean(counts))/mean(counts2))*100,
            lat = mean(lat), lon = mean(lon)) %>% ungroup() %>%
  mutate(type = ifelse(counts > 1,"Rise", "Fall")) %>%
  mutate(counts = abs(counts)) %>%
  mutate(counts = ifelse(counts > 100, 100, ifelse(counts < (-100),-100,counts))) %>%
  filter(!is.na(counts),!is.na(city))

boundary <- readOGR('../../../data/maps','ultra-generalised')
boundary <- unionSpatialPolygons(boundary,rep("UK",4))
coords <- cbind(lng = as.numeric(as.character(final$lon)),
                lat = as.numeric(as.character(final$lat)))
map_data <- SpatialPointsDataFrame(coords,data=final,proj4string = CRS("+init=epsg:4326"))

map1 <- tm_shape(boundary) + tm_borders(col="black",lwd=0.5) +
  tm_shape(map_data[map_data@data$month==3,]) + 
  tm_symbols(size = "counts", col="type", border.col = "black",
             scale = 0.7, border.lwd = 0.1,
             palette = c("#E74C3C","#28B463"),
             title.size = "Volume of Change (%)",
             title.col = "Direction",sizes.legend = c(10,20,40,100),
             alpha = 0.8, border.alpha = 1) + 
  tm_text("city", size="counts",scale=0.3,root=1.5,
          ymod = 0.5,
          legend.size.show = FALSE) +
  tm_layout(frame = FALSE, 
            main.title = "Mar 2019",
            main.title.size = 0.5,
             legend.title.size = 0.4,
            legend.text.size = 0.3,
            legend.title.fontfamily = "Helvetica")
map2 <- tm_shape(boundary) + tm_borders(col="black",lwd=0.5) +
  tm_shape(map_data[map_data@data$month==4,]) + 
  tm_symbols(size = "counts", col="type", border.col = "black",
             scale = 0.7, border.lwd = 0.1,
             palette = c("#E74C3C","#28B463"),
             title.size = "Volume of Change (%)",
             title.col = "Direction",sizes.legend = c(10,20,40,100),
             alpha = 0.8, border.alpha = 1) +
  tm_text("city", size="counts",scale=0.4,root=2,
          col = "#666666",
          ymod = map_data[map_data@data$month==4,]@data$counts/250+0.2,
          legend.size.show = FALSE) +
  tm_layout(frame = FALSE, 
            main.title = "Apr 2019",
            main.title.size = 0.5,
             legend.title.size = 0.4,
            legend.text.size = 0.3,
            legend.title.fontfamily = "Helvetica")
map3 <- tm_shape(boundary) + tm_borders(col="black",lwd=0.5) + 
  tm_shape(map_data[map_data@data$month==5,]) + 
  tm_symbols(size = "counts", col="type", border.col = "black",
             scale = 0.7, border.lwd = 0.1,
             palette = c("#E74C3C","#28B463"),
             title.size = "Volume of Change (%)",
             title.col = "Direction",sizes.legend = c(10,20,40,100),
             alpha = 0.8, border.alpha = 1) + 
  tm_text("city", size="counts",scale=0.4,root=2,
          col = "#666666",
          ymod = -map_data@data$counts/250-0.2,
          legend.size.show = FALSE) +
  tm_layout(frame = FALSE,
            main.title = "May 2019",
            main.title.size = 0.5,
            legend.title.size = 0.4,
            legend.text.size = 0.3,
            legend.title.fontfamily = "Helvetica")
map <- tmap_arrange(map2,map3)
tmap_save(map,"../../../images/applications-city-indices.png",width=6,height=4,units="in")

