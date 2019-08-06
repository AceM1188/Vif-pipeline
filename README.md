# Vif-pipeline
contains scripts and the overall pipeline to merge paired-end reads, parse by unique molecular IDs (UMIDs), filter UMID, blast and identify mutations in vif amplicons

The master script: `vifmaster.sh` will call all of the scripts in the src folder to read and process through to arrive at a final fasta file for nucleotides and amino acids. In addition, two tab-delimited files will be produced that display the counts of all unique nucleotide codons or amino acids at Vif position 41 (`41ct.txt` or `41ct-aa.txt`) and position 43 (`43ct.txt` or `43ct-aa.txt`).

Note that this must be run on the Simon lab server managed by Ravi Sachidanandam at the Icahn School of Medicine at Mount Sinai. There is one perl script in this pipeline (`useParse_p.pl`) that calls other packages he's developed that are maintained on the server.

Of note, this pipeline is set to run Vif sequences and is dependent on what primers are used for PCR amplification of Vif sequences. If other sequences are to be run on this platform please adjust parameters in the necessary component files (e.g., #1, #6, #7). 

Finally, the file `vif-stream.txt` contains the lines of code (`R`) to make streamgraphs through the streamgraph widget (please see `https://hrbrmstr.github.io/streamgraph/`) for generating graphics of evolution of the different nucleotide codons or amino acids at either Vif position 41 or position 43.

For questions, please contact matthew.hernandez@icahn.mssm.edu
