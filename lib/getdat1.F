c getdat1.F,v 2.3 1995/07/28 22:55:02 drach Exp
c getdat1.F,v
c Revision 2.3  1995/07/28  22:55:02  drach
c - Modified for IBM RS/6000 version
c
c Revision 2.2  1995/03/30  00:50:46  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:12:55  drach
c Merged Sun, Unicos, SGI, and HP versions.
c
c Revision 2.2  1992/12/16  23:10:23  drach
c Fixed big to allow rdtrans errors to propagate upward for testing.
c
c Revision 2.1  1992/05/21  01:06:17  drach
c Rewrote to call new version of dictlook, and
c to call confnam to check conformity of dimensions.
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
      integer function gd1 (lu,a,isize)
c***********************************************************************
c                 get equally-spaced data according to the user vdb
c
#include "drscom.h"
#include "drsdef.h"
c
      integer a(1)
      dimension dxa(mxdim)
      integer lu,rdtrans,dictlook
c
c                 lu    - is the logical unit for the dictionary
c                 a     - is the returned data space
c                 isize - is the size of a, in bytes
c     gd1 returns the error return code
c                         0 - successful
c              IDRS_BADLEN - isize too small (uvdb has information)
c              IDRS_BADLU - lu does not exist or is empty or
c                             dictionary read error
c              IDRS_VDBNOTFOUND - the variable cannot be found
c              IDRS_BADDIMNAME - dimension names are incorrect
c              IDRS_CANNOTREADDATA - data could not be read
c                            (uvdb has information)
c              IDRS_BADTYPE - a bad data type was found in the dictionary
c
c     modified 8/22/90 (RSD) to use dictlook for lookup
      logical simlar,confnam
c
      gd1=0
      il=iflun(lu)
c                 return if lu not found 
      if (il.le.0) go to 9002
c
      if (nvdb(il).le.0) go to 9002
c                 find the variable
      n1=n_rec(1,il)
      n2=n_rec(2,il)
c$$$      do 100 n=n1,n2
c$$$      simlar=.true.
c$$$      ilen=idenc(usrc,lenu,n_src(n),lena)
c$$$      if (ilen.lt.lenu) simlar=.false.
c$$$      ilen=idenc(unam,lenu,n_nam(n),lena)
c$$$      if (ilen.lt.lenu) simlar=.false.
c$$$      ilen=idenc(utitl,lenu,n_tit(n),lena)
c$$$      if (ilen.lt.lenu) simlar=.false.
c$$$      ilen=idenc(uun,lenu,n_un(n),lena)
c$$$      if (ilen.lt.lenu) simlar=.false.
c$$$      if (simlar) go to 150
c$$$ 100  continue
c$$$      go to 9003
      simlar=.true.
      gd1=dictlook(il,0,usrc,unam,utitl,uun,n)
      if(gd1.eq.IDRS_LOOKUPFAILED) go to 9003
c
 150  continue
      call redic (ludi(il),n-n1+1,ier)
      if (ier.ne.0) go to 9002

c     set element file representation

      if(atype(1:1).eq.'R') then
         if(laty.eq.4) then
            filerepa=IDRS_IEEE_R4
         elseif(laty.eq.8) then
            filerepa=IDRS_CRAY_R8
         else
            gd1=IDRS_BADTYPE
            go to 9000
         endif
      elseif(atype(1:1).eq.'I') then
         if(laty.eq.4) then
            filerepa=IDRS_I4
         elseif(laty.eq.8) then
            filerepa=IDRS_I8
         else
            gd1=IDRS_BADTYPE
            go to 9000
         endif
      elseif(atype(1:1).eq.'C') then
         filerepa=IDRS_ASCII
      else
         gd1=IDRS_BADTYPE
         go to 9000
      endif
c
      do 160 n=1,mxdim
      ip(n)=0
      do 160 i=1,8
      ieqv(i,n)=1
 160  continue
c                        check dimension names agree and set pointers
c                        to corresponding user dimensions

      if(.not.confnam(udna,adna,nda,ip)) go to 9004
c
c                determine whether data fits the dimensions
c
      neu=1
      iuds(1)=laty
      do 750 n=1,nda
c                check uvdb entries
c                       set both limits to avdb limits if none given
      if (dfu(ip(n)).ge.xlownull.and.dlu(ip(n)).ge.xlownull) then
        dfu(ip(n))=dfa(1,n)
        dlu(ip(n))=dla(1,n)
      else
c                       set both limits equal if only one given
        if (dfu(ip(n)).ge.xlownull) dfu(ip(n))=dlu(ip(n))
        if (dlu(ip(n)).ge.xlownull) dlu(ip(n))=dfu(ip(n))
      endif
      ion(n)=1
      idim=1
      iu1(n)=1
      iu2(n)=1
      dxa(n)=0.0
      if (iadim(1,n).gt.1) then
        dxa(n)=(dla(1,n)-dfa(1,n))/(iadim(1,n)-1)
        iu1(n)=int((dfu(ip(n))-dfa(1,n)+0.5*dxa(n))/dxa(n))+1
        iu2(n)=int((dlu(ip(n))-dfa(1,n)+0.5*dxa(n))/dxa(n))+1
