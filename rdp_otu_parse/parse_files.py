__author__ = "Sanjeev Sariya"
__date__= "08 Feb 2016"
__maintainer__= "Sanjeev Sariya"
__status__= "development"

from collections import OrderedDict,defaultdict
from microbiome import * 
from rep_seq import *
import logging,re
from pprint import pprint
import sys

def create_sample_list(_otu_array):
#{
    """
    Function returns an object which has rep seq name, and
    a dict which contains sample name, and its count
    """
    #sample_count=defaultdict(int)
    sample_count=OrderedDict()
    
    #rep_seq_object=Rep_seq(int(_otu_array[0])) #create object    #rep_seq_object.sample_count_dict=parse_sample(_otu_array[1:])

    for x in _otu_array[1:]: #_otu_array[0] - is rep seq

        _under_score=x.find("_")

        if _under_score!=-1: # _under_score=x.find("_")
            _sample=x[:_under_score] # sample can be or cannot be Number.. it is good to keep it as string
            
            if _sample in sample_count:
                sample_count[_sample]+=1
            else:
                sample_count[_sample]=1
        else:
            logging.debug("_ missing from %s" %(x))
    #} For loop ends

    if len(sample_count) ==0:
        logging.debug("There are no sample is rep seq %s" %(_otu_array[0]))
        sys.exit()

    rep_seq_object=Rep_seq(_otu_array[0],sample_count) #rep_seq_object.sample_count_dict=sample_count # set dictionary
    return rep_seq_object #return object

#} function ends -------------------------------------------------

def read_otu_map_file(_map_file):
#functoin begins
    """
    Read Rep Seq and sample Map file 
    Function creates a list of objects after parsing otu map file
 
    """
    #read MAP file
    #rep_sample_list=[] #hold objects
    rep_sample_list={} #hold objects
    
    with open(_map_file) as _map_handle:
        for line in _map_handle:
            otu_array=re.split('\s+',line.rstrip())
            rep_seq_obj=create_sample_list(otu_array)
            rep_sample_list[otu_array[0]]=rep_seq_obj
            #rep_sample_list.append(rep_seq_obj)
            
        #iteration ends of file

    if len(rep_sample_list) ==0:
        logging.debug("Empty list for OTU map and rep seq")
        
    logging.debug("Rep sequence, and sample list file has been parsed")
    return rep_sample_list
#} function ends -------------------------------------------------

def check_microbe(microb_list,microb_object):
    
#{ Functoin begins
    """
    This function checks if similar microboe confirguration is already present in the dict
    If present Then returns True, else False
    """
    
    present=False
    if len(microb_list) > 0:
        for key in microb_list:
            temp_object=microb_list[key]

            if temp_object.class_m==microb_object.class_m and temp_object.domain==microb_object.domain:
                if temp_object.phylum==microb_object.phylum and temp_object.order==microb_object.order:
                     if temp_object.family==microb_object.family and temp_object.genus==microb_object.genus:
                         if temp_object.species==microb_object.species:
                             logging.debug("microbiome exists like this " + str(temp_object.rep_seq) + str(microb_object.rep_seq))
                             (temp_object.rep_seq).append((microb_object.rep_seq)[0]) #add the firt element of the list
                             return True

    return present
#} function ends -------------------------------------------------

def read_rdp_file(temp_rdp_file,conf_thresh):
#{
    """
    Function to read RDP file, and do further process
    """
    diversity_microbe={}
    """
    Have microbe object in dictionary way
    1 , microb object
    2, object ....
    """
    
    counter=0
    """
    This counter is key for microbiome objects that are stored in dictionary
    """
    
    with open(temp_rdp_file) as handle_rdp:
        for line in handle_rdp:
            
            pass_threshold=True # Flag to keep a check if threshold has passed or fail
            line=(line.rstrip()).replace('"',"")
            line_array=filter(None,re.split('\t',line) ) #split it by tab, remove/filter the ones which are blank/tab...
            microb_obj=Microbiome() 
            """
            Microbe object has: rep_seq null list, domain, phylum, class_m, sub_class
            order, sub_order, family, sub_family, genus and species. Everything is set to NULL initially
            """
            (microb_obj.rep_seq).append(line_array[0]) # store rep seq - can be int, can be string.. let's keep it string by default every where
            
            """
            We are not keeping suborder, sub family and sub class
            """
            
            for i in range(len(line_array)):
                
                if line_array[i] == "domain":
                    if pass_threshold:
                        #if threshold is still True
                        
                        if float(line_array[i+1]) > conf_thresh:
                            microb_obj.domain=line_array[i-1]
                        else:
                            microb_obj.domain=line_array[i-1]+"<"+str(conf_thresh) # Fermicutes<0.80
                            pass_threshold=False
                            
                if line_array[i] == "phylum":
                    if pass_threshold:
                        if float(line_array[i+1])> conf_thresh:
                            microb_obj.phylum=line_array[i-1]
                        else:
                            microb_obj.phylum=line_array[i-1]+"<"+str(conf_thresh)  #Fermicutes<0.80              
                            pass_threshold=False
                                                       
                if line_array[i] == "class":
                    if pass_threshold:
                        #if threshold is still True 
                        if float(line_array[i+1]) >conf_thresh:
                            microb_obj.class_m=line_array[i-1] 
                        else:
                            microb_obj.class_m=line_array[i-1]+"<"+str(conf_thresh)#Fermicutes<0.80
                            pass_threshold=False

                if line_array[i] == "order":
                    if pass_threshold:
                        #if threshold is still True
                        if float(line_array[i+1])> conf_thresh:
                            microb_obj.order=line_array[i-1]
                        else:
                            microb_obj.order=line_array[i-1]+"<"+str(conf_thresh)#Fermicutes<0.80
                            pass_threshold=False
                            
                if line_array[i] == "family":
                    if pass_threshold:
                        #if threshold is still True 
                        if float(line_array[i+1])>conf_thresh:
                            microb_obj.family=line_array[i-1] 
                        else:
                            microb_obj.family=line_array[i-1]+"<"+str(conf_thresh) #Fermicutes<0.80
                            pass_threshold=False
                                                        
                if line_array[i] == "genus":
                    if pass_threshold:
                        if float(line_array[i+1])>conf_thresh:
                            microb_obj.genus=line_array[i-1] 
                        else:
                            microb_obj.genus=line_array[i-1]+"<"+str(conf_thresh) #Fermicutes<0.80
                            pass_threshold=False
                            
                if line_array[i] == "species":
                    if pass_threshold:
                        #if threshold is still True 
                        if float(line_array[i+1]) > conf_thresh:
                            microb_obj.species=line_array[i-1] 
                        else:
                            microb_obj.species=line_array[i-1]+"<"+str(conf_thresh) #Fermicutes<0.80
                            pass_threshold=False

            # -- for loop ends
            #pprint(vars(microb_obj))
            
            if(check_microbe(diversity_microbe,microb_obj)== False):
                """
                check_microbe is function whhich check if exact taxonomy is present already in the 
                dictionary
                """
                
                diversity_microbe[counter]=microb_obj

                """
                Will have key from 0
                """
                counter+=1
            #} if ends for check_microbe -- false/true
    #} with ends
    
    return diversity_microbe #return to the main python
    
