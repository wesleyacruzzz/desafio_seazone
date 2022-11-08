# Seazone Code Challenge - Airbnb listings occupation and prices, an analysis

The purpose of this repository is to display the codes and files needed to reproduce my analysis. The entire script was made using the software Rstudio and was programmed in the R language.

The analysis was based on graphs and tables as well as some statistical concepts, such as heterogeneous linear correlation. In the end, two products were generated:

- **A PDF report with comments**
- **A web application for viewing available data**

To reproduce the analysis scripts it is necessary for the user to follow some steps, they are:

- Install R: https://cran.r-project.org/
- Install RStudio: https://www.rstudio.com/products/rstudio/download/
- With Rstudio open it is necessary to install the following packages:

```
install.packages("ggcorrplot") # Generate a visualization for the correlation matrix
install.packages("kableExtra") # Create tables with good aesthetics in R Markdown
install.packages("gridExtra") # Allows you to create graphics grids
install.packages("tidyverse") # Collection of various general purpose packages
install.packages("polycor") # Generate the heterogeneous correlation matrix
install.packages("scales") # Allows you to format the values on the axes of the graphs
install.packages("knitr") # Generate the R Markdown file
```

After installing the packages, the evaluator can run the codes found in the file script_desafio_seazone.R or if it is of interest it is possible to generate the same PDF running the codes present in the file relatorio_desafio_seazone.Rmd. **To ensure there is no problem the scripts and data must be on the same page** or you will need to add the following line of code before running:

```
setwd("DATA_PATH")
```

If the need arises, the evaluator can access the HTML version of the final report through this [link](https://htmlpreview.github.io/?https://github.com/wesleyacruzzz/desafio_seazone/blob/main/Arquivos/html_relatorio_desafio_seazone.html)

The web application was an extra that I decided to add to the challenge. The app works as an online dashboard for quick data visualization, in this application it is possible to find graphs of individual variables, graphs of crossing of variables and graphs of variables over time.

If the user has any difficulty or does not know how to interact with the application, just click on the question mark icons located in the upper right corner of the screen, there will be a summary of each page on the dashboard. The application can be found at this [link](https://x2estatistica.shinyapps.io/listing_analysis/).

<p align="center">
  <img src="https://github.com/wesleyacruzzz/desafio_seazone/blob/main/Imagens/print_app.png" width="900" title=" ">
</p>
