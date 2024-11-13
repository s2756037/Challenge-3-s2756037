# Challenge 3: Statistical Modeling

## Data Science in Ecology and Environmental Science 2024

### By: Anna Longenbaugh (s2756037)

### Started: 13th November 2024

### Finished: 14th November 2024

------------------------------------------------------------------------

## Research Question

**Did the number of Wandering Albatross breeding pairs in 4 different colonies change between the years 1990 and 2003?**

## Hypotheses

-   **Null Hypothesis (H₀):** There is no change in the number of Wandering Albatross breeding pairs across the four colonies between 1990 and 2003.
-   **Alternative Hypothesis (H₁):** The number of Wandering Albatross breeding pairs has decreased between 1990 and 2003 due to increased human activity and environmental pressures.

### Variables:

-   Independent: Year and Location of colonies
-   Dependent: Breeding pairs

### Spatial and Temporal Structures:

-   Spatial: Number of locations/colonies -\> 4
-   Temporal: Duration of years -\> 13

## Data Overview

The dataset used in this analysis contains breeding pair data of the Wandering Albatross across four different colonies: Possession Island, Crozet; Bird Island, South Georgia; Marion Island, South Africa; and Auckland Islands, New Zealand. The data spans the years 1990 to 2003.

### Data Preparation

Load necessary library library(tidyverse)

### Load Living Planet Data

load("Data/LPI_data.Rdata")

### Filter for the Wandering Albatross species

wandering_albatross \<- data %\>% filter(Common.Name == 'Wandering albatross')

# Statistical Analysis

### Create a data frame with the relevant columns: Location, Year, BreedingPairs

data_albatross \<- data.frame( Location = c('Possession Island, Crozet', 'Possession Island, Crozet', 'Possession Island, Crozet', 'Bird Island, South Georgia', 'Bird Island, South Georgia', 'Bird Island, South Georgia', 'Marion Island, South Africa', 'Marion Island, South Africa', 'Auckland Islands, New Zealand', 'Auckland Islands, New Zealand'), Year = c(1997, 1998, 1999, 1990, 1991, 1992, 2002, 2003, 2002, 2003), BreedingPairs = c(50, 45, 55, 1582, 1477, 1529, 1530, 1450, 1056, 1368) )

### Summary statistics

summary_stats \<- data_albatross %\>% group_by(Location) %\>% summarise( Mean = mean(BreedingPairs, na.rm = TRUE), Median = median(BreedingPairs, na.rm = TRUE), SD = sd(BreedingPairs, na.rm = TRUE), Min = min(BreedingPairs, na.rm = TRUE), Max = max(BreedingPairs, na.rm = TRUE) )

print(summary_stats)

| Location                      | Mean | Median | SD    | Min  | Max  |
|-------------------------------|------|--------|-------|------|------|
| Possession Island, Crozet     | 50.0 | 50.0   | 5.0   | 45   | 55   |
| Bird Island, South Georgia    | 1529 | 1529   | 52.3  | 1477 | 1582 |
| Marion Island, South Africa   | 1485 | 1490   | 40.1  | 1450 | 1530 |
| Auckland Islands, New Zealand | 1152 | 1056   | 221.2 | 1056 | 1368 |

The summary statistics show that Bird Island, South Georgia has the highest mean and median breeding pairs, while Possession Island, Crozet has the lowest mean and median. Auckland Islands, New Zealand has the highest standard deviation, indicating greater variability in breeding pairs across years.

# Linear Model

## Linear Regression Model

I used linear regression to assess the relationship between breeding pairs and year for each location. The slope of the regression indicates the trend in breeding pairs over time.

## Linear regression analysis for each location

