#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
#use List::moreutils qw(uniq);

### This program is designed to organize amino acid or nucleotide codon counts
### into a tab delimited format across all given samples
### Your input should look like:  vif-lai-15\n100\tAAG\n20\tATG\n...vif-lai-28\n...


my $input = shift;
open(IN, '<', $input) or die "can't open file $input $!\n";

my $sample;
my %HoH;
my $codon;
my $count;

while(my $line =<IN>){
    
    if ($line =~ /^(vif-.*?-.*?)\n/) {
    $sample = $1;
    }
    
    #elsif ($line =~ /\d*\t[ATGC-]{3}\n/){     #for nucleic acids
    elsif ($line =~ /\d*\t[A-Z\*]{1}\n/){      #for amino acids
	($count, $codon) = split /\t/, $line;
	chomp $codon;                          #remove the empty line space from the element
	$HoH{$sample}{$codon} = $count;
    }

    else{ next };
}

my @list_of_codons;

foreach my $timept (sort keys %HoH){
    foreach my $aa (keys %{ $HoH{$timept} }) {
	push @list_of_codons, $aa;
    }
}



my @uniq_codons;
my %seen;


### you need to make a list of the unique codons that are found across
### the different samples so you can make a table
 
foreach my $value (@list_of_codons) {
    if (! $seen{$value}++ ) {
	push @uniq_codons, $value;
    }
}

### print out the first line of the chart which has an indent, the unique amino acids
print "\t",join("\t",@uniq_codons),"\n";


foreach my $id (sort keys %HoH){
    print "$id\t";
    my @list;
    foreach my $uniq_aa (@uniq_codons){
	
	if ( exists $HoH{$id}{$uniq_aa} ){
	    push @list, $HoH{$id}{$uniq_aa};
	}
	else{
	    push @list, "0";
	}
    }

    print join("\t",@list),"\n";
}


### this subroutine can be used to get the unique elements of a given input list	    
#sub uniq { keys { map { $_ => 1 } @_ } };
#print Dumper(\%HoH);

