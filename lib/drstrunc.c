/*

     drstrunc.c,v 2.8 1995/03/30 00:50:43 drach Exp
     drstrunc.c,v
 * Revision 2.8  1995/03/30  00:50:43  drach
 * Added disclaimer
 *
 * Revision 2.7  1994/11/23  19:17:31  drach
 * Commented out text after #endifs.
 *
 * Revision 2.6  1994/07/05  18:44:29  drach
 * NSL version doesn't call drstrunc.
 *
 * Revision 2.5  1993/12/11  01:36:37  drach
 * Truncate to a multiple of 512 bytes, for HP compatibility.
 *
 * Revision 2.4  1993/10/21  01:24:02  drach
 * Added file name check to remove trailing blanks.
 *
 * Revision 2.3  1993/10/20  17:18:20  drach
 * Clean up path alloc.
 *
 * Revision 2.2  1993/10/15  21:33:24  drach
 * Set pathname to end at first blank character passed.
 *
 * Revision 2.1  1993/10/15  19:49:35  drach
 * Added to repository.
 *

                     Data Retrieval and Storage System

**********************************************************************

			DISCLAIMER

   This software was prepared as an account of work sponsored by an
   agency of the United States Government. Neither the United
   States Government nor the University of California nor any of
   their employees, makes any warranty, express or implied, or
   assumes any liability or responsibility for the accuracy,
   completeness, or usefulness of any information, apparatus,
   product, or process disclosed, or represents that its use would
   not infringe privately owned rights. Reference herein to any
   specific commercial products, process, or service by trade name,
   trademark, manufacturer, or otherwise, does not necessarily
   constitute or imply its endorsement, recommendation, or favoring
   by the United States Government or the University of California.
   The views and opinions of authors expressed herein do not
   necessarily state or reflect those of the United States
   Government or the University of California, and shall not be
   used for advertising or product endorsement purposes.
   
**********************************************************************


ROUTINE
      drstrunc

SYNOPSIS (Fortran)
      integer function drstrunc( path, length )

DESCRIPTION
      Truncate the file with pathname path, to length bytes. Round
      truncation length to a multiple of 512 bytes (for HP compatibility).

AUTHOR
      Bob Drach

DATE
      6/18/93

NOTES
      The file should be closed before calling drstrunc.

*/

#include "drscdf.h"
#define DRS_BYTE_MULT 512	/* Note: should be a multiple of eight bytes */
				/* to handle Cray word lengths - set to 512 */
				/* bytes for compatibility with HP, which */
				/* cannot read partial records. */
#ifdef cray
                                             /* Note: not used with NSL version */

/**********************************************************************
      
      Unicos version

**********************************************************************/

#include <fortran.h>
#include <fcntl.h>
#include <string.h>
#include <stdio.h>

int DRSTRUNC(fpath, len)
	_fcd fpath;
	int *len;
{
	int fpathLen, i;
	int fd;
	off_t offset, size;
	char *path;

	fpathLen = _fcdlen(fpath);
	path = (char *) malloc(fpathLen+1);
	strncpy(path,_fcdtocp(fpath),fpathLen);

				/* Break pathname at first blank character */
	for(i=0;i<fpathLen;i++)
		if(path[i]==' '){
			path[i]='\0';
			break;
		}

	path[fpathLen]='\0';

	if ((fd = open(path, O_RDWR)) == -1) {
		fprintf(stderr,"Cannot open file %s to truncate.\n",path);
                perror("truncation failed");
		return 1;
	}

	offset = (*len==0 ? 0 : (((*len-1)/DRS_BYTE_MULT)+1)*DRS_BYTE_MULT);
	size = lseek(fd,offset,0);

	if(trunc(fd) == -1){
		fprintf(stderr,"Cannot truncate file %s to length %d.\n",path,offset);
                perror("truncation failed");
		return 1;
	}

	close(fd);
	free(path);
	return 0;
}

#else /* !cray */

/**********************************************************************
      
      Sun-like version

**********************************************************************/
#include <fcntl.h>
#include <sys/types.h>
#include <string.h>
#include <stdio.h>

#ifdef hpux
int drstrunc(fpath,len,fpathLen)
#else
int drstrunc_(fpath,len,fpathLen)
#endif
	char *fpath;
	int *len;
	int fpathLen;
{
	int fd, offset, i;
	char *path;

	path = (char *) malloc(fpathLen+1);
	strncpy(path,fpath,fpathLen);

				/* Break pathname at first blank character */
	for(i=0;i<fpathLen;i++)
		if(path[i]==' '){
			path[i]='\0';
			break;
		}
	path[fpathLen]='\0';

	if ((fd = open(path, O_RDWR)) == -1) {
		fprintf(stderr,"Cannot open file %s to truncate.\n",path);
                perror("truncation failed");
		return 1;
	}
				/* Truncate to next even multiple of DRS_BYTE_MULT bytes */
				/* for compatibility with Cray word length. */
	offset = (*len==0 ? 0 : (((*len-1)/DRS_BYTE_MULT)+1)*DRS_BYTE_MULT);
	if (ftruncate(fd,offset) == -1) {
		fprintf(stderr,"Cannot truncate file %s to length %d.\n",path,*len);
                perror("truncation failed");
		return 1;
	}

	close(fd);
	free(path);
	return 0;
}
#endif /* cray */



