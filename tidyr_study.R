####################################################################
# Title: R for Data Science Exercises
# File name: tidyr_study.R
# Author: Morgan Thompson
# Date: January 4, 2023
# Description: Exercises from 'R for Data Science' by Hadley Wickham and Garrett Grolemund
###################################################################

###################################################################
# 1. INTRODUCTION #################################################
###################################################################

install.packages("tidyverse")
install.packages(c("nycflights13", "gapminder", "Lahman"))

###################################################################
# 3. DATA VISUALIZATION ###########################################
###################################################################

library(tidyverse)

# 3.2.4 Exercises #################################################

# 1.
ggplot(data = mpg) # creates a blank graph

# 2.
nrow(mpg)  # 234 rows
ncol(mpg)  # 11 columns

# 3.
?mpg
# The drv variable describes the type of drive train, where f = front wheel drive, 
# r = rear wheel drive, and 4 = 4 wheel drive.

# 4.
ggplot(data = mpg) + geom_point(mapping = aes(x = hwy, y = cyl))

# 5.
ggplot(data = mpg) + geom_point(mapping = aes(x = class, y = drv))
# This graph is not useful because both variables are categorical,
# so we can't visualize the number of observations at each point
# in a scatter plot.

# 3.3.1 Exercises #################################################

# 1.
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))
# Because "blue" was mapped to the color argument within aes(),
# ggplot will try to scale the variable "blue" to levels of colors,
# but because "blue" is the name of a color and not a variable, only
# one color will be displayed in the plot. In order to make all the
# points blue, run this code instead:
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

# 2.
?mpg
# categorical vars: manufacturer, model, trans, drv, fl, class
# continuous vars: displ, year, cyl, cty, hwy
mpg
# the data types are printed in italics below the variables in the
# mpg tibble

# 3.
ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy, color = cty))
# when mapped to color, a continuous variable has an ombre color
# scheme instead of distinct colors

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = year))
# when mapped to size, ggplot will create artificial breaks within a
# continuous variable in order to scale it

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = cyl))
# when mapped to shape, ggplot throws and error message saying
# that a continuous variable cannot be mapped to the shape aesthetic,
# and to choose a different aesthetic or apply the scale_shape_binned() 
# function

# 4.
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = class, color = class))
# when a variable maps to multiple aesthetics, all of those aesthetics are
# applied to the plot

# 5.
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy),
              shape = 23,
              stroke = 1,
              size = 4,
              color = "green",
              fill = "pink")
# shapes 21-24 have a "stroke" aesthetic which is the size in mm of the 
# border of the point

# 6.
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = displ < 5))
# the variable is treated as a logical data type, and the aesthetic
# mapped to TRUE or FALSE values

# 3.5.1 Exercises #################################################

# 1.
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ cty, nrow = 2)
# integer variables facet similarly to discrete variables - plots
# are faceted on each integer value
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ displ, nrow = 2)
# a variable of type double, such as displ, is treated similarly but
# faceted on the values in the tenth decimal place

# 2.
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl))
# the empty cells in the plot with facet_grid(drv ~ cyl) represent the
# lack of data for cars with a certain value for drv and cyl. For example,
# there are no cars in the mpg dataset with drv = r and cyl = 4 or 5,
# and there are no cars with drv = 5 and cyl = 5. Additionally, there are
# no cars with cyl = 7 in the entire mpg data set. The facet with cyl = 7
# doesn't show up on the facet grid plot, but it does exist in the plot
# with aex(x = drv, y = cyl) because cyl is an integer data type and R tries
# to scale it as such.

# 3.
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)
# the . omits the facet in whichever dimension it is placed in the call
# to facet_grid(). In the first plot with facet_grid(drv ~ .), the columns
# dimension is not faceted, and in the second plot with facet_grid(. ~ drv),
# the rows dimension is not faceted.

