#!/usr/bin/sh

### once done with filtering all the UMIDs based on read criteria, this script will ####
### concatenate all metrics into the original sample_metric.txt file 				####

cat one-read-umid/[ATGC]*.txt >tmp
one_ct=`awk '{total += $1} END {print total}' tmp`
cat two-read-umid/[ATGC]*.txt >tmp
two_ct=`awk '{total += $1} END {print total}' tmp`
cat insufficient-read-umid/[ATGC]*.txt >tmp
bad_ct=`awk '{total += $1} END {print total}' tmp`
cat passing-umid/[ATGC]*.txt >tmp
pass_ct=`awk '{total += $1} END {print total}' tmp`
ls -l one-read-umid/[ATGC]*.txt >tmp
one_umid_ct=`grep -E [ATGC]*.txt tmp | wc -l | sed -e 's/^[ \t]*//g' | sed -e 's/ /\t/g' | cut -f1`
ls -l two-read-umid/[ATGC]*.txt >tmp
two_umid_ct=`grep -E [ATGC]*.txt tmp | wc -l | sed -e 's/^[ \t]*//g' | sed -e 's/ /\t/g' | cut -f1`
ls -l insufficient-read-umid/[ATGC]*.txt >tmp
bad_umid_ct=`grep -E [ATGC]*.txt tmp | wc -l | sed -e 's/^[ \t]*//g' | sed -e 's/ /\t/g' | cut -f1`
ls -l passing-umid/[ATGC]*.txt >tmp
pass_umid_ct=`grep -E [ATGC]*.txt tmp | wc -l | sed -e 's/^[ \t]*//g' | sed -e 's/ /\t/g' | cut -f1`
echo "No. of passing UMIDs:\t$pass_umid_ct" >>"*_metric.txt"
echo "Corresponding No. of passing reads:\t$pass_ct" >>"*_metric.txt"
echo "No. of UMIDs with two reads:\t$two_umid_ct" >>"*_metric.txt"
echo "Corresponding No. of reads for two-UMIDs:\t$two_ct" >>"*_metric.txt"
echo "No. of UMIDs with one read:\t$one_umid_ct" >>"*_metric.txt"
echo "Corresponding No. of reads for one-UMIDs:\t$one_ct" >>"*_metric.txt"
echo "No. of UMIDs without a consensus seq:\t$bad_umid_ct" >>"*_metric.txt"
echo "Corresponding No. of reads for UMIDs without consensus:\t$bad_ct" >>"*_metric.txt"