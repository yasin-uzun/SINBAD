# devtools::install_github("yasin-uzun/SINBAD.1.0")

# library(SINBAD)
# SINBAD::test()
# packageVersion('SINBAD')
# library(doSNOW)

# set working directory
# setwd("/Users/Shane/Code/packaging/SINBAD")
setwd("/mnt/c/Users/Shane/Code/packaging/SINBAD")

# load SINBAD
devtools::load_all()

# register cores
doParallel::stopImplicitCluster()
cores <- parallel::detectCores()
doParallel::registerDoParallel(cores = max(1, cores))

# directories
# root_dir <- "~/Tan-Lab/SINBAD-data"
root_dir <- "/mnt/c/Users/Shane/Documents/Tan-Lab/SINBAD-data"
config_dir <- file.path(root_dir, "config")
raw_fastq_dir <- file.path(root_dir, "reads")
demux_index_file = file.path(root_dir, "demux_index.txt")
working_dir = file.path(root_dir, "wd")

# read configurations
read_configs(config_dir)

# create working directory
dir.create(working_dir, recursive = TRUE)

# new SINBAD object
sample_name <- "Sample"
# sinbad_object <- construct_sinbad_object(
#     raw_fastq_dir, demux_index_file, working_dir, sample_name)

# flags
flag_r2_index_embedded_in_r1_reads  = FALSE
if (exists('sequencing_type') & exists('is_r2_index_embedded_in_r1_reads')) {
  if (sequencing_type == 'paired' & is_r2_index_embedded_in_r1_reads) {
    flag_r2_index_embedded_in_r1_reads  = TRUE
  }
}


# if (flag_r2_index_embedded_in_r1_reads) {
#   get_r2_indeces_from_r1(r1_fastq_dir = raw_fastq_dir,
#                          r2_input_fastq_dir = raw_fastq_dir,
#                          r2_output_fastq_dir = sinbad_object$r2_meta_fastq_dir,
#                          sample_name = sample_name)
#
# }

# Demux
# sinbad_object = wrap_demux_fastq_files(sinbad_object, flag_r2_index_embedded_in_r1_reads)
# sinbad_object = wrap_demux_stats(sinbad_object)
# rownames(sinbad_object$df_demux_reports) = gsub('_merged', '', rownames(sinbad_object$df_demux_reports) )
# sinbad_object_file = file.path(working_dir, sample_name, 'objects/sinbad_object.03.rds')
# saveRDS(sinbad_object, file = sinbad_object_file)
# print('Demux done')
# print(sinbad_object)

#Trim
# sinbad_object_file = file.path(working_dir, sample_name, 'objects/sinbad_object.03.rds')
# sinbad_object = readRDS(sinbad_object_file)
# sinbad_object$df_demux_reports
# sinbad_object = wrap_trim_fastq_files(sinbad_object)
# print('Trimming done')
# sinbad_object = wrap_trim_stats(sinbad_object)
# sinbad_object_file = file.path(working_dir, sample_name, 'objects/sinbad_object.05.rds')
# saveRDS(sinbad_object, file = sinbad_object_file)
# wrap_plot_preprocessing_stats(sinbad_object)
sinbad_object_file = file.path(working_dir, sample_name, 'objects/sinbad_object.05.rds')
sinbad_object = readRDS(sinbad_object_file)
# print(sinbad_object)

#Align
sinbad_object = wrap_align_sample(sinbad_object)
sinbad_object_file = file.path(working_dir, sample_name, 'objects/sinbad_object.06.rds')
saveRDS(sinbad_object, file = sinbad_object_file)
sinbad_object = readRDS(sinbad_object_file)
print(sinbad_object)

# #Alignment stats
# sinbad_object = wrap_generate_alignment_stats(sinbad_object)
# sinbad_object_file = file.path(working_dir, sample_name, 'objects/sinbad_object.07.rds')
# saveRDS(sinbad_object, file = sinbad_object_file)
# sinbad_object = readRDS(sinbad_object_file)
# print(sinbad_object)
# print(head(sinbad_object$df_alignment_stats))
# print(tail(sinbad_object$df_alignment_stats))



# #Merge bam files
# wrap_merge_r1_and_r2_bam(sinbad_object)

# #Coverage
# sinbad_object = wrap_compute_coverage_rates(sinbad_object)
# sinbad_object_file = file.path(working_dir, sample_name, 'objects/sinbad_object.08.rds')
# saveRDS(sinbad_object, file = sinbad_object_file)
# sinbad_object = readRDS(sinbad_object_file)
# print(sinbad_object)







# minimum_filtered_read_count = 2000000
# alignment_rate_threshold = 40

# #Plot alignment QC
# sinbad_object = wrap_plot_alignment_stats(sinbad_object)

