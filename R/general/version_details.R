library(openxlsx)

packages <- as_tibble(installed.packages())
Rversion <- as_tibble(version$version.string)
Rstudio <- as_tibble(RStudio.Version()$version)

list <- list(packages = packages,
             Rversion = Rversion,
             Rstudio = Rstudio)


write.xlsx(packages, 
           "version_details.xlsx")

