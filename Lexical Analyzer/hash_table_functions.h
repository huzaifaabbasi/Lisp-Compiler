#include "uthash.h"
typedef struct  {
    char id [10];                    /* key */
    char type[10];
    char func_name [20];
    UT_hash_handle hh;         /* makes this structure hashable */
}hash_structure;

void add_entry(char * user_id, char *type,char* fname,hash_structure **hash_table) {
    hash_structure *s;

    s = malloc(sizeof( hash_structure));
    strcpy(s->id,user_id);
    strcpy(s->type, type);
    strcpy(s->func_name, fname);
    HASH_ADD_STR( *hash_table, id, s );  /* id: name of key field */
}
hash_structure *find_entry(char * id,hash_structure *hash_table) {
    hash_structure *s;

    HASH_FIND_STR( hash_table, id, s );  /* s: output pointer */
    return s;
}