#} function ends -------------------------------------------------

def get_sample(otu_map):
#{
    """
    Collect sample names from the rep_seq otu map
    a list of sample name is returned
    """
    sample_list=[]
    """
    otu_map is a dict with rep seq name as key.. 
    value is object with sample count, rep seq name
    """
    
    for key in otu_map:
        for sample in otu_map[key].sample_count_dict:
            if not sample in sample_list:
                sample_list.append(sample)
                
            # -- if ends    
        #iteratoin over msaple dict ends        
    #iteratoin over list of rep seqn ends

    logging.debug("Sample list has been created and sending. Length %d"%(len(sample_list)))
    return sample_list
#} function ends -------------------------------------------------

def print_microb_matrix(microb_matrix,sample_list,list_microb_objects,
                        run_name,conf_thresh):
#{
    """
    This function prints matrix created in tsv format
    File name begins with run name, and the confidence 
    threshold provided
    """
    
    import xlwt
    line_domain=line_phylum="\t"
    line_class=line_order="\t"
    line_family=line_genus="\t"
    line_species="\t"
    
    for m in list_microb_objects:
        """
        Create headers for tsv file.. 
        """
        line_domain+=list_microb_objects[m].domain+"\t"
        line_phylum+=list_microb_objects[m].phylum+"\t"
        line_class+=list_microb_objects[m].class_m+"\t"
        line_order+=list_microb_objects[m].order+"\t"
        line_family+=list_microb_objects[m].family+"\t"
        line_genus+=list_microb_objects[m].genus+"\t"
        line_species+=list_microb_objects[m].species+"\t"

    with open(run_name+"_"+str(conf_thresh)+'_otu.tsv', 'a') as out_file:

        out_file.write(line_domain+"\n"+line_phylum+"\n"+line_class+"\n"+line_order+"\n")
        out_file.write(line_family+"\n"+line_genus + "\n"+line_species+"\n") #print line_domain+"\n"+line_phylum+"\n"+line_class+"\n"+line_order
        #print line_family+"\n"+line_genus + "\n"+line_species

        for i in range(len(sample_list)):
            """
            Remeber each sample is individully a row in matrix
            """
            line=sample_list[i]+"\t"

            for j in range(len(list_microb_objects)):
                line+=str(microb_matrix[i][j])+"\t"
            out_file.write(line+"\n") 
    # rows count - sample.. variable here the microb diversity

#} function ends -------------------------------------------------
def create_microb_matrix(rep_sample_map,list_microb_objects):
#{
    import numpy
    """
    rep_sample_map: rep seq dict for sample and their counts
    microb_objects - list with microbiome objects
    """
    sample_list=get_sample(rep_sample_map)
    """
    samplelist contains all sample names/ids 
    Index of sample is used further to populate matrix
    """
    
    microb_matrix=numpy.zeros((len(sample_list),len(list_microb_objects) )) #create 2D matrix
    """
    Number of rows - total samples present
    Number of variable to be the microbiome types present
    """

    for key in list_microb_objects:
        col=key
        temp_rep_seq_list=list_microb_objects[key].rep_seq
        """
        There can be multiple rep seqs having same microbiome config
        """
        for x in temp_rep_seq_list:
            sample_count_list=rep_sample_map[x].sample_count_dict
            """
            Each rep seq has sample and sample's count stored in dict
            """
            
            for s in sample_count_list:
                try:
                    row=sample_list.index(s)
                    microb_matrix[row][col]+=sample_count_list[s]
                    """
                    Increase the value.. 
                    Rep 1, 2 seq have sample 43 -> 23 and 5 resp.. 
                    Both Rep 1, and 2 have same taxonomic assignment.. 
                    Total count for the taxonomy for sample 43 should be 28!!
                    """
                except Exception as e:
                    print "Execution has to be stopped. Printing Matrix"
                    logging.debug("Having issues for %s %d row %d col " %(s,row, col))
                    logging.debug(e)
                    
            #iterating over samples in rep seq ends 
        #iterating over list of Rep Seq ends
    # iterating over microbe objects ends
    
    logging.debug("Matrix has been created with number of line %d and number of column %d"%(len(sample_list),len(list_microb_objects)))
    return microb_matrix,sample_list #return to the main python file
#}  function ends -------------------------------------------------
