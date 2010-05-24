c**********************************************************************
c drserr.F,v 2.4 1995/07/28 22:54:58 drach Exp
c drserr.F,v
c Revision 2.4  1995/07/28  22:54:58  drach
c - Modified for IBM RS/6000 version
c
c Revision 2.3  1995/03/30  00:50:40  drach
c Added disclaimer
c
c Revision 2.2  1993/10/21  01:23:35  drach
c Added sync error message.
c
c Revision 2.1  1993/07/13  01:12:51  drach
c Merged Sun, Unicos, SGI, and HP versions.
c
c Revision 2.2  1992/10/06  00:55:17  drach
c Added text for putdic errors.
c
c Revision 2.1  1992/05/22  01:09:01  drach
c Moved error messages to drsrep from drsdef.h
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
      integer function drserr(ierr)
c
c     Description:
c     -----------
c     Set and report a DRS error
c     
c     Arguments:
c     ---------
c     ierr    =:  DRS error number
c     
c     Function Returns:
c     ----------------
c     ierr
c     
c     Author: Bob Drach
c     ------
c
c     Date: 10/13/89
c     ----
c
c     Notes:
c     -----
c
c     Glossary:
c     --------
c
c**********************************************************************
#include "drsdef.h"
#include "drscom.h"
      integer drsrep
      drserr=ierr
      currenterror=ierr
      ierr2=drsrep(ierr)

 9000 continue
      return
      end
c**********************************************************************

      subroutine drsrout(routine,ierr)
      character*(*) routine

#include "drscom.h"
#include "drsdef.h"
      integer drsrep

      curroutine=routine
      ierr2=drsrep(ierr)

      return
      end
      
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Routine: 
c     -------
      logical function drstest(ierr)
c
c     Description:
c     -----------
c     Test for a fatal DRS error.
c
c     Arguments:
c     ---------
c     ierr =:  DRS error number
c
c     
c     Function Returns:
c     ----------------
c     .true. if the DRS error is fatal.
c     .false. if the DRS error is nonfatal
c     
c     Author: Bob Drach
c     ------
c     Date: 11/7/89
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
      
      call drstest2(ierr,ierrlev,ierrmsg)
      drstest=(ierrlev.eq.IDRS_FATAL)
      
      return
      end

c**********************************************************************

      subroutine drstest2(ierr,ierrlev,ierrmsg)

#include "drsdef.h"

      if(ierr.eq.0) then
         ierrlev=IDRS_SUCCESS
      elseif(ierr.ge.1 .and. ierr.le.999) then
         ierrlev=IDRS_FATAL
         ierrmsg=ierr
      elseif(ierr.ge.1000.and.ierr.le.1999) then
         ierrlev=IDRS_WARNING
         ierrmsg=ierr-1000
      elseif(ierr.ge.2000.and.ierr.le.2999) then
         ierrlev=IDRS_INTERNAL
         ierrmsg=ierr-2000
      else
         ierrlev=IDRS_FATAL
         ierrmsg=IDRS_ERROROUTOFRANGE
      endif
      
      return
      end
c**********************************************************************

      integer function drsrep(ierr)
      
