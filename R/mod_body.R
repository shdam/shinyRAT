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
      mod_scaffold_ui("scaffold_1"),
    ),
    box(
        title = "Add sample", solidHeader = TRUE,
        collapsible = TRUE, width = 5,
        mod_sample_files_ui("sample_files_1")
    )

  )
}

#' body Server Functions
#'
#' @noRd
mod_body_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_body_ui("body_1")

## To be copied in the server
# mod_body_server("body_1")
