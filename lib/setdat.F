ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c setdat.F,v 2.2 1995/03/30 00:51:20 drach Exp
c setdat.F,v
c Revision 2.2  1995/03/30  00:51:20  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:41  drach
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
      integer function setdate(date,time)
      character*8 date,time
c
c     Description:
c     -----------
c     Set date and time in the user vdb
c
c     Arguments:
c     ---------
c     date     =:  date descriptor (c*8)
c     time     =:  time descriptor (c*8)
c
c     
c     Function Returns:
c     ----------------
c       0: success
c     
c     Author: Bob Drach
c     ------
c     Date: 10/17/89
c     ----
c     Notes:
c     -----
c
c     Glossary:
c     --------
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

#include "drscom.h"
#include "drsdef.h"


      setdate=IDRS_SUCCESS

      call mvnbc (date,udate)
      call mvnbc (time,utime)
      return
      end
