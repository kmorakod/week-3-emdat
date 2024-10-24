is_installed <- "pacman" %in% rownames(installed.packages())
is_installed
setwd("~/Desktop/") #sets working directory to my desktop
rm(list = ls()) #clears environment and the previous check

if (!require("pacman")) {
  install.packages("pacman")
}

pacman::p_load(
  tidyverse, # tidyverse pkgs including purrr
  kableExtra,#table
  flextable, #table
  skimr) #a broad overview of data frame 

data <- read.csv("EMDAT.csv", header = TRUE) #header checks if the first row are labels rather than the variables

options(scipen=999) #so that numbers are not in scientific notation

skim(data)

library(dplyr)

# 4) Select the variables that capture the information related to 
#deaths, injuries, homelessness caused by all disasters. You can rename the variables.

newdataset <- data %>% select(Entity, Year, deaths_all_disasters, injured_all_disasters, homeless_all_disasters,) %>% 
  rename(deaths = deaths_all_disasters, injuries = injured_all_disasters, homelessness = homeless_all_disasters, country = Entity)

# 5) Create three tables showing the highest averages of deaths, injuries, 
#and homelessness (e.g. top 10)

averages <- newdataset %>%
  filter(!country %in% c("World", "Soviet Union")) %>%  # Remove "World" and "Soviet Union"
  group_by(country) %>%
  summarise(
    avg_deaths = mean(deaths, na.rm = TRUE),
    avg_injuries = mean(injuries, na.rm = TRUE),
    avg_homelessness = mean(homelessness, na.rm = TRUE)
  )

# Create tables for the top 10 averages
top_10_deaths <- averages %>%
  arrange(desc(avg_deaths)) %>%
  head(10) %>%
  kable(caption = "Top 10 Countries by Average Deaths")
# Apply formatting
top_10_deaths %>%
  kable_styling("striped") %>%
  kable_classic(full_width = FALSE)

top_10_injuries <- averages %>%
  arrange(desc(avg_injuries)) %>%
  head(10) %>%
  kable(caption = "Top 10 Countries by Average Injuries")
top_10_injuries %>%
  kable_styling("striped") %>%
  kable_classic(full_width = FALSE)

top_10_homelessness <- averages %>%
  arrange(desc(avg_homelessness)) %>%
  head(10) %>%
  kable(caption = "Top 10 Countries by Average Homelessness")
top_10_homelessness %>%
  kable_styling("striped") %>%
  kable_classic(full_width = FALSE)

# 6) Create a new binary variable in the original dataset to
#show whether the number of deaths by all disasters is higher than 500 in a given year

newdataset <- newdataset %>% mutate(high_death = ifelse(deaths > 500, 1, 0))

# 7) Reshape the dataset (selected version) and save it as a separate dataset in your repository
newdataset_wide <- newdataset %>%
  pivot_wider(
    names_from = Year,       # Specify the columns to pivot
    values_from = c(deaths, injuries, homelessness, high_death)  # Specify the values columns
  )
# Save the df_wide data frame as a separate R data set
saveRDS(newdataset_wide, "newdataset_wide.rds")

