#include "uthash.h"
#include<stdio.h>

struct hash_structure *hash_table = NULL;
struct hash_structure {
    char id [10];                    /* key */
    char type[10];
    UT_hash_handle hh;         /* makes this structure hashable */
};

void add_entry(char * user_id, char *type) {
    struct hash_structure *s;

    s = malloc(sizeof(struct hash_structure));
    strcpy(s->id,user_id);
    strcpy(s->type, type);
    HASH_ADD_STR( hash_table, id, s );  /* id: name of key field */
}
struct hash_structure *find_user(char * id) {
    struct hash_structure *s;

    HASH_FIND_STR( hash_table, id, s );  /* s: output pointer */
    return s;
}

int main(){

  add_entry("cat","function");
  add_entry("dog","variable");
  struct hash_structure* found = find_user("dog");
  if(found){
    printf("%s\n",found->type);
  }
  else{
    printf("Not found");
  }
  return 0;
}
