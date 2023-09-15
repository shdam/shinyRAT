#' sample_files UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_sample_files_ui <- function(id){
  ns <- NS(id)
  tagList(
      uiOutput( # Expression tooltip
          outputId = ns("exprinfo")
      ),
      fileInput(
          inputId = ns('sample_exprs'),
          label = "Upload an expression matrix:",
          multiple = FALSE
      ),
      uiOutput( # Wrong data format
          outputId = ns("exprs_format")
      ),
      uiOutput( # Phenotype tooltip
          outputId = ns("phenoinfo")
      ),
      fileInput(
          inputId = ns('sample_pheno'),
          label = "Upload a phenotype matrix:",
          multiple = FALSE
      ),
      uiOutput( # Wrong data format
          outputId = ns("pheno_format")
      )
  )
}

#' sample_files Server Functions
#' @noRd
mod_sample_files_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns


    # Add data ----
    r$add_sample <- FALSE
    observeEvent( input$sample_exprs, {
        r$sample_exprs <- readFile(input$sample_exprs$datapath)
        if(is(r$sample_exprs, "character")){
            output$exprs_format <- renderUI({
                p(r$sample_exprs) %>%
                    tagAppendAttributes(class = 'error')
            })
        } else output$exprs_format <- renderUI({NULL})
        # r$add_sample <- TRUE
        })
    r$sample_pheno <- NULL
    r$add_pheno <- FALSE
    observeEvent( input$sample_pheno, {
        r$sample_pheno <- readFile(input$sample_pheno$datapath)
        r$colnames <- colnames(r$sample_pheno)
        r$sample_colname <- r$colnames[1]
        if(is(r$sample_pheno, "character")){
            output$pheno_format <- renderUI({
                p(r$sample_pheno) %>%
                    tagAppendAttributes(class = 'error')
            })
        } else output$pheno_format <- renderUI({NULL})
        r$add_pheno <- TRUE
        })

    # Tooltips ----
    tooltip_expr <- tibble::tribble(
        ~` `, ~sample1, ~sample2, ~`...`,
        "gene1", 200, 900, "...",
        "gene2", 1300, 5, "..."
    )
    tooltip_pheno <- tibble::tribble(
        ~` `, ~cell_types,
        "sample1", "type1",
        "sample2", "type2",
        "...", "..."
    )
    output$exprinfo <- renderUI({
        shinyWidgets::dropdownButton(
            h4("Example expression matrix layout"),
            renderTable(tooltip_expr),
            inline = TRUE,
            size = "xs",
            circle = TRUE,
            # status = "danger",
            icon = icon("info"), width = "500px",
            tooltip = shinyWidgets::tooltipOptions(title = "Click to see expression matrix example")
        )
    })
    output$phenoinfo <- renderUI({
        shinyWidgets::dropdownButton(
            h4("Example phenotype matrix layout"),
            renderTable(tooltip_pheno),
            inline = TRUE,
            size = "xs",
            circle = TRUE,
            # status = "danger",
            icon = icon("info"), width = "500px",
            tooltip = shinyWidgets::tooltipOptions(title = "Click to see phenotype matrix example")
        )
    })
  })
}

## To be copied in the UI
# mod_sample_files_ui("sample_files_1")

## To be copied in the server
# mod_sample_files_server("sample_files_1")
