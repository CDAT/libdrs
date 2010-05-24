c     write four vars INTERLEAVED, read, and compare
      program test11
      
#include "drsdef.h"
      
      parameter(LEN1=4,LEN2=5,LEN3=6,LEN4=7)
      
      dimension a(LEN1),b(LEN2,LEN1),c(LEN2,LEN3,LEN1),
     $     d(LEN2,LEN3,LEN4,LEN1),dv1(LEN1),dv2(LEN2),
     $     dv3(LEN3),dv4(LEN4)
      dimension a2(LEN1),b2(LEN2,LEN1),c2(LEN2,LEN3,LEN1),
     $     d2(LEN2,LEN3,LEN4,LEN1)
      character*8 date,time
      data date/'10/31/89'/,time/'15:17:00'/
      integer lu,lud
      data lu/2/,lud/3/

      integer aslun,cluvdb,setname,putvdim,
     $     setvdim,putdat,setdim,cllun,getdat,
     $     drsautosync
      integer setdate
      logical drstest
c      integer system
      
c      ierr=system("rm -f dvtest1.dic")
c      ierr=system("rm -f dvtest1.dat")
      
      dv1(1)=1.0
      dv2(1)=10.0
      dv3(1)=11.0
      dv4(1)=24.0
      
      do 100 i=2,LEN1
         dv1(i)=dv1(i-1)+2.0
 100  continue
      
      do 200 i=2,LEN2
         dv2(i)=dv2(i-1)-2.0
 200  continue
      
      do 300 i=2,LEN3
         dv3(i)=dv3(i-1)+2.0
 300  continue
      
      do 400 i=2,LEN4
         dv4(i)=dv4(i-1)-2.0
 400  continue
      
      counter=101.0
      do 500 i=1,LEN1
         a(i)=counter
         counter=counter+1.0
 500  continue
      
      counter=201.0
      do 700 i=1,LEN1
         do 600 j=1,LEN2
            b(j,i)=counter
            counter=counter+1.0
 600     continue
 700  continue
      
      counter=301.0
      do 800 i=1,LEN1
         do 1000 k=1,LEN3
            do 900 j=1,LEN2
               c(j,k,i)=counter
               counter=counter+1.0
 900        continue
 1000    continue
 800  continue
      
      counter=501.0
      do 1100 i=1,LEN1
         do 1400 l=1,LEN4
            do 1300 k=1,LEN3
               do 1200 j=1,LEN2
                  d(j,k,l,i)=counter
                  counter=counter+1.0
 1200          continue
 1300       continue
 1400    continue
 1100 continue
c      ierr=seterr(6,IDRS_WARNING)
      
      if(drstest(aslun(lu,'dvtest1.dic',lud,'dvtest1.dat',IDRS_CREATE)))
     $     go to 9000
      if(drstest(drsautosync(lu,IDRS_SYNC_OFF))) go to 9000
      
c     write the dimension variables
c$$$  if(drstest(cluvdb())) go to 9000
c$$$  if(drstest(setname('test10','dv1','dimension variable 1',
c$$$  $     'none',' '))) go to 9000
c$$$  if(drstest(putvdim(lu,LEN1,dv1,idv1a,idv1b))) go to 9000
      
      if(drstest(cluvdb())) go to 9000
      if(drstest(setname('test10','dv2','dimension variable 2',
     $     'none',' '))) go to 9000
      ierr=setdate(date,time)      
      if(drstest(putvdim(lu,LEN2,dv2,idv2a,idv2b))) go to 9000
      
      
      if(drstest(cluvdb())) go to 9000
      if(drstest(setname('test10','dv3','dimension variable 3',
     $     'none',' '))) go to 9000
      ierr=setdate(date,time)      
      if(drstest(putvdim(lu,LEN3,dv3,idv3a,idv3b))) go to 9000
      
      
      if(drstest(cluvdb())) go to 9000
      if(drstest(setname('test10','dv4','dimension variable 4',
     $     'none',' '))) go to 9000
      ierr=setdate(date,time)      
      if(drstest(putvdim(lu,LEN4,dv4,idv4a,idv4b))) go to 9000
      
      
