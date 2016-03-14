#ifndef LOCAL_STRUCT_H
#define LOCAL_STRUCT_H

typedef struct{
  char *val;
  struct Dynamic_list *next;
  struct Dynamic_list *previous;
} Dynamic_list;
/*linked list*/

typedef struct{

  char *name;/*sample name*/
  unsigned int count;/*its count*/
  struct Sample_count *next;
  struct Sample_count *previous;
} Sample_count;
/*samle and its count*/

int size_dynamic_list();
#endif