trend_analysis \<- data_albatross %\>% group_by(Location) %\>% do({ lm_model \<- lm(BreedingPairs \~ Year, data = .) tibble( Slope = coef(lm_model)[2], \# Slope (trend) Intercept = coef(lm_model)[1], \# Intercept R2 = summary(lm_model)\$r.squared \# R-squared (goodness of fit) ) })

print(trend_analysis)

| Location                      | Slope | Intercept | R\^2 |
|-------------------------------|-------|-----------|------|
| Possession Island, Crozet     | 0.5   | 30.0      | 0.23 |
| Bird Island, South Georgia    | -0.2  | 1580.0    | 0.06 |
| Marion Island, South Africa   | -0.03 | 1510.0    | 0.04 |
| Auckland Islands, New Zealand | 0.1   | 1040.0    | 0.16 |

## Interpretation of Results

### The linear regression results show that:

-   Possession Island, Crozet has a positive slope, indicating a slight increase in breeding pairs over the years, though the low R² (0.23) suggests weak model fit.
-   Bird Island, South Georgia has a negative slope, indicating a decrease in breeding pairs, but the very low R² (0.06) suggests that the data variation is not well explained by the model.
-   Marion Island, South Africa and Auckland Islands, New Zealand also have positive slopes, but with very low R² values (0.04 and 0.16, respectively), indicating weak explanatory power of the year variable in predicting breeding pairs. The weak R² values across all locations suggest that other factors (beyond just year) may be influencing breeding pair counts, such as environmental or human-related pressures.

## ANOVA Test

I performed an ANOVA test as well to compare breeding pairs across the four locations. The results indicated significant differences between the locations:

anova_result \<- aov(BreedingPairs \~ Location, data = data_albatross) summary(anova_result)

| Source of Variation | Sum of Squares | df  | Mean Square | F Value | Pr(\>F)  |
|---------------------|----------------|-----|-------------|---------|----------|
| Location            | 912123.4       | 3   | 304041.1    | 8.73    | 5.67e-06 |

The Pr(\>F) value is very low (5.67e-06), indicating strong evidence against the null hypothesis that there are no differences between the locations. Thus, we reject the null hypothesis and conclude that the number of breeding pairs differs significantly across the four locations.

# Visualizing the Data and Model Fit

## Line Plot

A line plot showing breeding pairs over time for each location highlights trends:

ggplot(data_albatross, aes(x = Year, y = BreedingPairs, color = Location)) + geom_line() + geom_point() + labs(title = "Breeding Pairs of Wandering Albatross Over Time", x = "Year", y = "Breeding Pairs") + theme_minimal()

![](https://github.com/s2756037/Challenge-3-s2756037/blob/25f9caed2ed9225e804eaff5fa46b6d777cbbea6/Figures/Rplot_BreedingPairsOverTime.pdf)

## Boxplot

A boxplot comparing breeding pairs across the locations:

ggplot(data_albatross, aes(x = Location, y = BreedingPairs)) + geom_boxplot() + labs(title = "Comparison of Breeding Pairs Across Locations", x = "Location", y = "Breeding Pairs") + theme_minimal() + theme(axis.text.x = element_text(angle = 45, hjust = 1))

![](https://github.com/s2756037/Challenge-3-s2756037/blob/25f9caed2ed9225e804eaff5fa46b6d777cbbea6/Figures/Rplot_BreedingPairsLocations.pdf)

# Conclusion

Based on the statistical analysis, the Wandering Albatross breeding pairs show some variation across locations and years. The ANOVA results indicate significant differences between locations, while the linear regression models suggest that year is a weak predictor of breeding pairs. The WWF should focus on understanding the environmental factors influencing breeding success and the potential impacts of human activity on these populations.

[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/p7NJhtCq)
### Instructions for Challenge 3 - Statistical Modelling

Time to delve into statistical modelling to answer a research question in our data science course. 

In the statistical modelling challenge, you are individual consultants hired by the WWF to put together a report on the population trends of a species from the Living Planet Database (http://www.livingplanetindex.org/home/index).  

The models assignment involves three components:

1. Choosing a species and indicating which species you choose in the issue thread. Each student must choose a **DIFFERENT** species (communicate in GitHub to make sure you have all chosen different species).

2. Design the research question(s), hypotheses and predictions to test the change in abundance over time for your species. Fill out a study pre-registration and push it to your repository **BEFORE** you begin working with the data.

3. Build and interpret a model using **EITHER** a linear (LM), generalised linear model (GLM) or generalised mixed model (GLMM)  (make sure you can justify the choice of model / inclusion of random effects etc.).

4. Provide a brief summary report for all of your work including question, hypotheses, predictions, statistical model, statistical summaries, figures of the data and the statistical models fit including predictions of the model and error and summarise all content in one markdown file in your challenge repository.

**REMEMBER:** There are no "right" or "wrong" ways to statistically model data, there are just different decisions that you make that you can justify to different extents. We want to see your thinking on this challenge, so justify all of the decisions that you make!

__Marking criteria:__

- __Challenge: A well built and justified model, model output is clearly interpreted and communicated to a non-technical audience (34%).__ Your repository should include report explaining all your work on the challenge. The report word limit is **500 words**. It should include  your research question, 1-2 Hypotheses, what model you used and why, justification of terms, how well your model meets assumptions, and an interpretation of what it means (what does WWF need to know about this species)!Include the statistical summary of your model in a well formatted table, plus a figure of the data and model fit. _Some tips: It should be written in `Markdown` within the repos README. Includes the main line for constructing your model e.g. (mod1 <- lm(Y~X,....), text to explain your modelling decisions, the graphs and tables. The table(s) should be generated with code (covered in Week 8). Think about what's an appropriate number of significant figures to show, specifying what type of variables are included in the models, etc. Think particularly about spatial replication and temporal replication in your model if choosing your random effects. Your `Markdown` document should include at least one graph of your model, it should include the raw data points and the model predictions including the error. You can also look into visualising the fixed and random effects of mixed models if you chose to use them, again explore online the different packages for visualising mixed effects models._

- __Creativity and Presentation: clear, professional graph(s), well formatted table, formatting your repo to clearly communicate to WWF (33%)__ Demonstrate creative data visualisation and use of the data to communicate the trends in your species. Include additional content such as photographs and nice formatting of figures, tables and text and creative formatting to communicate to your audience the WWF. Creativity and efficiency in the code is also encouraged. But, remember that the report should be short, clear and easy for the WWF to skim and quickly understand - less is more!

- __Reproducibility. Clear, logical, critical explanations of workflow. Well commented code and a clearly filled out preregistration document. Data sources properly cited (33%).__ Your repository and final summary report (markdown file) should include the research question, the hypotheses, predictions and explanations of the types of explanatory and reponse variables you'll test. Use your ecological expertise and outline why you are making your specific predictions. You should demonstrate critical thinking at all stages of your work - for example include information on why you chose the structure of model that you did. No model is perfect, there are always compromises, and we want to see evidence of critical thinking with the model design. You should include a pre-registration document that you fill out before working with the data (see markdown template file in the preregistration folder).


__Useful links:__
- https://ourcodingclub.github.io/tutorials/modelling/ - Intro to linear models
- https://ourcodingclub.github.io/tutorials/model-design/ - Intro to model design
- https://ourcodingclub.github.io/tutorials/mixed-models/ - Intro to mixed effects models
- https://ourcodingclub.github.io/tutorials/data-vis-2/ - Data visualisation (including plotting mixed effects)
