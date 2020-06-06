# Read in cleaned wildfires data

# Author: Sara Altman
# Version: 2020-05-13

# Libraries
library(tidyverse)

# Parameters
file_data <- here::here("data-raw/wildfires_deduped.csv")
file_out <- here::here("data/wildfires.rds")
#===============================================================================

wildfires <-
  file_data %>% 
  read_csv(
    col_types = 
      cols(
        .default = col_character(),
        LATITUDE = col_double(),
        LONGITUDE = col_double(),
        ESTIMATED_COST = col_double(),
        REPORT_DATE = col_datetime(format = ""),
        MAX_PERSONNEL = col_double(),
        INCIDENT_AREA = col_double(),
        MAX_SFR_THREAT = col_double(),
        MAX_MFR_THREAT = col_double(),
        MAX_MU_THREAT = col_double(),
        MAX_COMM_THREAT = col_double(),
        MAX_OUTB_THREAT = col_double(),
        MAX_OTHER_THREAT = col_double(),
        SFR_DAMAGED = col_double(),
        MFR_DAMAGED = col_double(),
        MU_DAMAGED = col_double(),
        COMM_DAMAGED = col_double(),
        OTHER_DAMAGED = col_double(),
        SFR_DESTROYED = col_double(),
        MFR_DESTROYED = col_double(),
        MU_DESTROYED = col_double(),
        COMM_DESTROYED = col_double(),
        OUTB_DESTROYED = col_double(),
        OTHER_DESTROYED = col_double(),
        INJURIES = col_double(),
        FATALITIES = col_double(),
        REPORT_ID = col_character(),
        WILDFIRE = col_logical(),
        STATE_FIPS = col_character(),
        DESTROYED = col_logical(),
        THREATENED = col_logical(),
        CLIMATE_REGION = col_character()
      )
  ) %>% 
  write_rds(file_out)
