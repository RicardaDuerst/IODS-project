# Name: Ricarda Duerst
# Date: 02.11.2020
# IODS: Script for RStudio Exercise 2

# read in data
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", header = T, sep = "\t")

# explore structure and dimensions
View(learning2014) # shows me the full data set in another window
str(learning2014) # shows me the structure of the data, mainly how the variables are coded and what kind of obj the data is stored in
dim(learning2014) # shows me the number of rows and columns

# the data is stored in a data frame with 60 variables (in the columns) and 183 observations (in the rows)
# besides gender which is coded as a factor with "F" and "M", all the other variables are in numerical format


# Access the dplyr library
library(dplyr)

# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)

# choose a handful of columns to keep
keep_columns <- c("gender", "Age", "Attitude", "deep", "stra", "surf", "Points")

# select the 'keep_columns' to create a new dataset
learning2014 <- select(lrn14, one_of(keep_columns))

# exclude obs with 0 exam points
learning2014 <- filter(learning2014, Points > 0)

# check dimensions (shoudl be 166 obs and 7 var)
dim(learning2014)

# save data set as csv file to data folder
write.table(learning2014, file = "data\\learning2014.csv", sep = ",")

# read in the data again and make sure it has the same structure as before
test.data <- read.table("data\\learning2014.csv", header = T, sep = ",")
str(test.data)
head(test.data)
