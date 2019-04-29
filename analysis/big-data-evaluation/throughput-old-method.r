library(RJSONIO)
data <- NULL
folder <- "~/unorganised-files/ff_sample/2018/01/01/"
time <- system.time(
for(i in 1:10) {
  sensor <- paste0(folder,dir(folder)[i])
  for(j in dir(sensor)) {
    file <- paste0(sensor,"/",j);
    d <- fromJSON(file);
    d <- data.frame(matrix(unlist(d), nrow=length(d), byrow=T),stringsAsFactors=FALSE);
    if(is.null(data)) { 
      data <- d
    } else {
      data <- rbind(data,d)
    }
  }
  print(i)
}
)

print(time)
