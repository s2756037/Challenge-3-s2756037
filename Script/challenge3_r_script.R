# Challenge 3 Statistical Modeling
# Data Science in Ecology and Environmental Science 2024
# By: Anna Longenbaugh (s2756037)
# Started 13th November 2024
# Finished 14th November 2024

# Starter code ----

# Libraries
library(tidyverse) # Covers data import, tidying, transformation, visualization, and programming with a consistent syntax.

# Load Living Planet Data
load("Data/LPI_data.Rdata")

# Choose your species from this list - don't forget to register your species
# on the issue for the challenge and check that no other student has chosen 
# the species already. Every student must choose a different species!
unique(data$Common.Name)

# Filter for my chosen species here
# My chosen species is the Wandering albatross (favorite bird besides the kiwi)
wandering_albatross <- data %>%
filter(Common.Name %in% c('Wandering albatross'))

# Inspecting Wandering albatross data
head(wandering_albatross)
str(wandering_albatross)

# Statistical analysis ----

# Question, Hypothesis and Prediction
# Question: Did the number of Wandering Albatross breeding pairs in 4 different colonies change between the years of 1990 - 2003?
# Hypothesis: Wandering Albatross breeding pairs will have decreased during the 13 year interval
# Prediction: Due to increased human activity, Wandering Albatross breeding pairs will decrease in the 4 colonies?

# Create a data frame with the wandering_albatross dataset that includes only Location, Year, and Breeding Pairs
data_albatross <- data.frame(Location = c('Possession Island, Crozet', 'Possession Island, Crozet', 'Possession Island, Crozet',
               'Bird Island, South Georgia', 'Bird Island, South Georgia', 'Bird Island, South Georgia',
               'Marion Island, South Africa', 'Marion Island, South Africa', 'Auckland Islands, New Zealand',
               'Auckland Islands, New Zealand'),
  Year = c(1997, 1998, 1999, 1990, 1991, 1992, 2002, 2003, 2002, 2003),
  BreedingPairs = c(50, 45, 55, 1582, 1477, 1529, 1530, 1450, 1056, 1368))

# View the data
print(data)
# This new data allows me to find the mean, median, and mode since it is numerical

# Calculate mean, median, and mode for the breeding pairs, grouped by each location
# Summary statistics
summary_stats <- data %>%
  group_by(Location) %>%
  summarise(
    Mean = mean(BreedingPairs, na.rm = TRUE),
    Median = median(BreedingPairs, na.rm = TRUE),
    SD = sd(BreedingPairs, na.rm = TRUE),
    Min = min(BreedingPairs, na.rm = TRUE),
    Max = max(BreedingPairs, na.rm = TRUE))

# View the summary statistics
print(summary_stats) 
# Based on the statistic analysis results Bird Island, South Georgia has the largest mean (1529), median (1529), min (1477),
# and max (1582). Auckland Islands, New Zealand has the highest SD (221) and Possession Island, Crozet has the lowest
# results among all the locations
# Possession Island, Crozet results suggest that the breeding pairs there are not part of historically established colony

# Hierarchical linear model ----
# Linear regression analysis for each location
trend_analysis <- data %>%
  group_by(Location) %>%
  do({
    lm_model <- lm(BreedingPairs ~ Year, data = .)
    tibble(
      Slope = coef(lm_model)[2],  # The slope represents the rate of change between the variables or the trend
      Intercept = coef(lm_model)[1], # The intercept represents the expected value of the dependent variable when all independent variables are equal to zero. 
      R2 = summary(lm_model)$r.squared)}) # The R2 represents the proportion of the variation in the dependent variable from the line of best fit (mean)

# View the trend analysis results
print(trend_analysis)
# Based on the trend analysis results Bird Island, South Georgia and Possession Island, Crozet have the smallest R2 values
# meaning their dependent variable (breeding pairs) have the least amount of variation. Both Auckland Islands, New Zealand and Possession Island
# have positive slopes meaning that they have a positive trend with increasing breeding pairs per year. 

# ANOVA test to compare breeding pairs across locations
anova_result <- aov(BreedingPairs ~ Location, data = data) 
# Doing an ANOVA test will show if there is statistically significant differences between the 4 locations in the dataset

# Display ANOVA results
summary(anova_result) 
# Based on the ANOVA results one of the locations is significantly different from the 3 others since the test has a
# Pr(>F) value of 5.67e-06 showing that the null hypothesis can be rejected. The Pr(>F) value is the p-value of the F statistic/F value

# Model and data visualization ----
# Line plot to show breeding pairs over time for each location
ggplot(data, aes(x = Year, y = BreedingPairs, color = Location)) +
  geom_line() +
  geom_point() +
  labs(title = "Breeding Pairs of Wandering Albatross Over Time", x = "Year", y = "Breeding Pairs") +
  theme_minimal()

# Boxplot to compare breeding pairs across locations
ggplot(data, aes(x = Location, y = BreedingPairs)) +
  geom_boxplot() +
  labs(title = "Comparison of Breeding Pairs Across Locations", x = "Location", y = "Breeding Pairs") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

