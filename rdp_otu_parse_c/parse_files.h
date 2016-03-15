
#ifndef PARSE_FILE
#define PARSE_FILE

#define _GNU_SOURCE
#include<string.h>

#define SIZE_BUFF 8000

void parse_rdp_file(const char *); /*parse rdp classictn file*/
int parse_otu_map_file(const char *); /*parse rep-otu map file*/
void trim_character(char, char *);/*replace given character with '\0'*/
unsigned int get_tab_count(char *); /*get tab count*/

void array_of_str(char *, unsigned int);
#endif
