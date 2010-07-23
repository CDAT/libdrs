ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c readhd.F,v 2.2 1995/03/30 00:51:14 drach Exp
c readhd.F,v
c Revision 2.2  1995/03/30  00:51:14  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:34  drach
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
      integer function readhd(lu,dfname,numvdbs,idatalen,
     $     version)
      character*40 dfname

c
c     Description:
c     -----------
c     Read the dictionary header record.
c
c     Arguments:
c     ---------
c     lu      =:  Fortran logical unit number of dictionary file
c     dfname      := data file name (c*40)
c     numvdbs     := number of dictionary entries in the file
c     idatalen    := byte length of the data file
c     version     := file version
c
c     
c     Function Returns:
c     ----------------
c       IDRS_SUCCESS: success
c     IDRS_NEWFILEFORMAT: The code is older than the file format
c     IDRS_VERSION1FILE: No version in header: assume version 1
c     IDRS_CANNOTREADHEADER: Cannot read dictionary file header
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
	integer i4toi8,f4toc8
        logical drstest
#endif


      readhd=IDRS_SUCCESS


#ifdef cray
      read(lu,rec=1,err=200)(idicbuf(i),i=1,idicrecw)
      call strmov(idicbuf,1,40,dfname,1)
      readhd=i4toi8(idicbuf(6),numvdbs,1,IDRS_LEFTHALFWORD)
      if(drstest(readhd)) go to 9000
      readhd=i4toi8(idicbuf(6),idatalen,1,IDRS_RIGHTHALFWORD)
      if(drstest(readhd)) go to 9000
      call strmov(idicbuf(7),1,8,drstag,1)
      readhd=f4toc8(idicbuf(8),version,1,IDRS_LEFTHALFWORD)
#else
      read(lu,rec=1,err=100) dfname,numvdbs,idatalen,drstag,
     $     version
#endif
      if(drstag.ne.'DRS DICT') then
         readhd=IDRS_VERSION1FILE
         version=1.0
         go to 9000
      elseif(abs(100.0*version - aint(100.0*version)).gt.1.0) then
         readhd=IDRS_VERSION1FILE
         version=1.0
         go to 9000
      elseif(version.lt.2.0 .or. version.gt.DRS_MAXVERSION) then
         readhd=IDRS_VERSION1FILE
         version=1.0
         go to 9000
      elseif(version.gt.DRS_VERSION) then
         readhd=IDRS_NEWFILEFORMAT
         go to 9000
      endif
      go to 9000

 100  continue
c     see if we have a version 1 drs file
      read(lu,rec=1,err=200) dfname,numvdbs,idatalen
      readhd=IDRS_VERSION1FILE
      version=1.0
      go to 9000

 200  readhd=IDRS_CANNOTREADHEADER

 9000 continue
      call drsrout('readhd',readhd)
      return
      end


