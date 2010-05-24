c confnm.F,v 2.2 1995/03/30 00:50:27 drach Exp
c confnm.F,v
c Revision 2.2  1995/03/30  00:50:27  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:12:39  drach
c Merged Sun, Unicos, SGI, and HP versions.
c
c Revision 2.2  1992/10/06  00:51:35  drach
c made idenc logical
c
c Revision 2.1  1992/05/21  00:47:59  drach
c Entered into RCS
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
c**********************************************************************
c
c     Routine: 
c     -------
      logical function confnam(userd,avd,nd,ip)
      character*(*) userd(nd),avd(nd)
      integer ip(nd)
c
c     Description:
c     -----------
c     Check if the dimension names in userd and avd conform, in the sense
c     that each name in userd matches a name in avd. If successful, the
c     transposition array ip is returned, such that userd(ip(i)) matches avd(i),
c     i=1..nd.
c
c     Arguments:
c     ---------
c     userd =:  array of ASCII character strings
c     avd   =:  array of ASCII character strings
c     nd    =:  length of userd,avd,ip
c     ip     := transposition matrix
c
c     
c     Function Returns:
c     ----------------
c     .true. iff userd and avd conform
c     
c     Author: Bob Drach
c     ------
c
c     Date: 5/4/92
c     ----
c
c     Notes:
c     -----
c
c     Glossary:
c     --------
c
c**********************************************************************

      logical match,blank
      logical idenc

      confnam = .true.
      do 10 i=1,nd
         ip(i)=0
 10   continue
c
c     match nonblank user names to avd names
c
      do 30 i=1,nd
         do 20 j=1,nd
            match = idenc(userd(i),avd(j),blank)
            if (blank) go to 30
            if (match) then
c
c     if the avd name has already been matched, return no match
c     since the correspondence of dimension names is ambiguous
c     
               if (ip(j).ne.0) then
                  confnam=.false.
                  return
               endif
               ip(j)=i
               go to 30
            endif
 20      continue
c
c     no avd was matched
c     
         confnam=.false.
         return
 30   continue
c
c     match blanks in the order of non-matched avd elements
c     
      do 50 i=1,nd
         match = idenc(userd(i),avd(i),blank)
         if (blank) then
            do 40 j=1,nd
               if(ip(j).eq.0) then
                  ip(j)=i
                  go to 50
               endif
 40         continue
         endif
 50   continue
            
      return
      end
