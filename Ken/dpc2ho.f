c
c  2009 October 21: Calculate pattern correlations
cjfp 2011 Jan 3: changed cw_ to fcw_, and related changes
c
c  to compile:
c
c  f77 -g -e drs_pat_cor_2d_hov.f -L/pcmdi/cirrus/netcdf-2.3.2/libsrc -L/usr/local/lib -lcdms -lnetcdf -L/usr/local/src/hdf/HDF4.0r2/lib -lmfhdf -ldf -ljpeg -lz -lnsl -L/pcmdi/cirrus/drs_solaris -ldrs -lnsl -lF77 -lc -lm -lsunmath -o drs_pat_cor_2d_hov
c
c  f77 -g -e drs_pat_cor_2d_hov.f -L/home/andy/pcmdi/drs/lib -ldrs -o drs_pat_cor_2d_hov
c
c   THE PROGRAM HANDLES GAUSSIAN AND EVENLY SPACED GRIDS!!!!!!
c
      program drs_pat_cor_2d_hov
      include '../lib/drsdef.h'
c
c 0-360 degrees
      parameter(nlon=144,ntot=10394)
c  0E-150W
c      parameter(nlon=85,ntot=10394)
c 30E-150W
c      parameter(nlon=73,ntot=10394)
c
      real*8    x8(nlon*ntot),y8(nlon*ntot)
      real*8    x8_old(nlon),x8_new(nlon),y8_old(nlon),y8_new(nlon)
      real*8    slope1,yint1,F,R,xrmse
      real*8    clock, clockstart
cjfp N.B. most data in files is float (real*4).  The C DRS wrappers are not good at doing conversions
cjfp between float and double (real*8)!
      real*4  din(nlon),ddep(nlon),times(ntot)
      integer*4 aslun,cllun,setname,getname,getdat,putvdim,cluvdb,
     *          getedim,setdim,setvdim,putdat
      integer*4 fcw_aslun,fcw_cllun,fcw_setname,fcw_getname,fcw_getdat,
     *     fcw_putvdim, fcw_cluvdb,fcw_getedim,fcw_setdim,fcw_setvdim,
     *     fcw_putdat
c
      character*120 vsource(40),vsourcein1,vsourcein2,vsourceout1,
     &     vsourceout2
      character*120 vsource1d,vsource2d,vsource3d,vsourcetd
      character*16  vname(40),vnamein,vname1d,vname2d,vname3d,vnametd
      character*80  vtitle(40),vtitlein,vtitle1d,vtitle2d,vtitle3d,
     &     vtitletd
      character*40  vun(40),vunin,vun1d,vun2d,vun3d,vuntd
      character*8   vdate(40),vdatein,vdate1d,vdate2d,vdate3d,vdatetd
      character*8   vtime(40),vtimein,vtime1d,vtime2d,vtime3d,vtimetd
      character*8   vtype(40),vtypein,vtype1d,vtype2d,vtype3d,vtypetd
      integer*4     numdim(40),numdimin,numdim1d,numdim2d,numdim3d,
     &     numdimtd
c     
cjfp was      double precision xlonmin, xlonmax
      real*4 xlonmin, xlonmax
      character*200 filein,fileout
c     added by jfp to prefent Valgrind memory error in test  (din(1) .lt. 9.9 e19)...
      din(1) = 1.0e20

      call cpu_time(clockstart)
c     
c     name of drs file to open
c     
      print*,' DRS file with reconstructed data?'
cjfp      read(5,*) filein
      filein = "olr_15N_15S_eof_olr_79_07_20_100_25N_25S_3D_lsfit_pc1_4"
      idicfillen = 55
      write(6,*) filein
c
cjfp      ierr=fcw_aslun(7,filein,8,' ',IDRS_READ,55,1)
      ierr=fcw_aslun(7,filein,8,' ',IDRS_READ)
c
      print *,'Name of X variable?'
cjfp      read(5,*) vname(1)
      vname(1) = "rlt_bpf"
      write(6,*) vname(1)
c
      print*,' DRS file with validation data?'
cjfp      read(5,*) filein
      filein = "olr_daily_79_07_20_100_15N_15S"
      idicfillen = 30
      write(6,*) filein
