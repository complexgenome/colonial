#ifndef LOCAL_STRUCT_H
#define LOCAL_STRUCT_H

typedef struct{
  char *val;
  struct Dynamic_list *next;
  struct Dynamic_list *previous;
} Dynamic_list;
/*linked list*/

struct Sample_count{

  char *name;/*sample name*/
  unsigned int count;/*its count*/
  struct Sample_count *next;

};
/*samle and its count*/

int size_dynamic_list();
#endif
