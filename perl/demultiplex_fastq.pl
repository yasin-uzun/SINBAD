#!/bin/env perl

# invoke as:
# perl demultiplex_fastq.pl --demux_index_file demux_index_file --raw_fastq_file raw_fastq_file --demux_index_length demux_index_length --output_dir output_dir --output_prefix output_prefix --log_dir log_dir 

use File::Basename;
use IO::Compress::Gzip qw(gzip $GzipError) ;
#use IO::Compress::Gunzip qw(gunzip $GunzipError);
use IO::Uncompress::Gunzip qw(gunzip $GunzipError);
use Compress::Zlib;
use Getopt::Long;
use IO::Zlib;
#use open qw( :encoding(UTF-8) :std ); 

GetOptions( 'demux_index_file=s' => \my $demux_index_file 
          , 'raw_fastq_file=s' => \my $raw_fastq_file  
          , 'demux_index_length=s' => \my $demux_index_length 
          , 'output_dir=s' => \my $output_dir  
          , 'output_prefix=s' => \my $output_prefix  
		  , 'log_dir=s' => \my $log_dir  
          );

print("...\n");
print("Hello! My name is Demuxer.\n");
print("I will split your input read file $raw_fastq_file based on index at $demux_index_file \n");
print("Index length is specified as $demux_index_length \n");
print("Output prefix: $output_prefix \n");
print("Output dir: $output_dir \n");
print("log_dir: $log_dir \n");
print("...\n");


#my $demux_index_file = $ARGV[0];
#my $demux_index_length = $ARGV[1];
#my $raw_fastq_file = $ARGV[2];
#my $output_dir = $ARGV[3];
#my $output_prefix = $ARGV[4];


unless (open (demux_index_file, $demux_index_file)){ die ("Cannot read input index file: $demux_index_file \n"); }

@chrom_array = ();
@start_positions = ();
my %indeces = ();

$count = 0;
$ENV{PATH} = '';
while (my $line = <demux_index_file>) 
{
  print $line;
  chomp($line);
  my @array = split /:/, $line;
  my $index = $array[0];
  my $label = $array[1];
  print "***$index:$label\n";
  my $output_file = $output_dir."/".$output_prefix."_".$label.".fastq.gz";

  print $output_file."\n";

  #$indeces{$index} =  IO::File->new(); 
  #open($indeces{$index},"|-", " /usr/bin/gzip > $output_file");

  $indeces{$index} = new IO::Compress::Gzip($output_file) or die "gzip failed: $GzipError\n";
   
  $count++;
}

print "$count indeces found.\n";


print "Processing $raw_fastq_file \n";

#unless (open (raw_fastq_file, " /usr/bin/zcat $raw_fastq_file | ")){ die ("Cannot read input file: $raw_fastq_file\n"); }#

#gunzip $raw_fastq_file => raw_fastq_file  or die "unzip failed: $GunzipError\n";

#my $z = new IO::Uncompress::Gunzip $input [OPTS]
#        or die "IO::Uncompress::Gunzip failed: $GunzipError\n";

#my $gz= gzopen( $infile, "rb" )
#my $raw_fastq_file_handle = IO::Uncompress::Gunzip->new($raw_fastq_file, "transparent", 1)  or die "Could not read from $raw_fastq_file: $GunzipError";

my $raw_fastq_file_handle = new IO::Zlib;
$raw_fastq_file_handle->open($raw_fastq_file, "rb");

#open my $raw_fastq_file_handle, '<:gzip', $raw_fastq_file or die $!;

#my $raw_fastq_file_handle = gzopen($raw_fastq_file, "rb")  or die "Could not read from $raw_fastq_file: $gzerrno";

#unless (open ($raw_fastq_file_handle, "/usr/bin/zcat $raw_fastq_file | ")){ die ("Cannot read input file: $raw_fastq_file\n"); }#


my $basename = basename($raw_fastq_file);
my $undetermined_file = $output_dir."/No_matching_index.".$basename;
my $log_file = $log_dir."/".$output_prefix.".log";

print "**********$undetermined_file***********\n";
unless (open (UNDET, ">$undetermined_file")){ die ("Cannot write undetermined file: $undetermined_file\n"); }#
unless (open (LOG, ">$log_file")){ die ("Cannot write log file: $log_file\n"); }#

my $total_read_count = 0;
my $indexed_read_count = 0;
my $nonindex_read_count = 0;
my %read_counts = ();

while (my $line = <$raw_fastq_file_handle>) 
{
  #print $line;
  $total_read_count = $total_read_count + 1;
  my $line_1 = $line;

  $line = <$raw_fastq_file_handle>;
  my $line_2 = $line;
  my $index = substr($line, 0, 6) ;
  #print $index."\n";
  my $read = substr($line, 6);

  $line = <$raw_fastq_file_handle>;
  my $line_3 = $line;

  $line = <$raw_fastq_file_handle>;
  my $line_4 = $line;
  #my $index = substr($line, 1, 6) ;
  my $qual = substr($line, 6);
 
  my $match_flag = 0;
  if(exists($indeces{$index}) )
  {
      $match_flag = 1;   
	  $indeces{$index}->print($line_1);
	  $indeces{$index}->print($read);  
	  $indeces{$index}->print($line_3);
	  $indeces{$index}->print($qual);
       
	  $indexed_read_count = $indexed_read_count + 1;
	  $read_counts{$index} = $read_counts{$index} + 1;
  }
  else
  {
      my @x = split '', $index;
      

      foreach my $key (keys %indeces)
      {

         my @y = split '', $key;
         #Match indeces. Allow at most one mismatch
         my $result = join '',
           map { $x[$_] eq $y[$_] ? $y[$_] : "X" }
           0 .. $#y;

         #print $result;
         my $mismatch_count = $result =~ tr/X//;

         if($mismatch_count < 2) 
         {
			  $match_flag = 1;
			  $indeces{$key}->print($line_1);
			  $indeces{$key}->print($read);  
			  $indeces{$key}->print($line_3);
			  $indeces{$key}->print($qual); 

			  $indexed_read_count = $indexed_read_count + 1;  
			  $read_counts{$key} = $read_counts{$key} + 1;
              next;          
         }
      }#foreach


  }#else 


  #If mismatch is larger than 1 print to undetermined
  if($match_flag == 0){
      #print "$index\n";
	  print UNDET $line_1;
	  print UNDET $line_2;  
	  print UNDET $line_3;
	  print UNDET $line_4; 
      $nonindex_read_count = $nonindex_read_count + 1;   
      next;               

  }#else

  
}#while

print "Finished processing $raw_fastq_file \n";

my $header_str = "Total_reads\tReads_with_matching_index\tReads_without_matching_index";
my $number_str = "$total_read_count\t$indexed_read_count\t$nonindex_read_count";

foreach my $key (keys %read_counts)
{
   $header_str = $header_str."\t".$key;
   $number_str = $number_str."\t".$read_counts{$key};
}

print LOG $header_str."\n";
print LOG $number_str."\n";



