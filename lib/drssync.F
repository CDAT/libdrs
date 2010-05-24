c**********************************************************************
c
c     drssync.F,v 2.4 1995/03/30 00:50:42 drach Exp
c     drssync.F,v
c Revision 2.4  1995/03/30  00:50:42  drach
c Added disclaimer
c
c Revision 2.3  1994/07/05  18:44:07  drach
c NSL version calls nsllseed and nslwrite, instead of Fortran write.
c
c Revision 2.2  1993/10/15  21:32:45  drach
c Only write when block is dirty.
c
c Revision 2.1  1993/10/15  19:48:04  drach
c Added to repository.
c
c     
c     Routine: 
c     -------
      integer function drssync(lu)
      integer lu
c
c     Description:
c     -----------
c     Flush the buffer for a DRS file.
c
c     Arguments:
c     ---------
c     lu    =:  logical unit for the dictionary
c
c     
c     Function Returns:
c     ----------------
c       0: success
c     IDRS_BADLU
c     IDRS_CANNOTWRITEDATA
c     
c     Author: Bob Drach
c     ------
c
c     Date: 10/15/93
c     ----
c
c     Notes:
c     -----
c     Prior to V2.9, data and dictionary file were automatically synchronized.
c     Subsequently, the file must be closed (via cllun) and/or synchronized
c     via this routine to ensure that all the data has actually been written.
c
c     Glossary:
c     --------
c
c**********************************************************************

#include "drscom.h"
#include "drsdef.h"

      pointer (ptblock,tblock)
#ifdef cray
      integer tblock(ibloclen)
#else
      byte tblock(ibloclen)
#endif cray

      drssync = IDRS_SUCCESS

      il= iflun(lu)
      if(il.le.0) then
         drssync= IDRS_BADLU
         go to 9000
      endif

      if(ibdirty(il).eq.1) then
         ptblock= loc(iblock(1,il))
#ifdef NSL_DRS
         if(it(il)(2:2).eq.'N') then
            ioff=(iblno(il)-1)*idatrecl
            istat=nsllseek(luda(il),ioff,0)
            if(istat.eq.-1) go to 9001
            ireclast = (mxdat(il)-1)/idatrecl + 1
            if(iblno(il).lt.ireclast) then
               iwriteb=idatrecl
            else
               iwriteb=mxdat(il) - ((iblno(il)-1)*idatrecl)
               iwriteb=512*((iwriteb-1)/512 + 1)
            endif
            istat=nslwrite(luda(il),iblock(1,il),iwriteb)
            if(istat.eq.-1) go to 9001
         else
            write (luda(il),rec=iblno(il),err=9001) tblock
         endif
#else
         write (luda(il),rec=iblno(il),err=9001) tblock
#endif
         ibdirty(il)=0
      endif

      go to 9000

 9001 continue
      drssync= IDRS_CANNOTWRITEDATA

 9000 continue

      call drsrout('drssync',drssync)
      return
      end

