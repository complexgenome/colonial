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

Output files will be created from the folder you run


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

#header="Assembly  # contigs (>= 0 bp)  # contigs (>= 1000 bp)  Total length (>= 0 bp)  Total length (>= 1000 bp)  # contigs  Largest contig  Total length  GC (%)  N50     N75    L50  L75  # N's per 100 kbp"
#printf "%s" $header >> contigs_full_report.txtprintf "%s" $header >> scaffolds_full_report.txt

for f in $out_direc/*   # loop over isolate folders - where output directory provided -->
do
    if [[ -d $f ]] # if directory  -- 
    then
	isolate_name=`basename $f`

	if [ -d $f/"contigs_quast" ] # if contigs_quast folder available
	then
	    # Added code on Apr 28. Maliha's code.
	    if [ -f $f/"contigs_quast"/transposed_report.txt ]
	    then
		sed -n '4p' $f/"contigs_quast"/transposed_report.txt | sed "s/contigs/$isolate_name/g"  >> contigs_full_report.txt
	    else
		printf "$f doesn't have QUAST report\n"
	    fi
	else
	    printf "$isolate_name didn't have contigs_quast Folder \n"  >> log_quality.txt 
	fi # end of contigs_quast check

	if [ -d $f/"scaffolds_quast" ] # if scaffolds folder avail..!
	then
	    if [ -f $f/"scaffolds_quast"/transposed_report.txt ]
	    then
		sed -n '4p' $f/"scaffolds_quast"/transposed_report.txt | sed "s/scaffolds/$isolate_name/g"  >> scaffolds_full_report.txt
	    else
		printf "$f does not have QUAST report\n"
	    fi
 	else
	    printf "$isolate_name doesn't have scaffolds folder\n" >> log_quality.txt
	fi # if scaffolds folder available!

    fi # end of if loop to check directory
done # end of looping of assembly outputs

printf "\nPlease check contigs_full_report.txt and scaffolds_full_report.txt in "`pwd`"\n"
printf "\nPlease check log_quality.txt in "`pwd`" <not necessarily to be present>\n"
printf "\n<-Done consolidating Quality from contigs and scaffolds->\n\n"