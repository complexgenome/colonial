#include<stdlib.h>
#include<stdio.h>

#include "parse_files.h"
#include "rep_seq.h"

/*
Date 11 March 2016 
*/
int parse_otu_map_file(const char *otu_file){

  char line[SIZE_BUFF]; /*store line*/  
  FILE *otu_handle=fopen(otu_file,"r");
  char *test=NULL;
  
  if(otu_handle){
    
    Rep_seq *rep_seq_head;
    /*printf("address is %p\n",rep_seq_head);*/
    rep_seq_head=malloc(sizeof(struct Rep_seq *)); 
    /*printf("address is %p\n",rep_seq_head);*/
    
    if(rep_seq_head ==NULL){
      printf("Cannot assign memory to rep seq head\n");
      return 1;
    }
    while(fgets(line, sizeof(line), otu_handle)){
      trim_character('\n',line);
      
      printf("%s\n",line);
      /*printf("Rep seq's value: %s %p\n",rep_seq_head->seq,rep_seq_head->next);*/
      /*printf("tab are %u\n",get_tab_count(line));*/
      
      array_of_str(line,get_tab_count(line)+1);
    }
    /*looping file ends*/
    fclose(otu_handle);/*close file*/
  }
  /*otu handle true*/
  
  else{
    printf("Issues with OTU Map file\n");
    printf("Cannot do anything with otu-map. Bye!!\n");
  }
  /*if for otu-handle ends*/

  return 0;
}
/*Function ends for map file reading------------*/

void parse_rdp_file(const char *rdp_file){
  
}
/*Function ends to read RDP file ---------------*/
void array_of_str(char *line, unsigned int count){
  
  unsigned int i=0;
  /* char *array[count];*/
  char *p;
  char **h=malloc(count*sizeof(char *));
  
  p=strtok(line,"\t");
  /*array[i]=strtok(line,"\t");*/

  while(p!=NULL){
    /*  while(array[i] !=NULL){*/
    h[i]=malloc(sizeof(p)*sizeof(char));
    h[i++]=p;
    /*h[i]=p;*/
    /*i++;*/
      
    /*array[i]=strtok(NULL,"\t");*/
    p=strtok(NULL,"\t");
  }
  
  while(i--!=1){

    printf("value is %s\n",h[i-1]);
    
  }
  printf("##--##\n");

}
/**/
unsigned int get_tab_count(char *line){
  
  unsigned int count=0,i=0;
  
  while(*(line+i)!='\0'){
    if(*(line+i)=='\t'){
      count++;
    }/*if tab*/
    i++;
  }
  /*loop over string*/
  return count;
}
/*Function ends for tab count------------------*/
void trim_character(char chr,char *chr_array){
  /*
   * Replace any character from char array with '\0'
   * We are using this func to
   * replace new line character mostly
   */
  unsigned int i=0;
  
  while(*(chr_array+i)!=chr) i++;
  *(chr_array+i)='\0';
}
/*Function ends---------------------------*/
