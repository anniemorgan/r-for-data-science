####################################################################
# Title: R for Data Science Exercises
# Filename: tidyr_study.R
# Author: Morgan Thompson
# Date: February 28, 2019
# Description: Exercises from the 'R for Data Science' online book
###################################################################

# DATA MANIPULATION ###############################################

install.packages('tidyverse')
install.packages('nycflights13')
library(tidyverse)
library(nycflights13)

data('mtcars')
data('iris')

mydata <- mtcars
mydata <- as_tibble(mtcars)

head(mydata)

myiris <- iris
myiris <- as_tibble(myiris)

head(myiris)

head(flights)
View(flights)

options(tibble.print_max = 20, tibble.print_min = 20)
options(tibble.width = Inf)

#########################################################################################################
# DATA TRANSFORMATION ###################################################################################
#########################################################################################################

# filter() exercises, 'R for Data Science' ###########################################

# 1. Find all flights that
#   1. Had an arrival delay of two or more hours
#   2. Flew to Houston (IAH or HOU)
#   3. Were operated by United, American, or Delta
#   4. Departed in summer (July, August and September)
#   5. Arrived more than two hours late, but didn't leave late
#   6. Were delayed by at least an hour, but made up over 30 minutes in flight
#   7. Departed between midnight and 6am (inclusive)

# 1.1
flights %>% filter(dep_delay >= 120)

# 1.2
flights %>% filter(dest %in% c('IAH', 'HOU'))

# 1.3
flights %>% filter(carrier %in% c('AA', 'DL', 'UA'))

# 1.4
flights %>% filter(month %in% c(7, 8, 9))

# 1.5
flights %>% filter(arr_delay >= 120 & dep_delay <= 0)

# 1.6
flights %>% filter(dep_delay >= 60, dep_delay - arr_delay > 30)

# 1.7
flights %>% filter(dep_time >= 0 & dep_time <= 6)

# 2. Another useful dplyr filtering helper is between().  What does it do? Can you use it to simplify the code needed to answer 
#    the previous challenges?

# between(dat, x, y) grabs the values in dat between x and y, inclusive.  Answer 1.7 can be simplified to
flights %>% filter(between(dep_time, 0, 6))
# and answer 1.4 can be simplified to
flights %>% filter(between(month, 7, 9))

# 3. How many flights have a missing dep_time? What other variables are missing? What might these rows represent?
flights %>% filter(is.na(dep_time)) %>% count()  # 8,255 flights
# looking at the first 10 rows of this filtered data, dep_delay, arr_time, and arr_delay variables are also missing.  My guess
# is that these were canceled flights.

# 4. Why is NA ^ 0 not missing? Why is NA | TRUE not missing? Why is FALSE & NA not missing? Can you figure out the general
#    rule? (NA * 0 is a tricky counterexample!)

NA ^ 0  # not missing because anything to the power of 0 is equal to 1.
NA | TRUE  # not missing because something is always TRUE or unknown.
FALSE & NA  # not missing because we cannot ever know if an unknown is also FALSE.
NA * 0 # missing because of an inconsistency in R's handling of NAs.

# arrange() exercises, 'R for Data Science' #########################################################

# 1. How could you use arrange() to sort all missing values to the start? (Hint: use is.na())
flights %>% arrange(desc(is.na(dep_time)))

# 2. Sort flights to find the most delayed flights.  Find the flights that left earliest.
flights %>% arrange(desc(dep_delay + arr_delay))  # I chose to add these values to take into account time made up in-flight
flights %>% arrange(dep_time)

# 3. Sort flights to find the fastest flights.
flights %>% arrange(air_time)

# 4. Which flights traveled the longest? Which traveled the shortest?
flights %>% arrange(desc(distance))
flights %>% arrange(distance)

# select() exercises, 'R for Data Science' ##########################################################


# 1. Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay from flights.
flights %>% select(starts_with("dep"), starts_with("arr"))
flights %>% select(dep_time, dep_delay, arr_time, arr_delay)
flights %>% select(matches("^arr.*"), matches("^dep.*"))

# 2. What happens if you include the name of a variable multiple times in a select() call?
flights %>% select(arr_time, arr_time)
# it just returns it once.

# 3. What does the one_of() function do? Why might it be helpful in conjunction with this vector?
#    vars <- c("year", "month", "day", "dep_delay", "arr_delay")
# one_of() will grab columns that match an element in a character vector.  If I wanted to select all the columns in the
# character vector vars, instead of printing them all out, I can just use one_of(vars) and all will be returned.
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
flights %>% select(one_of(vars))

# 4. Does the result of running the following code surprise you? How do the select helpers deal with case by default? How can 
#    you change that default?
select(flights, contains("TIME"))
# select() looks for columns containing "TIME" in any case, upper or lower. contains() has an argument ignore.case which is 
# set to TRUE by default.  You can change it by specifying it in the call to contains().
flights %>% select(contains("TIME", ignore.case = FALSE))

# mutate() exercises, 'R for Data Science' #############################################################

# 1. Currently dep_time and sched_dep_time are convenient to look at, but hard to compute with because they're not really
#    continuous numbers. Convert them to a more convenient representation of number of minutes since midnight.

dep_time_mins = (dep_time %/% 100 * 60 + dep_time %% 100) %% 1440
sched_dep_time_mins = (sched_dep_time %/% 100 * 60 + sched_dep_time %% 100) %% 1440

# appropriate to create a function to perform this calculation.
time2mins <- function(x) {
  (x %/% 100 * 60 + x %% 100) %% 1440
}

flights %>% transmute(dep_time, 
                      sched_dep_time, 
                      dep_time_mins = time2mins(dep_time), 
                      sched_dep_time_mins = time2mins(sched_dep_time))                     

