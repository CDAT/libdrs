c     Inquire information in a drs file.
c
c     Usage: printdict
      
#include "drsdef.h"

      logical drstest
      integer prdict,cluvdb,aslun
      character*40 dictfile

      dictfile='dvtest1.dic'
      
c      if(drstest(seterr(6,IDRS_WARNING))) go to 9000
      if(drstest(aslun(7,dictfile,8,' ',IDRS_READ)))
     $     go to 9000
      if(drstest(cluvdb())) go to 9000
      if(drstest(prdict(6,7))) go to 9000
         
 9000 continue
c      stop
      end