# 4.
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
# comparing the first plot (which is faceted) to the second (which uses
# the color aesthetic), it is easier to visualize the variables within
# each level of class. Using the color aesthetic, it's easier to visualize
# the levels of class within the variables in the overall distribution of
# the variables. If we wanted to visualize the distribution of the variables
# in each level of class, it's better to use the faceted plot. However, if
# we would rather visualize how class varies within the variables in their
# greater distribution, it is better to use the color (or other applicable)
# aesthetic. In a larger data set, faceting might be a better choice because
# the increased amount of points in the overall plot may make the scaled
# aesthetic more difficult to visualize.

# 5.
?facet_wrap
# nrow and ncol allow us to specify a desired number of rows and columns,
# respectively. dir allows us to specify either "h" for horizontal wrapping,
# or "v" for vertical (the default). as.table either displays the facets like
# a table with highest values at the bottom right if TRUE (the default), or
# like a plot with highest values at the top right if FALSE. facet_grid()
# doesn't have nrow and ncol arguments because it forms a matrix of panels
# defined by row and column faceting variables. If a row or column variable
# is omitted using . in the call to facet_grid(), the plot is simply not split 
# on the omitted dimension (row or column).

# 6.
levels(as.factor(mpg$class))
levels(as.factor(mpg$fl))
# there are more unique levels in class than fl in mpg dataset
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(class ~ fl)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(fl ~ class)
# if the plot is laid out landscape style (horizontally), there is more space
# for columns, so it's better to put the variable with more unique levels
# in the column space.

# 3.6.1 Exercises #################################################

# 1.
# line chart:
ggplot(data = mpg) +
  geom_line(mapping = aes(x = displ, y = hwy))
# boxplot:
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = drv, y = displ))
# histogram:
ggplot(data = mpg) +
  geom_histogram(mapping = aes(x = displ))
# area chart:
ggplot(data = mpg) +
  geom_area(mapping = aes(x = displ, y = hwy))

# 2.
# prediction: this will be a scatterplot of displ against hwy, on the x and y axes
# respectively, plus a smoothed line of this variable without the shaded area 
# that signifies the confidence interval. The scatterplot points will be different
# colors based on the values of drv for each observation, and there will be three
# different smoothed lines of displ x hwy, each a different color for each grouping 
# of drv. The plot will also have a legend for the colors corresponding to each 
# value of drv.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)

# 3.
# show.legend = FALSE removes the legend from a plot that has a legend by default.
# I think Hadley used it earlier in the chapter so that the plot would match the 
# style of the plot that used group, which does not default to showing a legend.

# 4.
?geom_smooth
# The se argument to geom_smooth accepts a logical value (TRUE or FALSE) as to 
# whether to display a confidence interval around the smooth line. It is TRUE
# by default. If TRUE, we can specify the level of confidence interval using the
# level argument. level is set to 0.95 by default. The confidence intervals set
# by se are displayed as a shaded area around the smooth line in the plot.

# 5.
# No, they will not look different. In the first plot, the mapping is set in 
# ggplot() which makes these values global for both geoms. In the second plot,
# the mappings are identical for both geoms, and they match the global mappings
# set in ggplot() in the first plot, so even though they are locally set in the
# geom functions, the result will be the same.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot() + 
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))

# 6.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(size = 3) +
  geom_smooth(se = FALSE, size = 1.5)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(size = 3) +
  geom_smooth(mapping = aes(group = drv), se = FALSE, size = 1.5)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_point(size = 3) +
  geom_smooth(se = FALSE, size = 1.5)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = drv), size = 3) +
  geom_smooth(se = FALSE, size = 1.5)
  
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = drv), size = 3) +
  geom_smooth(mapping = aes(linetype = drv), se = FALSE, size = 1.5)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(size = 5, color = "white") +
  geom_point(mapping = aes(color = drv))

# 3.7.1 Exercises #################################################

# 1.
?stat_summary
# the default geom of stat_summary() is geom_pointrange().
ggplot(data = diamonds) +
  geom_pointrange(
    mapping = aes(x = cut, y = depth),
    stat = "summary",
    fun.min = min,
    fun.max = max,
    fun = median
  )
  
