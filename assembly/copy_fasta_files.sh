#!/usr/bin/env bash

# __date__ 22 April 2015                                                                                                                           
# __author__ Sanjeev Sariya                                                                                                                  
# __location__ Price Lab 4th Fl, New Hampshire, Cube# 420F

#SBATCH -p short 
#SBATCH --nodes=1 
#SBATCH -J copyFasta 
#SBATCH --time 10:0 
#SBATCH -o "out_copy.%j.out" 
#SBATCH -e "error_copy.%j.stderr"
 
# This file is called from assembly_pipeline.sh
# It copies scaffolds and contigs file to all_scaffold and all_contigs fasta file 
# Also, it renames info_cov_node files for each isolate and moves to it the desitnation as mentioned in command
#

while getopts "o:a:i:" args # iterate over arguments                                                                                                                                  
do
    case $args in

	i)
	    isolate=$OPTARG ;; # isolate name
        a)
            assembled_dir=$OPTARG ;; # directory where all isolates have been assembled                                                                 
        o)
            out_dir=$OPTARG ;; # output directory                                                                                                                                      
    esac # done with case loop                                                                                                                          
done # completed while loop

set -x
cp $assembled_dir/"scaffolds.fasta" $out_dir/"all_sample_scaffolds_fasta"/$isolate"__scaffolds.fasta"
cp $assembled_dir/"contigs.fasta" $out_dir/"all_sample_contigs_fasta"/$isolate"__contigs.fasta"
cp $assembled_dir/"info_cov_node.txt" $out_dir/"all_sample_info_cov_per_node"/$isolate"__info_cov_node.txt"

info_cov_node.txt 
set +x
