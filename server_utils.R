library(shiny)

renderCurrency <- function(expr) {
  func <- quoToFunction(rlang::enquo0(expr))
  createRenderFunction(
    func,
    transform = function(value, session, name, ...) {
      paste0("$", formatC(value, format="f", digits=2, big.mark=","))
    }
  )
}