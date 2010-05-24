c setnam.F,v 2.2 1995/03/30 00:51:23 drach Exp
c setnam.F,v
c Revision 2.2  1995/03/30  00:51:23  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:45  drach
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
      integer function setname(source,name,title,units,type)
c***********************************************************************
c     
c     put naming strings into the user vdb
c     
c     
c     source- data source definition <= 120 characters
c     name  - variable name <= 16 characters
c     title - description of variable <= 80 characters
c     units - variable units <= 40 characters
c     type  - type descriptor <= 8 characters 'r*n', 'i*n', 'c*n' in program
c     
#include "drscom.h"
#include "drsdef.h"
c     
      character*(*) source,name,title,units,type
      setname=IDRS_SUCCESS
      call mvnbc (source,usrc)
      call mvnbc (name,unam)
      call mvnbc (title,utitl)
      call mvnbc (units,uun)
      call mvnbc (type,utype2)
      return
      end
