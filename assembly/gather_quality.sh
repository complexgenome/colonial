#!/usr/bin/env bash

# __author__ sanjeev sariya
# __date__ Mar 20 2015
# __location__ 420 Cube, 4th FL New Hampshire NW

usage() {   #spit out the usage
cat <<UsageDisplay
#################################################

gather_quality.sh  -d <assembly output directory>
Option(s):
-d output directory of assembled genomes

#################################################
UsageDisplay
exit;
} # end of usage function

##
check_dir(){ # function to check direct

if [ "$out_direc" == "" ] || [ ! -d "$out_direc" ] 
then
    printf "Sample/output directory incorrect\n"
    usage;
fi

} # end of check_dir function 

## ------- iterate over arguments  >>         

out_direc=""

while getopts "d:" args # iterate over arguments
do
    case $args in
        d) 
            out_direc=$OPTARG ;; # store sample direc
        h) 
            # help
            usage ;;
        *) 
            # any other flag which is not an option
            usage ;;

    esac # done with case loop
done # completed while loop

# ---- 

if [ $# -eq 0 ] # exit if no arguments!
then
    usage;
fi 

check_dir;

for f in $out_direc/*   # loop over isolate folders - where output directory provided -->
do
    if [[ -d $f ]] # if directory  -- 
    then
	isolate_name=`basename $f`

	if [ -d $f/"contigs_quast" ] # if contigs_quast folder available
	then
#	    printf "$isolate_name\n" >> contigs_quality.tsv # take isolate name!
	#   tail -1 $f/"contigs_quast"/transposed_report.txt >> contigs_quality.txt # get last line#	    tail -2 $f/"contigs_quast"/transposed_report.tsv >> contigs_quality.tsv # get last line#	    printf "#\n" >> contigs_quality.tsv

	    # Added code on Apr 28. Maliha's code.

	    sed -n '4p' $f/"contigs_quast"/transposed_report.txt | sed "s/contigs/$isolate_name/g"  >> contigs_full_report.txt

	else
	    printf "$isolate_name didn't have contigs_quast Folder \n"  >> log_quality.txt 
	fi # end of contigs_quast check

	if [ -d $f/"scaffolds_quast" ] # if scaffolds folder avail..!
	then
#	    printf "$isolate_name\n" >> scaffolds_quality.tsv  # take isolate name
#	    tail -1 $f/"scaffolds_quast"/transposed_report.txt >> scaffolds_quality.txt # get last line
#	    tail -2 $f/"scaffolds_quast"/transposed_report.tsv >> scaffolds_quality.tsv # get last line
#	    printf "#\n" >> scaffolds_quality.tsv

	    sed -n '4p' $f/"scaffolds_quast"/transposed_report.txt | sed "s/scaffolds/$isolate_name/g"  >> scaffolds_full_report.txt

 	else
	    printf "$isolate_name doesn't have scaffolds folder\n" >> log_quality.txt
	fi # if scaffolds folder available!

    fi # end of if loop to check directory
done # end of looping of assembly outputs

printf "\nPlease check contigs_full_report.txt and scaffolds_full_report.txt in "`pwd`"\n"
printf "\nPlease check log_quality.txt in "`pwd`" <not necessarily to be present>\n"
printf "\n<-Done consolidating Quality from contigs and scaffolds->\n\n"