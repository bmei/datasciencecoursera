# read data
data <- read.table("household_power_consumption.txt", sep=';', header=TRUE, na.string='?')

# change the class and format of Date
data$Date <- as.Date(data$Date, format="%d/%m/%Y")

# subset the data
mydata <- data[data$Date<="2007-02-02" & data$Date>="2007-02-01",]

# plot #1
png("plot1.png", width=480, height=480, units="px")

hist(mydata$Global_active_power, col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)")

dev.off()