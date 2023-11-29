#' body UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_body_ui <- function(id){
  ns <- NS(id)
  tagList(
    box(
      title = "Scaffold space", solidHeader = TRUE,
      collapsible = TRUE, width = 10,
      mod_scaffold_ui("scaffold_1")
    ),
    # box(
    #     title = "Add sample", solidHeader = TRUE,
    #     collapsible = TRUE, width = 2,
    #     mod_sample_files_ui("sample_files_1")
    # ),
    box(
        title = "Gene contribution plot", solidHeader = TRUE,
        collapsible = TRUE, width = 10, collapsed = TRUE,
        mod_loading_ui("loading_1")
    ),
    box(
        title = "Scaffold description", solidHeader = TRUE,
        collapsible = TRUE, width = 10, collapsed = TRUE,
        mod_info_ui("info_1")
    ),
    uiOutput(ns("prediction_table"))

  )
}

#' body Server Functions
#'
#' @noRd
mod_body_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    observeEvent(r$expr, {
        box(
            title = "Prediction table", solidHeader = TRUE,
            collapsible = TRUE, width = 10, collapsed = TRUE,
            mod_prediction_ui("prediction_1")
        )
    })
  })
}

## To be copied in the UI
# mod_body_ui("body_1")

## To be copied in the server
# mod_body_server("body_1")
