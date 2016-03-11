#ifndef LOCAL_STRUCT_H
#define LOCAL_STRUCT_H

typedef struct{
  char *val;
  struct Dynamic_list *next;
  struct Dynamic_list *previous;
} Dynamic_list;

int size_dynamic_list();
#endif
