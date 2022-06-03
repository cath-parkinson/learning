df <- dplyr::tibble(fruit = c("Apples", "Pears", "Bananas", "Apples", "Pears", "Bananas"),
             metric = c("METRIC 1", "METRIC 1", "METRIC 1", "METRIC 1 - METRIC 2", "METRIC 1 - METRIC 2", "METRIC 1 - METRIC 2"),
             value = c(1000, 2000, 3000, 2000, 3000, 3000))

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

myplotly <- plotly::ggplotly(myplot)
myplotly

# Move yaxis down to make room
myplotly$x$layout$yaxis$range <- c(0.4, 4.2) # Original is c(0.4, 3.6)

# Extend facet shapes down into the space
myplotly$x$layout$shapes[[2]]$y0 <- -15
myplotly$x$layout$shapes[[4]]$y0 <- -15

# Move labels down to centre in the nearly extended shape
myplotly$x$layout$annotations[[1]]$y <- 0.96 #if only 1 line we move less
myplotly$x$layout$annotations[[2]]$y <- 0.9 # if /n is present we move more

fix_plotly(myplotly)

# Fix ggplotly facet_grid labels
fix_plotly <- function(plotly_obj){
    
  # Always adding 0.6 to the top of the yaxis range to make room for shape
  plotly_obj$x$layout$yaxis$range[2] <- plotly_obj$x$layout$yaxis$range[2] +  0.6
  
  # Extend shapes down (assumes there are two)
  plotly_obj$x$layout$shapes[[2]]$y0 <- -15
  plotly_obj$x$layout$shapes[[4]]$y0 <- -15
  
  # Move text down (assumes there are two)
  facet1_text <- plotly_obj$x$layout$annotations[[1]]$text
  if(grepl("\\n", facet1_text)){ plotly_obj$x$layout$annotations[[1]]$y <- 0.9 } 
  else { plotly_obj$x$layout$annotations[[1]]$y <- 0.96 }
  
  facet2_text <- plotly_obj$x$layout$annotations[[2]]$text
  if(grepl("\\n", facet2_text)){ plotly_obj$x$layout$annotations[[2]]$y <- 0.9 } 
  else { plotly_obj$x$layout$annotations[[2]]$y <- 0.96 }
  
  return(plotly_obj)
}


