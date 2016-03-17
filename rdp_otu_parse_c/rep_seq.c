#include<stdio.h>
#include<stdlib.h>

#include "rep_seq.h"

void delete_rep_node(struct Rep_seq *temp){
  
}
void print_list(struct Rep_seq *temp){
  if(temp!=NULL){
    struct Sample_count *sc_temp;
    
    while(temp->next){
      printf("Rep seq we have is %s\n",temp->seq);
      sc_temp=temp->sample_count;
      printf("In rep seq. Sample name is %p \n",(void*)sc_temp);
      //printf("Sample name is %s\n",sc_temp->name);
	
      temp=temp->next;
    }

  }
  /*If valid node*/
}
/*Functoin ends ----------------------------*/