# 2. Compare air_time with arr_time - dep_time. What do you expect to see? What do you see? What do you need to do to fix it?
flights %>% transmute(air_time, arr_time, dep_time, arr_time - dep_time)
# I would expect air_time and arr_time - dep_time to be equal, but they are not.  arr_time and dep_time need to be changed into
# minutes instead of hour and minutes in one string.

f <- flights %>% transmute(air_time, 
                      arr_time_mins = time2mins(arr_time), 
                      dep_time_mins = time2mins(dep_time), 
                      arr_minus_dep = arr_time_mins - dep_time_mins,
                      air_diff = air_time - arr_minus_dep
)

# 3. Compare dep_time, sched_dep_time, and dep_delay.  How would you expect those three numbers to be related?
flights %>% select(dep_time, sched_dep_time, dep_delay)
# I would expect dep_delay to be the difference of sched_dep_time and dep_time.
f <- flights %>% transmute(dep_time, 
                      sched_dep_time, 
                      dep_time_mins = time2mins(dep_time), 
                      sched_dep_time_mins = time2mins(sched_dep_time),
                      delay_calc = dep_time_mins - sched_dep_time_mins,
                      dep_delay,
                      dep_diff = dep_delay - delay_calc)

f %>% filter(dep_diff != 0, dep_diff != 1440)

# 4. Find the 10 most delayed flights using a ranking function. How do you want to handle ties? Carefully read the 
#    documentation for min_rank().
f <- flights %>% transmute(arr_delay = sort(arr_delay, decreasing = TRUE, na.last = TRUE), 
                      rank = min_rank(desc(sort(arr_delay, decreasing = TRUE, na.last = TRUE))))
                      
f %>% top_n(-10)

# I chose arr_delay to find the most delayed flights, to account for catching up time in-flight, or losing time in-flight.  
# I want to capture ties as the same rank, so I chose min_rank() for the ranking function.  It's necessary to use desc(arr_delay)
# to show the flights with the highest delay value as the lowest ranks.

# 5. What does 1:3 + 1:10 return? Why?
1:3 + 1:10
# [1]  2  4  6  5  7  9  8 10 12 11
# Warning message:
#   In 1:3 + 1:10 :
#   longer object length is not a multiple of shorter object length
# 
# It looks like the addition was accomplished like this:
#   1 2 3 1 2 3 1 2  3  1
# + 1 2 3 4 5 6 7 8  9  10
# = 2 4 6 5 7 9 8 10 12 11
# The smaller vector was repeated over the length of the longer vector.  The warning message exists to show that the smaller
# vector was not applied an equal number of times, because its length is not a divisor of the longer vector's length.

# 6. What trigonometric functions does R provide?
# R provides cos(x), sin(x), tan(x) acos(x), asin(x), atan(x), and atan2(y, x).
# They respectively compute the cosine, sine, tangent, arc-cosine, arc-sine, arc-tangent, and the two-argument arc-tangent.
# cospi(x), sinpi(x), and tanpi(x) compute cos(pi*x), sin(pi*x), and tan(pi*x).

# summarise() exercises, 'R for Data Science' #############################################################

not_cancelled <- flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay))
                      
# 1. Brainstorm at least 5 different ways to assess the typical delay characteristics of a group of flights. Consider
#    the following scenarios:
#    * A flight is 15 minutes early 50% of the time, and 15 minutes late 50% of the time.
#    * A flight is always 10 minutes late.
#    * A flight is 30 minutes early 50% of the time, and 30 minutes late 50% of the time.
#    * 99% of the time a flight is on time. 1% of the time it's 2 hours late.
#    Which is more important: arrival delay or departure delay?

by_flight <- not_cancelled %>% group_by(flight)

# find the most- and least-delayed departures for each flight number:
by_flight %>% 
  mutate(dr = min_rank(desc(dep_delay))) %>%
  filter(dr %in% range(dr)) %>%
  arrange(flight, dr)

# find the mean, meadian, max, and min departure and arrival delays for each flight:

not_cancelled %>% 
  group_by(flight) %>%
  summarise(mean_dep_delay = mean(dep_delay), median_dep_delay = median(dep_delay), max_dep_delay = max(dep_delay), 
            min_dep_delay = min(dep_delay), mean_arr_delay = mean(arr_delay), median_arr_delay = median(arr_delay), 
            max_arr_delay = max(arr_delay), min_arr_delay = min(arr_delay))

# view proportion of flights arriving on time or before scheduled arrival time, grab top 10:

not_cancelled %>%
  group_by(flight) %>%
  # tally(mean(arr_delay <= 0)) %>%   ... can do it this way too
  summarise(prop_arr_on_time = mean(arr_delay <= 0)) %>%
  top_n(10)

# find most-delayed arrival for each flight:

not_cancelled %>%
  group_by(flight) %>%
  top_n(n = 1, wt = arr_delay) %>%
  arrange(flight)

# flights seem to be delayed on departure more on average than delayed on arrival. I would say that departure delay is 
# more important for that reason.

# 2. Come up with another approach that will give you the same output as not_cancelled %>% count(dest) and not_cancelled %>%
#    count(tailnum, wt = distance) (without using count()).

not_cancelled %>% count(dest)
not_cancelled %>% group_by(dest) %>% summarise(n = n())

not_cancelled %>% count(tailnum, wt = distance)
not_cancelled %>% group_by(tailnum) %>% summarise(n = sum(distance))

# 3. Our definition of cancelled flights (is.na(dep_delay) | is.na(arr_delay)) is slightly suboptimal. Why? Which is the
#    most important column?

