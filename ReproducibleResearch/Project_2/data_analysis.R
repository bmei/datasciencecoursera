setwd("C:\\Bing Files\\Coursera\\Data Science Specialization\\5_Reproducible Research\\homework 2")

# read data
if (!"stormData" %in% ls()) {
    stormData <- read.csv(bzfile("repdata-data-StormData.csv.bz2"))
}
dim(stormData)

head(stormData, n = 2)

unique(stormData$EVTYPE)

# convert literal exp values to numeric
converter <- function (data = stormData, field, new_field) {
    col_idx <- which(colnames(data) == field)
    
    data[, col_idx] <- as.character(data[, col_idx])
    data[toupper(data[, col_idx]) == "B", col_idx] <- "9"
    data[toupper(data[, col_idx]) == "M", col_idx] <- "6"
    data[toupper(data[, col_idx]) == "K", col_idx] <- "3"
    data[toupper(data[, col_idx]) == "H", col_idx] <- "2"
    data[toupper(data[, col_idx]) %in% c("-","+","?",""), col_idx] <- "0"
    data[, col_idx] <- as.numeric(data[, col_idx])
    
    # add a new field to store real dollar values
    data <- cbind(data, data[, col_idx - 1] * 10 ^ data[, col_idx])
    colnames(data)[dim(data)[2]] <- new_field
    
    return(data)
}

if (dim(stormData)[2] == 37) {
    stormData <- converter(stormData, "PROPDMGEXP", "PROPDMGVAL")
    stormData <- converter(stormData, "CROPDMGEXP", "CROPDMGVAL")
}

## Main Task Now
processor <- function(data = stormData, subj.field, by.field, evregex) {
    subj_idx <- which(colnames(data) == subj.field)
    by_idx <- which(colnames(data) == by.field)
  
    # subset data - only keep those with non-zero number of events for the subject
    data2 <- data[data[, subj_idx] > 0, ]
    
    # aggregate data before regexing event types for computing efficiency
    aggregDF <- aggregate(data2[, subj_idx] ~ data2[, by_idx], data = data2, FUN = sum)
    
    # add a new field to store cleaned EVTYPE using regex, with intial value set to "Unassigned"
    aggregDF$CLEANEV <- "Unassigned"
    
    # regex now
    for (i in 1:nrow(evregex)) {
        selector <- grepl(evregex[, 2][i], aggregDF[, 1], ignore.case=T)
        
        if (any(selector)) {
            aggregDF[selector, ]$CLEANEV = evregex[, 1][i]
        }
    }  
    
    # aggreage the aggregated table again based on same cleanev values due to regexing
    aggregDF2 <- aggregate(aggregDF[, 2] ~ aggregDF[, 3], data = aggregDF, FUN = sum)
    
    # sort the final table by the number of subjects descendingly
    aggregDF2 <- aggregDF2[order(-aggregDF2[, 2]), ]
    
    # reset column and row names
    colnames(aggregDF2) <- c("CLEANEV", subj.field)
    rownames(aggregDF2) <- 1 : nrow(aggregDF2)
    
    # remove rows with CLEANEV = Unassigned
    aggregDF2 <- aggregDF2[aggregDF2$CLEANEV != "Unassigned", ]
    
    # return the sorted data frame
    return(aggregDF2)
}

evregex <- read.csv("regex for storm data.csv", header=T, colClasses=c("character", "character"))

fatalities <- processor(stormData, "FATALITIES", "EVTYPE", evregex)
injuries <- processor(stormData, "INJURIES", "EVTYPE", evregex)
propdamages <- processor(stormData, "PROPDMGVAL", "EVTYPE", evregex)
cropdamages <- processor(stormData, "CROPDMGVAL", "EVTYPE", evregex)

head(fatalities, n=10)
head(injuries, n=10)
head(propdamages, n=10)
head(cropdamages, n=10)

# plot now
library(ggplot2)
library(gridExtra)

fatalityPlot <- ggplot(data = head(fatalities, n=10), 
                       aes(x = reorder(CLEANEV, order(FATALITIES, decreasing = TRUE)), y = FATALITIES)) +
                geom_bar(stat = "identity", width = 0.8) +
                labs(y = "Total number of fatalities", x = "Weather Event Type",
                     title = "Top 10 Fatalities by Weather Event Types \n in the US from 1950 - 2011") +
                theme(legend.position="none", axis.text.x=element_text(angle=45, hjust=1, size=11), 
                      axis.text.y=element_text(size=11), plot.title=element_text(size=13))

injuryPlot <- ggplot(data = head(injuries, n=10), 
                     aes(x = reorder(CLEANEV, order(INJURIES, decreasing = TRUE)), y = INJURIES)) +
              geom_bar(stat = "identity", width = 0.8) +
              labs(y = "Total number of injuries", x = "Weather Event Type",
                   title = "Top 10 Injuries by Weather Event Types \n in the US from 1950 - 2011") +
              theme(legend.position="none", axis.text.x=element_text(angle=45, hjust=1, size=11), 
                    axis.text.y=element_text(size=11), plot.title=element_text(size=13))

grid.arrange(fatalityPlot, injuryPlot, ncol = 2)

propdmgPlot <- ggplot(data = head(propdamages, n=10), 
                      aes(x = reorder(CLEANEV, order(PROPDMGVAL, decreasing = TRUE)), y = PROPDMGVAL)) +
               geom_bar(stat = "identity", width = 0.8) +
               labs(y = "Property damages in UD dollars", x = "Weather Event Type",
               title = "Top 10 Property Damages by Weather Event Types \n in the US from 1950 - 2011") +
               theme(legend.position="none", axis.text.x=element_text(angle=45, hjust=1, size=11), 
                     axis.text.y=element_text(size=11), plot.title=element_text(size=13))

cropdmgPlot <- ggplot(data = head(cropdamages, n=10), 
                      aes(x = reorder(CLEANEV, order(CROPDMGVAL, decreasing = TRUE)), y = CROPDMGVAL)) +
               geom_bar(stat = "identity", width = 0.8) +
               labs(y = "Crop damages in UD dollars", x = "Weather Event Type",
                    title = "Top 10 Crop Damages by Weather Event Types \n in the US from 1950 - 2011") +
               theme(legend.position="none", axis.text.x=element_text(angle=45, hjust=1, size=11), 
                     axis.text.y=element_text(size=11), plot.title=element_text(size=13))

grid.arrange(propdmgPlot, cropdmgPlot, ncol = 2)
