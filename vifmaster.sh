#!/usr/bin/sh

### note that these scripts only work with bash 4.1.2(1)-release (x86_64-redhat-linux-gnu) which is the version on Ravi's server
### this script is the master pipeline																									###
### first you need to make sure that all scripts (perl and shell) are located in a folder called src									###
### second, all fastq files must be in whatever folder this script is located in 														###
### make sure all your fastq files are named pol-spl-xx or vif-lai-15 or etc															###

### align the paired reads which should have a label name like vif-lai-15_S1_L001_R1_001.fastq and vif-lai-15_S1_L001_R2_001.fastq		###
### you want to extract the name vif-lai-15 (or whatever you have labeled) to be used as every type of organization from hereon in		###
### you need to have Paired-End reAd mergeR installed: https://sco.h-its.org/exelixis/web/software/pear/								###

### make an array with all of the sample names prior to the 'S1' extract 																###
ls *fastq | cut -d'_' -f1 | sort | uniq | sed -e 's/^[ \t]*//g' | sed -e 's/ /\t/g' >tmp


IFS=$'\n' read -d '' -r -a array < tmp

echo -e "1. I'm now aligning paired-end reads\n"

for element in ${array[@]}; 
do
    forward=`echo $element\*R1\*`;
    reverse=`echo $element\*R2\*`;
    pear -f $forward -r $reverse -o $element;
    mkdir $element;
    mv "$element.assembled.fastq" "$element.merged.fastq";
    mv $element*.fastq $element/;
    echo $element/;
done

echo -e "2. I'm now identifying the UMIDs with each read\n"

for dir in vif-lai*/;
do
	sample=`echo $dir | cut -d'/' -f1`;
	cd $dir;
	mkdir fastq;
	mv *.fastq fastq/;
	perl ../src/1-vif-umid-identifier.pl fastq/$sample.merged.fastq;
	mv fastq/$sample.txt .;
	mv fastq/$sample_metric.txt .;
	cd ..;
done

echo -e "3. I'm now creating consensus reads and determining how many reads support each consensus\n"

for dir in vif-lai*/;
do
	sample=`echo $dir | cut -d'/' -f1`;
	cd $dir;

	if ls passing-umid/[ATGC]*.txt 1> /dev/null 2>&1;
		then echo -e "UMID files already created\n" && continue
	else sh ../src/2-mywrapper.sh "$sample.txt"
	fi
	cd ..;
done

echo -e "4. I'm now filtering the consensus reads (UMID files)\n"

for dir in vif-lai*/;
do
	cd $dir;
	
	if ls passing-umid/[ATGC]*.txt 1> /dev/null 2>&1;
		then echo -e "UMID files already filtered\n" && continue
	else sh ../src/3-filter.sh
	fi
	cd ..;
done

echo -e "5. I'm now compiling metrics after all filtering events\n"

for dir in vif-lai*/;
do
	cd $dir;
	sh ../src/4-metrixrx.sh
	cd ..;
done

echo -e "6. I'm now compiling all of the final fasta consensus sequences\n"

for dir in vif-lai*/;
do
	cd $dir; cd passing-umid;
	sh ../../src/5-compile-passing-umid.sh;
	cd ../..;
done

echo -e "7. I'm now going to blast all the consensus reads against the reference sequence and creating a final output fasta file\n"

sh src/6-blast-and-filt-length.sh 

echo -e "8. I'm now going to extract the vif nucleotide codons corresponding with amino acids at the 41st and the 43rd position\n"

sh src/7-extract-codons.sh
perl src/8-nt-formatter.pl tmp41 >41ct.txt
perl src/8-nt-formatter.pl tmp43 >43ct.txt

echo -e "9. I'm not going to extract the vif amino acids at the 41st and 43rd postion\n"

rm tmp_aa41
rm tmp_aa43

for dir in vif-lai*/;
do
	sample=`echo $dir | cut -d'/' -f1`;
	cd $dir;
	perl ../src/9-nt-to-aa.pl "$sample-final.fa" | sed -e 's/vif/>vif/g' | awk 'NF' >"$sample-final-aa.fa";

	echo $sample >>../tmp_aa41; 
	echo $sample >>../tmp_aa43;
	grep -v ">" "$sample-final-aa.fa" | cut -c9 | sort | uniq -c | sed -e 's/^[ \t]*//g' | sed -e 's/ /\t/g' >>../tmp_aa41;
	grep -v ">" "$sample-final-aa.fa" | cut -c11 | sort | uniq -c | sed -e 's/^[ \t]*//g' | sed -e 's/ /\t/g' >>../tmp_aa43;
	cd ..; 
done

perl src/9-aa-formatter.pl tmp_aa41 >41ct-aa.txt
perl src/9-aa-formatter.pl tmp_aa43 >43ct-aa.txt

rm tmp*
echo -e "I'M DONE!!!!!\n"




