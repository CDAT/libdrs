      program drs_put3
c     Test second instance stuff: write a 2-d var, one element at a time
      
#include "drsdef.h"
      parameter (LEN1=4, LEN2=5)
      
      integer ibuf(LEN1,LEN2)
      character*40 datfil,dicfil
c      integer system
      integer aslun
      integer putdat
      integer setdim
      integer cluvdb
c      integer seterr
      integer setname
      integer setdate
      integer cllun
      
      data datfil/'dbwrt3.dat'/
      data dicfil/'dbwrt3.dic'/
      data lu/3/,lud/2/
      character*16 dna1,dna2
      data dna1/'longitude'/
      data dna2/'latitude '/
      
      character*40 dun1,dun2
      data dun1/'degrees '/
      data dun2/'degrees '/
      
      character dum
      data dum /' '/
      integer dim1,dim2
      data dim1/LEN1/,dim2/LEN2/
      
      character*120 source
      data source/'cgcm83az  coupled nuclear war experiment'/
      character*10 name
      data name/'slp'/
      character*80 title
      data title/'sea level pressure'/
      character*40 units
      data units/'mb'/
      character*8 date,time
      data date/'7/25/84 '/,time/'11:05:30'/
      character*8 type
#ifdef cray
      data type/'I*8'/
#else !cray
      data type/'I*4'/
#endif
c     remove dat and dic files
c      ierr=system("rm -f dbwrt3.dic")
c      ierr=system("rm -f dbwrt3.dat")
      
c      ierr=seterr(6,.true.)
      ierr= aslun (lud,dicfil,lu,datfil,IDRS_CREATE)
      if (ierr.gt.0) then
         write (6,90) ierr
 90      format (' aslun error',i4)
         stop
      endif
      
      ktr=0
      do 105 j=1,LEN2
         do 100 i=1,LEN1
            ibuf(i,j)=ktr
            ktr= ktr+1
 100     continue
 105  continue
      
      dincr1=360.0/LEN1
      dincr2=180.0/LEN2
      df2=-90.0
      
      do 200 j=1,LEN2
         dl2=df2
         df1=-180.0
         do 205 i=1,LEN1
            dl1=df1
            
            ierr=cluvdb()
c            call putnam (source,name,title,units,date,time,type)
            ierr=setname (source,name,title,units,type)
            ierr=setdate(date,time)
c            call putdim (1,dna1,dun1,1,df1,dl1,ierr)
            ierr=setdim (1,dna1,dun1,1,df1,dl1)
            if (ierr.ne.0) write (6,92) ierr
 92         format (' putdim error ',i4)
c            call putdim (2,dna2,dun2,1,df2,dl2,ierr)
            ierr=setdim (2,dna2,dun2,1,df2,dl2)
            if (ierr.ne.0) write (6,92) ierr
            
            ierr= putdat (lud,ibuf(i,j))
            if (ierr.ne.0) then
               write (6,93) ierr
 93            format (' putdat error ',i4)
               stop
            endif
            
            df1=df1+dincr1
            
 205     continue
         df2=df2+dincr2
 200  continue
      ierr=cllun(lud)
c      stop
c     
      end
