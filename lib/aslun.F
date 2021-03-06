c aslun.F,v 2.15 1996/05/29 19:11:25 drach Exp
c aslun.F,v
c Revision 2.15  1996/05/29  19:11:25  drach
c - Fixed bug in SGI version which caused precompiler to select the wrong
c   open statement in aslun
c - Removed dependency on drsdef.h in Makefile.SGI
c - Fixed up revision log in aslun.F
c
c aslun.F,v 2.12 1995/10/26 23:21:17 drach Exp
c aslun.F,v
c Revision 2.12  1995/10/26  23:21:17  drach
c - added IDRS_NOCOPY option for NSL
c
c Revision 2.11  1995/10/16  18:46:53  drach
c - Modified for DEC Alpha
c
c Revision 2.10  1995/07/28  22:54:50  drach
c - Modified for IBM RS/6000 version
c
c Revision 2.9  1995/03/30  00:48:24  drach
c Added NSL flag as aslun open mode option
c
c Revision 2.8  1994/11/23  19:14:27  drach
c Changed nslopen to nsldrsopen.
c
c Revision 2.7  1994/07/05  18:41:42  drach
c NSL version uses nslopen instead of Fortran open.
c
c Revision 2.6  1993/12/11  01:35:10  drach
c Added option for NSL library.
c
c Revision 2.5  1993/10/21  01:22:01  drach
c Changed name of sync options for consistency.
c
c Revision 2.4  1993/10/20  17:15:47  drach
c Initialize autosync option to ON.
c
c Revision 2.3  1993/10/15  19:28:23  drach
c (1) Call drsreadb when reading the first data block to handle partial data blocks
c (2) Set ibdirty to CLEAN (0) on open.
c
c Revision 2.2  1993/08/13  23:55:42  drach
c Added check that logical units for dictionary and data files are not in use.
c
c Revision 2.1  1993/07/13  01:12:30  drach
c Merged Sun, Unicos, SGI, and HP versions.
c
c Revision 2.3  1993/03/09  22:40:42  drach
c Fixed bug which caused initial block of data not to be read when file
c was opened with IDRS_EXTEND, even though it is legal to read from
c such a file.
c
c Revision 2.2  1992/10/06  00:20:53  drach
c *** empty log message ***
c
c Revision 2.1  1992/05/22  01:06:44  drach
c Changed default error output unit to 0 (stderr)
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
      integer function aslun (lud,dicfil,lu,datfil,istat)

c***********************************************************************
c
c        assign logical unit numbers for the dictionary and data files
c
c     Modified 4/2/91 (BD) added idirty test (cf getindex)
c
c        if istat is IDRS_READ the datfil name will be taken from the
c        dictionary file
c
#include "drscom.h"
#include "drsdef.h"

#ifndef ibm
      data curreplevel/IDRS_WARNING/
#endif
#ifdef hpux
#ifdef __linux_absoft
      data ierrun/9/
#else
#ifndef ibm
      data ierrun/7/
#endif
#endif
#else
      data ierrun/0/
#endif
c
      integer lud
      integer readhd,writehd,drsreadb
      logical drstest
      character*(*)dicfil
      integer lu
      character*(*) datfil
      integer istat
      character*40 dum
      integer ierr
#ifndef ibm
      data nf /0/
#endif

#ifdef cray
      character*248 dictf
      logical isnsl, icopynsl
      integer drsn2lcp
#else
      character*1024 dictf
#endif

c      character*40 path
c
c         lud     is the logical unit for the dictionary file.
c         dicfil  is the dictionary file specifier.
c         lu      is the logical unit for the data file.
c         datfil  is the data file specifier.
c         istat   is the data file status, IDRS_CREATE, IDRS_READ.
c         
c	aslun returns:
c                  IDRS_SUCCESS = successful open
c                  IDRS_TOOMANYFILES = number of files limit exceeded
c                  IDRS_CANNOTOPENDICT = dictionary file could not be opened or is IDRS_READ and empty
c                  IDRS_CANNOTOPENDATA = data file could not be opened
c                  IDRS_BADLU = illegal logical unit used <1 or >99 or lu=lud
c                               or one of the logical units is in use within DRS
c                  IDRS_BADSTATUS = status not IDRS_CREATE, IDRS_READ
c                  IDRS_DICTFULL = number of variables (mxent for all files) would be exceeded
c                  IDRS_DICTREADERROR = error reading dictionaly entries
c                  IDRS_CANNOTREADDATA = error reading first block of data after open
c                  IDRS_DICTALREADYOPEN = dictionary file is already open
c
c     Note: on a Macintosh, 64-bit, an additional, temporary, dictionary file will be opened.
c     Most reading and writing will be to and from the temporary dic file.  When the files are
c     closed the temporary file will be written to the specified file lud/dicfil.  This improves
c     performance if the specified file is elsewhere on a network.
      aslun=0
