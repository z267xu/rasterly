#' @title Extract or replace parts of a `rasterizer` object
#' @description Operators acting on a `rasterizer` object to extract or replace parts.
#' @param x Object from which to extract element(s) or in which to replace element(s).
#' @param name A literal character string to be extracted from x. See details for more info.
#' 
#' @details Available names: 
#' \itemize{
#'  \item{Aggregation: }{"data", "mapping", "plot_width", "plot_height", "range", "x_range", 
#' "y_range", "xlim", "ylim", "aesthetics", "reduction_func", "glyph", 
#' "max_size", "group_by_data_table", "drop_data", "variable_check"}
#'  \item{Display: }{"background", "colour_map", "colour_key", "alpha", "span",
#'  "show_raster", "layout"}
#' }
#' 
#' @usage 
#' x[name]
#' 
#' x[name] <- value
#' 
#' @examples 
#' library(rasterizer)
#' r <- rasterizer(
#'        data = data.frame(x = 1:1e4, y = runif(1e4), category = sample(1:4, 1e4, replace = TRUE)), 
#'        mapping = aes(x = x, y = y)
#' ) %>% 
#'   rasterize_points(xlim = c(1, 5000)) %>% 
#'   rasterize_points(
#'     mapping = aes(x = x, y = y, colour = category),
#'     xlim = c(5001, 1e4)
#'   )   
#' r["mapping"]
#' r["xlim"]
#' 
#' # reassign parent `rasterizer()` mapping
#' r["mapping"] <- aes(x = x, y = y, colour = category)
#' r["mapping"]
#' 
#' # reassign all mapping systems
#' r["mapping", which = 1:length(r)] <- aes(x = x, y = y)
#' r["mapping"]
#' @export
`[.rasterizer` <- function(x, name) {
  # x is executed
  if(is.rasterizer_build(x)) {
    .Primitive("[")(x,name)
  } else {
    # x is an unexecuted list of environments
    l <- lapply(x, 
                function(envir) {
                  .get(name, envir = envir)
                })
    return(l)
  }
}

#' @inherit [.rasterizer
#' @param which Replace parts on which layer. Default is 1, parent layer (`rasterizer()`)
#' @usage 
#' x[name]
#' 
#' x[name] <- value
#' @export
`[<-.rasterizer` <- function(x, name, value, which = 1) {

  # x is executed
  if(is.rasterizer_build(x)) {
    .Primitive("[<-")(x, name, value)
  } else {
    # x is an unexecuted list of environments
    for(w in which) {
      assign(name, value, envir = x[[w]])
    }
    return(x)
    invisible()
  }
}