#Paths
dependency_path = '/mnt/isilon/tan_lab/uzuny/projects/sinbad/package/dependencies/'

#Genomic sequence
genomic_sequence_path = paste0(dependency_path, '/reference_genome/hg38_plus_lambda/chroms/')
bs_seeker_genome_dir = paste0(dependency_path, '/bs3/reference_genome/hg38_plus_lambda/')
bs_seeker_genome_fasta = '/hg38_plus_lambda.fa'

reference_genome_dir=paste0(dependency_path, '/reference_genome/hg38_plus_lambda/')
reference_genome_fasta= paste0(reference_genome_dir, '/hg38_plus_lambda.fa')

#Chromosome numbers
organism_chrom_numbers = 'chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrY chrM'
lambda_chrom_numbers = 'chrLambda chrlambda Lambda lambda L'
lambda_control = TRUE

#Annotation
annot_dir = paste0(dependency_path,'/annot/')
format_file = paste0(annot_dir, '/annot_file_format.txt')

chrom_sizes_file = paste0(annot_dir, '/hg38/hg38.chrom.sizes')
gene_annot_file = paste0(annot_dir, '/hg38/regions.all_genes.bed')
bins_100k_file = paste0(annot_dir, '/hg38/regions.100k_bins.bed')
bins_10k_file = paste0(annot_dir, '/hg38/regions.10k_bins.bed')



