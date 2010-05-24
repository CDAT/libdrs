c**********************************************************************
c getedim.F,v 2.2 1995/03/30 00:50:48 drach Exp
c getedim.F,v
c Revision 2.2  1995/03/30  00:50:48  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:12:58  drach
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
      integer function getedim (n,dsrc,dna,dti,dun,dtype,idim,df,dl)
      integer n,dtype,idim
      character*(*) dsrc,dna,dti,dun
      real df,dl
c
c     Description:
c     -----------
c     Get dimension info from the vdb (including cyclical dimensions)
c
c     Arguments:
c     ---------
c     n     - dimension to retrieve
c     dsrc  - dimension source
c     dna   - dimension name
c     dti   - dimension title
c     dun   - dimension units
c     dtype - dimension type (integer)
c     idim  - number of elements in the dimension
c     df    - position of first element
c     dl    - position of the last element
c
c     
c     Function Returns:
c     ----------------
c       0: success
c     
c     Author: Bob Drach
c     ------
c
c     Date: 6/15/90
c     ----
c
c     Notes:
c     -----
c     (1) This function supersedes getdim at the user level. It may be
c     used for any type of dimension.
c
c     Glossary:
c     --------
c
c**********************************************************************

#include "drscom.h"
#include "drsdef.h"
#include "cycle.h"

      integer seterr,getcdim

      getedim=IDRS_SUCCESS

      if(n.le.0 .or. n.gt.ndu) then
         getedim=IDRS_BADDIM
         go to 9000
      endif
         
c     turn off bad length error report and read diminfo

      isaverr=ierrun
      isaverep=curreplevel
      ierr=seterr(isaverr,IDRS_NOREPORT)
      getedim=getcdim(n,dsrc,dna,dti,dun,dtype,0,dum,iret)
      ierr=seterr(isaverr,isaverep)
      if(getedim.ne.IDRS_SUCCESS .and. getedim.ne.IDRS_BADLEN)
     $     go to 9000
      getedim=IDRS_SUCCESS

c     if dimension was specified via getslab ...

      if(usecycle.eq.1) then
         idim=actdlen(n)
         df=cyfe(n)
         dl=cyle(n)
      elseif(dtype.eq.IDRS_UNEQUALLY_SPACED) then
         idim=iudim(n)
         df=dfu2(n)
         dl=dlu2(n)
      else
         idim=iudim(n)
         df=dfu(n)
         dl=dlu(n)
      endif
 

 9000 continue
      call drsrout('getedim',getedim)
      end




