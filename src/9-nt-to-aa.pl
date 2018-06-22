#!/usr/bin/perl
use Bio::SeqIO;

my $sequences = Bio::SeqIO->new( 
    -file   => shift,
    -format => "fasta",
    );

while ( my $dna = $sequences->next_seq ){
    my $protein = $dna->translate( 
        -codontable_id => 1, # standard genetic code
        -frame         => 1, #reading-frame offset 0
	);
    print $dna->display_id, "\n";
    print $protein->seq, "\n\n";
}