flights %>% filter(is.na(dep_delay) | is.na(arr_delay))
flights %>% filter(is.na(arr_delay)) %>% summarise(sum(!is.na(dep_delay)))
flights %>% filter(is.na(dep_delay)) %>% summarise(sum(!is.na(arr_delay)))

# It's problematic because some flights without arrival delay times recorded do have departure times and departure delay times.
# The more important field to filter is dep_delay, because all flights with is.na(dep_delay) == TRUE also have NA values for
# arr_delay.

# 4. Look at the number of cancelled flights per day.  Is there a pattern? Is the proportion of cancelled flights related to
#    the average delay?

flights %>% 
  group_by(year, month, day) %>% 
  summarise(num_cancelled = sum(is.na(dep_delay)), avg_dep_delay = mean(dep_delay, na.rm = TRUE), 
            avg_arr_delay = mean(arr_delay, na.rm = TRUE)) %>%
  arrange(num_cancelled)

# There seems to be a connection between number of cancelled flights and average departure and arrival delay times: higher
# numbers of cancelled flights tend to occur on days with higher average departure and arrival delay times.

# 5. Which carrier has the worst delays? Challenge: can you disentangle the effects of bad airports vs. bad carriers? Why/why
#    not? (Hint: think about flights %>% group_by(carrier, dest) %>% summarise(n))

flights %>% 
  group_by(carrier) %>%
  summarise(avg_dep_delay = mean(dep_delay, na.rm = TRUE), avg_arr_delay = mean(arr_delay, na.rm = TRUE)) %>%
  arrange(desc(avg_dep_delay), desc(avg_arr_delay))

# On average, F9 carrier has the worst departure and arrival delays.

flights %>% 
  group_by(carrier, dest) %>% 
  summarise(n) %>%
  filter(carrier == 'F9')

# Carrier F9 only flies into one airport - DEN.  Let's look at average delay by airport:

flights %>%
  group_by(dest) %>%
  summarise(avg_dep_delay = mean(dep_delay, na.rm = TRUE), avg_arr_delay = mean(arr_delay, na.rm = TRUE)) %>%
  arrange(desc(avg_arr_delay)) %>%
  mutate(rank = min_rank(desc(avg_arr_delay))) %>%
  filter(dest == 'DEN')

# Denver airport is the 47th most arrival-delayed flight, having an average departure delay time of 15.2 mins, and an average 
# arrival delay time of 8.61 mins.

flights %>% 
  group_by(carrier) %>%
  summarise(avg_dep_delay = mean(dep_delay, na.rm = TRUE), avg_arr_delay = mean(arr_delay, na.rm = TRUE)) %>%
  arrange(desc(avg_dep_delay), desc(avg_arr_delay)) %>%
  mutate(rank = min_rank(desc(avg_dep_delay))) %>%
  filter(carrier == 'F9')

# F9's average delay times are still higher than the average delay times overall for the DEN destination. However, it's
# likely that some of the high delay times are due to the DEN airport's problems.

# 6. What does the sort argument to count() do? When might you use it?

flights %>%
  group_by(carrier) %>%
  count(dest, sort = TRUE)

# the sort argument to count() orders the counts by decreasing value of n.  This is helpful if you'd like to look at the
# highest counts for a given grouping.

# Grouped mutates (and filters) exercises, 'R for Data Science' ###############################################

# 1. Refer back to the lists of useful mutate and filtering functions. Describe how each operation changes when you combine
#    it with a grouping.

# They operate within each group rather than over the entire tibble.

# 2. Which plane (tailnum) has the worst on-time record?

# 3. What time of day should you fly if you want to avoid delays as much as possible?

# 4. For each destination, compute the total minutes of delay. For each flight, compute the proportion of the total delay
#    for its destination.

# 5. Delays are typically temporally correlated: even once the problem that cause the initial delay has been resolved,
#    later flights are delayed to allow earlier flights to leave. Using lag(), explore how the delay of a flight is related 
#    to the delay of the immediately preceding flight.

# 6. Look at each destination. Can you find flights that are suspiciously fast? (i.e. flights that represent a potential data
#    entry error). Compute the air time a flight relative to the shortest flight to that destination. Which flights were most
#    delayed in the air?

# 7. Find all destinations that are flown by at least two carriers. Use that information to rank the carriers.

# 8. For each plane, count the number of flights before the first delay of greater than 1 hour.

#########################################################################################################
# TIBBLES ###############################################################################################
#########################################################################################################

# Tibbles exercises, 'R for Data Science' ###############################################################

# 1. How can you tell if an object is a tibble? (Hint: try printing mtcars, which is a regular data frame)
print(mtcars)
as.tibble(mtcars)
# A tibble will have the comment "A tibble:" followed by the dimensions of the tibble.  Only the first 10 rows (or however
# many rows are set in option()) will print of a tibble.  Printing a data frame will show all rows. The columns of a tibble
# will have the data type printed underneath, before the values. Additionally, a tibble will not create column names, or 
# coerce columns into a different data type (e.g. strings as factors).

