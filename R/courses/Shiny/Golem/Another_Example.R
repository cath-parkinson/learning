mod_dataviz_ui <- function(
  id, 
  type = c("point", "hist", "boxplot", "bar")
) 
{
  # Setting a header with the specified type of graph
  h4(
    sprintf( "Create a geom_%s", type )
  ),
  # [ ... ]
  # We want to allow a coord_flip only with barplots
  if (type == "bar"){
    checkboxInput(
      ns("coord_flip"),
      "coord_flip"
    )
  }, 
  # [ ... ]
  # We want to display the bins input only 
  # when the type is histogram
  if (type == "hist") {
    numericInput(
      ns("bins"), 
      "bins", 
      30, 
      1, 
      150,
      1
    )
  },
  # [ ... ]
  # The title input will be added to the graph 
  # for every type of graph
  textInput(
    ns("title"),
    "Title",
    value = ""
  )
}