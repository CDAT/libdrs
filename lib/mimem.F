ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c mimem.F,v 2.3 1995/07/28 22:55:06 drach Exp
c mimem.F,v
c Revision 2.3  1995/07/28  22:55:06  drach
c - Modified for IBM RS/6000 version
c
c Revision 2.2  1995/03/30  00:51:06  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:22  drach
c Merged Sun, Unicos, SGI, and HP versions.
c
c Revision 2.0  1992/03/07  00:08:14  drach
c Entered into RCS
c
c
c
c                     Data Retrieval and Storage System
c
c**********************************************************************
c
c			DISCLAIMER
c
c   This software was prepared as an account of work sponsored by an
c   agency of the United States Government. Neither the United
c   States Government nor the University of California nor any of
c   their employees, makes any warranty, express or implied, or
c   assumes any liability or responsibility for the accuracy,
c   completeness, or usefulness of any information, apparatus,
c   product, or process disclosed, or represents that its use would
c   not infringe privately owned rights. Reference herein to any
c   specific commercial products, process, or service by trade name,
c   trademark, manufacturer, or otherwise, does not necessarily
c   constitute or imply its endorsement, recommendation, or favoring
c   by the United States Government or the University of California.
c   The views and opinions of authors expressed herein do not
c   necessarily state or reflect those of the United States
c   Government or the University of California, and shall not be
c   used for advertising or product endorsement purposes.
c   
c**********************************************************************
c
c     Routine: 
c     -------
      integer function mialloc(len,ptr)
      pointer(ptr,buf)
c
c     Description:
c     -----------
c     Allocate len bytes of memory into block pointed to by ptr
c
c     Arguments:
c     ---------
c     len =:  length of block (in bytes) to be allocated
c     ptr  := pointer to memory block
c
c     
c     Function Returns:
c     ----------------
c       0: success
c     IDRS_NOMEMORY: could not allocate additional memory
c     
c     Author: Bob Drach
c     ------
c     Date: 10/26/89
c     ----
c     Notes:
c     -----
c     This routine is machine-dependent.
c     Use miallocw for word lengths.
c
c     Glossary:
c     --------
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
#include "drsdef.h"

#ifdef ibm
      external malloc !$pragma C( malloc )
#endif
      mialloc=IDRS_SUCCESS

#ifdef cray

c     *** UNICOS version ***

      if(len.le.0) then
         mialloc=IDRS_BADLEN
         go to 9000
      endif
      lenwords=(len-1)/IDRS_BYTES_PER_WORD + 1
      call hpalloc(ptr,lenwords,ierr,0)
      if(ierr.lt.0) then
         mialloc=IDRS_NOMEMORY
         go to 9000
      endif

#else !cray
c     *** SUN-like version ***

#ifdef ibm
      ptr=malloc(%val(len))
#else
#ifdef __linux_absoft
      ptr=malloc_(len)
#else
      ptr=malloc(len)
#endif
#endif
      if(ptr.eq.0) then
         mialloc=IDRS_NOMEMORY
         go to 9000
      endif
#endif cray

 9000 continue
      call drsrout('mialloc',mialloc)
      end
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Routine: 
c     -------
      integer function mifree(ptr)
      pointer(ptr,buf)
c
c     Description:
c     -----------
c     Free memory block pointed to by ptr
c
c     Arguments:
c     ---------
c     ptr  =:  pointer to memory block
c
c     
c     Function Returns:
c     ----------------
c       0: success
c     
c     Author: Bob Drach
c     ------
c     Date: 10/26/89
c     ----
c     Notes:
c     -----
c     This routine is machine-dependent
c
c     Glossary:
c     --------
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

#include "drsdef.h"

#ifdef ibm
      external free !$pragma C( free )
#endif
      mifree=IDRS_SUCCESS


#ifdef cray

c     *** UNICOS version ***

      call hpdeallc(ptr,ierr,1)
#else !cray
c     *** SUN-like version ***

#ifdef ibm
      call free(%val(ptr))
#else
#ifdef __linux_absoft
      call free_(ptr)
#else
      call free(ptr)
#endif
#endif

#endif cray

 9000 continue
      end
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Routine: 
c     -------
      integer function miextend(len,ptr)
      pointer(ptr,buf)
c
c     Description:
c     -----------
c     Extend the memory block pointed to by ptr to length len bytes
c
c     Arguments:
c     ---------
c     len  =:  new byte length
c     ptr  =:  pointer to memory block
c
c     
c     Function Returns:
c     ----------------
c       0: success
c     IDRS_NOMEMORY: cannot extend to specified length
c     Author: Bob Drach
c     ------
c     Date: 10/26/89
c     ----
c     Notes:
c     -----
c     The data in the old memory block may be lost.
c     This routine is machine-dependent.
c     Use miextenw for word lengths.
c
c     Glossary:
c     --------
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

