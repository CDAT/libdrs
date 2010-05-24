ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c wrtrans.F,v 2.3 1995/10/16 18:49:27 drach Exp
c wrtrans.F,v
c Revision 2.3  1995/10/16  18:49:27  drach
c - Add calls to byteswap4 for DEC Alpha
c
c Revision 2.2  1995/03/30  00:51:29  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:54  drach
c Merged Sun, Unicos, SGI, and HP versions.
c
c Revision 2.1  1992/12/16  23:21:38  drach
c Propagate wrdat errors upward.
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
      integer function wrtrans(lu,a)
c
c     Description:
c     -----------
c     Translate and read data array, according to VDB
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

#ifdef hpux
      integer a(1), gettbuf, c8tof4_, f4toc8_, i8toi4_, i4toi8_, wrdat
#else
      integer a(1), gettbuf, c8tof4, f4toc8, i8toi4, i4toi8, wrdat
#endif
      logical drstest
      pointer(itbufptr,itranbuf(1))

      wrtrans=IDRS_SUCCESS
      itbuflen=neu*laty
      if(progrep.eq.IDRS_CRAY_R8 .and.
     $     filerepa.eq.IDRS_IEEE_R4) then
         wrtrans= gettbuf(itbuflen,itbufptr)
         if(drstest(wrtrans)) go to 9000
#ifdef hpux
         wrtrans= c8tof4_(a,itranbuf,neu,IDRS_LEFTHALFWORD)
#else
         wrtrans= c8tof4(a,itranbuf,neu,IDRS_LEFTHALFWORD)
#endif
         if(wrtrans.ne.IDRS_SUCCESS) wrtrans=IDRS_BADCRAYFP
         wrtrans= wrdat(lu,itranbuf)
         if(drstest(wrtrans)) go to 9000
      elseif(progrep.eq.IDRS_I8 .and. filerepa.eq.IDRS_I4) then
         wrtrans= gettbuf(itbuflen,itbufptr)
         if(drstest(wrtrans)) go to 9000
#ifdef hpux
         wrtrans= i8toi4_(a,itranbuf,neu,IDRS_LEFTHALFWORD)
#else
         wrtrans= i8toi4(a,itranbuf,neu,IDRS_LEFTHALFWORD)
#endif
         if(wrtrans.ne.IDRS_SUCCESS) wrtrans=IDRS_BADCRAYINT
         wrtrans= wrdat(lu,itranbuf)
         if(drstest(wrtrans)) go to 9000
      elseif(progrep.eq.IDRS_IEEE_R4
     $        .and. filerepa.eq.IDRS_CRAY_R8) then
         wrtrans= gettbuf(itbuflen,itbufptr)
         if(drstest(wrtrans)) go to 9000
#ifdef hpux
         wrtrans= f4toc8_(a,itranbuf,neu,IDRS_LEFTHALFWORD)
#else
         wrtrans= f4toc8(a,itranbuf,neu,IDRS_LEFTHALFWORD)
#endif
         if(wrtrans.ne.IDRS_SUCCESS) wrtrans=IDRS_BADIEEEFP
         wrtrans= wrdat(lu,itranbuf)
         if(drstest(wrtrans)) go to 9000
      elseif(progrep.eq.IDRS_I4 .and. filerepa.eq.IDRS_I8) then
         wrtrans= gettbuf(itbuflen,itbufptr)
         if(drstest(wrtrans)) go to 9000
#ifdef hpux
         wrtrans= i4toi8_(a,itranbuf,neu,IDRS_LEFTHALFWORD)
#else
         wrtrans= i4toi8(a,itranbuf,neu,IDRS_LEFTHALFWORD)
#endif
         wrtrans= wrdat(lu,itranbuf)
         if(drstest(wrtrans)) go to 9000
      elseif(progrep.eq.filerepa) then
#if defined(__alpha)||defined(__linux)
c     
c     swap ints and floats in place on the Alpha
c     
         if(progrep.eq.IDRS_IEEE_R4 .or. progrep.eq.IDRS_I4) then
            call byteswap4(a,neu)
         endif
#endif
         wrtrans= wrdat(lu,a)
         if(drstest(wrtrans)) go to 9000
#if defined(__alpha)||defined(__linux)
c     
c     now swap back (ughgh, but the best alternative is
c     to grab more memory and copy ...)
c     
         if(progrep.eq.IDRS_IEEE_R4 .or. progrep.eq.IDRS_I4) then
            call byteswap4(a,neu)
         endif
#endif
      else
         wrtrans= IDRS_CANNOTCONVERT
      endif

 9000 continue
      call drsrout('wrtrans',wrtrans)

      return
      end
