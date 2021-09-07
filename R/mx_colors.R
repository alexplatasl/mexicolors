#' Mexican politics-inspired color palettes
#'
#' Use \code{\link{mexico_palette}} to produce desired color palette
#'
#' @export
mexico_palettes <- list(
  morena = c("#B3282D", "#D35459", "#BDBBBB", "#808285"),
  pri = c("#00A54F", "#F5F5F5", "#B4B5B8", "#EE1D23"),
  pan = c("#164EAF", "#216BB6", "#03C4FD", "#F5F5F5"),
  prd = c("#FDD808", "#FEED86", "#F5F5F5", "#B4B5B8", "#221F20"),
  cuatroT = c("#6A1C32", "#9F203B", "#BC955C", "#DDC9A4", "#98989A", "#767573", "#235B4E", "#10302B"),
  ine = c("#950054", "#D5007F", "#B2B2B2", "#000000"),
  pvem = c("#50AA4E", "#87BF1C", "#ACCF77", "#FEEF1F", "#DE2837", "#000000"),
  mc = c("#F68628","#F9A765","#FCBE8B","#FEDDC0","#D3D4D6","#A5A9AC","#81878D","#5D6770")
)

#' Mexico color palette generator
#'
#' @usage mexico_palette("name", n, "type")
#' @param n Number of colors to select from the palette. If null, then all colors in the palette are selected
#' @param name Name of the specific palette in quotation marks. The options are: \code{morena}, \code{pri}, \code{pan}, \code{prd}, \code{cuatroT}
#' @param type Specify the type of color mapping, either "continuous" or "discrete" in quotation marks. Use "continuous" to include more colors than those in the palette. See \code{examples} below for more
#'   @importFrom graphics rgb rect par image text
#' @references Philip Waggoner. 2019. amerika: American Politics-Inspired Color Palette Generator. R package version 0.1.0
#' @return A vector of colors
#' @export
#' @examples
#' # Display each palette
#' mexico_palette("morena")
#' mexico_palette("pri")
#' mexico_palette("pan")
#' mexico_palette("prd")
#' mexico_palette("cuatroT")
#'
#' # Interpolating between existing colors based on the palettes using the "continuous" type
#' mexico_palette(n = 50, name = "morena", type = "continuous")
#' mexico_palette(n = 50, name = "pri", type = "continuous")
#' mexico_palette(n = 50, name = "pan", type = "continuous")
#' mexico_palette(n = 50, name = "prd", type = "continuous")
#' mexico_palette(n = 50, name = "cuatroT", type = "continuous")

mexico_palette <- function(name, n, type = c("discrete", "continuous")) {
  type <- match.arg(type)

  pal <- mexico_palettes[[name]]
  if (is.null(pal))
    stop("You supplied the name of a palette not included in 'mexicolors'.")

  if (missing(n)) {
    n <- length(pal)
  }

  if (type == "discrete" && n > length(pal)) {
    stop("The number of requested colors is more than those offered by the palette.\n
         Consider changing the palette or the number of requested colors.")
  }

  out <- switch(type,
                continuous = grDevices::colorRampPalette(pal)(n),
                discrete = pal[1:n]
  )
  #structure(out, class = "palette", name = name)
  out
}

#' @export
#' @importFrom graphics rect par image text
#' @importFrom grDevices rgb
print.palette <- function(x, ...) {
  n <- length(x)
  old <- par(mar = c(0.5, 0.5, 0.5, 0.5))
  on.exit(par(old))

  image(1:n, 1, as.matrix(1:n), col = x,
        ylab = "", xaxt = "n", yaxt = "n", bty = "n")

  rect(0, 0.9, n + 1, 1.1, col = rgb(1, 1, 1, 0.8), border = NA)
  text((n + 1) / 2, 1, labels = attr(x, "name"), cex = 1, family = "serif")
}

