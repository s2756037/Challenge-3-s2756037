# Challenge 3 Statistical Modeling
# Data Science in EES 2024
# By: Anna Longenbaugh
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
# My chosen species is the Wandering albatross
wandering_albatross <- data %>%
filter(Common.Name %in% c('Wandering albatross'))

# Inspecting Wandering albatross data
head(wandering_albatross)
str(wandering_albatross)

# Statistical analysis ----
# Create a data frame with the wandering_albatross dataset (simplified version)
data_albatross <- data.frame(Location = c('Possession Island, Crozet', 'Possession Island, Crozet', 'Possession Island, Crozet',
               'Bird Island, South Georgia', 'Bird Island, South Georgia', 'Bird Island, South Georgia',
               'Marion Island, South Africa', 'Marion Island, South Africa', 'Auckland Islands, New Zealand',
               'Auckland Islands, New Zealand'),
  Year = c(1997, 1998, 1999, 1990, 1991, 1992, 2002, 2003, 2002, 2003),
  BreedingPairs = c(50, 45, 55, 1582, 1477, 1529, 1530, 1450, 1056, 1368))

# View the data
print(data)

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
      Slope = coef(lm_model)[2],  # The slope represents the trend
      Intercept = coef(lm_model)[1],
      R2 = summary(lm_model)$r.squared)})

# View the trend analysis results
print(trend_analysis)

# ANOVA test to compare breeding pairs across locations
anova_result <- aov(BreedingPairs ~ Location, data = data)

# Display ANOVA results
summary(anova_result) 

# Model and data visualization ----