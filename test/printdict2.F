c     Inquire information in a drs file.
c
c     Usage: printdict <dictionary-file>
      
#include "drsdef.h"

      logical drstest
      integer prdict,cluvdb,aslun
      character*256 dictfile

      if(iargc().ne.1) then
         print *,'Usage: printdict <DRS-dictionary-file>'
         call exit(1)
      endif
      call getarg(1,dictfile)
      
c      if(drstest(seterr(6,IDRS_WARNING))) go to 9000
      if(drstest(aslun(7,dictfile,8,' ',IDRS_READ)))
     $     go to 9000
      if(drstest(cluvdb())) go to 9000
      if(drstest(prdict(6,7))) go to 9000
         
 9000 continue
c      stop
      end
