# invoke as:
# perl get_r2_indeces_from_r1.pl --input_r1_fastq_file input_r1_fastq_file --input_r2_fastq_file input_r2_fastq_file --demux_index_length demux_index_length --output_r2_fastq_file output_r2_fastq_file 

use File::Basename;


use Getopt::Long;

GetOptions( 'input_r1_fastq_file=s' => \my $input_r1_fastq_file 
          , 'input_r2_fastq_file=s' => \my $input_r2_fastq_file  
          , 'demux_index_length=i' => \my $demux_index_length  
          , 'output_r2_fastq_file=s' => \my $output_r2_fastq_file 
          );

print("...\n");
print("Hello! My name is Indexter.\n");
print("I will copy indeces from $input_r1_fastq_file \n to $input_r2_fastq_file \n");
print("Index length is specified as $demux_index_length \n");

print("...\n");



unless (open (input_r1_fastq_file, "/usr/bin/zcat $input_r1_fastq_file | ")){ die ("Cannot read input file: $input_r1_fastq_file\n"); }#
unless (open (input_r2_fastq_file, "/usr/bin/zcat $input_r2_fastq_file | ")){ die ("Cannot read input file: $input_r2_fastq_file\n"); }#
unless (open (output_r2_fastq_file, "|-", "/usr/bin/gzip > $output_r2_fastq_file")){ die ("Cannot write output_r2_fastq_file: $output_r2_fastq_file\n"); }#v
#unless (open (output_r2_fastq_file, " > $output_r2_fastq_file")){ die ("Cannot write output_r2_fastq_file: $output_r2_fastq_file\n"); }#v

my $r1_read_count = 0;
my $r2_read_count = 0;
my $nonindex_read_count = 0;
my %read_counts = ();

$sttime = time;


while (my $line = <input_r1_fastq_file>) 
{
  
  $r1_read_count = $r1_read_count + 1;
  my $line_1 = $line;

  $line = <input_r1_fastq_file>;
  my $line_2 = $line;
  my $index = substr($line, 0, 6) ;
  #print $index."\n";
  my $read = substr($line, 6);

  $line = <input_r1_fastq_file>;
  my $line_3 = $line;

  $line = <input_r1_fastq_file>;
  my $line_4 = $line;
  #my $index = substr($line, 1, 6) ;
  my $index_qual = substr($line, 0, 6);
  my $read_qual = substr($line, 6);

  #print  "*Line 1:".$line_1;
  #print  "*Line 2:".$line_2;
  #print  "*Line 3:".$line_3;
  #print  "*Line 4:".$line_4;



  $r2_read_count = $r2_read_count + 1;

  $line = <input_r2_fastq_file>;
  my $line_1 = $line;

  $line = <input_r2_fastq_file>;
  my $dummy_seq = substr($line, 0, 6) ;
  #print $index."\n";
  my $read = substr($line, 6);
  my $line_2 = $index.$read;

  $line = <input_r2_fastq_file>;
  my $line_3 = $line;

  $line = <input_r2_fastq_file>;
  my $line_4 = $line;
  #my $index = substr($line, 1, 6) ;
  my $read_qual = substr($line, 6);
  my $line_4 = $index_qual.$read_qual;

  #print  "-Line 1:".$line_1;
  #print  "-Line 2:".$line_2;
  #print  "-Line 3:".$line_3;
  #print  "-Line 4:".$line_4;

  print output_r2_fastq_file $line_1.$line_2.$line_3.$line_4;

  if($r1_read_count % 1000000 == 0)
  {
     print("Processed $r1_read_count reads\n");
  }


}#while

$entime = time;
$elapse = $entime - $sttime;
print "Elapsed time : ".$elapse."s\n";



print "Finished reading \n $input_r1_fastq_file and $input_r2_fastq_file \n";
print "R1 read count: $r1_read_count \n";
print "R2 read count: $r2_read_count \n";
print "Wrote results to \n $output_r2_fastq_file  \n";

print "****************** Program ended *******************\n";




