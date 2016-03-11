#ifndef MICROB_H
#define MICROB_H

typedef struct{
  
  char *domain;
  char *phylum;
  char *class;
  char *order;
  char *family;
  char *genus;
  char *species;
  
}Microbiome;

void print_microb();
#endif
