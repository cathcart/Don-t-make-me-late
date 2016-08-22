library(shiny)
library(ggplot2)
library(ggrepel)
source("helpers.R")
A <- read.csv("data/final.csv", skip=0, header=TRUE)
#A$date <- as.Date(paste(A$year,A$month, "1", sep="-"))
A$date <- as.Date(A$date)
mean_pect <- aggregate(x=A$pect_ontime, by=list(A$date), FUN=mean)
colnames(mean_pect) <- c("date","pect_ontime")

allairlines <- as.character(unique(A$airlines))

shinyServer(function(input, output) {
  
  output$plotUi <- renderUI({
    if (is.null(input$whichPlot))
      return()

    switch(input$whichPlot,
           "1" = fluidRow(column(12, sliderInput("month",
                             label = "Month to plot",
                             min = 1, max = 12, step = 1, value = 1)),
                          column(12, sliderInput("year",
                              label = "Year to plot",
                              min = 2010, max = 2015, step=1, value = 2015))
                  ),
           # 
           # sliderInput("year",
           #             label = "Year to plot",
           #             min = 2010, max = 2015, step=1, value = 2015),
           "2" = checkboxGroupInput("selectText", "Select the text you want", choices=allairlines, selected = "American Airlines Inc."),
           "3" = checkboxGroupInput("selectText", "Select the text you want", choices=allairlines, selected = c("American Airlines Inc.", "Hawaiian Airlines Inc.", "Alaska Airlines Inc.", "Spirit Air Lines"))
           
    )
  })
  
  output$plotSpot <- renderPlot({
    if (is.null(input$whichPlot))
      return()

    switch(input$whichPlot,
           "1" = plot_frac(A, input$month,input$year),
           "2" = plot_timeline(A, input$selectText, mean_pect),
           "3" = meanBarPlot(A, input$selectText)
    )
  })
  
})