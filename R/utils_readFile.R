#' readFile
#' @importFrom openxlsx read.xlsx
#' @noRd
readFile <- function(filepath) {
    # Extract the file extension using base R functions
    file_extension <- sub(".*\\.", "", filepath)

    if (file_extension == "csv") {
        data <- read.csv(filepath, row.names = 1)
    } else if (file_extension == "tsv") {
        data <- read.delim(filepath, row.names = 1)
    } else if (file_extension == "rds") {
        data <- readRDS(filepath)
    } else if (file_extension == "xlsx") {
        data <- openxlsx::read.xlsx(filepath, rowNames = TRUE)
    } else {
        data <- paste("Unsupported file type:", file_extension)
    }
    return(data)
}