#include "drsdef.h"

#ifdef ibm
      external malloc !$pragma C( malloc )
      external free !$pragma C( free )
#endif
      miextend=IDRS_SUCCESS

#ifdef cray

c     *** UNICOS version ***

      if(len.le.0) then
         miextend=IDRS_BADLEN
         go to 9000
      endif
      lenwords=(len-1)/IDRS_BYTES_PER_WORD + 1
      call hpclmove(ptr,lenwords,ierr,0)
      if(ierr.lt.0) then
         miextend=IDRS_NOMEMORY
         go to 9000
      endif

#else !cray
c     *** SUN-like version ***

#ifdef ibm
      call free(%val(ptr))
      ptr=malloc(%val(len))
#else
#ifdef __linux_absoft
      call free_(ptr)
      ptr=malloc_(len)
#else
      call free(ptr)
      ptr=malloc(len)
#endif
#endif
      if(ptr.eq.0) then
         miextend=IDRS_NOMEMORY
         go to 9000
      endif
#endif cray

 9000 continue
      call drsrout('miextend',miextend)
      end

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Routine: 
c     -------
      integer function miallocw(len,ptr)
      pointer(ptr,buf)
c
c     Description:
c     -----------
c     Allocate len WORDS of memory into block pointed to by ptr
c
c     Arguments:
c     ---------
c     len =:  length of block (in WORDS) to be allocated
c     ptr  := pointer to memory block
c
c     
c     Function Returns:
c     ----------------
c       0: success
c     IDRS_NOMEMORY: could not allocate additional memory
c     
c     Author: Bob Drach
c     ------
c     Date: 10/26/89
c     ----
c     Notes:
c     -----
c     This routine is machine-dependent
c
c     Glossary:
c     --------
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
#include "drsdef.h"
#ifdef ibm
      external malloc !$pragma C( malloc )
#endif
      miallocw=IDRS_SUCCESS

#ifdef cray

c     *** UNICOS version ***

      call hpalloc(ptr,len,ierr,0)
      if(ierr.lt.0) then
         miallocw=IDRS_NOMEMORY
         go to 9000
      endif

#else !cray
c     *** SUN-like version ***

#ifdef ibm
      len2 = IDRS_BYTES_PER_WORD*len
      ptr=malloc(%val(len2))
#else
#ifdef __linux_absoft
c     Linux version
      ptr=malloc_(IDRS_BYTES_PER_WORD*len)
#else
      ptr=malloc(IDRS_BYTES_PER_WORD*len)
#endif
#endif
      if(ptr.eq.0) then
         miallocw=IDRS_NOMEMORY
         go to 9000
      endif
#endif cray

 9000 continue
      call drsrout('miallocw',miallocw)
      end

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Routine: 
c     -------
      integer function miextenw(len,ptr)
      pointer(ptr,buf)
c
c     Description:
c     -----------
c     Extend the memory block pointed to by ptr to length len in WORDS
c
c     Arguments:
c     ---------
c     len  =:  new length in WORDS
c     ptr  =:  pointer to memory block
c
c     
c     Function Returns:
c     ----------------
c       0: success
c     IDRS_NOMEMORY: cannot extend to specified length
c     Author: Bob Drach
c     ------
c     Date: 10/26/89
c     ----
c     Notes:
c     -----
c     The data in the old memory block may be lost.
c     This routine is machine-dependent
c
c     Glossary:
c     --------
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

#include "drsdef.h"
#ifdef ibm
      external malloc !$pragma C( malloc )
      external free !$pragma C( free )
#endif
      miextenw=IDRS_SUCCESS

#ifdef cray

c     *** UNICOS version ***

      call hpclmove(ptr,len,ierr,0)
      if(ierr.lt.0) then
         miextenw=IDRS_NOMEMORY
         go to 9000
      endif

#else !cray
c     *** SUN-like version ***

#ifdef ibm
      call free(%val(ptr))
      len2 = IDRS_BYTES_PER_WORD*len
      ptr=malloc(%val(len2))
#else
#ifdef __linux_absoft
c     Linux version
      call free_(ptr)
      ptr=malloc_(IDRS_BYTES_PER_WORD*len)
#else
      call free(ptr)
      ptr=malloc(IDRS_BYTES_PER_WORD*len)
#endif
#endif
      if(ptr.eq.0) then
         miextenw=IDRS_NOMEMORY
         go to 9000
      endif
#endif cray

 9000 continue
      call drsrout('miextenw',miextenw)
      end


