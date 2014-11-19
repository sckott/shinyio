require("rCharts")
require("shiny")

shinyUI(navbarPage("TaxaViewer", id="nav",

  tabPanel("Classification",

    includeHTML('assets.html'),

#     textInput("spec", "Species", "Carpobrotus,Rosmarinus,Ageratina"),

#     HTML('<textarea id="spec" rows="3" cols="100" autofocus>Carpobrotus,Rosmarinus,Ageratina</textarea>'),
    absolutePanel(id = "controls", class = "modal", fixed = TRUE, draggable = TRUE,
      top = 60, left = "auto", right = 400, bottom = "auto",
      width = 330, height = "auto",
#       textInput("spec", "Species", "Carpobrotus,Rosmarinus,Ageratina")
      HTML('<textarea class="form-control" id="spec" rows="2" cols="100" autofocus>Carpobrotus,Rosmarinus,Ageratina</textarea>')
    ),

    dataTableOutput("rank_names")
  ),
  tabPanel("Downstream", includeHTML('childrenmodal.html'), dataTableOutput("children")),
  tabPanel("Phylogeny", includeHTML('phylogenymodal.html'), plotOutput("phylogeny")),
  tabPanel("Map",

      absolutePanel(id = "controls", class = "modal", fixed = TRUE, draggable = TRUE,
            top = 60, left = "auto", right = 20, bottom = "auto",
            width = 330, height = "auto",

#             HTML('<textarea class="form-control" id="spec" rows="2" cols="100" autofocus>Carpobrotus,Rosmarinus,Ageratina</textarea>'),
            selectInput(inputId="datasource", label="Select data source", choices=c("ecoengine","gbif","inat","antweb"), selected="ecoengine"),
            # number of occurrences for map
            textInput(inputId="numocc", label="Select max. number of occurrences to search for per species", value=50),
            # color palette for map
            selectInput(inputId="palette", label="Select color palette",
              choices=c("Blues","BlueGreen","BluePurple","GreenBlue","Greens","Greys","Oranges","OrangeRed","PurpleBlue","PurpleBlueGreen","PurpleRed","Purples","RedPurple","Reds","YellowGreen","YellowGreenBlue","YlOrBr","YellowOrangeRed",
                        "BrownToGreen","PinkToGreen","PurpleToGreen","PurpleToOrange","RedToBlue","RedToGrey","RedYellowBlue","RedYellowGreen","Spectral"), selected="Blues"),
            selectInput('provider', 'Select map provider for interactive map',
              choices = c("OpenStreetMap.Mapnik","OpenStreetMap.BlackAndWhite","OpenStreetMap.DE","OpenCycleMap","Thunderforest.OpenCycleMap","Thunderforest.Transport","Thunderforest.Landscape","MapQuestOpen.OSM","MapQuestOpen.Aerial","Stamen.Toner","Stamen.TonerBackground","Stamen.TonerHybrid","Stamen.TonerLines","Stamen.TonerLabels","Stamen.TonerLite","Stamen.Terrain","Stamen.Watercolor","Esri.WorldStreetMap","Esri.DeLorme","Esri.WorldTopoMap","Esri.WorldImagery","Esri.WorldTerrain","Esri.WorldShadedRelief","Esri.WorldPhysical","Esri.OceanBasemap","Esri.NatGeoWorldMap","Esri.WorldGrayCanvas","Acetate.all","Acetate.basemap","Acetate.terrain","Acetate.foreground","Acetate.roads","Acetate.labels","Acetate.hillshading"),
              selected = 'MapQuestOpen.OSM')
           ),

           mapOutput('map_rcharts')),
  tabPanel("Papers",
           absolutePanel(id = "controls", class = "modal", fixed = TRUE, draggable = TRUE,
                         top = 60, left = "auto", right = 20, bottom = "auto",
                         width = 250, height = "auto",

                         textInput(inputId="paperlim", label="Number of papers to return", 10)
           ),

          htmlOutput('papers')
#           dataTableOutput('papers')
          )
))
