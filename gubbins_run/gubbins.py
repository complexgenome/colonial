#!/usr/bin/env python

# Date March 02 2016
# Sanjeev Sariya
# Price Lab 420 F New Hampshire
#

# Input directory is where all ST folders are present
# Each ST folder is to have bestsnp.fasta
# This script then calls run_gubbins.sh to run gubbins
# python ~/scripts/gubbins_run/gubbins.py -i test_trees_input/ -o test_trees_output/

import os, argparse,sys

def check_input(**temp_input):
    """
    Check inputs, if present make them absolute 
    if not then exit 
    """

    if os.path.exists(temp_input['inp_dir']):
        temp_inp_dir=os.path.abspath(temp_input['inp_dir'])
    else:
        print "Incorrect out dir"
        sys.exit()
        
    if os.path.exists(temp_input['out_dir']):
        temp_out_dir=os.path.abspath(temp_input['out_dir'])
    else:
        print "Incorrect input direc"
        sys.exit()
    
    return temp_inp_dir,temp_out_dir
#--------------------------
def check_snp_fasta(inp_dir):
    
    """
    Loop over input directory.. Find all directories.
    See if they have all bestsnp.fasta present in them
    iF not exit the script
    """

    st_dir_list=os.listdir(inp_dir)
    st_list=[] # hold all st dir which have bestsnp.fasta
    # will return this list 

    if len(st_dir_list) == 0:
        print "Something is wrong with input directory!!"
        sys.exit()
    # if no folders in input direc
    
    for d_list in st_dir_list:
        st=d_list #st added in list
        
        d_list=input_dir+"/"+d_list
        # make it full path
        
        if os.path.isdir(d_list):
            #if a directory
            
            fasta_file=d_list+"/"+"bestsnp.fasta"
            if not os.path.isfile(fasta_file):
                #if bestsnp fasta not present
                print "best snp fasta not present in ",d_list
                sys.exit()
            else:
                st_list.append(st)
            # if for FASTA snp ends
        #if for ST directory ends

    # For ends to loop over dir listings

    return st_list
#---------------------------------------------
def run_bash_script(st_list,inp_dir,out_dir):
    """
    This function:
    - Loops over ST list
    - prepare string for bash script with all input flags, and parameters
    - prepare job string with wall, queue and other essentials
    - send the job string
    - get job id, and print it in log
    
    """
    import subprocess
    
    from time import strftime
    import logging
    import re
    job_string=""
    current_time=strftime("%Y%m%d%H%M%S")
    log_file_name="run_"+current_time+".log"
    logging.basicConfig(filename=log_file_name,format='%(asctime)s %(message)s',datefmt='%m/%d/%Y %I:%M:%S %p',level=logging.DEBUG)

    queue="defq"
    job_name="gubbins_"
    walltime="14-00:00:0"
    out_name="main_gubbins_.%j.out"
    log_name="log_gubbins_.%j.stderr"
    
    for x in st_list:
        #iterate over ST list-folders
        
        # bash run_gubbins.sh  -i /lustre/groups/pricelab/sanjeev_files/io_files/ -o ./ -s ST1234
        #subprocess.call(["bash /home/sariyasanjeev/scripts/gubbins_run/run_gubbins.sh -o %s -i %s -s %s" %(out_dir,inp_dir,x)],shell=True,stderr=subprocess.PIPE)
        
        run_command="bash /home/sariyasanjeev/scripts/gubbins_run/run_gubbins.sh -o %s -i %s -s %s "\
        %(out_dir,inp_dir,x) #prepare bash command
        
        job_string="""#!/bin/sh
#SBATCH -p %s 
#SBATCH -J %s
#SBATCH --time %s
#SBATCH -o %s
#SBATCH -e %s

%s
        """ % (queue,job_name,walltime,out_name,log_name,run_command)
        #prepare job-string to send it to sbatch!
        
        logging.debug("bash command used is %s" %(run_command))
        logging.debug("sbatch command used is %s" %(job_string)) #store information which might be handy in future

        proc = subprocess.Popen(['sbatch'],stderr=subprocess.PIPE,stdout=subprocess.PIPE,stdin=subprocess.PIPE)
        std_out=proc.communicate(input=job_string)
        job_info=re.split('\s+',std_out[0])
        
        logging.debug("Job number is %s" %(job_info[3])) # print the job number and say bye-bye
        logging.debug("Done with ST %s"%(x))
        
    # For loop ends-------------------------------------------
    return log_file_name
#---------------------------------------------    
if __name__=="__main__":

    parser=argparse.ArgumentParser("description")
    parser.add_argument ('-i', '--inp_dir', help='location where all input ST folders are present',required=True) # store input dire
    parser.add_argument ('-o', '--out_dir', help='location where all output files will be written',required=True) # store out dire
    args_dict = vars(parser.parse_args()) # make them dict..
    
    input_dir,out_dir=check_input(**args_dict)

    st_list=check_snp_fasta(input_dir)
    log_file=run_bash_script(st_list,input_dir,out_dir)
    print "Please check log file name in PWD ",log_file
    print "Bye Bye!"

    
