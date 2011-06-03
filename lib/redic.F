c redic.F,v 2.3 1995/07/28 22:55:14 drach Exp
c redic.F,v
c Revision 2.3  1995/07/28  22:55:14  drach
c - Modified for IBM RS/6000 version
c
c Revision 2.2  1995/03/30  00:51:17  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:37  drach
c Merged Sun, Unicos, SGI, and HP versions.
c
c Revision 2.1  1992/10/14  23:18:26  drach
c Retrieve adna (dimension names) and adun (dimension units)
c from names and units, resp. of the dimension variable,
c when unequally-spaced.
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
      subroutine redic (lu,irec,ierr)

c***********************************************************************
c
c         read the avdb from the dictionary file pointed to by lu
c
c         lu      is the dictionary logical unit.
c         irec    is the dictionary entry number
c         ierr    is the error return
c                  0 = successful 
c                  1 = error reading the dictionary file
c                  2 = file does not exist
c         ierr also is used for input - if ierr<0 that means
c                  lu is nonstandard; use -err for computing il if needed
c
      integer lu
      integer lustd
#include "drscom.h"
#include "drsdef.h"

#ifdef cray
	integer i4toi8,f4toc8
        logical drstest
#endif

c
      if ( ierr.lt.0 ) then
         lustd = -ierr
      else
         lustd = lu
      endif

      ierr=0
      il=iflun(lustd)
      if (il.le.0) go to 9002
      if (irec.gt.nvdb(il).or.irec.le.0) go to 9002

#ifdef cray

      read (lu,rec=irec*2,err=9001) abuf
      read(lu,rec=irec*2+1,err=9001)(idicbuf(i),i=1,mxiabuf)

      iptr=1
      ilen=4+mxnin*mxdim
      if(drstest(i4toi8(idicbuf(1),nina,ilen,IDRS_LEFTHALFWORD)))
     $     go to 9001

      iptr=iptr+ilen
      if(mod(iptr,2).eq.1) then
         ihalfword=IDRS_LEFTHALFWORD
      else
         ihalfword=IDRS_RIGHTHALFWORD
      endif
      ilen=2*mxnin*mxdim
      if(drstest(f4toc8(idicbuf((iptr-1)/2+1),dfa,ilen,ihalfword)))
     $     go to 9001

      iptr=iptr+ilen
      if(mod(iptr,2).eq.1) then
         ihalfword=IDRS_LEFTHALFWORD
      else
         ihalfword=IDRS_RIGHTHALFWORD
      endif
      ilen=1+4*mxdim
      if(drstest(i4toi8(idicbuf((iptr-1)/2+1),iads,ilen,ihalfword)))
     $     go to 9001

      iptr=iptr+ilen
      if(mod(iptr,2).eq.1) then
         ihalfword=IDRS_LEFTHALFWORD
      else
         ihalfword=IDRS_RIGHTHALFWORD
      endif
      ilen=2+2*mxdim
      if(drstest(f4toc8(idicbuf((iptr-1)/2+1),dvfe,ilen,ihalfword)))
     $     go to 9001

#else
      read (lu,rec=irec*2,err=9001) abuf
      read (lu,rec=irec*2+1,err=9001) iabuf
#endif

c     version 1.0 files must have equally-spaced dimensions

      if(drsvers(il).lt.2.0) then
         do 200 i=1,nda
            dimtypea(i)=IDRS_EQUALLY_SPACED
            dimaddra(i)=-1
            dimmonoa(i)=0
            dfa2(i)=xnull
            dla2(i)=xnull
 200     continue
         dvfe=xnull
         dvle=xnull
      endif

c     obtain names of unequally-spaced dimensions from the naming fields
c     of the dimension variable. Note: the catalog has already been read
c     in aslun, so all names and units are present. 

      do 300 i=1,nda
         if( dimtypea(i).eq.IDRS_UNEQUALLY_SPACED ) then
            idimind = n_rec(1,il)+dimaddra(i)-1
            adna(i) = n_nam(idimind)
            adun(i) = n_un(idimind)
         endif
 300  continue

      go to 9000
c                     error return
 9002 ierr=ierr+1
 9001 ierr=ierr+1
 9000 return
      end

