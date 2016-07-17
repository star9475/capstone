#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = "bootstrap.css",
  
  # Application title
  titlePanel("Coursera Capstone - Word Prediction"),
  
  tabsetPanel(
  # Sidebar with a slider input for number of bins 
       tabPanel(p(icon("info"), "About"),
                hr(),
                includeMarkdown("about.Rmd")
       ), # end of "Visualize the Data" tab panel
       tabPanel(p(icon("line-chart"), "Predict"),
                hr(),
                sidebarLayout(
                     sidebarPanel(
                          # sliderInput("bins",
                          #             "Number of bins:",
                          #             min = 1,
                          #             max = 50,
                          #             value = 30),
                          # hr(),
                          #textInput("text", label = h3("Text input"), value = "Enter text..."),
                          sliderInput("numResults",
                                      "Number of results:",
                                      min = 1,
                                      max = 10,
                                      value = 1),
                          
                          hr(),
                          
                          textInput("predictText", "Text:", ""),
                          submitButton("Predict")
                     ),
                     
                     # Show a plot of the generated distribution
                     mainPanel(
                          #plotOutput("distPlot"),
                          h4("Prediction"),
                          #hr(),
                          fluidRow(column(10, verbatimTextOutput("predictText"))),
                          fluidRow(column(10, verbatimTextOutput("predictText1"))),
                          #column(8, wellPanel(verbatimTextOutput("text")))
                          hr(),
                          plotOutput("wordcloudPlot")
                          
                     )
                )
       )
  )# end of "Visualize the Data" tab panel
       
  )
)
