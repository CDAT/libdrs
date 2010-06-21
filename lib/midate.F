ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c midate.F,v 2.3 1995/10/16 18:48:56 drach Exp
c midate.F,v
c Revision 2.3  1995/10/16  18:48:56  drach
c - Add declarations for DEC Alpha
c
c Revision 2.2  1995/03/30  00:51:04  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:20  drach
c Merged Sun, Unicos, SGI, and HP versions.
c
c Revision 2.1  1992/10/06  00:56:50  drach
c Modified date routine for SGI version.
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
      integer function midate(cdate)
c
c     Description:
c     -----------
c     Return ASCII date.
c
c     Arguments:
c     ---------
c     cdate  := (Character*8) date, in the form mm/dd/yy
c     
c     Function Returns:
c     ----------------
c       0: success
c     
c     Author: Bob Drach
c     ------
c     Date: 1/30/90
c     ----
c     Notes:
c     -----
c
c     Glossary:
c     --------
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

#include "drsdef.h"

#if defined(sun) || defined(hpux)
#ifdef __alpha
      integer*4 iarray(3)
      external idate
#else
      integer iarray(3)
#endif
      character*(*) cdate
#endif sun||hpux

#ifdef sgi
      integer imon, iday, iyear
      character*(*) cdate
#endif sgi

#ifdef cray
      integer iarray(3)
      character*8 cdate
#endif cray

      midate=IDRS_SUCCESS

#if defined(sun) || defined(hpux)
#ifdef hpux
      call idate_(iarray)
#else
      call idate(iarray)
#endif
      write(cdate,100) iarray(2),iarray(1),mod(iarray(3),100)
 100  format(i2,"/",i2,"/",i2)
#endif sun||hpux

#ifdef sgi
      call idate(imon,iday,iyear)
      write(cdate,100) imon,iday,iyear
 100  format(i2,"/",i2,"/",i2)
#endif sgi

#ifdef cray
      call date(cdate)
#endif cray

      do 10 i=2,8
         if(cdate(i:i).eq.' ') cdate(i:i)='0'
 10   continue
      return
         
      end
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Routine: 
c     -------
      integer function mitime(ctime)
c
c     Description:
c     -----------
c     Return ASCII time
c     
c     Arguments:
c     ---------
c     ctime  := (Character*8) time, in the form hh:mm:ss
c     
c     Function Returns:
c     ----------------
c       0: success
c     
c     Author: Bob Drach
c     ------
c     Date: 1/30/90
c     ----
c     Notes:
c     -----
c
c     Glossary:
c     --------
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

#include "drsdef.h"
#ifdef __alpha
      integer*4 iarray(3)
      external itime
#else
      integer iarray(3)
#endif

#ifdef cray
      character*8 ctime
#else !cray
      character*(*) ctime
#endif cray

      mitime=IDRS_SUCCESS

#ifdef cray
      call clock(ctime)
#else !cray
#ifdef hpux
      call itime_(iarray)
#else
      call itime(iarray)
#endif
      write(ctime,100) iarray(1),iarray(2),iarray(3)
 100  format(i2,":",i2,":",i2)
#endif cray

      do 10 i=2,8
         if(ctime(i:i).eq.' ') ctime(i:i)='0'
 10   continue
      return
      end




