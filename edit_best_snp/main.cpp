#include <iostream>
#include <fstream>
#include <stdlib.h> //#include <sstream>
#include<unistd.h> //necessary for optarg

/*
This program remove weird strings from fasta file 
generated using nasp
This program is called from the bash script present in this directory

*/
/*
Date Feb 29 2016
Sanjeev Sariya
Location: Price Lab 

g++ -g -Wall -Wextra -pedantic -std=c++0x   *.cpp -o edit_fasta

*/

bool FileExists(char* filename);
void print_usage();
//--------------------------------
int main(int argc, char *argv[]){
  
  if(argc!=3){
    print_usage();
  }

  bool present=0;
  char *file_fasta=NULL;
  char get_opt;
  
  while((get_opt=getopt(argc, argv,"f:h")) !=-1){

    switch(get_opt){
    case 'f':
      file_fasta=optarg;
      break;
    case 'h':
      print_usage();
      break;
    }
  }
  
  file_fasta=realpath(file_fasta,NULL);
  present=FileExists(file_fasta);  
  
  if(present){
    
    std::string chop_line="_bcode_lane::BWA-mem,GATK"; //this string has to be removed from seq headers
    std::ifstream infile(file_fasta); 
    std::string line;
    
    while (std::getline(infile, line))    
      {
	if(line.find('>')!=std::string::npos){
	  
	  if(line.find(chop_line) != std::string::npos){
	    
	    std::cout<<line.substr(0,line.length()-chop_line.length()) << '\n' ;
	  } //reference check ends
	  
	  else{
	    std::cout<< line << '\n'; //print refernce header
	  }
	} // ">" if ends
	
	else{
	  
	  std::cout<<line<< '\n';
	}
	
      }//while ends
  }
  else{
    //if not present
    std::cerr<< "Fasta File not present"<< '\n';
  }
  
  return 0;
}
//-----------------------------------
bool FileExists(char* filename){
  
  if(filename!=NULL){
    
    std::ifstream myFile(filename);
    return myFile.fail() == 0; //return 1 if true.. myFile.fail() is 0 if file exists
  
  }
  else{
    std::cerr << "Incorrect fasta file "<<'\n';
    return -1;
  }
    
}
//bool function ends
void print_usage(){

  std::cout<< "Usage: edit_fasta [-f fasta_file]" << '\n'
	   <<"-f fasta file from best_snp " <<'\n';
  
}
//- -------------------------------------
