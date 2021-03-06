#!/usr/bin/sh

rm tmp41
rm tmp43

for dir in vif-lai*; 
do 
	name=`echo $dir | cut -d'/' -f1`; 
	cd $dir; 
	echo $name >>../tmp41; 
	echo $name >>../tmp43;
	grep -v ">" "$name-final.fa" | cut -c26,27,28 | sort | uniq -c | sed -e 's/^[ \t]*//g' | sed -e 's/ /\t/g' | tr a-z A-Z >>../tmp41; 
	grep -v ">" "$name-final.fa" | cut -c32,33,34 | sort | uniq -c | sed -e 's/^[ \t]*//g' | sed -e 's/ /\t/g' | tr a-z A-Z >>../tmp43; 
	cd ..; 
done


# note that to assess other codons within nl4-3 vif seq, change the numbering in the ...cut -c... portion of code (e.g., for vif-45: cut -c38,39,40)



