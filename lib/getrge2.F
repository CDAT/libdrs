c**********************************************************************
c getrge2.F,v 2.3 1995/07/28 22:55:05 drach Exp
c getrge2.F,v
c Revision 2.3  1995/07/28  22:55:05  drach
c - Modified for IBM RS/6000 version
c
c Revision 2.2  1995/03/30  00:50:55  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:09  drach
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
      integer function getrge2(lu,idim,elem1,elem2,ind1,ind2,dlow,dhigh)
c
c     Description:
c     -----------
c     Get the range of indices [ind1,ind2], corresponding to
c     the user value range [elem1,elem2], for dimension idim
c     of the current variable.
c
c     Arguments:
c     ---------
c     lu    =: dictionary logical unit
c     idim  =: index of dimension, in the range 1..MXDIM
c     elem1 =: left endpoint of user range
c     elem2 =: right endpoint of user range
c     ind1   := index of leftmost value
c     ind2   := index of rightmost value
c     dlow   := user value corresponding to ind1
c     dhigh  := user value corresponding to ind2
c
c     
c     Function Returns:
c     ----------------
c       0: success
c     IDRS_NORANGE: the range [elem1,elem2] is outside the variable range.
c     
c     Author: Bob Drach
c     ------
c
c     Date: 3/9/90
c     ----
c     Modified 90/6/26 to handle single-point, evenly-spaced dimension
c     Modified 90/10/8 to REALLY handle single-point dimensions. (BD)
c
c     Notes:
c     -----
c     (1) The dimension may be equally-spaced or unequally-spaced.
c     (2) elem1 and elem2 need not correspond exactly to dimension
c         values; the actual user range which DRS will retrieve
c         is [dlow,dhigh]
c     Glossary:
c     --------
c
c**********************************************************************

#include "drscom.h"
#include "drsdef.h"
      integer getrange

      getrge2=IDRS_SUCCESS
      il=iflun(lu)
      if(dimtypea(idim).eq.IDRS_EQUALLY_SPACED) then
c     equally-spaced dimension
         if(iadim(1,idim).gt.1) then
            dxa=(dla(1,idim)-dfa(1,idim))/(iadim(1,idim)-1)
            tol=0.001*abs(dxa)
         else
            dxa=0.0
            tol=1.0e-6
         endif
         xmin=min(dfa(1,idim),dla(1,idim))-tol
         xmax=max(dfa(1,idim),dla(1,idim))+tol
         if((elem1.lt.xmin .and. elem2.lt.xmin).or.
     $        (elem1.gt.xmax .and. elem2.gt.xmax)) then
            getrge2=IDRS_NORANGE
            go to 9000
         endif
         if(iadim(1,idim).gt.1) then
            ind1=int((elem1-dfa(1,idim)+0.5*dxa)/dxa)+1
            ind2=int((elem2-dfa(1,idim)+0.5*dxa)/dxa)+1
            ind1=min0(max0(ind1,1),iadim(1,idim))
            ind2=min0(max0(ind2,1),iadim(1,idim))
         else
            ind1=1
            ind2=1
         endif
         dlow=dfa(1,idim)+(ind1-1)*dxa
         dhigh=dfa(1,idim)+(ind2-1)*dxa
      else
c     unequally-spaced dimension
         idaddr=dimaddra(idim)
         getrge2=getrange(elem1,elem2,
     $        idaddr+n_rec(1,il)-1,ind1,ind2,
     $        dlow,dhigh)
      endif

 9000 continue
      call drsrout('getrge2',getrge2)
      return
      end
