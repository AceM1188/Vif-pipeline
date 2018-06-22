#!/usr/bin/sh

### this shell script should be run on the sample.txt file that has the UMID\tread             ###

file=$1
### sample name is the string before the period                                                ###
name=`echo $file | cut -d'.' -f1`

cut -f1 "$name.txt" >tmp
### the loop will read through the lines of the sample.txt file and create files               ###
### containing all the distinct reads pertaning to that UMID                                   ###
while read line; 
do 
out=`echo $line.txt`; 

### extract all the reads that have the same UMID and send them to a file called 'UMID.txt'    ###
### 'UMID.txt' file has read_count\tread\tfraction_of_total_reads                              ###
awk -v var="$line" '$1 == var' $name.txt | cut -f2 | sort | uniq -c | sed -e 's/^[ \t]*//g' | sed -e 's/ /\t/g' >$out; 
sum=`awk '{total += $1} END {print total}' $out`; 
awk -v sumvar="$sum" '{print $1"\t"$2"\t"$1/sumvar}' $out | sort -nr -k3,3 >tmp2 && mv tmp2 $out; 
done <tmp