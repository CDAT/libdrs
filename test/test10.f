c     write four vars, read, and compare
      program test10
      
      include 'drsdefv.h'
      
      parameter(LEN1=4,LEN2=5,LEN3=6,LEN4=7)
      
      dimension a(LEN1),b(LEN1,LEN2),c(LEN1,LEN2,LEN3),
     $     d(LEN1,LEN2,LEN3,LEN4),dv1(LEN1),dv2(LEN2),
     $     dv3(LEN3),dv4(LEN4)
      dimension a2(LEN1),b2(LEN1,LEN2),c2(LEN1,LEN2,LEN3),
     $     d2(LEN1,LEN2,LEN3,LEN4)
      character*8 date,time
      data date/'10/31/89'/,time/'15:17:00'/
      integer lu,lud
      data lu/2/,lud/3/

      integer drserr,aslun,cluvdb,setname,putvdim,
     $     setvdim,putdat,setdim,cllun,getdat,drsautosync
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
      do 700 j=1,LEN2
         do 600 i=1,LEN1
            b(i,j)=counter
            counter=counter+1.0
 600     continue
 700  continue
      
      counter=301.0
      do 1000 k=1,LEN3
         do 900 j=1,LEN2
            do 800 i=1,LEN1
               c(i,j,k)=counter
               counter=counter+1.0
 800        continue
 900     continue
 1000 continue
      
      counter=401.0
      do 1400 l=1,LEN4
         do 1300 k=1,LEN3
            do 1200 j=1,LEN2
               do 1100 i=1,LEN1
                  d(i,j,k,l)=counter
                  counter=counter+1.0
 1100          continue
 1200       continue
 1300    continue
 1400 continue
c      ierr=seterr(6,IDRS_WARNING)
      
      if(drserr(aslun(lu,'dvtest1',lud,' ',
     $     IDRS_CREATE)).ne.
     $     IDRS_SUCCESS) go to 9000
      
      if(drstest(drsautosync(lu,IDRS_SYNC_OFF))) go to 9000
c     write the dimension variables
      if(drserr(cluvdb()).ne.IDRS_SUCCESS) go to 9000
      if(drserr(setname('test10','dv1','dimension variable 1',
     $     'none',' ')).ne.IDRS_SUCCESS) go to 9000
      ierr=setdate(date,time)      
      if(drserr(putvdim(lu,LEN1,dv1,idv1a,idv1b)).ne.IDRS_SUCCESS)
     $     go to 9000
      
      if(drserr(cluvdb()).ne.IDRS_SUCCESS) go to 9000
      if(drserr(setname('test10','dv2','dimension variable 2',
     $     'none',' ')).ne.IDRS_SUCCESS) go to 9000
      ierr=setdate(date,time)      
      if(drserr(putvdim(lu,LEN2,dv2,idv2a,idv2b)).ne.IDRS_SUCCESS)
     $     go to 9000
      
      
      if(drserr(cluvdb()).ne.IDRS_SUCCESS) go to 9000
      if(drserr(setname('test10','dv3','dimension variable 3',
     $     'none',' ')).ne.IDRS_SUCCESS) go to 9000
      ierr=setdate(date,time)      
      if(drserr(putvdim(lu,LEN3,dv3,idv3a,idv3b)).ne.IDRS_SUCCESS)
     $     go to 9000
      
      
      if(drserr(cluvdb()).ne.IDRS_SUCCESS) go to 9000
      if(drserr(setname('test10','dv4','dimension variable 4',
     $     'none',' ')).ne.IDRS_SUCCESS) go to 9000
      ierr=setdate(date,time)      
      if(drserr(putvdim(lu,LEN4,dv4,idv4a,idv4b)).ne.IDRS_SUCCESS)
     $     go to 9000
      
      
