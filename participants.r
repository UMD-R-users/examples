# build a function to evaluate each participant

test <- function(record) {
  
  numRecords <- sum(data$participant == record)

  if (numRecords == 1) { 
    # do nothing
  }

  # evaluate all participants that have more than 1 record
  
  else {

    # get information about sessions
    numSessions <- length(unique(data$session[data$participant == record]))
    sessionIds <- data$session[data$participant == record]
      
    # get information about recording times
    numTimes <- length(unique(data$recording[data$participant == record]))
 
    sessionTimes <- data$recording[which(data$session %in% sessionIds)]
    
    
    # build report
    writeLines(paste("Participant", record))
    writeLines(paste("Number of unique sessions:", numSessions))
    writeLines(paste("Number of unique recording times:", numTimes))
    writeLines(paste("Session id:", sessionIds, "-- recorded at:", sessionTimes))
    cat("\n")

  }
}

# dummy data

data <- data.frame(participant = c(20222, 20222, 20329, 20345, 20345), session = c(11111, 11112, 23456, 22223, 22223), recording = c(10.02, 10.03, 11.25, 12.08, 12.09))

# loop over each unique participant and save the results to a text file

sink("report.txt", append = TRUE)

for (participant in (unique(data$participant))) {
  
  test(participant)
}

sink()
