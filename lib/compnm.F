ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c compnm.F,v 2.2 1995/03/30 00:50:26 drach Exp
c compnm.F,v
c Revision 2.2  1995/03/30  00:50:26  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:12:38  drach
c Merged Sun, Unicos, SGI, and HP versions.
c
c Revision 2.2  1992/10/06  00:48:40  drach
c made idenc logical
c
c Revision 2.1  1992/05/21  00:49:26  drach
c Modified to use new version of idenc:
c - changed to logical function
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
      logical function compnam(src1,name1,titl1,units1,src2,
     $     name2,titl2,units2)
      character*(*) src1, src2
      character*(*) name1, name2
      character*(*) titl1, titl2
      character*(*) units1, units2
c     
c     Description:
c     -----------
c     Check if var1 is similar to var2 in the sense that each
c     nonblank character of each name element (src1,name1,titl1,units1) 
c     matches the corresponding (nonblank) character of the same
c     var2 naming element. 
c     
c     Arguments:
c     ---------
c     src1,name1,titl1,units1 =: variable 1 naming info
c     src2,name2,titl2,units2 =: variable 2 naming info
c     
c     Function Returns:
c     ----------------
c     .true. iff respective naming elements match (blank matches anything)
c     
c     Author: Bob Drach
c     ------
c     Date: 5/4/92
c     ----
c     Notes:
c     -----
c     14 Mar 90  Changed name comparison to exact comparison (BD).
c     
c     Glossary:
c     --------
c     
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      
      logical blank,idenc

      compnam = idenc(name1,name2,blank).and.idenc(src1,src2,blank).and.
     $     idenc(titl1,titl2,blank).and.idenc(units1,units2,blank)

      return
      end
