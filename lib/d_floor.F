#ifdef cray
c**********************************************************************
c d_floor.F,v 2.3 1995/07/28 22:54:56 drach Exp
c d_floor.F,v
c Revision 2.3  1995/07/28  22:54:56  drach
c - Modified for IBM RS/6000 version
c
c Revision 2.2  1995/03/30  00:50:30  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:12:42  drach
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
      real function d_floor(x)
      real x
c
c     Description:
c     -----------
c     Round x toward negative infinity.
c
c     Arguments:
c     ---------
c
c     
c     Function Returns:
c     ----------------
c       Greatest integral value less than or equal to x.
c     
c     Author: Bob Drach
c     ------
c
c     Date:
c     ----
c     6/24/91
c
c     Notes:
c     -----
c     This routine is intended to run only under CTSS or UNICOS.
c     SunOS provides this function in the Fortran libm.a
c
c     Glossary:
c     --------
c
c**********************************************************************
      d_floor = aint(x)
      if(x.lt.0.0 .and. d_floor.ne.x) d_floor=d_floor-1.0
      return
      end
#endif
#ifdef sgi
      double precision function d_floor(x)
      double precision x
      d_floor = dint(x)
      if(x.lt.0.0 .and. d_floor.ne.x) d_floor=d_floor-1.0
      return
      end
#endif
#ifdef ibm
      double precision function d_floor(x)
      double precision x
      d_floor = dint(x)
      if(x.lt.0.0 .and. d_floor.ne.x) d_floor=d_floor-1.0
      return
      end
#endif
#if defined (__linux) || defined (mac)
      double precision function d_floor(x)
      double precision x
      d_floor = dint(x)
      if(x.lt.0.0 .and. d_floor.ne.x) d_floor=d_floor-1.0
      return
      end
#endif
