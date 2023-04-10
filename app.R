library(shiny)
library(ggplot2)
library(rlang)

data <- read.csv("https://raw.githubusercontent.com/bhandarianish/MSDS-6371/main/trainw3.csv")

ui <- navbarPage(
  "MSDS 6371 Kaggle Project: Anish Bhandari & William Jones",
  tabsetPanel(
    tabPanel("Livng Area(sq.ft) Vs Sales Price (in Thousands $) for Neighborhoods BrkSide,Edwards, and NAmes,  ",
             fluid = T,
             fluidPage(
               sidebarPanel(selectInput(
                 inputId = "varColor",
                 label = "Neighborhood",
                 choices = c("Neighborhood","HouseStyle","Foundation","BedroomAbvGr","YrSold","OverallQual","OverallCond"
                 ),
                 selected = "Neighborhood"
               )),
               mainPanel(plotOutput(outputId = "plot",height = 800))
             )
    )
  )
)


server <- function(input, output) {
  p <- reactive({
    ggplot(
      data,
      aes(y = SalePrice/1000, x = GrLivArea)
    ) +
      # This Part needs help
      geom_point(aes(size = 2,color = .data[[input$varColor]]))+ theme_classic() + guides(color = guide_legend(override.aes = list(size = 5))) + theme(axis.text.x = element_text(size=16),axis.text.y  = element_text(size=16),axis.title = element_text(face = "bold",size=18),legend.text = element_text(size=14) )
  })
  
  
  output$plot <- renderPlot({
    p()
  })
}

#shinyApp(ui, server)

shinyApp(ui = ui, server = server)
