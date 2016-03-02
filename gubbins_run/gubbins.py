#!/usr/bin/env python

# Date March 02 2016
# Sanjeev Sariya
# Price Lab 420 F New Hampshire
#

def submit_job():
    
    from time import strftime
    import logging
    import subprocess
    import re
    current_time=strftime("%Y%m%d%H%M%S")
    log_file_name="run_"+current_time+".log"
    
    logging.basicConfig(filename=log_file_name,format='%(asctime)s %(message)s',datefmt='%m/%d/%Y %I:%M:%S %p',level=logging.DEBUG)

    queue="defq"
    job_name="test"
    walltime="1:0"
    out_name="wow_helo_.%j.out"
    log_name="test_heloo_.%j.stderr"
    run_command="bash hello.sh"
    job_string="""#!/bin/sh
#SBATCH -p %s 
#SBATCH -J %s
#SBATCH --time %s
#SBATCH -o %s
#SBATCH -e %s


%s
""" % (queue,job_name,walltime,out_name,log_name,run_command)
    
    logging.debug("Command used is %s" %(job_string))

    proc = subprocess.Popen(['sbatch'],stderr=subprocess.PIPE,stdout=subprocess.PIPE,stdin=subprocess.PIPE)
    std_out=proc.communicate(input=job_string)
    job_info=re.split('\s+',std_out[0])
    logging.debug("Job number is %s" %(job_info[3]))

#}-------------------------------------------------------------------------------
def check_input():
    """
    Check inputs, if present make them absolute 
    if not then exit 
    """
    print ""
#--------------------------


if __name__=="__main__":
    print "sahii"
#    submit_job()
    
