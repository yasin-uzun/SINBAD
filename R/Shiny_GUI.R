library(shiny)

# global objects
sinbad_object <- NULL
config_dir <- NULL
raw_fastq_dir <- NULL
working_dir <- NULL
demux_index_file <- NULL

# default objects (SETTINGS)
sequencing_type <- "paired"
demux_index_length <- 6
is_r2_index_embedded_in_r1_reads <- TRUE
num_cores <- 16

# default objects (EXECUTE)
mapq_threshold <- 10
alignment_rate_threshold <- 20
minimum_filtered_read_count <- 200000
min_call_count_threshold <- 10
max_ratio_of_na_cells <- 0.25


# register cores
doParallel::stopImplicitCluster()
cores <- parallel::detectCores()
doParallel::registerDoParallel(cores = max(1, cores))


# helper function OS-independent directory choice
choose.dir <- function() {
  tcltk::tclvalue(tcltk::tkchooseDirectory())
}


# helper function for creation of SINBAD object once appropriate
try_create_object <- function(sample_name) {
    if (is.null(sinbad_object) && !is.null(raw_fastq_dir) && !is.null(demux_index_file) && !is.null(working_dir) && !is.null(sample_name)) {
        sinbad_object <<- SINBAD::construct_sinbad_object(
            raw_fastq_dir, demux_index_file, working_dir, sample_name)
    }
}


# annotation list names
ensure_annot_list <- function(sinbad_object) {
    annot_format_file <- paste0(annot_dir, "/annot_file_format.txt")
    annot_file <- paste0(annot_dir, '/hg38/', 'regions.Bins_100Kb.bed')
    sinbad_object <- wrap_read_annot(sinbad_object, annot_file = annot_file, annot_format_file = annot_format_file, annot_name = 'Bins_100Kb')
    annot_file <- paste0(annot_dir, '/hg38/', 'regions.Bins_10Kb.bed')
    sinbad_object <- wrap_read_annot(sinbad_object, annot_file = annot_file, annot_format_file = annot_format_file, annot_name = 'Bins_10Kb')
    annot_file <- paste0(annot_dir, '/hg38/', 'regions.all_genes.bed')
    sinbad_object <- wrap_read_annot(sinbad_object, annot_file = annot_file, annot_format_file = annot_format_file, annot_name = 'Gene_Body')
    annot_file <- paste0(annot_dir, '/hg38/', 'regions.all_genes_plus_2Kb.bed')
    sinbad_object <- wrap_read_annot(sinbad_object, annot_file = annot_file, annot_format_file = annot_format_file, annot_name = 'Gene_Body-+2Kb')
    annot_file <- paste0(annot_dir, '/hg38/', 'regions.TSS_up2Kb_down2Kb.bed')
    sinbad_object <- wrap_read_annot(sinbad_object, annot_file = annot_file, annot_format_file = annot_format_file, annot_name = 'TSS-+2Kb')
    annot_file <- paste0(annot_dir, '/hg38/', 'regions.TSS_up2Kb_down500bp.bed')
    sinbad_object <- wrap_read_annot(sinbad_object, annot_file = annot_file, annot_format_file = annot_format_file, annot_name = 'TSS-2Kb+500bp')
    sinbad_object
}


# helper function for displaying an image
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


