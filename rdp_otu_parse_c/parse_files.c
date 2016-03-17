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
  unsigned int val=0;

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
      
      printf("Rep seq's value:%p %s %p\n",rep_seq_head,rep_seq_head->seq,rep_seq_head->next);
      
      val=get_tab_count(line); /*get number of words/tab*/
      split_array=array_of_str(line,val+1);
      add_node(rep_seq_head,split_array,val);
      
      free_array(&split_array,val);/*Free memory of split line*/
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
void add_node(Rep_seq *local,char **temp_array, unsigned int val){
  
  printf("We are here %p %d\n",local,val);
  for(unsigned int i=0;i<val;i++){
    printf("string is %s\n",temp_array[i]);
  }
}
/*---------------------------*/
