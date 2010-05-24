ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c dictlk.F,v 2.2 1995/03/30 00:50:32 drach Exp
c dictlk.F,v
c Revision 2.2  1995/03/30  00:50:32  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:12:44  drach
c Merged Sun, Unicos, SGI, and HP versions.
c
c Revision 2.1  1992/05/21  00:51:52  drach
c - changed dictlen argument to ioff offset for search start
c - handles new version of compnam
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
      integer function dictlook(dict,ioff,source,name,title,
     $     units,vdb)
      integer dict,ioff,vdb
      character*(*) source
      character*(*) name
      character*(*) title
      character*(*) units

c
c     Description:
c     -----------
c     Lookup the variable named by the arguments in the dictionary.
c     
c     Arguments:
c     ---------
c     dict     =:  file index
c     ioff     =:  zero-origin offset of first entry to search (0 for no offset)
c     source   =:  variable source
c     name     =:  variable name
c     title    =:  variable title
c     units    =:  variable units
c     vdb       := dictionary index of the variable
c     
c     Function Returns:
c     ----------------
c       0: success
c     IDRS_LOOKUPFAILED: the variable is not in the dictionary
c     
c     Author: Bob Drach
c     ------
c     Date: 10/16/89
c     ----
c     Notes:
c     -----
c     (1) On successful return, the avdb is set to the variable
c       descriptor.
c     (2) On error return, vdb is 0
c     Glossary:
c     --------
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
#include "drscom.h"
#include "drsdef.h"

      logical compnam

      dictlook=IDRS_SUCCESS
      vdb=0
      n1=n_rec(1,dict)+ioff
      do 100 i=n1,n_rec(2,dict)
         if(compnam(source,name,title,units,
     $        n_src(i),n_nam(i),n_tit(i),n_un(i))) then
            vdb=i
            go to 9000
         endif
 100  continue

      dictlook=IDRS_LOOKUPFAILED
            
 9000 continue
      call drsrout('dictlook',dictlook)
      return
      end

