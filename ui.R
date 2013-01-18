shinyUI(pageWithSidebar(
   # Application title
  headerPanel("Nr of wikipedia page views"),
    # Sidebar with controls to select the subjects and time span
  sidebarPanel(
     p(strong("enter wikipedia page identifier")),
     textInput(inputId = "subjects", label = " ", value = "Alexey_Navalny"),
     selectInput("type", "which label?",c("date","count")),
     numericInput(inputId = "nLabels", label = "how many labels",1),
     checkboxInput(inputId= "custom","enter custom values?",F),
     textInput(inputId= "customLabels","use a comma to separate input values","day after Russian election,Bolotnaia protests"),
     sliderInput(inputId = "size",
                  label="font size",
                  min = 3, max = 15, step = 1,value=8)
  ),
  
  mainPanel(
    h3(textOutput("caption")),
    
    plotOutput("plot",height="500px",width="600px"), 
    tableOutput("view")

    
  )
))
