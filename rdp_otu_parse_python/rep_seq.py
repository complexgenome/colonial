__author__="Sanjeev Sariya"
__date__="Feb 08 2016"
"""
Rep_seq class:
OTU 1 - can have rep seqeunces from different samples

1 123_23 123_35 23_1 23_45 23_90


"""
from collections import OrderedDict   
class Rep_seq:
    def __init__(self,rep_seq_name,sample_dict=OrderedDict()):
        self.rep_seq_name=rep_seq_name
        self.sample_count_dict=sample_dict
    
    
