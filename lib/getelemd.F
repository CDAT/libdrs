c**********************************************************************
c getelemd.F,v 2.2 1995/03/30 00:50:49 drach Exp
c getelemd.F,v
c Revision 2.2  1995/03/30  00:50:49  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:12:59  drach
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
      integer function getelemd(type,bpe)
c
c     Description:
c     -----------
c     Get element description, for current variable.
c
c     Arguments:
c     ---------
c     type := element type (IDRS_CRAY_R8, IDRS_IEEE_R4, IDRS_I8,
c                           IDRS_I4, or IDRS_ASCII)
c     bpe  := bytes per element
c
c     
c     Function Returns:
c     ----------------
c       0: success
c     IDRS_BADTYPE: A bad element type was found.
c     
c     Author: Bob Drach
c     ------
c
c     Date: 3/12/90
c     ----
c
c     Notes:
c     -----
c     (1) The UVDB must have been set (i.e., via getdat or inqdict)
c
c     Glossary:
c     --------
c
c**********************************************************************

#include "drscom.h"
#include "drsdef.h"
      integer type,bpe

      getelemd=IDRS_SUCCESS

      if(utype(1:3).eq.'R*8') then
         type=IDRS_CRAY_R8
         bpe=8
      elseif(utype(1:3).eq.'R*4') then
         type=IDRS_IEEE_R4
         bpe=4
      elseif(utype(1:3).eq.'I*8') then
         type=IDRS_I8
         bpe=8
      elseif(utype(1:3).eq.'I*4') then
         type=IDRS_I4
         bpe=4
      elseif(utype(1:1).eq.'C') then
         type=IDRS_ASCII
         bpe=0
         do 3 i=1,8
            if (utype(i:i).ge.'0'.and.utype(i:i).le.'9') bpe=
     1           bpe*10+(ichar(utype(i:i))-ichar('0'))
 3       continue
         if (bpe.le.0) getelemd=IDRS_BADTYPE
      else
         getelemd=IDRS_BADTYPE
      endif
      
 9000 continue
      return
      end

