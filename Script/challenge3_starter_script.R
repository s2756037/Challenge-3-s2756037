# Challenge 3 Statistical Modelling
# Data Science in EES 2024
# Starter script written by Isla Myers-Smith and edited/finished by Anna Longenbaugh
# 14th November 2024

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

# Hierarchical linear model ----

# Model and data visualisation ----

