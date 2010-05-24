ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c getvdim.F,v 2.2 1995/03/30 00:50:59 drach Exp
c getvdim.F,v
c Revision 2.2  1995/03/30  00:50:59  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:13  drach
c Merged Sun, Unicos, SGI, and HP versions.
c
c Revision 2.0  1992/03/07  00:08:14  drach
c Entered into RCS
c
c     
c
c                     Data Retrieval and Storage System
c
c**********************************************************************
c
c			DISCLAIMER
c
c   This software was prepared as an account of work sponsored by an
c   agency of the United States Government. Neither the United
c   States Government nor the University of California nor any of
c   their employees, makes any warranty, express or implied, or
c   assumes any liability or responsibility for the accuracy,
c   completeness, or usefulness of any information, apparatus,
c   product, or process disclosed, or represents that its use would
c   not infringe privately owned rights. Reference herein to any
c   specific commercial products, process, or service by trade name,
c   trademark, manufacturer, or otherwise, does not necessarily
c   constitute or imply its endorsement, recommendation, or favoring
c   by the United States Government or the University of California.
c   The views and opinions of authors expressed herein do not
c   necessarily state or reflect those of the United States
c   Government or the University of California, and shall not be
c   used for advertising or product endorsement purposes.
c   
c**********************************************************************
c
c     Routine: 
c     -------
      integer function getvdim(idim,source,title,reqlen,var,retlen)
      character*(*) source
      character*(*) title
      integer reqlen
c      dimension var(reqlen)
      dimension var(*)
      integer retlen
c     
c     Description:
c     -----------
c     Get the dimension variable for dimension idim, as described
c     in the avdb
c     
c     Arguments:
c     ---------
c     idim   =:  dimension number
c     source  := dimension source
c     title   := dimension title
c     reqlen =:  length of var in words
c     var     := dimension variable
c     retlen  := number of words returned in var
c     
c     Function Returns:
c     ----------------
c     0: success
c     
c     Author: Bob Drach
c     ------
c     Date:
c     ----
c       modified: 6/11/90 to get subranges of dimension variables
c         and to handle transpositions properly (BD)
c                 7/9/91 to calc byte length returned via neu*lpty
c         rather than neu*laty (for correct calc on Cray version)
c                 9/23/91 Only fail after fatal error from getrge2
c                
c     Notes:
c     -----
c     If the dimension is equally-spaced, then an equally-spaced
c     vector is returned.
c     
c     Glossary:
c     --------
c     
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      
#include "drscom.h"
#include "drsdef.h"

      character*16 name
      character*40 units
      integer dtype,dimlen,dum
      integer savevdbs,restvdbs,cluvdb,setname,gd1,getdim,getrge2,setdim
      logical drstest
      
      getvdim=IDRS_SUCCESS

c     find the corresponding file dimension index

      do 50 i=1,nda
         if(ip(i).eq.idim) then
            ipp=i
            go to 60
         endif
 50   continue
      getvdim=IDRS_BADDIM
      go to 9000
 60   continue

c     get the user specified dimension range

      getvdim=getdim(idim,name,units,dtype,dum,dimf,diml)
      if(getvdim.ne.IDRS_SUCCESS) go to 9000

c     translate to indices

      getvdim=getrge2(isavelu,ipp,dimf,diml,ind1,ind2,dfact,dlact)
      if(drstest(getvdim)) go to 9000
      dimlen=abs(ind2-ind1)+1
      ibytelen=IDRS_BYTES_PER_WORD*reqlen
      
c     if the dimension is unequally-spaced, then save the avdb and uvdb,
c     read the dictionary for the dimension variable, then read the
c     data. Finally, restore the vdbs
      
      if(dimtypea(ipp).eq.IDRS_UNEQUALLY_SPACED) then
         getvdim=savevdbs(isavbuf)
         idaddr=dimaddra(ipp)
         call redic(isavelu,idaddr,ierr)
         if(ierr.eq.1) then
            getvdim=IDRS_DICTREADERROR
            go to 9000
         elseif(ierr.eq.2) then
            getvdim=IDRS_NODICTFILE
            go to 9000
         endif
         source=asrc
         title=atitl
         getvdim=cluvdb()

#ifdef cray
         getvdim=setname(source,name,title,units,'R*8')
#else !cray
         getvdim=setname(source,name,title,units,'R*4')
#endif cray
         
c     dimension values of DIMENSION variables are just
c     the (floating-point) indices

         getvdim=setdim(1,'internal','internal',
     $        reqlen,real(ind1),real(ind2))
         getvdim=gd1(isavelu,var,ibytelen)
c$$$         neb=neu*laty
         neb=neu*lpty
         if(neb.le.0 .or. neb.gt.ibytelen) then
            retlen=0
         else
            retlen=(neb-1)/IDRS_BYTES_PER_WORD+1
         endif
         ierr=restvdbs(isavbuf)
         if(getvdim.ne.IDRS_SUCCESS) go to 9000
         
c     if the dimension is equally-spaced, then just fill
c     the user vector up to the requested length
         
         
      elseif(dimtypea(ipp).eq.IDRS_EQUALLY_SPACED) then
         source=' '
         title=' '
         
         if (reqlen.lt.dimlen) then
            retlen=0
            getvdim=IDRS_BADLEN
            go to 9000
         else
            retlen=dimlen
         endif
         if(retlen.eq.1) then
            dxa=0.0
         else
            dxa=(dlact-dfact)/real(retlen-1)
         endif
         var(1)=dfact
         do 100 i=2,retlen
            var(i)=var(i-1)+dxa
 100     continue
      endif
      
 9000 continue
      call drsrout('getvdim',getvdim)
      return
      end
