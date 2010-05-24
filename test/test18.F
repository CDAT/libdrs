c     test getslab
      program test18
      
#include "drsdef.h"
      
      integer R,ret1,ret2,ret3
      parameter (L1=31,L2=2,L3=13,R=3)
      parameter(LEN1=12,LEN2=15,LEN3=18,LEN4=21)
      
      dimension cc(L1,L2,L3)
      dimension c(LEN1,LEN2,LEN3)
      dimension dvar1(L1), dvar1b(L1)
      dimension dvar2(L2), dvar2b(L2)
      dimension dvar3(L3), dvar3b(L3)
c$$$      integer rank /R/
c$$$      integer order(R) /2,3,1/
c$$$      real fe(R) /-10.,13.,1./
c$$$      real le(R) /20.,15.,25./
c$$$      real cycle(R) /15.,0.0,24./
c$$$      real fe2(R) /20.,13.,25./
c$$$      real le2(R) /-10.,15.,1./
c$$$      integer datadim(R)/L1,L2,L3/
c$$$      integer lu/2/,lud/3/,dtype
      integer rank
      data rank/R/
      integer order(R)
      data order/2,3,1/
      real fe(R)
      data fe/-10.,13.,1./
      real le(R)
      data le/20.,15.,25./
      real cycle(R)
      data cycle/15.,0.0,24./
      real fe2(R)
      data fe2/20.,13.,25./
      real le2(R)
      data le2 /-10.,15.,1./
      integer datadim(R)
      data datadim/L1,L2,L3/
      integer lu,lud,dtype
      data lu/2/,lud/3/
      integer aslun,setname,getslab,cllun,cluvdb,getcdim,getedim
      logical drstest
      character*120 source
      character*80 title
      character*16 name
      character*40 units
      
      counter=301.0
      do 1000 k=1,LEN3
         do 900 j=1,LEN2
            do 800 i=1,LEN1
               c(i,j,k)=counter
               counter=counter+1.0
 800        continue
 900     continue
 1000 continue
      
      counter=fe(1)
      do 1050 i=1,L1
         dvar1b(i)=counter
         counter=counter+1.0
 1050 continue

      counter=fe(2)
      do 1060 i=1,L2
         dvar2b(i)=counter
         counter=counter+2.0
 1060 continue

      counter=fe(3)
      do 1070 i=1,L3
         dvar3b(i)=counter
         counter=counter+2.0
 1070 continue
      if(drstest(aslun(lu,'dvtest1.dic',lud,'dvtest1.dat',IDRS_READ)))
     $     go to 9000
      
      
      ierr=setname(' ','c',' ',' ',' ')
      if(getslab(lu,rank,order,fe,le,cycle,cc,datadim).ne.0) then
         write (6,*)'Error getting hyperslab'
#ifdef cray
         call abort()
#else !cray
      call exit(1)
#endif
      endif
      
      do 1300 k=1,L3
         do 1200 j=1,L2
            do 1100 i=1,L1
               ii=mod(k-1,LEN1)+1
               jj=mod(i+3,LEN2)+1
               kk=j+1
               if(cc(i,j,k).ne.c(ii,jj,kk)) then
                  write(6,*) 'error: cc(',i,j,k,') != c(',ii,jj,kk,')'
#ifdef cray
                  call abort()
#else !cray
      call exit(1)
#endif
               endif
 1100       continue
 1200    continue
 1300 continue
                  
      write (6,'(F11.3)') cc

      if(getcdim(1,source,name,title,
     $     units,dtype,L1,dvar1,ret1).ne.0) then
         write(6,*) 'Error getting dvar1'
#ifdef cray
         call abort()
#else !cray
      call exit(1)
#endif
      endif
      do 2350 i=1,L1
         if(abs(dvar1(i)-dvar1b(i)).gt.1.0e-5) then
            write(6,*) 'Error: dimvar1(',i,')=',dvar1(i),', !=',
     $           dvar1b(i)
#ifdef cray
            call abort()
#else !cray
      call exit(1)
#endif
         endif
 2350 continue

      if(drstest(getedim(1,source,name,title,units,dtype,
     $     idv1len,dv1f,dv1l))) go to 9000

      if(idv1len.ne.ret1 .or. abs(dv1f-dvar1(1)).gt.1.0e-5
     $     .or. abs(dv1l-dvar1(ret1)).gt.1.0e-5) then
         write(6,*) 'Error on getedim of dim 1'
      endif

      if(getcdim(2,source,name,title,units,dtype,L2,dvar2,ret2).ne.0)
     $     then
         write(6,*) 'Error getting dvar2'
#ifdef cray
         call abort()
#else !cray
      call exit(1)
#endif
      endif
      do 2360 i=1,L2
         if(abs(dvar2(i)-dvar2b(i)).gt.1.0e-5) then
            write(6,*) 'Error: dimvar2(',i,')=',dvar2(i),', !=',
     $           dvar2b(i)
#ifdef cray
            call abort()
#else !cray
      call exit(1)