#ifdef NSL_DRS
      icopynsl=(istat.lt.IDRS_NOCOPY)
      if(.not.icopynsl) istat = istat-IDRS_NOCOPY
      isnsl=(istat.ge.IDRS_NSL)
      if(isnsl)istat=istat-IDRS_NSL
#endif      
      if (istat.ne.IDRS_CREATE.and.istat.ne.IDRS_READ.and.
     $     istat.ne.IDRS_EXTEND) then
        aslun=IDRS_BADSTATUS
        go to 9000
      endif
      if (lu.lt.1.or.lud.lt.1.or.
     1                  lu.gt.99.or.lud.gt.99.or.lu.eq.lud) then
        aslun=IDRS_BADLU
        go to 9000
      endif

c     Check that logical units are not already in use

      do 5 i=1,nf
         if(lud.eq.ludi(i) .or. lu.eq.luda(i)) then
            aslun=IDRS_BADLU
            go to 9000
         endif
 5    continue

      dictf=dicfil
      do 10 i=1,nf
         if(dictf.eq.dif(i)) then
            if(lud.ne.ludi(i)) then
               aslun=IDRS_DICTALREADYOPEN
            endif
            go to 9000
         endif
 10   continue
      nf=nf+1
      if (nf.gt.mxfil) go to 9001
c
c                             save file status
c$$$      it(nf)=istat
      if(istat.eq.IDRS_READ) then
         it(nf)(1:1)='R'
      elseif(istat.eq.IDRS_CREATE) then
         it(nf)(1:1)='W'
      else
         it(nf)(1:1)='E'
      endif
#ifdef NSL_DRS
      if(isnsl) then
         it(nf)(2:2)='N'
      else
         it(nf)(2:2)=' '
      endif
      if(isnsl.and.icopynsl) then
         it(nf)(3:3)='C'
      else
         it(nf)(3:3)=' '
      endif
#endif      
c                                save logical unit numbers
      luda(nf)=lu
      ludi(nf)=lud
c
c     Determine the dictionary name. If no extension was specified,
c     use a '.dic' extension.
c
      do 12 i=len(dicfil),1,-1
         if(dicfil(i:i).ne.' ') then
            icpathln=i
            go to 13
         endif
 12   continue
      go to 9026
 13   continue

      do 15 i=icpathln,1,-1
         if(dicfil(i:i).eq.'/') then
            idirlen=i
            go to 18
         endif
 15   continue
      idirlen=0
 18   continue

      do 200 i=icpathln,idirlen+1,-1
         if(dicfil(i:i).eq.'.') then
            idcflen=i
            go to 210
         endif
 200  continue
      idcflen=icpathln+1
 210  continue

      if(idcflen.gt.icpathln) then
         dif(nf)=dicfil(1:icpathln)//'.dic'
         icpathln = icpathln+4
      else
         dif(nf)=dicfil(1:icpathln)
      endif

c     
c     Determine the datafile name. If no data file was specified, use
c     the dictionary name with a .dat extension. 
c
      do 212 i=len(datfil),1,-1
         if(datfil(i:i).ne.' ') then
            idpathln=i
            go to 213
         endif
 212  continue
      idpathln=0
 213  continue

      if(datfil.eq.' ') then
         daf(nf)=dicfil(1:idcflen-1)//'.dat'
      else
         do 215 i=idpathln,1,-1
            if(datfil(i:i).eq.'/') then
               idirlen2=i
               go to 217
            endif
 215     continue
         idirlen2=0
 217     continue

         ihasext=0
         do 220 i=idpathln,1,-1
            if(datfil(i:i).eq.'.') then
               ihasext=1
               go to 230
            endif
 220     continue
 230     continue

         if(idirlen2.eq.0 .and. idirlen.gt.0) then
            if(ihasext.eq.1) then
               daf(nf)=dicfil(1:idirlen)//datfil(1:idpathln)
            else
               daf(nf)=dicfil(1:idirlen)//datfil(1:idpathln)//'.dat'
            endif
         else
            if(ihasext.eq.1) then
               daf(nf)=datfil(1:idpathln)
            else
               daf(nf)=datfil(1:idpathln)//'.dat'
            endif
         endif
      endif

      
