      program drs_get2a
c     test getting from file where vector is not continuous
c     get two interlaced variables
c     AND dimensions 1 and 2 are transposed
      
#include "drsdef.h"
      parameter (LEN1=4, LEN2=5, LEN3=12)
      
      integer ibuf(LEN2,LEN1,LEN3)
      integer aslun, cllun
      integer getdat
      integer setdim
      integer cluvdb
c      integer seterr
      integer setname

      character*40 datfil,dicfil
      
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
      data dim1/LEN1/,dim2/LEN2/,dim3/LEN3/
      data df1/-180./,dl1/175./
      data df2/1./,dl2/1./
      data df3/1./,dl3/12./
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

      df2=-90.
      dl2=90.
      ierr=cluvdb()
c      call putnam (source,name,title,units,date,time,type)
      ierr=setname (source,name,title,units,type)
c      call putdim (1,dna2,dun2,dim2,df2,dl2,ierr)      
      ierr=setdim (1,dna2,dun2,dim2,df2,dl2)      
      if (ierr.ne.0) write (6,92) ierr
 92   format (' putdim error ',i4)
c      call putdim (2,dna1,dun1,dim1,df1,dl1,ierr)
      ierr=setdim (2,dna1,dun1,dim1,df1,dl1)
      if (ierr.ne.0) write (6,92) ierr
c      call putdim (3,dna3,dun3,dim3,df3,dl3,ierr)
      ierr=setdim (3,dna3,dun3,dim3,df3,dl3)
      if (ierr.ne.0) write (6,92) ierr
      
      ierr= getdat(lud,ibuf,IDRS_BYTES_PER_WORD*LEN1*LEN2*LEN3)
      if (ierr.ne.0) then
         write (6,*) 'error ',ierr,' getting slp'
      else
         write (6,'(I5)')
     $        (((ibuf(i,j,k), j=1,LEN1), i=1,LEN2), k=1,LEN3)
      endif
      
      ierr=cluvdb()
c      call putnam(' ','varb',' ',' ',' ',' ',' ')
      ierr=setname(' ','varb',' ',' ',' ')
c      call putdim (1,dna2,dun2,dim2,df2,dl2,ierr)      
      ierr=setdim (1,dna2,dun2,dim2,df2,dl2)      
      if (ierr.ne.0) write (6,93) ierr
 93   format (' putdim error on slp',i4)
c      call putdim (2,dna1,dun1,dim1,df1,dl1,ierr)
      ierr=setdim (2,dna1,dun1,dim1,df1,dl1)
      if (ierr.ne.0) write (6,93) ierr
      ierr= getdat(lud,ibuf,IDRS_BYTES_PER_WORD*LEN1*LEN2*LEN3)

      if (ierr.ne.0) then
         write (6,*) 'error ',ierr,' getting varb'
      else
         write (6,'(I5)')
     $        (((ibuf(i,j,k), j=1,LEN1), i=1,LEN2), k=1,LEN3)
      endif

      ierr=cllun(lud)
c      stop
      end
