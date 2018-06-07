#' cellar: functions and pipelines for processing single cell data
#'
#' @author Kent Riemondy <kent.riemondy@@gmail.com>
#'
#' @docType package
#' @name cellar
#'
#' @seealso Report bugs at \url{https://github.com/rnabioco/10x_data}
#'
#' @importFrom tibble tribble as_tibble
#' @importFrom readr read_tsv col_integer col_character col_double
#' @importFrom stringr str_replace str_split str_c str_length fixed
#' @importFrom rlang quos sym syms
#' @importFrom stats fisher.test na.omit
#' @importFrom utils head tail
#' @importFrom broom tidy
#' @import ggplot2
#' @import dplyr
"_PACKAGE"