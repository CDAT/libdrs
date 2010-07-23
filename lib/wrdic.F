c wrdic.F,v 2.3 1995/07/28 22:55:20 drach Exp
c wrdic.F,v
c Revision 2.3  1995/07/28  22:55:20  drach
c - Modified for IBM RS/6000 version
c
c Revision 2.2  1995/03/30  00:51:27  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:51  drach
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
      subroutine wrdic (lu,irec,ierr)

c***********************************************************************
c
c         write the avdb to the dictionary file pointed to by lu
c
c         lu      is the dictionary logical unit.
c         irec    is the dictionary entry number
c         ierr    is the error return
c                  0 = successful 
c                  1 = error writing the dictionary file
c                  2 = l.u. wrong or open for readonly
c
      integer lu
#include "drscom.h"
#include "drsdef.h"

#ifdef cray
      integer i8toi4,c8tof4
      logical drstest
#endif

c
      ierr=0
c
      il=iflun(lu)
      if (il.le.0.or.it(il)(1:1).eq.'R') go to 9002
      if (irec.gt.nvdb(il).or.irec.le.0) go to 9002

#ifdef cray

      write (lu,rec=irec*2,err=9001) asrc,anam,atitl,aun,adate,atime,
     1                             atype,adna,adun

      iptr=1
      ilen=4+mxnin*mxdim
      if(drstest(i8toi4(nina,idicbuf(1),ilen,IDRS_LEFTHALFWORD)))
     $     go to 9001

      iptr=iptr+ilen
      if(mod(iptr,2).eq.1) then
         ihalfword=IDRS_LEFTHALFWORD
      else
         ihalfword=IDRS_RIGHTHALFWORD
      endif
      ilen=2*mxnin*mxdim
      if(drstest(c8tof4(dfa,idicbuf((iptr-1)/2+1),ilen,ihalfword)))
     $     go to 9001

      iptr=iptr+ilen
      if(mod(iptr,2).eq.1) then
         ihalfword=IDRS_LEFTHALFWORD
      else
         ihalfword=IDRS_RIGHTHALFWORD
      endif
      ilen=1+4*mxdim

      if(drstest(i8toi4(iads,idicbuf((iptr-1)/2+1),ilen,ihalfword)))
     $     go to 9001

      iptr=iptr+ilen
      if(mod(iptr,2).eq.1) then
         ihalfword=IDRS_LEFTHALFWORD
      else
         ihalfword=IDRS_RIGHTHALFWORD
      endif
      ilen=2+2*mxdim
      if(drstest(c8tof4(dvfe,idicbuf((iptr-1)/2+1),ilen,ihalfword)))
     $     go to 9001

      write(lu,rec=irec*2+1,err=9001)(idicbuf(i),i=1,mxiabuf)
#else
      write (lu,rec=irec*2,err=9001) asrc,anam,atitl,aun,adate,atime,
     1                             atype,adna,adun
      write (lu,rec=irec*2+1,err=9001) nina,nda,nea,laty,iadim,dfa,dla,
     1                             iads,iaddr,
     $     dimtypea,dimaddra,dimmonoa,dvfe,dvle,dfa2,dla2
#ifdef ibm
      call flush_(lu)
#endif
#endif

      go to 9000
c                     error return
 9002 ierr=ierr+1
 9001 ierr=ierr+1
 9000 return
      end

