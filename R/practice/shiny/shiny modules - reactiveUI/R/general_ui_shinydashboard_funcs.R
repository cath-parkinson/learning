# HELPER FUNCTIONS---------------- 

# this fixes a menuItem so it can hold content 

convertMenuItem <- function(mi,tabName) {
  mi$children[[1]]$attribs['data-toggle']="tab"
  mi$children[[1]]$attribs['data-value'] = tabName
  if(length(mi$attribs$class)>0 && mi$attribs$class=="treeview"){
    mi$attribs$class=NULL
  }
  mi
}

# stylise our own actionBtton

actionBttn_os <- function(inputId, 
                          label = NULL, 
                          icon = NULL, 
                          style = "material-flat",
                          color = "success", 
                          size = "md", 
                          block = FALSE,
                          no_outline = TRUE, 
                          my_additional_style = "") {
  value <- shiny::restoreInput(id = inputId, default = NULL)
  style <- match.arg(
    arg = style,
    choices = c("simple", "bordered", "minimal", "stretch", "jelly",
                "gradient", "fill", "material-circle", "material-flat",
                "pill", "float", "unite")
  )
  color <- match.arg(
    arg = color,
    choices = c("default", "primary", "warning", "danger", "success", "royal")
  )
  size <- match.arg(arg = size, choices = c("xs", "sm", "md", "lg"))
  
  tagBttn <- htmltools::tags$button(
    id = inputId, type = "button", class = "action-button bttn", `data-val` = value,
    class = paste0("bttn-", style), 
    class = paste0("bttn-", size),
    class = paste0("bttn-", color), list(icon, label),
    class = if (block) "bttn-block",
    class = if (no_outline) "bttn-no-outline",
    style = my_additional_style
  )
  shinyWidgets:::attachShinyWidgetsDep(tagBttn, "bttn")
}

# use action buttons as tab selectors

update_all <- function(x) {
  updateSelectInput(session, 
                    inputId = "tab",
                    choices = c("", "Patients", "Antimicrobial consumption", "Diagnostics", "Outcome"),
                    label = "",
                    selected = x
  )
}




