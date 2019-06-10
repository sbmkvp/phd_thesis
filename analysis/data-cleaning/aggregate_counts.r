
(function() { 

get_counts <- function(data) {

	count_probes <- function(probes) {
		threshold <- unique(probes$threshold)
		threshold2 <- unique(probes$threshold2)
		if(probes$type[1] == "Manual") {
			count <- probes %>%
				select(interval,mac) %>%
				group_by(interval) %>% summarise(footfall=length(mac))
			count$count_type <- "Manual"
		} else {
			count <- probes %>% 
				filter(signal >= threshold) %>%
				select(interval,mac) %>%
				group_by(mac) %>% summarise(interval=min(interval)) %>%
				group_by(interval) %>% summarise(footfall=length(unique(mac)))
			count$count_type <- "Sensor"
		}
		count$interval_numeber <- 1:nrow(count)
		count$type <- probes$type[1]
		count$location <- probes$location[2]
		return(count %>% data.frame)
	}

	count <- data %>% 
		split(f=list(.$type,.$location)) %>% 
		lapply(count_probes) %>%
		bind_rows()
	return(count)
}

return(get_counts) })()
