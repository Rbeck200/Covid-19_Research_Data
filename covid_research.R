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

basedata<-read.csv('Covid-19 Data-Set.csv')

class(basedata$collection_date)

mydata<-subset(basedata,collection_date='7/1/2020')
