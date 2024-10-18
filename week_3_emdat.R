EMDAT <- read.csv("/Users/keomorakod/Desktop/EMDAT.csv") # importing 
View(EMDAT)

#setup
if (!require("pacman")) {
  install.packages("pacman")
}

pacman::p_load(
  tidyverse,
    kableExtra, 
  flextable,
  skimr)

data <- read.csv("EMDAT.csv", header = TRUE)

skim(data)

df <- data %>% select(Entity, Year, deaths_all_disasters, injured_all_disasters, homeless_all_disasters) %>%
  rename(deaths = deaths_all_disasters, injured_all_disasters, homeless_all_disasters, 
         homelessness = homeless_all_disasters, country = Entity)

glimpse(df)



