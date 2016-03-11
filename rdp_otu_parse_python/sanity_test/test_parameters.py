__author__="Sanjeev Sariya"
__date__="Feb 08 2016"
import os,sys
import logging

def check_inputs(**_temp_args_dict):
    """
    This checks RDP file, and otu map

    """
    if os.path.isfile(_temp_args_dict['otu_map']):
        _otu_map_file=os.path.abspath(_temp_args_dict['otu_map'])
    else:
        logging.debug("Wrong otu map file")
        print "Check file %s" %(_temp_args_dict['log_file'])
        sys.exit(1)
        
    if os.path.isfile(_temp_args_dict['rdp_file']):
        _rdp_file=os.path.abspath(_temp_args_dict['rdp_file'])
    else:
        logging.debug("Wrong RDP file")
        print "Check file %s" %(_temp_args_dict['log_file'])
        sys.exit(1)
        
    return _otu_map_file,_rdp_file
    

