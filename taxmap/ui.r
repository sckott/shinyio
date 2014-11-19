library(shiny)
library(rCharts)

shinyUI(pageWithSidebar(
  
  headerPanel(title=HTML("TaxMap"), windowTitle="TaxMap"),

  sidebarPanel(
    
    wellPanel(
      HTML('<style type="text/css">
          .row-fluid .span4{width: 26%;}
         .leaflet {height: 600px; width: 830px;}
         </style>'),
      
#         <div class="row" align="center">
      HTML('
         <textarea type="text" id="url" rows="5" class="field span12" color="grey" value="http://www.plosone.org/article/info:doi/10.1371/journal.pone.0073192">http://www.plosone.org/article/info:doi/10.1371/journal.pone.0073192</textarea>
         <button type="submit" class="btn btn-primary">Submit</button>
     ')
    ),

    includeHTML('infomodal.html'),
#      </div>
  
    sliderInput("numplot", "No. species to plot", min=1, max=9, value=5, step=1),

    sliderInput("numocc", "No. occurrences per species", min=1, max=250, value=50, step=25),

    selectInput('provider', 'Select map provider for interactive map', 
            choices = c("OpenStreetMap.Mapnik","OpenStreetMap.BlackAndWhite","OpenStreetMap.DE","OpenCycleMap","Thunderforest.OpenCycleMap","Thunderforest.Transport","Thunderforest.Landscape","MapQuestOpen.OSM","MapQuestOpen.Aerial","Stamen.Toner","Stamen.TonerBackground","Stamen.TonerHybrid","Stamen.TonerLines","Stamen.TonerLabels","Stamen.TonerLite","Stamen.Terrain","Stamen.Watercolor","Esri.WorldStreetMap","Esri.DeLorme","Esri.WorldTopoMap","Esri.WorldImagery","Esri.WorldTerrain","Esri.WorldShadedRelief","Esri.WorldPhysical","Esri.OceanBasemap","Esri.NatGeoWorldMap","Esri.WorldGrayCanvas","Acetate.all","Acetate.basemap","Acetate.terrain","Acetate.foreground","Acetate.roads","Acetate.labels","Acetate.hillshading"),
            selected = 'MapQuestOpen.OSM'
    ),

    p("Uses scrapenames() function from taxize",
         "to get scientific names from the article at",
         "the URL your provide above.  The names are", 
         "output in the first tab, and the map on the",
         "map tab. Code at", a(href="https://github.com/sckott/shinyio", "https://github.com/sckott/shinyio", target="_blank"))
  ),

  mainPanel(
  tabsetPanel(
    tabPanel("Scientific names", dataTableOutput("table")),
    tabPanel("Map", mapOutput("plot"))
  ))
))