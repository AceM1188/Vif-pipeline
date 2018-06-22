#!/usr/bin/perl
use strict;
use warnings;

### input file is the fastq file which should exist as 'sample.fastq' ###
my $file=shift;

### pull out the sample name which should be prior to the '.fastq'    ###
my $sample_name=$file; $sample_name=~s/\.merged\.fastq//;

### make output files for the UMID\tread                              ###
my $out=$file; $out=~s/\.merged\.fastq//; $out.=".txt";
### or the metric output file                                         ###
my $metric_out=$file; $metric_out=~s/\.merged\.fastq//; $metric_out.="_metric.txt";

open IN,$file or die "FAIL:$file";
open OUT,">$out" or die "FAIL:$out";
open OUT2,">$metric_out" or die "FAIL:$out";

my $tot=0;
my $bad_umid=0;
my $bad_seq=0;


### enter the file and the second line is the read defined as $seq    ###
### $tot will count every 4 lines to determine the number of reads    ###
while(my $line=<IN>){
    my $seq=<IN>;
    my $tmp=<IN>;
    $tmp=<IN>;
    $tot++;


### the vif read needs to end in the sequence of AAGNNNNNNNN where N  ###
### is [ATGC]. The UMID is defined as the variable string \w{8}       ###
    my $umid;
    my $seq_no_umid;
    if($seq=~/AAG(\w{8})$/){
	$umid=$1;

### take off the UMID to extract the read only                        ###
### otherwise, do not pass the read into the output file as it is a   ###
### bad read because the UMID is in the incorrect position.           ###
### Go to the next sequence after                                     ###

	$seq_no_umid = substr $seq, 0, -9;
    } else{
	$bad_umid++;
	next;
    }
    chomp($seq);

### check the front of the read and see if it begins with A[AG] as it ###
### should. (the AorG accounts for any APOBEC3 mutation (G-to-A)).    ### 
### if it does not, it is considered a bad read and does not make it  ###
### to the output file                                                ###

    if($seq!~/^A[AG]/){
	$bad_seq++;
	next;
    }
    print OUT "$umid\t$seq_no_umid\n";
}

### determine the total number of reads that were idenfied with UMIDs ###
### defined by the variable $final_reads                              ###

open OUT,$out or die "oops!\n";
my $final_reads=0;
$final_reads++ while <OUT>;

### add all of the metric results to the 'sample_metric.txt' file     ###
print OUT2 "Total\ reads:\ $tot\nReads\ with\ bad\ UMID:\ $bad_umid\nBad\ seqs:\ $bad_seq\nReads\ with\ intact\ UMID:\ $final_reads\n";
close IN;
close OUT;
