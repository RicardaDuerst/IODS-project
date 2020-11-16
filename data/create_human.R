# Name: Ricarda Duerst
# Date: 16.11.2020
# IODS: Script for RStudio Exercise 4/5

# data source Human Development: http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets
# data source Gender Inequality: http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets

# necessary libraries
library(dplyr)

# read in data
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# explore data sets (structure, dimensions, summaries of variables)
str(hd)
dim(hd)
summary(hd)

str(gii)
dim(gii)
summary(gii)

# rename variables with short and meaningful names
# source: http://hdr.undp.org/en/content/human-development-index-hdi
names(hd) <- c("gni_rank", "cntr", "hdi", "e0", "exp_edu", "mean_edu", "gni", "gni_minus_rank")
names(gii) <- c("gii_rank", "cntr", "gii", "mmr", "abr", "parlia", "sec_edu_f", "sec_edu_m", "lfp_f", "lfp_m")

# create new variables for gender inequality data:
# ratio of female and male population with secondary education for each country
gii <- mutate(gii, sec_edu_sexratio = sec_edu_f / sec_edu_m)
# ratioj of labour force participation of females and males for each country
gii <- mutate(gii, lfp_sexratio = lfp_f / lfp_m)


# join the dats sets
human <- inner_join(hd, gii, by = "cntr")
dim(human) #correct number of observations and variables

# save data set as csv file to data folder
write.table(human, file = "data\\human.csv", sep = ",")
