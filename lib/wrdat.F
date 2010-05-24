c wrdat.F,v 2.6 1995/03/30 00:51:26 drach Exp
c wrdat.F,v
c Revision 2.6  1995/03/30  00:51:26  drach
c Added disclaimer
c
c Revision 2.5  1994/07/05  18:45:29  drach
c NSL version calls nsllseek and nslwrite instead of Fortran writes.
c
c Revision 2.4  1993/10/21  01:24:15  drach
c Changed names of sync options for consistency.
c
c Revision 2.3  1993/10/20  17:19:24  drach
c Flush the buffer automatically, if autosync is ON.
c Set dirty flag immediately after data is written.
c
c Revision 2.2  1993/10/15  19:33:43  drach
c - Modified to write data only when the current buffer is full.
c - Removed zeroing out a new data block
c
c Revision 2.1  1993/07/13  01:13:50  drach
c Merged Sun, Unicos, SGI, and HP versions.
c
c Revision 2.1  1992/05/21  17:44:21  drach
c Changed implied do loops on I/O statements to read/writes of pointer variables
c on both Sun and Unicos versions;
c Rewrote copies on Sun version to use bcopy and bzero
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
      integer function wrdat (lu,a)

c***********************************************************************
c
#include "drscom.h"
#include "drsdef.h"
      logical drstest
      integer drsreadb

#ifdef cray
      integer a(1)
      pointer (ptblock,tblock)
      integer tblock(ibloclen)
#else !cray
      external bcopy !$pragma C( bcopy )
      external bzero !$pragma C( bzero )
      byte a(*)
      pointer (ptblock,tblock)
      byte tblock(ibloclen)
#endif cray

      integer iw1,kn,il,ik,ij,ii,kl,kk,kj,ki
      integer lu
c
c            lu  - is the logical unit for dictionary
c            a   - is the array from which data is transferred
c            ierr- is the error return code
c                  0 - data written as requested
c                  1 - error writing data
c
      wrdat=IDRS_SUCCESS

      nl=iflun(lu)
      if (nl.le.0) go to 9001

c     Calculate the next record number, and last record number

      irecn=(iadd-1)/idatrecl+1
      irec=(mxdat(nl)+idatrecl-1)/idatrecl

c     If the next record is not the current record, then
c       If the current block has data, write it
c       If the new block has data, read it
c       Update current block number

      if(irecn.ne.iblno(nl)) then
         if(ibdirty(nl).eq.1) then
            ptblock= loc(iblock(1,nl))
#ifdef NSL_DRS
            if(it(nl)(2:2).eq.'N') then
               ioff=(iblno(nl)-1)*idatrecl
               istat=nsllseek(luda(nl),ioff,0)
               if(istat.eq.-1) go to 9001
               istat=nslwrite(luda(nl),iblock(1,nl),idatrecl)
               if(istat.eq.-1) go to 9001
            else
               write (luda(nl),rec=iblno(nl),err=9001) tblock
            endif
#else            
            write (luda(nl),rec=iblno(nl),err=9001) tblock
#endif
         endif
         if(irec.eq.irecn) then
            if(drstest(drsreadb(nl,irecn))) go to 9002
         endif
         iblno(nl)=irecn
      endif

      do 20 i=1,mxdim
      in1(i)=in1(i)*ins(i)
      inn(i)=inn(i)*ins(i)
  20  continue
      iw1=(irecn-1)*idatrecl+1
      kn=iadd
      il=in1(4)-ins(4)
      do 1300 kl=1,io2(4)
      ik=in1(3)-ins(3)
      do 1200 kk=1,io2(3)
      ij=in1(2)-ins(2)
      do 1100 kj=1,io2(2)
      ii=in1(1)-ins(1)
      do 1000 ki=1,io2(1)
      in=1+ii+ij+ik+il

c----------------------------------------------------------------------------

c     Copy element from a to iblock
c     ibl, jbl = indices, into iblock, of first and last bytes of element
c     kn = 1-origin byte address of start of element, in file
c     in = byte index, into a, of element

      ibl= mod(kn-1,idatrecl)+1
      jbl= ibl+nbyt-1
      irec= (kn-1)/idatrecl+1

      do 30 n=1,nbyt


c     If done writing to current block,
c     flush the block, zero out block, and update block number

         if(irec.ne.iblno(nl)) then


c$$$            write (luda(nl),rec=iblno(nl),err=9001)
c$$$     $        (iblock(i,nl),i=1,ibloclen)
            ptblock = loc(iblock(1,nl))
#ifdef NSL_DRS
            if(it(nl)(2:2).eq.'N') then
               ioff=(iblno(nl)-1)*idatrecl
               istat=nsllseek(luda(nl),ioff,0)
               if(istat.eq.-1) go to 9001
               istat=nslwrite(luda(nl),iblock(1,nl),idatrecl)
               if(istat.eq.-1) go to 9001
            else
               write (luda(nl),rec=iblno(nl),err=9001) tblock
            endif
#else
            write (luda(nl),rec=iblno(nl),err=9001) tblock
#endif
            iblno(nl)=iblno(nl)+1
         endif

c     Copy as many bytes as possible to the buffer
c     and mark the buffer as dirty

         iclen= min0(jbl,idatrecl)-ibl+1

#ifdef cray
	 call strmov(a,in,iclen,iblock(1,nl),ibl)
#else !cray
c$$$         do 25 i=1,iclen
c$$$            iblock(ibl+i-1,nl)= a(in+i-1)
c$$$ 25      continue
      call bcopy(a(in),iblock(ibl,nl),%val(iclen))
#endif cray

      ibdirty(nl)=1

c     If more data for this element, update the pointers
c     and read a new block, else exit the loop

         if(ibl+iclen .le. jbl) then
            ibl= 1
            jbl= jbl-idatrecl
            in= in+iclen
            irec= irec+1
         else
            go to 35
         endif
 30   continue
 35   continue

c----------------------------------------------------------------------------

      kn=kn+nbyt
      ii=ii+inn(1)
 1000 continue
      ij=ij+inn(2)
 1100 continue
      ik=ik+inn(3)
 1200 continue
      il=il+inn(4)
 1300 continue

c     If autosync is on, flush the buffer even if partially full
c     Note: synch is off for NSL version, so this code fragment is
c     executed in drssync for the NSL, at which point mxdat is
c     properly set to calculate amount to write

      if(isynch(nl).eq.IDRS_SYNC_ON) then
         ptblock = loc(iblock(1,nl))
         write (luda(nl),rec=iblno(nl),err=9001) tblock
         ibdirty(nl)=0
      endif

      go to 9000
c                          error returns
 9002  continue
       wrdat=IDRS_CANNOTREADDATA
       go to 9000
 9001 continue
      wrdat=IDRS_CANNOTWRITEDATA
 9000 continue
      call drsrout('wrdat',wrdat)
      return
      end

      