# 2. Compare and contrast the following operations on a data.frame and equivalent tibble. What is different? Why might the 
#    default data frame behaviors cause you frustration?
df <- data.frame(abc = 1, xyz = "a")
tb <- as.tibble(df)
df$x
tb$x
# There is no column "x" in the data, but df$x returns the value for df$xyz. The tibble version does not return a value, 
# which is desirable because there is no column "x" in the tibble.
df[, "xyz"]
class(df[, "xyz"])
tb[, "xyz"]
# df[, "xyz"] returned a factor, whereas tb[, "xyz"] returned another tibble, with the column name and data type of the column
# printed below it, as is standard with tibbles. Tibbles are preferable in this instance because [ returns the same object
# type.
df[, c("abc", "xyz")
class(df[, c("abc", "xyz")])
tb[, c("abc", "xyz")]
# The results of this operation on the data frame and the tibble seem to be the same, however you get more with the tibble,
# as the column data types are returned, as well as the tibble dimensions, and row names are not added as they are with 
# the data frame.

# 3. If you have the name of a variable stored in an object, e.g. var <- "mpg", how can you extract the reference variable
#    from a tibble?
var <- "mpg"
as.tibble(mtcars) %>% select(var)
# The select() function will allow reference to the variable in the tibble.

# 4. Practice referring to non-syntactic names in the following data frame by:
#   1. Extracting the variable called 1.
#   2. Plotting a scatterplot of 1 vs 2.
#   3. Creating a new column called 3 which is 2 divided by 1.
#   4. Renaming the columns to one, two and three.
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)

annoying$`1`
plot(annoying$`1`, annoying$`2`)
annoying <- annoying %>%
  mutate(`3` = `2` / `1`)
annoying <- annoying %>% rename("one" = `1`, "two" = `2`, "three" = `3`)

# 5. What does tibble::enframe() do? When might you use it?
tibble::enframe(1:6)
# This might be useful if you want to create observations and corresponding values from a list of both stored in atomic
# vectors.  For example, if you had a vector of patient names:
patients <- c("Martha", "Tim", "Maggie", "Anthony", "Paula", "Sam")
# you could create a tibble with their names and auto-generated unique IDs using:
tibble::enframe(patients, name = "ID", value = "patient_name")

# 6. What option controls how many additional column names are printed at the footer of a tibble?
tibble.max_extra_cols

#########################################################################################################
# TIDY DATA #############################################################################################
#########################################################################################################

# Tidy Data exercises, 'R for Data Science' #############################################################

# 1. Using prose, describe how the variables and observations are organised in each of the sample tables.
# table1 has the data in a tidy representation.  Every variable has its own column, every observation has its own row,
# and every value has its own cell. table 2 collapses two variables, cases and population, into one column, called type.
# the count column contains the corresponding values for either population or cases held in the type variable. Additionally,
# every observation does not have its own row - there are two rows for Afghanistan in 1999, for example; one for cases, and 
# one for population. table3 collapses two values, cases and population, into one cell, called rate.  This is against the tidy
# data rules. table4 does not have columns for cases or population -instead, they are broken into two separate tibbles.

# 2. Compute the rate for table2, and table4a + table4b. You will need to perform four operations:
#  1. Extract the number of TB cases per country per year.
#  2. Extract the matching population per country per year.
#  3. Divide cases by population, and multiply by 10000.
#  4. Store back in the appropriate place.
#    Which representation is easiest to work with? Which is hardest? Why?
# table 2: Need to break up into two tibbles, one for cases and one for population.  Then recombine into a new
# tibble with columns for cases and population, and then calculate a column for rate.
t2.cases <- table2 %>% 
  filter(type == "cases") %>%
  rename(cases = count) %>%
  arrange(country, year)

t2.pops <- table2 %>% 
  filter(type == "population") %>%
  rename(population = count) %>%
  arrange(country, year)

t2.rate <- tibble(
  country = t2.cases$country,
  year = t2.cases$year,
  cases = t2.cases$cases,
  population = t2.pops$population
) %>%
  mutate(rate = cases / population * 10000)

# table 4a & 4b: Need to add the 1999 & 2000 population data to the cases tibble, and rename the columns.  Then calculate
# rates for 1999 and 2000.

t4a_1999 <- table4a %>%
  transmute(country = country, year = 1999, cases = `1999`)

t4a_2000 <- table4a %>%
  transmute(country = country, year = 2000, cases = `2000`)

t4a <- as.tibble(rbind(t4a_1999, t4a_2000))

t4b_1999 <- table4b %>%
  transmute(country = country, year = 1999, population = `1999`)

t4b_2000 <- table4b %>%
  transmute(country = country, year = 2000, population = `2000`)

t4b <- as.tibble(rbind(t4b_1999, t4b_2000))

t4.rate <- tibble(
  country = t4a$country,
  year = t4a$year,
  cases = t4a$cases,
  population = t4b$population,
  rate = cases / population * 10000)
 
t4.rate %>% arrange(country, year)

# I found table2 easier to work with than table4a and table4b.  The fact that table4a and table4b has one variable (year) 
# broken up into two columns (1999 and 2000), and the columns are values themselves, with the values of counts in those
# columns, makes wrangling the data more complicated and require more steps to accomplish the goal.

# 3. Recreate the plot showing change in cases over time using table2 instead of table1. What do you need to do first?
library(ggplot2)
ggplot(table1, aes(year, cases)) + 
  geom_line(aes(group = country), colour = "grey50") + 
  geom_point(aes(colour = country))

# to use table2 in the same plot used for table1, we'll need to expand table2 to have two columns for counts, one for cases
# and one for population.
t2.cases <- table2 %>%
  filter(type == "cases") %>%
  select(country, year, cases = count)

t2.pop <- table2 %>%
  filter(type == "population") %>%
  select(country, year, population = count)

t2 <- tibble(
  country = t2.cases$country,
  year = t2.cases$year,
  cases = t2.cases$cases,
  population = t2.pop$population)
)

ggplot(t2, aes(year, cases)) + 
  geom_line(aes(group = country), colour = "grey50") + 
  geom_point(aes(colour = country))

# Spreading and Gathering exercises, 'R for Data Science' #################################################

# 1. Why are gather() and spread() not perfectly symmetrical? Carefully consider the following example:
stocks <- tibble(
  year = c(2015, 2015, 2016, 2016),
  half = c(1, 2, 1, 2),
  return = c(1.88, 0.59, 0.92, 0.17)
)

