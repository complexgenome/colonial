#include<stdlib.h>
#include<stdio.h>

#include "parse_files.h"

/*
Date 11 March 2016 
*/
void parse_otu_map_file(const char *otu_file){
  FILE *otu_handle=fopen(otu_file,"r");
  
  printf("We are here %s\n",otu_file);
  printf("We have %d \n",SIZE_BUFF);
  if(otu_handle){
    
  }
  else{
    printf("Issues with OTU Map file\n");
    printf("Cannot do anything with otu-map\n");
  }
  /*if for otu-handle ends*/
}
/*Function ends for map file reading*/

void parse_rdp_file(const char *rdp_file){
  
}

