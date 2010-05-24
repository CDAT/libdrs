c putdat1.F,v 2.3 1995/07/28 22:55:09 drach Exp
c putdat1.F,v
c Revision 2.3  1995/07/28  22:55:09  drach
c - Modified for IBM RS/6000 version
c
c Revision 2.2  1995/03/30  00:51:10  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:27  drach
c Merged Sun, Unicos, SGI, and HP versions.
c
c Revision 2.4  1993/06/16  18:13:43  drach
c - Add check that incremental extension constraint is met.
c - Use user values for dla during second instance stuff, to
c   avoid roundoff problems.
c
c Revision 2.3  1992/12/16  23:12:17  drach
c -Changed equality test to test on small threshold for
c second instance stuff.
c -Allow wrtrans errors to propagate upward.
c
c Revision 2.2  1992/06/26  01:22:02  drach
c set dla to dfu, rather than calculate via dxa;
c otherwise, the following happens on the Y/MP:
c the calculated value of dxa is slightly off ->
c the (new) calculated value of dla is slightly off ->
c dla is truncated to 32 bits in the dictionary, which
c magnifies the error -> on the next iteration, the value
c of dxa (which is calculated using the truncated dla
c from the dictionary) is even worse, etc., until it
c fails the check.
c
c This fix is not an ideal solution; a better solution
c would be to go to vector dimensions solely, or to
c support 64-bit precision in the dictionary, or to
c represent the dimensions as <first value,increment,nPoints>,
c ...
c
c Revision 2.1  1992/05/21  00:59:27  drach
c Rewrote to use dictlook and confnam, and to implement
c the new naming scheme:
c A new variable may be written if its naming strings are
c not equal to any of the naming strings of the current
c dictionary file, where equality is implemented in compnam
c and idenc.
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
      integer function putdat1 (lu,a,skipred)
c***********************************************************************
c     put equally-spaced data according to the user vdb
#include "drscom.h"
#include "drsdef.h"
c     
      integer a(1)
      dimension dxa(mxdim),ia1(mxnin,mxdim),ia2(mxnin,mxdim)
      integer lp
      integer lu
      integer writehd,wrtrans
      logical skipred,drstest
      character*40 ib,dum
c     
c     lu    - is the logical unit for the dictionary
c     a     - is the data to be stored
c     skipred - .true.iff skip the redic call
      
c     putdat1 returns the error return code
c     IDRS_SUCCESS - successful
c     IDRS_BADLU - lu does not exist or cannot be written or read
c     IDRS_BADTYPE - data length or data type illegal,
c     must be 'I', 'R', or 'C'.
c     default (if utype blank) is 'r*4' ('r*8' on cray)
c     IDRS_BADDIM - input dimensions are incorrect
c     IDRS_AMBIGUITYEXISTS - an ambiguity exists
c     IDRS_CANNOTADDDATA - data cannot add to existing data
c     IDRS_DICTFULL - too many dictionary entries
c     IDRS_BADDIMTYPE - dimension types disagree
c     
      logical adjac
      logical idenc,blank,confnam
      integer dictlook
      integer nee,nef,nean,nen(mxnin)
c     
      putdat1=0
      il=iflun(lu)
c     return if lu not found or is not opened for write
      if (il.le.0) go to 9001
      if (it(il)(1:1).eq.'R') go to 9001

c     generate program element characterizations

      if (utype2.eq.' ') then

#ifdef cray
            if(filerepu.eq.IDRS_I4 .or. filerepu.eq.IDRS_I8) then
               utype2='I*8'
            elseif(filerepu.eq.IDRS_ASCII) then
               go to 9002
            else
               utype2='R*8'
            endif
#else !cray
            if(filerepu.eq.IDRS_I4 .or. filerepu.eq.IDRS_I8) then
               utype2='I*4'
            elseif(filerepu.eq.IDRS_ASCII) then
               go to 9002
            else
               utype2='R*4'
            endif
#endif cray

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
         lpty=0
         do 3 i=1,8
            if (utype2(i:i).ge.'0'.and.utype2(i:i).le.'9') lpty=
     1           lpty*10+(ichar(utype2(i:i))-ichar('0'))
 3       continue
         if (lpty.le.0) go to 9002
      else
         go to 9002
      endif

