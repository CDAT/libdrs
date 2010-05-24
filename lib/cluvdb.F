c cluvdb.F,v 2.2 1995/03/30 00:50:25 drach Exp
c cluvdb.F,v
c Revision 2.2  1995/03/30  00:50:25  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:12:36  drach
c Merged Sun, Unicos, SGI, and HP versions.
c
c Revision 2.0  1992/03/07  00:08:14  drach
c Entered into RCS
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
c***********************************************************************
      integer function cluvdb()
c***********************************************************************
c     
c     Modified: 6/14/90 (BD) for cycle dimensions
      
#include "drscom.h"
#include "drsdef.h"
      integer setcdim
      dimension default(mxdim)
c     
      cluvdb=0
      do 2 n=1,mxdim
         default(n)=0.0
 2    continue
      do 5 n=1,mxbuf
         ubuf(n)=' '
 5    continue
      ndu=0
      luty=0
      neu=0
      utype2=' '
      progrep=IDRS_DEFAULT
      filerepu=IDRS_DEFAULT
      lpty=0
      do 10 i=1,mxdim
         iuds(i)=0
         dfu(i)=xnull
         dlu(i)=xnull
         dfu2(i)=xnull
         dlu2(i)=xnull
         iudim(i)=0
 10   continue
      do 20 i=1,mxdim
         dimtypeu(i)=IDRS_NOVALUE
         dimmonou(i)=0
         dimaddru(i)=-1
         udso(i)=' '
         udti(i)=' '
 20   continue
      dvfu=xnull
      dvlu=xnull
      cluvdb=setcdim(mxdim,default,default,
     $     default,default,default,default,0)
      call drsrout('cluvdb',cluvdb)
      return
      end
