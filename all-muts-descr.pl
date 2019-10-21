#!/usr/bin/perl
use strict;
use warnings;

### takes in aligned fasta files with the first seq as the reference RT or vif sequence and counts all substitutions as well as subs at distinct GG/GA dinucleotide motifs ###

my $file = shift;
open(IN, '<', $file) or die "can't open file $file $!\n";

my $snme=$file; $snme=~s/_with-ref.fa//;
my $out=$file; $out=~s/_with-ref.fa//; $out.="_muts.txt";

open(OUT, '>', $out) or die "can't open file $out $!\n";

### the ref seq below is for RT targeted region; if targetting vif region, this needs to be changed ###
my $nl43 = 'CAGACATAGTCATCTATCAATACATGGATGATTTGTATGTAGGATCTGACTTAGAAATAGGGCAGCATAGAACAAAAATAGAGGAACTGAGACAACATCTGTTGAGGTGGGGATTTACCACACCAGACAAAAAACATCAGAAAGAACCTCCATTCCTTTGGATGGGTTATGAACTCCATCCTGATAAATGGACAGTACAGCCTATAGTGCTGCCAGAAAAGGACAGCTGGACTGTCAATGACATACAGA';

#look at dinucleotide motifs
my $GG2AGmuts = 0;
my $GA2AAmuts = 0;

#count all other transitions and transversions
my $AtoT = 0;
my $AtoG = 0;
my $AtoC = 0;

my $TtoA = 0;
my $TtoC = 0;
my $TtoG = 0;

my $CtoA = 0;
my $CtoT = 0;
my $CtoG = 0;

my $GtoA = 0;
my $GtoC = 0;
my $GtoT = 0;

#transitions = G<->A + C<->T; transversions = G<->C + G<->T + A<->C + A<->T
my $transitions = 0;
my $transversions = 0;

while(my $line =<IN>){
    chomp $line;
    my $cdna_count=$line; $cdna_count=~s/\>//;
    my $seq=<IN>; $seq=~s/\n//;
    
    my $result='';
        
    for(0..length($seq)){
        my $base = substr($seq, $_, 1);
        my $nlbase = substr($nl43, $_, 1);
        
        #mutations from A bp
        if($nlbase eq 'A' && $base eq 't'){
            $AtoT++;
        }
        if($nlbase eq 'A' && $base eq 'g'){
            $AtoG++;
        }
        if($nlbase eq 'A' && $base eq 'c'){
            $AtoC++;
        }
        
        #mutations from T bp
        if($nlbase eq 'T' && $base eq 'a'){
            $TtoA++;
        }
        if($nlbase eq 'T' && $base eq 'g'){
            $TtoG++;
        }
        if($nlbase eq 'T' && $base eq 'c'){
            $TtoC++;
        }
        
        #mutations from C bp
        if($nlbase eq 'C' && $base eq 'a'){
            $CtoA++;
        }
        if($nlbase eq 'C' && $base eq 'g'){
            $CtoG++;
        }
        if($nlbase eq 'C' && $base eq 't'){
            $CtoT++;
        }
        
        #mutations from G bp
        if($nlbase eq 'G' && $base eq 'a'){
            $GtoA++;
        }
        if($nlbase eq 'G' && $base eq 'c'){
            $GtoC++;
        }
        if($nlbase eq 'G' && $base eq 't'){
            $GtoT++;
        }
        
        
        my $dinucleotide = substr($nl43, $_, 2);
    
        if($nlbase eq 'G' && $base eq 'a'){
            if($dinucleotide eq 'GG' ){
                $GG2AGmuts++;
            }
            elsif($dinucleotide eq 'GA' ){
                $GA2AAmuts++;
            }
        }
    }
}

$transitions = $AtoG + $TtoC + $CtoT + $GtoA;
$transversions = $AtoT + $AtoC + $TtoA + $TtoG + $CtoA + $CtoG + $GtoC + $GtoT;

#print "Sample\GG-to-GA_muts\tGA-to-AA_muts\n"
#print "$snme\t$GG2AGmuts\t$GA2AAmuts\n";
print OUT "Sample\tAtoT\tAtoG\tAtoC\tTtoA\tTtoG\tTtoC\tCtoA\tCtoG\tCtoT\tGtoA\tGtoC\tGtoT\tGG\>AG_muts\tGA\>AA_muts\tTransitions\tTransversions\n";
print OUT "$snme\t$AtoT\t$AtoG\t$AtoC\t$TtoA\t$TtoG\t$TtoC\t$CtoA\t$CtoG\t$CtoT\t$GtoA\t$GtoC\t$GtoT\t$GG2AGmuts\t$GA2AAmuts\t$transitions\t$transversions\n";
close IN;
