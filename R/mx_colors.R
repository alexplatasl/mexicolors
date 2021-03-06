#' Mexican politics-inspired color palettes
#'
#' Use \code{\link{mexico_palette}} to produce desired color palette
#'
#' @keywords internal
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
#' @usage mexico_palette("name", n, "type", alpha, display)
#'
#' @param name Name of the specific palette in quotation marks.
#' Available options are:
#' \itemize{
#' \item morena
#' \item pri
#' \item pan
#' \item prd
#' \item cuatroT
#' \item ine
#' \item pvem
#' \item mc
#' }
#'
#' @param n Number of colors to select from the palette. If null, then all colors in the palette are selected
#'
#' @param type Specify the type of color mapping, either "continuous" or "discrete" in quotation marks. Use "continuous" to include more colors than those in the palette. See \code{examples} below for more.
#'
#' @param direction Sets the order of colors in the scale. 1 is the default.
#' If -1, the order of colors is reversed.
#'
#' @param alpha The alpha transparency, a number in [0,1], see argument alpha in
#' \code{\link[grDevices]{hsv}}.
#'
#' @param display Display the color palette in a plot window? (default: \code{FALSE} -
#'  generate color hex codes).
#'
#' @author Alejandro Platas-López: \email{alejandroplatasl@@gmail.com} / \href{https://www.linkedin.com/in/alexplatasl/}{@@alexplatasl}
#' @author Patricia Avilés-Casas: \email{patriciaavilesc@@gmail.com} / \href{https://www.linkedin.com/in/patriciaavilesc}{@@patriciaavilesc}
#'
#' @importFrom graphics rgb rect par image text
#'
#' @importFrom ggplot2 scale_fill_gradientn scale_color_gradientn discrete_scale
#'
#' @references Philip Waggoner. 2019. amerika: American Politics-Inspired Color Palette Generator. R package version 0.1.0
#'
#' @return A vector of colors
#'
#' @export
#' @examples
#' # Display each palette
#' mexico_palette("morena", display = TRUE)
#' mexico_palette("pri", display = TRUE)
#' mexico_palette("pan", display = TRUE)
#' mexico_palette("prd", display = TRUE)
#' mexico_palette("cuatroT", display = TRUE)
#' mexico_palette("ine", display = TRUE)
#' mexico_palette("pvem", display = TRUE)
#' mexico_palette("mc", display = TRUE)
#'
#' # Interpolating between existing colors based on the palettes using the "continuous" type
#' mexico_palette(n = 50, name = "morena", type = "continuous", display = TRUE)
#' mexico_palette(n = 50, name = "pri", type = "continuous", display = TRUE)
#' mexico_palette(n = 50, name = "pan", type = "continuous", display = TRUE)
#' mexico_palette(n = 50, name = "prd", type = "continuous", display = TRUE)
#' mexico_palette(n = 50, name = "cuatroT", type = "continuous", display = TRUE)
#' mexico_palette(n = 50, name = "ine", type = "continuous", display = TRUE)
#' mexico_palette(n = 50, name = "pvem", type = "continuous", display = TRUE)
#' mexico_palette(n = 50, name = "mc", type = "continuous", display = TRUE)

mexico_palette <- function(name, n, type = c("discrete", "continuous"), alpha = 1,
                           direction = 1, display = FALSE) {
  type <- match.arg(type)

  if (alpha < 0.06){
    alpha = 0.06
  }

  if (abs(direction) != 1) {
    stop("direction must be 1 or -1")
  }

  pal <- mexico_palettes[[name]]
  if (is.null(pal))
    stop("You supplied the name of a palette not included in 'mexicolors'.")

  if (missing(n)) {
    n <- length(pal)
  }

  if (type == "discrete" && n > length(pal)) {
    message(
    "The number of requested colors is more than those offered by the palette.
    Consider changing the palette or the number of requested colors.\n
    Parameter 'type' is changed to continuous and interpolated colors are provided.")
    type = "continuous"
  }

  out <- switch(type,
                continuous = if (alpha < 1){
                  colors <- grDevices::colorRampPalette(pal)(n)
                  paste(colors, sprintf("%x", ceiling(255*alpha)), sep="")
                }else{
                  grDevices::colorRampPalette(pal)(n)
                },
                discrete = if (alpha < 1){
                  colors <- pal[1:n]
                  paste(colors, sprintf("%x", ceiling(255*alpha)), sep="")
                }else{
                  pal[1:n]
                }
  )

  if (direction == -1){
    out = rev(out)
  }

  if (display == TRUE){
    structure(out, class = "palette", name = name)
  }else{
    out
  }

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

