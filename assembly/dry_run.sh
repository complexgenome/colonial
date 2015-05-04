#!/usr/bin/env bash

# __date__ 4 March 2015                                                                                                                            
# __author__ Sanjeev Sariya                                                                                                                  
# __location__ Price Lab 4th Fl, New Hampshire, Cube# 420F

#< - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ->

get_fastq_files(){ # get reverse and foward strand of sample isoltae

    # paramter is $1
    trim_forward=""
    trim_reverse="" # variables to store trim reads, if available

    regex_for='(\_L00[0-9]+)?\_R1+(\_001)?(\_trimmed)?\.fastq\.gz$'
   # regex_for='\_L00[0-9]+\_R1+(\_001)?\.fastq\.gz$'
    regex_rev='(\_L00[0-9]+)?\_R2+(\_001)?(\_trimmed)?\.fastq\.gz$' 
   # regex_rev='\_L00[0-9]+\_R2+(\_001)?\.fastq\.gz$' 
  
    array_name=($(find -L $sample_direc -name "*$1*" 2>/dev/null)) # store find files in an array --
    #array_name=($(find $sample_direc -type f -name "*$1*" 2>/dev/null)) # store find files in an array --

    if [ ${#array_name[@]} -gt 2 ] 
    then
	printf "$1 has more than 2 files - Warning\n"  >> $curr_dir/"logs_errors.txt"
    fi  # if there're trimmed or some other garbage.. 
     
    if [ ${#array_name[@]} -gt 0 ]  # if greater than 0 size 
    then
    
	for file in "${array_name[@]}" # iterate over array 
	do	
	    if [[ ${file: -9} == ".fastq.gz"  ]]  # if fastq.gz extension
	    then
	      
		if [[ "`basename $file`" =~ $regex_for ]] # if R1 or not 
		then
		   
		    if [[ "`basename $file`" == *"trimmed"*  ]] # if R1 and trimmed
		    then
			trim_forward=$file # store in trim_forward variable .. -
		    else
			forward_read=$file
		    fi

	        #else # if it has R2 -- this got updated.. because it was failing on isolate names.. 
		elif [[ "`basename $file`" =~ $regex_rev ]]
		then

		    if [[ "`basename $file`" == *"trimmed"*  ]] 
		    then
			trim_reverse=$file
		    else
			reverse_read=$file # store in reverse+non_trim variable
		    fi
		fi # check for forward and reverse reads

	    else
		if [[ ${file: -4} != ".txt"  ]] # if file doesn't end with .txt & doesn't have .fastq.gz extension --  
		then
		    printf "$file\n" >> $curr_dir/"logs_errors.txt"
		    printf "$1 doesn't have .fastq.gz files in its folder\n"  >> $curr_dir/"logs_errors.txt"

		fi # end of .txt file check if 
	    fi # if file has .fastq.gz extension 
	done # end of file stored in array 
    else
	printf "File not found for $i\n" >> $curr_dir/"logs_errors.txt"
    fi

    if [[ "$trim_forward" != "" ]] && [[ "$trim_reverse" != "" ]] # if there are trimmed reads available !!
    then

	forward_read=$trim_forward  # assign trim read file to normal forward reads file 
	reverse_read=$trim_reverse
    fi

    unset trim_forward trim_reverse # unset them to NULL

} # end of get_fastq_file function 
##

check_dir(){ # function to check dirctories 

    if [ "$sample_direc" == "" ] || [ "$out_dir" == "" ]
    then
	printf "\nSample/output directory incorrect. Aborting...\n" 
	usage;
    fi 

    out_dir=$(cd $out_dir;pwd)
    sample_direc=$(cd $sample_direc;pwd)
    # get full path .. that is /home/my_user_name/folder_depth1_/blah1/blah_n/file_R1_001.fastq.gz 
    
    if [ ! -d "$out_dir" ] ||  [ ! -d "$sample_direc" ]
    then	
	printf "\nSample/output directory incorrect. Aborting...\n"
        usage;
    fi

} # end of check_dir function

check_files(){ # function to check files 
    
    if [ "$adap_file" == "" ] || [ "$isolate_file" == "" ] # isolate_file
    then
	printf "\nadap/isolate Files are not provided correctly. Aborting... \n" 
	usage;
    fi

    adap_file=$(cd $(dirname $adap_file) ; pwd)/`basename $adap_file` # make full path .. 
    isolate_file=$(cd $(dirname $isolate_file) ; pwd)/`basename $isolate_file` # make ful path 

    if [ ! -f "$adap_file" ] ||  [ ! -f "$isolate_file" ]
    then

	printf "\nadap/isolate Files are not provided correctly. Aborting... \n"
	usage;
    fi

} # end of check file function

check_coverage(){ # start of check coverage function..
 
    if [ "$coverage" != "auto" ] # if it is not auto
    then
	if ! [[ $coverage =~ ^-?[0-9]+$ ]] #and if it's not a number .. Negate regex ..   
	then
	    coverage="auto" # then set it to auto    
	fi
    fi

} # end of check coverage .. 

check_info_node(){ # check if job_info.txt file exists in current directory .. 
#"copy_job_ids.txt"

    if [ -f $curr_dir/"copy_job_ids.txt" ] # this has job ids for all copying scaffolds and contig  fasta files.
    then
	printf "copy_job_ids.txt present in current directory\n"
	printf "Cannot over write it. Aborting... \n\n"
	exit;
    fi

    if [ -f $curr_dir/"assem_job_ids.txt" ] # where assembly and ST jobs are thrown
    then
	printf "assem_job_ids.txt present in current directory\n"
	printf "Cannot over write it. Aborting... \n\n"
	exit;
    fi 

    if [ -f $curr_dir/"cov_job_ids.txt" ] # python job ids.. 
    then 
	printf "cov_job_ids.txt present in current directory\n"
	printf "Cannot over write it. Aborting... \n\n" 
	exit;
    fi


} ## end of check_info_node file.. 

create_directs(){ # function to create directs 

    if [[ "$tasks" -eq 4 ]] || [[ "$tasks" -eq 7 ]] 
    then
	mkdir $out_dir/all_sample_scaffolds_fasta
	mkdir $out_dir/all_sample_contigs_fasta
    fi

} # create directory function ends
# ---------------

usage() {   #spit out the usage
cat <<UsageDisplay
#################################################

assembly_pipeline.sh [-t threads]  -s <count/sum for tasks> -i <isolate_file> -o <output_Directory> -d <isolate directory> -a <illumina_adapter_file> [ -c coverage_contigs]
Default threads 16
Default coverage is auto for SPAdes run. Default for scaffolds is 0 and above.

Options:
-o output directory for assembled genomes <mandatory>
-d directory path where isolates are present <mandatory>
-a illumina adapter file <mandatory>
-i file containing isolate name (without .fastq.gz) <mandatory>
-s tell what to do to the script.. 
   -s 4 will only assemble your reads
   -s 3 will only Sequence type your reads .. after trimming your data. 
   -s 2 will ONLY sequence type your reads using assembled genome .. assuming your reads have been assembled..
   -s 7 will assemble your reads and Seqeunce type them using SRST2 tool
   -s 6 will assemble your reads and BLAST sequence type them. 
   -s 9 will assemble your readsm BLAST sequence type and SRST2 sequence type them.. 
Advanced Options:
-t threads count 
-c coverge of contigs. This would be K-mer coverage. 
#################################################

UsageDisplay
exit;
} # end of usage function --
##

# -- load modules 
module load trimmomatic spades quast python2.7 biopython/1.63 

#
coverage="auto" # default 
curr_dir="" # get curr direct 
sample_direc="" # sample directory 
forward_read="" # there was a bug.. if all variables in one line and not sepearted by a semi colon.. 
reverse_read="" 
out_dir=""  # output directory -- 
adap_file="" # illumina adapter_file used for trimomatic
num_threads="" # for trimmomatic/SPAdes, QUAST
def_threads=16
tasks=""
## -- 


while getopts "s:c:d:i:a:t:o:h" args # iterate over arguments
do
    case $args in
	d) 
	    sample_direc=$OPTARG ;; # store sample direc
	i)
	    isolate_file=$OPTARG ;; # store isolate file
	a)
	    adap_file=$OPTARG ;; # adapter file 
	t)
	    num_threads=$OPTARG ;;# number of threads
	o)
	    out_dir=$OPTARG ;; # output directory
	c)
	    coverage=$OPTARG ;; # coverage 
	s) 
	    tasks=$OPTARG ;; # count tells what to do.. assembly, sequence type or both.
