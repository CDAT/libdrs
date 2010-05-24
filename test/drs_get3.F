      program drs_get3
c     Test reading second instance stuff: read 4x5 var
      
#include "drsdef.h"
      parameter (LEN1=4, LEN2=5)
      
      integer ibuf(LEN1,LEN2)
      integer aslun, cllun
      integer getdat
      integer setdim
      integer cluvdb
c      integer seterr
      integer setname
      character*40 datfil,dicfil
      
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
      
c      ierr=seterr(6,.true.)
      ierr= aslun (lud,dicfil,lu,datfil,IDRS_READ)
      if (ierr.gt.0) then
         write (6,90) ierr
 90      format (' aslun error',i4)
         stop
      endif
      
      ierr=cluvdb()
c      call putnam (source,name,title,units,date,time,type)
      ierr=setname (source,name,title,units,type)
c      call putdim (1,dna1,dun1,LEN1,-180.0,90.0,ierr)
      ierr=setdim (1,dna1,dun1,LEN1,-180.0,90.0)
      if (ierr.ne.0) write (6,92) ierr
 92   format (' putdim error ',i4)
c      call putdim (2,dna2,dun2,LEN2,-90.0,54.0,ierr)
      ierr=setdim (2,dna2,dun2,LEN2,-90.0,54.0)
      if (ierr.ne.0) write (6,92) ierr
      
      ierr= getdat (lud,ibuf,IDRS_BYTES_PER_WORD*LEN1*LEN2)
      if (ierr.ne.0) then
         write (6,93) ierr
 93      format (' getdat error ',i4)
      else
         write(6,'(I5)') ibuf
      endif
      ierr=cllun(lud)
c      stop
c     
      end
