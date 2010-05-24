ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c setrep.F,v 2.3 1995/07/28 22:55:19 drach Exp
c setrep.F,v
c Revision 2.3  1995/07/28  22:55:19  drach
c - Modified for IBM RS/6000 version
c
c Revision 2.2  1995/03/30  00:51:24  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:47  drach
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
      integer function setrep(irep)
c
c     Description:
c     -----------
c     Set the requested element file representation.
c
c     Arguments:
c     ---------
c     irep =:  representation code as defined in drsdef.h:
c              IDRS_I4     : 1-s complement, 4-byte integer (Sun integer)
c              IDRS_I8     : 1-s complement, 8-byte integer (Cray integer)
c              IDRS_IEEE_R4: IEEE 32-bit floating point
c              IDRS_CRAY_R8: Cray 64-bit floating point
c              IDRS_ASCII  : ASCII character string
c              IDRS_DEFAULT: Set to default, depending on 
c                 element program representation. (see Note 1)
c                 
c     
c     Function Returns:
c     ----------------
c       0: success
c     
c     Author: Bob Drach
c     ------
c     Date: 1/10/90
c     ----
c     Notes:
c     -----
c     (1) Element program representation is set via the VariableType
c         parameter of setname. By default, integers are written as
c         IDRS_I4, and reals are written as IDRS_IEEE_R4. ASCII strings
c         are written as IDRS_ASCII, that is, no translation.
c         Using parameter IDRS_DEFAULT is equivalent to not calling
c         setrep.
c
c     Glossary:
c     --------
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

#include "drscom.h"
#include "drsdef.h"

      setrep= IDRS_SUCCESS
      filerepu= irep

      return
      end
