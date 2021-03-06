#!/usr/bin/sh

### takes all of the passing UMID files and compiles a fasta file listing the consensus sequence 				###
### with the header of each seqeunce listing the sample ID, the UMID and the number of supporting reads    		###                                        	 		###

### this loop is run outside of all the folders that correspond with the given sample ID e.g., vif-lai-15  		###

#for dir in vif-lai*/;  ### change the universal directory name as required e.g., Spl-pol-12 or whatever   		###
#do 
	#cd $dir; cd passing-umid; ### enter into the passing-umid directory that contains passing NNNNNNNN.txt files   ###

rm ../passing-umid.fa

	for file in *.txt;  ### go through each of the passing-umid files
	do 
		### the header of each consensus sequence must be in the format of sample-id_UMID_reads
		header=`echo $(cd .. && echo "${PWD##*/}")`;  ### moves one directory backward and extracts the name of the folder which is the sample-id
		header+=`echo "_"`; header+=`echo $file | cut -d'.' -f1`; ### adds an underscore after the sample-id in the header and then extracts the name of the text file which represents the UMID
		header+=`echo "_"`; header+=`head -n1 $file | cut -f1`; ### adds another underscore in the header and extracts the number of reads that support that consensus sequence which is in the first field of the first line of the file
		read=`head -n1 $file | cut -f2`; echo -e ">$header\n$read" >>../passing-umid.fa;  ### extracts the consensus sequence and makes the fasta-formatted line of >header\nconsensus-seq and concatenates into a new file called passing-umid.fa
	done

	#cd ../..; ### return to the parent directory and repeat this step for all the folders (AKA: sample-ids)

#done

