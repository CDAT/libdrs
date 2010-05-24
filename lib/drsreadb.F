c**********************************************************************
c
c     drsreadb.F,v 2.3 1995/03/30 00:50:41 drach Exp
c     drsreadb.F,v
c Revision 2.3  1995/03/30  00:50:41  drach
c Added disclaimer
c
c Revision 2.2  1994/07/05  18:43:24  drach
c NSL version calls nsllseek and nslread, instead of Fortran read.
c
c Revision 2.1  1993/10/15  19:48:59  drach
c Added to repository.
c
c     
c     Routine: 
c     -------
      integer function drsreadb(nl,iblnum)
      integer nl, iblnum
c
c     Description:
c     -----------
c     Read a data block, whether partial or whole, into the buffer
c     for that file (iblock(nl))
c
c     Arguments:
c     ---------
c     nl     =:  file number (NOT logical unit) of file to read
c     iblnum =:  1-origin block number to read
c
c     
c     Function Returns:
c     ----------------
c       0: success
c     IDRS_CANNOTREADDATA
c     
c     Author: Bob Drach
c     ------
c
c     Date: 10/15/93
c     ----
c
c     Notes:
c     -----
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

      drsreadb = IDRS_SUCCESS

c     Calculate last record number

      ireclast = (mxdat(nl)-1)/idatrecl + 1
      if(ireclast.lt.0) ireclast=0

c     If this is not the last record, or the record ends
c     on a block boundary, read the whole record
      
#ifdef NSL_DRS
      if(it(nl)(2:2).eq.'N') then
         ioff=(iblnum-1)*idatrecl
         istat=nsllseek(luda(nl),ioff,0)
         if(istat.eq.-1) go to 9001
      endif
#endif      

      if(iblnum.lt.ireclast .or. mxdat(nl).eq.(ireclast*idatrecl)) then
#ifdef NSL_DRS
         if(it(nl)(2:2).eq.'N') then
            istat=nslread(luda(nl),iblock(1,nl),idatrecl)
            if(istat.eq.-1) go to 9001
         else
            ptblock= loc(iblock(1,nl))
            read (luda(nl),rec=iblnum,err=9001) tblock
         endif
#else
         ptblock= loc(iblock(1,nl))
         read (luda(nl),rec=iblnum,err=9001) tblock
#endif
      else

c     Read a partial block

         ireadb = mxdat(nl) - ((iblnum-1)*idatrecl)
#ifdef cray
c     Cray DRS files are word-addressed
         if(ireadb.gt.0) then
            ireadb = (ireadb-1)/8 + 1
         else
            ireadb = 0
         endif
#endif
#ifdef NSL_DRS
         if(it(nl)(2:2).eq.'N') then
            istat=nslread(luda(nl),iblock(1,nl),ireadb*8)
            if(istat.eq.-1) go to 9001
         else
            read(luda(nl),rec=iblnum,err=9001) (iblock(i,nl),i=1,ireadb)
         endif
#else
         read(luda(nl),rec=iblnum,err=9001) (iblock(i,nl),i=1,ireadb)
#endif
      endif

      iblno(nl)=iblnum
      ibdirty(nl)=0
         
      go to 9000

 9001 continue
      drsreadb= IDRS_CANNOTREADDATA

 9000 continue

      call drsrout('drsreadb',drsreadb)
      return
      end
