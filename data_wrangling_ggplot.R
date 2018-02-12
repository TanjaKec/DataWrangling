# Start writing **R** code
# To learn about **R**'s basic operations, data structures and 
# base functions you could look at 'Introduction to base R' 
# https://tanjakec.github.io/blog/introduction-to-r/.

# If you want to access data and code written by other people, 
# you’ll need to install it as a **package**. An **R package** 
# is a bundle of functions (code), data, documentation, vignettes 
# (examples), stored in one neat place.

# Access Chicago Data available in 'gamair' package
# step 1) install the package
# step 2) call the package

install.packages("gamair")
library(gamair)
data(chicago)
?chicago
# 1st look at the data
dim(chicago)
#
head(chicago)

# Examine the structure of the data: ```str()```
str(chicago) 

# The output could look messy and it might not fit the 
# screen if you're dealing with a big data set that has lots 
# of variables!
# Do it in a tidy way: ```glimpse()```
suppressPackageStartupMessages(library(dplyr))
glimpse(chicago) 

# Select your variables

chicago_air_measurements <- select(chicago, ends_with("median"))
head(chicago_air_measurements, n = 1)
#
chicago_air_pm <- chicago[c("pm10median", "pm25median")]
head(chicago_air_pm, n = 1)
#
chicago_air_pm2 <- select(chicago, starts_with("pm"))
head(chicago_air_pm2, n = 1)


# mutate(): allow you to add to the data frame ```df``` a new column
# Let us convert °F into °C: T(°C) = (T(°F) - 32) × 5/9
chicago2 <- mutate(chicago, tmpdc = round((tmpd - 32) / 1.8, digits = 1)) 
head(chicago2, n = 3)

# Filter your data with filter()
high_death <- filter(chicago2, death > 200) 
high_death
#
high_temp_death <- filter(chicago2, death > 200 & tmpdc >= 30)
high_temp_death

# Arranging your data using arrange()
low_2_high <- arrange(chicago, death)
head(low_2_high, n = 4)
#
high_2_low <- arrange(chicago, desc(death))
head(high_2_low, n = 4)


# summary of chicago data containing two variables: 
# max_detht and the max_tmpd by using summarise()
summarise(chicago, max_deth = max(death), max_tmpd = max(tmpd))

# pipe it all up with %>%
chicago_pipe <- chicago %>%
  filter(!is.na(pm10median) & !is.na(so2median)) %>%
  mutate(tmpdC = round((tmpd - 32) / 1.8, digits = 1))
# plot it
plot(chicago_pipe$tmpdC, chicago_pipe$death, cex = 0.5, col = "red")


# grammer of graphics: ggplot()
# install(ggplot2)
library(ggplot2)
ggplot(chicago_pipe, aes(x = tmpdC, y = death)) +
  geom_point(col ="red")

## adding layers to your ggplot()
ggplot(chicago_pipe, aes(x = tmpdC, y = death, col = "red")) +
  geom_point(alpha = 0.2) +
  geom_smooth(col = "blue") +
  labs (title= " death vs temperature ", 
        x = "°C", y = "death") +
  theme(legend.position = "none", 
        panel.border = element_rect(fill = NA, 
                                    colour = "black",
                                    size = .75),
        plot.title=element_text(hjust=0.5))

# YOUR TURN!!!
# upload Daily Mortality Weather and Pollution Data for Chicago: 
# 'chicagoNMMAPS' available from 'dlnm' package.
# have a glance at the data.
# what are the questions you could ask; could you provide the answers to them?
  
# **There is a chalange:
# dplyr's group_by() function enables you to group your data. 
# It allows you to create a separate df that splits the original df by a variable.
# Knowing about group_by() function, coud you compute the average pollutant 
# level by month and visualise your result?

# Possible Solution: code
# install and open `dlnm' package and access the data
install.packages("dlnm")
library(dlnm)
data("chicagoNMMAPS")

