ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c savdb.F,v 2.3 1995/07/28 22:55:16 drach Exp
c savdb.F,v
c Revision 2.3  1995/07/28  22:55:16  drach
c - Modified for IBM RS/6000 version
c
c Revision 2.2  1995/03/30  00:51:18  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:38  drach
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
      integer function savevdbs(ibuf)
c
c     Description:
c     -----------
c     Save all vdb blocks
c
c     Arguments:
c     ---------
c     ibuf := index to save buffer area
c
c     
c     Function Returns:
c     ----------------
c       0: success
c     IDRS_SAVEBUFOVERFLOW: no more save buffers: increase mxdepth and recompile
c     
c     Author: Bob Drach
c     ------
c     Date: 10/26/89
c     ----
c     Notes:
c     -----
c     (1)ibuf is intended to be passed to restvdbs
c     (2) these routines are essentially a kluge, and should not
c        be necessary when the entire dictionary resides in memory
c     Glossary:
c     --------
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

#include "drscom.h"
#include "drsdef.h"
#include "cycle.h"

#ifndef ibm
      data nbufsav/0/
#endif

      savevdbs=IDRS_SUCCESS
      nbufsav=nbufsav+1
      if(nbufsav.lt.1 .or. nbufsav.gt.mxdepth) then
         savevdbs=IDRS_SAVEBUFOVERFLOW
         go to 9000
      endif

      do 10 i=1,mxbuf
         cavdbsav(nbufsav,i)=abuf(i)
         cuvdbsav(nbufsav,i)=ubuf(i)
 10   continue

      do 20 i=1,mxiabuf
         qavdbsav(nbufsav,i)=iabuf(i)
 20   continue

      do 30 i=1,mxiubuf
         quvdbsav(nbufsav,i)=iubuf(i)
 30   continue

      do 40 i=1,mxubuf2
         cuvd2sav(nbufsav,i)=ubuf2(i)
 40   continue

      do 50 i=1,mxiuvdb
         iuvdbsav(nbufsav,i)=iuvdbuf(i)
 50   continue

      do 60 i=1,mxqddb
         qddbsav(nbufsav,i)=iqddbuf(i)
 60   continue

      do 70 i=1,mxcycleb
         icycbsav(nbufsav,i)=icyclebf(i)
 70   continue

 9000 continue
      ibuf=nbufsav
      call drsrout('savevdbs',savevdbs)
      return
      end

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Routine: 
c     -------
      integer function restvdbs(ibuf)
c
c     Description:
c     -----------
c     Restore all vdb blocks
c
c     Arguments:
c     ---------
c     ibuf =:  index to save buffer area
c
c     
c     Function Returns:
c     ----------------
c       0: success
c     IDRS_SAVEBUFOVERFLOW: no more save buffers: increase mxdepth and recompile
c     
c     Author: Bob Drach
c     ------
c     Date: 10/26/89
c     ----
c     Notes:
c     -----
c
c     Glossary:
c     --------
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

#include "drscom.h"
#include "drsdef.h"
#include "cycle.h"

      restvdbs=IDRS_SUCCESS
      nbufsav=ibuf
      if(nbufsav.lt.1 .or. nbufsav.gt.mxdepth) then
         restvdbs=IDRS_SAVEBUFOVERFLOW
         go to 9000
      endif

      do 10 i=1,mxbuf
         abuf(i)=cavdbsav(nbufsav,i)
         ubuf(i)=cuvdbsav(nbufsav,i)
 10   continue

      do 20 i=1,mxiabuf
         iabuf(i)=qavdbsav(nbufsav,i)
 20   continue

      do 30 i=1,mxiubuf
         iubuf(i)=quvdbsav(nbufsav,i)
 30   continue

      do 40 i=1,mxubuf2
         ubuf2(i)=cuvd2sav(nbufsav,i)
 40   continue

      do 50 i=1,mxiuvdb
         iuvdbuf(i)=iuvdbsav(nbufsav,i)
 50   continue

      do 60 i=1,mxqddb
         iqddbuf(i)=qddbsav(nbufsav,i)
 60   continue

      do 70 i=1,mxcycleb
         icyclebf(i)=icycbsav(nbufsav,i)
 70   continue

      nbufsav=nbufsav-1
 9000 continue
      call drsrout('restvdbs',restvdbs)
      return
      end