stocks %>%
  spread(year, return) %>%
  gather("year", "return", `2015`:`2016`)

# (Hint: look at the variable types and think about column names.)
# Both spread() and gather() have a convert argument.  What does it do?

# The functions spread() and gather() are not perfectly symmetrical because column type information is lost.
# When we use gather() on a tibble, it discards the original column types. It has to coerce all the gathered
# variables into a single vector with a single type. Later, if we spread() that data frame, the spread() function
# does not know the original data types of the variables. In this example, the values in variable "year" are spread
# into columns.  When it's gathered, it isn't clear that the year variable is a number, because the values became
# column NAMES.  Hence they are coerced into characters.
stocks %>%
  spread(year, return) %>%
  gather("year", "return", `2015`:`2016`, convert = TRUE)
# the convert argument will call type.convert() on the key column, in this case, "year". type.convert() converts a character
# vector to a logical, integer, numeric, complex or factor as appropriate.  When added to gather(), it returns the year 
# column as type int.

# 2. Why does this code fail?
table4a %>%
  gather(1999, 2000, key = "year", value = "cases")
# this code fails because it refers to number columns without tick marks.
table4a %>%
  gather(`1999`, `2000`, key = "year", value = "cases")
# this code works

# 3. Why does spreading this tibble fail? How could you add a new column to fix the problem?
people <- tribble(
  ~name,             ~key,     ~value,
  #-----------------|----------|------
  "Phillip Woods",   "age",     45,
  "Phillip Woods",   "height",  186,
  "Phillip Woods",   "age",     50,
  "Jessica Cordero", "age",     37,
  "Jessica Cordero",  "height", 156
)

people %>%
  spread("key", "value")
# it fails because there are two values for one observation: Phillip Wood's age. We could add another column,
# say "obs", to differentiate between the two observations of age.
people <- tribble(
  ~name,             ~key,     ~value,
  #-----------------|----------|------
  "Phillip Woods",   "age",     45,
  "Phillip Woods",   "height",  186,
  "Phillip Woods",   "age",     50,
  "Jessica Cordero", "age",     37,
  "Jessica Cordero",  "height", 156
)

people2 <- people %>%
  group_by(name, key) %>%
  mutate(obs = row_number())

# we can spread people2 because the combination of name and obs will uniquely identify the spread rows.
people2 %>%
  spread("key", "value")

# Tidy the simple tibble below. Do you need to spread or gather it? What are the variables?
preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",      NA,    10, 
  "no",       20,    12
)

# We need to gather the data in preg.  The variables are:
# sex: "male", "female"
# pregnant: "yes", "no"
# count: number of people corresponding to the observation
preg %>%
  gather(male, female, key = "sex", value = "count")

# Separating and Uniting exercises, 'R for Data Science' #################################################

# 1. What do the extra and fill arguments do in separate()? Experiment with the various options for the following
#    two toy datasets.
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>%
  separate(x, c("one", "two", "three"))
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>%
  separate(x, c("one", "two", "three"), extra = "drop")
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>%
  separate(x, c("one", "two", "three"), extra = "merge")
# extra controls what to do when there are two many pieces in on group to separate.  The default is to emit a warning
# and drop extra values.  The other options are "drop", which will drop extra values without a warning, and "merge",
# which only splits at most length(into) times.

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>%
  separate(x, c("one", "two", "three"))
tibble(x = c("a,b,c", "d,e", "f,g,i")) %>%
  separate(x, c("one", "two", "three"), fill = "right")
tibble(x = c("a,b,c", "d,e", "f,g,i")) %>%
  separate(x, c("one", "two", "three"), fill = "left")
# fill controls what is done when there are too few pieces to separate in one of the groups.  The default, "warn", emits
# a warning and fills from the right. "right" fills with missing values (NA) on the right, and "left" fills with NA on the
# left.

# 2. Both unite() and separate() have a remove argument.  What does it do? Why would you set it to FALSE?
tibble(x = c("a,b,c", "d,e", "f,g,i")) %>%
  separate(x, c("one", "two", "three"), remove = FALSE)
# remove is set to TRUE by default, and it will remove the input columns from the output data frame.  If we set it to FALSE,
# the original, unseparated (or un-united) columns will be included in the data frame with the separated (or united) columns.

# 3. Compare and contrast separate() and extract(). Why are there three variations of separation (by position, by separator,
#    and with groups), but only one unite?
df <- data.frame(x = c(NA, "a-b", "a-d", "b-c", "d-e"))
df %>% extract(x, "A")
# The function separate() splits a column into multiple columns by separator, if the sep argument is a character vector,
# or by positions, if sep is numeric. Example with character vector:

tibble(x = c("X_1", "X_2", "Y_1", "Y_2")) %>%
  separate(x, c("variable", "into"), sep = "_")

# Example with numeric column position:
tibble(x = c("X1", "X2", "Y1", "Y2")) %>%
  separate(x, c("variable", "into"), sep = c(1))

# The function extract() uses a regular expression to specify groups in character vector and split that single character
# vector into multiple columns.  This is more flexible than separate() because it does not require a common separator or 
# specific column positions. Both separate() and extract() convert a single column into multiple columns. However, unite()
# converts many columns into one, with a choice of a separator to include between column values.  With extract() and 
# separate() only one column can be chosen, but it can be split in a variety of different ways. With unite(), there are a 
# variety of choices of columns to include, but only one choice of how to combine their contents into a single vector - 
# a separator. 

# Missing values exercises, 'R for Data Science' #####################################################

