

# Read the raw data in
raw_hall_data = read_tsv("raw_data/hall-data/hall-data-main.txt")
# get a warning because "low" was used for a few rows of readings,
# maybe because they were too low to for the meter.

# See a quick summary:
summary(raw_hall_data)

# histogram of glucose values:
hist(raw_hall_data$GlucoseValue)
sort(raw_hall_data$GlucoseValue)[1:30]

# Ok, so will fill in the "low" values in glucose with 39 for now. I'm guessing it didn't 
# go much further below that.

clean_hall_data <- select(raw_hall_data, id = subjectId, time = DisplayTime, glucose = GlucoseValue) %>% 
  mutate(glucose = ifelse(is.na(glucose), 39, glucose))

# Done!

# Load in the other data too:

# meal data:
raw_meal_data = read_tsv("raw_data/hall-data/hall-meal-data.tsv")

# Need to use SQLite for loading the subject data
library(RSQLite)
filename <- "raw_data/hall-data/hall-data-subjects.db"
sqlite.driver <- dbDriver("SQLite")
db <- dbConnect(sqlite.driver,
                dbname = filename)
dbListTables(db)
hall_subject_data <- dbReadTable(db,"clinical")