c     Generate requested user element file characterizations

      if(filerepu.eq.IDRS_DEFAULT) then
         if(progrep.eq.IDRS_IEEE_R4 .or. progrep.eq.IDRS_CRAY_R8) then
            filerepu=IDRS_IEEE_R4
         elseif(progrep.eq.IDRS_I4 .or. progrep.eq.IDRS_I8) then
            filerepu=IDRS_I4
         else
            filerepu=IDRS_ASCII
         endif
      endif

      if(filerepu.eq.IDRS_IEEE_R4) then
         utype='R*4'
         luty=4
      elseif(filerepu.eq.IDRS_CRAY_R8) then
         utype='R*8'
         luty=8
      elseif(filerepu.eq.IDRS_I4) then
         utype='I*4'
         luty=4
      elseif(filerepu.eq.IDRS_I8) then
         utype='I*8'
         luty=8
      elseif(filerepu.eq.IDRS_ASCII) then
         utype=utype2
         luty=lpty
      endif
      
c     
      
c$$$c     check given type, and set to 'r*4' if not given.
c$$$      if (utype.eq.' ') then
c$$$         luty=IDRS_BYTES_PER_WORD
c$$$         if(IDRS_MACHINE.eq.IDRS_SUN) then
c$$$            utype='R*4'
c$$$         elseif(IDRS_MACHINE.eq.IDRS_CRAY) then
c$$$            utype='R*8'
c$$$         endif
c$$$      else
c$$$         if (utype(1:1).ne.'I'.and.utype(1:1).ne.'C'.and.
c$$$     1        utype(1:1).ne.'R') go to 9002
c$$$c     get number of bytes per element
c$$$         luty=0
c$$$         do 2 i=1,8
c$$$            if (utype(i:i).ge.'0'.and.utype(i:i).le.'9') luty=
c$$$     1           luty*10+(ichar(utype(i:i))-ichar('0'))
c$$$ 2       continue
c$$$         if (luty.le.0) go to 9002
c$$$      endif
c     
      ndu=0
      neu=1
c     initialize pointers and write indices
      do 6 n=1,mxdim
         ip(n)=n
         do 5 i=1,8
            ieqv(i,n)=1
 5       continue
 6    continue
c     
c     get number of dimensions from user vdb
c     by counting the contiguous non-zero dimensions
      do 30 n=1,mxdim
         
         if (iudim(n).gt.0) then
            ndu=n
            if (dlu(n).ge.xlownull.or.dfu(n).ge.xlownull) go to 9003
            if (iudim(n).eq.1.and.dlu(n).ne.dfu(n)) go to 9003
            if (iudim(n).ne.1.and.dfu(n).eq.dlu(n)) go to 9003
            iuds(n)=neu*luty
            neu=neu*iudim(n)
c     check for similarity of dimension names
            do 20 i=1,ndu-1
               if(idenc(udna(i),udna(n),blank)) go to 9003
 20         continue
c     
         else
            go to 35
         endif
 30   continue
c     
 35   continue
      if (ndu.le.0) go to 9003
      
c     search for a like variable --------------------------------------
      
      nbyt=luty
      iadd=mxdat(il)+1
      nsim=0
      if (nvdb(il).gt.0) then
         n1=n_rec(1,il)
         n2=n_rec(2,il)
c
c     search for naming info in the dictionary. If not found,
c     add a new variable
c     
         if(dictlook(il,0,usrc,unam,utitl,uun,ivdb).eq.
     $        IDRS_LOOKUPFAILED) go to 110
         nsim= ivdb-n1+1
         
c     if naming info is not unique, error
         
         if (ivdb.lt.n2) then
            if(dictlook(il,nsim,usrc,unam,utitl,uun,idum).eq.
     $           IDRS_SUCCESS) go to 9004
         endif

c     read in the avdb if necessary

         if(.not.skipred) then
            call redic(ludi(il),nsim,ier)
            if(ier.ne.0) go to 9001
         endif

c     check that types match

         if(.not.idenc(utype,atype,blank)) go to 9004

c     set filerepa, and check that it equals filerepu
c     filerepa is the program representation for the datafile variable

         if(atype(1:3).eq.'R*4') then
            filerepa=IDRS_IEEE_R4
         elseif(atype(1:3).eq.'I*4') then
            filerepa=IDRS_I4
         elseif(atype(1:3).eq.'R*8') then
            filerepa=IDRS_CRAY_R8
         elseif(atype(1:3).eq.'I*8') then
            filerepa=IDRS_I8
         elseif(atype(1:1).eq.'C') then
            filerepa=IDRS_ASCII
         else
            go to 9002
         endif
         if(filerepa.ne.filerepu) go to 9004

         if (ndu.ne.nda) go to 9004

