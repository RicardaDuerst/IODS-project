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

# The BPRS data contains 40 observations (men) and their treatment group (1 or 2)
# as well as repeated measures of their psychological health for 8 weeks after the
# the initial measurement in week 0 and subsequent treatment.

# BPRS
names(bprs)
str(bprs)
dim(bprs)
summary(bprs)

# The RATS data contains 16 observations (rats) and their treatment group (1, 2, or 3)
# as well as repeated measures of their weight over a 9-week period.

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

# In contrast to the wide format data where the information of each men or rat 
# was stored in one row (each repeated measure had their own column), there is
# only one column for the BPRS or weight and a new variable indicating the time
# of measurement. Therefore, the individuals men or rats appear several times in
# different rows of the data set. Hence, it is called the long format, as the
# data is stored under each other instead of next to each other (wide format).

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
