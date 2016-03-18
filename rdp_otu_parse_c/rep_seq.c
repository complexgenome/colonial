#include<stdio.h>
#include<stdlib.h>

#include "rep_seq.h"

//void delete_rep_node(struct Rep_seq *temp){}


void print_list(struct Rep_seq *temp){
  if(temp!=NULL){
    struct Sample_name *temp_sc;
    
    while(temp->next!=NULL){
      
      temp_sc=temp->sample_name_head;
      printf("Rep seq we have is %s\t",temp->seq);

      while(temp_sc->next!=NULL){
	printf("Sample is %s %u\t",temp_sc->name,temp_sc->count);
	temp_sc=temp_sc->next;
      }
      /*loop over samples ----*/
      printf("Final/First print is %s %u\n",temp_sc->name,temp_sc->count);
      temp=temp->next;
    }
    /*loop over rep sequences */
    printf("*--Leaving print--*\n");
  }
  /*If valid node*/
}
/*Functoin ends ----------------------------*/
