###########################################################################
###Help area for all the installations and librarys we need

list.of.packages <- c("TDAmapper", "fastcluster", "igraph","ggplot2","TDAstats")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

help(fastcluster)
help("mapper1D")

##*************VERY IMPORTANT****************
##Make sure that you replace what is in the "double quotes" on the next line with the file path that you have this
##R-Script saved and all of the .csv files as well.

setwd("C:/Users/Paral/Documents/School/TDA Paper/Covid-19_Research_Data/Data")
library(TDAmapper)
require(fastcluster)
library(igraph)
library(ggplot2)
library(TDAstats)


##Remove everything in our global environment
rm(list = ls())


####The Main Section

##I load all the data in from my .csv

basedata<-read.csv('Covid-19 Data-Set.csv')
popdata<-read.csv('populations.csv')

##This is where you designate what state you want to look at, based on the state abreviations used in the .CSV files
STATE <-'CA'

##Subset data based on state picked
caldata<-subset(basedata,state==STATE)
caldata$collection_date <- as.Date(caldata$collection_date)
attach(caldata)

calPop <-subset(popdata, popdata$State==STATE)
calPopValue<-calPop$Population

##create a column that has the count of days used to calculate the barcode and persistance diagrams
count <- 0

x <- rep(NA,  nrow(caldata))

for(line in x){
  count = count + 1
  x[count] = count
}

ripsDate <- data.frame(x)
rm(count, line, x)



##Create basic ggplots to compare mapper diagrams to
ggplot(data = caldata, aes(x = collection_date )) +
  geom_path(aes(y = ICU.Beds.Occupied.Estimated), color = "red", size = 2)+
  labs(x = "",
       y = "Total ICU Bed Occupation",
       subtitle = "7/2020 - 1/2021")+
  scale_x_date(date_labels = "%B",date_breaks = "1 month")+
  theme(axis.text.x = element_text(angle=45, hjust = 1,face="bold"),
        axis.title=element_text(size=14,face="bold"))

##Create dataframes for each varriable you want to compare by time
ICUdf<-data.frame(x=caldata[,2], y=caldata[,3])

##Create disatance matrix, like the one used by mapper1D, just to look at
dist_mat_ICU<-as.matrix(dist(ICUdf))
write.csv(dist_mat_ICU,'distICU.csv')
rm(dist_mat_ICU)

##Create mapper diagrams for corresponding dataframes
m1 <- mapper1D( 
  distance_matrix = dist(ICUdf), 
  filter_values = ICUdf[,2], 
  num_intervals = 10,
  percent_overlap = 25, 
  num_bins_when_clustering = 16) 

g1 <- graph.adjacency(m1$adjacency, mode="undirected")
plot(g1, layout = layout.auto(g1))

##Calculate homology off of variables used.

ripsDataf <-data.frame(x=ripsDate[,1], y=caldata[,3]) 

ICU.phom <- calculate_homology(ripsDataf)

plot_barcode(ICU.phom)
plot_persist(ICU.phom)

rm(calPop, caldata, calPopValue)