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
  char **split_array=NULL;/*store split line values*/
  unsigned int tab_count=0;//tab count present in one line*/

  if(otu_handle){
    
    struct Rep_seq *rep_seq_head;
    rep_seq_head=malloc(sizeof(struct Rep_seq ));
    rep_seq_head->next=NULL;
    
    if(rep_seq_head ==NULL){
      printf("Cannot assign memory to rep seq head\n");
      return 1;
    }
    while(fgets(line, sizeof(line), otu_handle)){
      trim_character('\n',line);/*get rid of '\n' char */
      
      //      printf("Rep seq's value at beginning:%p %s %p\n",(void*)rep_seq_head,rep_seq_head->seq,(void*)rep_seq_head->next);
      //printf("Rep seq s_count %p %p\n",(void*)rep_seq_head->sample_count,(void*)rep_seq_head->sample_count);
      
      tab_count=get_tab_count(line); /*get number of words/tab*/
      split_array=array_of_str(line,tab_count+1);
      add_rep_node(rep_seq_head,split_array,tab_count+1);
      
      free_array(&split_array,tab_count);/*Free memory of split line*/
    }
    print_list(rep_seq_head);
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
void free_array(char ***array, unsigned int size){
  
  /* Free 2 D array of split strings
   */
  char **temp_add=*array;
  
  for(unsigned int i=0;i<size;i++){
    /*Foor loop intial declarations in: C99, C11, or gnu99
     */

    free(temp_add[i]);
  }
  
  free(temp_add);
  *array=NULL;
}
/*Function ends-------------------------------------*/
char **array_of_str(char *line, unsigned int count){
  
  unsigned int i=0;
  char *parsed_word;/*hold strtok output*/
  char **array_words=malloc(count*sizeof(char *)); /*2D array */
  
  parsed_word=strtok(line,"\t");

  while(parsed_word!=NULL && i < count ){

    pos_underscore(parsed_word);
    /*
     * keep only sample names. Get rid of seq identifier
     */
    array_words[i]=malloc(strlen(parsed_word)+1);//'\0' last place
    strcpy(array_words[i++],parsed_word); //copy chracters. we need them outside scope
    parsed_word=strtok(NULL,"\t");
  }
  //while ends
  
  return array_words;
}
/*Function ends ----------------------------*/
unsigned int get_tab_count(char *line){
  /*
   *return number of tabs present in line
   */
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
void add_rep_node(struct Rep_seq *local,char **temp_array, unsigned int words){

  int sample_found=-1;
  struct Rep_seq *loop_rep_seq=local;/*get head node*/
  struct Rep_seq *temp_rep_s=malloc(sizeof(struct Rep_seq));

  temp_rep_s->next=NULL;
  temp_rep_s->sample_count=NULL;/*MUST to initialize to NULL*/
  /*make pointers to point to NULL other wise they might point to Junk!*/
  /*variables to add new rep seq node */
  
  /*create sample list along with it.. Sample_count node..
   *
   *Rep_seq-node->Rep-sequence name
   *            -sample name
   *            -sample-count
   *
   */
  struct Sample_count *loop_sc;/*iterator for sample name list*/
  struct Sample_count *temp_sc;/* variable to store sample_count list address*/
  
  /**/
  if(temp_rep_s==NULL ){
    printf("Something went wrong in memory allocation\n");
  }

  
  while(loop_rep_seq->next!=NULL){
    loop_rep_seq=loop_rep_seq->next;
  }
  /*until you find last node*/
  
  loop_rep_seq->next=temp_rep_s; /*loop_rep_seq is the new repseq node added*/
  
  for(unsigned int i=0;i<words;i++){
    
    if(i==0){
      /*add representative seq first*/
      loop_rep_seq->seq=malloc(strlen(temp_array[i])+1);
      strcpy(loop_rep_seq->seq,temp_array[i]);

    }
    /*store rep sequence-----*/
    else{
      
      /*sample name in temp_array now*/
      /*loop_rep_seq is the new repseq node added*/
      if(loop_rep_seq->sample_count == NULL){
	
	/*If no sample name present in rep seq */
	temp_sc=malloc(sizeof(struct Sample_count));
	temp_sc->next=NULL;
	
	temp_sc->name=malloc(strlen(temp_array[i])+1);
	temp_sc->count=1;
	strcpy(temp_sc->name,temp_array[i]);
	
	loop_rep_seq->sample_count=temp_sc;
	
      }
      else{
	/*loop_rep_seq is the new repseq node added*/
	/*sample node is present */
	
	loop_sc=loop_rep_seq->sample_count;
	if(loop_sc->next == NULL && ( (strcmp(loop_sc->name,temp_array[i])==0))){
	  loop_sc->count++;
	}
	else{
	  /*more than 1 sample nodes prenset or, sample name didn't match
	   *Iterate using while
	   */
	  
	  while(loop_sc->next!=NULL){
	  
	    if(strcmp(loop_sc->name,temp_array[i]) == 0){
	      sample_found=0;
	      loop_sc->count++;
	      break;
	    }
	    /*if ends*/
	    loop_sc=loop_sc->next;
     
	  }
	  /*while loop ends---*/
	  
	  if(sample_found==-1){

	    temp_sc=malloc(sizeof(struct Sample_count));
	    temp_sc->next=NULL;
	    temp_sc->count=1;/*each sample is present atleast 1 if in array*/
	    
	    temp_sc->name=malloc(strlen(temp_array[i])+1);
	    strcpy(temp_sc->name,temp_array[i]);

	    loop_sc->next=temp_sc;/*append node*/
	  }
	  /*if not present in sample name's node list--*/
	}
	/*Didn't match initial node's sample name or mode nodes are present*/

      }
      /*Else ends first node's null sample count*/
    }
    /*else ends for temp_array i ==0*/

  }
  /*For loop ends of array stored*/
    
}
/*Function ends ---------------------------*/

void pos_underscore(char *temp_seq){
  /*
   *Find max position of _ (an underscore)
   *Put '\0' at that position
   *the end result is sample name
   */
  
  int max_ind=-1;/*get _ position*/
  int i=0;/*iterate*/

  while(*(temp_seq+i)!='\0'){
    
    if(*(temp_seq+i)=='_' && i>max_ind){
      max_ind=i;
    }
    i++;
  }

  *(temp_seq+max_ind)='\0';
  /*trim string to its sample name!*/
}
/*function ends ----------------------------*/
