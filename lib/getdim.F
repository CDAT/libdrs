c getdim.F,v 2.2 1995/03/30 00:50:47 drach Exp
c getdim.F,v
c Revision 2.2  1995/03/30  00:50:47  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:12:57  drach
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
      integer function getdim (n,dna,dun,dtype,idim,df,dl)
c***********************************************************************
c     
c     get dimensions from the user vdb
c     
c     
c     n     - dimension to retrieve
c     dna   - dimension name
c     dun   - dimension units
c     dtype - dimension type (integer)
c     idim  - number of elements in the dimension
c     df    - position of first element
c     dl    - position of the last element
      
c     getdim returns error return
c     = IDRS_SUCCESS  no error
c     = IDRS_BADDIM  dimension is outside range 0 < n <= mxdim
c     
#include "drscom.h"
#include "drsdef.h"
c     
      character*(*) dna,dun
      integer dtype
      ierr=0
      getdim=0
      if (n.gt.ndu.or.n.le.0) go to 9001
      dna=udna(n)
      dun=udun(n)
      dtype=dimtypeu(n)
      if(dtype.eq.IDRS_UNEQUALLY_SPACED) then
         df=dfu2(n)
         dl=dlu2(n)
      else
         df=dfu(n)
         dl=dlu(n)
      endif
      idim=iudim(n)
      go to 9000
c     
 9001 ierr=ierr+1
      getdim=IDRS_BADDIM
 9000 continue
      call drsrout('getdim',getdim)
      return
      end
