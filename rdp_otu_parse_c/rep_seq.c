#include<stdio.h>
#include<stdlib.h>

#include "rep_seq.h"

void delete_rep_node(struct Rep_seq **head_temp){

  struct Rep_seq **temp_rs;
  struct Sample_name **head_temp_sc;
  struct Sample_name **sc_free_hold;

  while((*head_temp)->next){
    
    //printf("We have rep-seq as %s\n",(*head_temp)->seq);
    
    head_temp_sc=&((*head_temp)->sample_name_head);
    /* get first node of sample names
     * and iterate 
     */
    
    while((*head_temp_sc)->next){
      
      sc_free_hold=&((*head_temp_sc)); /*temp hold*/
      (*sc_free_hold)->count=9999; //poison

      free((*sc_free_hold)->name); //free sample_name
      free(*sc_free_hold); ///free sample name node
      
      *head_temp_sc=(*head_temp_sc)->next; //go to next
    }
    /*iterate over sample names*/

    //last/first sample_name node
    free((*head_temp_sc)->name); //free sample name node -last/first
    free(*head_temp_sc); //free first/last sample name node 
    (*head_temp_sc)=NULL;

    /* Done with sample name node-list
     *
     */
    
    temp_rs=&((*head_temp)); //store temp
    free((*temp_rs)->seq); //free rep seq memory last/first
    free(*temp_rs); //free rep-seq node
    *head_temp=(*head_temp)->next;
    
  }
  /*iterate over rep-seq names*/
  // last or first node
  
  free((*head_temp)->seq); //free rep-seq names
  free(*head_temp); //free node
  (*head_temp)=NULL; //set it to NULL
  
}
/*Free function ends ----------------------------*/

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
