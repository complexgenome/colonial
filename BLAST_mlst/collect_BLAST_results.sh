#!/usr/bin/env bash

# __date__ 29 April 2015
# __author__ Sanjeev Sariya
# __location__ Price Lab 4th Fl, New Hampshire, Cube# 420F

# This will take in isolate file. Path to all BLAST MLST output/folders.
# Output will be a new file with MLST results concatenated into one single file.
# this has been hard coded as output from MLST BLAST had suffix __scaffolds_mlst_calls.txt  file names.

check_files(){ 

if [ "$isolate_file" == "" ]
then
    printf "\nIsolate file not provided. Exiting...\n"
    usage;
fi
if [ ! -f "$isolate_file" ]
then
    printf "Incorrect isolate file. Exiting...\n"
    usage;
fi
}
# function ends 

check_dir(){ #check dir function starts here

    if [ "$mlst_dir" == ""  ]
    then
        printf "\nMLST directory is incorrect. Aborting...\n"
        usage;
    fi

    mlst_dir=$(cd $mlst_dir; pwd)

    # get full path .. that is /home/my_user_name/folder_depth1_/blah1/blah_n/file_R1_001.fastq.gz

    if [ ! -d "$mlst_dir" ] 
    then
        printf "\nmlst directory is incorrect. Aborting...\n"
        usage;
    fi
} # end of check dir function
#

usage() {   #spit out the usage
cat <<UsageDisplay
#################################################

bash collect_BLAST_results.sh -d <MLST output dir> -i <isolate file>

OPTIONS:

-d directory where all BLAST MLST folders are present. 

-i isolate file

#################################################

UsageDisplay
exit;
} # end of usage function --

if [ $# -eq 0 ] # exit if no arguments!
then
    usage;
fi
#


mlst_dir=""
isolate_file=""

while getopts "i:d:h" args # iterate over arguments
do
    case $args in
       
        i)
            isolate_file=$OPTARG;; 
        d) 
            mlst_dir=$OPTARG ;;
            # path to mlst outputs
        h) 
            # help
            usage ;;
        *) 
            # any other flag which is not an option
            usage ;;

    esac # done with case loop
done # completed while loop

## ----  

check_dir;  # check directories
check_files;

for i in `cat $isolate_file`
do
    if [ "$i" != "" ]
    then

	temp_mlst_dir=$mlst_dir/$i
	mlst_file=$i"__scaffolds_mlst_calls.txt"
	# hard coded #__scaffolds_mlst_calls.txt 
	
	sed -n '2p ' $temp_mlst_dir/$mlst_file | sed 's/__scaffolds//g' >> full_report_blast_mlst.txt

	unset temp_mlst_dir mlst_file
    fi # end if not null
done #end of for loop, iterating on isolate file

printf "Please check `pwd` for full_report_blast_mlst.txt\n"
printf "You're done using this script. Now use check_blast python script to check your results\n"
printf "\n<-- TADA -->\n"