ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c getrge.F,v 2.3 1995/07/28 22:55:03 drach Exp
c getrge.F,v
c Revision 2.3  1995/07/28  22:55:03  drach
c - Modified for IBM RS/6000 version
c
c Revision 2.2  1995/03/30  00:50:54  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:07  drach
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
      integer function getrange(elem1,elem2,dimvar,
     $     ind1,ind2,dlow,dhigh)
      integer dimvar
c     
c     Description:
c     -----------
c     Get an integer range of a dimension variable.
c     
c     Arguments:
c     ---------
c     
c     elem1  =:  first element of range
c     elem2  =:  last element of range
c     dimvar =:  dictionary index of dimension variable
c     ind1    := first index of range (See note 1)
c     ind2    := last index of range (see note 1)
c     dlow    := dimension variable(ind1)
c     dhigh   := dimension variable(ind2)
c     
c     Function Returns:
c     ----------------
c     0: success
c     IDRS_NORANGE: the range [elem1,elem2] is outside the variable range
c     
c     Author: Bob Drach
c     ------
c     Date: 10/26/89
c     ----
c     Notes: 
c     -----
c     (1) On return, the range [elem1,elem2] contains the
c     range [dimension variable(ind1),dimension variable(ind2)],
c     with the monotonicity
c     of dimension variable accounted for
c     (2) elem1 need not be <= elem2
c     (3) this routine returns the vdbs unchanged
c     (4) if ind2 < ind1, then the order of elem1,elem2 is the reverse of
c          the order of the dimension variable
c     Glossary:
c     --------
c     ivdb = dictionary file 'record' number
c     
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      
#include "drscom.h"
#include "drsdef.h"
      integer savevdbs,restvdbs,getindex
      logical ireverse
c     save the avdb, and read the dimvar info into the avdb
      
      getrange=IDRS_SUCCESS
      lu=n_lun(dimvar)
      il=iflun(lu)
      ivdb=dimvar-n_rec(1,il)+1

      getrange=savevdbs(isavbuf)
      call redic(lu,ivdb,ierr)
      if(ierr.eq.1) then
         getrange=IDRS_DICTREADERROR
         go to 9000
      elseif(ierr.eq.2) then
         getrange=IDRS_BADLU
         go to 9000
      endif
c     Set the actual dimension naming strings
      
      udna2=anam
      udun2=aun
      
c     Set the search tolerance
      
      if(iadim(1,1).eq.1) then
         tol=1.0e-6
      else
         tol=min(1.0e-3,abs(dvle-dvfe)/float(iadim(1,1)))
      endif

c     order the search elements so that i1<=i2

      ireverse=(dimmonoa(1).gt.0 .and. elem2.lt.elem1) .or.
     $     (dimmonoa(1).lt.0 .and. elem1.lt.elem2)
      if(dimmonoa(1).ge.0) then
         x1=min(elem1,elem2)
         x2=max(elem1,elem2)
      else
         x1=max(elem1,elem2)
         x2=min(elem1,elem2)
      endif

c     get the indices; error if both indices are out of range

      idimlen=iadim(1,1)
      getrange=getindex(x1,dimvar,idimlen,tol,i1,d1,d2)
      call drstest2(getrange,ierrlev,idum)
      if(ierrlev.eq.IDRS_FATAL
     $     .or. getrange.eq.IDRS_INDEXHIGH) then
         getrange=IDRS_NORANGE
         go to 9000
      endif
c     if search was successful, then index is correct, otherwise one too low
      if(getrange.eq.IDRS_SUCCESS) then
         ind1=i1
         dlow=d1
      else
         ind1=i1+1
         dlow=d2
      endif

      getrange=getindex(x2,dimvar,idimlen,tol,i2,d1,d2)
      call drstest2(getrange,ierrlev,idum)
      if(ierrlev.eq.IDRS_FATAL .or. getrange.eq.IDRS_INDEXLOW) then
         getrange=IDRS_NORANGE
         go to 9000
      endif

c     if search was successful or index is between 1 and len, then
c     index is correct, else reduce by one (i.e.,index is high)
      if(getrange.eq.IDRS_INDEXHIGH) then
         ind2=i2-1
         dhigh=d2
      else
         ind2=i2
         dhigh=d1
      endif

c     reverse the return values if the order of elem1,elem2 differs from
c     the monotonicity of the dimension variable
      
      if(ireverse) then
         itemp=ind1
         ind1=ind2
         ind2=itemp
         dtemp=dlow
         dlow=dhigh
         dhigh=dtemp
      endif

 9000 continue
c     restore vdb info
      ierr=restvdbs(isavbuf)
      call drsrout('getrange',getrange)
      return
      end


