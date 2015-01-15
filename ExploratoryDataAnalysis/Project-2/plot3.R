# if data not downloaded yet, use the code in next line
# source("downloadData.R")

library(ggplot2)

# read NEI data in - first check if the data already read in
if (!"NEI" %in% ls()) {
  NEI <- readRDS("summarySCC_PM25.rds")
}

# subset Baltimore City data
bcNEI <- NEI[NEI$fips=="24510",] 

# plot
png("plot3.png", width=600, height=480, units="px")

bc_plot <- ggplot(bcNEI, aes(x=factor(year), y=Emissions, fill=type)) +
           geom_bar(stat="identity") + facet_grid(. ~ type) +
           labs(x="Year", y="Total PM2.5 Emission (Tons)", 
                title="Baltimore City PM2.5 Emissions by Source Type")

print(bc_plot) 

dev.off()
