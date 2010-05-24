c**********************************************************************
c seterr.F,v 2.2 1995/03/30 00:51:22 drach Exp
c seterr.F,v
c Revision 2.2  1995/03/30  00:51:22  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:44  drach
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
      integer function seterr(ierrlun,reportlevel)
      integer reportlevel
c
c     Description:
c     -----------
c     Set DRS error reporting
c     
c     Arguments:
c     ---------
c     ierrlun  =:  Fortran logical unit number for error reporting
c     reportlevel =:  if = IDRS_NOREPORT then do not report errors
c                        = IDRS_FATAL report only fatal drs errors
c                        = IDRS_WARNING report fatal and warning errors
c     
c     Function Returns:
c     ----------------
c       0: success
c     IDRS_BADLU: Invalid logical unit number
c     
c     Author: Bob Drach
c     ------
c
c     Date: 10/13/89
c     ----
c
c     Notes:
c     -----
c     (1) Error reporting is initially on at level IDRS_WARNING
c        to unit 6 (cf. aslun)
c     
c     Glossary:
c     --------
c
c**********************************************************************
#include "drscom.h"
#include "drsdef.h"

      seterr=IDRS_SUCCESS

      if(ierrlun.lt.0 .or. ierrlun.gt.99) then
         seterr=IDRS_BADLU
         go to 9000
      endif
      ierrun=ierrlun
      if(reportlevel.lt.IDRS_NOREPORT .and.
     $     reportlevel.gt.IDRS_INTERNAL) then
         seterr=IDRS_BADERRLEVEL
         go to 9000
      endif
      curreplevel=reportlevel
 9000 continue
      call drsrout('seterr',seterr)
      return
      end

c**********************************************************************
c
c     Routine: 
c     -------
      integer function getdrser(ierrlun,replevel,ierror)
c
c     Description:
c     -----------
c     Get error parameters
c
c     Arguments:
c     ---------
c     ierrlun  := error reporting unit
c     replevel := error reporting level
c     ierror   := error number most recently reported via drserr
c
c     
c     Function Returns:
c     ----------------
c       0: success
c     
c     Author: Bob Drach
c     ------
c
c     Date: 3/14/90
c     ----
c
c     Notes:
c     -----
c
c     Glossary:
c     --------
c
c**********************************************************************

#include "drscom.h"
      integer replevel

      getdrser=0

      ierrlun=ierrun
      replevel=curreplevel
      ierror=currenterror

      return
      end