c     write the variables
      
      do 4000 ielem=1,LEN1
         if(drstest(cluvdb())) go to 9000
         if(drstest(setname('test10','dv1','dimension variable 1',
     $        'none',' '))) go to 9000
      ierr=setdate(date,time)      
         if(drstest(putvdim(lu,1,dv1(ielem),idv1a,idv1b)))
     $        go to 9000
         
         
         if(drstest(cluvdb())) go to 9000
         if(drstest(setname('test10','a','data variable a',
     $        'aunits',' '))) go to 9000
         if(drstest(setvdim(1,'test10 ','dv1',
     $        'dimension variable 1 ','none ',dv1(ielem),dv1(ielem))))
     $        go to 9000
      ierr=setdate(date,time)      
         if(drstest(putdat(lu,a(ielem)))) go to 9000
         
         
         if(drstest(cluvdb())) go to 9000
         if(drstest(setname('test10','b','data variable b',
     $        'bunits',' '))) go to 9000
         if(drstest(setvdim(2,'test10','dv1','dimension variable 1',
     $        'none',dv1(ielem),dv1(ielem)))) go to 9000
         if(drstest(setvdim(1,'test10','dv2','dimension variable 2',
     $        'none',dv2(1),dv2(LEN2)))) go to 9000
      ierr=setdate(date,time)      
         if(drstest(putdat(lu,b(1,ielem)))) go to 9000
         
         if(drstest(cluvdb())) go to 9000
         if(drstest(setname('test10','c','data variable c',
     $        'cunits',' '))) go to 9000
         if(drstest(setvdim(3,'test10','dv1','dimension variable 1',
     $        'none',dv1(ielem),dv1(ielem)))) go to 9000
         if(drstest(setdim(1,'longitude','lunits',LEN2,1.0,real(LEN2))))
     $        go to 9000
         if(drstest(setvdim(2,'test10','dv3','dimension variable 3',
     $        'none',dv3(1),dv3(LEN3)))) go to 9000
      ierr=setdate(date,time)      
         if(drstest(putdat(lu,c(1,1,ielem)))) go to 9000
         
         if(drstest(cluvdb())) go to 9000
         if(drstest(setname('test10','d','data variable d',
     $        'dunits',' '))) go to 9000
         if(drstest(setvdim(4,'test10','dv1','dimension variable 1',
     $        'none',dv1(ielem),dv1(ielem)))) go to 9000
         if(drstest(setvdim(1,'test10','dv2','dimension variable 2',
     $        'none',dv2(1),dv2(LEN2)))) go to 9000
         if(drstest(setvdim(2,'test10','dv3','dimension variable 3',
     $        'none',dv3(1),dv3(LEN3)))) go to 9000
         if(drstest(setvdim(3,'test10','dv4','dimension variable 4',
     $        'none',dv4(1),dv4(LEN4)))) go to 9000
      ierr=setdate(date,time)      
         if(drstest(putdat(lu,d(1,1,1,ielem)))) go to 9000
         
 4000 continue
      
      if(drstest(cllun(lu))) go to 9000
c     read the variables back
      
      if(drstest(aslun(lu,'dvtest1.dic',lud,'dvtest1.dat',IDRS_READ)))
     $     go to 9000
      if(drstest(cluvdb())) go to 9000
      if(drstest(setname(' ','a',' ',' ',' '))) go to 9000
      if(drstest(getdat(lu,a2,IDRS_BYTES_PER_WORD*LEN1))) go to 9000
      
      if(drstest(cluvdb())) go to 9000
      if(drstest(setname(' ','b',' ',' ',' '))) go to 9000
      if(drstest(getdat(lu,b2,IDRS_BYTES_PER_WORD*LEN1*LEN2)))
     $     go to 9000
      
      if(drstest(cluvdb())) go to 9000
      if(drstest(setname(' ','c',' ',' ',' '))) go to 9000
      if(drstest(getdat(lu,c2,IDRS_BYTES_PER_WORD*LEN1*LEN2*LEN3)))
     $     go to 9000
      
      if(drstest(cluvdb())) go to 9000
      if(drstest(setname(' ','d',' ',' ',' '))) go to 9000
      if(drstest(getdat(lu,d2,
     $     IDRS_BYTES_PER_WORD*LEN1*LEN2*LEN3*LEN4))) go to 9000
      
      
c     compare
      
      do 1500 i=1,LEN1
         if(a(i).ne.a2(i)) then
            write(6,*) 'a does not compare at',i
            go to 1600
         endif
 1500 continue
 1600 continue
      do 1700 i=1,LEN1
         do 1800 j=1,LEN2
            if(b(j,i).ne.b2(j,i)) then
               write(6,*) 'b does not compare at', i,j
               go to 1900
            endif
 1800    continue
 1700 continue
 1900 continue
      do 1950 i=1,LEN1
         do 2100 k=1,LEN3
            do 2000 j=1,LEN2
               if(c(j,k,i).ne.c2(j,k,i)) then
                  write(6,*) 'c does not compare at',i,j,k
                  go to 2200
               endif
 2000       continue
 2100    continue
 1950 continue
 2200 continue
      do 2300 i=1,LEN1
         do 2600 l=1,LEN4
            do 2500 k=1,LEN3
               do 2400 j=1,LEN2
                  if(d(j,k,l,i).ne.d2(j,k,l,i)) then
                     write(6,*) 'd does not compare at',i,j,k,l
                     go to 2700
                  endif
 2400          continue
 2500       continue
 2600    continue
 2300 continue
 2700 continue
      
 9000 continue
      ierr=cllun(lu)
      end
