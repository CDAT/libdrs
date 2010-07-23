ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c putvdm.F,v 2.3 1995/07/28 22:55:12 drach Exp
c putvdm.F,v
c Revision 2.3  1995/07/28  22:55:12  drach
c - Modified for IBM RS/6000 version
c
c Revision 2.2  1995/03/30  00:51:12  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:30  drach
c Merged Sun, Unicos, SGI, and HP versions.
c
c Revision 2.1  1992/05/21  00:56:09  drach
c Modified to handle new version of dictlook
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
      integer function putvdim(lu,len,dimvar,i1,i2)
      dimension dimvar(len)

c
c     Description:
c     -----------
c     Write a dimension variable to a DRS file.
c
c     Arguments:
c     ---------
c     lu        =:  Fortran logical unit number of dictionary file
c     len       =:  length of dimvar
c     dimvar    =:  dimension variable
c     i1         := index (in file variable) of dimvar(1)
c     i2         := index (in file variable) of dimvar(len)
c     
c     Function Returns:
c     ----------------
c       0: success
c     IDRS_NOTMONOTONE: The dimension variable is not monotone, or
c       adding to an existing variable does not preserve monotonicity
c     IDRS_BADLEN: len.le.0
c     IDRS_DICTREADERROR: error reading dictionary file
c     IDRS_NODICTFILE: could not find dictionary file
c     Author: Bob Drach
c     ------
c     Date: 10/17/89
c     ----
c     Notes:
c     -----
c     Modified: 9/16/91 (RSD) To ensure that mono2 is always set.
c
c     Glossary:
c     --------
c     mono     = +1 or -1 (dimvar is monotonically increasing or
c            decreasing); 0 if len=1
c     mono2    = +1 or -1 (dimvar(1) is > or < dvle
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
#include "drsdef.h"
#include "drscom.h"

      integer vdb
      real newdfe, newdle
      integer putdat1
      integer setdim
      integer cluvdb
      integer setname
      integer setdate
      integer dictlook

      character*120 source
      character*16 name
      character*80 title
      character*40 units
      character*8 date,time

      putvdim=IDRS_SUCCESS

      il=iflun(lu)
      if(il.le.0) then
         putvdim=IDRS_BADLU
         go to 9000
      endif

c     check for monotonicity

      if(len.eq.1) then
         mono=0
      elseif(len.gt.1) then
         if(dimvar(len).gt.dimvar(1)) then
            do 100 i=2,len
               if(dimvar(i).le.dimvar(i-1)) then
                  putvdim=IDRS_NOTMONOTONE
                  go to 9000
               endif
 100        continue
            mono=1
         elseif(dimvar(len).lt.dimvar(1)) then
            do 200 i=2,len
               if(dimvar(i).ge.dimvar(i-1)) then
                  putvdim=IDRS_NOTMONOTONE
                  go to 9000
               endif
 200        continue
            mono=-1
         else
            putvdim=IDRS_NOTMONOTONE
            go to 9000
         endif
      elseif(len.lt.1) then
         putvdim=IDRS_BADLEN
         go to 9000
      endif

c     clear the uvdb, except for naming info
      
      call mvnbc(usrc,source)
      call mvnbc(unam,name)
      call mvnbc(utitl,title)
      call mvnbc(uun,units)
      call mvnbc(udate,date)
      call mvnbc(utime,time)
      putvdim=cluvdb()

c     See if the dimension variable exists

      putvdim=dictlook(il,0,source,name,title,units,vdb)

c     if found, then we are extending: set the avdb to the dimension var
c       if monotonicity is not set, then the existing dimension variable
c       has one value: dvfe
c     NB! To conform to the action in putdat:
c       for existing variables, set the AVDB
c       for new variables, set the UVDB

      if(putvdim.eq.IDRS_SUCCESS) then
         call redic(lu,vdb-n_rec(1,il)+1,ierr)
         if(ierr.eq.1) then
            putvdim=IDRS_DICTREADERROR
            go to 9000
         elseif(ierr.eq.2) then
            putvdim=IDRS_NODICTFILE
            go to 9000
         endif

c     set mono2 to +/1 iff dimvar(1) >/< dvle

         if(dimvar(1).gt.dvle) then
            mono2=1
         elseif(dimvar(1).lt.dvle)then
            mono2=-1
         else
            putvdim=IDRS_NOTMONOTONE
            go to 9000
         endif

         dvle=dimvar(len)

c     check that resulting dimension variable will be monotone, and
c     set monotonicity if necessary

         if(dimmonoa(1).eq.0) then

c     if extending a single-valued dimension, then it must be the case
c     that either:
c     1) dimvar is multi-valued and has monotonicity equal to it is
c        orientation to dvle, or
c     2) dimvar is single-valued

            if((mono.eq.mono2).or.(mono.eq.0)) then
               dimmonoa(1)=mono2
            else
               putvdim=IDRS_NOTMONOTONE
               go to 9000
            endif
         else

c     if extending a multi-valued dimension, then it must be the case
c     that BOTH:
c     1) the orientation to dvle is the same as the existing monotonicity,
c        AND
c     2) either we are extending with a single point, OR
c        we are extending with a multi-point dimvar which has the same
c        monotonicity as its orientation to dvle.

            if((mono2.ne.dimmonoa(1)) .or.
     $           ((mono.ne.0).and.(mono.ne.mono2))) then
               putvdim=IDRS_NOTMONOTONE
               go to 9000
            endif
         endif

         i1=iadim(1,1)+1
         i2=iadim(1,1)+len

c     we are creating a new dimension variable
      else
         dvfu=dimvar(1)
         dvlu=dimvar(len)
         if(len.gt.1) then
            if(dimvar(len).gt.dimvar(1)) then
               dimmonou(1)=1
            elseif(dimvar(len).lt.dimvar(1)) then
               dimmonou(1)=-1
            else
               putvdim=IDRS_NOTMONOTONE
               go to 9000
            endif
         else
            dimmonou(1)=0
         endif

         i1=1
         i2=len
         
      endif
         
c     write the dimension variable

      newdfe=real(i1)
      newdle=real(i2)

#ifdef cray
         putvdim=setname(source,name,title,units,'R*8')
#else
         putvdim=setname(source,name,title,units,'R*4')
#endif

      putvdim=setdate(date,time)
      putvdim=setdim(1,'internal','internal',len,newdfe,newdle)
      if(putvdim.ne.IDRS_SUCCESS) go to 9000
      putvdim=putdat1(lu,dimvar,.true.)
      if(putvdim.ne.IDRS_SUCCESS) go to 9000
      
 9000 continue
      call drsrout('putvdim',putvdim)
      return
      end
