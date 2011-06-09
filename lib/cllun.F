c cllun.F,v 2.10 1995/10/26 23:21:52 drach Exp
c cllun.F,v
c Revision 2.10  1995/10/26  23:21:52  drach
c - Copy dictionary to NSL on close, then remove the file, NSL version
c
c Revision 2.9  1995/07/28  22:54:54  drach
c - Modified for IBM RS/6000 version
c
c Revision 2.8  1995/03/30  00:50:24  drach
c Added disclaimer
c
c Revision 2.7  1994/07/05  18:42:56  drach
c - NSL version calls nslclose instead of Fortran close.
c - No truncation needed for NSL version, which uses direct NSL calls.
c
c Revision 2.6  1993/12/11  01:35:40  drach
c Do not truncate if NSL/UniTree file
c
c Revision 2.5  1993/10/21  01:22:21  drach
c Only call truncation on write or extend.
c
c Revision 2.4  1993/10/20  17:16:17  drach
c Handle autosync flags.
c
c Revision 2.3  1993/10/15  21:32:25  drach
c Add call to synchronize before close.
c
c Revision 2.2  1993/10/15  19:29:38  drach
c (1) Truncate the file after closing, to actual number of bytes written, rounded up to 8 byte boundary for Cray compatibility.
c (2) Handle deletion of ibdirty entry.
c
c Revision 2.1  1993/07/13  01:12:35  drach
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
      integer function cllun (lu)

c***********************************************************************
c
c         lu      is the logical unit for the dictionary file.
c
c     Modified: 5/6/91 (BD) Modified reset of dictionary vars (n_lun, etc.)
c
#include "drscom.h"
#include "drsdef.h"
#ifdef NSL_DRS
      integer drsl2ncp
#endif
      integer cpdic

c
      cllun=IDRS_SUCCESS
      il=iflun(lu)
      if (il.eq.0) return

c     Flush buffer if necessary
      call drssync(lu)

c     Close the dictionary file.
c     On a Macintosh, also copy the temporary copy of the dictionary file to
c     its permanent, remote location if any, and close that too.
      close (unit=ludi(il))
#ifdef mac64
      if ( ludi2(il).gt.0 ) then
         ierr = cpdic( dif(il), ludi(il), ludi2(il) )
         if ( ierr.ne.0 ) then
            cllun = IDRS_CANNOTWRITEDIC
            go to 9000
         endif
      endif
      close (unit=ludi2(il))
#endif

c     Close the data file.
#ifdef NSL_DRS
      if(it(il)(2:2).eq.'N') then
         istat=nslclose(luda(il))
      else
         close (unit=luda(il))
      endif
c     Apparently, only one NSL file can be open at a time !!!
c     Close the data file before copying the dictionary ...
c     Copy local dictionary to NSL on write or extend
      if((it(il)(1:1).eq.'W' .or. it(il)(1:1).eq.'E'))
     $     cllun = drsl2ncp(dif(il),nsldif(il))
      if(cllun.ne.IDRS_SUCCESS) then
         cllun = IDRS_CANNOTWRITEDIC
         go to 9000
      endif
      call unlink(dif(il))

#else
      close (unit=luda(il))
#endif

c     Truncate on write or extend.
c     Do not truncate NSL data files - they are written
c     with direct NSL calls.

#ifdef NSL_DRS
      if((it(il)(2:2).ne.'N').and.
     $     (it(il)(1:1).eq.'W' .or. it(il)(1:1).eq.'E'))
     $     call drstrunc(daf(il),mxdat(il))
#else
      if(it(il)(1:1).eq.'W' .or. it(il)(1:1).eq.'E')
     $    call drstrunc(daf(il),mxdat(il))
#endif

      if (il.lt.nf) then
         ioff=n_rec(1,il+1)-n_rec(1,il)
        do 100 i=il+1,nf
        luda(i-1)=luda(i)
        ludi(i-1)=ludi(i)
        nvdb(i-1)=nvdb(i)
        mxdat(i-1)=mxdat(i)
        drsvers(i-1)=drsvers(i)
#ifdef mac64
        ludi2(i-1)=ludi2(i)
        dif2(i-1)=dif2(i)
#endif

        it(i-1)=it(i)
        daf(i-1)=daf(i)
        dif(i-1)=dif(i)
        iblno(i-1)=iblno(i)
        ibdirty(i-1)=ibdirty(i)
        isynch(i-1)=isynch(i)
        do 10 j=1,ibloclen
        iblock(j,i-1)=iblock(j,i)
  10    continue
c
        n_rec(1,i-1)=n_rec(1,i)-ioff
        n_rec(2,i-1)=n_rec(2,i)-ioff
        do 20 j=n_rec(1,i-1),n_rec(2,i-1)
        jj=j+ioff
        n_src(j)=n_src(jj)
        n_nam(j)=n_nam(jj)
        n_tit(j)=n_tit(jj)
        n_un(j)=n_un(jj)
        n_lun(j)=n_lun(jj)
  20    continue
c
 100    continue
      endif
      n_rec(1,nf)=0
      n_rec(2,nf)=0
      luda(nf)=0
      ludi(nf)=0
      nvdb(nf)=0
      mxdat(nf)=0
      drsvers(nf)=0.0


      it(nf)=' '
      daf(nf)=' '
      dif(nf)=' '
      nf=nf-1
      cllun=0
 9000 continue
      call drsrout('cllun',cllun)
#ifdef mac64mmap
c     un-map files from memory
      ierr = funmapf()
#endif

      return
      end

      integer function cpopendic( lusrc, lutrg )
c copies a file at logical unit lusrc (source) to logical unit lutarg (target).
c This function is specific to DRS.  I particular, lusrc & lutrg must be known to the
c DRS library, and must point to a dictionary file, so the library can get the
c file length.  Both logical units must correspond to files which have been
c opened, for direct unformatted access, readable or writeable as appropriate..
#include "drscom.h"
      integer lusrc, lutrg
      integer ierr, ilsrc, iltrg, irec
      ilsrc = iflun(lusrc)
      if (ilsrc.eq.0) then
         ierr = -1
         go to 9000
      endif

      ierr = 0
      do irec = 1, 2*nvdb(ilsrc)+1
         read( unit=lusrc, rec=irec, err=9001 ) abuf
         write( unit=lutrg, rec=irec, err=9001 ) abuf
      enddo

      go to 9000
 9001 ierr = 1
 9000 cpopendic = ierr
      return
      end

      integer function cpdic( src, lusrc, lutrg )
c copies a file named src (string, 'source') to logical unit lutarg (integer).
c The target logical unit must correspond to a file which has been
c opened, for direct unformatted access, and writeable as appropriate.
c The source file should have been closed, but logical unit lusrc must be
c available to use for opening it.  This function will delete the source file!
#include "drscom.h"
      integer lusrc, lutrg
      character mybuf
      integer ierr, ilsrc, iltrg, irec
      character*(*) src

c     Open the t
      open (unit=lusrc,file=src,status='old',
     1     access='direct',recl=1,form='unformatted',
     2     err=9001,CONVERT='big_endian')

      irec = 1
      do
         read( unit=lusrc, rec=irec, err=9000 ) mybuf
         write( unit=lutrg, rec=irec, err=9002 ) mybuf
         irec = irec + 1
      enddo

 9000 ierr = 0
      cpdic = ierr
      close( unit=lusrc, status='delete' )
      return
 9001 ierr = 1
      cpdic = ierr
      close( unit=lusrc )
      return
 9002 ierr = 2
      cpdic = ierr
      close( unit=lusrc )
      return

      end