c     check that dimensions conform

         if(.not.confnam(udna,adna,ndu,ip)) go to 9004

c     check that declared dimension types match

         do 90 i=1,ndu
            if(dimtypeu(ip(i)).ne.dimtypea(i)) then
               putdat1=IDRS_BADDIMTYPE
               go to 9000
            endif
 90      continue
      endif
c----------------------------------------------------------------     
 110  if (nsim.eq.0) then
c     a new variable will be added
c     
         call clavdb
c     copy uvdb to avdb
         do 130 i=1,mxbuf
            abuf(i)=ubuf(i)
 130     continue
c$$$
         filerepa=filerepu
         if(adate.eq.' ') putdat1=midate(adate)
         if(atime.eq.' ') putdat1=mitime(atime)
c$$$
         iaddr=iadd
         dvfe=dvfu
         dvle=dvlu
         do 145 n=1,ndu
            dfa(1,n)=dfu(n)
            dla(1,n)=dlu(n)
            dfa2(n)=dfu2(n)
            dla2(n)=dlu2(n)
            iadim(1,n)=iudim(n)
            ia1(1,n)=1
            ia2(1,n)=iadim(1,n)
            dimtypea(n)=dimtypeu(n)
            dimaddra(n)=dimaddru(n)
            dimmonoa(n)=dimmonou(n)
            iads(n)=iuds(n)
 145     continue
         nina=1
         nda=ndu
         nea=neu
         laty=luty
c     set parameters for writing
         do 150 n=1,ndu
            in2(n)=iudim(n)
            ins(n)=iuds(n)
            io2(n)=iudim(n)
            ios(n)=iuds(n)
 150     continue
c     
         nvdb(il)=nvdb(il)+1
         nsim=nvdb(il)
c     
         if (n_rec(2,nf).ge.mxent) go to 9006
         if (nf.gt.il) then
            do 152 n=nf,il+1,-1
               do 151 i=n_rec(2,n),n_rec(1,n),-1
                  n_src(i+1)=n_src(i)
                  n_nam(i+1)=n_nam(i)
                  n_tit(i+1)=n_tit(i)
                  n_un(i+1)=n_un(i)
                  n_lun(i+1)=n_lun(i)
 151           continue
               n_rec(1,n)=n_rec(1,n)+1
               n_rec(2,n)=n_rec(2,n)+1
 152        continue
         endif
         n_rec(2,il)=n_rec(2,il)+1
         n=n_rec(2,il)
         n_src(n)=asrc
         n_nam(n)=anam
         n_tit(n)=atitl
         n_un(n)=aun
         n_lun(n)=lu
         go to 8000
      endif
c-------------------------------------------------------------------
c
c     add to an existing variable
c     
c     if the identical variable was found, the new data
c     will be added to the existing variable, iff dimensions
c     allow.
c     
c     determine whether data is unique wrt existing data
c     and adds to existing data such that spacing between elements
c     of each dimension remains constant
      adjac=.true.
      nn=0
      nee=luty
      do 155 i=1,mxnin
         nen(i)=1
 155  continue
c     
c     
c     
      do 230 n=1,nda
c     set dxa
         dxa(n)=1.e30
         if (iadim(1,n).gt.1) then
            dxa(n)=(dla(1,n)-dfa(1,n))/(iadim(1,n)-1)
         else if (abs(dfa(nina,n)-dfa(1,n)) .gt.
     $           1.0e-6*abs(dfa(1,n))) then
            dxa(n)=dfa(nina,n)-dfa(1,n)
         else if (iudim(ip(n)).gt.1) then
            dxa(n)=sign((dlu(ip(n))-dfu(ip(n)))/(iudim(ip(n))-1),
     1           dlu(ip(n))-dfa(1,n))
         else if (abs(dfu(ip(n))-dfa(1,n)) .gt.
     $           1.0e-6*abs(dfu(ip(n)))) then
            dxa(n)=(dfu(ip(n))-dfa(1,n))
         endif
