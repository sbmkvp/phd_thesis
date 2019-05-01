library(fmsb)
library(showtext)
font_add('Helvetica', '/usr/share/fonts/OTF/Helvetica-Light.otf')
library(Cairo)

data <- data.frame(
  volume = 2.5,
  variety = 0,
  veracity = 5,
  visualisation = 2,
  velocity = 2.5
)

data <- rbind(rep(5,5),rep(0,5),data)
CairoFonts(
  regular="Helvetica",
  bold="Helvetica",
  italic="Helvetica",
  bolditalic="Helvetica")
png("../../images/spider.png",width=400,height=400,type="cairo")
par(family="regular")
radarchart(data,
  pcol = '#FF5733', pfcol = rgb(1,0.4,0,0.2),
  cglcol= "#777777", cglty = 1, cglwd = 1, vlcex = 1.6
)
dev.off()
