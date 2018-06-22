use strict;

use lib("/home/ravi","/Users/ravi");

## for blast+
#blastn -query tmp.fa -task blastn -db  bdb/tcra_mm_1 -num_alignments 10000 -evalue 1e-10 -outfmt 0 -dust no -out tmp.blastn

use common_util::align::parseBlast_p;

my $pb=common_util::align::parseBlast_p->new();

## output goes to STDOUT

my $fh=undef;
$pb->init($fh);

$pb->parse_blast();