# if 4 then only assembly.. if 3 then only SRST MLST sequence typing.. 2 only BLAST sequence typing.. 
#if sum is 4 then only assembly 
# if.. sum is 7 do assembly + srst sequece typing..  if 6 then, BLAST+ ASSEMBLY.. if 9 then assembly+SRST2+BLAST
	h) 
	    # help
	    usage ;;
	*) 
	    # any other flag which is not an option
	    usage ;;

    esac # done with case loop
done # completed while loop

if [ $# -eq 0 ] # exit if no arguments!
then
    usage;
fi

if [[ $num_threads -eq 0 ]]; # if no threads provided
then   
    num_threads=$def_threads
fi 

# ----          --     ----                   --                      Check parameter   --  -----          --------------------------        -  #


## ------        ##      ----      ----     ---
if [ "$tasks" == "" ] 
then
    printf "Sorry. Mention number of tasks to perform with flag -s\n"
    printf "Aborting ... \n"
    usage;
fi

if (( $tasks > 9 )) || (( $tasks < 2 ))
then
    printf "Sorry invalid tasks count. Aborting ...\n"
    usage;
fi

### -- <
curr_dir=`pwd`
script_dir=`dirname $0`

## ----  

check_files; # check files
check_dir;  # check directories
#check_coverage; # check coverage ..
#check_info_node; # check if node_info.txt i present in current directoy.. exit if present 
#create_directs; # create directories to have organized data 

# -- ----           -----          ---            ----         Loop over isolate list provided  --- -- -- -- -- ---   --- -- -- -- -- -- -- --    #

total_isolates=0 #total isolates found in file provided 
isolates_found=0  # total isolates which have both forward and reverse reads  
 
# loop over isolate file and send files to check

jobs_launched=0
for i in `cat $isolate_file | sort`
do
    if [ "$i" != "" ]
    then

	total_isolates=`expr 1 + $total_isolates` # increment total isolates -- 

	get_fastq_files $i; # function to get forward and reverse read

	if [ "$forward_read" != "" ] && [ "$reverse_read" != "" ]
	then 

	    isolates_found=`expr 1 + $isolates_found` # increment isolates found 
#	    mkdir $out_dir/$i # make direc of isolate name in output direc. 


	    forward_read=$(cd $(dirname $forward_read); pwd)/`basename $forward_read` #/`basename "$forward_read"`
	    reverse_read=$(cd $(dirname $reverse_read); pwd)/`basename $reverse_read`
#            ln -s $forward_read $out_dir/$i/`basename "$forward_read"` # make symbolic link in the directory created for forward and reverse read --  
 #           ln -s $reverse_read $out_dir/$i/`basename "$reverse_read"`

	    index_read=$(echo $forward_read | grep -bo "_R1" | awk 'BEGIN {FS=":"}{print $1}'  )

	    if [ "$index_read" == "" ] # _R1 pattern isn't avail..  Exit function
	    then 
		printf "\nThe reads here do not match our pattern for $i. Exiting Sequence typing function. Team Fall back!\n "  
		exit;
	    fi

	    index_fastq=$(echo $forward_read | grep -bo ".fastq.gz" | awk 'BEGIN {FS=":"} {print $1}')
	    rev_suff=${forward_read:$index_read:$index_fastq-$index_read} # get reverse suffix                                                                                                                     
            printf "for $i we have forward suff as $rev_suff\n"

            index_read=$(echo $reverse_read | grep -bo "_R2" | awk 'BEGIN {FS=":"}{print $1}'  )

            if [ "$index_read" == "" ] # _R1 pattern isn't avail..  Exit function                                                                                                                         
            then
                printf "\nThe reads here do not match our pattern for $i. Exiting Sequence typing function. Team Fall back!\n "
                exit;
            fi
	    
	    index_fastq=$(echo $reverse_read | grep -bo ".fastq.gz" | awk 'BEGIN {FS=":"} {print $1}')
	    rev_suff=${reverse_read:$index_read:$index_fastq-$index_read} # get reverse suffix
	    printf "for $i we have reverse suff as $rev_suff \n"

	    forward_link=$out_dir/$i/`basename $forward_read` # save symbolik links 
	    reverse_link=$out_dir/$i/`basename $reverse_read`

            zcat $forward_read |  awk '{if(NR%4==2) print length($1)}' | head -1
	    
	   
	    jobs_launched=`expr 1 + $jobs_launched`

	    if [[ "$tasks" -eq 7 ]] || [[ "$tasks" -eq 4 ]] # throw jobs of coverage only if assembly to be done
	    then
	       
#		job_id=$(sbatch --dependency=afterok:$job_id $script_dir/copy_fasta_files.sh -a $out_dir/$i -i $i -o $out_dir | awk '{print $4}')
#		printf "$i submitted for copying contigs and scaffolds file at job $job_id\n" >> $curr_dir/"copy_job_ids.txt"
# submit another job to copy contigs and scaffold fasta file.. 
   jobs_launched=`expr 1 + $jobs_launched`
#		job_id=$(sbatch --dependency=afterok:$job_id  $script_dir/coverage_info.py -r $forward_link -s $out_dir/$i/"scaffolds.fasta" -o $out_dir/$i -c $coverage | awk '{print $4}' ) # scaffolds file for coverage calculation 
   jobs_launched=`expr 1 + $jobs_launched`
#python coverage_info.py -r $forward_link -s $out_dir/$i/"scaffolds.fasta" -o $out_dir/$i -c $coverage

 
	    fi # if assembly or assembly + sequence typing .. 

	    unset forward_link reverse_link job_id
	else
	    printf "$i doesn't have forward or reverse read\n" >> $curr_dir/"logs_errors.txt"

	fi # end of not nul if check for forward and reverse reads

	unset forward_read reverse_read # make forward and reverse reads back to null -- 
    fi # if $i is not null

done # for loop of cat file ends

printf "Total Isolates are $total_isolates\n" >> $curr_dir/"assem_job_ids.txt"
printf "Isolates with forward and reverse reads are $isolates_found\n"  >> $curr_dir/"assem_job_ids.txt"
printf "<--Done looping over isolates-->\n"  >> $curr_dir/"assem_job_ids.txt"

#printf "Please check "$curr_dir"/"copy_job_ids.txt" for copy submitted jobs and other information\n"
printf "Please check "$curr_dir"/"assem_job_ids.txt" for assembly submitted jobs and other information\n"
#printf "Please check "$curr_dir"/"cov_job_ids.txt" for coverage submitted jobs and other information\n"
printf "please check "$curr_dir"/"logs_errors.txt" for error logs (not necessarily to be present)\n"

printf "<--Thank you for using this pipeline. TADA! -->\n"
printf  "\nTotal jobs are $jobs_launched\n"