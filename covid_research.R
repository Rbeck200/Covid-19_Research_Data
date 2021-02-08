###########################################################################
#Help area for all the installations and librarys we need

list.of.packages <- c("TDAmapper", "fastcluster", "igraph")
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

rm(list = ls())






##I load all the data in from my .csv

basedata<-read.csv('Covid-19 Data-Set.csv')


##I want to separate the data by the date 
##so that I can gegt one days worth of data at a time like this file

exampledata<-read.csv('Example_Data.csv')

######Use this area to loop through a .csv that has the dates from 
########each month in a collunm to process it a month at a time.---------------------------------------------------


##SOmething like for(int i; i < month.length; i++) so that I can loo through a month at a time
#########-=--------------------------------------------------------------------------------------------------------


##Use next part to separate data into one days worth
#####This code that I need help using to separate into one day===================================================

mydata<-subset(basedata,collection_date='7/1/2020')
######===========================================================================================================





###calculate positivity rate

posRate<-data.frame(mydata$Positive.Tests / mydata$Negative.tests)





##########This code does not work it is something that I would like a hand with++++++++++++++++++

ICUdf<-merge(x=mydata[3], y=posRate[1])
  
DEATHdf<-merge(x=mydata[12], y=posRate[1])

######+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++





m1 <- mapper1D( 
  distance_matrix = dist(ICUdf), 
  filter_values = ICUdf[,2], #This defines the filter function to be the x value num_intervals = 10, 
  num_intervals = 8,
  percent_overlap = 50, 
  num_bins_when_clustering = 1) 

g1 <- graph.adjacency(m1$adjacency, mode="undirected")
plot(g1, layout = layout.auto(g1) ,xlab='X',ylab='Y',main='Dist - 1')



m2 <- mapper1D( 
  distance_matrix = dist(DEATHdf), 
  filter_values = DEATHdf[,2], #This defines the filter function to be the x value num_intervals = 10, 
  num_intervals = 8,
  percent_overlap = 50, 
  num_bins_when_clustering = 2) 

g2 <- graph.adjacency(m2$adjacency, mode="undirected")
plot(g2, layout = layout.auto(g2) ,xlab='X',ylab='Y',main='Dist - 2')

########------------------------------------------------------------------------------------------------------

