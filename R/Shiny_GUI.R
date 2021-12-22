# library(shiny)

# object is initially NULL
sinbad_object <- NULL

ui <- fluidPage(
  tags$head(tags$style(
    HTML(
      ".col-sm-4 {width: min-content;}
    p {font-weight:bold;padding-top:6px;}
    input[type='number'] {text-align:right;}
    .shiny-split-layout {display:inline-block;padding-right:10px;}"
    )
  )),

  titlePanel("SINBAD"),

  sidebarLayout(
    sidebarPanel(style = "width: 350px;",
                 tabsetPanel(
                   tabPanel(
                     "Settings",

                     br(),

                     splitLayout(
                       cellWidths = c("67%", "33%"),
                       p("Sample name:"),
                       textInput("sample_name", NULL,
                                 value = "Sample")
                     ),

                     actionButton(
                       "browse_config_dir",
                       "Config dir",
                       width = '150px',
                       style = 'padding:4px; background-color:#C0C0C0; border-color: #696969'
                     ),

                     actionButton(
                       "browse_demux_index_file",
                       "Demux file",
                       width = '150px',
                       style = 'padding:4px; background-color:#C0C0C0; border-color: #696969'
                     ),

                     br(),
                     br(),

                     actionButton(
                       "browse_fastq_dir",
                       "Read dir",
                       width = '150px',
                       style = 'padding:4px; background-color:#C0C0C0; border-color: #696969'
                     ),
                     actionButton(
                       "browse_working_dir",
                       "Output dir",
                       width = '150px',
                       style = 'padding:4px; background-color:#C0C0C0; border-color: #696969'
                     ),

                     br(),
                     br(),

                     actionButton(
                       "save_sinbad_object",
                       "Save results",
                       width = '150px',
                       style = 'padding:4px; background-color:#C0C0C0; border-color: #696969'
                     ),
                     actionButton(
                       "load_sinbad_object",
                       "Load results",
                       width = '150px',
                       style = 'padding:4px; background-color:#C0C0C0; border-color: #696969'
                     ),

                     br(),
                     br(),

                     splitLayout(
                       cellWidths = c("67%", "33%"),
                       p("Sequencing type:"),
                       selectInput(
                         "sequencing_type",
                         label = NULL,
                         choices = c("paired",
                                     "single"),
                         selected = "paired"
                       )
                     ),

                     splitLayout(
                       cellWidths = c("67%", "33%"),
                       p("Demux index length:"),
                       numericInput("demux_index_length", NULL,
                                    value = "6"),
                     ),


                     splitLayout(
                       cellWidths = c("67%", "33%"),
                       p("Is the index only in left read?"),
                       radioButtons(
                         "is_r2_index_embedded_in_r1_reads",
                         NULL,
                         choices = list("Yes" = T, "No" = F),
                         selected = T,
                         inline = T
                       )
                     ),


                     splitLayout(
                       cellWidths = c("67%", "33%"),
                       p("Number of cores:"),
                       numericInput("num_cores", NULL, value = "16")
                     ),

                   ),
                   tabPanel(
                     "Execute",
                     br(),

                     actionButton(
                       "btn_preprocess",
                       "Preprocess",
                       class = "btn-warning",
                       width = '150px',
                       style = 'padding:4px'
                     ) ,
                     actionButton(
                       "btn_pp_stats",
                       "Plot PP Stats",
                       class = "btn-warning",
                       width = '150px',
                       style = 'padding:4px'
                     ) ,

                     br(),
                     br(),

                     splitLayout(
                       cellWidths = c("67%", "33%"),
                       p("Mapping quality threshold:", style = "font-weight:bold;overflow:visible;"),
                       numericInput("mapq_threshold", NULL, value = "10")
                     ),

                     splitLayout(
                       cellWidths = c("50%", "50%"),
                       cellArgs = list(style = "overflow:hidden"),
                       p("Min alignment rate:", style = "font-weight:bold"),
                       sliderInput(
                         "alignment_rate_threshold",
                         NULL,
                         min = 0,
                         max = 100,
                         value = 20
                       )
                     ),

                     splitLayout(
                       cellWidths = c("67%", "33%"),
                       p("Min read count for cell:", style = "font-weight:bold;overflow:visible;"),
                       numericInput("minimum_filtered_read_count", NULL, value = "200000")
                     ),

                     actionButton(
                       "btn_align",
                       "Align",
                       class = "btn-warning",
                       width = '150px',
                       style = 'padding:4px'
                     ),
                     actionButton(
                       "btn_align_stats",
                       "Plot Alignment",
                       class = "btn-warning",
                       width = '150px',
                       style = 'padding:4px'
                     ) ,

                     br(),
                     br(),

                     actionButton(
                       "btn_met",
                       "Call Met.",
                       class = "btn-warning",
                       width = '150px',
                       style = 'padding:4px'
                     ),
                     actionButton(
                       "btn_met_stats",
                       "Plot Met. Stats",
                       class = "btn-warning",
                       width = '150px',
                       style = 'padding:4px'
                     ),

                     br(),
                     br(),

                     splitLayout(
                       cellWidths = c("67%", "33%"),
                       p("Min call count for region:", style = "font-weight:bold;"),
                       numericInput("min_call_count_threshold", NULL, value = "10")
                     ),

                     splitLayout(
                       cellWidths = c("67%", "33%"),
                       p("Max ratio of missing cells:", style = "font-weight:bold;"),
                       numericInput("max_ratio_of_na_cells", NULL, value = "0.25")
                     ),

                     actionButton(
                       "btn_Quantify",
                       "Quantify",
                       class = "btn-warning",
                       width = '150px',
                       style = 'padding:4px'
                     ),

                     actionButton(
                       "btn_DMR",
                       "DMR",
                       class = "btn-warning",
                       width = '150px',
                       style = 'padding:4px'
                     )

                   )

                 )),

    mainPanel(imageOutput("myImage", width = "100%"))
  )
)

render_image <- function(outfile) {
  error_msg = paste(outfile, 'cannot be found.')
  renderImage({
    list(
      src = outfile,
      contentType = 'image/png',
      width = 800,
      height = 600,
      alt = error_msg
    )
  }, deleteFile = FALSE)
}

server <- function(input, output) {
  # load object
  observeEvent(input$load_sinbad_object, {
    sinbad_object <<- readRDS(file.choose())
  })

  # get plot proprocessing
  observeEvent(input$btn_pp, {
    sinbad_object <<- wrap_plot_preprocessing_stats(sinbad_object)
  })

  # get plot alignment
  observeEvent(input$btn_align, {
    sinbad_object <<- wrap_plot_alignment_stats(sinbad_object)
  })

  # get plot methylation
  observeEvent(input$btn_met, {
    sinbad_object <<- wrap_plot_met_stats(sinbad_object)
  })

  # plot preprocessing
  observeEvent(input$btn_pp_stats, {
    outfile = paste0(sinbad_object$plot_dir,
                     "/QC/Preprocessing_statistics.png")
    output$myImage <- render_image(outfile)
  })

  # plot alignment
  observeEvent(input$btn_align_stats, {
    outfile = paste0(sinbad_object$plot_dir,
                     "/QC/Alignment_statistics.png")
    output$myImage <- render_image(outfile)
  })

  # plot methylation
  observeEvent(input$btn_met_stats, {
    outfile = paste0(sinbad_object$plot_dir,
                     "/QC/Met_call_statistics.png")
    output$myImage <- render_image(outfile)
  })

}

shinyApp(ui, server)
