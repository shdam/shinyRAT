#' sidebar UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_sidebar_ui <- function(id){
    ns <- NS(id)
    tagList(
        mod_space_ui("space_1"),
        # selectInput(
        #     inputId = ns("plot_mode"),
        #     label = "Plot mode",
        #     choices = c("dot", "tiny_label"),
        #     selected = "dot"
        # ) %>% tagAppendAttributes(class = "sidebar"),
        checkboxInput(
            inputId = ns("interactive"),
            label = "Interactive",
            value = TRUE),
    # selectInput(
    #     inputId = ns("annotation"),
    #     label = "Select annotation:",
    #     choices = c(
    #         "ensembl_gene", "ensembl_transcript",
    #         "refseq_mrna", "entrez", "hgnc_symbol"),
    #     selected = "ensembl_gene"
    # ),
    uiOutput(ns("dimred")),
    uiOutput(ns("classes")),
    mod_sample_files_ui("sample_files_1"),
    uiOutput(ns("pheno_colname")),
    uiOutput(ns("plot_title")),
    br(),
    uiOutput(ns("save")),
    textOutput(ns("plotname"))

  )
}

#' sidebar Server Functions
#'
#' @noRd
mod_sidebar_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # Allow large files
    options(shiny.maxRequestSize = 6000*1000^2) # 6 GB
    # Inputs ----
    # observeEvent( input$dimred, {
    #     r$dim_reduction <- input$dimred
    # })
    # observeEvent( input$annotation, {
    #     r$annotation <- input$annotation
    # })
    # observeEvent( input$plot_mode, {
    #   r$plot_mode <- input$plot_mode
    # })
    observeEvent( input$dimred, {
        r$dimred <- input$dimred
    })
    observeEvent( input$interactive, {
        r$interactive <- input$interactive
    })
    observeEvent( input$colname, {
        # Two versions to prevent double plotting
        r$sample_colname <- r$colname <- input$colname
    })

    observeEvent( r$dimreds, {
        output$dimred <- renderUI({
            selectInput(
                inputId = ns("dimred"),
                label = "Dimensionality reduction",
                choices = r$dimreds,
                selected = r$dimred)
        })
    })
    # Plot title
    observeEvent( r$sample_exprs, {
        output$plot_title <- renderUI({
            textInput(
                inputId = ns("title"),
                label = "Plot title",
                value = "Samples projected onto scaffold PCA"
            )})
    })
    observeEvent( input$title, {
        r$title <- input$title
        # Put here to delay plotting
        r$add_sample <- TRUE
    })
    # Pheno colnames
    observeEvent( r$sample_pheno, {
        if(!is(r$sample_pheno, "NULL")){
            output$pheno_colname <- renderUI({
                selectInput(
                    inputId = ns("colname"),
                    label = "Phenotype column",
                    choices = r$colnames,
                    selected = r$sample_colname,
                    multiple = FALSE
                )
            })
        }})


    # Classes ----
    observeEvent( input$classes, {
        r$classes <- input$classes
    })
    observeEvent( r$all_classes, {
        if(r$space == "DMAP.v1"){
            # Determine cell types
            output$classes <- renderUI(list(
                selectInput(
                    inputId = ns("classes"),
                    label = "Select classes to include",
                    choices = sort(r$all_classes),
                    multiple = TRUE,
                    selected = r$classes
                ),
                p("Mark and press the 'delete' button to remove classes.") %>%
                    tagAppendAttributes(class = 'msg')
            ))
        } else{output$classes <- NULL; r$classes <- r$all_classes}

    })


    # Press save ----
    observeEvent( input$savePlot, {
      r$savePlot <- input$savePlot
      r$format <- input$format
      r$height <- input$height
      r$width <- input$width
      r$plotname <- "plot_spaceRAT"
    })
    # Print filename ----
    output$plotname <- renderText({
      if (is.null(r$plotname) ){
        NULL
      } else{
        paste0("Plot saved with filename '", r$plotname, ".", r$format, "'")
      }
    })
    # Download data ----
    output$downloadData <- downloadHandler(
      filename = "spaceRAT_data.csv",
      content = function(file) {
        utils::write.csv(r$data, file, row.names = FALSE)
      }
    )
  })
}

## To be copied in the UI
# mod_sidebar_ui("sidebar_1")

## To be copied in the server
# mod_sidebar_server("sidebar_1")