# #Call methylation
# sinbad_object = wrap_call_methylation_sites(sinbad_object)

# sinbad_object_file = file.path(working_dir, sample_name, 'objects/sinbad_object.09.rds')
# saveRDS(sinbad_object, file = sinbad_object_file)
# sinbad_object = readRDS(sinbad_object_file)
# print(sinbad_object)



# #Methylation stats

# sinbad_object = wrap_generate_methylation_stats(sinbad_object)

# sinbad_object_file = file.path(working_dir, sample_name, 'objects/sinbad_object.10.rds')
# saveRDS(sinbad_object, file = sinbad_object_file)
# sinbad_object = readRDS(sinbad_object_file)
# print(head(sinbad_object$df_alignment_stats))


# options('bitmapType')
# options(bitmapType='cairo')

# sinbad_object = wrap_plot_met_stats(sinbad_object)
# print(sinbad_object$plot_dir)

# options(bitmapType = "Xlib")

# ##########Read annotation matrices##########

# annot_format_file =  paste0(annot_dir, "/annot_file_format.txt")

# annot_file = paste0(annot_dir, '/hg38/', 'regions.Bins_100Kb.bed')
# sinbad_object = wrap_read_annot(sinbad_object, annot_file = annot_file, annot_format_file = annot_format_file, annot_name = 'Bins_100Kb')

# annot_file = paste0(annot_dir, '/hg38/', 'regions.Bins_10Kb.bed')
# sinbad_object = wrap_read_annot(sinbad_object, annot_file = annot_file, annot_format_file = annot_format_file, annot_name = 'Bins_10Kb')

# annot_file = paste0(annot_dir, '/hg38/', 'regions.all_genes.bed')
# sinbad_object = wrap_read_annot(sinbad_object, annot_file = annot_file, annot_format_file = annot_format_file, annot_name = 'Gene_Body')

# annot_file = paste0(annot_dir, '/hg38/', 'regions.all_genes_plus_2Kb.bed')
# sinbad_object = wrap_read_annot(sinbad_object, annot_file = annot_file, annot_format_file = annot_format_file, annot_name = 'Gene_Body-+2Kb')

# annot_file = paste0(annot_dir, '/hg38/', 'regions.TSS_up2Kb_down2Kb.bed')
# sinbad_object = wrap_read_annot(sinbad_object, annot_file = annot_file, annot_format_file = annot_format_file, annot_name = 'TSS-+2Kb')

# annot_file = paste0(annot_dir, '/hg38/', 'regions.TSS_up2Kb_down500bp.bed')
# sinbad_object = wrap_read_annot(sinbad_object, annot_file = annot_file, annot_format_file = annot_format_file, annot_name = 'TSS-2Kb+500bp')



# sinbad_object_file = paste0(working_dir, sample_name,'/objects/sinbad_object.11.rds')
# saveRDS(sinbad_object, file = sinbad_object_file)
# sinbad_object = readRDS(sinbad_object_file)
# #print(sinbad_object)


# ##########Quantify methylation matrices##########

# annot_names = names(sinbad_object$annot_list)
# print(annot_names)

# for(annot_name in annot_names)
# {
#   print(annot_name)
#   sinbad_object = wrap_quantify_regions(sinbad_object, annot_name = annot_name)
# }

# print(names(sinbad_object$met_matrices))

# sinbad_object_file = paste0(working_dir, sample_name,'/objects/sinbad_object.12.rds')
# saveRDS(sinbad_object, file = sinbad_object_file)
# sinbad_object = readRDS(sinbad_object_file)
# print(sinbad_object)


# ##########Impute NA values##########


# for(annot_name in annot_names)
# {
#   print(annot_name)
#   sinbad_object = wrap_impute_nas(sinbad_object, annot_name)
# }

# sinbad_object_file = file.path(working_dir, sample_name, 'objects/sinbad_object.13.rds')
# saveRDS(sinbad_object, file = sinbad_object_file)
# sinbad_object = readRDS(sinbad_object_file)


# ##########Run dimensionality reduction##########

# annot_name = "Bins_100Kb"
# for(annot_name in annot_names)
# {
#   print(annot_name)
#   sinbad_object = wrap_dim_red(sinbad_object, annot_name)
# }

# sinbad_object_file = file.path(working_dir, sample_name, 'objects/sinbad_object.13.rds')
# saveRDS(sinbad_object, file = sinbad_object_file)
# sinbad_object = readRDS(sinbad_object_file)


# ##########Run differential methylation##########


# sinbad_object = wrap_dmr_analysis(sinbad_object)

# sinbad_object_file = file.path(working_dir, sample_name, 'objects/sinbad_object.14.rds')
# saveRDS(sinbad_object, file = sinbad_object_file)
# sinbad_object = readRDS(sinbad_object_file)
# print(sinbad_object)