c            the files exist open the dictionary file and get the data file
c            name
      if (istat.eq.IDRS_READ.or.istat.eq.IDRS_EXTEND) then

#if defined(sgi)
        open (unit=ludi(nf),file=dif(nf),status='old',
     2       access='direct',form='unformatted',
     $       recl=idicrecl/IDRS_BYTES_PER_WORD,err=9002)
#elif defined(NSL_DRS)
        if(icopynsl) then
           nsldif(nf)=dif(nf)
           dif(nf)=nsldif(nf)(idirlen+1:icpathln)
           aslun = drsn2lcp(nsldif(nf),dif(nf))
           if(aslun.ne.IDRS_SUCCESS) go to 9002
        endif
        open (unit=ludi(nf),file=dif(nf),status='unknown',
     2       access='direct',form='unformatted',
     $       recl=idicrecl,err=9002)
#elif defined(__alpha)
        open (unit=ludi(nf),file=dif(nf),status='old',
     2       access='direct',form='unformatted',
     $       recl=idicrecl/IDRS_BYTES_PER_WORD,err=9002)
#elif defined(gfortran)
        open (unit=ludi(nf),file=dif(nf),status='old',
     2       access='direct',form='unformatted',
     $       recl=idicrecl,err=9021,CONVERT='big_endian')
#elif !defined(sgi)
        open (unit=ludi(nf),file=dif(nf),status='old',
     2       access='direct',form='unformatted',
     $       recl=idicrecl,err=9002)
#endif

c                      get data file name, number of vdbs, data length
c        read (ludi(nf),rec=1) daf(nf),nvdb(nf),mxdat(nf)
        if(drstest(readhd(ludi(nf),dum,nvdb(nf),mxdat(nf),
     $       drsvers(nf))))
     $       go to 9024


c
        if (nvdb(nf).le.0.or.mxdat(nf).le.0) go to 9025
c                       open the data file

#if defined(sgi)
      open (unit=luda(nf),file=daf(nf),status='old',
     1     access='direct',form='unformatted',
     $     recl=idatrecl/IDRS_BYTES_PER_WORD,err=9003)
#elif defined(NSL_DRS)

      if(isnsl) then
         do 240 i=len(daf(nf)),1,-1
            if(daf(nf)(i:i).ne.' ') then
               idpathln=i
               go to 250
            endif
 240     continue
 250     continue
         iordwr=2
         ifd=nsldrsopen(daf(nf)(1:idpathln),iordwr,666B)
         if(ifd.ne.-1) then
            luda(nf)=ifd
         else
            go to 9003
         endif
      else
         open (unit=luda(nf),file=daf(nf),status='old',
     1        access='direct',form='unformatted',recl=idatrecl,err=9003)
      endif
#elif defined(__alpha)
      open (unit=luda(nf),file=daf(nf),status='old',
     1     access='direct',form='unformatted',
     $     recl=idatrecl/IDRS_BYTES_PER_WORD,err=9003)
#elif defined(gfortran)
      open (unit=luda(nf),file=daf(nf),status='old',
     1     access='direct',form='unformatted',
     2     CONVERT='big_endian',recl=idatrecl,err=9003)
#elif !defined(sgi)
      open (unit=luda(nf),file=daf(nf),status='old',
     1     access='direct',form='unformatted',recl=idatrecl,err=9003)
#endif

c
        n_rec(1,nf)=1
        idirty=1
        if (nf.gt.1) then
          n_rec(1,nf)=n_rec(2,nf-1)+1
        endif
        n_rec(2,nf)=n_rec(1,nf)-1+nvdb(nf)
        if (n_rec(2,nf).gt.mxent) go to 9006
        do 20 i=n_rec(1,nf),n_rec(2,nf)
        irec=(i-n_rec(1,nf)+1)*2

        read (ludi(nf),rec=irec,err=9007) n_src(i),n_nam(i),
     1                                   n_tit(i),n_un(i)

        n_lun(i)=ludi(nf)
  20    continue
