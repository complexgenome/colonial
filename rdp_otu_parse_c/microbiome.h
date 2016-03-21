#ifndef MICROB_H
#define MICROB_H

struct Microbiome{
  
  char *domain;
  char *phylum;
  char *class;
  char *order;
  char *family;
  char *genus;
  char *species;
  
};

void print_microb(struct Microbiome *);
#endif
