c**********************************************************************
c putdic.F,v 2.3 1995/07/28 22:55:10 drach Exp
c putdic.F,v
c Revision 2.3  1995/07/28  22:55:10  drach
c - Modified for IBM RS/6000 version
c
c Revision 2.2  1995/03/30  00:51:11  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:29  drach
c Merged Sun, Unicos, SGI, and HP versions.
c
c Revision 2.2  1992/12/16  23:20:55  drach
c Shortened some lines for Cray compiler (no real changes).
c
c Revision 2.1  1992/10/14  23:17:08  drach
c Completely rewrote to handle renaming dimension variables,
c dimensions, and timestamp info.
c
c Revision 2.0  1992/10/06  01:07:45  drach
c Added to RCS
c
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
      integer function putdic(lu,iopt)
      integer lu,iopt
c
c     Description:
c     -----------
c     Update naming information for a variable.
c
c     Arguments:
c     ---------
c     lu  =:  dictionary file logical unit number
c     iopt=:  IDRS_BLANKS_ARE_NULL (reset blank input strings to current
c             values), or IDRS_BLANKS_ARE_LITERAL (treat blanks as literals)
c
c     Function Returns:
c     ----------------
c       0: success
c     IDRS_BADLU: Bad logical unit number
c     IDRS_DUPLICATEVAR: New naming strings would conflict with
c        an existing variable
c     IDRS_CANNOTWRITEDIC: Cannot write to dictionary file
c     IDRS_VDBNOTFOUND: Variable not found in the dictionary
c     IDRS_BADDIM: The new name of a dimension variable conflicts
c        with another dimension
c     IDRS_DICTREADERROR: Error reading the dictionary file
c     IDRS_NODICTFILE: No dictionary file found
c     IDRS_CANNOTWRITEDIC: Cannot write to dictionary file
c     
c     Author: Bob Drach
c     ------
c
c     Date:
c     ----
c     6/15/92
c
c     Notes:
c     -----
c     This routine should be used as follows (it is only necessary
c     to call setname and/or setdim for information that changes,
c     since the default is to leave the names the same.
c
c     Names of dimension variables must be updated by directly
c     modifying the variable, not via setvdim.
c
c     Datatype, dimension limits and values may
c     not be changed.
c     
c     ierr=cluvdb()
c     ierr=setname(oldsrc,oldnam,oldtitl,oldunits,cdum)
c     ierr=inqdict(lu,IDRS_GETFIRSTVAR)
c     ierr=setname(newsrc,newnam,newtitl,newunits)
c     ierr=setdate(newdate,newtime)
c     ierr=setdim(1,newdnam,newdun,idum,dum,dum)
c     ierr=setdim(2,...)
c     ierr=putdic(lu,IDRS_BLANKS_ARE_NULL)
c
c     
c     Glossary:
c     --------
c
c**********************************************************************

#include "drscom.h"
#include "drsdef.h"

      integer dictlook
      logical idenc

      logical blank

      putdic=0

      il=iflun(lu)
      if(il.le.0) then
         putdic=IDRS_BADLU
         go to 9000
      endif

c     Reset default names

      if(iopt.eq.IDRS_BLANKS_ARE_NULL) then
         if(usrc.eq.' ') usrc=asrc
         if(unam.eq.' ') unam=anam
         if(utitl.eq.' ') utitl=atitl
         if(uun.eq.' ') uun=aun
         if(udate.eq.' ') udate=adate
         if(utime.eq.' ') utime=atime
         do 3 idim=1,nda
            if(udna(idim).eq.' ') udna(idim)=adna(idim)
            if(udun(idim).eq.' ') udun(idim)=adun(idim)
 3       continue
      endif

c     Lookup the variable

      if( dictlook(il,0,asrc,anam,atitl,aun,isavevdb)
     $     .ne.IDRS_SUCCESS) then
         putdic=IDRS_VDBNOTFOUND
         go to 9000
      endif
      nsave=isavevdb-n_rec(1,il)+1

c     If new names conflict with other variables, error.

      if( usrc.ne.asrc .or. unam.ne.anam .or.
     $     utitl.ne.atitl .or. uun.ne.aun) then

         if( dictlook(il,0,usrc,unam,utitl,uun,ivdb)
     $        .eq.IDRS_SUCCESS) then

c     Matched a different variable: cannot rename

            if(ivdb.ne.isavevdb) then
               putdic=IDRS_DUPLICATEVAR
               go to 9000
            else

c     Matched the same variable (e.g., a blank matches anything), keep looking

               if( dictlook(il,ivdb-n_rec(1,il)+1,
     $              usrc,unam,utitl,uun,ivdb2)
     $              .eq.IDRS_SUCCESS) then
                  putdic=IDRS_DUPLICATEVAR
                  go to 9000
               endif
            endif
         endif
      endif

c---  Variable is NOT a dimension variable

      if(adna(1)(1:8).ne.'internal' .or. adun(1)(1:8).ne.'internal'
     $     .or. nda.ne.1) then

c     If names of equally-spaced dimensions have changed, check that
c     they do not conflict with existing dimension names

         do 10 idim=1,nda
            if( dimtypea(idim).eq.IDRS_EQUALLY_SPACED
     $           .and. udna(idim).ne.adna(idim)) then
               do 5 jdim=1,nda
                  if( jdim.eq.idim) go to 5
                  if( idenc(adna(jdim),udna(idim),blank)) then
                     putdic=IDRS_BADDIM
                     go to 9000
                  endif
 5             continue
            elseif( dimtypeu(idim).ne.dimtypea(idim)) then
               putdic=IDRS_BADDIMTYPE
                  go to 9000
            endif
 10      continue
         
c     Update dimensions

         do 20 idim=1,nda
            if( dimtypea(idim).eq.IDRS_EQUALLY_SPACED) then
               adna(idim)=udna(idim)
               adun(idim)=udun(idim)
            endif
 20      continue

c---  Variable is a dimension variable. Find all other variables
c     in the file which reference this dimension variable (have it
c     as a dimension) and check that the new names do not conflict.
c     Dimensions of dimension variables may not be changed.

      else

         if(unam.ne.anam) then
            do 100 ivdb=n_rec(1,il),n_rec(2,il)
               if(ivdb.eq.isavevdb) go to 100
               call redic(lu, ivdb-n_rec(1,il)+1, ierr)
               if(ierr.eq.1) then
                  putdic=IDRS_DICTREADERROR
                  go to 9000
               elseif(ierr.eq.2) then
                  putdic=IDRS_NODICTFILE
                  go to 9000
               endif

c     Does this variable have a dimension which is the same as the
c     dimension variable being changed? 

               jdim=-1
               do 40 idim=1,nda
                  if( dimaddra(idim).eq.nsave) then
                     jdim=idim
                     go to 60
                  endif
 40            continue
               go to 100
               
c     Does the name conflict with other dimension names?

 60            continue
               do 80 idim=1,nda
                  if( idim.eq.jdim) go to 80
                  if( idenc(adna(idim),unam,blank)) then
                     putdic=IDRS_BADDIM
                     go to 9000
                  endif
 80            continue
 100        continue
         endif

c     Restore AVDB
         
         call redic(lu, nsave, ierr)
         if(ierr.eq.1) then
            putdic=IDRS_DICTREADERROR
            go to 9000
         elseif(ierr.eq.2) then
            putdic=IDRS_NODICTFILE
            go to 9000
         endif

      endif

c     Update names

      asrc=usrc
      anam=unam
      atitl=utitl
      aun=uun
      adate=udate
      atime=utime

c     Update catalog
      
      n_src(isavevdb)=asrc
      n_nam(isavevdb)=anam
      n_tit(isavevdb)=atitl
      n_un(isavevdb)=aun

c     Write the new dictionary entry

      call wrdic(lu,nsave,ier)
      if(ier.eq.2) then
         putdic=IDRS_BADLU
      elseif(ier.eq.1) then
         putdic=IDRS_CANNOTWRITEDIC
      endif

 9000 continue
      call drsrout('putdic',putdic)
      end
