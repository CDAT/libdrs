c     Fortran wrappers for libcdms, generally look like DRS but handle other file formats as well.
c     The libcdms this wraps is the new one in UV-CDAT, which contains no Fortran support.
c     Thus you also need a C file, cddrs_fc.c.

      integer function fcw_aslun( plud, dicfilin, plu, datfilin, pistat)
      implicit none
      integer plud,plu,pistat,dicfilmax,dicfillen,datfilmax,datfillen
      character dicfilin*(*), datfilin*(*)
      integer ierr
      integer fc_aslun
      dicfilmax = len(dicfilin)
      dicfillen = len_trim(dicfilin)
      datfilmax = len(datfilin)
      datfillen = len_trim(datfilin)
      ierr = fc_aslun(plud,dicfilin,plu,datfilin,pistat,
     1     dicfilmax, dicfillen,datfilmax,datfillen)
      fcw_aslun = ierr
c      if ( ierr.ne.0 ) then
c         print *,"jfp ***** in fcw_aslun ierr=",ierr," *****"
c      endif
      end function fcw_aslun


      integer function fcw_setname( isource, iname, ititle, iunits,
     1     ityped)
      implicit none
      character isource*(*), iname*(*), ititle*(*), iunits*(*),
     1     ityped*(*)
      integer srcmax, nammax, timax, unmax, typmax
      integer srclen, namlen, tilen, unlen, typlen
      integer ierr
      integer fc_setname
      srcmax = len(isource)
      srclen = len_trim(isource)
      nammax = len(iname)
      namlen = len_trim(iname)
      timax = len(ititle)
      tilen = len_trim(ititle)
      unlen = len(iunits)
      unmax = len(iunits)
      typmax = len(ityped)
      typlen = len_trim(ityped)

      ierr = fc_setname(isource,iname,ititle,iunits,ityped,
     1     srcmax, srclen, nammax, namlen, timax, tilen,
     2     unmax, unlen, typmax, typlen )
      fcw_setname = ierr
c      if ( ierr.ne.0 ) then
c         print *,"jfp ***** in fcw_setname ierr=",ierr," *****"
c      endif
      end function fcw_setname


      integer function fcw_getname( isource, iname, ititle, iunits,
     1      idate, itime, ityped, nd )
      implicit none
      character isource*(*), iname*(*), ititle*(*), iunits*(*),
     1     idate*(*), itime*(*), ityped*(*)
      integer srcmax, nammax, timax, unmax, datmax, timmax, typmax
      integer srclen, namlen, tilen, unlen, datlen, timlen, typlen
      integer ierr, nd
      integer fc_getname
      srcmax = len(isource)
      srclen = len_trim(isource)
      nammax = len(iname)
      namlen = len_trim(iname)
      timax = len(ititle)
      tilen = len_trim(ititle)
      unmax = len(iunits)
      unlen = len_trim(iunits)
      datmax = len(idate)
      datlen = len_trim(idate)
      timmax = len(itime)
      timlen = len_trim(itime)
      typmax = len(ityped)
      typlen = len_trim(ityped)

      ierr = fc_getname( isource, iname, ititle, iunits, idate, itime,
     1     ityped, nd,
     2     srcmax, srclen, nammax, namlen, timax, tilen, unmax, unlen,
     3     datmax, datlen, timmax, timlen, typmax, typlen )

      typlen = len( ityped )
      fcw_getname = ierr
c      if ( ierr.ne.0 ) then
c         print *,"jfp ***** in fcw_getname ierr=",ierr," *****"
c      endif
      end function fcw_getname


      integer function fcw_getedim( pn, dsrc, dna, dti, dun, dtype,
     1     idim, df, dl )
      implicit none
      integer ierr, pn, dtype, idim
      character dsrc*(*), dna*(*), dti*(*), dun*(*)
      integer srcmax, srclen, namax, nalen, timax, tilen, unmax, unlen
      real df,dl
      integer fc_getedim

      srcmax = len(dsrc)
      srclen = len_trim(dsrc)
      namax = len(dna)
      nalen = len_trim(dna)
      timax = len(dti)
      tilen = len_trim(dti)
      unmax = len(dun)
      unlen = len_trim(dun)

      ierr = fc_getedim( pn, dsrc, dna, dti, dun, dtype, idim, df, dl,
     1     srcmax, srclen, namax, nalen, timax, tilen, unmax, unlen )

      fcw_getedim = ierr
c      if ( ierr.ne.0 ) then
c         print *,"jfp ***** in fcw_getedim ierr=",ierr," *****"
c      endif
      end function fcw_getedim


      integer function fcw_getcdim( pn, dsrc, dna, dti, dun, dtype,
     1     preqlen, var, retlen )
      implicit none
      integer ierr, pn, dtype
      integer preqlen, retlen
      integer srcmax, srclen, nmmax, nmlen, timax, tilen,  unmax, unlen
      character dsrc*(*), dna*(*), dti*(*), dun*(*)
      real*4 var
      integer fc_getcdim

      srcmax = len(dsrc)
      srclen = len_trim(dsrc)
      nmmax = len(dna)
      nmlen = len_trim(dna)
      timax = len(dti)
      tilen = len_trim(dti)
      unmax = len(dun)
      unlen = len_trim(dun)

      ierr = fc_getcdim( pn, dsrc, dna, dti, dun, dtype, preqlen, var,
     1     retlen,
     2     srcmax, srclen, nmmax, nmlen, timax, tilen, unmax, unlen )
      fcw_getcdim = ierr
