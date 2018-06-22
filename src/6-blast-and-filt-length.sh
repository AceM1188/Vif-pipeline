#!/usr/bin/sh

### this script does several things with the consensus sequences:					 				###
### 1. makes a blast database for which to align the consensus sequences							###
### 2. aligns all of the consensus sequences to the reference										###
### 3. produces an output file with mismatches as lowercase and gaps as hyphens						###
### 4. filters out sequences that when after aligninng are all the same length						###

### note that you need to have blastall installed on your system to do this (it is on the server)		###
### you also need to have the useParse.pl script made by Ravi in the parent folder					###

for dir in vif-lai*/; 
do 
	name=`echo $dir | cut -d'/' -f1`; ### extract the name of the sample 
	cd $dir; mkdir blast-files; ### make a blast-files directory to work all blast processes
	mv passing-umid.fa blast-files/.;
	cd blast-files; ### enter into the blast-files directory 

	### make a reference file with the reference sequence; the following sequence corresponds with the 270bp of vif
	echo ">nl4-3_vif" >ref.fa; echo "AGGGAAAGCTAGGGGATGGTTTTATAGACATCACTATGAAAGCCCTCATCCAAGAATAAGTTCAGAAGTACACATCCCACTAGGGGATGCTAGATTGGTAATAACAACATATTGGGGTCTGCATACAGGAGAAAGAGACTGGCATCTGGGTCAGGGAGTCTCCATAGAATGGAGGAAAAAGAGATATAGCACACAAGTAGACCCTGAACTAGCAGACCAACTAATTCATCTGTATTACTTTGACTGTTTTTCAGACTCTGCTATAAGAAAG" >>ref.fa; 
	cp ../../src/useParse_p.pl .; ### move Ravi's script from the parent directory to the blast-files directory
	makeblastdb -in ref.fa -dbtype nucl; ### make a blast database
	### blast the passing-umid.fa file against the reference file; the below criteria are the least stringent to prevent trimming of sequences and maintaining the mismatches
	### useParse_p.pl formats the output file to have lowercase mismatches and be in fasta format into a file called passing-umid-blast.out
	blastn -db ref.fa -query passing-umid.fa -reward 5 -penalty -4 -gapopen 8 -gapextend 6 | perl useParse_p.pl | grep -v 'SUB' | grep -v 'qb' | grep -v 'S:' | sed -e 's/Q://g' | sed -e 's/\ ref.fa\ len\=[0-9]*//g' >passing-umid-blast.out; 
	
	### this last line, temporarily converts the passing-umid-blast.out file into a tab delimited instead of fasta, selects for sequences that have a length more than 270bp (accounts for trimming that blast sometimes does if the last bp is a mismatch), and returns a fasta file with the filtered reads called passing-umid-blast.fa
	awk 'BEGIN{RS=">"}NR>1{sub("\n","\t"); gsub("\n",""); print RS$0}' passing-umid-blast.out | awk 'length($2)>270' | awk '{print $1"\n"$2}' >passing-umid-blastfilt.fa;

	cp passing-umid-blastfilt.fa ../$name"-final.fa"; ### makes a final file and moves it up one directory
	
	cd ../..; 


done


