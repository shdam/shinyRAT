#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinydashboard
#' @import shinydashboardPlus
#' @import shinyWidgets
#' @import waiter
#' @noRd
app_ui <- function(request) {
  tagList(useWaiter(),
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    dashboardPage(skin = "midnight",
        preloader = list(html = tagList(spin_1(), "Loading ...")),
        shinydashboardPlus::dashboardHeader(
          title = paste("SpaceRAT"),
          leftUi = tagList(
              div(textOutput(outputId = "version"), style = "padding: 12px 0;"),
              sidebarMenu(
                  id = "welcome",
                  menuItem(text = "Welcome!", tabName = "welcome", selected = TRUE)
                  ),
              sidebarMenu(
                  id = "projection",
                  menuItem(text = "Projection", tabName = "spaceRAT"))
          )),
        shinydashboardPlus::dashboardSidebar(id = "sidebar",
            mod_sidebar_ui("sidebar_1"), collapsed = FALSE, minified = FALSE
            ),
      dashboardBody(
          tabItems(
              tabItem(
                  tabName = "welcome",
                  mod_welcome_ui("welcome_1")),
              tabItem(
                  tabName = "spaceRAT",
                  mod_body_ui("body_1"))
              )
          )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(ext = "png"),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "shinyRAT"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
