 # libraries used. install as necessary
  Sys.setlocale("LC_CTYPE","russian")
  library(shiny)
  library(RJSONIO) # acquiring and parsing data
  library(ggplot2) # graphs
  library(plyr)  # manipulating data
  library(lubridate) #dates
  library(stringr)


shinyServer(function(input, output) {
  
  #get some data from wikipedia  
  data <- reactive(function() {  
    # create blank dataframe to hold three fields
    allData <- data.frame(count=numeric(),date=character(),name=character())
    target<-(input$subjects)

    Encoding(target)<-"UTF-8"

    # create dataframe for individual records
    df <- data.frame(count=numeric())  
     
      # obtain and process daily count data by month by target
      url <- paste0("http://stats.grok.se/json/en/",2011,12,"/",target)
        raw.data <- readLines(url, warn="F") 
        rd  <- fromJSON(raw.data)
        rd.views <- rd$daily_views 
        
        df <- rbind(df,as.data.frame(rd.views))
      
     #create the dataframe with all targets search counts by day
    df$date <-  as.Date(rownames(df))
    df$name <- target
    colnames(df) <- c("count","date","name")
    allData <- arrange(df,date)
 
   return(allData)
  })
  
  # create labels
  dataLabels <- reactive(function() {
    data<-data()
    #add blank labels
    data$labels<-""
    #sort the data
    data<-data[order(data$count,decreasing=T),]
    
    #add labels to the top n observations
    if(input$type=="date"){
      data$labels[1:input$nLabels]<-day(data$date)[1:input$nLabels]
    }
    if(input$type=="count"){
      data$labels[1:input$nLabels]<-data$count[1:input$nLabels]
    }

    
    if(input$custom==T){
      #use str split to break up the input
      customLabels<-unlist(str_split(input$customLabels,","))
      print(customLabels)
      data$labels[1:input$nLabels]<-customLabels[1:input$nLabels]
    }       
    data
  })  
    
  #create a plot
  output$plot<-reactivePlot(function(){
  data<-  dataLabels()
  yDate<-min(data$date)
  print(class(yDate))
  print(class(data$date))
  p<- ggplot(data, aes(x=date,y=count,label=labels))+
      ylab("")+xlab("") +theme_bw() +  
      geom_point()+
      geom_line(linetype="dashed")+
      theme(legend.position="top",legend.title=element_blank(),legend.text = element_text(colour="black", size = 14, face = "bold"))+
    geom_text(colour="blue",size=input$size,vjust=-.2)
  
  print(p)    
    })

  output$text<-reactiveText(function(){
    data<-  dataLabels()
    data$labels
  })
})
