# Read in ICS209 wildfires data

# Author: Sara Altman
# Version: 2020-05-19

# Libraries
library(tidyverse)
library(sf)

# Parameters
  # Atlas Equal Area (what the paper uses)
PROJECTION <- 
  "+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs"
file_incidents <- 
  here::here(
    "data/ics209-plus-wildfire/ics209-plus-wf_incidents_1999to2014.csv"
  )
file_out_fires <- here::here("data/ics209plus_wildfires.rds")
file_out_hexnet <- here::here("data/hexnet.rds")
#===============================================================================

states <-
  ussf::boundaries("state", projection = "longlat") %>% 
  filter(!NAME == "Hawaii") %>% 
  select(state_fips = STATEFP, state_name = NAME) %>% 
  st_transform(PROJECTION)

hexnet <-
  states %>% 
  st_make_grid(
    cellsize = 50000,
    square = FALSE,
    crs = st_crs(states)
  ) %>% 
  st_sf(crs = st_crs(states)) %>% 
  st_cast("MULTIPOLYGON") %>% 
  mutate(hex_id = row_number()) %>% 
  write_rds(file_out_hexnet)

incidents <-
  file_incidents %>% 
  read_csv(
    col_types =
      cols(
        X1 = col_double(),
        INCIDENT_ID = col_character(),
        INCIDENT_NUMBER = col_character(),
        INCIDENT_NAME = col_character(),
        INCTYP_ABBREVIATION = col_character(),
        FINAL_ACRES = col_double(),
        CAUSE = col_character(),
        COMPLEX = col_logical(),
        DISCOVERY_DATE = col_datetime(format = ""),
        DISCOVERY_DOY = col_double(),
        EXPECTED_CONTAINMENT_DATE = col_datetime(format = ""),
        FATALITIES = col_double(),
        FUEL_MODEL = col_character(),
        INCIDENT_DESCRIPTION = col_character(),
        INC_IDENTIFIER = col_character(),
        INJURIES_TOTAL = col_double(),
        LL_CONFIDENCE = col_character(),
        LL_UPDATE = col_logical(),
        LOCAL_TIMEZONE = col_character(),
        POO_CITY = col_character(),
        POO_COUNTY = col_character(),
        POO_LATITUDE = col_double(),
        POO_LONGITUDE = col_double(),
        POO_SHORT_LOCATION_DESC = col_character(),
        POO_STATE = col_character(),
        PROJECTED_FINAL_IM_COST = col_double(),
        START_YEAR = col_double(),
        SUPPRESSION_METHOD = col_character(),
        STR_DAMAGED_TOTAL = col_double(),
        STR_DAMAGED_COMM_TOTAL = col_double(),
        STR_DAMAGED_RES_TOTAL = col_double(),
        STR_DESTROYED_TOTAL = col_double(),
        STR_DESTROYED_COMM_TOTAL = col_double(),
        STR_DESTROYED_RES_TOTAL = col_double(),
        FINAL_REPORT_DATE = col_datetime(format = ""),
        INC_MGMT_NUM_SITREPS = col_double(),
        EVACUATION_REPORTED = col_logical(),
        STR_THREATENED_MAX = col_double(),
        STR_THREATENED_COMM_MAX = col_double(),
        STR_THREATENED_RES_MAX = col_double(),
        TOTAL_AERIAL_SUM = col_double(),
        TOTAL_PERSONNEL_SUM = col_double(),
        WF_PEAK_AERIAL = col_double(),
        WF_PEAK_AERIAL_DATE = col_datetime(format = ""),
        WF_PEAK_AERIAL_DOY = col_double(),
        WF_PEAK_PERSONNEL = col_double(),
        WF_PEAK_PERSONNEL_DATE = col_datetime(format = ""),
        WF_PEAK_PERSONNEL_DOY = col_double(),
        WF_CESSATION_DATE = col_datetime(format = ""),
        WF_CESSATION_DOY = col_double(),
        WF_MAX_FSR = col_double(),
        WF_MAX_GROWTH_DATE = col_datetime(format = ""),
        WF_MAX_GROWTH_DOY = col_double(),
        WF_GROWTH_DURATION = col_double(),
        FOD_NUM_FIRES = col_double(),
        FOD_DISCOVERY_DOY = col_double(),
        FOD_CONTAIN_DOY = col_double(),
        FOD_CAUSE_CODE = col_character(),
        FOD_CAUSE_DESCR = col_character(),
        FOD_FIRE_SIZE = col_double(),
        FOD_COMPLEX_NAME = col_character(),
        FOD_OBJ = col_character(),
        FOD_LIST = col_character(),
        FOD_ID = col_double(),
        MTBS_ID = col_character(),
        MTBS_FIRE_NAME = col_character(),
        FOD_LATITUDE = col_double(),
        FOD_LONGITUDE = col_double()
      )
  ) %>% 
  rename_with(str_to_lower) %>% 
  select(-x1) %>% 
  filter(!is.na(poo_longitude), !is.na(poo_latitude)) %>% 
  st_as_sf(coords = c("poo_longitude", "poo_latitude"), crs = 4326) %>% 
  st_transform(crs = st_crs(states)) %>% 
  st_join(hexnet) %>%
  st_intersection(states) %>% 
  write_rds(file_out_fires)
