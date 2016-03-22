#ifndef MICROB_H
#define MICROB_H

struct rep_seq_name{
  char *rep_seq;
  struct rep_seq_name *next;
};

/* rep_seq_name
 * multiple rep_seq can have 
 * same microbiome
 */
struct Microbiome{
  
  char *domain;
  char *phylum;
  char *class;
  char *order;
  char *family;
  char *genus;
  char *species;
  struct rep_seq_name *head_rep_seq;
  /* Hold rep_seq name
   *
   */
};

void print_microb(struct Microbiome *);
#endif
