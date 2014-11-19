library(shiny)
library(plyr)
library(rImpactStory)
library(ggplot2)

# Define server logic required to plot various variables
shinyServer(function(input, output) {


  output$guessPlot <- reactivePlot(function() {
    df <- github_report(input$iid, key = "RAM4008f900")
    p1 <- github_plot(df)
    print(p1, height="8", width="4")
    
  })

})
