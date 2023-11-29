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
      # actionButton(
      #   inputId = ns("build_scaffold"),
      #   label = "Build Scaffold"),
      # uiOutput(ns("add_sample"), inline = TRUE)
  )
}

#' scaffold Server Functions
#'
#' @noRd
mod_scaffold_server <- function(id, r){
    moduleServer( id, function(input, output, session){
        ns <- session$ns

        # Only build scaffold if classes are subset
        observeEvent({r$classes}, {
            if(!all(r$all_classes %in% r$classes)){
                r$scaffold <- spaceRAT::buildScaffold(
                        r$space,
                        classes = r$classes,
                        data = r$data,
                        # plot_mode = r$plot_mode,
                        add_umap = FALSE
                        # annotation = r$annotation
                        # pheno = r$scaf_pheno,
                        # colname = r$scaf_colname
                    )
                if(!r$add_sample) r$new_scaffold <- r$scaffold
            }

        })


        # Scaffold plot ----
    observeEvent({r$new_scaffold; r$interactive}, {

      if(is(r$new_scaffold, "NULL")) {
        output$scaffold <- renderUI({NULL})
      }else if(!r$add_sample){
          scaffold_plot <- reactive({
              spaceRAT::plotScaffold(
                  scaffold = r$new_scaffold,
                  # title = r$scaffold_title,
                  # plot_mode = r$plot_mode,
                  # dims = r$dims,
                  dimred = r$dimred
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
        waiter_hide()
    })

        # Plot sample ----
        observeEvent({r$add_sample; r$scaffold; r$interactive}, {
            # r$plot_sample <- input$plot_sample
            if(is(r$scaffold, "NULL")){# | is(input$plot_sample, "NULL")){
                output$scaffold <- renderUI({NULL})
            } else{


                # Ensures plot is not regenerated twice
                pheno <- reactive({
                    if(is(r$sample_pheno, "NULL") | is(r$sample_colname, "NULL")) NULL
                    else r$sample_pheno
                })
                colname <- reactive({
                    if(is(r$sample_pheno, "NULL") | is(r$sample_colname, "NULL")) NULL
                    else r$sample_colname
                })

                # Add sample to plot
                sample_plot <- reactive({
                    spaceRAT::projectSample(
                        scaffold = r$scaffold,
                        sample = r$sample_exprs,
                        pheno = pheno(),
                        colname = colname(),
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
