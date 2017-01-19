
#include<stdio.h>
#include "hash_table_functions.h"
hash_structure *hash_table = NULL;

int main(){

  add_entry("cat","function","global",&hash_table);
  add_entry("dog","variable","cat",&hash_table);
  hash_structure* found = find_entry("dog",hash_table);
  if(found){
    printf("%s\n",found->type);
    printf("%s\n",found->func_name);
  }
  else{
    printf("Not found");
  }
  return 0;
}
