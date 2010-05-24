ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c setvdm.F,v 2.2 1995/03/30 00:51:25 drach Exp
c setvdm.F,v
c Revision 2.2  1995/03/30  00:51:25  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:48  drach
c Merged Sun, Unicos, SGI, and HP versions.
c
c Revision 2.0  1992/03/07  00:08:14  drach
c Entered into RCS
c
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
c     Routine: 
c     -------
      integer function setvdim(n,dso,dna,dti,dun,df,dl)
      character*(*) dso,dna,dti,dun
c     
c     Description:
c     -----------
c     put unequally-spaced dimension description into user vdb
c     
c     Arguments:
c     ---------
c     n        =:  dimension to be stored
c     dso      =:  dimension source (c*120)
c     dna      =:  dimension name <= 16 characters
c     dti      =:  dimension title (c*80)
c     dun      =:  dimension units <= 40 characters
c     df       =:  position of first element
c     dl       =:  position of the last element
c     
c     Function Returns:
c     ----------------
c     IDRS_SUCCESS: success
c     IDRS_BADDIM: Bad dimension number
c     
c     Author: Bob Drach
c     ------
c     Date: 10/25/89
c     ----
c     Notes:
c     -----
c     
c     Glossary:
c     --------
c     
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     
#include "drscom.h"
#include "drsdef.h"
c     
      setvdim=IDRS_SUCCESS
      if (n.gt.mxdim.or.n.le.0) then
         setvdim=IDRS_BADDIM
         go to 9000
      endif
      dimtypeu(n)=IDRS_UNEQUALLY_SPACED
      ndu=max(n,ndu)
      
      call mvnbc (dna,udna(n))
      call mvnbc (dun,udun(n))
      call mvnbc(dso,udso(n))
      call mvnbc(dti,udti(n))
      
      if(df.gt.xlownull) then
         dfu2(n)=xnull
      else
         dfu2(n)=df
      endif
      if(dl.gt.xlownull) then
         dlu2(n)=xnull
      else
         dlu2(n)=dl
      endif
      
 9000 continue
      call drsrout('setvdim',setvdim)
      end
