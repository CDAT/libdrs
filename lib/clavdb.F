c clavdb.F,v 2.2 1995/03/30 00:50:23 drach Exp
c clavdb.F,v
c Revision 2.2  1995/03/30  00:50:23  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:12:34  drach
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
      subroutine clavdb
c***********************************************************************
c     
#include "drscom.h"
#include "drsdef.h"
c     
      do 5 n=1,mxbuf
         abuf(n)=' '
 5    continue
      laty=0
      nda=0
      nina=0
      nea=0
      filerepa=IDRS_DEFAULT
      do 15 i=1,mxdim
         iads(i)=0
         dfa2(i)=xnull
         dla2(i)=xnull
         do 10 j=1,mxnin
            dfa(j,i)=xnull
            dla(j,i)=xnull
            iadim(j,i)=0
 10      continue
 15   continue
      iaddr=0
      do 20 i=1,mxdim
         dimtypea(i)=IDRS_NOVALUE
         dimmonoa(i)=0
         dimaddra(i)=-1
 20   continue
      dvfe=xnull
      dvle=xnull
      return
      end