# 1. Compare and contrast the fill arguments to spread() and complete().
# The fill argument in spread will replace missing values with the fill value.  Both types of missing values will be 
# replaced with the fill value - explicit (NA) and implicit (rows that simply aren't present) missing values.
# The fill argument in complete takes a list that for each variable supplies a single value to use instead of NA for
# missing combinations.  It will do this for both implicit missing values and existing explicit missing values.

# 2. What does the direction argument to fill() do?
# The direction argument to fill states which direction to fill missing values, currently either "down" (default) or "up".

# Case study exercises, 'R for Data Science' #########################################################

# 1. In this case study I set na.rm = TRUE just to make it easier to check that we had the correct values. Is this 
#    reasonable? Think about how missing values are represented in this dataset. Are there implicit missing values?
#    What's the difference between an NA and a zero?
who %>% filter(is.na(new_sn_m014) == FALSE)

who2 <- who %>%
  gather(new_sp_m014:newrel_f65, key = "key", value = "cases", na.rm = FALSE)

who2 %>% 
  group_by(key) %>% 
  count(is.na(cases) == FALSE)

who3 <- who %>%
  gather(key, value, new_sp_m014:newrel_f65, na.rm = FALSE) %>%
  mutate(key = stringr::str_replace(key, "newrel", "new_rel")) %>%
  separate(key, c("new", "var", "sexage")) %>%
  select(-new, -iso2, -iso3) %>%
  separate(sexage, c("sex", "age"), sep = 1)

who3 %>% group_by(year, var) %>% summarise(sum(is.na(value)))
# The difference between an NA and a zero is that an NA is an unknown value, whereas zero is a known value - it's equal to 
# zero. NA could be equal to zero or any other value, we just don't know it.  It looks like some of the sp cases were recorded  
# in later years in the study, more than the early years, where each case type (sn, sp, ep, rel) had similar counts of missing
# values.  
who3 %>% filter(var == "sp") %>% group_by(year, sex, age) %>% summarise(sum(is.na(value)))
who3 %>% filter(var == "sp") %>% group_by(year, sex, age) %>% summarise(sum(is.na(value)))

# 2. What happens if you neglect the mutate() step? (mutate(key = stringr::str_replace(key, "newrel", "new_rel"))
who4 <- who %>%
  gather(key, value, new_sp_m014:newrel_f65, na.rm = FALSE) %>%
#  mutate(key = stringr::str_replace(key, "newrel", "new_rel")) %>%
  separate(key, c("new", "var", "sexage")) %>%
  select(-new, -iso2, -iso3) %>%
  separate(sexage, c("sex", "age"), sep = 1)
# There is an error message for the key values that lack 3 pieces, namely, the key values that start with "newrel" instead of
# "new_rel".  The separate function can't accomplish its operation of separating the key value into three separate pieces,
# labeled "new", "var", and "sexage", and it replaces the last key value, sexage, with NAs.
who %>%
  gather(key, value, new_sp_m014:newrel_f65, na.rm = FALSE) %>%
  #  mutate(key = stringr::str_replace(key, "newrel", "new_rel")) %>%
  separate(key, c("new", "var", "sexage")) %>%
  select(-iso2, -iso3) %>%
  filter(is.na(sexage))

# 3. I claimed that iso2 and iso3 were redundant with country. Confirm this claim.
who %>%
  select(country, iso2, iso3) %>%
  complete(country, iso2, iso3) %>%
#  group_by(country, iso2) %>%
  summarise(country_NA = sum(is.na(country)), is02_NA = sum(is.na(iso2)), iso3_NA = sum(is.na(iso3)))
# when completing the unique combinations of values of country, iso2, and iso3, there are no added NA values, as evidenced
# by summing the values of is.na() for each variable after calling complete() on all 3 variables.

# 4. For each country, year, and sex, compute the total number of cases of TB. Make an informative visualization of the data.
w <- who %>% 
  gather(key, value, new_sp_m014:newrel_f65, na.rm = TRUE) %>%
  mutate(key = stringr::str_replace(key, "newrel", "new_rel")) %>%
  separate(key, c("new", "var", "sexage")) %>%
  select(-new, -iso2, -iso3) %>%
  separate(sexage, c("sex", "age"), sep = 1)

w %>% 
  group_by(country, year, sex) %>%
  summarise(cases = sum(value))

#########################################################################################################
# RELATIONAL DATA #######################################################################################
#########################################################################################################

# nycflights13 exercises, 'R for Data Science' ##########################################################

# 1. Imagine you wanted to draw (approximately) the route each plane flies from its origin to its destination.
#    What variables would you need? What tables would you need to combine?
# You would need the airport code and geographical information from airports: faa, late, lon, alt.
# You'd also need the flight info from flights: flight, tailnum, origin, dest
# You would need to combine flights, airports, and possibly planes, if you wanted more info on each plane.

# 2. I forgot to draw the relationship between weather and airports. What is the relationship and how should it appear
#    in the diagram?
# The origin variable in weather is a foreign key to the faa variable in airports.

# 3. weather only contains information for the origin (NYC) airports. If it contained weather records for all airports 
#    in the USA, what additional relation would it define with flights?
# If weather contained weather records for all airports in the US, then (year, month, day, hour, origin) in weather are 
# a foreign key to flights columns (year, month, day, hour, dest).  Without records in weather for every combination of 
# (year, month, day, hour, dest) in flights, the fields (year, month, day, hour, origin) are not a foreign key to 
# flights, because many unique combinations of these variables in flights do not exist in weather.

# 4. We know that some days of the year are "special", and fewer people than usual fly on them.  How might you
#    represent that data as a data frame? What would be the primary keys of that table? How would it connect
#    to the existing tables?
# You might have a table with variables for month, day, type, and name. The primary keys would be month and day.
# This new table, call it holidays, would connect to weather and flights on (month, day).

