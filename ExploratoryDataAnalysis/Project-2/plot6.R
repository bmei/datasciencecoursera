library(ggplot2)

# read NEI and SCC data in - first check if the data already read in
if (!"NEI" %in% ls()) {
  NEI <- readRDS("summarySCC_PM25.rds")
}
if (!"SCC" %in% ls()) {
  SCC <- readRDS("Source_Classification_Code.rds")
}

# subset vehicle-related NEI data
pickVehs <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
SCC_vehs <- SCC[pickVehs,]$SCC
vehsNEI <- NEI[NEI$SCC %in% SCC_vehs,]

# subset Baltimore City's vehicle-related NEI data
bcVehNEI <- vehsNEI[vehsNEI$fips=="24510",]
bcVehNEI$Location <- "Baltimore City"

# subset Los Angeles's vehicle-related NEI data
laVehNEI <- vehsNEI[vehsNEI$fips=="06037",]
laVehNEI$Location <- "Los Angeles County"

# combine two data sets
combVehNEI <- rbind(bcVehNEI, laVehNEI)

# plot
png("plot6.png", width=560, height=480, units="px")

veh_plot <- ggplot(combVehNEI, aes(x=factor(year), y=Emissions/10^3, fill=Location)) +
            geom_bar(stat="identity") + facet_grid(. ~ Location) + guides(fill=FALSE) +
            labs(x="Year", y="PM2.5 Motor Emission (in Thousand Tons)", 
                 title="Comparison between Baltimore City and Los Angeles County")

print(veh_plot)

dev.off()
