#' loading UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_loading_ui <- function(id){
  ns <- NS(id)
  tagList(
      uiOutput(ns("loading"))#, height = 250)
  )
}

#' loading Server Functions
#'
#' @noRd
mod_loading_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observeEvent({r$scaffold; r$interactive}, {
        if(is(r$scaffold, "NULL")) {
            output$loading <- renderUI({NULL})
        }else{
            loading_plot <- spaceRAT::loadingPlot(
                scaffold = r$scaffold
                # dims = r$dims,
                # dim_reduction = "PCA"
                )
            if(r$interactive){
                output$loading <- renderUI({
                    plotly::ggplotly(loading_plot)
                    })
                } else{
                    output$loading <- renderUI({
                        renderPlot({loading_plot})
                    })
                }
        }})
        })
}


## To be copied in the UI
# mod_loading_ui("loading_1")

## To be copied in the server
# mod_loading_server("loading_1")