# Shiny user interface
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
                         selected = sequencing_type
                       )
                     ),

                     splitLayout(
                       cellWidths = c("67%", "33%"),
                       p("Demux index length:"),
                       numericInput("demux_index_length", NULL,
                                    value = demux_index_length),
                     ),


                     splitLayout(
                       cellWidths = c("67%", "33%"),
                       p("Is the index only in left read?"),
                       radioButtons(
                         "is_r2_index_embedded_in_r1_reads",
                         NULL,
                         choices = list("Yes" = TRUE, "No" = FALSE),
                         selected = is_r2_index_embedded_in_r1_reads,
                         inline = TRUE
                       )
                     ),

                     splitLayout(
                       cellWidths = c("67%", "33%"),
                       p("Number of cores:"),
                       numericInput("num_cores", NULL, value = num_cores)
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
                       numericInput("mapq_threshold", NULL, value = mapq_threshold)
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
                         value = alignment_rate_threshold
                       )
                     ),

                     splitLayout(
                       cellWidths = c("67%", "33%"),
                       p("Min read count for cell:", style = "font-weight:bold;overflow:visible;"),
                       numericInput("minimum_filtered_read_count", NULL, value = minimum_filtered_read_count)
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
                       numericInput("min_call_count_threshold", NULL, value = min_call_count_threshold)
                     ),

                     splitLayout(
                       cellWidths = c("67%", "33%"),
                       p("Max ratio of missing cells:", style = "font-weight:bold;"),
                       numericInput("max_ratio_of_na_cells", NULL, value = max_ratio_of_na_cells)
                     ),

                     actionButton(
                       "btn_Quantify",
                       "Quantify",
                       class = "btn-warning",
                       width = '150px',
                       style = 'padding:4px'
                     ),

                     actionButton(
                       "btn_impute_nas",
                       "Fill Missing",
                       class = "btn-warning",
                       width = '150px',
                       style = 'padding:4px'
                     ),

                     br(),
                     br(),

                     actionButton(
                       "btn_dim_red",
                       "Dim. Red.",
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

# Sever component
server <- function(input, output) {

  # LOADING VARIABLES

  # confguration directory
 observeEvent(input$browse_config_dir, {
    tmp <- choose.dir()
    if (!is.na(tmp)) {
        config_dir <<- tmp
        SINBAD::read_configs(config_dir)
    }
 })

  # demux file
 observeEvent(input$browse_demux_index_file, {
    tmp <- file.choose()
    if (!is.na(tmp)) {
        demux_index_file <<- tmp
    }
    try_create_object(input$sample_name)
 })

  # reads directory
 observeEvent(input$browse_fastq_dir, {
    tmp <- choose.dir()
    if (!is.na(tmp)) {
        raw_fastq_dir <<- tmp
    }
    try_create_object(input$sample_name)
 })

  # output directory
 observeEvent(input$browse_working_dir, {
    tmp <- choose.dir()
    if (!is.na(tmp)) {
        working_dir <<- tmp
        dir.create(working_dir, recursive = TRUE)
    }
    try_create_object(input$sample_name)
 })

 # LOADING OR SAVING OBJECTS

  # save object
  observeEvent(input$save_sinbad_object, {
    saveRDS(sinbad_object, file = file.choose())
  })

  # load object
  observeEvent(input$load_sinbad_object, {
    sinbad_object <<- readRDS(file.choose())
  })

  # PROCESSING

  # get plot proprocessing
  observeEvent(input$btn_pp, {
    # flags
    flag_r2_index_embedded_in_r1_reads  = FALSE
    if (exists('sequencing_type') & exists('is_r2_index_embedded_in_r1_reads')) {
      if (sequencing_type == 'paired' & is_r2_index_embedded_in_r1_reads) {
        flag_r2_index_embedded_in_r1_reads  = TRUE
      }
    }

    if (flag_r2_index_embedded_in_r1_reads) {
      SINBAD::get_r2_indeces_from_r1(r1_fastq_dir = raw_fastq_dir,
                             r2_input_fastq_dir = raw_fastq_dir,
                             r2_output_fastq_dir = sinbad_object$r2_meta_fastq_dir,
                             sample_name = input$sample_name)
    }

    # Demux
    sinbad_object <<- SINBAD::wrap_demux_fastq_files(sinbad_object, flag_r2_index_embedded_in_r1_reads)
    sinbad_object <<- SINBAD::wrap_demux_stats(sinbad_object)
    rownames(sinbad_object$df_demux_reports) = gsub('_merged', '', rownames(sinbad_object$df_demux_reports) )
    print('Demux done')

    #Trim
    sinbad_object <<- SINBAD::wrap_trim_fastq_files(sinbad_object)
    print('Trimming done')
    sinbad_object <<- SINBAD::wrap_trim_stats(sinbad_object)
    SINBAD::wrap_plot_preprocessing_stats(sinbad_object)
  })

  # get plot alignment
  observeEvent(input$btn_align, {
    # update from inputs
    sequencing_type <<- input$sequencing_type
    demux_index_length <<- input$demux_index_length
    is_r2_index_embedded_in_r1_reads <<- input$is_r2_index_embedded_in_r1_reads
    num_cores <<- input$num_cores
    mapq_threshold <<- input$mapq_threshold
    alignment_rate_threshold <<- input$alignment_rate_threshold
    minimum_filtered_read_count <<- input$minimum_filtered_read_count

    #Align
    sinbad_object <<- SINBAD::wrap_align_sample(sinbad_object)

    #Alignment stats
    sinbad_object <<- SINBAD::wrap_generate_alignment_stats(sinbad_object)

    #Merge bam files
    SINBAD::wrap_merge_r1_and_r2_bam(sinbad_object)

    #Coverage
    sinbad_object <<- SINBAD::wrap_compute_coverage_rates(sinbad_object)

    #Plot alignment QC
    SINBAD::wrap_plot_alignment_stats(sinbad_object)
  })

  # get plot methylation
  observeEvent(input$btn_met, {
    sinbad_object <<- SINBAD::wrap_generate_methylation_stats(sinbad_object)
    options(bitmapType='cairo')
    SINBAD::wrap_plot_met_stats(sinbad_object)
  })

  # PLOTTING

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

  # POST-HOC

  # quantify
  observeEvent(input$btn_Quantify, {
    min_call_count_threshold <<- input$min_call_count_threshold
    max_ratio_of_na_cells <<- input$max_ratio_of_na_cells

    sinbad_object <<- ensure_annot_list(sinbad_object)
    annot_names = names(sinbad_object$annot_list)
    for(annot_name in annot_names) {
      sinbad_object <<- wrap_quantify_regions(sinbad_object, annot_name = annot_name)
    }
  })

  # impute missing values
  observeEvent(input$btn_impute_nas, {
    sinbad_object <<- ensure_annot_list(sinbad_object)
    annot_names = names(sinbad_object$annot_list)
    for (annot_name in annot_names) {
      sinbad_object <<- wrap_impute_nas(sinbad_object, annot_name)
    }
  })

  # dimensionality reduction
  observeEvent(input$btn_dim_red, {
    min_call_count_threshold <<- input$min_call_count_threshold
    max_ratio_of_na_cells <<- input$max_ratio_of_na_cells

    sinbad_object <<- ensure_annot_list(sinbad_object)
    annot_names = names(sinbad_object$annot_list)
    for (annot_name in annot_names) {
      sinbad_object <<- wrap_dim_red(sinbad_object, annot_name)
    }
  })

  # DMR
  observeEvent(input$btn_DMR, {
    sinbad_object <<- wrap_dmr_analysis(sinbad_object)
  })

}

# shiny run app
shinyApp(ui, server)
