#' welcome UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_welcome_ui <- function(id){
  ns <- NS(id)
  tagList(
      h1("Welcome to spaceRAT!"),
      actionBttn(
          inputId = ns("gospaceRAT"),
          label = "Start", style = "gradient")
  )
}

#' welcome Server Functions
#'
#' @noRd
mod_welcome_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observeEvent(input$gospaceRAT, {
        r$gospaceRAT <- input$gospaceRAT
        shinydashboard::updateTabItems(inputId = "projection", selected = "spaceRAT")
    })
  })
}

## To be copied in the UI
# mod_welcome_ui("welcome_1")

## To be copied in the server
# mod_welcome_server("welcome_1")