c                              read first block of data
c     Note: legal to read file opened for extension
        if (istat.eq.IDRS_READ .or. istat.eq.IDRS_EXTEND) then

          if(drstest(drsreadb(nf,1))) go to 9008

          iblno(nf)=1
        endif
      else 
c            it is a new file, save the 'given' data file name
        drsvers(nf)=DRS_VERSION
c

c       Set ludi2(nf)=0 to indicate that there are no second copies of the dictionary
c       file.  But for 64-bit Macintosh OS X:
c       Stash the specified dic file in dif2.  Create a tempoary local file and put it in
c       dif instead.  Thus the user's logical unit number ludi(nf) will point to the
c       temporary local file, and a new logical unit number ludi2(nf) will point to the
c       (possibly remote) file specified by the user.
c       Most of the DRS library will read and write to and from
c       the local file.  (The local file will be in the current directory, whatever that is.
c       There is no checking for whether it really is local or even whether that directory
c       has write permissions.)  This is a substitue for a cache, because (as of June 2011)
c       Macintosh OS X does not cache of networked files, at least not usefully; even
c       mmap doesn't help performance.
        ludi2(nf) = 0
#ifdef mac64
        dif2(nf) = dif(nf)
        call getlun( ludi2(nf) )
        call getfile( dif(nf) )
#endif

#if defined(sgi)
        open (unit=ludi(nf),file=dif(nf),status='new',
     1     access='direct',recl=idicrecl/IDRS_BYTES_PER_WORD,
     $     form='unformatted',
     2     err=9002)
#elif defined(__alpha)
        open (unit=ludi(nf),file=dif(nf),status='new',
     1     access='direct',recl=idicrecl/IDRS_BYTES_PER_WORD,
     $     form='unformatted',
     2     err=9002)
#elif defined(NSL_DRS)
        nsldif(nf)=dif(nf)
        dif(nf)=nsldif(nf)(idirlen+1:icpathln)
        open (unit=ludi(nf),file=dif(nf),status='new',
     1     access='direct',recl=idicrecl,form='unformatted',
     2     err=9002)
#elif defined(gfortran)

#ifdef mac64mmap
        ierr = fmapf(dif(nf))
        if ( ierr.ne.0 ) go to 9023
#endif
        if ( ludi2(nf).gt.0 ) then
c          Two dic files - we'll write to a temporary at ludi, then
c          copy to a permanent at ludi2.  Normally this is for the
c          mac64 case.
           open (unit=ludi(nf),file=dif(nf),status='new',
     1          access='direct',recl=idicrecl,form='unformatted',
     2          err=9022,CONVERT='big_endian')
c          After writing to ludi we'll close it and re-open at recl=1,
c          then copy to ludi2.  This open could be moved there.
           open (unit=ludi2(nf),file=dif2(nf),status='new',
     1          access='direct',recl=1,form='unformatted',
     2          err=9027,CONVERT='big_endian')
        else
c          One dic file, the normal case.
           open (unit=ludi(nf),file=dif(nf),status='new',
     1          access='direct',recl=idicrecl,form='unformatted',
     2          err=9022,CONVERT='big_endian')
        endif

#elif !defined(sgi)
        open (unit=ludi(nf),file=dif(nf),status='new',
     1     access='direct',recl=idicrecl,form='unformatted',
     2     err=9002)
#endif

c
c               include the device and directory if they are not in the
c               data file specifier
c
c$$$        do 30 i=1,80
c$$$        if (daf(nf)(i:i).eq.'/') go to 40
c$$$  30    continue
c$$$        if (getcwd(path).eq.0) then
c$$$          do 35 i=40,1,-1
c$$$          if (path(i:i).gt.' ') then
c$$$            daf(nf)=path(1:i)//'/'//datfil
c$$$            go to 40
c$$$          endif
c$$$  35      continue
c$$$        endif
c$$$  40    continue
c                   open the data file

#if defined(sgi)
        open (unit=luda(nf),file=daf(nf),status='new',
     1     access='direct',recl=idatrecl/IDRS_BYTES_PER_WORD,
     $     form='unformatted',
     2     err=9003)
#elif defined(NSL_DRS)
        if(isnsl) then
           do 260 i=len(daf(nf)),1,-1
              if(daf(nf)(i:i).ne.' ') then
                 idpathln=i
                 go to 270
              endif
 260       continue
 270       continue
           iocreat=1402B
           ifd=nsldrsopen(daf(nf)(1:idpathln),iocreat,666B)
           if(ifd.ne.-1) then
              luda(nf)=ifd
           else
              go to 9003
           endif
        else
           open (unit=luda(nf),file=daf(nf),status='new',
     1          access='direct',recl=idatrecl,form='unformatted',
     2          err=9003)
        endif
