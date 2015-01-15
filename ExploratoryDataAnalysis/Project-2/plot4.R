# if data not downloaded yet, use the code in next line
# source("downloadData.R")

library(ggplot2)

# read NEI and SCC data in - first check if the data already read in
if (!"NEI" %in% ls()) {
    NEI <- readRDS("summarySCC_PM25.rds")
}
if (!"SCC" %in% ls()) {
    SCC <- readRDS("Source_Classification_Code.rds")
}

# subset coal combustion data
pickCoal1 <- grepl("coal", SCC$EI.Sector, ignore.case=TRUE)
pickCoal2 <- grepl("coal", SCC$SCC.Level.Three, ignore.case=TRUE)
coalComb <- (pickCoal1 | pickCoal2)
SCC_cc <- SCC[coalComb,]$SCC
ccNEI <- NEI[NEI$SCC %in% SCC_cc,]

# plot
png("plot4.png", width=480, height=480, units="px")

cc_plot <- ggplot(ccNEI, aes(x=factor(year), y=Emissions / 10^3)) +
           geom_bar(stat="identity") + 
           labs(x="Year", y="PM2.5 Coal Combustion Emission (in Thousand Tons)", 
           title="PM2.5 Coal Combustion Emissions across the US")

print(cc_plot) 

dev.off()
