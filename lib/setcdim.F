c**********************************************************************
c setcdim.F,v 2.3 1995/07/28 22:55:17 drach Exp
c setcdim.F,v
c Revision 2.3  1995/07/28  22:55:17  drach
c - Modified for IBM RS/6000 version
c
c Revision 2.2  1995/03/30  00:51:19  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:40  drach
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
      integer function setcdim(rank,ufe,ule,requfe,requle,
     $     cyc,adlen,usecyc)
      integer usecyc, rank, adlen(rank)
      real ufe(rank),ule(rank),cyc(rank),requfe(rank),
     $     requle(rank)
c
c     Description:
c     -----------
c     Set cycle dimension info. A cycle dimension is a dimension which
c     the user has specified as cyclical (e.g., longitude), via
c     a nonzero 'cycle' argument to getslab.
c
c     Arguments:
c     ---------
c     rank     =:  length of ufe,ule,cyc
c     ufe      =:  array of (actual) first elements of cycle dimensions.
c     ule      =:  array of (actual) last elements of cycle dimensions.
c     requfe   =:  array of (requested) first elements of cycle dimension
c     requle   =:  array of (requested) last elements of cycle dimension
c     cyc      =:  array of dimension cycles, or 0.0 if no cycle.
c     adlen    =:  array of lengths of dimensions
c     usecyc   =:  flag that getslab has been called since most
c                    recent cluvdb call. (Note 1)
c     
c     Function Returns:
c     ----------------
c       0: success
c     IDRS_BADDIM: rank is not in the range 1..mxdim
c     
c     Author: Bob Drach
c     ------
c
c     Date:
c     ----
c     6/14/90
c
c     Notes:
c     -----
c
c     Glossary:
c     --------
c
c**********************************************************************

#include "drscom.h"
#include "drsdef.h"
#include "cycle.h"

      setcdim=IDRS_SUCCESS
      if(rank.lt.1 .or. rank.gt.mxdim) then
         setcdim=IDRS_BADDIM
         go to 9000
      endif

      do 100 i=1,rank
         cyfe(i)=ufe(i)
         cyle(i)=ule(i)
         reqcyfe(i)=requfe(i)
         reqcyle(i)=requle(i)
         cycle(i)=cyc(i)
         actdlen(i)=adlen(i)
 100  continue

      usecycle=usecyc

 9000 continue
      call drsrout('setcdim',setcdim)
      end