c     determine indices of user data relative to stored data
         iu1(n)=int((dfu(ip(n))-dfa(1,n)+0.5*dxa(n))/dxa(n))+1
         iu2(n)=int((dlu(ip(n))-dfa(1,n)+0.5*dxa(n))/dxa(n))+1
         if (abs(dfa(1,n)+(iu1(n)-1)*dxa(n)-dfu(ip(n))).gt.
     1        0.001*abs(dxa(n))) go to 9005
         if (abs(dfa(1,n)+(iu2(n)-1)*dxa(n)-dlu(ip(n))).gt.
     1        0.001*abs(dxa(n))) go to 9005
         do 160 in=1,nina
c     compute size of each array instance
            nen(in)=nen(in)*iadim(in,n)
c     set indices of each array instance
c$$$  modified by rsd, 89/09/26
c$$$  ia1(in,n)=1
            ia1(in,n)=(dfa(in,n)-dfa(1,n))/dxa(n)+1.001
            ia2(in,n)=(dla(in,n)-dfa(1,n))/dxa(n)+1.001
 160     continue
c     set spacing between elements of the array
c     single elements are set to the new size
         if (max(ia2(nina,n),ia2(1,n)).eq.1) iads(n)=iadd-iaddr
c     determine and set direction of index for the dimension
         if (iu2(n).lt.iu1(n)) then  
            in1(n)=iudim(ip(n))
            in2(n)=1
            inn(n)=-1
         else
            in1(n)=1
            in2(n)=iudim(ip(n))
            inn(n)=1
         endif
         
c     are the calculations of iu1 and iu2 correct
         
         if (iudim(ip(n)).ne.iabs(iu2(n)-iu1(n))+1) go to 9003
         
c     if there is more than one element in present dimension
c     spacing between elements must be the same
         
         if (iudim(ip(n)).gt.1.and.nee.ne.iads(n)) go to 9005


c     the new data must be unique wrt stored data
         
         if (min(iu1(n),iu2(n)).gt.ia2(nina,n)) then
c     it is unique
c     the new data must be adjacent to stored data in the
c     array in this dimension
            if (min(iu1(n),iu2(n))-ia2(nina,n).eq.1) then
c     only one dimension can be unique
               if (nn.ne.0) go to 9005
c     if this data is adding to a second instance
c     this dimension must not exceed the first instance
c     index limits
               if (nina.eq.mxnin.and.max(iu1(n),iu2(n)).gt.ia2(1,n))
     1              go to 9005
c     set pointer for this dimension
               nn=n
            else
               go to 9005
            endif
c     if this dimension is not unique then it must be
c     identical to the corresponding previous dimension
c     or it may become a new instance
         else
            if (min(iu1(n),iu2(n)).ne.ia1(nina,n)) go to 9005
            if (max(iu1(n),iu2(n)).gt.ia2(nina,n)) go to 9005
            if (max(iu1(n),iu2(n)).lt.ia2(nina,n)) then
c     it isnt identical so cannot be an adjacent array
               if (nina.eq.mxnin) go to 9005
c     it may become a new instance
               adjac=.false.
            endif
         endif
c     
         nee=nee*iudim(ip(n))
c     
         ins(n)=iuds(ip(n))
         io2(n)=iudim(ip(n))
         ios(n)=iads(n)
c     
 230  continue
c---------------------------------------------------------------
c     Enforce constraint on extending dimensions:
c
c     Calculate the file location of the first element of the block
c     currently being written. If it does not match iadd,
c     then the constraint is violated.
c
c     Note: iu1 and iu2 are FILE indices, and since
c     data is always written with increasing file index, the indices
c     corresponding to the first user element to be written
c     are min(iu1,iu2).
c
c     iblocloc is the location of the next element to be written
c     to the file, calculated using the increments established above.

      iblocloc = iaddr
      do 240 n=1,nda
         iblocloc = iblocloc+(min(iu1(n),iu2(n))-1)*iads(n)
 240  continue
      if(iadd.ne.iblocloc) go to 9005

c---------------------------------------------------------------

      if (nn.eq.0) go to 9003
c     
      if (.not.adjac) then
c     it will become a new instance
         nina=nina+1
         do 250 n=1,nda
c     set parameters for writing
            iadim(nina,n)=iudim(ip(n))
            dfa(nina,n)=dfu(ip(n))
            dla(nina,n)=dlu(ip(n))
            if (inn(n).lt.0) then
               dfa(nina,n)=dlu(ip(n))
               dla(nina,n)=dfu(ip(n))
            endif
 250     continue
      else
c     the array is adjacent so add it
         ia2(nina,nn)=ia2(nina,nn)+iudim(ip(nn))
