#!/usr/bin/env bash

# __date__ 12 March 2015
# __author__ Sanjeev Sariya
# __location__ Price Lab 4th Fl, New Hampshire, Cube# 420F

#SBATCH --time=7-0:0:0  # - time to run          #changed on May 17 from 4 to 7 
#SBATCH -o "main_automate.%j.out"  # output 
#SBATCH -J spades_trimmo # job name 
#SBATCH  -p 128gb # partition to run 
#SBATCH  --nodes=1 # number of nodes -- 
#SBATCH -e "log_automate.%j.stderr"  # error log name 

# This script is called in from assembly_pipeline.sh 
# All sanity checks have already been performed in there. 
# We here do: assembly, sequencing typing using SRST (trimmomatic reads) and blast Sequence typing.
# Make sure you provide correct files for MLST SRST database. And change their path in perform_srst function. 

# ------       ------          ------                          ------           ------     ------   ------             ------ 

module load python2.7 samtools/0.1.18 bowtie2/2.2.3

perform_srst(){ # function begins for doing SRST Sequence typing .. 
# $1 is dir of trimmed reads # $2 forward trimmed reads  # $3 reverse trimmed reads 
    
    delim='-'
    mlst_db="Staphylococcus_aureus" # do not add fasta to it. PLEASE
    mlst_def="saureus.txt"

    if [ ! -f $mlst_db".fasta" ] || [ ! -f $mlst_def ] # checks in current directory
    then
	printf "Sorry mlst files for srst are incorrect. Aborting mission... \n" >> `pwd`/logs_srst.log
	return 1;
    fi 

    temp_for=$1/$2 # concatenate out_dir and forward read
    temp_rev=$1/$3  # concatenate out_dir and reverse read

    index_read=$(echo $temp_for | grep -bo "_R1" | awk 'BEGIN {FS=":"}{print $1}'  )
    
    if [ "$index_read" == "" ] # _R1 pattern isn't avail..  Exit function
    then 
	printf "\nThe reads here do not match our pattern for $isolate. Exiting Sequence typing function. Team Fall back!\n "  >> `pwd`/logs_srst.txt
	return 1;
    fi

    index_fastq=$(echo $temp_for | grep -bo ".fastq.gz" | awk 'BEGIN {FS=":"} {print $1}')    
    for_suff=${temp_for:$index_read:$index_fastq-$index_read} # get forward suffix

    index_read=$(echo $temp_rev | grep -bo "_R2" | awk 'BEGIN {FS=":"}{print $1}' )

    if [ "$index_read" == "" ] # _R2 pattern isn't available.. Exit function 
    then 
	printf "\nThe reads here do not match our pattern $isolate. Exiting Sequence typing function. Team Fall back! \n "  >> `pwd`/logs_srst.txt
	return 1;
    fi

    index_fastq=$(echo $temp_rev | grep -bo ".fastq.gz" | awk 'BEGIN {FS=":"} {print $1}')
    rev_suff=${temp_rev:$index_read:$index_fastq-$index_read} # get reverse suffix

    set -x
    printf "\nThings went well for $isolate forward suff is $for_suff reverse suff is $rev_suff.\n"  >> `pwd`/logs_srst.txt
 
    ~/srst2-master/scripts/srst2.py --input_pe $temp_for $temp_rev --forward $for_suff --reverse $rev_suff --output $isolate  --log --save_scores --mlst_db $mlst_db".fasta" --mlst_definitions $mlst_def --mlst_delimiter $delim  

    output_mlst=$isolate"__mlst__"$mlst_db"__results.txt"

    sed -i -e 's/out_paired_//g' $output_mlst # edit 2 line, column to get rid of out_paired_

    printf "Reverse suffix is $rev_suff for $isolate \n"  >> `pwd`/logs_srst.txt
    printf "Forward suffix is $for_suff for $isolate \n" >> `pwd`/logs_srst.txt

    set +x

} #SRST function ends  

