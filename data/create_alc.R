# Name: Ricarda Duerst
# Date: 10.11.2020
# IODS: Script for RStudio Exercise 3

# data source: https://archive.ics.uci.edu/ml/datasets/Student+Performance

# necessary libraries
library(dplyr)

# read in data
math <- read.csv("data/student-mat.csv", header = TRUE, sep = ";")
port <- read.csv("data/student-por.csv", header = TRUE, sep = ";")

## explore structure and dimensions of the data:

# dimensions
dim(math)
dim(port)

# structure
str(math)
str(port)

# Both datasets have 33 variables, but much more people answered the Portuguese survey than the Mathematics survey.

## join the data sets:

# common columns to use as identifiers
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

# join the two datasets by the selected identifiers
math_port <- inner_join(math, port, by = join_by, suffix = c(".math", ".por"))

# structure and dimensions of new data set
dim(math_port)
str(math_port)

# 382 students answered both surveys. The new data has 53 variables.

## combine the duplicated answers in the data:

# create a new data frame with only the joined columns
alc <- select(math_port, one_of(join_by))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_port' with the same original name
  two_columns <- select(math_port, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

## create new columns alc_use and high_use:

# define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# define a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)

# glimpse at joined and modified data
glimpse(alc) # everything is how it should be

# save data set as csv file to data folder
write.table(alc, file = "data\\alc.csv", sep = ",")

