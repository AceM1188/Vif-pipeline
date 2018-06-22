#!/usr/bin/sh

### filters the 'UMID.txt' files into four different groups:                     	 		###
### 1. UMIDs only supported by one read                                          	 		###
### 2. UMIDs only supported by two reads                                         	 		###
### 3. Passing UMIDs (UMIDs supported by a consensus defined by >=70% of the reads)  		###
### 4. Insuffieicnt read UMIDs (UMIDs without a consensus defined by >=70% of the reads) 	###  

### make directories for each of th edifferent UMID files containing the reads              ###
mkdir one-read-umid
mkdir two-read-umid
mkdir passing-umid
mkdir insufficient-read-umid

### loop through the UMID files which are labeled as NNNNNNNN.txt                           ###
### make sure that you are in the directory for the given sample e.g., vif-lai-15 to run    ###
### this loop                                                                               ###
for file in [ATGC]*.txt;
do
    reads=`awk '{total += $1} END {print total}' $file`   ### summ up the total number of reads by adding up the numbers of the first column
    if [ "$reads" -eq 1 ]
	then mv $file one-read-umid/.
	elif [ "$reads" -eq 2 ]
	then mv $file two-read-umid/.
	elif [ "$reads" -ge 3 ]
	then awk -v file="$file" 'NR==1 { if ($3 >= 0.7) system("mv "file" ./passing-umid/."); else system("mv "file" ./insufficient-read-umid/"); }' $file 
	### there must be more than or equal to  3 reads total to support the given UMID
fi
done