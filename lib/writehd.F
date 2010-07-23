ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c writehd.F,v 2.2 1995/03/30 00:51:28 drach Exp
c writehd.F,v
c Revision 2.2  1995/03/30  00:51:28  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:53  drach
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
      integer function writehd(lu,dfname,numvdbs,idatalen,
     $     version)
      character*40 dfname
      real version

c
c     Description:
c     -----------
c     Write the dictionary header record.
c
c     Arguments:
c     ---------
c     lu      =:  Fortran logical unit number of dictionary file
c     dfname      =: data file name (c*40)
c     numvdbs     =: number of dictionary entries in the file
c     idatalen    =: byte length of the data file
c     version     =: version for this file
c
c     
c     Function Returns:
c     ----------------
c       IDRS_SUCCESS: success
c     IDRS_CANNOTWRITEHEADER: Cannot write dictionary file header
c     
c     Author: Bob Drach
c     ------
c     Date: 10/18/89
c     ----
c     Notes:
c     -----
c
c     Glossary:
c     --------
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
#include "drscom.h"
#include "drsdef.h"
      character*8 drstag

#ifdef cray
      integer c8tof4,i8toi4
      logical drstest
#endif

      data drstag /'DRS DICT'/

      writehd=IDRS_SUCCESS

#ifdef cray
      do 50 i=1,idicrecw
         idicbuf(i)=0
 50   continue
      call strmov(dfname,1,40,idicbuf,1)
      writehd=i8toi4(numvdbs,idicbuf(6),1,IDRS_LEFTHALFWORD)
      if(drstest(writehd)) go to 9000
      writehd=i8toi4(idatalen,idicbuf(6),1,IDRS_RIGHTHALFWORD)
      if(drstest(writehd)) go to 9000      
      call strmov(drstag,1,8,idicbuf(7),1)
      writehd=c8tof4(version,idicbuf(8),1,IDRS_LEFTHALFWORD)
      if(drstest(writehd)) go to 9000 
      write(lu,rec=1,err=200)(idicbuf(i),i=1,idicrecw)
#else
      write(lu,rec=1,err=200) dfname,numvdbs,idatalen,drstag,
     $     version
#endif


      go to 9000

 200  writehd=IDRS_CANNOTWRITEHEADER

 9000 continue
      call drsrout('writehd',writehd)
      return
      end

