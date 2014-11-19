library("shiny")
library("plotly")
library("ggplot2")

shinyServer(function(input, output) {
  output$text <- renderText({
    ggiris <- qplot(Petal.Width, Sepal.Length, data=iris, color=Species)
    py <- plotly("RgraphingAPI", "ektgzomjbx")
    res <- py$ggplotly(ggiris)
    iframe <- paste("<iframe height=\"600\" id=\"igraph\" scrolling=\"no\" seamless=\"seamless\" src=\"", 
          res$response$url, "\" width=\"500\" frameBorder=\"0\"></iframe>", sep = "")
    iframe
  })
})
