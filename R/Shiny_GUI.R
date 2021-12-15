library(shiny)

ui <- fluidPage(
#ui <- fixedPage(

  tags$head(tags$style(HTML('#sidebar {width: 250px;}'))),

  titlePanel("SINBAD"),

  sidebarLayout(
    sidebarPanel( id = "sidebar",
      #helpText("Parameter settings"),

      tabsetPanel(
        tabPanel("Settings",

        br(),

        textInput("sample_name", "Sample name: ",
                  value = "Sample"),

        actionButton("browse_config_dir", "Config dir", width = '100px', style='padding:4px; background-color:#C0C0C0; border-color: #696969'),
        actionButton("browse_demux_index_file", "Demux file", width = '100px', style='padding:4px; background-color:#C0C0C0; border-color: #696969'),
        br(),
        br(),

        actionButton("browse_fastq_dir", "Read dir", width = '100px', style='padding:4px; background-color:#C0C0C0; border-color: #696969'),
        actionButton("browse_working_dir", "Output dir", width = '100px', style='padding:4px; background-color:#C0C0C0; border-color: #696969'),
        br(),
        br(),

        actionButton("save_sinbad_object", "Save results", width = '100px', style='padding:4px; background-color:#C0C0C0; border-color: #696969'),
        actionButton("load_sinbad_object", "Load results", width = '100px', style='padding:4px; background-color:#C0C0C0; border-color: #696969'),

        br(),
        br(),

        selectInput("sequencing_type",
                    label = "Sequencing type",
                    choices = c("paired",
                                "single"),
                    selected = "paired"),

        numericInput("demux_index_length", "Demultiplexing index length: ",
                  value = "6"),

        radioButtons("is_r2_index_embedded_in_r1_reads", "Is right index embedded in left reads?",
                     choices = list("Yes" = T, "No" = F), selected = T, inline = T),


        numericInput("num_cores", "Number of cores: ", value = "16"),



      #br(),
      #br(),

        ),
      tabPanel("Execute",
      br(),

      actionButton("btn_preprocess", "Preprocess", class = "btn-warning", width = '100px', style='padding:4px'  ) ,
      actionButton("btn_pp_stats", "Plot PP Stats", class = "btn-warning", width = '100px', style='padding:4px' ) ,

      br(),
      br(),

      numericInput("mapq_threshold", "Mapping quality threshold: ", value = "10"),

      sliderInput("alignment_rate_threshold", "Minimum alignment rate:",
                  min = 0, max = 100,
                  value = 20),

      numericInput("minimum_filtered_read_count", "Minimum read count for cell: ", value = "200000"),

      actionButton("btn_align", "Align", class = "btn-warning", width = '100px', style='padding:4px'),
      actionButton("btn_align_stats", "Plot Alignment", class = "btn-warning", width = '100px', style='padding:4px' ) ,

      br(),
      br(),

      actionButton("btn_call_met", "Call Met.", class = "btn-warning", width = '100px', style='padding:4px'),
      actionButton("btn_met_stats", "Plot Met. Stats", class = "btn-warning", width = '100px', style='padding:4px'),

      br(),
      br(),

      numericInput("min_call_count_threshold", "Minimum call count for region: ", value = "10"),
      numericInput("max_ratio_of_na_cells", "Maximum ratio of missing cells for region: ", value = "0.25"),


      #actionButton("btn_align_stats", "Plot Alignment Stats", class = "btn-warning" ) ,

      #br(),
      #br(),
      actionButton("btn_Quantify", "Quantify", class = "btn-warning", width = '100px', style='padding:4px'),

      actionButton("btn_DMR", "DMR", class = "btn-warning", width = '100px', style='padding:4px')

      )

      )

    ),

    mainPanel(
      #textOutput("selected_var"),
      #textOutput("min_max")
      # Use imageOutput to place the image on the page

        imageOutput("myImage", width = "100%")


    )
  )
)



server <- function(input, output) {

  output$selected_var <- renderText({
    paste("You have selected", input$sequencing_type)
  })

  output$min_max <- renderText({
    paste("You have chosen minimum alignment rate",
          input$alignment_rate_threshold[1])
  })


  observeEvent(input$btn_pp_stats, {

    outfile = paste0(sinbad_object$plot_dir,  "/QC/Preprocessing_statistics.png")
    error_msg = paste(outfile, 'cannot be found.')
    output$myImage <- renderImage({

      list(src = outfile,
           contentType = 'image/png',
           width = 800,
           height = 600,
           alt = error_msg)
    }, deleteFile = FALSE)
  })






  observeEvent(input$btn_align_stats, {

    outfile = paste0(sinbad_object$plot_dir,  "/QC/Alignment_statistics.png")
    error_msg = paste(outfile, 'cannot be found.')
    output$myImage <- renderImage({

      # Return a list containing the filename
      list(src = outfile,
           contentType = 'image/png',
           width = 800,
           height = 600,
           alt = error_msg)
    }, deleteFile = FALSE)

  })


  observeEvent(input$btn_met_stats, {

    outfile = paste0(sinbad_object$plot_dir,  "/QC/Met_call_statistics.png")
    error_msg = paste(outfile, 'cannot be found.')
    output$myImage <- renderImage({

      # Return a list containing the filename
      list(src = outfile,
           contentType = 'image/png',
           width = 800,
           height = 600,
           alt = error_msg)
    }, deleteFile = FALSE)
  })





}


shinyApp(ui, server)

#runGadget(ui, server, viewer = dialogViewer("Dialog Title", width = 1000, height = 800))

