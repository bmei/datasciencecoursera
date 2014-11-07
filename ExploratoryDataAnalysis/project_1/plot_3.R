library(data.table)
library(lubridate)

# get column classes to speed up data file reading
tab5rows <- fread("household_power_consumption.txt", sep=";", header=TRUE, nrows=5, stringsAsFactors=FALSE, na.strings="?")
classes <- sapply(tab5rows, class)

# read all data
DF <- read.table("household_power_consumption.txt", sep=";", header=TRUE, stringsAsFactors=FALSE, na.strings="?", colClasses=classes)
DT <- data.table(DF)
DF = NULL           # free up some space

# slice the data to get the target ones
setkey(DT, Date)
myDT <- DT[c("1/2/2007","2/2/2007")]

# change the class and format of Date
myDT$Date <- as.Date(myDT$Date, "%d/%m/%Y")

# form the datetime column by combining the Date and Time columns
# then use the ymd_hms() function in the lubridate package to convert the class of datetime
myDT[, datetime:=ymd_hms(paste(myDT$Date, myDT$Time, sep=" "))]

# plot #3
png("plot_3.png", width=480, height=480, units="px")
x_range <- range(myDT$datetime)
y_range <- range(myDT$Sub_metering_1, myDT$Sub_metering_2, myDT$Sub_metering_3)
plot(x_range, y_range, type="n", xlab="", ylab="Energy sub metering")
with(myDT, lines(datetime, Sub_metering_1, col="black"))
with(myDT, lines(datetime, Sub_metering_2, col="red"))
with(myDT, lines(datetime, Sub_metering_3, col="blue"))
legend("topright", legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=c("black","red","blue"), lty=1)
dev.off()