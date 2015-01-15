# if data not downloaded yet, use the code in next line
# source("downloadData.R")

# read NEI data in - first check if the data already read in
if (!"NEI" %in% ls()) {
  NEI <- readRDS("summarySCC_PM25.rds")
}

# get the sum of total emissions by year
totalsByYear <- aggregate(Emissions ~ year, data=NEI, sum)

# plot
png("plot1.png", width=480, height=480, units="px")

barplot(totalsByYear$Emissions/10^6, names.arg=totalsByYear$year,
         xlab="Year", ylab="PM2.5 Emissions (in Million Tons)", col="red",
         main="Total PM2.5 Emission from All Sources in the US"
)

dev.off()
