      program test20
c
c     write five vars with similar names, then read back

#include "drsdef.h"

c      integer system
      integer aslun
      integer putdat
      integer setdim
      integer cllun
      integer cluvdb
      integer setname
      integer getdat
      integer setdate

      character*120 source1,source2
      character*16 name1,name2
      character*80 title1,title2
      character*40 units1,units2
      character*8 cdate,ctime
c      character*16 out

      data source1/'test'/,source2/'test2'/
      data name1/'hflxsen'/,name2/'hflxsenz'/
      data title1/'Sensible heat flux'/,
     $     title2/'Sensible heat flux, zonal'/
      data units1/'W/m^2'/,units2/'Watts/m^2'/
      data lu/7/
      data cdate /'05/21/92'/,ctime/'10:37:00'/

c     set exception handler
c      external invalid_handler
c      ieeer = ieee_handler('set','invalid',invalid_handler)

c      ierr=system("rm -f test20.dic")
c      ierr=system("rm -f test20.dat")

      ierr = aslun(lu,'test20',8,' ',IDRS_CREATE)

      ierr = cluvdb()
      ierr = setname(source1,name1,title1,units1,' ')
      ierr = setdate(cdate,ctime)
      ierr = setdim(1,'test','test',1,1.0,1.0)
      ierr = putdat(lu,1.0)

      ierr = cluvdb()
      ierr = setname(source2,name1,title1,units1,' ')
      ierr = setdate(cdate,ctime)
      ierr = setdim(1,'test','test',1,1.0,1.0)
      ierr = putdat(lu,2.0)
      
      ierr = cluvdb()
      ierr = setname(source1,name2,title1,units1,' ')
      ierr = setdate(cdate,ctime)
      ierr = setdim(1,'test','test',1,1.0,1.0)
      ierr = putdat(lu,3.0)
      
      ierr = cluvdb()
      ierr = setname(source1,name1,title2,units1,' ')
      ierr = setdate(cdate,ctime)
      ierr = setdim(1,'test','test',1,1.0,1.0)
      ierr = putdat(lu,4.0)
      
      ierr = cluvdb()
      ierr = setname(source1,name1,title1,units2,' ')
      ierr = setdate(cdate,ctime)
      ierr = setdim(1,'test','test',1,1.0,1.0)
      ierr = putdat(lu,5.0)

c     read back and compare

      ierr = cluvdb()
      ierr = setname(source1,name1,title1,units1,' ')
      ierr = getdat(lu,x,IDRS_BYTES_PER_WORD)
      if(x.ne.1.0) then
         print *,'Error occurred'
      endif

      ierr = cluvdb()
      ierr = setname(source2,' ',' ',' ',' ')
      ierr = getdat(lu,x,IDRS_BYTES_PER_WORD)
      if(x.ne.2.0) then
         print *,'Error occurred'
      endif
      
      ierr = cluvdb()
      ierr = setname(' ',name2,' ',' ',' ')
      ierr = getdat(lu,x,IDRS_BYTES_PER_WORD)
      if(x.ne.3.0) then
         print *,'Error occurred'
      endif
      
      ierr = cluvdb()
      ierr = setname(' ',' ',title2,' ',' ')
      ierr = getdat(lu,x,IDRS_BYTES_PER_WORD)
      if(x.ne.4.0) then
         print *,'Error occurred'
      endif
      
      ierr = cluvdb()
      ierr = setname(' ',' ',' ',units2,' ')
      ierr = getdat(lu,x,IDRS_BYTES_PER_WORD)
      if(x.ne.5.0) then
         print *,'Error occurred'
      endif

      ierr = cllun(lu)

c      stop
      end
