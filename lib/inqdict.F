ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c inqdict.F,v 2.2 1995/03/30 00:51:02 drach Exp
c inqdict.F,v
c Revision 2.2  1995/03/30  00:51:02  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:17  drach
c Merged Sun, Unicos, SGI, and HP versions.
c
c Revision 2.2  1993/01/05  02:05:43  drach
c Added code to set utype and utype2, to support getname and getpelem.
c
c Revision 2.1  1992/05/21  01:07:51  drach
c Rewrote to handle the new naming scheme:
c - calls dictlook for lookup, rather than idenc directly;
c - since the notion of similarity has been abandoned,
c   inqdict no longer returns IDRS_INEXACTMATCH
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
      integer function inqdict(lu,oper)
c     
c     Description:
c     -----------
c     Get naming information on all variables with naming information
c     similar to that specified in the UVDB.
c     
c     Arguments:
c     ---------
c     lu      =:  dictionary file logical unit
c     oper    =:  IDRS_GETFIRSTVAR or IDRS_GETNEXTVAR
c     
c     Function Returns:
c     ----------------
c     0: success
c     IDRS_BADLU: Bad logical unit number
c     IDRS_BADOPER: Bad operation flag.
c     IDRS_NOMOREVARS: No more variables (warning)
c     IDRS_DICTREADERROR: Error reading dictionary file
c     IDRS_NODICTFILE: No dictionary file found
c     
c     Author: Bob Drach
c     ------
c     Date: 11/28/89
c     ----
c     Notes:
c     -----
c     - The dictionary file must have been opened with ASLUN.
c     - This routine should first be called with IDRS_GETFIRSTVAR,
c     then subsequently with IDRS_GETNEXTVAR. After each successful
c     return, the UVDB contains all information on the variable,
c     which can be retrieved with GETNAME, GETDIM, and GETVDIM.
c     - If CLUVDB is called immediately before this routine,
c     all variables will be returned.
c     - If no more variables are found, the UVDB naming information
c     is set to null values (blanks)
c     
c     Glossary:
c     --------
c     
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      
#include "drscom.h"
#include "drsdef.h"
      character*120 cursource
      character*16 curname
      character*80 curtitle
      character*40 curunits
      integer oper, currecord, curlu, dictlook
      
      save currecord, cursource, curname, curtitle, curunits, curlu
      
      inqdict=IDRS_SUCCESS
      il=iflun(lu)
      if(il.le.0) then
         inqdict=IDRS_BADLU
         go to 9000
      endif
      
c     if getting first var, save user-specified naming info, and set 
c     current record.
      
      if(oper.eq.IDRS_GETFIRSTVAR) then
         currecord=1
         cursource=usrc
         curname=unam
         curtitle=utitl
         curunits=uun
         curlu=lu
c     save lu for use with getvdim
         isavelu=lu
      elseif(oper.eq.IDRS_GETNEXTVAR) then
         if(lu.ne.curlu) then
            inqdict=IDRS_BADLU
            go to 9000
         endif
      else
         inqdict=IDRS_BADOPER
         go to 9000
      endif
      
      if(currecord.gt.nvdb(il)) then
         inqdict=IDRS_NOMOREVARS
         usrc=' '
         unam=' '
         utitl=' '
         uun=' '
         go to 9000
      endif
      
c     lookup in dictionary for lu, starting with currecord
c     increment currecord to the 1-origin, next index to
c     search
      
      n1=n_rec(1,il)
      inqdict=dictlook(il,currecord-1,cursource,curname,
     $     curtitle,curunits,ivdb)
      currecord=ivdb-n1+2
      if(inqdict.eq.IDRS_SUCCESS) go to 200
      
c     No more variables found.
      
      inqdict=IDRS_NOMOREVARS
      usrc=' '
      unam=' '
      utitl=' '
      uun=' '
      go to 9000
      
c     A variable was found: read the avdb, and copy to uvdb
      
 200  continue
      
      call redic(ludi(il),ivdb-n1+1,ierr)
      if(ierr.eq.1) then
         inqdict=IDRS_DICTREADERROR
         go to 9000
      elseif(ierr.eq.2) then
         inqdict=IDRS_NODICTFILE
         go to 9000
      endif
      
c     no transposition of dimensions

      do 300 i=1,mxbuf
         ubuf(i)=abuf(i)
 300  continue
      ndu=nda
      do 350 i=1,ndu
         ip(i)=i
 350  continue
      do 400 i=1,mxdim
         dimtypeu(i)=dimtypea(i)
         iudim(i)=iadim(1,i)
         dfu(i)=dfa(1,i)
         dlu(i)=dla(1,i)
         dfu2(i)=dfa2(i)
         dlu2(i)=dla2(i)
 400  continue
      
c     set element file representation

      if(atype(1:1).eq.'R') then
         if(laty.eq.4) then
            filerepa=IDRS_IEEE_R4
         elseif(laty.eq.8) then
            filerepa=IDRS_CRAY_R8
         else
            inqdict=IDRS_BADTYPE
            go to 9000
         endif
      elseif(atype(1:1).eq.'I') then
         if(laty.eq.4) then
            filerepa=IDRS_I4
         elseif(laty.eq.8) then
            filerepa=IDRS_I8
         else
            inqdict=IDRS_BADTYPE
            go to 9000
         endif
      elseif(atype(1:1).eq.'C') then
         filerepa=IDRS_ASCII
      else
         inqdict=IDRS_BADTYPE
         go to 9000
      endif

c     set program element representation

      if (utype2.eq.' ') then

#ifdef cray
            if(filerepa.eq.IDRS_I4 .or. filerepa.eq.IDRS_I8) then
               utype2='I*8'
            elseif(filerepa.eq.IDRS_ASCII) then
               utype2=atype
            else
               utype2='R*8'
            endif
#else !cray
            if(filerepa.eq.IDRS_I4 .or. filerepa.eq.IDRS_I8) then
               utype2='I*4'
            elseif(filerepa.eq.IDRS_ASCII) then
               utype2=atype
            else
               utype2='R*4'
            endif
#endif cray

      endif

 9000 continue
      call drsrout('inqdict',inqdict)
      return
      end
