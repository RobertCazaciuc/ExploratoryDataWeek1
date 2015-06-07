#Script for course project 1
#load the data table library
library(data.table)
library(tidyr)
library(lubridate)


url <- c("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip")
zip_download <- c("power_consumption.zip")

if(!file.exists(zip_download)) {
        download.file(url, zip_download)
}

fileName <- c("household_power_consumption.txt")

if(!file.exists(folderName)) {
        unzip (zip_download)
}

#Read the first 10 lines
dataSubset <- read.csv(fileName, header = TRUE, sep = ";", nrows = 10)

#get the classes of the columns
classes <- lapply(dataSubset, class)

#read the data in, apply colCasses and specify null values as "?"
data <- read.csv("household_power_consumption.txt", header = TRUE, sep = ";", colClasses = classes, na.strings = "?")

#transform to data.table for faster
data <- as.data.table(data)

#transform the Date into Date for better manipulation
data$Date <- as.Date(data$Date, "%d/%m/%Y")

#Subset on the required dates
datesSubset <- c("2007-02-02","2007-02-01")
datesSubset <- as.Date(datesSubset, "%Y-%m-%d")
data <- data[data[, Date %in% datesSubset]]

#Apply tidy data principles and collapse columnsh
data <- gather(data, sub_meter, sub_meter_reading, 7:9)

data <- mutate(data, DateTime = paste(Date, Time))
data$DateTime <- ymd_hms(data$DateTime)

#Set the screen display to 1 graph
par(mfrow = c(2,2))

#Set the margins
par(mar = c(4,1,1,1))

#Display the graph

with(data, plot(DateTime, Global_intensity,type = "l", ylab = "Global Active Power (Killowats)", xlab = ""))
with(data, plot(DateTime, Voltage,type = "l", ylab = "", xlab = "datetime"))
with(data, plot(DateTime, sub_meter_reading, type="n", xlab = "",ylab="Energy sub metering"))
with(subset(data,sub_meter=="Sub_metering_1"), points(DateTime, sub_meter_reading, type="l"))
with(subset(data,sub_meter=="Sub_metering_2"), points(DateTime, sub_meter_reading, type="l", col = "Red"))
with(subset(data,sub_meter=="Sub_metering_3"), points(DateTime, sub_meter_reading, type="l", col = "Blue"))
legend("topright", pch = "-", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
with(data, plot(DateTime, Global_reactive_power,type = "l", xlab = "datetime"))


## Copy my plot to a PNG file
dev.copy(png, file = "plot4.png") 
## Don't forget to close the PNG device!
dev.off()