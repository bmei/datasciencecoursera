# read data
data <- read.table("household_power_consumption.txt", sep=';', header=TRUE, na.string='?')

# change the class and format of Date
data$Date <- as.Date(data$Date, format="%d/%m/%Y")

# subset the data
mydata <- data[data$Date<="2007-02-02" & data$Date>="2007-02-01",]

# form the datetime column by combining the Date and Time columns
mydata$datetime <- as.POSIXlt(paste(mydata$Date, mydata$Time))

# plot #4
png("plot4.png", width=480, height=480, units="px")

par(mfrow=c(2,2))             # all plots on one page

with(mydata, {
     plot(datetime, Global_active_power, type="l", xlab="", ylab="Global Active Power")
     plot(datetime, Voltage, type="l")
})

x_range <- range(mydata$datetime)
y_range <- range(mydata$Sub_metering_1, mydata$Sub_metering_2, mydata$Sub_metering_3)

plot(x_range, y_range, type="n", xlab="", ylab="Energy sub metering")

with(mydata, {
     lines(datetime, Sub_metering_1, col="black")
     lines(datetime, Sub_metering_2, col="red")
     lines(datetime, Sub_metering_3, col="blue")
})

legend("topright", legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=c("black","red","blue"), lty=1, bty = "n")

with(mydata, plot(datetime, Global_reactive_power, type="l"))

dev.off()