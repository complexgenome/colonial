#!/usr/bin/env bash

# Date 1 Mar 2016

# This script takes in input directory .. Input directory has ST folders.. 
# Each ST folder has output folder generated from NASP
# each of these output folder has matrices folder
# Each matrices folder has bestsnp.fasta

# - It assumes the executable edit_fasta is in script's directory

#Input Directory
#    -ST45
#    -    output
#    -    -    matrices
#    -    -    -    -bestsnp.fasta

# This script is going to call edit_fasta in the current directory
#
#
#

# bash loop_best_snp_fasta.sh -d /groups/pricelab/FUTI_analysis/phylogenetic_trees/nasp/ -o /lustre/groups/pricelab/sanjeev_files/io_files/edited_fasta

usage() {   #spit out the usage
    cat <<UsageDisplay
#################################################

    loop_best_snp_fasta.sh -d input_dir -o output_dir

#################################################
UsageDisplay
exit;
} # end of usage function --
check_input(){
    
    if [ "$input_dir" == "" ] || [ ! -d "$input_dir" ]
    then
	printf "Incorrect input directory\n"
	usage;
    fi
    
    input_dir=$(cd $(dirname $input_dir) ; pwd)/`basename $input_dir` # make full path ..
    
    if [ "$output_dir" == "" ] || [ ! -d "$output_dir" ]
    then
	printf "Incorrect output directory\n"
	usage;
    fi
    output_dir=$(cd $(dirname $output_dir) ; pwd)/`basename $output_dir` # make full path ..
}
# -- function ends

if [ $# -eq 0 ] # exit if no arguments!
then
    usage;
fi

input_dir=""
output_dir=""

while getopts "o:d:h" args # iterate over arguments
do
    case $args in
	d)
	    input_dir=$OPTARG;; #store input direct
	o)
	    output_dir=$OPTARG;;
	h)
	    usage;
	      
    esac # done with case loop
done # completed while loop

check_input;

total_dir=0
found_best_snp=0

for i in `ls $input_dir | sort`
do
    total_dir=`expr 1 + $total_dir` # increment total isolates --
    fasta_file=$input_dir/$i/output/matrices/bestsnp.fasta
    
    if [ -f $fasta_file ]
    then
	found_best_snp=` expr 1 + $found_best_snp `
    else
	printf "$fasta_file missing"
    fi

done

printf "$total_dir Total directories\n"
printf "$found_best_snp total found bestsnp fastas \n"

if [ $total_dir != $found_best_snp ]
then
    printf "Incorrect number of files\n"
    exit;
else
    printf "Things are fine.. Move-on \n"
fi


for i in `ls $input_dir | sort`
do
 
    fasta_file=$input_dir/$i/output/matrices/bestsnp.fasta
    # get the path for fasta file
    
    if [ -d "$output_dir/$i" ]
    then
	printf "Something is fishy for $i\n"
	exit;
    else
	mkdir $output_dir/$i
	
	./edit_fasta -f $fasta_file >> $output_dir/$i/"bestsnp.fasta"
	#c++ executable that parses and edits fasta file from NASP 
    fi

done
