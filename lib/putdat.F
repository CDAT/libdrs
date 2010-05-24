ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c putdat.F,v 2.3 1995/07/28 22:55:08 drach Exp
c putdat.F,v
c Revision 2.3  1995/07/28  22:55:08  drach
c - Modified for IBM RS/6000 version
c
c Revision 2.2  1995/03/30  00:51:09  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:26  drach
c Merged Sun, Unicos, SGI, and HP versions.
c
c Revision 2.1  1992/05/21  00:56:34  drach
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
      integer function putdat(lu,a)
      integer a(1)
c
c     Description:
c     -----------
c     Put data according to the user vdb.
c
c     Arguments:
c     ---------
c     lu  =:  dictionary file logical unit number
c     a   =:  data vector
c     
c     Function Returns:
c     ----------------
c       0: success
c     IDRS_SUCCESS - successful
c     IDRS_BADLU - lu does not exist or cannot be written or read
c     IDRS_BADTYPE - data length or data type illegal,
c     must be 'I', 'R', or 'C'.
c     default (if utype blank) is 'r*4'
c     IDRS_BADDIM - input dimensions are incorrect
c     IDRS_AMBIGUITYEXISTS - an ambiguity exists
c     IDRS_CANNOTADDDATA - data cannot add to existing data
c     IDRS_DICTFULL - too many dictionary entries
c     IDRS_BADDIMTYPE - dimension types disagree
c     IDRS_NORANGE - requested range is outside the dimension range
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
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

#include "drscom.h"
#include "drsdef.h"

      integer putdat1,dictlook,getrange
      logical drstest

      il=iflun(lu)
      if(il.le.0) then
         putdat=IDRS_BADLU
         go to 9000
      endif

      isavelu=lu

c     for unequally spaced dimensions:
c     - look for the naming info in the dictionary for this file
c     - get the indices corresponding to the user-specified
c     -     first and last values
c     - calculate the length to write from the indices
c
      do 100 n=1,mxdim
         if(dimtypeu(n).eq.IDRS_UNEQUALLY_SPACED) then
            putdat=dictlook(il,0,udso(n),udna(n),udti(n),udun(n),ivdb)
            if(putdat.eq.IDRS_SUCCESS) then
               dimaddru(n)=ivdb-n_rec(1,il)+1
               if(dfu2(n).ge.xlownull .or. dlu2(n).ge.xlownull) then
                  putdat=IDRS_BADDIM
                  go to 9000
               endif
               putdat=getrange(dfu2(n),dlu2(n),ivdb,
     $              idfu,idlu,
     $              dlow,dhigh)
               if(drstest(putdat)) go to 9000
               iudim(n)=iabs(idlu-idfu)+1
               dfu(n)=float(idfu)
               dlu(n)=float(idlu)
c     Reset user dimension naming strings to those in the dimension variable
               udna(n)=udna2
               udun(n)=udun2
c     reset user dimension limits for unequally-spaced dimension
c     to those actually written
               dfu2(n)=dlow
               dlu2(n)=dhigh
            else
               if(putdat.eq.IDRS_LOOKUPFAILED) putdat=IDRS_VDBNOTFOUND
               go to 9000
            endif
         endif
 100  continue
      putdat=putdat1(lu,a,.false.)

 9000 continue
      call drsrout('putdat',putdat)
      end
