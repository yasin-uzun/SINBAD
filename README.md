
# SINBAD: A pipeline for processing SINgle cell Bisulfite sequencing samples and Analysis of Data

<!-- README.md is generated from README.Rmd. Please edit that file -->

SINBAD is an R package for processing single cell DNA methylation data.
It accepts FASTQ files as input, performs demultiplexing, adapter
trimmming, mapping, quantification, dimensionality reduction and
differential methylation analysis for single cell DNA methylation
datasets.

<p align="center">
<img src="docs/SINBAD_Framework.png" width="600" title="">
</p>

NOTE: SINBAD is tested with paired snmC-Seq data.

## System requirements

R 3.6.0 or later version is required for installation.

## Installation

To install SINBAD, type the following command in R command prompt:

``` r
devtools::install_github("yasin-uzun/SINBAD")
```

Once you have installed the SINBAD, you can verify that it is installed
correctly as follows:

``` r
SINBAD::test()
```

If SINBAD is installed without any problems, you should see the
following message:

<br />

``` r
>SINBAD installation is ok.
```

## Dependencies

SINBAD has following software dependencies:

-   Adapter Trimmer: [Cutadapt](https://cutadapt.readthedocs.io/en/stable/installation.html) 
-   Aligner: [Bismark](https://www.bioinformatics.babraham.ac.uk/projects/bismark/)
-   Duplicate removal: [samtools](http://www.htslib.org/download/)
-   Perl dependencies: SINBAD uses two perl scripts for demultiplexing (see below).

You can install these tools by yourself. For convenience, we provide the
binaries in
[here](https://chopri.box.com/s/vplpxht3r7u6i0fcnio803wlnezuc5o3) .
Please cite the specific tool when you use it, in addition to SINBAD.

You can download the perl scripts from our [repository](perl/). 

You also need genomic sequence and annotated genomic regions for
quantification of methylation calls. We provide the sequence data for
hg38 and mm10 assemblies in
[here](https://chopri.box.com/s/ajbbqsu3vqumygqu8uzqex5m7afpniwr).

## Graphical User Interface

SINBAD can be run using simple R instructions. It also has an easy to use Graphical User Interface (GUI). The users with no R programming background can use the GUI to process and analyze their single cell DNA methylation sequencing datasets. Please see the user manual (below) on how to use SINBAD via GUI.

<p align="center">
<img src="docs/SINBAD_alignment.png" width="800" title="">
</p>

## User Manual

Detailed instructions for using SINBAD are available in the [SINBAD User Manual](docs/SINBAD_User_Manual.pdf). You can find the information about seeting the parameters and executing the analysis steps in the manual.

## Configuration

To run SINBAD, you need three configuration files to modify:

-   `config.general.R` : Sets the progam paths to be used by SINBAD.
    You need to edit this file only once.
-   `config.genome.R` : Sets the genomic information and paths to be
    used by SINBAD. You need to generate one for each organism. We
    provide the built-in configuration for hg38 assembly.
-   `config.project.R` : You need to configure this file for your
    project.

You can download the templates for the configuration files from the [repository](config_files/) and
edit them for your purposes.

## Running

SINBAD is run in two steps:

1.  Read configuration files:

``` r
read_configs(config_dir)
```

`config_dir` should point to your configuration file directory
(mentioned above).

2.  Process data:

``` r
process_sample_wrapper(raw_fastq_dir, demux_index_file, working_dir, sample_name)
```

-   `raw_fastq_dir` should point to the directory containing FASTQ files
    as the input.
-   `demux_index_file` should point to the demultiplexing index file for
    the FASTQ files.
-   `working_dir` should point to the directory where all the outputs
    will be placed into.
-   `sample_name` (optional) is the name for the sample or project.

This function reads FASTQ files, demultiplexes them into single cells,
performs filtering, mapping (alignment), DNA methylation calling and
quantification, dimensionality reduction, clustering and differential
methylation analysis for the given input. All the outputs are placed
into related directories in `working_dir`.

## Example Data

For testing SINBAD, we provide [example single ended and pair ended datasets](https://chopri.box.com/s/bzb3fb4dykenl99rethdxiqy6389wvat) generated with snmC-Seq protocol.

## Citation

If you use SINBAD in your study, please cite it as follows:

SINBAD: A pipeline for processing SINgle cell Bisulfite sequencing
samples and Analysis of Data, GitHub, 2021.

## Contact

For any questions or comments, please contact Yasin Uzun (uzuny at email
chop edu)
