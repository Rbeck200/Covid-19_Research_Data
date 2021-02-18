###########################################################################
#Help area for all the installations and librarys we need

list.of.packages <- c("TDAmapper", "fastcluster", "igraph","ggplot2")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

help(fastcluster)
help("mapper1D")

##*************VERY IMPORTANT****************
##Make sure that you replace what is in the "double quotes" on the next line with the file path that you have this
##R-Script saved and all of the .csv files as well.

setwd("C:/Users/Paral/Documents/School/CURM/Covid-19_Research_Data")
library(TDAmapper)
require(fastcluster)
library(igraph)
library(ggplot2)

rm(list = ls())

##I load all the data in from my .csv

basedata<-read.csv('Covid-19 Data-Set.csv')
popdata<-read.csv('populations.csv')


caldata<-subset(basedata,state=='CA')
caldata$collection_date <- as.Date(caldata$collection_date)
attach(caldata)

calPop <-subset(popdata, popdata$State=="CA")
calPopValue<-calPop$Population


plot(ICU.Beds.Occupied.Estimated~collection_date, data=caldata)

##SOmething like for(int i; i < month.length; i++) so that I can loo through a month at a time
#########-=--------------------------------------------------------------------------------------------------------

ggplot(data = caldata, aes(x = collection_date )) +
  geom_path(aes(y = ICU.Beds.Occupied.Estimated), color = "blue")+
  labs(x = "Date",
       y = "Total ICU Bed Occupation",
       title = "ICU Occupation - California",
       subtitle = "7/2020 - 1/2021")+
       scale_x_date(date_labels = "%B",date_breaks = "1 month")+
       theme(axis.text.x = element_text(angle=45, hjust = 1))

ggplot(data = caldata, aes(x = collection_date )) +
  geom_path(aes(y = ((Deaths/calPopValue)*100000)), color = "darkred")+
  labs(x = "Date",
       y = "Deaths per 100,000 people",
       title = "Deaths per 100,000 people - California",
       subtitle = "7/2020 - 1/2021")


ICUdf<-data.frame(x=caldata[,2], y=caldata[,3])

dist_mat_ICU<-as.matrix(dist(ICUdf))
write.csv(dist_mat_ICU,'distICU.csv')
rm(dist_mat_ICU)
  
DEATHdf<-data.frame(x=caldata[,2], y=((caldata[,12]/calPopValue)*100000))

dist_mat_DEATH<-as.matrix(dist(DEATHdf))
write.csv(dist_mat_DEATH,'distDEATH.csv')
rm(dist_mat_DEATH)

threeDdf<-data.frame(x=caldata[,2], y=caldata[,3], z=((caldata[,12]/calPopValue)*100000))

m1 <- mapper1D( 
  distance_matrix = dist(ICUdf), 
  filter_values = ICUdf[,2], 
  num_intervals = 10,
  percent_overlap = 26, 
  num_bins_when_clustering = 8) 

g1 <- graph.adjacency(m1$adjacency, mode="undirected")
plot(g1, layout = layout.auto(g1) ,xlab='Date',ylab='Staffed Occupied ICU Beds',main='ICU Occupation - 7/20-1/21')



m2 <- mapper1D( 
  distance_matrix = dist(DEATHdf), 
  filter_values = DEATHdf[,2],  
  num_intervals = 8,
  percent_overlap = 50, 
  num_bins_when_clustering = 10) 

g2 <- graph.adjacency(m2$adjacency, mode="undirected")
plot(g2, layout = layout.auto(g2) ,xlab='X',ylab='Y',main='Death Rate per 100000')

##m3 <- mapper()