# Keys exercises, 'R for Data Science' ##################################################################

# 1. Add a surrogate key to flights.
flights %>%
  mutate(ID = row_number()) %>%
  select(ID, everything())

# 2. Identify the keys in the following datasets:
#  1. Lahman::Batting
#  2. babynames::babynames
#  3. nasaweather::atmos
#  4. fueleconomy::vehicles
#  5. ggplot2::diamonds
# (You might need to install some packages and read some documentation)

# 2.1 
install.packages("Lahman")
Lahman::Batting
bat <- Lahman::Batting 
bat <- as.tibble(bat)

bat %>% 
  count(playerID, yearID, stint, teamID) %>%
  filter(n > 1)
# The key to Lahman::Batting is (playerID, yearID, stint, teamID).

# 2.2
install.packages("babynames")
names <- babynames::babynames
names <- as.tibble(names)

names %>%
  rename(num = n) %>%
  count(year, sex, name) %>%
  filter(n > 1)
# The key to babynames::babynames is (year, sex, name).

# 2.3 
install.packages("nasaweather")
atmos <- nasaweather::atmos
atmos <- as.tibble(atmos)

atmos %>% 
  count(lat, long, year, month) %>%
  filter(n > 1)
# The key to atmos is (lat, long, year, month).

# 2.4
install.packages("fueleconomy")
vehicles <- fueleconomy::vehicles
vehicles <- as.tibble(vehicles)

vehicles %>%
  count(id) %>%
  filter(n > 1)
# The key to vehicles is id.

# 2.5
diamonds <- ggplot2::diamonds

diamonds %>%
  count(carat, cut, color, clarity, depth, table, price, x, y, z) %>%
  filter(n > 1)
# There is no key to the diamonds table.

# 3. Draw a diagram illustrating the connections between the Batting, Master, and Salaries tables in the Lahman package.
#    Draw another diagram that shows the relationship between Master, Managers, and AwardsManagers. How would you characterise
#    the relationship between the Batting, Pitching, and Fielding tables?
# Batting and Master are connected through playerID. Salaries is connected to Master through playerID, and to Batting through
# yearID, teamID, lgID, and playerID.  Master, Manager, and AwardsManagers are connected through playerID, as Managers and
# AwardsManagers are composed of players from Master. Battig, Pitching, and Fielding are stats related to each player's 
# performance at bat, as a pitcher (if applicable), and in the field (if applicable). A player who is not a pitcher will
# almost always exist in the Batting and Fielding tables, however Pitchers do not bat, so they will likely only exist in the
# Pitching table.

# Mutating joins exercises, 'R for Data Science' ###################################################

# 1. Compute the average delay by destination, then join on the airports data frame so you can show the spatial distribution
#    of delays. Here's an easy way to draw a map of the United States:
airports %>%
  semi_join(flights, c("faa" = "dest")) %>%
  ggplot(aes(lon, lat)) + 
    borders("state") +
    geom_point() +
    coord_quickmap()
#    (Don't worry if you don't understand what semi_join() does--you'll learn about it next.)
#    You might want to use the size or colour of the points to display the average delay for each airport.
flights %>%
  group_by(dest) %>%
  summarise(avg_delay = mean(arr_delay)) %>%
  left_join(airports, c("dest" = "faa"))

# 2. Add the location of the origin *and* destination (i.e. the lat and lon) to flights.
flights %>%
  left_join(airports, by = c("dest" = "faa")) %>%
  select(-name, -alt, -tz, -dst, -tzone) %>%
  rename(dest_lat = lat, dest_lon = lon) %>%
  left_join(airports, by = c("origin" = "faa")) %>%
  select(-name, -alt, -tz, -dst, -tzone) %>%
  rename(origin_lat = lat, origin_lon = lon)

# 3. Is there a relationship between the age of a plane and its delays?
flights %>%
  group_by(tailnum) %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE)) %>%
  left_join(planes, by = "tailnum") %>%
  arrange(year)

# 4. What weather conditions make it more likely to see a delay?
flights %>%
  left_join(weather, by = c("origin", "time_hour"))

# 5. What happened on June 13 2013? Display the spatial pattern of delays, and then use Google to cross-reference
#    with the weather.
flights %>%
  left_join(weather, by = c("origin", "time_hour")) %>%
  select(-year.y, -month.y, -day.y, -hour.y) %>%
  rename(year = year.x, month = month.x, day = day.x, hour = hour.x) %>%
  filter(year == 2013, month == 6, day == 13) %>%
  group_by(origin) %>%
  summarise(avg_delay = mean(dep_delay, na.rm = TRUE))
# There was a derecho, a type of severe storm, on June 12-13 2013 in the Eastern U.S.

# Filtering joins exercises, 'R for Data Science' #####################################################

# 1. What does it mean for a flight to have a missing tailnum? What do the tail numbers that don't have a matching
#    record in planes have in common? (Hint: one variable explains ~90% of the problems).
flights %>%
  anti_join(planes, by = "tailnum") %>%
  count(carrier, sort = TRUE)
# Almost all of the flights without matching records in planes for their tail numbers are from American Airlines
# and Envoy Airlines.  These airlines do not report tail numbers.

# 2. Filter flights to only show flights with planes that have flown at least 100 flights.
flts_100  <- flights %>%
  group_by(tailnum) %>%
  count() %>%
  filter(n >= 100)

semi_join(flights, flts_100, by = "tailnum")

# 3. Combine fueleconomy::vehicles and fueleconomy::common to find only the records for the most common models.
fv <- fueleconomy::vehicles
fc <- fueleconomy::common

