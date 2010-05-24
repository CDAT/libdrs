c**********************************************************************
c bnsrch.F,v 2.3 1995/07/28 22:54:53 drach Exp
c bnsrch.F,v
c Revision 2.3  1995/07/28  22:54:53  drach
c - Modified for IBM RS/6000 version
c
c Revision 2.2  1995/03/30  00:49:09  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:12:32  drach
c Merged Sun, Unicos, SGI, and HP versions.
c
c Revision 2.1  1992/10/06  00:59:28  drach
c *** empty log message ***
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
      integer function bnsrch(var,elem,tol,mono,len,index,index2)
      real var(len)
c     
c     Description:
c     -----------
c     Search for the value 'elem' in the real, monotonic vector
c     'var', within tolerance 'tol'.
c     
c     Arguments:
c     ---------
c     var     =:  Search vector
c     elem    =:  Value to search for.
c     tol     =:  Tolerance defining 'equality'
c     mono    =:  Direction of monotonicity; +/-1
c     len     =:  Length of var
c     index    := Index of elem in var, or of first bracketing
c       value if elem not found
c     index2   := Index of second bracketing value, if elem not found
c     
c     Function Returns:
c     ----------------
c     IDRS_SUCCESS: success
c     IDRS_BINFAILED: search failed (See Note 1)
c     IDRS_BADLEN: length was <1
c     IDRS_NOMONO: monotonicity =0 and length>1
c     
c     Author: Bob Drach
c     ------
c     
c     Date: 10/13/89
c     ----
c     
c     Notes:
c     -----
c     (1) If return value is IDRS_BINFAILED,
c       Case: mono >= 0
c         index=0 indicates elem<var(1)-tol
c         index2=len+1 indicates elem>var(len)+tol
c         otherwise var(index)+tol < elem < var(index2)-tol
c       Case: mono < 0
c         index=0 indicates elem>var(1)+tol
c         index2=len+1 indicates elem<var(len)-tol
c         otherwise var(index)-tol > elem > var(index2)+tol
c     (2) On return, index.le.index2
c     
c     Glossary:
c     --------
c     
c**********************************************************************
#include "drsdef.h"

      bnsrch=IDRS_SUCCESS
      if(len.lt.1) then
         bnsrch=IDRS_BADLEN
         go to 9000
      endif
      if(mono.eq.0 .and. len.gt.1) then
         bnsrch=IDRS_NOMONO
         go to 9000
      endif
      
      i=1
      j=len
      
      if(mono.ge.0) then
 100     continue
         k=(i+j)/2
         if(elem.gt.(var(k)+tol)) then
            i=k+1
         else
            j=k-1
         endif
         if(abs(var(k)-elem).lt.tol) then
            index=k
            index2=k
            go to 9000
         elseif(i.gt.j) then
            index=j
            index2=i
            bnsrch=IDRS_BINFAILED
            go to 9000
         else
            go to 100
         endif
      else
 200     continue
         k=(i+j)/2
         if(elem.lt.(var(k)-tol)) then
            i=k+1
         else
            j=k-1
         endif
         if(abs(var(k)-elem).lt.tol) then
            index=k
            index2=k
            go to 9000
         elseif(i.gt.j) then
            index=j
            index2=i
            bnsrch=IDRS_BINFAILED
            go to 9000
         else
            go to 200
         endif
      endif


 9000 continue
      call drsrout('bnsrch',bnsrch)
      return
      end
