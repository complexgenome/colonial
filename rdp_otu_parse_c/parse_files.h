
#ifndef PARSE_FILE
#define PARSE_FILE

#define _GNU_SOURCE
#include<string.h>

#define SIZE_BUFF 8000

void parse_rdp_file(const char *); /*parse rdp classictn file*/
int parse_otu_map_file(const char *); /*parse rep-otu map file*/
void trim_character(char, char *);/*replace given character with '\0'*/
unsigned int get_tab_count(char *); /*get tab count*/

char **array_of_str(char *, unsigned int);/*split and store in array*/
void free_array(char ***, unsigned int); /*Free two dim array*/
void pos_underscore(char *);
#endif