c
cjfp      ierr=fcw_aslun(9,filein,10,' ',IDRS_READ,55,1)
      ierr=fcw_aslun(9,filein,10,' ',IDRS_READ)
c
      print *,'Name of Y variable?'
cjfp      read(5,*) vname(2)
      vname(2) = "rlt_bpf"
      write(6,*) vname(2)
c
c      write(6,111)
c111   format(' If Latitude EVENLY Spaced Enter 0, Else Enter 1?')
c      read(5,*) nspace
c      write(6,*) nspace
c     
      print *,'MIN and MAX Longitudes (0-360)?'
cjfp      read(5,*) xlonmin, xlonmax
      xlonmin = 0.
      xlonmax = 360.
      write(6,*) xlonmin, xlonmax
c
c      print*,' Output file to create?'
c      read(5,*) fileout
c      write(6,*) fileout
c     
c     create statistics output file
c
c      open(file=fileout,unit=16,status='unknown')
c
c      if(nspace.eq.1)then
c
c     extract gaussian latitudes 
c
c         ierr=fcw_cluvdb()
c         ierr=fcw_setname(' ','latitude',' ',' ',' ')
c         ierr=fcw_getdat(7,gausslat,idrs_bytes_per_word*nlat)
c         ierr=fcw_getname(vsource2d,vname2d,vtitle2d,vun2d,
c     *        vdate2d,vtime2d,vtype2d,numdim2d)
c 
c      endif
c     
c     extract dimension 3
c
C      ierr=fcw_cluvdb()
C      ierr=fcw_setname(' ','plev',' ',' ',' ')
C      ierr=fcw_getdat(7,plevel,idrs_bytes_per_word*n3)
C      ierr=fcw_getname(vsource3d,vname3d,vtitle3d,vun3d,
C     *     vdate3d,vtime3d,vtype3d,numdim3d)
c
c*******************************************************************
c  Get time dimension
c
         ierr=fcw_cluvdb()
         ierr=fcw_setname(' ',vname(1),' ',' ',' ')
         ierr=fcw_inqdict(7,IDRS_GETFIRSTVAR)
c     testing...
      vtitle2d = "jfp_hello"
         ierr=fcw_getedim(2,vsource2d,vname2d,vtitle2d,vun2d,
     *        ntype2d, numdim2, xt1, xtn )
         ierr=fcw_getcdim(2,vsource2d,vname2d,vtitle2d,
     *        vun2d,ntype2d,ntot,times,dum2d)
c
c         do itot=1,ntot
c            write(16,*) times(itot)
c         enddo
c
c************************************************************************
c************************************************************************
c
c Read in the necessary time points for the first pattern correlation
c
      ncases=0
      do 1313 itot=1,ntot
c
c         print *,'Reading ',vname(1)
         ierr=fcw_cluvdb()
         ierr=fcw_setname(' ',vname(1),' ',' ',' ')
c
c        ONLY USE SETDIM IF YOU WANT TO EXTRACT A PORTION OF VNAME()
c        where
c        ndim    = which x, y, z, t coordinate (integer 1-4) (e.g. 3)
c        dimname = name corresponding to ndim (e.g., 'month')
c        num     = number of array locations
c        start   = beginning array location
c        finish  = ending array location
c     
c        ierr=fcw_setdim(ndim,'dimname',' ',num,start,finish)
c   
         ierr=fcw_setdim(1,'longitude',' ',nlon,xlonmin,xlonmax)
c         ierr=fcw_setvdim(2,' ','latitude',' ',' ',-45.4203,45.4203)
c         ierr=fcw_setvdim(3,' ','plev',' ',' ',xlevel,xlevel)
         ierr=fcw_setdim(2,vname2d,vun2d,1,times(itot),times(itot))
c
c
         ierr=fcw_getdat(7,din,IDRS_BYTES_PER_WORD*nlon)
