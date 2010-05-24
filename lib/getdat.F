ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c getdat.F,v 2.3 1995/07/28 22:55:01 drach Exp
c getdat.F,v
c Revision 2.3  1995/07/28  22:55:01  drach
c - Modified for IBM RS/6000 version
c
c Revision 2.2  1995/03/30  00:50:45  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:12:54  drach
c Merged Sun, Unicos, SGI, and HP versions.
c
c Revision 2.2  1992/12/16  23:09:11  drach
c Modified to allow setdim and setvdim to be used interchangeably on
c data retrieval.
c
c Revision 2.1  1992/05/21  01:05:02  drach
c Rewrote to call new version of dictlook,
c and to call confnam to check for dimension conformity.
c
c Revision 2.0  1992/03/07  00:08:14  drach
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
c     Routine: 
c     -------
      integer function getdat(lu,a,isize)
      integer a(isize)
c     
c     Description:
c     -----------
c     get data according to the user vdb
c     
c     Arguments:
c     ---------
c     lu    =:  is the logical unit for the dictionary
c     a      := is the returned data space
c     isize =:  length of a in bytes
c     
c     
c     Function Returns:
c     ----------------
c     0: success
c     IDRS_BADLU
c     IDRS_VDBNOTFOUND
c     IDRS_DICTREADERROR
c     IDRS_NODICTFILE
c     IDRS_BADDIMNAME
c     IDRS_CANNOTREADDATA
c     IDRS_BADLEN
c     
c     Author: Bob Drach
c     ------
c     Date: 10/30/89
c     ----
c     Notes:
c     -----
c     
c     Glossary:
c     --------
c     dlow = dimension variable(idfu) for unequally-spaced vars
c     dhigh= dimension variable(idlu) for unequally-spaced vars
c     
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      
#include "drscom.h"
#include "drsdef.h"
      integer gd1,dictlook,getrange
      logical drstest,confnam
      logical iuset, ieset
      
      il=iflun(lu)
      if(il.le.0) then
         getdat=IDRS_BADLU
         go to 9000
      endif
      
      isavelu=lu

      if (nvdb(il).le.0) then
         getdat=IDRS_VDBNOTFOUND
         go to 9000
      endif
c     find the variable
      
      idict=n_rec(1,il)
      getdat=dictlook(il,0,usrc,unam,utitl,uun,ivdb)
      if(getdat.eq.IDRS_LOOKUPFAILED) getdat=IDRS_VDBNOTFOUND
      if(getdat.ne.IDRS_SUCCESS) go to 9000
      
      call redic (ludi(il),ivdb-idict+1,ierr)
      if(ierr.eq.1) then
         getdat=IDRS_DICTREADERROR
         go to 9000
      elseif(ierr.eq.2) then
         getdat=IDRS_NODICTFILE
         go to 9000
      endif

c     check that dimensions conform

      if(.not.confnam(udna,adna,nda,ip)) then
         getdat=IDRS_BADDIMNAME
         go to 9000
      endif

c     Allow setdim and setvdim to be used interchangeably, by
c     reading ranges from:
c     dfu for uneq-spaced dimensions, if dfu2 is not set;
c     dfu2 for eq-spaced dimensions, if dfu is not set.

      do 50 n=1,nda
         iuset = dfu2(ip(n)).lt.xlownull .or.
     $        dlu2(ip(n)).lt.xlownull
         ieset = dfu(ip(n)).lt.xlownull .or.
     $        dlu(ip(n)).lt.xlownull
         if(dimtypea(n).eq.IDRS_UNEQUALLY_SPACED.and.ieset.and.
     $        .not.iuset) then
            dfu2(ip(n)) = dfu(ip(n))
            dlu2(ip(n)) = dlu(ip(n))
         elseif(dimtypea(n).eq.IDRS_EQUALLY_SPACED.and.iuset.and.
     $           .not.ieset) then
            dfu(ip(n)) = dfu2(ip(n))
            dlu(ip(n)) = dlu2(ip(n))
         endif
 50   continue

c     For unequally-spaced dimensions, translate from user (dfu2,dlu2)
c     to internal (dfu,dlu) dimension values
      
      do 100 n=1,nda
         if(dimtypea(n).eq.IDRS_UNEQUALLY_SPACED) then
            if((dfu2(ip(n)).lt.xlownull).and.
     $           (dlu2(ip(n)).ge.xlownull))
     $           dlu2(ip(n))=dfu2(ip(n))
            if((dlu2(ip(n)).lt.xlownull).and.
     $           (dfu2(ip(n)).ge.xlownull))
     $           dfu2(ip(n))=dlu2(ip(n))
c     if neither limit is set, get the entire range as specified
c     in the avdb: i.e., need not translate
            if(dfu2(ip(n)).ge.xlownull) then
               dfu(ip(n))=dfa(1,n)
               dfu2(ip(n))=dfa2(n)
               dlu(ip(n))=dla(1,n)
               dlu2(ip(n))=dla2(n)
               go to 100
            endif
c     The range is not the default: must translate
c     NB!! dimaddra gets clobbered during the search for dimension
c     variable, so do not use as an argument!
            idaddr=dimaddra(n)
            getdat=getrange(dfu2(ip(n)),dlu2(ip(n)),
     $           idaddr+n_rec(1,il)-1,idfu,idlu,
     $           dlow,dhigh)
            if(drstest(getdat)) go to 9000
            iudim(ip(n))=iabs(idlu-idfu)+1
            dfu(ip(n))=float(idfu)
            dlu(ip(n))=float(idlu)
            dfu2(ip(n))=dlow
            dlu2(ip(n))=dhigh
         endif
 100  continue
      
      getdat=gd1(lu,a,isize)
c
c     Set the dimension types
c     
      do 200 n=1,nda
         dimtypeu(ip(n))=dimtypea(n)
 200  continue

 9000 continue
      call drsrout('getdat',getdat)
      return
      end