#endif
         endif
 2360 continue

      if(drstest(getedim(2,source,name,title,units,dtype,
     $     idv2len,dv2f,dv2l))) go to 9000

      if(idv2len.ne.ret2 .or. abs(dv2f-dvar2(1)).gt.1.0e-5
     $     .or. abs(dv2l-dvar2(ret2)).gt.1.0e-5) then
         write(6,*) 'Error on getedim of dim 2'
      endif

       if(getcdim(3,source,name,title,units,
     $     dtype,L3,dvar3,ret3).ne.0) then
         write(6,*) 'Error getting dvar3'
#ifdef cray
         call abort()
#else !cray
      call exit(1)
#endif
      endif
      do 2370 i=1,L3
         if(abs(dvar3(i)-dvar3b(i)).gt.1.0e-5) then
            write(6,*) 'Error: dimvar3(',i,')=',dvar3(i),', !=',
     $           dvar3b(i)
#ifdef cray
            call abort()
#else !cray
      call exit(1)
#endif
         endif
 2370 continue

      if(drstest(getedim(3,source,name,title,units,dtype,
     $     idv3len,dv3f,dv3l))) go to 9000

      if(idv3len.ne.ret3 .or. abs(dv3f-dvar3(1)).gt.1.0e-5
     $     .or. abs(dv3l-dvar3(ret3)).gt.1.0e-5) then
         write(6,*) 'Error on getedim of dim 3'
      endif

      ierr=cluvdb()
      ierr=setname(' ','c',' ',' ',' ')
      if(getslab(lu,rank,order,fe2,le2,cycle,cc,datadim).ne.0) then
         write (6,*)'Error getting hyperslab'
#ifdef cray
         call abort()
#else !cray
      call exit(1)
#endif
      endif
               
      do 2300 k=1,L3
         do 2200 j=1,L2
            do 2100 i=1,L1
               ii=mod(k-1,LEN1)+1
               jj=mod(i+3,LEN2)+1
               kk=j+1
               if(cc(L1-i+1,j,L3-k+1).ne.c(ii,jj,kk)) then
                  write(6,*) 'error: cc(',L1-i+1,j,L3-k+1,
     $                 ') != c(',ii,jj,kk,')'
#ifdef cray
                  call abort()
#else !cray
      call exit(1)
#endif
               endif
 2100       continue
 2200    continue
 2300 continue

      write (6,'(F11.3)') cc
      if(getcdim(1,source,name,title,units,dtype,L1,dvar1,ret1).ne.0)
     $     then
         write(6,*) 'Error getting dvar1'
#ifdef cray
         call abort()
#else !cray
      call exit(1)
#endif
      endif
      do 2450 i=1,L1
         if(abs(dvar1(i)-dvar1b(L1-i+1)).gt.1.0e-5) then
            write(6,*) 'Error: dimvar1(',i,')=',dvar1(i),', !=',
     $           dvar1b(i)
#ifdef cray
            call abort()
#else !cray
      call exit(1)
#endif
         endif
 2450 continue

      if(drstest(getedim(1,source,name,title,units,dtype,
     $     idv1len,dv1f,dv1l))) go to 9000

      if(idv1len.ne.ret1 .or. abs(dv1f-dvar1(1)).gt.1.0e-5
     $     .or. abs(dv1l-dvar1(ret1)).gt.1.0e-5) then
         write(6,*) 'Error on getedim of dim 1'
      endif

      if(getcdim(2,source,name,title,units,dtype,L2,dvar2,ret2).ne.0)
     $     then
         write(6,*) 'Error getting dvar2'
#ifdef cray
         call abort()
#else !cray
      call exit(1)
#endif
      endif
      do 2460 i=1,L2
         if(abs(dvar2(i)-dvar2b(i)).gt.1.0e-5) then
            write(6,*) 'Error: dimvar2(',i,')=',dvar2(i),', !=',
     $           dvar2b(i)
#ifdef cray
            call abort()
#else !cray
      call exit(1)
#endif
         endif
 2460 continue

      if(drstest(getedim(2,source,name,title,units,dtype,
     $     idv2len,dv2f,dv2l))) go to 9000

      if(idv2len.ne.ret2 .or. abs(dv2f-dvar2(1)).gt.1.0e-5
     $     .or. abs(dv2l-dvar2(ret2)).gt.1.0e-5) then
         write(6,*) 'Error on getedim of dim 2'
      endif

       if(getcdim(3,source,name,title,units,dtype,L3,dvar3,ret3).ne.0)
     $     then
         write(6,*) 'Error getting dvar3'
#ifdef cray
         call abort()
#else !cray
      call exit(1)
#endif
      endif
      do 2470 i=1,L3
         if(abs(dvar3(i)-dvar3b(L3-i+1)).gt.1.0e-5) then
            write(6,*) 'Error: dimvar3(',i,')=',dvar3(i),', !=',
     $           dvar3b(i)
#ifdef cray
            call abort()
#else !cray
      call exit(1)
#endif
         endif
 2470 continue

      if(drstest(getedim(3,source,name,title,units,dtype,
     $     idv3len,dv3f,dv3l))) go to 9000

      if(idv3len.ne.ret3 .or. abs(dv3f-dvar3(1)).gt.1.0e-5
     $     .or. abs(dv3l-dvar3(ret3)).gt.1.0e-5) then
         write(6,*) 'Error on getedim of dim 3'
      endif

      ierr=cllun(2)
 9000 continue
      end