c
c         ierr=fcw_getname(vsourcein1,vname(1),vtitle(1),vun(1),
c     *        vdate(1),vtime(1),vtype(1),numdim(1))
c
c     EXTRACT LONGITUDE INFORMATION
c
c         ierr=fcw_getedim(1,vsource1d,vname1d,vtitle1d,
c     *        vun1d,ntype1d,nlong,xlong1,xlongn)
c         ierr=fcw_getcdim(1,vsource1d,vname1d,vtitle1d,
c     *        vun1d,ntype1d,nlong,along,longn)
c
c         if(nspace .eq. 0)then
c            ierr=fcw_getedim(2,vsource2d,vname2d,vtitle2d,
c     *           vun2d,ntype2d,nlatt,xlat1,xlatn)
c            go to 1013
c
c            ierr=fcw_getcdim(2,vsource2d,vname2d,vtitle2d,
c     *           vun2d,ntype2d,nlat,gausslat,latn)
c         endif
c
c        ierr=fcw_getedim(3,vsourcetd,vnametd,vtitletd,
c     *        vuntd,ntypetd,numdimtd,xn31,xn3n)
c
c************************************************************************
c        print *,'Reading ',vname(2)
         ierr=fcw_cluvdb()
         ierr=fcw_setname(' ',vname(2),' ',' ',' ')
c
c     ONLY USE SETDIM IF YOU WANT TO EXTRACT A PORTION OF VNAME()
c     where
c     ndim    = which x, y, z, t coordinate (integer 1-4) (e.g. 3)
c     dimname = name corresponding to ndim (e.g., 'month')
c     num     = number of array locations
c     start   = beginning array location
c     finish  = ending array location
c
c     ierr=fcw_setdim(ndim,'dimname',' ',num,start,finish)
c
c
         ierr=fcw_setdim(1,'longitude',' ',nlon,xlonmin,xlonmax)
c         ierr=fcw_setvdim(2,' ','latitude',' ',' ',-45.4203,45.4203)
c         ierr=fcw_setvdim(3,' ','plev',' ',' ',xlevel,xlevel)
         ierr=fcw_setdim(2,vname2d,vun2d,1,times(itot),times(itot))
c
         ierr=fcw_getdat(9,ddep,IDRS_BYTES_PER_WORD*nlon)
c
c         ierr=fcw_getname(vsourcein2,vname(2),vtitle(2),vun(2),
c     *        vdate(2),vtime(2),vtype(2),numdim(2))
c
c
c  Put independent and dependent data from each time point into the full array
c
         if(din(1) .lt. 9.9 e19)then
            ncases=ncases+1
            do ilon=1,nlon
               ipt=ilon+((itot-1)*nlon)
               x8(ipt)=din(ilon)
               y8(ipt)=ddep(ilon)
c              write(16,*) itot,ilon,ipt,x8(ipt),y8(ipt)
            enddo
         endif
c
1313  continue

      call cpu_time(clock)
      write(6,*) 'Time before lsfit is', clock-clockstart
      clockstart = clock
c
c  Call LSFIT
c     
      call lsfit(x8,y8,nlon*ncases,slope1,yint1,F,R)
      call rmse(x8,y8,nlon*ncases,xrmse)
      write(6,*) 'For ',ncases,' time points the correlation = ',R
      write(6,*) 'The root-mean-square error = ',xrmse
      call cpu_time(clock)
      write(6,*) 'Time for lsfit and rmse is', clock-clockstart
c
      go to 1013
c
c************************************************************************
c
c Select time point data to be removed and new time point data to add
c
      do itime=1,ntot-ntot
c
         iold=itime
         inew=itime+ntot
c
c         write(16,*) itime,times(iold),times(inew)
c
         ierr=fcw_cluvdb()
         ierr=fcw_setname(' ',vname(1),' ',' ',' ')   
         ierr=fcw_setdim(1,'longitude',' ',nlon,xlonmin,xlonmax)
         ierr=fcw_setdim(2,vname2d,vun2d,1,times(iold),times(iold))
         ierr=fcw_getdat(7,din,IDRS_BYTES_PER_WORD*nlon)
         do ilon=1,nlon
            x8_old(ilon)=din(ilon)
         enddo
c
         ierr=fcw_cluvdb()
         ierr=fcw_setname(' ',vname(1),' ',' ',' ')   
         ierr=fcw_setdim(1,'longitude',' ',nlon,xlonmin,xlonmax)
         ierr=fcw_setdim(2,vname2d,vun2d,1,times(inew),times(inew))
         ierr=fcw_getdat(7,din,IDRS_BYTES_PER_WORD*nlon)
         do ilon=1,nlon
            x8_new(ilon)=din(ilon)
         enddo