# 2.
?geom_col
?geom_bar
# geom_col() is a bar chart with the height of the bars representing values in 
# the data. geom_bar() makes the height of the bars proportional to the number 
# of cases in each group.

# 3.
# geom_bar() <--> stat_count()
# geom__bin2d() <--> stat_bin_2d()
# geom_boxplot() <--> stat_boxplot()
# geom_contour_filled() <--> stat_contour_filled()
# geom_contour() <--> stat_contour()
# geom_count() <--> stat_sum()
# geom_density_2d() <--> stat_density_2d()
# geom_density() <--> stat_density()
# geom_dotplot() <--> stat_bindot()
# geom_function() <--> stat_function()
# geom_sf() <--> stat_sf()
# geom_smooth() <--> stat_smooth()
# geom_violin() <--> stat_ydensity()
# geom_hex() <--> stat_bin_hex()
# geom_qq_line() <--> stat_qq_line()
# geom_qq() <--> stat_qq()
# geom_quantile() <--> stat_quantile()
# these pairs tend to have the suffix names in common, and be documented on
# the same help pages. They also tend to be defaults for each other's geom or
# stat, respectively.

# 4.
?stat_smooth
# stat_smooth() calculates the predicted value (y), the lower limit of the
# confidence interval (ymin), the upper limit of the confidence interval (ymax),
# and the standard error (se). The parameters controlling the behavior of
# stat_smooth are method (smoothing method i.e. function to use, accepts NULL
# or character vector e.g. "lm", "glm" etc. or a function e.g. stats::loess),
# formula (smoothing formula to use in a custom method argument), se (TRUE to
# display confidence interval bands, FALSE to omit them), na.rm (TRUE to remove
# missing values silently, FALSE to remove missing values with a warning), and 
# method.arg() (arguments other than formula to pass into the function in method).

# 5.
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = after_stat(prop)))

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = color, y = after_stat(prop)))
# these plots calculate the proportions *within* each group, so the heights
# of the bars are all equal to 1.

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = after_stat(prop), group = 1))

# to recreate the stacked bar chart with filled colors, we need to create the
# proportions of diamond colors (fill) within each diamond cut (bar).
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = after_stat(count) / sum(after_stat(count)),
                         fill = color))
        
# 3.8.1 Exercises #################################################

# 1.
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point()
# this plot would benefit from jittering the points, as multiple points are "hiding"
# behind others in the same location on the plot.
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point(position = "jitter")
# the jittered points help reveal where more of the variables are concentrated in
# the plot and better shows the overall distribution.

# 2.
?geom_jitter
# width and height parameters control the amount of horizontal and vertical jitter,
# respectively. The value is added to both sides of the point, so the total spread
# is double the value specified in width and/or height.

# 3.
?geom_count
# geom_count() is a variant of geom_point() that counts the number of observations
# at each location, then maps the count to the point area. This is similar to 
# geom_jitter in that both plots are useful for visualizing discrete data that runs
# the risk of overplotting. They differ in the way they treat visualizing the over-
# plotted points.
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter()
# the points are "jittered" so they don't all stack up on top of each other in discrete
# locations on the plot, helping to show more individual points and their concentration
# on the plot.
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_count()
# geom_count() shows the concentration of points at each plot location via the area of
# the point. The larger circles indicate more points concentrated at that location, so
# that we can visualize the amount of points with a certain value without losing
# the accuracy of the value itself.

# 4.
?geom_boxplot
# the default position of geom_boxplot is "dodge2".
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = class, y = hwy, fill = class))
        
# 3.9.1 Exercises #################################################

# 1.
ggplot(data = diamonds, mapping = aes(x = factor(1), fill = cut)) +
  geom_bar(width = 1) +
  coord_polar(theta = "y")
# setting theta = y in coord_polar() maps the angle of the slices in the pie chart 
# to the counts within the levels of the cut variable. The pie chart is just a 
# stacked bar chart mapped to polar coordinates.

