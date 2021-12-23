
#Project directories
#raw_fastq_dir = '/mnt/isilon/tan_lab/uzuny/projects/sinbad/data/example/reads/'
#demux_index_file = '/mnt/isilon/tan_lab/uzuny/projects/sinbad/data/example/demux_index.txt'
#working_dir = '/mnt/isilon/tan_lab/uzuny/projects/sinbad/data/example/working_dir/'


#Tool selection
trimmer = 'cutadapt' #options: cutadapt trim_galore Trimmomatic
#aligner = 'bsmap'  #options: bismark bsmap bs_seeker
aligner = 'bismark'  #options: bismark bsmap bs_seeker


#Parameter settings

#Adapter trimming
#cutadapt_param_settings = ' -f fastq -q 20 -u 10 -m 30 -a AGATCGGAAGAGCACACGTCTGAAC '
#cutadapt_param_settings = '  -q 20 -u 10 -m 30 -a AGATCGGAAGAGCACACGTCTGAAC '
cutadapt_param_settings = ' -q 20 -u 16 -U 16 -m 30 -a AGATCGGAAGAGCACACGTCTGAAC -A AGATCGGAAGAGCGTCGTGTAGGGA  ' 

trim_galore_param_settings = ''
Trimmomatic_param_settings = 'SE ILLUMINACLIP:custom:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 MINLEN:25'

#Aligner
bismark_aligner_param_settings = ' --pbat -D 15 -R 2 -L 20 -N 0 --score_min L,0,-0.2 '
#bs_seeker_aligner_param_settings = ' -f bam --bt2-D 15 --bt2-R 2 --bt2-L 20 --bt2-N 0 --bt2--score_min L,0,-0.2 '
bs_seeker_aligner_param_settings = ' -f bam  '
bsmap_aligner_param_settings = '  -n 1 -w 100 -p 16  '

protocol = 'snmc'
sequencing_type = 'paired'
#sequencing_type = 'single'

is_r2_index_embedded_in_r1_reads = TRUE
#Methylation calling

#bme_param_settings = ' -s --comprehensive --gzip --merge_non_CpG  '
bme_param_settings = ' -s --comprehensive --gzip  '
#bme_param_settings = ' -s --gzip  '


filter_non_conversion_param_settings = ' --single --threshold 3 --consecutive '


demux_index_length = 6

mapq_threshold = 10
#duplicate_remover = 'picard'
duplicate_remover = 'samtools'
num_cores = 16

alignment_rate_threshold = 20
minimum_filtered_read_count = 200000
#organism_minimum_filtered_read_count = 200000

dmr_adj_p_value_cutoff = 0.05
dmr_log2_fc_cutoff = log2(1.5)
dm_num_heatmap_regions = 50

#For computing methylation rate for regions
min_call_count_threshold = 10

#For imputation
max_ratio_of_na_cells = 0.25

