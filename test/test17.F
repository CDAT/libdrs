c     multifile test
c     write two variables of the same name, different values,
c     to dvtest17a and dvtest17b
      program test17
      
#include "drsdef.h"
      parameter(LENV=300)

      dimension a1(LENV), b1(LENV), a2(LENV), b2(LENV)
      dimension a1a(LENV), b1a(LENV), a2a(LENV), b2a(LENV)
      dimension dv1(LENV),dv2(LENV)

      integer aslun,cluvdb,setname,
     $     putdat,setdim,cllun,getdat,putvdim,setvdim
      integer setdate
      logical drstest
c      integer system
      character*8 date,time
      data date/' 1/10/90'/,time/'11:05:30'/
      
c      ierr=system("rm -f dvtest17a.dic")
c      ierr=system("rm -f dvtest17a.dat")
c      ierr=system("rm -f dvtest17b.dic")
c      ierr=system("rm -f dvtest17b.dat")
      
      do 100 i=1,LENV
         a1(i)=float(i)
         b1(i)=float(i+LENV)
         a2(i)=float(i+2*LENV)
         b2(i)=float(i+3*LENV)
         dv1(i)=float(-i)
         dv2(i)=float(-i-LENV)
 100  continue

c      ierr=seterr(6,IDRS_WARNING)
      
      if(drstest(aslun(2,'dvtest17a.dic',3,'dvtest17a.dat',
     $     IDRS_CREATE))) go to 9000
      if(drstest(aslun(7,'dvtest17b.dic',8,'dvtest17b.dat',
     $     IDRS_CREATE))) go to 9000
      
c     write the variables
      
      if(drstest(cluvdb())) go to 9000
      if(drstest(setname('test17a','dv','dimension variable',
     $     'none',' '))) go to 9000
      ierr=setdate(date,time)      
      if(drstest(putvdim(2,LENV,dv1,idv1,idv2))) go to 9000

      if(drstest(cluvdb())) go to 9000
      if(drstest(setname('test17b','dv','dimension variable',
     $     'none',' '))) go to 9000
      ierr=setdate(date,time)      
      if(drstest(putvdim(7,LENV,dv2,idv1,idv2))) go to 9000

      if(drstest(cluvdb())) go to 9000
      if(drstest(setname('test17a','a','data variable a',
     $     'aunits',' '))) go to 9000
      if(drstest(setdim(1,'none','none',LENV,1.0,real(LENV))))
     $     go to 9000
      ierr=setdate(date,time)      
      if(drstest(putdat(2,a1))) go to 9000
      
      if(drstest(cluvdb())) go to 9000
      if(drstest(setname('test17a','b','data variable b',
     $     'bunits',' '))) go to 9000
      if(drstest(setvdim(1,'test17a','dv','dimension variable',
     $     'none',dv1(1),dv1(LENV)))) go to 9000
      ierr=setdate(date,time)      
      if(drstest(putdat(2,b1))) go to 9000
      
      if(drstest(cluvdb())) go to 9000
      if(drstest(setname('test17b','a','data variable a',
     $     'aunits',' '))) go to 9000
      if(drstest(setdim(1,'none','none',LENV,1.0,real(LENV))))
     $     go to 9000
      ierr=setdate(date,time)      
      if(drstest(putdat(7,a2))) go to 9000
      
      if(drstest(cluvdb())) go to 9000
      if(drstest(setname('test17b','b','data variable b',
     $     'bunits',' '))) go to 9000
      if(drstest(setvdim(1,'test17b','dv','dimension variable',
     $     'none',dv2(1),dv2(LENV)))) go to 9000
      ierr=setdate(date,time)      
      if(drstest(putdat(7,b2))) go to 9000
      
      
      if(drstest(cllun(2))) go to 9000
      if(drstest(cllun(7))) go to 9000
c     read the variables back
      
      if(drstest(aslun(2,'dvtest17b.dic',3,'dvtest17b.dat',
     $     IDRS_READ))) go to 9000
      if(drstest(aslun(7,'dvtest17a.dic',8,'dvtest17a.dat',
     $     IDRS_READ))) go to 9000

      if(drstest(cluvdb())) go to 9000
      if(drstest(setname('test17b','a',' ',' ',' '))) go to 9000
      if(drstest(getdat(2,a2a,IDRS_BYTES_PER_WORD*LENV)))
     $     go to 9000

      if(drstest(cluvdb())) go to 9000
      if(drstest(setname('test17b','b',' ',' ',' '))) go to 9000
      if(drstest(getdat(2,b2a,IDRS_BYTES_PER_WORD*LENV)))
     $     go to 9000

      if(drstest(cluvdb())) go to 9000
      if(drstest(setname('test17a','a',' ',' ',' '))) go to 9000
      if(drstest(getdat(7,a1a,IDRS_BYTES_PER_WORD*LENV)))
     $     go to 9000

      if(drstest(cluvdb())) go to 9000
      if(drstest(setname('test17a','b',' ',' ',' '))) go to 9000
      if(drstest(getdat(7,b1a,IDRS_BYTES_PER_WORD*LENV)))
     $     go to 9000

c     compare
      
      do 200 i=1,LENV
         if(a1(i).ne.a1a(i)) then
            write(6,*) 'a1 does not compare at',i
            go to 9000
         endif
         if(b1(i).ne.b1a(i)) then
            write(6,*) 'b1 does not compare at',i
            go to 9000
         endif
         if(a2(i).ne.a2a(i)) then
            write(6,*) 'a2 does not compare at',i
            go to 9000
         endif
         if(b2(i).ne.b2a(i)) then
            write(6,*) 'b2 does not compare at',i
            go to 9000
         endif
 200  continue

 9000 continue
      end