# 2.
?labs
# labs() allows us to set the plot labels manually. We can set the plot title, subtitle,
# caption, tab, and the x and y axes.

# 3.
?coord_quickmap
?coord_map
# coord_map() projects a portion of the earth, approximately spherical, onto a flat 2D
# plane using projections in the "mapproj" package. coord_quickmap() is an approximation
# that, unlike coord_map(), preserves straight lines. For this reason, coord_quickmap()
# works best for smaller areas closer to the equator. Both coord_map() and coord_quickmap()
# are superseded by coord_sf() and should not be used in new code. All non-sf geoms can
# be used with coord_sf() by setting the default coordinate system with the default_crs
# argument.
?coord_sf
# coord_sf is used to visualize simple features (sf) objects from the "sf" package.

# 4.
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() +
  coord_fixed()

# coord_fixed() enforces a specified ratio between the physical representation of
# data units on the plot axes. The default, ratio = 1, ensures that one unit on the
# x-axis is the same length as one unit on the y-axis. 

# geom_abline() adds the line x = y onto the plot. It shows that for corresponding
# values of cty (city miles per gallon), values of hwy (highway miles per gallon)
# are *always* higher, because all of the points are above the ab line (i.e y > x 
# for every value of x).

# This plot shows that for all observations in the mpg data set, highway miles per
# gallon is higher than city miles per gallon. The observed cars always have better
# gas mileage on the highway than in city (non-highway) driving.

###################################################################
# 4. WORKFLOW: BASICS #############################################
###################################################################

# 4.4 Exercises ###################################################

# 1.
my_variable <- 10
my_varıable
#> Error in eval(expr, envir, enclos): object 'my_varıable' not found
# this code doesn't work because the character "i" is missing in 'my_varıable",
# and is replaced with "ı". 

