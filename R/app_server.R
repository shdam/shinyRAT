#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import spaceRATScaffolds
#' @import spaceRAT
#' @import magrittr
#' @importFrom plotly ggplotly
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic

  r <- reactiveValues(warning = FALSE)
  r$session <- session

  # Stop app when window is closed
  session$onSessionEnded(function() {
    stopApp()
  })

  mod_sidebar_server("sidebar_1", r = r)
  mod_body_server("body_1", r = r)
  mod_scaffold_server("scaffold_1", r = r)
  mod_space_server("space_1", r = r)
  mod_sample_files_server("sample_files_1", r = r)
  mod_loading_server("loading_1", r = r)

}
