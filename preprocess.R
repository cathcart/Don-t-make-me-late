preparse <- function(mydate){
  month <- format(mydate,"%m")
  year <- format(mydate,"%Y")
  fn <- "./data/UNIQUE_CARRIERS.csv"
  LUT <- read.csv(fn, skip=0, header=TRUE)
  LUT$Code <- as.character(LUT$Code)
  LUT$Description <- as.character(LUT$Description)
  
  fn <- paste("./data/", paste(month, paste(year,"csv", sep="."), sep="-"), sep="")
  A <- read.csv(fn, skip=0, header=TRUE)
  A <- A[,-ncol(A)]
  
  new <- aggregate(x=A$ARR_DEL15, by=list(A$UNIQUE_CARRIER), FUN=sum, na.rm=TRUE)
  colnames(new) <- c("UNIQUE_CARRIER", "NUM_DELAYED")
  new$cancelled <- aggregate(x=A$CANCELLED, by=list(A$UNIQUE_CARRIER), FUN=sum)$x
  new$total <- aggregate(x=A$ARR_DEL15, by=list(A$UNIQUE_CARRIER), FUN=length)$x
  new$pect_ontime <- 1 - new$NUM_DELAYED/(new$total - new$cancelled)
  
  airlines <- c()
  for(i in new$UNIQUE_CARRIER){
    ans <- LUT$Description[LUT$Code==i]
    #this is to remove the weird NA which appear, not sure why
    des <- ans[!is.na(ans)]
    airlines <- c(airlines, des)
  }
  new$airlines <- airlines
  new$month <- rep(month,length(airlines))
  new$year <- rep(year,length(airlines))
  return(new)
  return(new[,c("UNIQUE_CARRIER","airlines", "pect_ontime", "year", "total", "cancelled", "month")])
}

mymonths <- seq(as.Date("2010-01-01"), by = "month", length.out = 72)
results <- lapply(mymonths, preparse)

final <- Reduce(function(x, y) rbind(x, y), results)

final$date <- as.Date(paste(final$year,final$month, "1", sep="-"))

mean_pect <- aggregate(x=final$pect_ontime, by=list(final$date), FUN=mean)
colnames(mean_pect) <- c("date","pect_ontime")

meanCount <- function(air, mean_pect, A){
  B <- A[A$airlines %in% air,]
  C <- B$pect_ontime - mean_pect[,2]
  return(sum(C>=0))
}

alt <- lapply(final$airlines, meanCount, mean_pect, final)
final$num_above <- unlist(alt)

meanCount2 <- function(air, mean_pect, A){
  B <- A[A$airlines %in% air,]
  C <- B$pect_ontime - mean_pect[,2]
  return(sum(C>=0)/(sum(C>=0)+sum(C<0)))
}

alt2 <- lapply(final$airlines, meanCount2, mean_pect, final)
final$num_above2 <- unlist(alt2)

write.csv(final, file = "./data/final.csv", row.names = F)
