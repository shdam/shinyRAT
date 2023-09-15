#' space UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_space_ui <- function(id){
  ns <- NS(id)
  tagList(
    selectInput(
      inputId = ns("space"),
      label = "Select space:",
      choices = c("dmap", "gtex", "other"),
      selected = "dmap"
    ),
    uiOutput(ns("noScaffold")),
  )
}

#' space Server Functions
#'
#' @noRd
mod_space_server <- function(id, r){
    moduleServer( id, function(input, output, session){
        ns <- session$ns
        observeEvent( input$space, {
            if(input$space == "dmap"){
                r$space <- "DMAP_scaffold"
                r$noScaffold <- renderUI({NULL})
                r$scaffold <- spaceRAT:::loadData("DMAP_scaffold")
                r$all_classes <- as.character(unique(r$scaffold$label))
                r$classes <- r$all_classes
                r$data <- "exprs"
                r$new_scaffold <- r$scaffold
            } else if(input$space == "gtex"){
                r$scaffold <- NULL
                r$new_scaffold <- NULL
                r$noScaffold <- renderUI({
                    p("Not yet implemented") %>%
                        tagAppendAttributes(class = 'msg')
                    })
            }else if(input$space == "other"){
                r$scaffold <- NULL
                r$new_scaffold <- NULL
                r$noScaffold <- renderUI({
                    p(style = "color:black;", "Not yet implemented") %>%
                        tagAppendAttributes(class = 'msg')
                })}
        })
        observeEvent( r$noScaffold, {
            output$noScaffold <- r$noScaffold
        })
    })
}

## To be copied in the UI
# mod_space_ui("space_1")

## To be copied in the server
# mod_space_server("space_1")
