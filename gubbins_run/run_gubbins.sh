#!/usr/bin/env bash

module load biopython 
module load gubbins/1.4.2 2> /dev/null
module load python/3.4.2 2> /dev/null

usage() {   #spit out the usage
cat <<UsageDisplay
#################################################

run_gubbins.sh -o <out dir> -i <input dir> -s <seq type>

bash run_gubbins.sh  -i /lustre/groups/pricelab/sanjeev_files/io_files/ -o ./ -s ST1234

this script calls in run_gubbins at colonial_bin
This script is called from gubbins.py 
That means: all input, and outout parameters have been validated

#################################################

UsageDisplay
exit;

}
check_input(){

    if [ "$in_dir" == "" ] || [ "$out_dir" == "" ] 
    then
	printf "Directories not provided "
	usage;
    fi

    if [ ! -d "$in_dir" ] || [ ! -d "$out_dir"  ]
    then
	printf "Incorrect directories\n"
	usage;
    fi
    
    out_dir=$(cd $out_dir;pwd) # make them full path
    in_dir=$(cd $in_dir;pwd)

    if [ "$seq_type" == "" ]
    then
	printf "Seq type missing\n"
	usage;
	
    fi
}
# -------------------------------------------------
if [ $# -eq 0 ] # exit if no arguments!
then
    usage;
fi

in_dir="" #input dir
out_dir="" #output dir
seq_type=""

while getopts "s:i:o:h" args # iterate over arguments
do
    case $args in
	i)
	    in_dir=$OPTARG;;
	o)
	    out_dir=$OPTARG;;
	s)
	    seq_type=$OPTARG;;# ST131 or so
	# this will be used while running gubbins
	      
	h)
	    usage;;
	*)
	    # any other flag which is not an option
	    usage ;;

    esac # done with case loop
done # completed while loop

check_input;

mkdir $out_dir/$seq_type #create resp ST output dir . and run gubbins within it

snp_fasta_file=$in_dir/$seq_type/"bestsnp.fasta"

if [ ! -f "$snp_fasta_file" ]
then
    printf "SNP file not present in $seq_type\n"
    usage;
fi

pushd $out_dir/$seq_type > /dev/null

printf "we are doing great for $seq_type \n"
printf "File is $snp_fasta_file\n"
python /groups/pricelab/colonial_bin/gubbins_1.4.2_scripts/run_gubbins.py -u -t fasttree -p tree $snp_fasta_file &> /dev/null
#
popd > /dev/null

printf "<--Done with ST $seq_type-->\n"