c      if ( ierr.ne.0 ) then
c         print *,"jfp ***** in fcw_getcdim ierr=",ierr," *****"
c      endif
      end function fcw_getcdim


      integer function fcw_setdim( pn, dnain, dunin, pidim, pdf, pdl )
c     Note that pdf,pdl are required to be real*4 on input, and are
c     converted to real*8 for calling fc_setdim.  This provides backwards
c     compatibility - to Fortran code cw_setdim will look like the 32-bit
c     version in older versions of libcdms.
      implicit none
      integer ierr
      integer pn, namax, nalen, unmax, unlen, pidim
      character dnain*(*), dunin*(*)
      real*4 pdf,pdl
      real*8 df,dl
      integer fc_setdim
      
      df = dble(pdf)
      dl = dble(pdl)
      namax = len(dnain)
      nalen = len_trim(dnain)
      unmax = len(dunin)
      unlen = len_trim(dunin)

      ierr = fc_setdim( pn, dnain, dunin, pidim, df, dl,
     1     namax, nalen, unmax, unlen )
      fcw_setdim = ierr
c      if ( ierr.ne.0 ) then
c         print *,"jfp ***** in fcw_setdim ierr=",ierr," *****"
c      endif
      end function fcw_setdim


      integer function fcw_drstest( ierr )
      integer new_ierr
      integer fc_drstest
      new_ierr = fc_drstest( ierr )
      fcw_drstest = new_ierr
c      if ( ierr.ne.0 ) then
c         print *,"jfp ***** in fcw_drstest ierr=",ierr," *****"
c      endif
      end function fcw_drstest


      integer function fcw_getdat( plu, a, psize )
! plu = logical unit number, a = data array (output), psize = size of a in bytes
      implicit none
      integer plu, psize
      real*4,dimension(psize) :: a
      integer ierr
      integer fc_getdat
!      real nosense

      ierr = fc_getdat( plu, a, psize )

! Nonsense calculation works around a problem in the call stack, a bad return value:
! This problem arises with gfortran 4.6.0 on a Macintosh.
!      nosense = sin(real(ierr))
      fcw_getdat = ierr
c      if ( ierr.ne.0 ) then
c         print *,"jfp ***** in fcw_getdat ierr=",ierr," *****"
c      endif
      end function fcw_getdat


      integer function fcw_cluvdb()
      implicit none
      integer ierr, fc_cluvdb
      ierr = fc_cluvdb()
      fcw_cluvdb = ierr
c      if ( ierr.ne.0 ) then
c         print *,"jfp ***** in fcw_cluvdb ierr=",ierr," *****"
c      endif
      return
      end function fcw_cluvdb


!!$  interface 
!!$     function cw_setdim(pn, dnain, dunin, pidim, pdf, pdl, nalen, unlen) result (ierr)
!!$       integer pn,nalen, unlen,pidim
!!$       character(*) dnain,dunin
!!$       double precision pdf,pdl
!!$       integer ierr
!!$     end function cw_setdim
!!$  end interface
!!$  interface 
!!$     function cw_inqdict(plu,poper) result (ierr)
!!$       integer plu,poper
!!$       integer ierr
!!$     end function cw_inqdict
!!$  end interface
!!$  interface 
!!$     function cw_setname(isource,iname,ititle,iunits,ityped, srclen, nalen, tilen, unlen, tylen) result (ierr)
!!$       character(*) isource,iname,ititle,iunits,ityped
!!$       integer srclen, nalen, tilen, unlen, tylen
!!$       integer ierr
!!$     end function cw_setname
!!$  end interface
!!$  interface 
!!$     function cw_aslun(plud,dicfilin,plu,datfilin,pistat,dicfillen,datfillen) result (ierr)
!!$       integer plud,plu,pistat,dicfillen,datfillen
!!$       character(*) dicfilin,datfilin
!!$       integer ierr
!!$     end function cw_aslun
!!$  end interface
!!$  interface 
!!$     function cw_cluvdb() result (ierr)
!!$       integer ierr
!!$     end function cw_cluvdb
!!$  end interface
!!$  interface 
!!$     function cw_getdat(plu,a,pisize) result(ierr)
!!$       integer ierr,plu,a,pisize
!!$     end function cw_getdat
!!$  end interface
!!$  interface 
!!$     function cw_cllun(plu) result(ierr)
!!$       integer ierr,plu
!!$     end function cw_cllun
!!$  end interface
!!$  interface 
!!$     function cw_getcdim(pn,dsrc,dna,dti,dun,dtype,preqlen,var,retlen,srclen,nmlen,tilen,unlen) result(ierr)
!!$       integer ierr,pn,dtype,preqlen,retlen,srclen,nmlen,tilen,unlen
!!$       character(*) dsrc,dna,dti,dun
!!$       real var
!!$     end function cw_getcdim
!!$  end interface
!!$  interface 
!!$     function cw_getedim(pn,dsrc,dna,dti,dun,dtype,idim,df,dl,srclen,nalen,tilen,unlen) result(ierr)
!!$       integer ierr,pn,dtype,idim,srclen,nalen,tilen,unlen
!!$       character(*) dsrc,dna,dti,dun
!!$       real df,dl
!!$     end function cw_getedim
!!$  end interface

