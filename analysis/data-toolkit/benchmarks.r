rm(list=ls())
suppressMessages(library(tidyverse))
suppressMessages(library(RJSONIO))

test <- function(number_of_sensors) {
  day <- "~/unorganised-files/ff_sample/2018/01/01"
  sensors <- paste(day, dir(day), sep = "/")[1:number_of_sensors]
  probes <- NULL
  for(sensor in sensors) {
    files <- paste(sensor, dir(sensor), sep = "/")
    for( file in files ) {
      records <- fromJSON(file)
      location <- vector(); signal <- vector(); mac <- vector(); packets <- vector(); vendor <- vector(); type <- vector(); time <- vector();
      for(record in records) {
        signal <- append(signal,record$Signal);
        mac <- append(mac,record$MacAddress);
        packets <- append(packets,record$PacketCount);
        type <- append(type,record$PacketType);
        vendor <- append(vendor,record$VendorMacPart);
        time <- append(time,strsplit(strsplit(file,'\\.')[[1]][1],'/')[[1]][8])
        location <- append(location,strsplit(strsplit(file,'\\.')[[1]][1],'/')[[1]][7])
      }
      recordsdf <- data.frame(location,time,signal,mac,packets,type,vendor)
      if(is.null(probes)) { probes <- recordsdf } else { probes <- rbind(probes,recordsdf) }
    }
  }
  probes %>%
    group_by(location,time) %>%
    summarise(count = length(unique(paste0(vendor,mac)))) %>%
    write.csv("output-old.csv",row.names=FALSE)
}

times <- vector()
range <- 1:10
for(i in range) {
  times <- append(times,system.time(test(i))[3][["elapsed"]])
}

data <- data.frame(x=range,y = times)

library(showtext)
font_add('Helvetica', '/usr/share/fonts/OTF/Helvetica-Light.otf')

p <- data %>% 
  ggplot() + 
  geom_line(aes(as.integer(x), as.integer(y), group="time"),
            show.legend = FALSE,
            size = 0.5,
            color = "#FF5733") +
  ylab("Processing time (s)") + xlab("Number of locations") +
  scale_y_continuous(limits=c(0,200)) +
  scale_x_continuous(breaks=c(2,4,6,8,10)) +
  theme(text = element_text(family = "Helvetica Neue"),
        panel.background = element_blank(),
        axis.text = element_text(size = 10, color = "black"),
        axis.ticks.y = element_blank(),
        axis.title.y = element_text(size=10, color="black",margin=margin(0,10,0,0)),
        axis.title.x = element_text(size=10, color="black",margin=margin(10,0,0,0)),
        axis.line.x = element_line(color= "black", size = 0.1))
 
ggsave("../../images/processing-time-old.png", plot=p, height=3, width=3,units="in")

