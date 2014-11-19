library("shiny")
library("taxize")
library("spocc")
library("rCharts")
library("plyr")
library("rgbif")
library("RColorBrewer")

shinyServer(function(input, output) {  
  url2 <- reactive({
    input$url
  })
  
  numoccs <- reactive({
    input$numocc
  })
  
  numplot <- reactive({
    input$numplot
  })
  
  getdata <- reactive({
    scrapenames(url2())
  })
  
  output$table <- renderDataTable({
    getdata()$data
#     getdata()$data[,c(1:4)]
  })
  
  makemapdata <- reactive({
    namesuniq <- unique(getdata()$data$scientificname)
    scinames <- namesuniq[sapply(namesuniq, function(x) length(strsplit(x, " ")[[1]]))==2]
    
    keys <- compact(sapply(scinames, function(x) name_backbone(x)$usageKey))
    occs <- occ_search(taxonKey=keys, hasCoordinate=TRUE, limit=numoccs())
    temp <- lapply(occs, "[[", "data")
    temp <- temp[sapply(temp, class)=="data.frame"]
    temp <- lapply(temp, function(x) { x$name <- x$name[1]; na.omit(x)} )
    df <- ldply(temp)
    df$name <- sapply(as.character(df$name), function(x){
      temp <- strsplit(x, " ")[[1]]
      if(length(temp)==1){
        temp
      } else
      {
        paste(temp[1:2], collapse=" ")
      }
    })
    
    sizen <- min(length(unique(df$name)), numplot())
    df[ df$name %in% sample(as.character(unique(df$name)), size=sizen), ]
  })
  
  output$plot <- renderMap({
    maprcharts(makemapdata(), map_provider=input$provider, map_zoom=2)
  })
})