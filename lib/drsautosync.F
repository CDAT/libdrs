c**********************************************************************
c
c     drsautosync.F,v 2.1 1993/10/21 01:24:34 drach Exp
c     drsautosync.F,v
c Revision 2.1  1993/10/21  01:24:34  drach
c Added to CVS.
c
c     
c     Routine: 
c     -------
      integer function drsautosync(lu,iopt)
      integer lu
c
c     Description:
c     -----------
c     Set autosynchronization flag for a DRS file.
c
c     Arguments:
c     ---------
c     lu    =:  logical unit for the dictionary
c     iopt  =:  IDRS_SYNC_ON (default) causes dictionary and data file to be
c                 synchronized after each write via putdat
c               IDRS_SYNC_OFF causes dictionary file and data file to
c                 be synchronized only after the call to cllun or
c                 a call to drssync
c
c     
c     Function Returns:
c     ----------------
c       0: success
c     IDRS_BADLU
c     IDRS_BADSYNCOPT
c     
c     Author: Bob Drach
c     ------
c
c     Date: 10/19/93
c     ----
c
c     Notes:
c     -----
c     - By default, autosync is set to ON via aslun.
c     - Prior to V2.9, data and dictionary file were automatically synchronized.
c     If autosync is turned off, the file must be closed (via cllun) and/or synchronized
c     via this routine to ensure that all the data has actually been written.

c
c     Glossary:
c     --------
c
c**********************************************************************

#include "drscom.h"
#include "drsdef.h"

      drsautosync = IDRS_SUCCESS

      il= iflun(lu)
      if(il.le.0) then
         drsautosync= IDRS_BADLU
         go to 9000
      endif

      if(iopt.ne.IDRS_SYNC_ON .and. iopt.ne.IDRS_SYNC_OFF) then
         drsautosync= IDRS_BADSYNCOPT
         go to 9000
      endif
      isynch(il)=iopt

 9000 continue

      call drsrout('drsautosync',drsautosync)
      return
      end