#elif defined(__alpha)
        open (unit=luda(nf),file=daf(nf),status='new',
     1     access='direct',recl=idatrecl/IDRS_BYTES_PER_WORD,
     $     form='unformatted',
     2     err=9003)
#elif defined(gfortran)
        open (unit=luda(nf),file=daf(nf),status='new',
     1     access='direct',recl=idatrecl,form='unformatted',
     2     err=9003,CONVERT='big_endian')
#elif !defined(sgi)
        open (unit=luda(nf),file=daf(nf),status='new',
     1     access='direct',recl=idatrecl,form='unformatted',
     2     err=9003)
#endif

c
        nvdb(nf)=0
        mxdat(nf)=0
c                           dump out the file name
c$$$        write (ludi(nf),rec=1) daf(nf),nvdb(nf),mxdat(nf)
        dum=' '
        aslun=writehd(ludi(nf),dum,nvdb(nf),mxdat(nf),
     $       drsvers(nf))
        if(aslun.ne.IDRS_SUCCESS) go to 9000
        n_rec(1,nf)=1
        idirty=1
        n_rec(2,nf)=0
        if (nf.gt.1) then
          n_rec(1,nf)=n_rec(2,nf-1)+1
          n_rec(2,nf)=n_rec(2,nf-1)
        endif
        iblno(nf)=0
        do 100 i=1,ibloclen
        iblock(i,nf)=0
  100   continue
c
      endif
c
      ibdirty(nf)=0

#ifdef NSL_DRS
      isynch(nf)=IDRS_SYNC_OFF
#else
      isynch(nf)=IDRS_SYNC_ON
#endif
      go to 9000
c
c                        error returns
c
 9008 aslun=IDRS_CANNOTREADDATA
      close (unit=lu)
      close (unit=lud)
      nf=nf-1
      go to 9000
 9007 aslun=IDRS_DICTREADERROR
      close (unit=lu)
      close (unit=lud)
      nf=nf-1
      go to 9000
 9006 aslun=IDRS_DICTFULL
      close (unit=lu)
      close (unit=lud)
      nf=nf-1
      go to 9000
 9003 aslun=IDRS_CANNOTOPENDATA
      close (unit=lud)
      nf=nf-1
      go to 9000
c The 902? labels are for debugging convenience; all were formerly 9002.
 9021 continue
      write(6,*)"hit error branch 9021"
 9022 continue
      write(6,*)"hit error branch 9022"
 9023 continue
      write(6,*)"hit error branch 9023"
 9024 continue
      write(6,*)"hit error branch 9024"
 9025 continue
      write(6,*)"hit error branch 9025"
 9026 continue
      write(6,*)"hit error branch 9026"
 9027 continue
      write(6,*)"hit error branch 9027"
 9002 aslun=IDRS_CANNOTOPENDICT
      nf=nf-1
      go to 9000
 9001 aslun=IDRS_TOOMANYFILES
      nf=nf-1
      go to 9000
 9000 continue
      call drsrout('aslun',aslun)
      return
      end

      subroutine getlun( lun )
      integer lun
c     returns a random logical unit number which is not open
      integer minlun, rangelun, i
      real rnd
      logical isopen

      minlun = 1234
      rangelun = 2**15-1 - minlun
      do 10 i = 1, 123456789
         call random_number( rnd )
         lun = minlun + rnd*rangelun
         inquire( unit=lun, opened=isopen )
         if ( .not. isopen ) exit
 10   continue
      return
      end

      subroutine getfile( filename )
      character *(*) filename
c     returns a random filename.  The caller should have allocated space
c     for the argument, a string of length at least 17 characters.
      integer num
      character*7 numstr
      real rnd
      logical isopen, exists

      do 10 i = 1, 123456789
         call random_number( rnd )
         num = 1000000 + 9000000*rnd
c     1,000,000 <= num < 10,000,000, thus it prints as 7 characters
         write (unit=numstr,fmt='(i7)') num
         filename = 'drstmp' // numstr // '.dic'
         inquire( file=filename, exist=exists )
         if ( .not. exists ) exit
 10   continue
      return
      end