c              put indices within those of existing data
        iu1(n)=min0(max0(iu1(n),1),iadim(1,n))
        iu2(n)=min0(max0(iu2(n),1),iadim(1,n))
c                 compute number of elements expected in the data
c                 and set dimensions and index upper limits
        idim=iabs(iu2(n)-iu1(n))+1
      endif
c              compute the increment between elements to fit the
c              requested dimension sizes, and alter dimension sizes
c
c ion = 1                   if (idim <= iudim)
c     = (idim-1)/(iudim-1)  if ( (iudim-1)*ion+1 = idim)
c  or = (idim-1)/(iudimp-1) for iudimp which minimizes
c                           idim-(iudimp-1)*ion for
c                           2*(idim-1)/(iudim-1) >= ion > (idim-1)/(iudim-1)
c
      if (iudim(ip(n)).le.0) iudim(ip(n))=idim
      iudim(ip(n))=min0(iudim(ip(n)),idim)
      if (idim.gt.iudim(ip(n)).and.iudim(ip(n)).gt.1) then
        ion(n)=(idim-1)/(iudim(ip(n))-1)
        if ((iudim(ip(n))-1)*ion(n).ne.idim-1) then
          kk1=ion(n)+1
          kk2=(2*idim-2)/(iudim(ip(n))-1)
          do 280 kk=kk1,kk2
          iik=(idim-1)/kk+1
          if ((iik-1)*kk.gt.(iudim(ip(n))-1)*ion(n))then
            iudim(ip(n))=iik
            ion(n)=kk
          endif
 280      continue
        endif
      endif
c
c                    set limits of dimensions
      iu2(n)=iu1(n)+isign((iudim(ip(n))-1)*ion(n),iu2(n)-iu1(n))
      neu=neu*iudim(ip(n))
 750  continue
c                      set spacing of values in the array
      if (nda.gt.1) then
        do 760 n=2,nda
 760    iuds(n)=iuds(n-1)*iudim(n-1)
      endif
c
c                       transfer info to the uvdb
c
      do 770 i=1,mxbuf
      ubuf(i)=abuf(i)
 770  continue
c
      filerepu=filerepa
      nbyt=laty
      iadd=iaddr
      ndu=nda
      do 1000 n=1,nda
      udna(ip(n))=adna(n)
      udun(ip(n))=adun(n)
c                 re-compute dimension limits.
      dfu(ip(n))=dfa(1,n)+(iu1(n)-1)*dxa(n)
      dlu(ip(n))=dfa(1,n)+(iu2(n)-1)*dxa(n)
c
c                       now set pointers to go get the data
c
      io1(n)=min0(iu1(n),iu2(n))
      io2(n)=max0(iu1(n),iu2(n))
      ios(n)=iads(n)
      in1(n)=(iu1(n)-io1(n))/ion(n)+1
      in2(n)=(iu2(n)-io1(n))/ion(n)+1
      inn(n)=isign(1,in2(n)-in1(n))
      ins(n)=iuds(ip(n))
 1000 continue
c
      do 1010 n=nda+1,mxdim
      udna(n)=' '
      udun(n)=' '
      dfu(n)=xnull
      dlu(n)=xnull
      iudim(n)=0
 1010 continue

c     set program element representation

      if (utype2.eq.' ') then

#ifdef cray
            if(filerepa.eq.IDRS_I4 .or. filerepa.eq.IDRS_I8) then
               utype2='I*8'
            elseif(filerepa.eq.IDRS_ASCII) then
               utype2=atype
            else
               utype2='R*8'
            endif
#else 
            if(filerepa.eq.IDRS_I4 .or. filerepa.eq.IDRS_I8) then
               utype2='I*4'
            elseif(filerepa.eq.IDRS_ASCII) then
               utype2=atype
            else
               utype2='R*4'
            endif
#endif

      endif

      if(utype2(1:3).eq.'R*8') then
         progrep=IDRS_CRAY_R8
         lpty=8
      elseif(utype2(1:3).eq.'R*4') then
         progrep=IDRS_IEEE_R4
         lpty=4
      elseif(utype2(1:3).eq.'I*8') then
         progrep=IDRS_I8
         lpty=8
      elseif(utype2(1:3).eq.'I*4') then
         progrep=IDRS_I4
         lpty=4
      elseif(utype2(1:1).eq.'C') then
         progrep=IDRS_ASCII
         lpty=laty
      else
         gd1=IDRS_BADTYPE
         go to 9000
      endif

c                      check isize is large enough for the actual data
      if (neu*lpty.gt.isize) go to 9001
c                        read the data
      gd1=rdtrans(lu,a)
      if (gd1.ne.0) go to 9005
c
      go to 9000
c                   error return

 9005 gd1=IDRS_CANNOTREADDATA
      go to 9000
 9004 gd1=IDRS_BADDIMNAME
      go to 9000
 9003 gd1=IDRS_VDBNOTFOUND
      go to 9000
 9002 gd1=IDRS_BADLU
      go to 9000
 9001 gd1=IDRS_BADLEN
      go to 9000
 9000 continue
      call drsrout('gd1',gd1)
      return
      end

