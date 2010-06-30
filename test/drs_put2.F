      program drs_put2
c     write two arrays interleaved: twelve parts of 4x5x20 var

#include "drsdef.h"
      parameter (LEN1=4, LEN2=5)
      
      integer ibuf(LEN1,LEN2)
      integer ibufb(LEN1,LEN2)
      character*40 datfil,dicfil
c      integer system
      integer aslun
      integer putdat
      integer setdim
      integer cllun
      integer cluvdb
c      integer seterr
      integer setname
      integer setdate
      
      data datfil/'dbwrt2.dat'/
      data dicfil/'dbwrt2.dic'/
      data lu/3/,lud/2/
      character*16 dna1,dna2,dna3
      data dna1/'longitude'/
      data dna2/'latitude '/
      data dna3/'month    '/
      character*40 dun1,dun2,dun3
      data dun1/'degrees '/
      data dun2/'degrees '/
      data dun3/'        '/
      character dum
      data dum /' '/
      integer dim1,dim2,dim3
      data dim1/LEN1/,dim2/LEN2/,dim3/1/
      data df1/-180./,dl1/175./
      data df2/1./,dl2/1./
      data df3/1./,dl3/1./
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
c      ierr=system("rm -f dbwrt2.dic")
c      ierr=system("rm -f dbwrt2.dat")
      
c      ierr=seterr(6,.true.)
c     write first block of slp and varb
      print*, 'ok first drs call: ',lud,dicfil,lu,datfil,IDRS_CREATE
      ierr=aslun (lud,dicfil,lu,datfil,IDRS_CREATE)
      if (ierr.gt.0) then
         write (6,90) ierr
 90      format (' aslun error',i4)
         stop
      endif
      ia=1
      k=1
      df3=k
      dl3=k
      df2=-90.
      dl2=90.
      ierr=cluvdb()
c      call putnam (source,name,title,units,dum,dum,type)
      ierr=setname(source,name,title,units,type)
c      call putdim (1,dna1,dun1,dim1,df1,dl1,ierr)
      ierr= setdim (1,dna1,dun1,dim1,df1,dl1)
      if (ierr.ne.0) write (6,92) ierr
 92   format (' putdim error ',i4)
c      call putdim (2,dna2,dun2,dim2,df2,dl2,ierr)
      ierr=setdim (2,dna2,dun2,dim2,df2,dl2)
      if (ierr.ne.0) write (6,92) ierr
c      call putdim (3,dna3,dun3,dim3,df3,dl3,ierr)
      ierr=setdim (3,dna3,dun3,dim3,df3,dl3)
      if (ierr.ne.0) write (6,92) ierr
      ktr=0
      do 105 j=1,LEN2
         do 100 i=1,LEN1
            ibuf(i,j)=ktr
            ktr= ktr+1
 100     continue
 105  continue
      do 115 j=1,LEN2
         do 110 i=1,LEN1
            ibufb(i,j)=ktr
            ktr=ktr+1
 110     continue
 115  continue
      ierr=setdate(date,time)      
      ierr= putdat (lud,ibuf)
      if (ierr.ne.0) then
         write (6,93) ierr
 93      format (' putdat error ',i4)
         stop
      endif
      
      ierr=cluvdb()
c      call putnam (source,'varb',title,units,dum,dum,type)
      ierr=setname (source,'varb',title,units,type)
c      call putdim (1,dna1,dun1,dim1,df1,dl1,ierr)
      ierr=setdim (1,dna1,dun1,dim1,df1,dl1)
      if (ierr.ne.0) write (6,92) ierr
c      call putdim (2,dna2,dun2,dim2,df2,dl2,ierr)
      ierr=setdim (2,dna2,dun2,dim2,df2,dl2)
      if (ierr.ne.0) write (6,92) ierr
c      call putdim (3,dna3,dun3,dim3,df3,dl3,ierr)
      ierr=setdim (3,dna3,dun3,dim3,df3,dl3)
      if (ierr.ne.0) write (6,92) ierr
      
      ierr=setdate(date,time)      
      ierr= putdat (lud,ibufb)
      if (ierr.ne.0) then
         write (6,93) ierr
         stop
      endif
      
      ierr= cllun (lud)
      ierr= aslun (lud,dicfil,lu,datfil,IDRS_EXTEND)
      if (ierr.gt.0) then
         write (6,90) ierr
         stop
      endif
      
c     now add twelve new blocks
      
      do 205 k=2,12
         df3=k
         dl3=k
         df2=-90.
         dl2=90.
         do 215 j=1,LEN2
            do 210 i=1,LEN1
               ibuf(i,j)=ktr
               ktr= ktr+1
 210        continue
 215     continue
         do 225 j=1,LEN2
            do 220 i=1,LEN1
               ibufb(i,j)=ktr
               ktr=ktr+1
 220        continue
 225     continue
         ierr=cluvdb()
c         call putnam (source,name,title,units,dum,dum,type)
         ierr=setname (source,name,title,units,type)
c         call putdim (1,dna1,dun1,dim1,df1,dl1,ierr)
         ierr=setdim (1,dna1,dun1,dim1,df1,dl1)
         if (ierr.ne.0) write (6,92) ierr
c         call putdim (2,dna2,dun2,dim2,df2,dl2,ierr)
         ierr=setdim (2,dna2,dun2,dim2,df2,dl2)
         if (ierr.ne.0) write (6,92) ierr
c         call putdim (3,dna3,dun3,dim3,df3,dl3,ierr)
         ierr=setdim (3,dna3,dun3,dim3,df3,dl3)
         if (ierr.ne.0) write (6,92) ierr
      ierr=setdate(date,time)      
         ierr= putdat (lud,ibuf)
         if (ierr.ne.0) then
            write (6,93) ierr
            stop
         endif
         
         ierr=cluvdb()
c         call putnam (source,'varb',title,units,dum,dum,type)
         ierr=setname (source,'varb',title,units,type)
c         call putdim (1,dna1,dun1,dim1,df1,dl1,ierr)
         ierr=setdim (1,dna1,dun1,dim1,df1,dl1)
         if (ierr.ne.0) write (6,92) ierr
c         call putdim (2,dna2,dun2,dim2,df2,dl2,ierr)
         ierr=setdim (2,dna2,dun2,dim2,df2,dl2)
         if (ierr.ne.0) write (6,92) ierr
c         call putdim (3,dna3,dun3,dim3,df3,dl3,ierr)
         ierr=setdim (3,dna3,dun3,dim3,df3,dl3)
         if (ierr.ne.0) write (6,92) ierr
      ierr=setdate(date,time)      
         ierr= putdat (lud,ibufb)
         if (ierr.ne.0) then
            write (6,93) ierr
            stop
         endif
 205  continue
      
      
      ierr=cllun(lud)
c      stop
c
      end


