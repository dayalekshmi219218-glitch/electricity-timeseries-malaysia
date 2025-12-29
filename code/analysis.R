# Clear all objects
rm(list = ls())

# Clear plots
if (!is.null(dev.list())) dev.off()

# Clear console
cat("\014")  # CTRL+L in RStudio also works

# Install only once if you haven't already
# install.packages("forecast")
# install.packages("tseries")
# install.packages("ggplot2")
# install.packages("dplyr")  # optional for filtering

# Load libraries
library(forecast)
library(tseries)
library(ggplot2)
library(dplyr)

df <- read.csv("electricity_consumption.csv",
               stringsAsFactors = FALSE)

# Quick checks
head(df)
str(df)
summary(df)

# Ensure date column is Date type
df$date <- as.Date(df$date)

# Filter for total electricity consumption only
df_total <- df %>%
  filter(sector == "total") %>%
  arrange(date) %>%
  na.omit()  # remove missing values if any

# Adjust start year/month if your data starts elsewhere
ts_data <- ts(df_total$consumption,
              start = c(2015, 1),
              frequency = 12)

# Quick plot (Raw Plot)
plot(ts_data,
     main = "Monthly Electricity Consumption in Malaysia",
     xlab = "Year",
     ylab = "Consumption")

 # Additive Decomposition plot 
add_dec <- decompose(ts_data, type = "additive")
plot(add_dec)

 # Additive Seasonal Forecast Plot
library(forecast)
add_model <- ets(ts_data, model = "AAA")
add_fc <- forecast(add_model, h = 12)
plot(add_fc, main = "Additive Seasonal Forecast")

 # Multiplicative Seasonal Plot
mult_model <- ets(ts_data, model = "MAM")
mult_fc <- forecast(mult_model, h = 12)
plot(mult_fc, main = "Multiplicative Seasonal Forecast")

# Forecast Accuracy Measures
# Additive
accuracy(add_fc)
# Multiplicative
accuracy(mult_fc)

 
