c**********************************************************************
c getpelem.F,v 2.2 1995/03/30 00:50:53 drach Exp
c getpelem.F,v
c Revision 2.2  1995/03/30  00:50:53  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:06  drach
c Merged Sun, Unicos, SGI, and HP versions.
c
c Revision 2.1  1993/01/05  02:02:41  drach
c Initial version.
c
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
      integer function getpelem(type,bpe)
c
c     Description:
c     -----------
c     Get element program description, for current variable.
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
c     (2) Use getelemd for the FILE representation
c     (3) This routine is most useful for C DRS routines which need
c         the user representation specified (e.g., getslab)
c
c     Glossary:
c     --------
c
c**********************************************************************

#include "drscom.h"
#include "drsdef.h"
      integer type,bpe

      getpelem=IDRS_SUCCESS

      if(utype2(1:3).eq.'R*8') then
         type=IDRS_CRAY_R8
         bpe=8
      elseif(utype2(1:3).eq.'R*4') then
         type=IDRS_IEEE_R4
         bpe=4
      elseif(utype2(1:3).eq.'I*8') then
         type=IDRS_I8
         bpe=8
      elseif(utype2(1:3).eq.'I*4') then
         type=IDRS_I4
         bpe=4
      elseif(utype2(1:1).eq.'C') then
         type=IDRS_ASCII
         bpe=0
         do 3 i=1,8
            if (utype2(i:i).ge.'0'.and.utype2(i:i).le.'9') bpe=
     1           bpe*10+(ichar(utype2(i:i))-ichar('0'))
 3       continue
         if (bpe.le.0) getpelem=IDRS_BADTYPE
      else
         getpelem=IDRS_BADTYPE
      endif
      
 9000 continue
      return
      end

