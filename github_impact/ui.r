library(shiny)

# Define UI
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("Github ImpactStory report"),

  # Sidebar with controls
  sidebarPanel(
    wellPanel(
    h4(strong("ImpactStory Collection ID")),
    textInput(inputId="iid", label="Enter an ImpactStory collection ID for your GitHub account", value="d4npn7"),
    HTML("<br>"),
    HTML("<a href=\"http://impactstory.org/create\" target=\"blank\">If you don't already have a collection, enter your GitHub username here and grab the ID</a>"),
    HTML("<br><br>Orange bars (dark outlines) indicate significant activity for a given metric. Bars are only significant when a metric is above the 75th percentile and exceeds a minimum frequency. Orange bars indicate that the repository was highly discussed (tweets), highly cited (forks), and/or highly recommended (stars).")
      )),

  # Show the plot of the requested variable against mpg
  mainPanel(
    plotOutput("guessPlot")
  )
))
