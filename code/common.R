library(ggplot2)
library(showtext)

sysfonts::font_add_google("Lato", "lato")
showtext_auto()

theme_ccx <- function() {
  ggplot2::theme_minimal(base_family = "lato") +
  ggplot2::theme(

  )
}

theme_set(theme_ccx())
