# More complicated than I thought because it depends
# on how many rows there are

text0 <- "METRIC 1 - METRIC 2"
text0 <- "this text is"
text0 <- "this text is longer"
text0 <- "this text is even longer" # 1 \n
text0 <- "this text is even longer again woah" # 2 \n
text0 <- "this text is even longer than I would hope possible" # 3 \n


df <- dplyr::tibble(fruit = c("Apples", "Pears", "Bananas", "Apples", "Pears", "Bananas"),
             metric = c("METRIC 1", "METRIC 1", "METRIC 1", text0, text0, text0),
             value = c(1000, 2000, 3000, 2000, 3000, 3000))

df2 <- dplyr::tibble(fruit = c("Peach", "Grape", "Plum", "Peach", "Grape", "Plum"),
                    metric = c("METRIC 1", "METRIC 1", "METRIC 1", text0, text0, text0),
                    value = c(1000, 2000, 3000, 2000, 3000, 3000))

df3 <- dplyr::tibble(fruit = c("Peach1", "Grape1", "Plum1", "Peach1", "Grape1", "Plum1"),
                     metric = c("METRIC 1", "METRIC 1", "METRIC 1", text0, text0, text0),
                     value = c(1000, 2000, 3000, 2000, 3000, 3000))


df <- dplyr::bind_rows(df, df2, df3)

myplot <- ggplot2::ggplot(
  data = df,
  ggplot2::aes(x = fruit,
               y = value,
               fill = metric)) +
  ggplot2::geom_bar(stat = "identity")  +
  ggplot2::geom_abline(intercept = 0, slope = 0, lty = 2, color = "grey") +
  ggplot2::facet_grid(cols = ggplot2::vars(metric),
                      scales = "fixed",
                      labeller = ggplot2::label_wrap_gen(
                        width = 15,
                        multi_line = TRUE)
                      ) +
  ggplot2::coord_flip() +
  ggplot2::theme(
    text = ggplot2::element_text(size = 14,
                                 color = "#0D0D0D"),
    axis.title.x = ggplot2::element_blank(),
    axis.title.y = ggplot2::element_blank(),
    axis.text = ggplot2::element_text(color = "#0D0D0D"),
    axis.ticks = ggplot2::element_blank(),
    axis.title = ggplot2::element_text(face = "bold"),
    panel.background = ggplot2::element_blank(),
    plot.margin = ggplot2::unit(c(0, 0, 0, 0), units = "cm"),
    legend.position = "none"
    ,
    strip.text = ggplot2::element_text(lineheight = 2)
  )

myplot
myplotly

myplotly <- plotly::ggplotly(myplot)
fix_plotly(myplotly)

# 1 \n
myplotly$x$layout$yaxis$range <- c(0.4, 4.2) # Original is c(0.4, 3.6) - in units of the original chart
myplotly$x$layout$shapes[[2]]$y0 <- -15 # Original is 0 - maybe in pixels?
myplotly$x$layout$shapes[[4]]$y0 <- -15 # Original is 0
myplotly$x$layout$annotations[[1]]$y <- 0.96 #Original is 1 - proportion of the screen
myplotly$x$layout$annotations[[2]]$y <- 0.90 #Original is 1 

# 2 \n
myplotly$x$layout$yaxis$range <- c(0.4, 5) # Original is c(0.4, 3.6)
myplotly$x$layout$shapes[[2]]$y0 <- -35
myplotly$x$layout$shapes[[4]]$y0 <- -35
myplotly$x$layout$annotations[[1]]$y <- 0.91 #if only 1 line we move less
myplotly$x$layout$annotations[[2]]$y <- 0.75 # if /n is present we move more

# 3 \n
myplotly$x$layout$yaxis$range <- c(0.4, 6) # Original is c(0.4, 3.6)
myplotly$x$layout$shapes[[2]]$y0 <- -60
myplotly$x$layout$shapes[[4]]$y0 <- -60
myplotly$x$layout$annotations[[1]]$y <- 0.8 #if only 1 line we move less
myplotly$x$layout$annotations[[2]]$y <- 0.6 # if /n is present we move more

fix_plotly(myplotly)

# Works if there is 1 new line - for each multiple line we need to move every thing more

# Fix ggplotly facet_grid labels
fix_plotly <- function(plotly_obj){
  
  # Identify max number of \n
  facet1_count <- stringr::str_count(plotly_obj$x$layout$annotations[[1]]$text, "\\n")
  facet2_count <- stringr::str_count(plotly_obj$x$layout$annotations[[2]]$text, "\\n")
  
  n <- max(facet1_count, facet2_count)
  
  if(n < 1) { return(plotly_obj) } 
  else {
    
    range_ymax_shift <- n*(n + 5)/10 
    
  }
  
    # Always adding 0.6 to the top of the yaxis range to make room for shape
  plotly_obj$x$layout$yaxis$range[2] <- plotly_obj$x$layout$yaxis$range[2] + range_ymax_shift
  
  # Extend shapes down (assumes there are two)
  plotly_obj$x$layout$shapes[[2]]$y0 <- -20
  plotly_obj$x$layout$shapes[[4]]$y0 <- -20
  # 
  # # Move text down (assumes there are two)
  # facet1_text <- plotly_obj$x$layout$annotations[[1]]$text
  # if(grepl("\\n", facet1_text)){ plotly_obj$x$layout$annotations[[1]]$y <- 0.93 }
  # else { plotly_obj$x$layout$annotations[[1]]$y <- 0.97 }
  # # 
  # facet2_text <- plotly_obj$x$layout$annotations[[2]]$text
  # if(grepl("\\n", facet2_text)){ plotly_obj$x$layout$annotations[[2]]$y <- 0.93 }
  # else { plotly_obj$x$layout$annotations[[2]]$y <- 0.97 }
  # # 
  return(plotly_obj)
}


