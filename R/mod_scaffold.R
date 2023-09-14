#' scaffold UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_scaffold_ui <- function(id){
  ns <- NS(id)
  tagList(
      uiOutput(ns("scaffold"), height = 250),
      actionButton(
        inputId = ns("build_scaffold"),
        label = "Build Scaffold"),
      uiOutput(ns("add_sample"))
  )
}

#' scaffold Server Functions
#'
#' @noRd
mod_scaffold_server <- function(id, r){
    moduleServer( id, function(input, output, session){
        ns <- session$ns
        # Build scaffold ----
        observeEvent(input$build_scaffold, {
            # r$build_scaffold <- input$build_scaffold
            r$scaffold <- spaceRAT::buildScaffold(
                r$space,
                classes = r$classes,
                data = r$data,
                add_umap = FALSE
                # annotation = r$annotation
                # pheno = r$scaf_pheno,
                # colname = r$scaf_colname
                )
            })


        # Scaffold plot ----
    observeEvent({r$scaffold; input$build_scaffold; r$interactive}, {

      if(is(r$scaffold, "NULL")) {
        output$scaffold <- renderUI({NULL})
      }else{
          scaffold_plot <- reactive({
              spaceRAT::plotScaffold(
                  space = r$scaffold,
                  # title = r$scaffold_title,
                  plot_mode = r$plot_mode,
                  # dims = r$dims,
                  # dim_reduction = "PCA"
              )
          })
          if(r$interactive){
              output$scaffold <- renderUI({
                  plotly::ggplotly(scaffold_plot())
              })
          } else{
              output$scaffold <- renderUI({
                  renderPlot({scaffold_plot()})
              })
          }

      }
    })
        # Add sample ----
        observeEvent({r$sample_exprs; r$scaffold}, {
            if(is(r$scaffold, "NULL") | is(r$sample_exprs, "NULL")){
                output$add_sample <- renderUI({NULL})
            } else{
                output$add_sample <- renderUI({
                    actionButton(
                        inputId = ns("plot_sample"),
                        label = "Plot sample")
                })
            }
        })
        # Plot sample ----
        observeEvent({input$plot_sample; r$interactive}, {
            r$plot_sample <- input$plot_sample
            if(is(r$scaffold, "NULL")){
                output$add_sample <- renderUI({NULL})
            } else{
                sample_plot <- reactive({
                    spaceRAT::projectSample(
                        space = r$scaffold,
                        sample = r$sample_exprs,
                        pheno = r$sample_pheno,
                        colname = r$colname,
                        title = r$title
                    )
                })
                if(r$interactive){
                    output$scaffold <- renderUI({
                        plotly::ggplotly(sample_plot())
                    })
                } else{
                    output$scaffold <- renderUI({
                        renderPlot({sample_plot()})
                    })
                }
            }
        })
  })
}

## To be copied in the UI
# mod_scaffold_ui("scaffold_1")

## To be copied in the server
# mod_scaffold_server("scaffold_1")
