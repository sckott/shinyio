library("shiny")

shinyUI(pageWithSidebar(
  
  headerPanel(title=HTML("TaxMap"), windowTitle="TaxMap"),
  
  sidebarPanel(
    wellPanel("Hello")
  ),
  
  mainPanel(
    htmlOutput("text")
  )
))