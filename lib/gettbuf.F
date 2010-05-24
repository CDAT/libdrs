ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c gettbuf.F,v 2.2 1995/03/30 00:50:58 drach Exp
c gettbuf.F,v
c Revision 2.2  1995/03/30  00:50:58  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:12  drach
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
      integer function gettbuf(len,ptr)
c     
c     Description:
c     -----------
c     Get pointer to translation buffer, of length len
c     
c     Arguments:
c     ---------
c     len =: Required length, in bytes
c     ptr  := pointer
c     
c     
c     Function Returns:
c     ----------------
c     0: success
c     IDRS_NOMEMORY  Cannot allocate memory for translation buffer.
c     
c     Author: Bob Drach
c     ------
c     Date: 1/10/90
c     ----
c     Notes:
c     -----
c     
c     Glossary:
c     --------
c     traninit = .true. iff buffer has been initialized
c     itbufptr = pointer to translation buffer
c     itbuflen = current length of translation buffer
c     
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      
#include "drsdef.h"
      
      pointer (itbufptr,itranbuf(1))
      logical traninit, drstest
      integer itbuflen, ptr
      data itbuflen /0/, traninit/.false./
      
      save traninit, itbufptr, itbuflen
      
      gettbuf=IDRS_SUCCESS
      
      if(len.gt.itbuflen) then
         if(traninit) then
            gettbuf=miextend(len,itbufptr)
         else
            gettbuf=mialloc(len,itbufptr)
            traninit= .true.
         endif
         if(drstest(gettbuf)) go to 9000
         itbuflen=len
      endif
      ptr=itbufptr
      
 9000 continue
      call drsrout('gettbuf',gettbuf)
      
      return
      end