c
         ierr=fcw_cluvdb()
         ierr=fcw_setname(' ',vname(2),' ',' ',' ')   
         ierr=fcw_setdim(1,'longitude',' ',nlon,xlonmin,xlonmax)
         ierr=fcw_setdim(2,vname2d,vun2d,1,times(iold),times(iold))
         ierr=fcw_getdat(9,ddep,IDRS_BYTES_PER_WORD*nlon)
         do ilon=1,nlon
            y8_old(ilon)=ddep(ilon)
         enddo
c
         ierr=fcw_cluvdb()
         ierr=fcw_setname(' ',vname(2),' ',' ',' ')   
         ierr=fcw_setdim(1,'longitude',' ',nlon,xlonmin,xlonmax)
         ierr=fcw_setdim(2,vname2d,vun2d,1,times(inew),times(inew))
         ierr=fcw_getdat(9,ddep,IDRS_BYTES_PER_WORD*nlon)
         do ilon=1,nlon
            y8_new(ilon)=ddep(ilon)
         enddo
c
         call lsfit_moving(nlon*ntot,x8_old,x8_new,y8_old,y8_new,nlon,
     &        slope1,yint1,F,R)
         write(16,*) times(itime+1),R,F
c
      enddo
c
c************************************************************************
c
1013  ierr=fcw_cllun(7)
      ierr=fcw_cllun(9)
      stop
      end
c************************************************************************
      subroutine rmse(xin,yin,ict,xrmse)
      real*8  xin(ict),yin(ict),xrmse
c
c  Root-Mean-Square Error
c
      xrmse=0.0
      do 10 i=1,ict
          diff=xin(i)-yin(i)
          xrmse=xrmse+diff*diff
10    continue
      xrmse=sqrt(xrmse/float(ict))
c
      return
      end
c************************************************************************
	SUBROUTINE LSFIT(X,Y,N,B,A,F,R)
C
C METHOD OF LEAST SQUARES STRAIGHT LINE
C    -Returns linear regression coeficients, F-test, and correlation, R
C    -In the case where lag 0 moving correlations are to be calculated 
C     using SUBROUTINE LSFIT_MOVING, the efficiency is improved by  
C     by passing the sum and sum of squares of the independent and 
C     dependent variables (XST, XTOT, XYST, YST, and YTOT) via a 
C     common block
C    -In SUBROUTINE LSFIT_MOVING these sums and products are modified 
C     by removing the sums and products of the time point data that are 
C     no longer needed, and adding in the sums and products of the newly 
C     added time point data
C
C N= NUMBER OF VARIABLES
C XST= SUM X(I) SQUARED
C XTOT= SUM X VARIABLE
C XYST= SUM X(I)*Y(I)
C YST= SUM Y(I) SQUARED
C YTOT= SUM Y VARIABLE
C Sxx=CORRECTED SUM OF SQUARES FOR X
C Syy=CORRECTED SUM OF SQUARES FOR Y
C Sxy=CORRECTED SUM OF THE PRODUCT OF X AND Y
C B= SLOPE
C A= INTERCEPT
C RegSS=REGRESSION SUM OF SQUARES
C ResSS=RESIDUAL SUM OF SQUARES
C
C F=F-test STATISTIC OF THE FIT
C R=CORRELATION COEFFICIENT OF X AND Y
C   -NOTE: these measures give virtually identical results for 
C          statistical significance of the fit
C          Kiladis and Weickmann (1992, MWR) use the correlation coefficient
C          to test the significance of the linear fits
C
      REAL*8 X(n),Y(n)
      REAL*8 XST,XTOT,XYST,YST,YTOT,SXX,SYY,SXY,B,A,REGSS,RESSS,F,R
C
C This is the information based on the independent variable
C
      COMMON /CSTUFF/ XST,XTOT,XYST,YST,YTOT
C
      XST=0.0
      XTOT=0.0
      XYST=0.0
      YST=0.0
      YTOT=0.0
      DO 30 I=1,N
         XST=X(I)*X(I)+XST
         XTOT=X(I)+XTOT
         XYST=X(I)*Y(I)+XYST
         YST=Y(I)*Y(I)+YST
         YTOT=Y(I)+YTOT
