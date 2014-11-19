rcharts_prep1 <- function(sppchar, occurrs, datasource){

  require("plyr")
  require("RColorBrewer")
  require("taxize")
  require("spocc")
  # prepare occurrence data
  species2 <- strsplit(sppchar, ",")[[1]]

  out <- occ(query = species2, from = datasource, gbifopts = list(hasCoordinate = TRUE), limit = occurrs)
  out <- fixnames(out, how = "query")
  out <- occ2df(out)
  names(out)[2:3] <- c("decimalLongitude","decimalLatitude")
  apply(out, 1, as.list)

#   if(datasource=="GBIF"){
#     library("spocc")
# #     require(rgbif)
# #     out <- occ_search(scientificName = species2, hasCoordinate = TRUE, limit = occurrs)
# #     out$taxonName <- capwords(out$taxonName, onlyfirst=TRUE)
#     out <- occ(query = species2, gbifopts = list(hasCoordinate = TRUE), limit = occurrs)
#     out <- fixnames(out, how = "query")
#     out <- occ2df(out)
# #     out <- out[,c("taxonName","county","decimalLatitude","decimalLongitude",
# #                   "institutionCode","collectionCode","catalogNumber","basisOfRecordString","collector")]
#     apply(out, 1, as.list)
#   } else
#   {
#     require(rbison); require(doMC)
#     registerDoMC(cores=4)
#     hh <- llply(species2, function(x){
#       temp <- bison_data(bison(x, count = occurrs), "data_list")
#       llply(temp, function(x){
#         names(x)[2:4] <- c("taxonName","decimalLongitude","decimalLatitude")
#         x$taxonName <- capwords(x$taxonName, onlyfirst=TRUE)
#         x
#       })
#     }, .parallel=TRUE)
#     do.call(c,hh)
#   }
}

get_colors <- function(vec, palette_name){
  num_colours <- length(unique(vec))
  brewer.pal(max(num_colours, 3), palette_name)
}

rcharts_prep2 <- function(out, palette_name, popup = FALSE){
  require("rgbif")

  # colors
  uniq_name_vec <- unique(sapply(out, function(x) x[["name"]]))
  mycolors <- get_colors(uniq_name_vec, palette_name)
  mycolors_df <- data.frame(taxon=uniq_name_vec, color=mycolors, stringsAsFactors = FALSE)

  out_list2 <- llply(out, function(x){
    x$fillColor = mycolors_df[mycolors_df$taxon %in% x$name, "color"]
    x
  })

  # popup
  if(popup)
    out_list2 <- lapply(out_list2, function(l){
      l$popup = paste(paste("<b>", names(l), ": </b>", l, "<br/>"), collapse = '\n')
      return(l)
    })
  out_list2 <- Filter(function(x) !is.na(x$decimalLatitude), out_list2)
  toGeoJSON(out_list2, lat = 'decimalLatitude', lon = 'decimalLongitude')
}

toGeoJSON <- function(list_, lat = 'latitude', lon = 'longitude'){
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

gbifmap2 <- function(input_data, map_provider = 'MapQuestOpen.OSM', map_zoom = 3, height = 800, width = "100%"){
  require(rCharts)
  L1 <- Leaflet$new()
  L1$tileLayer(provider = map_provider, urlTemplate = NULL)
  L1$set(height = height, width = width)
  L1$setView(c(30, -73.90), map_zoom)
  L1$geoJson(input_data,
             onEachFeature = '#! function(feature, layer){
             layer.bindPopup(feature.properties.popup || feature.properties.name)
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
  L1$fullScreen(TRUE)
  return(L1)
}

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