c     write the variables
      
      if(drserr(cluvdb()).ne.IDRS_SUCCESS) go to 9000
      if(drserr(setname('test10','a','data variable a',
     $     'aunits',' ')).ne.IDRS_SUCCESS) go to 9000
      if(drserr(setvdim(1,'test10 ','dv1',
     $     'dimension variable 1 ','none ',dv1(1),dv1(LEN1))).ne.
     $     IDRS_SUCCESS) go to 9000
      if(drserr(putdat(lu,a)).ne.0) go to 9000
      
      
      if(drserr(cluvdb()).ne.IDRS_SUCCESS) go to 9000
      if(drserr(setname('test10','b','data variable b',
     $     'bunits',' ')).ne.IDRS_SUCCESS) go to 9000
      if(drserr(setvdim(1,'test10','dv1','dimension variable 1',
     $     'none',dv1(1),dv1(LEN1))).ne.
     $     IDRS_SUCCESS) go to 9000
      if(drserr(setvdim(2,'test10','dv2','dimension variable 2','none',
     $     dv2(1),dv2(LEN2))).ne.
     $     IDRS_SUCCESS) go to 9000
      ierr=setdate(date,time)      
      if(drserr(putdat(lu,b)).ne.0) go to 9000
      
      if(drserr(cluvdb()).ne.IDRS_SUCCESS) go to 9000
      if(drserr(setname('test10','c','data variable c',
     $     'cunits',' ')).ne.IDRS_SUCCESS) go to 9000
      if(drserr(setvdim(1,'test10','dv1','dimension variable 1','none',
     $     dv1(1),dv1(LEN1))).ne.
     $     IDRS_SUCCESS) go to 9000
      if(drserr(setdim(2,'longitude','lunits',LEN2,1.0,real(LEN2)))
     $     .ne.IDRS_SUCCESS) go to 9000
      if(drserr(setvdim(3,'test10','dv3','dimension variable 3','none',
     $     dv3(1),dv3(LEN3))).ne.
     $     IDRS_SUCCESS) go to 9000
      ierr=setdate(date,time)      
      if(drserr(putdat(lu,c)).ne.0) go to 9000
      
      if(drserr(cluvdb()).ne.IDRS_SUCCESS) go to 9000
      if(drserr(setname('test10','d','data variable d',
     $     'dunits',' ')).ne.IDRS_SUCCESS) go to 9000
      if(drserr(setvdim(1,'test10','dv1','dimension variable 1','none',
     $     dv1(1),dv1(LEN1))).ne.
     $     IDRS_SUCCESS) go to 9000
      if(drserr(setvdim(2,'test10','dv2','dimension variable 2','none',
     $     dv2(1),dv2(LEN2))).ne.
     $     IDRS_SUCCESS) go to 9000
      if(drserr(setvdim(3,'test10','dv3','dimension variable 3','none',
     $     dv3(1),dv3(LEN3))).ne.
     $     IDRS_SUCCESS) go to 9000
      if(drserr(setvdim(4,'test10','dv4','dimension variable 4','none',
     $     dv4(1),dv4(LEN4))).ne.
     $     IDRS_SUCCESS) go to 9000
      ierr=setdate(date,time)      
      if(drserr(putdat(lu,d)).ne.0) go to 9000
      
      if(drserr(cllun(lu)).ne.IDRS_SUCCESS) go to 9000
c     read the variables back
      
      if(drserr(aslun(lu,'dvtest1',lud,'dvtest1',
     $     IDRS_READ)).ne.
     $     IDRS_SUCCESS) go to 9000
      if(drserr(cluvdb()).ne.IDRS_SUCCESS) go to 9000
      if(drserr(setname(' ','a',' ',' ',' ')).ne.IDRS_SUCCESS)
     $     go to 9000
      if(drserr(getdat(lu,a2,IDRS_BYTES_PER_WORD*LEN1))
     $     .ne.IDRS_SUCCESS) go to 9000
      
      if(drserr(cluvdb()).ne.IDRS_SUCCESS) go to 9000
      if(drserr(setname(' ','b',' ',' ',' ')).ne.IDRS_SUCCESS)
     $     go to 9000
      if(drserr(getdat(lu,b2,IDRS_BYTES_PER_WORD*LEN1*LEN2)).ne.
     $     IDRS_SUCCESS) go to 9000
      
      if(drserr(cluvdb()).ne.IDRS_SUCCESS) go to 9000
      if(drserr(setname(' ','c','data variable c',' ',' ')).ne.
     $     IDRS_SUCCESS)
     $     go to 9000
      if(drserr(getdat(lu,c2,IDRS_BYTES_PER_WORD*LEN1*LEN2*LEN3)).ne.
     $     IDRS_SUCCESS) go to 9000
      
      if(drserr(cluvdb()).ne.IDRS_SUCCESS) go to 9000
      if(drserr(setname(' ','d','data variable d',' ',' ')).ne.
     $     IDRS_SUCCESS)
     $     go to 9000
      if(drserr(getdat(lu,d2,
     $     IDRS_BYTES_PER_WORD*LEN1*LEN2*LEN3*LEN4)).ne.
     $     IDRS_SUCCESS) go to 9000
      
      
c     compare
      
      do 1500 i=1,LEN1
         if(a(i).ne.a2(i)) then
            write(6,*) 'a does not compare at',i
            go to 1600
         endif
 1500 continue
 1600 continue
      do 1800 j=1,LEN2
         do 1700 i=1,LEN1
            if(b(i,j).ne.b2(i,j)) then
               write(6,*) 'b does not compare at', i,j
               go to 1900
            endif
 1700    continue
 1800 continue
 1900 continue
      do 2100 k=1,LEN3
         do 2000 j=1,LEN2
            do 1950 i=1,LEN1
               if(c(i,j,k).ne.c2(i,j,k)) then
                  write(6,*) 'c does not compare at',i,j,k
                  go to 2200
               endif
 1950       continue
 2000    continue
 2100 continue
 2200 continue
      do 2600 l=1,LEN4
         do 2500 k=1,LEN3
            do 2400 j=1,LEN2
               do 2300 i=1,LEN1
                  if(d(i,j,k,l).ne.d2(i,j,k,l)) then
                     write(6,*) 'd does not compare at',i,j,k,l
                     go to 2700
                  endif
 2300          continue
 2400       continue
 2500    continue
 2600 continue
 2700 continue
      
 9000 continue
      end