30    CONTINUE
c      print*,XST,XTOT,XYST,YST,YTOT
      Sxx=XST-(XTOT*XTOT)/float(N)
      Syy=YST-(YTOT*YTOT)/float(N)
      Sxy=XYST-(XTOT*YTOT)/float(N)
c      print*,'Sxx= ',Sxx,' Syy= ',Syy,' Sxy= ',Sxy
      B=Sxy/Sxx
      A=(YTOT-(B*XTOT))/float(N)
      RegSS=(Sxy*Sxy)/Sxx
      ResSS=Syy-RegSS
      F=RegSS/(ResSS/float(N-2))
      R=Sxy/sqrt(Sxx*Syy)
c      print*,'RegSS= ',RegSS,' ResSS= ',ResSS,' F= ',F,' R= ',R
c
1013  RETURN
      END
c************************************************************************
	SUBROUTINE LSFIT_MOVING(N,X_OLD,X_NEW,Y_OLD,Y_NEW,NY,B,A,F,R)
C
C METHOD OF LEAST SQUARES STRAIGHT LINE
C    -An initial call to SUBROUTINE LSFIT must be made to obtain 
C     the sums and products, passed in the COMMON block, of the 
C     initial dataset
C    -In this SUBROUTINE LSFIT_MOVING the COMMON block sums and products 
C     are modified by removing the sums and products of the time point 
C     data that are no longer needed, and adding in the sums and products 
C     of the newly added time point data 
C
C N= NUMBER OF VARIABLES
C XST= SUM X(I) SQUARED
C XTOT= SUM X VARIABLE
C XYST= SUM X(I)*Y(I)
C YST= SUM Y(I) SQUARED
C YTOT= SUM Y VARIABLE
C Sxx=CORRECTED SUM OF SQUARES FOR X
C Syy=CORRECTED SUM OF SQUARES FOR Y
C Sxy=CORRECTED SUM OF THE PRODUCT OF X AND Y
C B= SLOPE
C A= INTERCEPT
C RegSS=REGRESSION SUM OF SQUARES
C ResSS=RESIDUAL SUM OF SQUARES
C
C F=F-test STATISTIC OF THE FIT
C R=CORRELATION COEFFICIENT OF X AND Y
C   -NOTE: these measures give virtually identical results for 
C          statistical significance of the fit
C          Kiladis and Weickmann (1992, MWR) use the correlation coefficient
C          to test the significance of the linear fits
C
      REAL*8 X_OLD(ny),X_NEW(ny),Y_OLD(ny),Y_NEW(ny)
      REAL*8 XST,XTOT,XYST,YST,YTOT,SXX,SYY,SXY,B,A,REGSS,RESSS,F,R
C
C This is the information from SUBROUTINE LSFIT
C
      COMMON /CSTUFF/ XST,XTOT,XYST,YST,YTOT
C
c      print*,XST,XTOT,XYST,YST,YTOT
      DO 20 I=1,NY
c         print*,X_OLD(I),X_NEW(I),Y_OLD(I),Y_NEW(I)
         XST=XST-(X_OLD(I)*X_OLD(I))+(X_NEW(I)*X_NEW(I))
         XTOT=XTOT-X_OLD(I)+X_NEW(I)
         XYST=XYST-(X_OLD(I)*Y_OLD(I))+(X_NEW(I)*Y_NEW(I))
         YST=YST-(Y_OLD(I)*Y_OLD(I))+(Y_NEW(I)*Y_NEW(I))
         YTOT=YTOT-Y_OLD(I)+Y_NEW(I)
20    CONTINUE
c      print*,XST,XTOT,XYST,YST,YTOT
      Sxx=XST-(XTOT*XTOT)/float(N)
      Syy=YST-(YTOT*YTOT)/float(N)
      Sxy=XYST-(XTOT*YTOT)/float(N)
c      print*,'Sxx= ',Sxx,' Syy= ',Syy,' Sxy= ',Sxy
      B=Sxy/Sxx
      A=(YTOT-(B*XTOT))/float(N)
      RegSS=(Sxy*Sxy)/Sxx
      ResSS=Syy-RegSS
      F=RegSS/(ResSS/float(N-2))
      R=Sxy/sqrt(Sxx*Syy)
c      print*,'RegSS= ',RegSS,' ResSS= ',ResSS,' F= ',F,' R= ',R
c
1013  RETURN
      END
c************************************************************************
