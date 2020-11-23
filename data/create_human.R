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

##############################################################################

# Date: 23.11.2020
# IODS: Script for RStudio Exercise 5

# necessary libraries
library(stringr)
library(dplyr)
library(tibble)

# read in data
human <- read.table("data\\human.csv", sep = ",")

# structure and dimensions of the data
str(human)
dim(human) # 195 observations and 19 variables, as it should be

# transform GNI variable to numeric
human$gni <- str_replace(human$gni, pattern = ",", replace = "") %>% as.numeric()

# exclude unneeded variables
keep = c("cntr", "sec_edu_sexratio", "lfp_sexratio", "exp_edu", "e0", "gni", "mmr", "abr", "parlia")
human_new <- dplyr::select(human, one_of(keep))

# exclude observations with missing values
human_new <- filter(human_new, complete.cases(human_new))

# remove observations that relate to regions and not countries (the last 6 in the data set)
my_human <- human_new[1:(nrow(human_new)-7),]

# transform cntr variable to rownames
my_human <- my_human %>% remove_rownames() %>% column_to_rownames("cntr")

# check dimensions
dim(my_human) # everything as it should be

# overrite old human data with new human data
write.table(my_human, file = "data\\human.csv", sep = ",", row.names = TRUE)

