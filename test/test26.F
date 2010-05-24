c     read portions of dvtest1.dat,
c     INTERCHANGING setdim and setvdim !
c     adapted from test12 (should use dvtest1 generated
c     in test11 !!!!
      program test26
      
#include "drsdef.h"
      
      parameter(LEN1=4,LEN2=5,LEN3=6,LEN4=7)
      
      dimension a(LEN1),b(LEN2,LEN1),c(LEN2,LEN3,LEN1),
     $     d(LEN2,LEN3,LEN4,LEN1),dv1(LEN1),dv2(LEN2),
     $     dv3(LEN3),dv4(LEN4),dv4a(LEN4),dv2a(LEN2)
      dimension a2(LEN1),b2(LEN2*LEN1),c2(LEN2*LEN3*LEN1),
     $     d2(LEN2*LEN3*LEN4*LEN1)

      character*8 date,time
      data date/'10/31/89'/,time/'15:17:00'/
      integer lu,lud,retlen,dtype
      data lu/2/,lud/3/
      character source*120,title*80,name*16,units*40

      integer aslun, cluvdb, setname, setvdim,
     $     setdim, getdat, getcdim, getedim, cllun
      logical drstest

c     ranges for getting data
      
      data xa1/3.0/,xa2/5.0/
      data xb11/9.0/,xb12/3.0/,xb21/1.0/,xb22/7.0/
      data xc11/2.0/,xc12/5.0/,xc21/19.0/,xc22/19.0/,
     $     xc31/4.0/,xc32/6.0/
      data xd11/6.0/,xd12/4.0/,xd21/11.0/,xd22/13.0/,
     $     xd31/22.0/,xd32/16.0/,xd41/3.0/,xd42/5.0/
      
c     corresponding indices
      
      data ixa1/2/,ixa2/3/
      data ixb11/2/,ixb12/4/,ixb21/1/,ixb22/4/
      data ixc11/2/,ixc12/5/,ixc21/5/,ixc22/5/,
     $     ixc31/3/,ixc32/3/
      data ixd11/3/,ixd12/4/,ixd21/1/,ixd22/2/,
     $     ixd31/2/,ixd32/5/,ixd41/2/,ixd42/3/
      
      
c$$$  integer system
      
c$$$  ierr=system("rm -f dvtest1.dic")
c$$$  ierr=system("rm -f dvtest1.dat")
c$$$  
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
      
      n=1
      counter=101.0
      do 500 i=1,LEN1
         a(i)=counter
         counter=counter+1.0
         a2(n)=-1.0
         n=n+1
 500  continue
      
      n=1
      counter=201.0
      do 700 i=1,LEN1
         do 600 j=1,LEN2
            b(j,i)=counter
            counter=counter+1.0
            b2(n)=-1.0
            n=n+1
 600     continue
 700  continue
      
      n=1
      counter=301.0
      do 800 i=1,LEN1
         do 1000 k=1,LEN3
            do 900 j=1,LEN2
               c(j,k,i)=counter
               counter=counter+1.0
               c2(n)=-1.0
               n=n+1
 900        continue
 1000    continue
 800  continue
      
      n=1
      counter=501.0
      do 1100 i=1,LEN1
         do 1400 l=1,LEN4
            do 1300 k=1,LEN3
               do 1200 j=1,LEN2
                  d(j,k,l,i)=counter
                  counter=counter+1.0
                  d2(n)=-1.0
                  n=n+1
 1200          continue
 1300       continue
 1400    continue
 1100 continue
c      ierr=seterr(6,IDRS_WARNING)
      
c$$$  if(drstest(aslun(lu,'dvtest1.dic',lud,'dvtest1.dat',IDRS_CREATE)))
c$$$  $     go to 9000
      
c     write the dimension variables
c$$$  if(drstest(cluvdb())) go to 9000
c$$$  if(drstest(setname('test10','dv1','dimension variable 1',
c$$$  $     'none',' '))) go to 9000
c$$$  if(drstest(putvdim(lu,LEN1,dv1,idv1a,idv1b))) go to 9000
c$$$  
c$$$  if(drstest(cluvdb())) go to 9000
c$$$  if(drstest(setname('test10','dv2','dimension variable 2',
c$$$  $     'none',' '))) go to 9000
c$$$  if(drstest(putvdim(lu,LEN2,dv2,idv2a))) go to 9000
c$$$  
c$$$  
c$$$  if(drstest(cluvdb())) go to 9000
c$$$  if(drstest(setname('test10','dv3','dimension variable 3',
c$$$  $     'none',' '))) go to 9000
c$$$  if(drstest(putvdim(lu,LEN3,dv3,idv3a,idv3b))) go to 9000
c$$$  
c$$$  
c$$$  if(drstest(cluvdb())) go to 9000
c$$$  if(drstest(setname('test10','dv4','dimension variable 4',
c$$$  $     'none',' '))) go to 9000
c$$$  if(drstest(putvdim(lu,LEN4,dv4,idv4a,idv4b))) go to 9000
c$$$  
c$$$  
c$$$c write the variables
c$$$  
c$$$  do 4000 ielem=1,LEN1
c$$$  if(drstest(cluvdb())) go to 9000
c$$$  if(drstest(setname('test10','dv1','dimension variable 1',
c$$$  $        'none',' '))) go to 9000
c$$$  if(drstest(putvdim(lu,1,dv1(ielem),idv1a,idv1b)))
c$$$  $        go to 9000
c$$$  
c$$$  
c$$$  if(drstest(cluvdb())) go to 9000
c$$$  if(drstest(setname('test10','a','data variable a',
c$$$  $        'aunits','R*4'))) go to 9000
c$$$  if(drstest(setvdim(1,'test10 ','dv1',
c$$$  $        'dimension variable 1 ','none ',dv1(ielem),dv1(ielem))))
c$$$  $        go to 9000
c$$$  if(drstest(putdat(lu,a(ielem)))) go to 9000
c$$$  
c$$$  
c$$$  if(drstest(cluvdb())) go to 9000
c$$$  if(drstest(setname('test10','b','data variable b',
c$$$  $        'bunits','R*4'))) go to 9000
c$$$  if(drstest(setvdim(2,'test10','dv1','dimension variable 1',
c$$$  $        'none',dv1(ielem),dv1(ielem)))) go to 9000
c$$$  if(drstest(setvdim(1,'test10','dv2','dimension variable 2',
c$$$  $        'none',dv2(1),dv2(LEN2)))) go to 9000
c$$$  if(drstest(putdat(lu,b(1,ielem)))) go to 9000
c$$$  
c$$$  if(drstest(cluvdb())) go to 9000
c$$$  if(drstest(setname('test10','c','data variable c',
c$$$  $        'cunits','R*4'))) go to 9000
c$$$  if(drstest(setvdim(3,'test10','dv1','dimension variable 1',
c$$$  $        'none',dv1(ielem),dv1(ielem)))) go to 9000
c$$$  if(drstest(setdim(1,'longitude','lunits',LEN2,1.0,real(LEN2))))
c$$$  $        go to 9000
c$$$  if(drstest(setvdim(2,'test10','dv3','dimension variable 3',
c$$$  $        'none',dv3(1),dv3(LEN3)))) go to 9000
c$$$  if(drstest(putdat(lu,c(1,1,ielem)))) go to 9000
c$$$  
c$$$  if(drstest(cluvdb())) go to 9000
c$$$  if(drstest(setname('test10','d','data variable d',
c$$$  $        'dunits','R*4'))) go to 9000
c$$$  if(drstest(setvdim(4,'test10','dv1','dimension variable 1',
c$$$  $        'none',dv1(ielem),dv1(ielem)))) go to 9000
c$$$  if(drstest(setvdim(1,'test10','dv2','dimension variable 2',
c$$$  $        'none',dv2(1),dv2(LEN2)))) go to 9000
c$$$  if(drstest(setvdim(2,'test10','dv3','dimension variable 3',
c$$$  $        'none',dv3(1),dv3(LEN3)))) go to 9000
c$$$  if(drstest(setvdim(3,'test10','dv4','dimension variable 4',
c$$$  $        'none',dv4(1),dv4(LEN4)))) go to 9000
c$$$  if(drstest(putdat(lu,d(1,1,1,ielem)))) go to 9000
c$$$  
c$$$  4000 continue
c$$$  
c$$$  if(drstest(cllun(lu))) go to 9000
c     read the variables back
      
      if(drstest(aslun(lu,'dvtest1.dic',lud,'dvtest1.dat',IDRS_READ)))
     $     go to 9000
      if(drstest(cluvdb())) go to 9000
      if(drstest(setname(' ','a',' ',' ',' '))) go to 9000
      if(drstest(setdim(1,'dv1','none ',-1,xa1,xa2)))
     $     go to 9000
      if(drstest(getdat(lu,a2,IDRS_BYTES_PER_WORD*LEN1))) go to 9000
      
      if(drstest(cluvdb())) go to 9000
      if(drstest(setname(' ','b',' ',' ',' '))) go to 9000
      if(drstest(setdim(2,'dv1',
     $     'none',-1,xb21,xb22))) go to 9000
      if(drstest(setdim(1,'dv2',
     $     'none',-1,xb11,xb12))) go to 9000
      if(drstest(getdat(lu,b2,IDRS_BYTES_PER_WORD*LEN1*LEN2)))
     $     go to 9000
      
      if(drstest(cluvdb())) go to 9000
      if(drstest(setname(' ','c',' ',' ',' '))) go to 9000
      if(drstest(setdim(3,'dv1',
     $     'none',-1,xc31,xc32))) go to 9000
      if(drstest(setvdim(1,' ','longitude',' ','lunits',xc11,xc12)))
     $     go to 9000
      if(drstest(setdim(2,'dv3',
     $     'none',-1,xc21,xc22))) go to 9000
      if(drstest(getdat(lu,c2,IDRS_BYTES_PER_WORD*LEN1*LEN2*LEN3)))
     $     go to 9000
      
      if(drstest(getcdim(1,source,name,title,units,dtype,
     $     LEN2,dv2a,retlen))) go to 9000

      j=1
      do 1450 i=ixc11,ixc12
         if(abs(dv2a(j)-real(i)).gt.1.0e-5) then
            write(6,*) 'dv2a does not compare at ',i
            go to 1452
         endif
         j=j+1
 1450 continue
 1452 continue
            
      if(drstest(cluvdb())) go to 9000
      if(drstest(setname(' ','d',' ',' ',' '))) go to 9000
      if(drstest(setdim(4,'dv1',
     $     'none',-1,xd41,xd42))) go to 9000
      if(drstest(setdim(1,'dv2',
     $     'none',-1,xd11,xd12))) go to 9000
      if(drstest(setdim(2,'dv3',
     $     'none',-1,xd21,xd22))) go to 9000
      if(drstest(setdim(3,'dv4',
     $     'none',-1,xd31,xd32))) go to 9000
      if(drstest(getdat(lu,d2,
     $     IDRS_BYTES_PER_WORD*LEN1*LEN2*LEN3*LEN4))) go to 9000
      
#ifndef cray
      if(drstest(getcdim(3,source,name,title,units,dtype,
     $     LEN4,dv4a,retlen))) go to 9000
      
      j=1
      do 1454 i=ixd31,ixd32
         if(dv4a(j).ne.dv4(i)) then
            write(6,*) 'dv1a does not compare at ',i
            go to 1456
         endif
         j=j+1
 1454 continue
 1456 continue

      if(drstest(getedim(3,source,name,title,units,dtype,idv4len,
     $     dv4af,dv4al))) go to 9000
      if(idv4len.ne.retlen .or. dv4af.ne.dv4a(1) .or.
     $     dv4al.ne.dv4a(retlen)) then
         write(6,*) 'error on getedim'
      endif
#endif
c     compare
      

      n=1
      do 1500 i=ixa1,ixa2
         if(a(i).ne.a2(n)) then
            write(6,*) 'a does not compare at',i
            go to 1600
         endif
         n=n+1
 1500 continue
 1600 continue
      n=1
      do 1700 i=ixb21,ixb22
         do 1800 j=ixb11,ixb12
            if(b(j,i).ne.b2(n)) then
               write(6,*) 'b does not compare at', j,i
               go to 1900
            endif
            n=n+1
 1800    continue
 1700 continue
 1900 continue
      n=1
      do 1950 i=ixc31,ixc32
         do 2100 k=ixc21,ixc22
            do 2000 j=ixc11,ixc12
               if(c(j,k,i).ne.c2(n)) then
                  write(6,*) 'c does not compare at',j,k,i
                  go to 2200
               endif
               n=n+1
 2000       continue
 2100    continue
 1950 continue
 2200 continue
      n=1
      do 2300 i=ixd41,ixd42
         do 2600 l=ixd31,ixd32
            do 2500 k=ixd21,ixd22
               do 2400 j=ixd11,ixd12
                  if(d(j,k,l,i).ne.d2(n)) then
                     write(6,*) 'd does not compare at',j,k,l,i
                     go to 2700
                  endif
                  n=n+1
 2400          continue
 2500       continue
 2600    continue
 2300 continue
 2700 continue
      
 9000 continue
      ierr=cllun(lu)
      end
