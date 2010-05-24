c**********************************************************************
c prdict.F,v 2.3 1995/07/28 22:55:07 drach Exp
c prdict.F,v
c Revision 2.3  1995/07/28  22:55:07  drach
c - Modified for IBM RS/6000 version
c
c Revision 2.2  1995/03/30  00:51:08  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:24  drach
c Merged Sun, Unicos, SGI, and HP versions.
c
c Revision 2.2  1993/06/16  18:12:21  drach
c Add proper logical unit variable for inqlun.
c
c Revision 2.1  1992/05/22  01:11:15  drach
c Corrected output logical unit
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
      integer function prdict(lup,lu)
c     
c     Description:
c     -----------
c     print all variables in dictionary file similar to UVDB
c     naming information
c     
c     Arguments:
c     ---------
c     lup =:  Fortran logical unit number for print
c     lu  =:  Fortran logical unit number of dictionary file
c     
c     Function Returns:
c     ----------------
c     0: success
c     
c     Author: Bob Drach
c     ------
c     
c     Date: 12/1/89
c     ----
c     
c     Notes:
c     -----
c     - Dictionary file must have been opened with ASLUN
c     - If naming info in UVDB is blank (e.g., after a call to
c     CLUVDB), then all variables will be printed.
c     
c     Glossary:
c     --------
c     
c**********************************************************************
      
#include "drscom.h"
#include "drsdef.h"
      character*120 source, dsource
      character*16 name, dname
      character*80 title, dtitle
      character*40 units, dunits
      character*1024 datfile
      character*8 date, time, type
      integer dtype
      logical drstest
      integer seterr, getname, getdim, getvdim
      
      prdict=IDRS_SUCCESS
      
c     Get header info from the dictionary file
      prdict=inqlun(lu,datfile,nvars,dvers)
      if(drstest(prdict)) go to 9000
      
      write(lup,50) datfile(1:60), datfile(61:135),nvars, dvers
 50   format(1x,'Data file: ',a60,
     $     /1x,a75,
     $     /1x,'Number of variables: ',
     $     i5,', Written by DRS version ',f4.1)
      
c     Get first variable similar to UVDB (suppress IDRS_NOMOREVARS warning)
      ireplevel=curreplevel
      prdict=seterr(ierrun,IDRS_FATAL)
      prdict=inqdict(lu,IDRS_GETFIRSTVAR)
      ierr=seterr(ierrun,ireplevel)
      
      do 1000 ivar=1,nvars
         if(prdict.eq.IDRS_NOMOREVARS) then
            prdict=IDRS_SUCCESS
            go to 9000
         endif
         if(drstest(prdict)) go to 9000
         
         prdict=getname(source,name,title,units,date,time,type,ndim)
         if(drstest(prdict)) go to 9000
         
         write(lup,100) source(1:71),source(72:120),name,title(1:72),
     $        title(73:80),units,date,time,type,ndim
 100     format(1x,'**************************************************',
     $        '*****************',/,
     $        1x,'Source: ',a71/1x,a49/,
     $        1x,'Name: ',a16/,
     $        1x,'Title: ',a72/1x,a8/,
     $        1x,'Units: ',a40,' Date: ',a8,' Time: ',a8/,
     $        1x,'Type: ',a8,', Number of dimensions: ',i5)
         
         do 900 idim=1,ndim
            prdict=getdim(idim, dname, dunits, dtype, idlen,
     $           dfe, dle)
            if(drstest(prdict)) go to 9000
            ireplevel=curreplevel
            
c     turn off error reporting to suppress IDRS_BADLEN error
            
            prdict=seterr(ierrun,IDRS_NOREPORT)
            prdict=getvdim(idim, dsource, dtitle, 0,
     $           dum, iretlen)
            ierr=seterr(ierrun,ireplevel)
            if(prdict.eq.IDRS_BADLEN) prdict=IDRS_SUCCESS
            if(drstest(prdict)) go to 9000
            
            if(dtype.eq.IDRS_EQUALLY_SPACED) then
               write(lup,200) idim,dname,dunits,idlen,dfe,dle
 200           format(3x,'- - - - - - - - - - - - - - - -',
     $              ' - - - - - - - - - -',/,
     $              3x,'Dimension ',i1,' is equally spaced.',/,
     $              3x,' Name: ',a16,',  Units: ',a40/,
     $              3x,' Length: ',i8,/,
     $              3x,' First element: ',
     $              f8.2,',  Last element: ',f8.2)
            else
               write(lup,300) idim,dname,dsource(1:68),dsource(69:120)
     $              ,dtitle(1:69),dtitle(70:80),dunits,idlen,
     $              dfe,dle
 300           format(3x,'- - - - - - - - - - - - - - - -',
     $              ' - - - - - - - - - -',/,
     $              3x,'Dimension ',
     $              i1,' is unequally spaced.',/,
     $              3x,' Name: ',a16/,
     $              3x,' Source: ',a68/3x,a52/,
     $              3x,' Title: ',a69/3x,a11/,
     $              3x,' Units: ',a40/,
     $              3x,' Length: ',i8,/,
     $              3x,' First element: ',
     $              f8.2,',  Last element: ',f8.2)
            endif
            
 900     continue
         ireplevel=curreplevel
         prdict=seterr(ierrun,IDRS_FATAL)
         prdict=inqdict(lu,IDRS_GETNEXTVAR)
         ierr=seterr(ierrun,ireplevel)
 1000 continue
      if(prdict.eq.IDRS_NOMOREVARS) then
         prdict=IDRS_SUCCESS
         go to 9000
      endif
      if(drstest(prdict)) go to 9000
      
 9000 continue
      call drsrout('prdict',prdict)
      
      return
      end
