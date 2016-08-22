plot_frac <- function(A, thismonth, thisyear){
  
  mydata <- subset(A, month==thismonth & year==thisyear)
  m <- mean(mydata$pect_ontime)
  
  p<-ggplot(mydata,aes(y = pect_ontime, x = UNIQUE_CARRIER)) +
    xlab("Airline") +
    ylab("Fraction of flights which arrived on time") +
    ggtitle(paste("Fraction of US domestic airline flights which arrived on time", paste(month.name[thismonth],thisyear),sep="\n")) +
    geom_text_repel(aes(label=airlines), size = 4) +
    geom_point(aes(color=pect_ontime)) +
    geom_hline(yintercept = m, linetype="dashed", color="grey") +
    geom_text(aes(1.25,m,label = sprintf("mean: %.2f",m)), vjust = -1, color="grey", size=3) +
    scale_colour_gradient(low="red", high="green", name="Fraction\nof flights\narrived on time")
  plot(p)
}

plot_timeline <- function(A, myairlines, mean_pect){
  
  B <- A[A$airlines %in% myairlines,]
  p<-ggplot(B, aes(x=date, y=pect_ontime, color=airlines)) +
    xlab("Date") +
    ylab("Fraction of flights which arrived on time") +
    ggtitle("Fraction of US domestic airline flights which arrived on time") +
    geom_point() +
    geom_line(data=mean_pect, aes(color="mean")) +
    scale_x_date(date_breaks = "6 month",  date_minor_breaks = "3 month", expand=c(0,0), date_labels = "%b %y")+
    scale_colour_manual(name="Airline", values=palette(c(rainbow(length(myairlines)+1),"black")))
  plot(p)
}

meanBarPlot <- function(A, air){
  B <- A[A$airlines %in% air,]
  ans <- aggregate(x=B$num_above2, by=list(B$airline), FUN=mean)
  colnames(ans) <- c("airline", "fraction_good")
  p<-ggplot(ans, aes(x=airline, y=fraction_good, fill="white")) +
    xlab("Airline") +
    ylab("Fraction of months in operation at or above the mean") +
    ggtitle("Fraction of months in operation at or above the total mean fraction of flights which arrived on time") +
    geom_bar(stat="identity") +
    coord_flip() +
    scale_fill_discrete(guide=FALSE) #+
    #geom_text(aes(label=airline), position=position_dodge(width=0.9), vjust=-0.5)
    #geom_text(aes(label=airline), position=position_dodge(width=0.9), vjust=-0.5, angle = 90)
  plot(p)
}
