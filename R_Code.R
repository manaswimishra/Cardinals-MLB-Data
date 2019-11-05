install.packages("plotly")
install.packages("googleVis")
install.packages("gapminder")
install.packages("gganimate")
install.packages("zoo")
install.packages("tidyverse")
install.packages("hrbrthemes")
install.packages("viridis")

library(tidyverse)
library(hrbrthemes)
library(viridis)
library(gganimate)
library(ggplot2)
library(plotly)
library(googleVis)
library(gapminder)

Sys.setenv("plotly_username"="manaswimishra")
Sys.setenv("plotly_api_key"="••••••••••")
chart_link = api_create(p, filename="animations-basic")
chart_link

#Read file
df = read.csv("D:/KTM project/Log-20161003-193652 Office return.csv", skip = 1, header = TRUE)

#remove last row which contains garbage value
df<-df[-nrow(df),]

#removing columns which are not required
df<-df[-c(2:4)]

#converting time from factor values to Numeric
df$Time<-as.numeric(as.character(df$Time))

#As the data was procured at 10hz hence the time interval dewlls down to miliseconds
#The data can be kept in same granular scale but needs to be rolled up to seconds level instead of milisecond

#Round the time to nearest integer
df$Time<-ceiling(df$Time)

#Aggregate the data to per second level
df<-aggregate(df[, 2:10], list(df$Time), mean)
names(df)[1]<-"Time"



#SPEED AT DIFFERENT TIME INTERVAL

#plot Speed vs Time graph
p_lot<-ggplot(data=df,aes(x=Time,y=Speed..KM.H.))+geom_line(color="royalblue")
ggplotly(p_lot)


#Make plot function to create multiple images per time interval
#This function will be called repeatedly later on
plotf<-function(dd=max(df$Time)){
  
  ggplot(data=filter(df, Time<=dd), # drop missing obs, only plot if time <=dd
         aes(x=Time,y=Speed..KM.H.))+ 
    
    #####################################################################################
  ## This put invisible (alpha=0) layer on so axis stays fixed,
  ## Alternatively you could manually fix the axis, or maybe let them expand (e.g. http://lenkiefer.com/2017/02/11/expanding-axis/)
  geom_line(data=df,color="#009E73", alpha=0) +  
    #####################################################################################
  geom_line(data=filter(df, Time<=dd),color="#009E73") +
    
    labs(x="Time in Seconds",y="Speed(Kmph)",title="Visualization of Speed at different times of the travel")+
    theme(plot.title=element_text(face="bold",size=16))
  
}

#Test the plot at a particular time interval
plotf(1100)

#Get counts of Time intervals
dlist<-unique(df$Time)
N<- length(dlist)


#  Set YOURDIRECTORY equal to the place where you want to save image files
mydir<-"D:/KTM project/"

# Loop through images
#  could also use purrr::walk()
for (i in 1:(N+10)) {
  file_path = paste0(mydir, "/plot-",4000+i ,".png")
  g<-plotf(dlist[min(i,length(dlist))])
  ggsave(file_path, g, width = 10, height = 8, units = "cm",scale=2) 
  
  print(paste(i,"out of",length(dlist)))
}

#run CMD 
#go to the directory where the file is kept
#Run the script below to create the GIF
#magick convert -delay 10 loop -0 *.png  cpi.gif

file.remove(list.files(pattern=".png"))




#Accelerations

#Check for data defects in lateral-acceleration

mean(df$Accel.X)
#0.4094148

sd(df$Accel.X)
#[1] 0.04119586

quantile(df$Accel.X)
#      0%        25%        50%        75%       100% 
#-0.1494118  0.3976471  0.4150000  0.4329412  0.4788889

#As it can be seen that most of the values are centered around 0.4 which might be due to an offset error due to placement of sensor
#Plot Boxplot to ensure the findings

#Checking for X
df %>%
  ggplot( aes(x="AccelX",y=df$Accel.X, fill="Acc")) +
  geom_boxplot() +
  scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  geom_jitter(color="black", size=0.4, alpha=0.9) +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=11)
  ) +
  ggtitle("Acceleration Distribution") +
  xlab("")


#Cehcking for y
df %>%
  ggplot( aes(x="AccelY",y=df$Accel.Y, fill="Acc")) +
  geom_boxplot() +
  scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  geom_jitter(color="black", size=0.4, alpha=0.9) +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=11)
  ) +
  ggtitle("Acceleration Distribution") +
  xlab("")

#Cehcking for z
df %>%
  ggplot( aes(x="AccelZ",y=df$Accel.Z, fill="Acc")) +
  geom_boxplot() +
  scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  geom_jitter(color="black", size=0.4, alpha=0.9) +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=11)
  ) +
  ggtitle("Acceleration Distribution") +
  xlab("")

#looking at the acceleration data it would be best to normalize the acceleration variables around 0 and then calculate the Acceleration G experienced by the sensor


check<-dataframe(mean(df$Accel.X)-df$Accel.X)
check



normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

dfNorm <- as.data.frame(lapply(df["Accel.X"], normalize))

dfNorm %>%
  ggplot( aes(x="AccelX",y=dfNorm$Accel.X, fill="Acc")) +
  geom_boxplot() +
  scale_fill_viridis(discrete = TRUE, alpha=0.6) +
  geom_jitter(color="black", size=0.4, alpha=0.9) +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=11)
  ) +
  ggtitle("Acceleration Distribution") +
  xlab("")





















#MAP

#Basic Plot
g=ggplot(df) + geom_point(aes(x=df$Longitude,y=df$Latitude,col=sign(Speed..KM.H.),size=abs(Speed..KM.H.)))
print(g)


install.packages("rworldmap")
library(rworldmap)
newmap <- getMap(resolution = "high")
plot(newmap,xlim=c(76,78),ylim=c(10,15),asp=1)
points(log$Longitude,log$Latitude, col="red", cex=.6)


p_lot_map<-ggplot(log,aes(Latitude,Longitude))+geom_point(aes(frame=Time))
ggplotly(p_lot_map)

library(ggplot2)
install.packages("ggmap")
library(ggmap)

# creating a sample data.frame with your lat/lon points
lon <- c(-38.31,-35.5)
lat <- c(40.96, 37.5)
df <- as.data.frame(cbind(lon,lat))

# getting the map
mapgilbert <- get_map(location = c(lon = mean(log$Longitude), lat = mean(log$Latitude)), zoom = 4,
                      maptype = "satellite", scale = 2)

# plotting the map with some points on it
ggmap(mapgilbert) +
  geom_point(data = df, aes(x = lon, y = lat, fill = "red", alpha = 0.8), size = 5, shape = 21) +
  guides(fill=FALSE, alpha=FALSE, size=FALSE)



