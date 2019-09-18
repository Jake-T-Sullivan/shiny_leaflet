library(shiny)
library(leaflet)

r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()

ui <- fluidPage(
  sliderInput(inputId = "num",
              label = "Choose a number",
              value = 25, min = 0, 50),
  selectInput("variable", "Analyte:",
              c("TCE" = "cyl",
                "PCE" = "am",
                "Lead" = "gear")),
  
  radioButtons("dist", "Well Type:",
               c("Water Sample Point" = "norm",
                 "Monitoring Well" = "unif",
                 "Soil Boring" = "lnorm",
                 "Supra Permafrost" = "exp")),
  
  leafletOutput("mymap"),
  p(),
  actionButton("recalc", "New points"),
  
  plotOutput("hist")
)

server <- function(input, output, session) {
  
  points <- eventReactive(input$recalc, {
    cbind(rnorm(input$num) * 2 + 13, rnorm(input$num) + 48)
  }, ignoreNULL = FALSE)
  
  output$hist <- renderPlot({
    
    hist(rnorm(input$num))
  })
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)
      ) %>%
      addMarkers(data = points())
  })
}

shinyApp(ui, server)
