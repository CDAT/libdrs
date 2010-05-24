c redat.F,v 2.3 1995/03/30 00:51:16 drach Exp
c redat.F,v
c Revision 2.3  1995/03/30  00:51:16  drach
c Added disclaimer
c
c Revision 2.2  1993/10/15  19:32:00  drach
c - Read blocks via drsreadb, to handle partial data blocks
c - Set ibdirty to 'CLEAN' on read
c
c Revision 2.1  1993/07/13  01:13:36  drach
c Merged Sun, Unicos, SGI, and HP versions.
c
c Revision 2.1  1992/05/21  17:43:00  drach
c Changed implied do loops on I/O statements to read/writes of pointer variables;
c Rewrote copies on Sun version to use bcopy
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
      integer function redat (lu,a)

c***********************************************************************
c
#include "drscom.h"
#include "drsdef.h"
c
      logical drstest
      integer drsreadb
      
#ifdef cray
      integer a(1)
#else !cray
      external bcopy !$pragma C( bcopy )
      byte a(*)
#endif cray

      integer lu
      integer iw1,kn,il,ik,ij,ii,kl,kk,kj,ki
c
c            lu  - is the dictionary logical unit
c            a   - is the array to which data is transferred
c            ierr- is the error return code
c                  0 - data retrieved as requested
c                  1 - error reading data
c
      redat=IDRS_SUCCESS
c
      nl=iflun(lu)
      if (nl.le.0) go to 9001
      do 20 i=1,mxdim
      io1(i)=(io1(i)-1)*ios(i)
      io2(i)=(io2(i)-1)*ios(i)
      ion(i)=ion(i)*ios(i)
      in1(i)=in1(i)*ins(i)
  20  inn(i)=inn(i)*ins(i)
c
      iw1=(iblno(nl)-1)*idatrecl+1
      il=in1(4)-ins(4)
      do 1300 kl=io1(4),io2(4),ion(4)
      ik=in1(3)-ins(3)
      do 1200 kk=io1(3),io2(3),ion(3)
      ij=in1(2)-ins(2)
      do 1100 kj=io1(2),io2(2),ion(2)
      ii=in1(1)-ins(1)
      do 1000 ki=io1(1),io2(1),ion(1)
      kn=iadd+ki+kj+kk+kl
      in=1+ii+ij+ik+il

c----------------------------------------------------------------------------

c     Copy element from iblock to a
c     ibl, jbl = indices, into iblock, of first and last bytes of element
c     kn = 1-origin byte address of start of element, in file
c     in = byte index, into a, of element

c     Fill block with first record to be written

      irec= (kn-1)/idatrecl + 1
      ibl= mod(kn-1,idatrecl)+1
      jbl= ibl+nbyt-1

      do 30 n=1,nbyt

c     If current record is incorrect, read new record

         if(irec.ne.iblno(nl)) then

            if(drstest(drsreadb(nl,irec))) go to 9001

            iblno(nl)=irec
            ibdirty(nl)=0
         endif

c     Copy as many bytes as possible from buffer to data array

         iclen= min0(jbl,idatrecl)-ibl+1


#ifdef cray
         call strmov(iblock(1,nl),ibl,iclen,a,in)
#else !cray
c$$$         do 25 i=1,iclen
c$$$            a(in+i-1)= iblock(ibl+i-1,nl)
c$$$ 25      continue
      call bcopy(iblock(ibl,nl),a(in),%val(iclen))
#endif cray

c     If more bytes to read into the element,
c     read the new block and update all pointers
c     otherwise exit the loop

         if(ibl+iclen .le. jbl) then
            irec= irec+1
            ibl= 1
            jbl= jbl-idatrecl
            in= in+iclen
         else
            go to 35
         endif
 30   continue
 35   continue

c----------------------------------------------------------------------------

      ii=ii+inn(1)
 1000 continue
      ij=ij+inn(2)
 1100 continue
      ik=ik+inn(3)
 1200 continue
      il=il+inn(4)
 1300 continue
      go to 9000
c                          error returns
 9001 continue
      redat=IDRS_CANNOTREADDATA
 9000 continue
      call drsrout('redat',redat)
      return
      end

