/* hashSearch.h,v 1.3 1994/01/03 20:42:31 drach Exp
 hashSearch.h,v
 * Revision 1.3  1994/01/03  20:42:31  drach
 * Added option to compile with K&R C, if _KRC_ is defined.
 *
 * Revision 1.2  1992/06/26  21:31:01  drach
 * Changed to linear probing.
 *
 * Revision 1.1  1992/06/24  17:24:03  drach
 * Initial revision
 *
*/

#ifndef _hashSearch_h
#define _hashSearch_h

#define HASH_ERROR (ENTRY *)0

/* The hash table length should be defined to be somewhat larger than the number of records to be inserted, such that:

256^p is NOT congruent to a small integer a, modulo
HASH_TABLE_LENGTH.

The best size depends on the expected number of records and the lookup speed required: if

load factor = (records in hash table) / (table length)

then

average search length = 1/(1 - load factor)
*/

#define HASH_TABLE_LENGTH 661

typedef struct entry { char *key; void *data; } ENTRY;
typedef enum { FIND, INSERT, DELETE } ACTION;

#ifndef _KRC_
ENTRY *hashSearch( ENTRY, ACTION );
void hashInit( void );
unsigned long keyToInt( char * );
#else
ENTRY *hashSearch( );
void hashInit(  );
unsigned long keyToInt( );
#endif

#endif /*!_search_h*/
