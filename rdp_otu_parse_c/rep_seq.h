#ifndef REP_SEQ_STR
#define REP_SEQ_STR

#include "local_structure.h"

typedef struct{
  char *seq;
  Sample_count *sample_count; /*link list for sample and 
			      *its count
			      */
  struct Rep_seq *next;
  struct Rep_seq *previous;
} Rep_seq;

void add_node(Rep_seq *, char **,unsigned int );
#endif

