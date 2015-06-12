#!/usr/bin/env bash

# __date__ 12 June 2015
# __author__ Sanjeev Sariya
# __location__ Price Lab 4th Fl, New Hampshire, Cube# 420F

#####################################################
#Take in the list of isoltes for which BLAST is need#
#####################################################
#primersearch --version -- EMBOSS:6.6.0.0

check_tools(){
#function_starts
 
    hash primersearch 2>/dev/null || { echo >&2 "Require primersearch in path but it's not installed.  Aborting.\n"; exit 1; }
    
#function_ends
}

check_inputs(){
#function_starts

    if [ "$sample_file" == "" ] || [ "$sample_dir" == "" ] || [ "$out_dir" == "" ] || [ "$primer_file" == "" ]
    then
        printf "\nIncorrect inputs. Aborting...\n"
        usage;
    fi

    sample_file=$(cd $(dirname $sample_file) ; pwd)/`basename $sample_file` # make full paths
    sample_dir=$(cd $(dirname $sample_dir) ; pwd)/`basename $sample_dir` # make full path
    out_dir=$(cd $(dirname $out_dir) ; pwd)/`basename $out_dir` 
    primer_file=$(cd $(dirname $primer_file) ; pwd)/`basename $primer_file` # make full paths     

    if [ ! -f "$sample_file" ] || [ ! -d "$sample_dir" ] || [ ! -d "$out_dir" ] || [ ! -f "$primer_file" ]
    then
        printf "\nIncorrect inputs. Aborting... \n"
        usage;
    fi
} #function_ends  

#
usage() {   #spit out the usage
cat <<UsageDisplay

###########
It assumes primer search is in your PATH
primer_blast.sh -i <input file for isolates> -d <directory_where isolates are present> -o <output_dir> -p <primer file>

#########

UsageDisplay
exit;

} # end of usage function 

if [ $# -eq 0 ] # exit if no arguments!   
then
    usage;
fi
##

out_dir=""
sample_file=""
sample_dir=""
primer_file=""
##
while getopts "p:o:s:d:h" args #iterate over arguments                             
do
    case $args in
	p) 
	    primer_file=$OPTARG;; #user is expected to send primer file
        s)
            sample_file=$OPTARG ;; # sample file for amplicons.. 
        d)                                                  
            sample_dir=$OPTARG ;; #directory
        o)
            out_dir=$OPTARG ;; #output_dir 
        h)
            usage ;;
        *)
            usage ;;

    esac # done with case loop                           
done # completed while loop 

check_tools()
check_inputs()

