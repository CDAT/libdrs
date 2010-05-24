ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c getind.F,v 2.3 1995/10/16 18:48:42 drach Exp
c getind.F,v
c Revision 2.3  1995/10/16  18:48:42  drach
c - Declare restvdbs, savevdbs as integer
c
c Revision 2.2  1995/03/30  00:50:50  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:01  drach
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
      integer function getindex(elem, dimvar, len, tol, index, d1, d2)
      integer dimvar
c     
c     Description:
c     -----------
c     Get the index of real value elem in dimension variable dimvar,
c     within tolerance tol.
c     
c     Arguments:
c     ---------
c     elem     =:  value of element to lookup
c     dimvar   =:  dictionary index of dimension variable
c     to search for elem
c     len      =:  length of dimension variable
c     tol      =:  search tolerance (See Note 1)
c     index     := index of elem in dimension variable
c     d1        := First dimension variable value : (See note 5)
c     d2        := Second dimension variable value : (See note 5)
c     
c     Function Returns:
c     ----------------
c     IDRS_SUCCESS: success (see Note 1)
c     IDRS_INDEXHIGH: index>len
c     IDRS_INDEXLOW: index=0
c     IDRS_INDEXBETWEEN: 1<=index<=len but elem was not found (see Note 4)
c     IDRS_BADLEN: length was <1
c     IDRS_NOMONO: monotonicity =0 and length>1
c     
c     Author: Bob Drach
c     ------
c     Date: 10/16/89
c     Modified: 3/13/91 (BD) added curpath check
c     Modified: 3/21/91 (BD) set d1=buffer(len) when IDRS_INDEXHIGH
c     Modified: 4/3/91 (BD) changed curpath check to idirty check
c     ----
c     Notes:
c     -----
c      Where dv is the actual dimension variable:
c     (1) consider elem = dv(index) if abs(elem-dv(index))<tol
c     (2) this routine expects the avdb to contain the
c     dimension variable info
c     (3) this routine does not affect the avdb or uvdb
c     (4) if monotonicity of dv is >=0, 
c     dv(index)+tol<elem<dv(index+1)-tol
c     if mono<0
c     dv(index)-tol>elem>dv(index+1)+tol
c     (5) if IDRS_INDEXHIGH, then d1=d2=dv(len)
c     if IDRS_INDEXLOW, then d1=d2=dv(1)
c     if IDRS_INDEXBETWEEN, then d1=dv(index), d2=dv(index+1)
c     if IDRS_SUCCESS, then d1=d2=dv(index)
c     Glossary:
c     --------
c     ivdb = dictionary file 'record' number
c     
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      
#include "drscom.h"
#include "drsdef.h"
      
      integer buflen
      pointer (bufptr, buffer(len))
      character*120 cursource
      character*16 curname
      character*80 curtitle
      character*40 curunits

      integer curvdb,curlun
      integer bnsrch, restvdbs, savevdbs

      integer cluvdb,setname,gd1
      logical dvinit
      
      save curvdb,curlun, bufptr, buflen, mono, dvinit

      data curvdb/-1/,curlun/-1/,dvinit/.false./
      data buflen/0/
      
      getindex=IDRS_SUCCESS
      
      lu=n_lun(dimvar)
      il=iflun(lu)
      ivdb=dimvar-n_rec(1,il)+1
      
c     check if elem is the first or last value
      if(abs(elem-dvfe).lt.tol) then
         index=1
         d1=dvfe
         d2=dvfe
         go to 9000
      elseif(abs(elem-dvle).lt.tol) then
         index=len
         d1=dvle
         d2=dvle
         go to 9000
      endif
      
      
c     if desired dimension variable is not in the dimension variable
c     buffer, then read it. If a file has been closed, and replaced
c     in the file data structures by a file with the same lun, then
c     the check of idirty (set in aslun) will still force a vector
c     read. It is impossible for the file to have changed, and the
c     lun to remain the same, without the new file having been opened
c     with aslun, which sets idirty to 1.
      
      if(ivdb.ne.curvdb .or. lu.ne.curlun .or.
     $     idirty.eq.1) then
         if(len.gt.buflen) then
            if (dvinit) then
               getindex=miextenw(len,bufptr)
            else
               dvinit=.true.
               getindex=miallocw(len,bufptr)
            endif
            if(getindex.ne.IDRS_SUCCESS) go to 9000
            buflen=len
         endif
         cursource=asrc
         curname=anam
         curtitle=atitl
         curunits=aun
         curvdb=ivdb
         curlun=lu
c     indicate that the dimension vector was read since
c     the last file open/create
         idirty=0
c     save current vdb info
         getindex=savevdbs(isavbuf)
         getindex=cluvdb()
         getindex=setname(cursource,curname,curtitle,
     $        curunits,' ')
         getindex=gd1(lu, buffer,
     $        IDRS_BYTES_PER_WORD*len)
         mono=dimmonoa(1)
         ierr=restvdbs(isavbuf)
         if(getindex.ne.IDRS_SUCCESS) go to 9000
      endif
      
      getindex=bnsrch(buffer,elem,tol,mono,len,
     $     index,index2)
      if(getindex.eq.IDRS_BINFAILED) then
         if(index2.gt.len) then
            index=index2
            d1=buffer(len)
            d2=buffer(len)
            getindex=IDRS_INDEXHIGH
            go to 9000
         elseif(index.eq.0) then
            getindex=IDRS_INDEXLOW
            d1=buffer(1)
            d2=buffer(1)
            go to 9000
         else
            getindex=IDRS_INDEXBETWEEN
            d1=buffer(index)
            d2=buffer(index+1)
            go to 9000
         endif
      elseif(getindex.eq.IDRS_SUCCESS) then
         d1=buffer(index)
         d2=buffer(index)
      endif
      
 9000 continue
      call drsrout('getindex',getindex)
      return
      end

