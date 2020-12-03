# Name: Ricarda Duerst
# Date: 03.12.2020
# IODS: Script for RStudio Exercise 6

# data source BPRS: https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt
# data source RATS: https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt

# necessary libraries:
library(dplyr)
library(tidyr)

# load data from MABS GitHub repository in wide format
bprs <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", header = TRUE)
rats <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE)


# explore the data sets

# BPRS
names(bprs)
str(bprs)
dim(bprs)
summary(bprs)

# RATS
names(rats)
str(rats)
dim(rats)
summary(rats)


# convert categorical variables to factors

# BPRS: variables subject, treatment
bprs$subject <- factor(bprs$subject)
bprs$treatment <- factor(bprs$treatment)

# RATS: variables, ID, Group
rats$ID <- factor(rats$ID)
rats$Group <- factor(rats$Group)


# convert wide formatted data sets to long format
bprs.long <-  bprs %>% gather(key = weeks, value = bprs, -treatment, -subject)
rats.long <- rats %>% gather(key = times, value = weight, -ID, -Group)

# add week variable to BPRS data
bprs.long <- bprs.long %>% mutate(week = as.integer(substr(weeks, 5, 5)))

# add time variable to RATS data
rats.long <- rats.long %>% mutate(time = as.integer(substr(times, 3, 5)))


# explore the data sets in long format

# BPRS
names(bprs.long)
str(bprs.long)
dim(bprs.long)
summary(bprs.long)
glimpse(bprs.long)

# RATS
names(rats.long)
str(rats.long)
dim(rats.long)
summary(rats.long) 
glimpse(rats.long)


# save data sets as csv files in data folder
write.table(bprs.long, file = "data\\bprs.csv", sep = ",")
write.table(rats.long, file = "data\\rats.csv", sep = ",")
