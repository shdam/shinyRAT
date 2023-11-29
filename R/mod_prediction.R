#' prediction UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_prediction_ui <- function(id){
  ns <- NS(id)
  tagList(

  )
}

#' prediction Server Functions
#'
#' @noRd
mod_prediction_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_prediction_ui("prediction_1")

## To be copied in the server
# mod_prediction_server("prediction_1")
