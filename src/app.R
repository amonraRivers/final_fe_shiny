library(tidyverse)
library(ggplot2)
library(dplyr)
library(feather)
library(shiny)
library(corrplot)

# Cargar los datos
boston_data <- read_feather("boston_clean.feather")

# Definir la interfaz de usuario
ui <- fluidPage(
  titlePanel("Análisis Exploratorio de Datos - Boston Housing"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("sample_size", "Número de Muestras:",
                  min = 10, max = nrow(boston_data), value = 100, step = 10),
      selectInput("var_select", "Selecciona una Variable:",
                  choices = names(boston_data), selected = "MEDV")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Histograma", plotOutput("histPlot")),
        tabPanel("Correlaciones", plotOutput("corrPlot")),
        tabPanel("Parámetros Seleccionados", verbatimTextOutput("summaryText"))
      )
    )
  )
)

# Definir el servidor
server <- function(input, output) {
  sampled_data <- reactive({
    boston_data %>% sample_n(input$sample_size)
  })

  output$histPlot <- renderPlot({
    ggplot(sampled_data(), aes_string(x = input$var_select)) +
      geom_histogram(fill = "skyblue", color = "black", bins = 30) +
      labs(title = paste("Histograma de", input$var_select),
           x = input$var_select, y = "Frecuencia")
  })

  output$corrPlot <- renderPlot({
    cor_matrix <- cor(sampled_data())
    corrplot(cor_matrix, method = "color", type = "upper", tl.cex = 0.8)
  })

  output$summaryText <- renderPrint({
    summary(sampled_data())
  })
}

# Iniciar la aplicación Shiny
shinyApp(ui = ui, server = server)

