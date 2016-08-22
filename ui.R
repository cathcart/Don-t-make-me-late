library(shiny)

# Rely on the 'WorldPhones' dataset in the datasets
# package (which generally comes preloaded).
#library(datasets)

# Define the overall UI
shinyUI(
  
  # Use a fluid Bootstrap layout
  fluidPage(    
    
    # Give the page a title
    titlePanel("Don't make me late - Fraction on time"),
    
    # Generate a row with a sidebar
    sidebarLayout(      
      
      # Define the sidebar with one input
      sidebarPanel(
        selectInput("whichPlot", label = h3("Which plot?"),
                     choices = list("Monthly plot" = 1, "Timeline plot" = 2, "Airline comparison" = 3), 
                     selected = 1),
        hr(),
        helpText("Pick which plot."),
        uiOutput("plotUi")
      ),
      
      # Create a spot for the barplot
      mainPanel(
        plotOutput("plotSpot")
        #textOutput("plotSpot")  
      )
      
    )
  )
)