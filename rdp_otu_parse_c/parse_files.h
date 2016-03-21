#ifndef PARSE_FILE
#define PARSE_FILE

#define _GNU_SOURCE
#include<string.h>

#define OTU_SIZE_BUFF 8000
#define RDP_SIZE_BUFF 4000

struct Microbiome *parse_rdp_file(const char *); /*parse rdp classictn file*/

struct Rep_seq *parse_otu_map_file(const char *); /*parse rep-otu map file*/


void trim_character(char, char *);/*replace given character with '\0'*/
unsigned int get_tab_count(char *); /*get tab count*/

char **array_of_str(char *, unsigned int);/*split and store in array*/
void free_array(char ***, unsigned int); /*Free two dim array*/
void rem_seq_iden(char *);/*
			      * Find max _ position
			      * Get rid of seq identifier
			      * used in OTU MAP parsed words
			      */
void rem_doub_quotes(char *);/*
			      * Remove double quotes if present in string
			      * Used in RDP parsed words
			      */
#endif
