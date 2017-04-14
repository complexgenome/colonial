#!/usr/bin/env python

__date__="March 13 2017"
__location__="SEH 7th floor west offices, DC 20037"
__author__="Sanjeev Sariya"

long_description="""

Take fasta file from gubbins output
Add 2012 to FUTI isolates

"""

from Bio import SeqIO
import os, argparse,sys,re


def add_year(temp_fasta,temp_dir):

    """
    Add 2012 to FUTI isolate and create new file 
    """

    file_name=temp_dir+'/'+"isolates_date_futi.fasta" #file for printing fasta seq and edited isolate names
    
    for record in SeqIO.parse(temp_fasta,"fasta"):
        
        if "_CN" in record.id or "_coli" in record.id or "FMC" in record.id :

            temp_record=record.id+"_2012"
            with open(file_name,'a') as write_handle:
                write_handle.write(">"+temp_record+"\n")
                write_handle.write(str(record.seq)+"\n")
                
            #--with ends
            
        else:
            
            with open(file_name,'a') as write_handle:
                write_handle.write(">"+record.id+"\n")
                write_handle.write(str(record.seq)+"\n")
            #--with ends
            
        ##
        ## -- If ends for coli and CN check
        ##
        
        
        #if ends
    #for record ends
    
    ######################
    # function ends
    #####################
if __name__=="__main__":

    parser=argparse.ArgumentParser("description")
    parser.add_argument ('-fa', '--fasta_file', help='location for fasta file',required=True) # store input fasta file
    parser.add_argument ('-o', '--out', help='output dir',required=True) # store output directory
    args_dict = vars(parser.parse_args()) # make them dict..
    add_year(os.path.abspath(args_dict['fasta_file']),os.path.abspath(args_dict['out']))
                        