#include "drscom.h"
#include "drsdef.h"


      character*80 drsmsg(IDRS_LASTERROR)

      data drsmsg(IDRS_NOMEMORY)
     $     /'Cannot allocate dynamic memory.'/
      data drsmsg(IDRS_BINFAILED-2000)
     $     /'Data value lookup failed.'/
      data drsmsg(IDRS_BADLEN)
     $/'A vector length was .lt.1 or not large enough for actual data'/
      data drsmsg(IDRS_NOMONO)
     $/'No monotonicity specified for a search vector of length >1'/
      data drsmsg(IDRS_NOCOMPARISON-2000)
     $     /'Variable names do not compare.'/
      data drsmsg(IDRS_VDBNOTFOUND)
     $     /'Variable not found in dictionary.'/
      data drsmsg(IDRS_BADDIM)
     $     /'An input dimension or dimension limit is incorrect.'/
      data drsmsg(IDRS_NOTMONOTONE)
     $     /'Resulting dimension variable will not be monotone.'/
      data drsmsg(IDRS_DICTREADERROR)
     $     /'Error reading dictionary file.'/
      data drsmsg(IDRS_NODICTFILE)
     $     /'Cannot find dictionary file.'/
      data drsmsg(IDRS_BADLU)
     $     /'Bad logical unit number.'/
      data drsmsg(IDRS_BADTYPE)
     $     /'Data length or data type illegal.'/
      data drsmsg(IDRS_AMBIGUITYEXISTS)
     $     /'An ambiguity exists between user vdb and file data.'/
      data drsmsg(IDRS_CANNOTADDDATA)
     $     /'Cannot add to existing data.'/
      data drsmsg(IDRS_DICTFULL)
     $     /'Dictionary is full.'/
      data drsmsg(IDRS_VERSION1FILE-1000)
     $     /'Warning: version 1 file found.'/
      data drsmsg(IDRS_NEWFILEFORMAT-1000)
     $     /'Warning: File format is newer than code.'/
      data drsmsg(IDRS_CANNOTREADHEADER)
     $     /'Cannot read dictionary file header.'/
      data drsmsg(IDRS_CANNOTREADDATA)
     $     /'Cannot read data file.'/
      data drsmsg(IDRS_BADDIMNAME)
     $     /'Bad dimension name.'/
      data drsmsg(IDRS_TOOMANYFILES)
     $     /'Too many files open.'/
      data drsmsg(IDRS_CANNOTOPENDICT)
     $     /'Cannot open dictionary file.'/
      data drsmsg(IDRS_CANNOTOPENDATA)
     $     /'Cannot open data file.'/
      data drsmsg(IDRS_BADSTATUS)
     $     /'Bad file status specified.'/
      data drsmsg(IDRS_BADDIMTYPE)
     $     /'Bad dimension type specified.'/
      data drsmsg(IDRS_INDEXHIGH-2000)
     $     /'Lookup found index larger than vector length.'/
      data drsmsg(IDRS_INDEXLOW-2000)
     $     /'Lookup returned 0 index.'/
      data drsmsg(IDRS_INDEXBETWEEN-2000)
     $/'Element is in vector range, but does not match a value.'/
      data drsmsg(IDRS_NORANGE)
     $     /'A data range does not overlap file data.'/
      data drsmsg(IDRS_SAVEBUFOVERFLOW)
     $     /'Internal save buffer overflow.'/
      data drsmsg(IDRS_BADERRLEVEL)
     $     /'A bad error report level was specified.'/
      data drsmsg(IDRS_ERROROUTOFRANGE)
     $     /'Error number is out of range.'/
      data drsmsg(IDRS_CANNOTWRITEHEADER)
     $     /'Cannot write dictionary file header.'/
      data drsmsg(IDRS_CANNOTWRITEDATA)
     $     /'Cannot write a data file record.'/
      data drsmsg(IDRS_BADCHARLEN)
     $     /'A Cray variable character length is not a multiple of 8.'/
      data drsmsg(IDRS_BADOPER)
     $     /'A bad dictionary file inquiry operator was specified.'/
      data drsmsg(IDRS_NOMOREVARS-1000)
     $     /'Warning: No more matching variables found in search.'/
      data drsmsg(IDRS_DICTALREADYOPEN)
     $     /'Dictionary file is already open on a different unit.'/
      data drsmsg(IDRS_LOOKUPFAILED-2000)
     $     /'Dictionary lookup failed.'/
      data drsmsg(IDRS_DICTWRITEERROR)
     $     /'Error writing to dictionary file.'/
      data drsmsg(IDRS_DICTEXTENDERROR)
     $     /'Error extending dictionary file.'/
      data drsmsg(IDRS_DATEXTENDERROR)
     $     /'Error extending data file.'/
      data drsmsg(IDRS_DICTRUNCATEERR)
     $     /'Error truncating dictionary file.'/
      data drsmsg(IDRS_DATTRUNCATEERR)
     $     /'Error truncating data file.'/
      data drsmsg(IDRS_BADIEEEFP-1000)
     $     /'Bad IEEE floating point number, cannot translate.'/
      data drsmsg(IDRS_BADCRAYFP-1000)
     $     /'Bad CRAY floating point number, cannot translate.'/
      data drsmsg(IDRS_BADCRAYINT-1000)
     $     /'Bad CRAY integer encountered during translation.'/
      data drsmsg(IDRS_CANNOTCONVERT)
     $     /'Cannot convert data as requested.'/
      data drsmsg(IDRS_INEXACTMATCH-1000)
     $     /'Naming info is similar, but names do not match.'/
      data drsmsg(IDRS_DUPLICATEVAR)
     $     /'Duplicate variable name found in dictionary.'/
      data drsmsg(IDRS_CANNOTWRITEDIC)
     $     /'Cannot write to dictionary file.'/
      data drsmsg(IDRS_BADSYNCOPT)
     $     /'Bad synchronization option'/

      drsrep=IDRS_SUCCESS
      call drstest2(ierr,ierrlev,ierrmsg)

      if(ierrlev.le.curreplevel .and. ierrlev.ne.IDRS_SUCCESS) then
         write(ierrun,100) ierr,curroutine
 100     format(1x,'DRS error',i5,' in routine ',a8)
         write(ierrun,200) drsmsg(ierrmsg)
 200     format(1x,a80)
      endif
      

      return
      end


