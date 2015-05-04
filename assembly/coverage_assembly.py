#!/usr/bin/env python

__author__ = "Sanjeev Sariya"
__date__= "30 April 2015"
__maintainer__= "Sanjeev Sariya"
__status__= "development"

long_description= """Get coverage from scaffolds.fasta file. Takes scaffold file provided from assmbly_pipeline.sh. Calculates coverage based on K-mer. Coverage calculated is per contig."""

#SBATCH --time=1:0:0
#SBATCH -o "coverage_%j.out"
#SBATCH -e "coverage_%j.stderr"
#SBATCH -J coverage
#SBATCH -p short
#SBATCH --nodes=1

import sys, os, re, argparse,glob
import subprocess as sp 
from Bio import SeqIO
#
if sys.version_info < (2,7):
    print "Python 2.7+ are needed for script"
    exit(1)
##
def get_fasta_seq(file_temp): #{{{ function to get fasta seq and node IDs --   get_fasta_seq starts --
    seq_rec=SeqIO.parse(open(file_temp,"rU"),"fasta")
    return seq_rec # return dict 

#}}} get_fasta_seq ends -- 

def get_readLength(file_name):   # function to send read length 
#{{{ get_readLength starts here 

    command= "zcat "+ file_name + " | awk '{if(NR%4==2) print length($1)}' " + " | head -1 " # store command 
    store_readLength = sp.Popen(command,  stdout=sp.PIPE, stderr=sp.PIPE, shell=True) # security bug if shell = true

    read_length=store_readLength.communicate()[0] # get stdout..  having issues with fatal broken pipe error!! 
    read_length=int(read_length.strip() ) # strip off \n character  and convert to integer  .. 
    return read_length 
# }}} get_readLength ends here 
##   

def get_kmer(read_file):
#{{{ function starts here
# this will iterate over read folder. Find folder with names K, and then truncate after K. Find max of those values 
# and return max value.

    kmer_values=[]
    read_dir=os.path.dirname(read_file)
    folder_list=glob.glob(os.path.join(read_dir,'K*'))

    for k in folder_list:
        kmer_values.append(int(os.path.basename(k)[1:]))
        # K21, K33, K55 -> get only value after K, convert them into intger and add that to array

    print "Max value is ",max(kmer_values)
    return max(kmer_values)

##}}} function ends here  

def get_coverage(**temp_dict): # takes dictionary as argument 
#{{{ function starts --
 
    read_file=temp_dict['read'] # store read file -- 
    scaffold_file=temp_dict['scaff'] # store scaffold file ... 
    out_dir=temp_dict['outdir'] # store out_dir 
    cov_cut=temp_dict['cov'] # this will be string ..   
    cut_off_file="" # file storing contigs with threashold and above.. 
    file_name_cov=os.path.join(out_dir,'info_cov_node.txt') # file showin coverage of each contig 
    
    read_length=get_readLength(read_file) # get read length .. function ..     
    seq_dict=get_fasta_seq(scaffold_file) # function sent node id's dict . --
 
    print "Output is in ", out_dir

    k_mer=get_kmer(read_file) # get k_mer based on read_length .. 
    
    print "We're using k_mer value as ",k_mer

    if cov_cut!="auto": # if SPAdes not run on auto cut off coverage .. 
        cut_off_file=os.path.join(out_dir,'cut_off_scaffolds.fasta') 
        
    for element in seq_dict:
# iterate over node ids in scaffolds file provided . 

        if re.match( r'NODE_[0-9]+_length_[0-9]+_cov_+[0-9]+((\.?[0-9]+)?)_ID_.*',element.id ): # if NODE starts and have the pattern .. 

            cov_value=re.match( r'NODE_[0-9]+_length_[0-9]+_cov_+([0-9]+)(\.?[0-9]+)?_ID_.*',element.id ) # capture int value of cov.. 
            cov_value= int (cov_value.group(1)) # capture cov value..  and convert to integer 

            with open (file_name_cov,'a') as f:                # write coverage value of each node of scaffolds file.
                if read_length*cov_value/(read_length-k_mer+1) < 0:
                    print "Sorry. There's an issue with read length and K-mer value",read_length,k_mer
                    sys.exit()

                f.write( "%s\t%s\n" % (element.id ,str (read_length*cov_value/(read_length-k_mer+1) ) )  ) # running based on K-mer from k_mer function

            if cov_cut!="auto": # if there's value of cut_off provided by user, in original bash run .. 

                # if SPAdes not run on auto cut off coverage .. 
                if (read_length*cov_value/(read_length-k_mer+1) ) >=int(cov_cut):

                    with open (cut_off_file,'a') as fh:
                        fh.write("%s%s\n" %(">",element.id)) # print node name  .  .  
                        fh.write("%s\n" % (element.seq))  # print sequence to output file 

#}}} function get_coverage ends  --
#
if __name__=="__main__": 
#{{{ main starts
    
    parser=argparse.ArgumentParser("description")
    parser.add_argument ('-r', '--read', help='read file location/path',required=True) # store forward read 
    parser.add_argument ('-s','--scaff',help='location/path of scaffolds file',required=True) # store scaffolds file
    parser.add_argument('-o','--outdir',help='directory for coverage output', required=True) # out dir path
    parser.add_argument('-c','--cov',help='threshold for coverage output', required=False) # coverage 
    args_dict = vars(parser.parse_args()) # make them dict.. 
    
    get_coverage(**args_dict) # send to function to get coverage .. 
    print "Check outdir of assembly isolate for info_cov_node.txt file"

    if args_dict['cov'] != "auto":
        print "New scaffolds file is generated as per cut off provided"
        print "Check outdir of assembly isolate for cut_off_scaffolds.fasta "
    print "<--Done calculating coverage!-->"

#}}} main ends
