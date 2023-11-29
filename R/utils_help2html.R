#' help2html
#'
#' A utils function that extracts a help page and converts to HTML
#'
#' @return The HTML content of a help page
#'
#' @noRd
help2html <- function(topic) {
    helpfile <- utils:::.getHelpFile(help(topic))
    hs <- capture.output(tools:::Rd2HTML(helpfile))
    hs <- hs[20:length(hs)-2] # remove auxiliary html stuff
    html <- htmltools::HTML(paste(hs, collapse = "\n"))
    return(html)
}
