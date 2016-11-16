# Commands to convert SPSS PEEP-I-Ratings .sav file to R data frame and csv

path2data <- "analysis/data/"
spss.fn <- paste(path2data, "FINAL PEEP I Stimulus Identification task.sav", sep="")

library(foreign)
dataset = read.spss(spss.fn)

pid <- gsub(pattern=" ", replacement="", x=dataset$id)
pid <- rep(pid, 24)

awake.data.collected <- rep(dataset$Awake_Data_Collected, 24)

collected.run1 <- rep(dataset$Run1, 24)
collected.run2 <- rep(dataset$Run2, 24)

# Get ratings
s <- names(dataset)[6:29]

prosody <- rep(tolower(substr(s, 9, 11)), each=39)
script.num <- rep(substr(s, 7, 7), each=39)

# Length of names to extract last
l <- unlist(lapply(s, nchar))

rating.type <- rep(substr(s,l,l), 39) # H)appy, A)ngry
rating.type <- rep(c(rep(c("ang"), 39*4), rep(c("hap"), 39*4)),3)
ratings <- as.numeric(unlist(lapply(dataset[6:29], rbind)))

peep.I.ratings <- data.frame(pid=pid, awake.data.collected = awake.data.collected,
                             collected.run1 = collected.run1,
                             collected.run2 = collected.run2,
                             prosody = prosody,
                             script.num = script.num,
                             rating.type = factor(rating.type, labels = c("ang", "hap")),
                             ratings = ratings)

write.csv(x = peep.I.ratings, file=paste(path2data, "peep-I-ratings.csv", sep=""), row.names = FALSE)

