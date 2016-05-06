#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>/*must for optarg*/
#include<string.h>

#define BUFF_SIZE 6000
/*
Date 23 march 2016
Sanjeev Sariya
Remove reference from NASP/gubbins generated 
FASTA files

gcc -g -Wall -Wextra -pedantic *.c -std=gnu99 -o clean_seq_iden

*/

void print_help();
int get_position(char *);

int main(int argc, char *argv[]){
  int pos;
  char get_opt;/*loop over args*/
  char *fasta_file=NULL;
  FILE *fasta_handle;/*hold fasta file pointer*/
  char line[BUFF_SIZE]; /*store line*/
  unsigned int found=0; /*var to store if reference found*/
  
  if(argc ==1){
    print_help();
    return 0;
    
  }
  
  while((get_opt=getopt(argc, argv,"f:")) !=-1){
    switch(get_opt){
    case 'f':
      fasta_file=optarg;
      break;
    case '?':
      print_help();
      break;
    }
    /*switch ends*/
  }
  /*while ends*/

  fasta_handle=fopen(fasta_file,"r");
  
  if(fasta_handle== NULL){
    fprintf(stderr,"Incorrect FASTA file\n");
  }
  
  while(fgets(line,sizeof(line),fasta_handle)){
    
    if(line[0]=='>'){
      
      if(strcmp(line,">Reference\n")!=0){

	pos=get_position(line);/*get position of _bcode*/
	
	found=0;
	if(pos>0){
	  
	  for(int i=0;i<pos;i++){
	    printf("%c",line[i]);
	  }
	  printf("\n");
	  pos=-1;
	  /*print done until that index*/
	}
	
	else{
	  /*if some issues*/
	
	  fprintf(stderr,"Having issues with %s",line);
	  exit(-1);
	}

      }
      else{
	
	found=1;
      }
      /*Reference compare*/
      
    }
    else{
      if(found==0){
	printf("%s",line);
      }
    }
  }
  /*while loop ends*/
  
  fclose(fasta_handle);
  
  return 0;
}
void print_help(){
  const char* help="Run as:\n"\
 "./program -f fasta_file";

  printf("%s\n",help);
}
/*Function over---------------------*/
int get_position(char *line){
  
  /*char *sub_str=strstr(line,"_bcode");*/
  int pos;
  pos= strstr(line,"_bcode")-line;
 
  return (pos>0) ? pos : -1;
}
