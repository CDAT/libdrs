/*

Name:
----

hashSearch, hashInit

Synopsis:
--------

#include "hashSearch.h"

ENTRY *hashSearch(ENTRY entry, ACTION action)

void hashInit()

Description:
-----------

hashSearch is a hash table search function. When action is FIND, it
returns a pointer to the entry in the table with the same key, or
HASH_ERROR if the lookup fails.  If the action is INSERT and the
lookup fails, the entry is added to the table and a pointer to the
entry is returned. If a duplicate key is found, or the table
overflows, HASH_ERROR is returned. If the action is DELETE, the entry
is deleted (if found) and a pointer to the entry returned, else
HASH_ERROR is returned.

An entry is defined (in hashSearch.h) as

typedef struct entry {char *key, *data; } ENTRY;

The key is a pointer character string ID for the object; data is the
object to be associated with the key.

The function is an implementation of Knuth's Algorithm R (Sec 6.4, open addressing
with linear probing and deletions, using division hashing).

hashInit zeroes out the hash table entries. It should be called before
the first call to hashSearch, or when a new table is started.

Author: Bob Drach
------

Date: 6/5/92
----

Notes:
-----

Glossary:
--------

Revision History:
----------------

 hashSearch.c,v
 * Revision 1.5  1994/01/03  20:42:04  drach
 * Use K&R style if _KRC_ is defined.
 *
 * Revision 1.4  1992/10/14  23:47:13  drach
 * Added deletion capability to hash table, to support same-name
 * variables.
 *
 * Revision 1.3  1992/06/26  21:29:37  drach
 * Changed to linear probing (preparing to implement deletions)
 *
 * Revision 1.2  1992/06/24  17:23:47  drach
 * Added RCS identifier
 *
 * Revision 1.1  1992/06/24  17:18:54  drach
 * Initial revision
 *

*/

#include <stdio.h>
#include "hashSearch.h"
#define DECREMENTMOD(X,M) (((X)+(M)-1)%(M))

static ENTRY hashTable[HASH_TABLE_LENGTH];
static char rcsid[]="hashSearch.c,v 1.5 1994/01/03 20:42:04 drach Exp";

#ifndef _KRC_
ENTRY *hashSearch(ENTRY entry, ACTION action)
#else
ENTRY *hashSearch(entry, action)
ENTRY entry;
ACTION action;
#endif
{
	int hashIndex, nSearch, i, j, r;
	unsigned long keyInteger;
	ENTRY *hashEntry;

	if( !entry.key ){
		fprintf( stderr, "Null key in hash function.\n");
		return HASH_ERROR;
	}
	if( action != INSERT && action != FIND && action != DELETE){
		fprintf( stderr, "Invalid hash action: %d, key = %s.\n", action, entry.key);
		return HASH_ERROR;
	}
				/* Compute the initial hash index */

	hashIndex = keyToInt( entry.key ) % HASH_TABLE_LENGTH;

				/* Keep searching until no more collisions or overflow. */
				/* Leave one entry empty to ensure that deletions succeed. */

	nSearch = 0;
	while ( nSearch++ < HASH_TABLE_LENGTH - 1){
		hashEntry = hashTable+hashIndex;
				/* The table entry is empty */
		if( !hashEntry->key )
			switch (action){
			  case INSERT:
				/* Insert the entry */
				hashEntry->key = entry.key;
				hashEntry->data = entry.data;
				return hashEntry;
			  case FIND:
			  case DELETE:
				return HASH_ERROR;
			}
				/* The table entry key matches the input key */
		else if ( !strcmp(hashEntry->key,entry.key ))
			switch (action){
			  case INSERT:
				return HASH_ERROR;
			  case FIND:
				return hashEntry;
			  case DELETE:
				/* Delete the entry. Note that there is */
				/* always one empty table entry, so the */
				/* while loop must eventually complete. */
				i = hashIndex;
				while (hashTable[i].key){
					hashTable[i].key = (char *)0;
					j = i;
					for( i = DECREMENTMOD(i,HASH_TABLE_LENGTH);
					    hashTable[i].key;
					    i = DECREMENTMOD(i,HASH_TABLE_LENGTH)){
						r = keyToInt(hashTable[i].key)%HASH_TABLE_LENGTH;
				/* if NOT(i<=r<j) cyclically */
						if( !(( i<=r && r<j ) ||
						      ( i>j  && ( i<=r || r<j ))))
							break;
					}
					if( hashTable[i].key ){
						hashTable[j].key = hashTable[i].key;
						hashTable[j].data = hashTable[i].data;
					}
				}
				return hashEntry;
			}
		hashIndex = DECREMENTMOD(hashIndex,HASH_TABLE_LENGTH);
	}
				/* Table overflow */

	fprintf(stderr,"Hash table overflow.\n");
	return HASH_ERROR;
}

				/* Initialize the hash table */
#ifndef _KRC_
void hashInit( void ) 
#else
void hashInit()
#endif
{
	int i;

	for( i=0; i<HASH_TABLE_LENGTH; i++)
		hashTable[i].key = (char *)0;
}
	
/* return an unsigned long produced by XORing consecutive long-size chunks of key */
  
#ifndef _KRC_
unsigned long keyToInt( char *key )
#else
unsigned long keyToInt( key )
char *key;
#endif
{
	unsigned long temp, keyInteger;
	char *tempPtr, *keyPtr;
	int i;

	keyInteger = 0;
	keyPtr = key;

	while( *keyPtr ){
		for( i=0, tempPtr = (char *)&temp;
		    i<sizeof(long);
		    i++, tempPtr++){
			*tempPtr = *keyPtr;
			if ( *keyPtr ) keyPtr++;
		}
		keyInteger ^= temp;
	}

	return keyInteger;
}
