#ifndef REP_SEQ_STR
#define REP_SEQ_STR

#include "local_structure.h"

struct Rep_seq{
  char *seq;
  struct Sample_name *sample_name_head; /*link list for sample and 
			      *its count
			      */
  struct Rep_seq *next;

};

void add_rep_node(struct Rep_seq *, char **,unsigned int );
void print_list(struct Rep_seq *);
void delete_rep_node(struct Rep_seq *);
#endif

