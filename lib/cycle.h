c cycle.h,v 2.1 1995/03/30 00:50:29 drach Exp
c cycle.h,v
c Revision 2.1  1995/03/30  00:50:29  drach
c Added disclaimer
c
c Revision 2.0  1992/03/07  00:10:39  drach
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
c     cycle dimension common block for getcdim and setcdim

      common /drscycle/ cyfe,cyle,reqcyfe,reqcyle,
     $     cycle,actdlen,usecycle

      real cyfe(mxdim),cyle(mxdim),cycle(mxdim),reqcyfe(mxdim),
     $     reqcyle(mxdim)
      integer usecycle, actdlen(mxdim)
      parameter(mxcycleb=6*mxdim+1)

c     cyfe    = array of (actual) first elements of cycle dimension
c     cyle    = array of (actual) last elements of cycle dimension
c     reqcyfe = array of (requested) first elements of cycle dimension
c     reqcyle = array of (requested) last elements of cycle dimension
c     cycle   = array of cycles (or 0.0 for no cycle)
c     actdlen = array of actual dimension lengths most recently returned
c     usecycle= 1 if getslab was called since last cluvdb, 0 if not

      integer icyclebf(mxcycleb)
      equivalence(icyclebf(1),cyfe(1))

      common /drssave2/ icycbsav

      integer icycbsav(mxdepth,mxcycleb)
