
#Paths
dependency_path = '/mnt/isilon/tan_lab/uzuny/projects/sinbad/package/dependencies/'

#Aligners
bismark_path = paste0(dependency_path, '/programs/bismark_v0.20.1/')
bs_seeker_path = paste0(dependency_path, '/programs/bs3/')
bsmap_path = paste0(dependency_path, '/programs/bsmap-2.90/usr/bin/')

bowtie2_path = paste0(dependency_path, '/programs/bowtie2/')
Sys.setenv('PATH' = paste0(Sys.getenv('PATH'), ':', bowtie2_path)  )


#Sam processors
picard_path = paste0(dependency_path, '/programs/picard-tools-2.5.0/picard.jar')
samtools_path = paste0(dependency_path, '/programs/samtools/')

Sys.setenv('PATH' = paste0(Sys.getenv('PATH'), ':', bismark_path)  )
Sys.setenv('PATH' = paste0(Sys.getenv('PATH'), ':', samtools_path)  )

#Demuxer path
perl_demux_path = paste0(dependency_path, '/perl/demultiplex_fastq.pl')
perl_index_transfer_path = paste0(dependency_path, '/perl/get_r2_indeces_from_r1.pl')

#Trimmer paths
#cutadapt_path = paste0(dependency_path, '/programs/')
cutadapt_path = paste0( '~/.local/bin/')

trim_galore_path = paste0(dependency_path, '/programs/TrimGalore-0.6.5/')
Trimmomatic_jar_path = paste0(dependency_path, '/programs/trimmomatic-0.39.jar')


#system('echo $PATH')

