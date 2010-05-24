c mvnbc.F,v 2.2 1995/03/30 00:51:07 drach Exp
c mvnbc.F,v
c Revision 2.2  1995/03/30  00:51:07  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:23  drach
c Merged Sun, Unicos, SGI, and HP versions.
c
c Revision 2.0  1992/03/07  00:08:14  drach
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
c
c***********************************************************************
      subroutine mvnbc (a,b)
c***********************************************************************
      character*(*) a,b
      la=len(a)
      lb=len(b)
      i1=la
      i2=1
      do 20 i=1,la
      ia=ichar(a(i:i))
      if (ia.gt.32.and.ia.lt.127) then
        i1=min(i1,i)
        i2=max(i2,i)
      endif
  20  continue
      if (i2.ge.i1) then
        b=a(i1:i2)
      else
        b=' '
      endif
      return
      end