fv %>%
  semi_join(fc, by = c("make", "model"))

# 4. Find the 48 hours (over the course of the whole year) that have the worst delays. Cross-reference it with the
#    weather data. Can you see any patterns?
worst_hours <- flights %>%
  mutate(hour = sched_dep_time %/% 100) %>%
  group_by(origin, year, month, day, hour) %>%
  summarise(dep_delay = mean(dep_delay, na.rm = TRUE)) %>%
  ungroup() %>%
  arrange(desc(dep_delay)) %>%
  slice(1:48)

weather_most_delayed <- semi_join(weather, worst_hours, 
  by = c("origin", 
         "year", 
         "month", 
         "day", 
         "hour"
         )
  )

select(weather_most_delayed, temp, wind_speed, precip) %>%
  print(n = 48)

# 5. What does anti_join(flights, airports, by = c("dest" = "faa")) tell you? What does  
#    anti_join(airports, flights, by = c("faa", "dest")) tell you?

x <- anti_join(flights, airports, by = c("dest" = "faa"))
y <- anti_join(airports, flights, by = c("faa", "dest"))   
# x tells me which flights are going to destinations not listed in the FAA list. Since the FAA list contains 
# only domestic airports, these are likely international flights. y tells me which airports are not a destination
# in any of the flights listed in flights. These would be flights that do not have a direct flight from New York
# City in 2013.

# 6. You might expect that there's an implicit relationship between plane and airline, because each plane is flown
#    by a single airline. Confirm or reject this hypothesis using the tools you've learned above.
carrier_planes <- flights %>% 
  filter(!is.na(tailnum)) %>%
  distinct(tailnum, carrier)
# The number of planes that have flown for more than one airline are those tailnum that appear more than once
# in the carrier_planes data.
carrier_planes %>% 
  group_by(tailnum) %>%
  filter(n() > 1) %>%
  left_join(airlines, by = "carrier") %>%
  arrange(tailnum, carrier) 
# There are 2 carriers each for the planes that are flown by more than one airline. tailnum N978AT
# is flown by AirTran Airways Corp. and Delta Air Lines. tailnums N146PQ, N153PQ, N176PQ, N181PQ, N197PQ,
# N200PQ, N228PQ, and N232PQ are all flown by both ExpressJet Airlines and Endeavor Air. My guess is that 
# AirTran is owned by Delta, and ExpressJet is owned by Endeavor.

#######################################################################################################
# STRINGS #############################################################################################
#######################################################################################################

install.packages("stringr")
library(stringr)

# String Basics exercises, 'R for Data Science' #######################################################

# 1. In code that doesn't use stringr, you'll often see paste() and paste0().  What's the difference between
#    the two functions?  What stringr function are they equivalent to?  How do the functions differ in their
#    handling of NA?
# 
# paste() converts its arguments (via as.character) to character strings, and concatenates them, separating them
# by the string given in sep.  paste() coerces NAs to "NA".  paste0() is equivalent to paste(..., sep = "", collapse).
# If a value is specified for collapse, the results are concatenated into a single string with the elements separated
# by the value specified for collapse.
# The stringr function equivalent to paste() is str_c().  The stringr function equivalent to paste0() is 
# str_c(..., collapse).  Instead of being changed into characters, str_c() keeps NAs as missing values.  Whenever
# a missing value (NA) is combined with another string, the result will always be missing (NA).

# 2. In your own words, describe the difference between the sep and collapse arguments to str_c().

# The sep argument takes string elements, which could be strings or vectors of strings, and concatenates them using
# the value specified by sep.  Vectors of strings are preserved as separate strings.  collapse concatenates the string 
# values in a vector of strings together, using the value specified by collapse, into a single string.  Look at the
# following example:

x <- c("x", "y", "z")  # example vector of strings
str_c("w", x, sep = "")  # first using sep = "" 
# "wx" "wy" "wz"  # the "w" is distributed to each string in the vector of strings (x), separated by "" as specified
str_c("w", x, collapse = "")  # now using collapse = "" 
# "wxwywz"  # the "w" is still distributed to each string in the vector x, but now it's collapsed into a single
# string, using "" as the separator, specified by collapse.

# 3. Use str_length() and str_sub() to extract the middle character from a string.  What will you do if the string
#    has an even number of characters?

# My name (Morgan) has an even number of characters, but my sister's (Molly) has an odd number.  I will use strings of 
# both our names to do this exercise. I would like "" to be returned if a string has an even number of characters, and
# obviously I'd like the middle character to be returned if a string has an odd number of characters.  This can be 
# accomplished by adding 1 to the str_length() of a string, dividing by 2, and using ceiling() and floor() as the start
# and end arguments to str_sub.  If a string has an odd number of characters, like the 5 characters in my sister's name,
# then adding 1 to the str_length and dividing by 2 will yeild an integer that is the middle character position of the string.  
# 5 + 1 = 6, 6 / 2 = 3, and calling str_sub("Molly", start = 3, end = 3) will return "l" as we wish.  If a string has an 
# even number of characters, like the 6 in my name, adding 1 to the str_length and dividing by 0 will yield a fraction.
# In the case of my name, 6 + 1 = 7, and 7 / 2 = 3.5. ceiling(3.5) = 4, and floor(3.5) = 3.  Calling str_sub("Morgan", 
# start = 4, end = 3) will return the empty string, "", as desired.  This logic will work for characters of any integer
# length.

find.sub.string <- function(string) {
  str_sub(string, 
          start = ceiling((str_length(string) + 1) / 2), 
          end = floor((str_length(string) + 1) / 2))
}

find.sub.string("Molly")
find.sub.string("Morgan")
  