perform_assembly(){

#-- run spades--
# it runs mismatch corrector with --careful flag <which is recommended> # Default gzip output # Default runs bayes_hammer for read correction and assembler 

    set -x
    printf "We are going to run SPAdes with cut_off $cut_off \n"

    python /c1/apps/spades/SPAdes-3.5.0-Linux/bin/spades.py -t $num_threads --cov-cutoff $cut_off --careful -1 $out_dir/"out_paired_"$temp_forw_read -2 $out_dir/"out_paired_"$temp_rev_read -o $out_dir 

    if [ -f $out_dir/"contigs.fasta" ] # if contigs.fasta exists
    then
	printf "Run QUAST on contigs files\n"
	mkdir $out_dir/"contigs_quast"
	python /c1/apps/quast/quast-2.3/quast.py --threads $num_threads $out_dir/"contigs.fasta" -o $out_dir/"contigs_quast"
	printf "Done quality check for contigs using Quast\n"

    else
	printf "No Contigs file was generated\n"
    fi

    if [ -f $out_dir/"scaffolds.fasta" ] # if scaffolds.fasta exists
    then 
	printf "Run Quast on scaffolds file\n"
	mkdir $out_dir/"scaffolds_quast"
	python /c1/apps/quast/quast-2.3/quast.py --threads $num_threads $out_dir/"scaffolds.fasta" -o $out_dir/"scaffolds_quast"	
	printf "Done quality check for scaffolds using Quast\n"
	
	python $script_dir/coverage_assembly.py -s $out_dir/"scaffolds.fasta" -o $out_dir/ -c $cut_off -r $forward_read
        printf "Done coverage file\n"

	temp_copy_dir=`dirname $out_dir` #this is passed into copy_bash script..                                                                                         
        bash $script_dir/copy_fasta_files.sh -a $out_dir -i $isolate -o $temp_copy_dir
	printf "copyied file Successfully\n"

    else
	printf "No scaffodls file was generated"
    fi

  #  if [ -f $out_dir/"scaffolds.fasta" ]
 #   then
#	python $script_dir/coverage_assembly.py -s $out_dir/"scaffolds.fasta" -o $out_dir/ -c $cut_off -r $forward_read 
#	temp_copy_dir=`dirname $out_dir` #this is passed into copy_bash script..
#	bash $script_dir/copy_fasta_files.sh -a $out_dir -i $isolate -o $temp_copy_dir
 #   else
#	printf "No fasta file was generated\n"
    #fi

    rm $out_dir/"out_unpaired_"$temp_forw_read $out_dir/"out_unpaired_"$temp_rev_read $out_dir/"before_rr.fasta" $out_dir/"before_rr.fastg"  # remove unpaired ends generated by trimmmomatic

    printf "Removed trimmomatic reads and SPAdes before files\n"

    if [ -d $out_dir/"misc" ] # if misc is present
    then
	rm -rf $out_dir/"misc"
	printf "Removed misc folder from SPAdes\n"
    else
	printf "No misc directory was present\n"
    fi

    set +x
} # assembly function ends 

# --- > 

usage() {   #spit out the usage
cat <<UsageDisplay
#################################################

# This script is called in from assembly_pipeline.sh 
# All sanity checks have already been performed in there. 
# We here do: assembly, sequencing typing using SRST (trimmomatic reads) and blast Sequence typing.

automate_process.sh -[t threads] -f <forward_read> -r <reverse_read> -o <output_Directory>  -a <illumina_adapter_file> -c <cut_off for SPAdes> -t <number of threads> -s <tasks to do> -w <dir_of_the_script_stored>
Default threads 16

#################################################

UsageDisplay
exit;
} # end of usage function 

if [ $# -eq 0 ] # exit if no arguments!   
then
    usage;
fi

#- ------- >> 

out_dir=""
forward_read=""
cut_off=""
reverse_read=""
adap_file=""
out_dir=""
tasks_to_do=""
num_threads=""
isolate=""
script_dir=""

# --- 
while getopts "w:s:c:f:r:a:t:o:h" args # iterate over arguments                             
do
    case $args in
	w)
	    script_dir=$OPTARG ;; # this is directory of the scripts stored
	c)
	    cut_off=$OPTARG ;; # covergae cut off for SPAdes .. 
	f)                                                  
            forward_read=$OPTARG ;; # forward strand                                        
	r) 
            reverse_read=$OPTARG ;; # reverse strand                  
        a)
            adap_file=$OPTARG ;; # adapter file                                                                          
        t)
            num_threads=$OPTARG ;;# number of threads
        o)
            out_dir=$OPTARG ;; # output directory
	s)
	    tasks_to_do=$OPTARG ;; #what things to do.. 
	h)
	    usage ;;
	*)
	    usage ;;

    esac # done with case loop                           
done # completed while loop 

temp_forw_read=`basename $forward_read` ; # get only base name of input file provided              
temp_rev_read=`basename $reverse_read` ; # --||--  
isolate=`basename $out_dir`

printf "we are going to run trimmomatic with phred33 settings\n"

java -jar /c1/apps/trimmomatic/Trimmomatic-0.33/trimmomatic-0.33.jar PE -phred33 -threads $num_threads -trimlog $out_dir/"trim_log.txt" $forward_read $reverse_read $out_dir/"out_paired_"$temp_forw_read $out_dir/"out_unpaired_"$temp_forw_read $out_dir/"out_paired_"$temp_rev_read $out_dir/"out_unpaired_"$temp_rev_read ILLUMINACLIP:$adap_file:2:25:10 MINLEN:30

if [[ $tasks_to_do -eq 3 ]] 
then

    perform_srst $out_dir "out_paired_"$temp_forw_read "out_paired_"$temp_rev_read;

    rm $out_dir/"out_unpaired_"$temp_forw_read $out_dir/"out_unpaired_"$temp_rev_read
    printf "\n<--Done with ONLY Sequence Typing-->\n"
fi

if [[ $tasks_to_do -eq 7 ]]
then    
    
    perform_srst $out_dir "out_paired_"$temp_forw_read "out_paired_"$temp_rev_read;
    printf "\n<--Done Sequence Typing -->\n"
    perform_assembly ;
    printf "\n<--Done with assembly -->\n"
fi

if [[ $tasks_to_do -eq 4 ]]
then   
    perform_assembly ;
    printf "\n<-- Done with ONLY assembly -->\n"
fi

printf "<--Done with isolate. Cheers!  -->\n"