c$$$         dla(nina,nn)=dla(nina,nn)+iudim(ip(nn))*dxa(nn)
c$$$
         dla(nina,nn)=dlu(ip(nn))
         dla2(nn)=dlu2(ip(nn))
c$$$
         iadim(nina,nn)=iadim(nina,nn)+iudim(ip(nn))
c     
         do 310 in=nina,2,-1
c     find full size of previous instance and this one
            nef=1
            do 260 n=1,nda
               nef=nef*max(ia2(in,n),ia2(in-1,n))
 260        continue
c     
            if (nef.eq.nen(in)+nen(in-1)+neu) then
c     the n-dimensional array is full,
c     we can consolidate instances.
               do 300 n=1,nda
                  if (ia2(in-1,n).lt.ia2(in,n)) then
                     ia2(in-1,n)=ia2(in,n)
                     iadim(in-1,n)=iadim(in-1,n)+iadim(in,n)
c$$$                     dla(in-1,n)=dfa(in-1,n)+(ia2(in-1,n)-1)*dxa(n)
c$$$
                     dla(in-1,n)=dlu(ip(n))
                     dla2(n)=dlu2(ip(n))
c$$$
                  endif
 300           continue
               nina=nina-1
            else
               go to 8000
            endif
 310     continue
      endif
c
c     ---------------------------------------------------------------
c
c     This section is executed for both new and existing variables
c     
 8000 continue
c     order the dimensions, single values last
      if (nda.gt.1) then
         do 8010 n=1,nda
 8010    continue
         do 8020 n=1,nda-1
            do 8021 i=n+1,nda
               if (iads(i).lt.iads(n)) then
                  ib=adna(i)
                  adna(i)=adna(n)
                  adna(n)=ib
                  ib=adun(i)
                  adun(i)=adun(n)
                  adun(n)=ib
                  do 8040 j=1,nina
                     lp=iadim(j,i)
                     iadim(j,i)=iadim(j,n)
                     iadim(j,n)=lp
                     f=dfa(j,i)
                     dfa(j,i)=dfa(j,n)
                     dfa(j,n)=f
                     f=dla(j,i)
                     dla(j,i)=dla(j,n)
                     dla(j,n)=f
 8040             continue
                  lp=iads(i)
                  iads(i)=iads(n)
                  iads(n)=lp
                  lp=dimtypea(i)
                  dimtypea(i)=dimtypea(n)
                  dimtypea(n)=lp
                  lp=dimaddra(i)
                  dimaddra(i)=dimaddra(n)
                  dimaddra(n)=lp
                  lp=dimmonoa(i)
                  dimmonoa(i)=dimmonoa(n)
                  dimmonoa(n)=lp
                  f=dfa2(i)
                  dfa2(i)=dfa2(n)
                  dfa2(n)=f
                  f=dla2(i)
                  dla2(i)=dla2(n)
                  dla2(n)=f
               endif
 8021       continue
 8020    continue
      endif
      nea=0
      do 8060 i=1,nina
         nean=1
         do 8050 n=1,nda
            nean=nean*iadim(i,n)
 8050    continue
         nea=nea+nean
 8060 continue
c     write to the data file.

c$$$      putdat1=wrdat (lu,a)
c$$$      if (ier.ne.0) go to 9001

      putdat1=wrtrans(lu,a)
      if(drstest(putdat1)) go to 9007

c     write or rewrite the dictionary entry
      call wrdic (lu,nsim,ier)
      if (ier.ne.0) go to 9001

c     rewrite the initial block of dictionary
      mxdat(il)=mxdat(il)+neu*luty
c$$$      write (lu,rec=1,err=9001) daf(il),nvdb(il),mxdat(il)
      dum=' '
      putdat1=writehd(lu,dum,nvdb(il),mxdat(il),
     $     drsvers(il))
      if(drstest(putdat1)) go to 9000

      go to 9000
c
 9007 putdat1=IDRS_CANNOTWRITEDATA
      go to 9000
 9006 putdat1=IDRS_DICTFULL
      go to 9000
 9005 putdat1=IDRS_CANNOTADDDATA
      go to 9000
 9004 putdat1=IDRS_AMBIGUITYEXISTS
      go to 9000
 9003 putdat1=IDRS_BADDIM
      go to 9000
 9002 putdat1=IDRS_BADTYPE
      go to 9000
 9001 putdat1=IDRS_BADLU
 9000 continue
      call drsrout('putdat1',putdat1)
      end