# 2.
ggplot(dota = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

fliter(mpg, cyl = 8)
filter(diamond, carat > 3)

# corrected code:
ggplot(data = mpg) +  # "data", not "dota"
  geom_point(mapping = aes(x = displ, y = hwy))

filter(mpg, cyl == 8)  # "filter", not "fliter", and "cyl == 8", not "cyl = 8"
filter(diamonds, carat > 3)  # "diamonds", not "diamond"

# 3.
# Pressing Alt + Shift + K brings up the Keyboard Shortcut Quick Reference, which
# has a list of all the key combinations plus the shortcuts they enable.

###################################################################
# 5. DATA TRANSFORMATION ##########################################
###################################################################

library(nycflights13)

# 5.2.4 Exercises

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

# 2.
# between(dat, x, y) grabs the values in dat between x and y, inclusive.  Answer 1.7 can be simplified to
flights %>% filter(between(dep_time, 0, 6))
# and answer 1.4 can be simplified to
flights %>% filter(between(month, 7, 9))

# 3. 
flights %>% filter(is.na(dep_time)) %>% count()  # 8,255 flights
# Looking at the first 10 rows of this filtered data, dep_delay, arr_time, and arr_delay variables are also missing.  
# My guess is that these were canceled flights.

# 4. 
NA ^ 0  # not missing because anything to the power of 0 is equal to 1.
NA | TRUE  # not missing because something is always TRUE or unknown.
FALSE & NA  # not missing because we can't know if an unknown is also FALSE.
NA * 0 # missing because a number multiplied by zero is always zero only for finite numbers.

# 5.3.1 Exercises

# 1. 
flights %>% arrange(desc(is.na(dep_time)), dep_time)

# 2. 
flights %>% arrange(desc(dep_delay))  
flights %>% arrange(dep_delay)

# 3. 
flights %>% arrange(air_time)

# 4. 
flights %>% arrange(desc(distance))
flights %>% arrange(distance)


# 5.4.1 Exercises

# 1. 
flights %>% select(starts_with("dep"), starts_with("arr"))
flights %>% select(dep_time, dep_delay, arr_time, arr_delay)
flights %>% select(matches("^arr.*"), matches("^dep.*"))
flights %>% select(dep_time:arr_delay, -starts_with("sched"))

# 2. 
flights %>% select(arr_time, arr_time)
# A variable name repeated in the select function is only returned once - the column is not duplicated.

# 3. 
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
# any_of() will grab columns that match an element in a character vector.  
flights %>% select(any_of(vars))
# This function is useful when there is a need to select multiple specific columns from a data set.
# It's easier to do that by feeding a character vector of variable names to select() instead of typing
# them all out, sans quotation marks, within the select() function.

# 4. 
select(flights, contains("TIME"))
# select() looks for columns containing "TIME" in any case, upper or lower. 
# contains() has an argument ignore.case which is TRUE by default.  
flights %>% select(contains("TIME", ignore.case = FALSE))


# 5.5.2 Exercises

# 1. 
flights %>%
  mutate(
    dep_time_mins = (dep_time %/% 100 * 60 + dep_time %% 100) %% 1440,
    sched_dep_time_mins = (sched_dep_time %/% 100 * 60 + sched_dep_time %% 100) %% 1440
  )

# 2. 
# First, arr_time and dep_time need to be changed into minutes, as air_time is in minutes.

flights_in_minutes <- mutate(flights,
       arr_time_mins = (arr_time %/% 100 * 60 + arr_time %% 100) %% 1440,
       dep_time_mins = (dep_time %/% 100 * 60 + dep_time %% 100) %% 1440,
       air_time_diff = air_time - arr_time_mins + dep_time_mins
       )

# I would expect air_time_diff, the difference between the variable air_time and the calculated difference
# in minutes of the arr_time and dep_time variables, to be all zeros.
flights_in_minutes %>% filter(air_time_diff != 0)
# A tibble: 327,150 × 22
# There are many nonzero values of air_time_diff.
# This suggests that the air_time variable omits some time values, such as taxi, take off, etc.
# Another factor may be time zone differences in the departure and arrival locations, affecting the values
# of dep_time and arr_time.
     
# 3. 
flights %>% select(dep_time, sched_dep_time, dep_delay)
# I would expect dep_delay to be the difference of sched_dep_time and dep_time.
# Let's find out if this is true by calculating the delays in minutes from dep_time and sched_dep_time,
# then finding the difference between the calculated delays in minutes and dep_delay:
flight_delays <- flights %>% 
  mutate(
    dep_time_mins = (dep_time %/% 100 * 60 + dep_time %% 100) %% 1440, 
    sched_dep_time_mins = (sched_dep_time %/% 100 * 60 + sched_dep_time %% 100) %% 1440,
    delay_calc = dep_time_mins - sched_dep_time_mins,
    dep_diff = dep_delay - delay_calc
    )

flight_delays %>% filter(dep_diff != 0, dep_diff != 1440)
# There are no flights where dep_diff is not equal to 0 or 1440, the latter indicating flights
# that were scheduled before midnight on a given day, but were delayed until after midnight i.e.
# the following day.

# 4. 
# I chose arr_delay to find the most delayed flights, to account for in flight savings or loss of time.
# I want to capture ties as the same rank, so I chose min_rank() for the ranking function. 
# It's necessary to use desc(arr_delay) to show the most delayed flights as the lowest ranks.
top10_delays <- flights %>% 
  mutate(
    arr_delay = sort(arr_delay, decreasing = TRUE, na.last = TRUE), 
    rank = min_rank(desc(sort(arr_delay, decreasing = TRUE, na.last = TRUE)))
    )

top10_delays %>% top_n(-10)

# 5. 
1:3 + 1:10
# [1]  2  4  6  5  7  9  8 10 12 11
# Warning message:
#   In 1:3 + 1:10 :
#   longer object length is not a multiple of shorter object length
# 
# It appears that the addition was accomplished like this:
#   1 2 3 1 2 3 1 2  3  1
# + 1 2 3 4 5 6 7 8  9  10
# = 2 4 6 5 7 9 8 10 12 11
# The smaller vector was repeated over the length of the longer vector.  
# The warning message exists to show that the smaller vector was not applied an equal number of times, 
# because its length is not a divisor of the longer vector's length.

# 6. 
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

# 4. What does str_wrap() do?  When might you want to use it?

# str_wrap() implements the Knuth-Plass paragraph wrapping algorithm.  It takes arguments:
# string - a character vector of strings
# width - positive integer giving target line width in characters.  Width <= 1 will put each word on its own line.
# indent - non-negative integer giving indentation of first line in each paragraph.
# exdent - non-negative integer giving indentation of following lines in each paragraph.

string <- "Hi, my name is Morgan Thompson.  I was born in San Francisco, California.  I grew up mostly in Orinda, California. 
  My parents are from Wyoming and Virginia.  I spent holidays in both states at my grandparents' homes.  I traveled a lot as
 a child, due to my mom's employement with a major airline, and the free tickets we received because of that.  I went to school
 in Nashville, Tennessee for my bachelor's degree, and in Berkeley, California for my master's degree.  I loved being in school."

str_wrap(string)
cat(str_wrap(string), "\n")
cat(str_wrap(string, width = 40), "\n")
cat(str_wrap(string, width = 40, indent = 5), "\n")
cat(str_wrap(string, width = 40, indent = 5, exdent = 5), "\n")
cat(str_wrap(string, width = 0), "\n")

# You might want to use str_wrap() when you need to print out a block of text, and you'd like it formatted nicely, with indents
# and within a certain limited space, rather than it printing across the whole screen without line breaks or any indentation.

# 5. What does str_trim() do?  What's the opposite of str_trim()?

# str_trim() removes whitespace from the start and end of a string.
string <- "   Morgan     "
str_trim(string)  

# the opposite of str_trim() is str_pad(), which will pad a string with a given character number of whitespace.

string <- "Morgan"
str_pad(string, 10, "left")
str_pad(string, 10, "right")
str_pad(string, 10, "both")

# 6. Write a function that turns (e.g.) a vector c("a", "b", "c") into the string "a, b, and c".  Think carefully
#    about what it should do if given a vector of length 0, 1, or 2.

# First, I'll create some sample string vectors.  I'm going to make one that is length 3, and the exact vector given
# in the question.  Then I'll create vectors of incrementally smaller lengths, down to 0.  I'll also create a vector
# of length > 3, to show what I want to happen in that scenario.  I decided to print out the result string minus the 
# missing strings for string vectors of length < 3.  For string vectors of length > 3, I decided to print an error
# message.  I'd like to keep this function limited to string vectors of length 3 or less, as I think it relates more
# to the problem description.
str <- c("a", "b", "c")
str_2 <- c("a", "b")
str_1 <- "a"
str_0 <- vector(mode = "character", length = 0)
str_4 <- c("a", "b", "c", "d")


str_fun <- function(str) {
  ifelse (
    # if the length of the string vector equals 0, then print the string without any characters in it.
    length(str) == 0, " , , and ",  
      # if it's not length 0, but it's length 1, print the string with the one character in the first spot, the rest
      # being left empty.
      ifelse(length(str) == 1, str_c(str, ", , and "),
        # if it's not length 1, but it's length 2, print the string with the two characters in the first two spots, 
        # the last one remaining empy.
        ifelse(length(str) == 2, str_c(str_c(str, collapse = ", "), " and "),
          # if it's not length 2, but it's length 3, print the desired result string as given in the problem.
          ifelse(length(str) == 3, str_c(str_c(str[1:2], collapse = ", "), str[3], sep = ", and "),
            # if it's over length 3, print this error message:
            "Too long!  Please enter a vector of length 3 or less.")
        )
      )
  )
}
    
str_fun(str)
str_fun(str_2)
str_fun(str_1)
str_fun(str_0)
str_fun(str_4)
# it works!
    
# Matching Patterns with Regular Expressions exercises, 'R for Data Science' ##################################
