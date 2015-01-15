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

# plot
png("plot5.png", width=480, height=480, units="px")

bc_veh_plot <- ggplot(bcVehNEI, aes(x=factor(year), y=Emissions)) +
               geom_bar(stat="identity") + 
               labs(x="Year", y="PM2.5 Motor Vehicle Emission (in Tons)", 
                    title="PM2.5 Motor Vehicle Emissions of Baltimore City")

print(bc_veh_plot)

dev.off()
