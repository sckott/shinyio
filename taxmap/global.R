maprcharts <- function(data, popup = TRUE, map_provider = 'MapQuestOpen.OSM', 
  map_zoom = 3, height = 600, width = 870, palette_color = "Blues", 
  centerview = c(30, -73.90), fullscreen = TRUE, path = NULL)
{
  spplist <- as.character(unique(data$name))
  datl <- apply(data, 1, as.list)
  
  # colors
  mycolors <- get_colors(spplist, palette_name=get_palette(palette_color))
  if(length(mycolors) > length(spplist))
    mycolors <- mycolors[1:length(spplist)]
  mycolors_df <- data.frame(taxon=spplist, color=mycolors)
  
  # Add fill color for points
  out_list2 <- lapply(datl, function(x){ 
    x$fillColor = mycolors_df[as.character(mycolors_df$taxon) %in% x$name, "color"]
    x
  })
  
  # popup
  if(popup)
    out_list2 <- lapply(out_list2, function(l){
      l$popup = paste(paste("<b>", names(l), ": </b>", l, "<br/>"), collapse = '\n')
      return(l)
    })
  out_list2 <- Filter(function(x) !is.na(x$decimalLatitude), out_list2)
  geojson <- spocc_rcharts_togeojson(out_list2, lat = 'decimalLatitude', lon = 'decimalLongitude')
  
  L1 <- Leaflet$new()
  L1$tileLayer(provider = map_provider, urlTemplate = NULL)
  L1$set(height = height, width = width)
  L1$setView(centerview, map_zoom)
  L1$geoJson(geojson, 
             onEachFeature = '#! function(feature, layer){
             layer.bindPopup(feature.properties.popup || feature.properties.taxonName)
            } !#',
             pointToLayer =  "#! function(feature, latlng){
             return L.circleMarker(latlng, {
             radius: 4,
             fillColor: feature.properties.fillColor || 'red',    
             color: '#000',
             weight: 1,
             fillOpacity: 0.8
             })
             } !#"
  )
  L1$fullScreen(fullscreen)
  if(!length(spplist) < 2)
    L1$legend(
      position = 'bottomright',
      colors = get_colors(spplist, get_palette(palette_color)),
      labels = spplist
    )
  if(!is.null(path))
    L1$save(path)
  else
    L1
}

#' Get palette actual name from longer names
#' @param list_ A list
#' @param lat Latitude name
#' @param lon Longitude name
#' @export
#' @keywords internal
spocc_rcharts_togeojson <- function(list_, lat = 'decimalLatitude', lon = 'decimalLongitude'){
  x = lapply(list_, function(l){
    if (is.null(l[[lat]]) || is.null(l[[lon]])){
      return(NULL)
    }
    list(
      type = 'Feature',
      geometry = list(
        type = 'Point',
        coordinates = as.numeric(c(l[[lon]], l[[lat]]))
      ),
      properties = l[!(names(l) %in% c(lat, lon))]
    )
  })
  setNames(Filter(function(x) !is.null(x), x), NULL)
}

#' Get colors from a vector of input taxonomic names, and palette
#' @param vec Vector of strings
#' @param palette_name Palette name
#' @export
#' @keywords internal
get_colors <- function(vec, palette_name){
  num_colours <- length(unique(vec))
  brewer.pal(max(num_colours, 3), palette_name)
}

#' Get palette actual name from longer names
#' @param userselect User input
#' @export
get_palette <- function(userselect){
  colours_ <- data.frame(
    actual=c("Blues","BuGn","BuPu","GnBu","Greens","Greys","Oranges","OrRd","PuBu",
             "PuBuGn","PuRd","Purples","RdPu","Reds","YlGn","YlGnBu","YlOrBr","YlOrRd",
             "BrBG","PiYG","PRGn","PuOr","RdBu","RdGy","RdYlBu","RdYlGn","Spectral"),
    choices=c("Blues","BlueGreen","BluePurple","GreenBlue","Greens","Greys","Oranges","OrangeRed",
              "PurpleBlue","PurpleBlueGreen","PurpleRed","Purples",
              "RedPurple","Reds","YellowGreen","YellowGreenBlue","YellowOrangeBrown","YellowOrangeRed",
              "BrownToGreen","PinkToGreen","PurpleToGreen","PurpleToOrange","RedToBlue","RedToGrey",
              "RedYellowBlue","RedYellowGreen","Spectral"))
  as.character(colours_[colours_$choices %in% userselect, "actual"])
}

#' Palettes to use with maprcharts function
#' @export
palettes <- function(){
  c("Blues","BlueGreen","BluePurple","GreenBlue","Greens","Greys","Oranges","OrangeRed",
    "PurpleBlue","PurpleBlueGreen","PurpleRed","Purples",
    "RedPurple","Reds","YellowGreen","YellowGreenBlue","YellowOrangeBrown","YellowOrangeRed",
    "BrownToGreen","PinkToGreen","PurpleToGreen","PurpleToOrange","RedToBlue","RedToGrey",
    "RedYellowBlue","RedYellowGreen","Spectral")
}

#' Base maps to use with maprcharts function
#' @export
basemaps <- function(){
  c("OpenStreetMap.Mapnik","OpenStreetMap.BlackAndWhite","OpenStreetMap.DE","OpenCycleMap",
    "Thunderforest.OpenCycleMap","Thunderforest.Transport","Thunderforest.Landscape",
    "MapQuestOpen.OSM","MapQuestOpen.Aerial","Stamen.Toner","Stamen.TonerBackground",
    "Stamen.TonerHybrid","Stamen.TonerLines","Stamen.TonerLabels","Stamen.TonerLite",
    "Stamen.Terrain","Stamen.Watercolor","Esri.WorldStreetMap","Esri.DeLorme",
    "Esri.WorldTopoMap","Esri.WorldImagery","Esri.WorldTerrain","Esri.WorldShadedRelief",
    "Esri.WorldPhysical","Esri.OceanBasemap","Esri.NatGeoWorldMap","Esri.WorldGrayCanvas",
    "Acetate.all","Acetate.basemap","Acetate.terrain","Acetate.foreground","Acetate.roads",
    "Acetate.labels","Acetate.hillshading") 
}