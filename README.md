# Vif-pipeline
contains scripts and the overall pipeline to merge paired-end reads, parse by UMID, filter UMID, blast and identify mutations in vif amplicons

The master script: `vifmaster.sh` will call all of the scripts in the src folder to read and process through to arrive at a final fasta file for nucleotides and amino acids as well as a count for the individual nucleotide codons and amino acids at position 43 and position 41. 

Note that this must be run on the Simon lab server managed by Ravi Sachidanandam. There is one perl package in this pipeline that calls other packages he's developed that are maintained on the server.
