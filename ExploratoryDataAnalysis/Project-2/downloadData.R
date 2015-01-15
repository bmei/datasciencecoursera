# Downlad data file & upzip it

dataFile_zp <- "exdata-data-NEI_data.zip"

if (!file.exists(dataFile_zp)) {
    URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(url=URL, destfile=dataFile_zp)
}

if (!file.exists("Source_Classification_Code.rds") || !file.exists("summarySCC_PM25.rds")) {
    unzip(dataFile_zp)
}
