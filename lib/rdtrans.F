ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c rdtrans.F,v 2.3 1995/10/16 18:49:11 drach Exp
c rdtrans.F,v
c Revision 2.3  1995/10/16  18:49:11  drach
c - Add calls to byteswap4 for DEC Alpha
c
c Revision 2.2  1995/03/30  00:51:13  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:32  drach
c Merged Sun, Unicos, SGI, and HP versions.
c
c Revision 2.1  1992/12/16  23:21:19  drach
c Propagate redat errors upward.
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
      integer function rdtrans(lu,a)
c
c     Description:
c     -----------
c     Read and translate data array, according to VDB
c
c     Arguments:
c     ---------
c     lu =:  Fortran logical unit
c     a   := data array
c
c     
c     Function Returns:
c     ----------------
c       0: success
c     IDRS_CANNOTCONVERT: Cannot convert data as requested.
c     IDRS_BADCRAYFP: A bad Cray floating point was encountered.
c     IDRS_BADCRAYINT: A bad Cray integer was encountered.
c     IDRS_BADIEEEFP: A bad IEEE floating point was encountered.
c     
c     Author: Bob Drach
c     ------
c     Date: 1/10/90
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

      integer a(1)
#ifdef hpux
      integer gettbuf,c8tof4_,f4toc8_,i8toi4_,i4toi8_,redat
#else !hpux
      integer gettbuf,c8tof4,f4toc8,i8toi4,i4toi8,redat
#endif
      logical drstest
      pointer(itbufptr,itranbuf(1))

      rdtrans=IDRS_SUCCESS
      itbuflen=neu*laty
      if(progrep.eq.IDRS_CRAY_R8
     $     .and. filerepa.eq.IDRS_IEEE_R4) then
         rdtrans= gettbuf(itbuflen,itbufptr)
         if(drstest(rdtrans)) go to 9000
         rdtrans= redat(lu,itranbuf)
         if(drstest(rdtrans)) go to 9000
#ifdef hpux
         rdtrans= f4toc8_(itranbuf,a,neu,IDRS_LEFTHALFWORD)
#else !hpux
         rdtrans= f4toc8(itranbuf,a,neu,IDRS_LEFTHALFWORD)
#endif
         if(rdtrans.ne.IDRS_SUCCESS) rdtrans=IDRS_BADCRAYFP
      elseif(progrep.eq.IDRS_I8 .and. filerepa.eq.IDRS_I4) then
         rdtrans= gettbuf(itbuflen,itbufptr)
         if(drstest(rdtrans)) go to 9000
         rdtrans= redat(lu,itranbuf)
         if(drstest(rdtrans)) go to 9000
#ifdef hpux
         rdtrans= i4toi8_(itranbuf,a,neu,IDRS_LEFTHALFWORD)
#else
         rdtrans= i4toi8(itranbuf,a,neu,IDRS_LEFTHALFWORD)
#endif
         if(rdtrans.ne.IDRS_SUCCESS) rdtrans=IDRS_BADCRAYINT
      elseif(progrep.eq.IDRS_IEEE_R4
     $        .and. filerepa.eq.IDRS_CRAY_R8) then
         rdtrans= gettbuf(itbuflen,itbufptr)
         if(drstest(rdtrans)) go to 9000
         rdtrans= redat(lu,itranbuf)
         if(drstest(rdtrans)) go to 9000
#ifdef hpux
         rdtrans= c8tof4_(itranbuf,a,neu,IDRS_LEFTHALFWORD)
#else
         rdtrans= c8tof4(itranbuf,a,neu,IDRS_LEFTHALFWORD)
#endif
         if(rdtrans.ne.IDRS_SUCCESS) rdtrans=IDRS_BADIEEEFP
#if defined(__alpha)||defined(__linux)
         call byteswap4(a,neu)
#endif
      elseif(progrep.eq.IDRS_I4 .and.
     $        filerepa.eq.IDRS_I8) then
         rdtrans= gettbuf(itbuflen,itbufptr)
         if(drstest(rdtrans)) go to 9000
         rdtrans= redat(lu,itranbuf)
         if(drstest(rdtrans)) go to 9000
#ifdef hpux
         rdtrans= i8toi4_(itranbuf,a,neu,IDRS_LEFTHALFWORD)
#else
         rdtrans= i8toi4(itranbuf,a,neu,IDRS_LEFTHALFWORD)
#endif
#if defined(__alpha)||defined(__linux)
         call byteswap4(a,neu)
#endif
      elseif(progrep.eq.filerepa) then
         rdtrans= redat(lu,a)
         if(drstest(rdtrans)) go to 9000
#if defined(__alpha)||defined(__linux)
         if(progrep.eq.IDRS_IEEE_R4 .or. progrep.eq.IDRS_I4) then
            call byteswap4(a,neu)
         endif
#endif	
      else
         rdtrans= IDRS_CANNOTCONVERT
      endif

 9000 continue
      call drsrout('rdtrans',rdtrans)

      return
      end
