# read data
data <- read.table("household_power_consumption.txt", sep=';', header=TRUE, na.string='?')

# change the class and format of Date
data$Date <- as.Date(data$Date, format="%d/%m/%Y")

# subset the data
mydata <- data[data$Date<="2007-02-02" & data$Date>="2007-02-01",]

# form the datetime column by combining the Date and Time columns
mydata$datetime <- as.POSIXlt(paste(mydata$Date, mydata$Time))

# plot #2
png("plot2.png", width=480, height=480, units="px")

with(mydata, plot(datetime, Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)"))

dev.off()