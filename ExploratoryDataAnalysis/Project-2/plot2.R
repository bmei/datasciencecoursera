# if data not downloaded yet, use the code in next line
# source("downloadData.R")

# read NEI data in - first check if the data already read in
if (!"NEI" %in% ls()) {
  NEI <- readRDS("summarySCC_PM25.rds")
}

# subset Baltimore County data
bcNEI <- NEI[NEI$fips=="24510",] 

# get the sum of total emissions by year
totalsByYear <- aggregate(Emissions ~ year, data=bcNEI, sum)

# plot
png("plot2.png", width=480, height=480, units="px")

barplot(totalsByYear$Emissions/10^3, names.arg=totalsByYear$year,
        xlab="Year", ylab="PM2.5 Emissions (in Thousand Tons)", col="red",
        main="Baltimore County Total PM2.5 Emission from All Sources"
)

dev.off()
