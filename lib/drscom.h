c drscom.h,v 2.7 1995/10/26 23:23:04 drach Exp
c drscom.h,v
c Revision 2.7  1995/10/26  23:23:04  drach
c - Save NSL dictionary file name, NSL version
c
c Revision 2.6  1995/03/30  00:50:35  drach
c Added disclaimer
c
c Revision 2.5  1993/12/11  01:35:58  drach
c Set NSL/UniTree buffer to 4MB
c
c Revision 2.4  1993/10/20  17:16:45  drach
c Add autosync flags.
c
c Revision 2.3  1993/10/15  19:31:06  drach
c Added ibdirty array: ibdirty(ifil)=1 if current block has been modified and not yet written, 0 otherwise.
c
c Revision 2.2  1993/07/13  17:53:58  drach
c Fixed up CVS install
c
c  * Revision 2.1  1993/07/13  01:12:48  drach
c  * Merged Sun, Unicos, SGI, and HP versions.
c  *
c Revision 2.0  1992/03/07  00:10:39  drach
c Entered into RCS
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
c#######################################################################
c                 drscom.h

c#######################################################################
c
      parameter (mxdim=4,mxfil=6,mxnin=2)
      parameter (mxbuf=512)
      parameter (mxent=600)
      parameter (mxdepth=3) 
      parameter (xnull=1.0e20, xlownull=xnull-1.0e14)

#ifdef cray

#ifdef NSL_DRS
      parameter (idatrecl=4194304)
#else
      parameter (idatrecl=81920)
#endif
      parameter (idicrecl=512)
c       Cray data buffer is an integer array
      parameter (ibloclen=idatrecl/8)
      parameter (idicrecw=idicrecl/8)
      parameter (idatrecw=idatrecl/8)
      integer idicbuf(idicrecw)
#else !cray
      parameter (idatrecl=512)
      parameter (ibloclen=idatrecl)
      parameter (idicrecl=512)

#endif cray

c
c         mxdim = max number of dimensions for a variable
c         mxfil = max data files that can be open simultaneously
c         mxnin = max number of allowable instances of a variable
c         mxbuf = max size of abuf and ubuf (first parts of avdb
c                     and uvdb, respectively)
c         mxent = max entries in the on-line dictionaries
c     mxdepth = max number of simultaneous calls to savebuffer routines
c
c     Note: At present (12/2/91), a depth of three in the save buffers may be
c     reached via getcdim -> getrange -> getindex
c     
c     xnull = null real value for drs arguments
c     xlownull = args are considered null for values >= xlownull
c     idatrecl = data file record byte length
c     idicrecl = dictionary file record byte length
c     ibloclen = length of iblock data buffer
c     idicrecw = word length of dictionary record
c     idicbuf  = dictionary record buffer
c
      save /drscdef/,/drsidef/,/drscavdb/,/drsqavdb/,/drscuvdb/
      save /drsquvdb/,/drsiuvdb/,/drsqddb/,/drsblock/,/drsdict/
      save /drserror/,/drscuvd2/,/drssave/,/drslusav/,/drscerr/
      save /drscuvd3/
c
c-----------------------------------------------------------------------
      common /drscdef/ it,daf,dif
      character*8 it(mxfil)

#ifdef cray
      character*248 daf(mxfil),dif(mxfil)
#else !cray
      character*1024 daf(mxfil),dif(mxfil)
#endif

c
c         it     = data file status 'R' - readonly,
c                                   'W' - write only,
c                                   'E' - extend.
c	      (Note: 'it' is length 8 to force word-alignment on the Crays)
c         daf    = data file specifiers
c         dif    = dictionary file specifiers
c
c-----------------------------------------------------------------------
#ifdef NSL_DRS
      common /drscdef2/ nsldif
      character*248 nsldif(mxfil)
      save /drscdef2/

c     nsldif = NSL dictionary file name (as opposed to dif = local disk copy)
#endif
c-----------------------------------------------------------------------

      common /drsidef/ nf,luda,ludi,nvdb,mxdat,drsvers

      integer nf
c      data nf/0/
      integer luda(mxfil),ludi(mxfil),nvdb(mxfil)
      integer mxdat(mxfil)
      real drsvers(mxfil)
c
c         nf     = number of open files
c         luda   = logical unit numbers for data files
c         ludi   = logical unit numbers for dictionary files
c         nvdb   = number of vdbs in each file
c         mxdat  = amount of data in each file (bytes)
c         drsvers = DRS version number for each file
c     Note: The following variables are used on Cray/CTSS
c     to track file extension and truncation
c     idatlen  = (Cray/CTSS) datafile word length
c     idiclen  = (Cray/CTSS) dictionary file word length
c     mxdatl   = (Cray/CTSS) actual number of data words in data file
c     mxdicl   = (Cray/CTSS) actual number of dictionary file words written
c
c-----------------------------------------------------------------------
      common /drscavdb/ asrc,anam,atitl,aun,adate,atime,atype,adna,adun
c
      character asrc*120,anam*16,atitl*80,aun*40,adate*8,atime*8,atype*8
      character adna(mxdim)*16,adun(mxdim)*40


c
c              defines the first part of the active virtual descriptor block
c
c         asrc   = string describing source of the data
c         anam   = name of the variable
c         atitl  = description or title of the variable
c         aun    = units description for the variable
c         adate  = date the data was created
c         atime  = time of day the data was created
c         atype  = type of the data r[eal]*i - real, i=length in bytes
c                                   i[nteg]*i - integer, i=length in bytes
c                                   c[har]*i - character, i=length in bytes
c         adna   = dimension names (up to mxdim dimensions)
c         adun   = dimension units descriptors (up to mxdim dimensions)
c
      character abuf(mxbuf)
      equivalence (abuf(1),asrc)
c
c-----------------------------------------------------------------------
      common /drsqavdb/ nina,nda,nea,laty,iadim,dfa,dla,iads,iaddr,
     $     dimtypea,dimaddra,dimmonoa,dvfe,dvle,dfa2,dla2
c
      integer nina,nda,laty
      integer nea,iadim(mxnin,mxdim),iads(mxdim),iaddr
      integer dimtypea(mxdim),dimaddra(mxdim),dimmonoa(mxdim)
      real dfa(mxnin,mxdim),dla(mxnin,mxdim),dvfe,dvle
      real dfa2(mxdim),dla2(mxdim)
c     mxiabuf=length in words of drsqavdb
c     NB!!! CANNOT HAVE MXIABUF>IDICRECL/BYTES_PER_WORD !!!
      parameter(mxiabuf=7+6*mxdim+3*mxnin*mxdim)
c
c              defines the second part of the active virtual descriptor block
c
c         nina   = number of "instances" of the variable defined  (1 or 2)
c         nda    = number of dimensions of avdb
c         nea    = number of elements of avdb
c         laty   = length for the type in avdb
c         iadim  = number of elements in each dimension
c         dfa    = value of the first point of each dimension, for each instance
c         dla    = value of the last point of each dimension, for each instance
c         iads   = distance (in bytes) between elements of each dimension
c         iaddr  = position (in bytes) of first element
c         dimtypea=flag for type of dimension (equally or unequally spaced)
c         dimaddra=record address of dimension variable, or 0 if none
c         dimmonoa= dimension monotonicity (+/-1)
c         dvfe   = first data value, if a dimension variable
c         dvle   = last data value, if a dimension variable
c         dfa2   = actual first point of dimension, if unequally-spaced
c         dla2   = actual last point of dimension, if unequally-spaced
c
      integer iabuf(mxiabuf)
      equivalence (iabuf(1),nina)
c-----------------------------------------------------------------------
c
      common /drscuvdb/ usrc,unam,utitl,uun,udate,utime,utype,udna,udun
c
      character usrc*120,unam*16,utitl*80,uun*40,udate*8,utime*8,utype*8
      character udna(mxdim)*16,udun(mxdim)*40
c
c              defines the first part of the user virtual descriptor block
c
c         usrc   = string describing source of the data
c         unam   = name of the variable
c         utitl  = description or title of the variable
c         uun    = units description for the variable
c         udate  = date the data was created
c         utime  = time of day the data was created
c         utype  = type of the data r[eal]*i - real, i=length in bytes
c                                   i[nteg]*i - integer, i=length in bytes
c                                   c[har]*i - character, i=length in bytes
c         udna   = dimension names (up to mxdim dimensions)
c         udun   = dimension units descriptors (up to mxdim dimensions)
c
c
      character ubuf(mxbuf)
      equivalence (ubuf(1),usrc)
c
c-----------------------------------------------------------------------
      common /drsquvdb/ ndu,neu,luty,iudim,dfu,dlu,iuds,dimtypeu,
     $     dimaddru,dimmonou,dvfu,dvlu,dfu2,dlu2
c
      integer ndu,luty
      integer neu,iudim(mxdim),iuds(mxdim),dimtypeu(mxdim),
     $     dimaddru(mxdim),
     $     dimmonou(mxdim)
      real dfu(mxdim),dlu(mxdim),dvfu,dvlu,dfu2(mxdim),dlu2(mxdim)
      parameter(mxiubuf=5+9*mxdim)
c
c              defines the second part of the user virtual descriptor block
c
c         ndu    = number of dimensions in uvdb
c         neu    = number of elements in uvdb
c         iudim  = number of elements in each dimension
c         dfu    = value of the first point of each dimension, for each instance
c         dlu    = value of the last point of each dimension, for each instance
c         iuds   = distance (in bytes) between elements of each dimension
c         dimtypeu=declared dimension type (equally or unequally spaced)
c         dvfu = first value of variable, for dimension variables
c         dvlu = last value of variable, for dimension variables
c         dfu2 = actual value of first point of dimension, for unequally
c              spaced dimensions (i.e., first data value of dimension var.)
c         dlu2 = actual value of last point of dimension, for unequally
c              spaced dimensions (i.e., last data value of dimension var.)
c
      integer iubuf(mxiubuf)
      equivalence (iubuf(1),ndu)
c-----------------------------------------------------------------------
      common /drscuvd2/ udso,udti,utype2
      character udso(mxdim)*120,udti(mxdim)*80, utype2*8
      parameter(mxubuf2=8+200*mxdim)
      character ubuf2(mxubuf2)
      equivalence(ubuf2(1),udso(1))

c     udso = dimension source name, if unequally spaced
c     udti = dimension source title, if unequally spaced
c     utype2= element program representation (e.g., 'R*8')
c-----------------------------------------------------------------------
      common /drscuvd3/ udna2,udun2
      character udna2*16,udun2*40

c     udna2 = dimension name, most recently referenced dimension variable
c     udun2 = dimension units, most recently referenced dimension variable

c-----------------------------------------------------------------------
      common /drsiuvdb/ iu1,iu2,ip,progrep,filerepa,filerepu,lpty
c
      integer iu1(mxdim),iu2(mxdim),ip(mxdim)
      integer progrep,filerepa,filerepu,lpty
      parameter(mxiuvdb=4+3*mxdim)
c     
c     iu1[dimension]=index of first user (requested) element relative to
c        data in file
c     iu2[dimension]=index of first user (requested) element relative to
c        data in file
c     ip = transposition vector from user dimensions to file dimensions:
c        <avdbmember>(dimension)=<uvdbmember>(ip(dimension))
c     progrep = element program representation (e.g., IDRS_CRAY_R8)
c     filerepa= element datafile representation
c     filerepu= requested element datafile representation
c     lpty = byte length, element program representation
      integer iuvdbuf(mxiuvdb)
      equivalence(iuvdbuf(1),iu1(1))
c-----------------------------------------------------------------------
c
c         data descriptor block for moving data
c
      common /drsqddb/ iadd,nbyt,in1,in2,inn,ins,io1,io2,ion,ios
c
      integer iadd,nbyt
      integer in1(mxdim),in2(mxdim),inn(mxdim),ins(mxdim)
      integer io1(mxdim),io2(mxdim),ion(mxdim),ios(mxdim)
      integer ieqv(8,mxdim)
      equivalence (in1(1),ieqv(1,1))
      parameter(mxqddb=2+8*mxdim)
      integer iqddbuf(mxqddb)
      equivalence(iqddbuf(1),iadd)
c
c         iadd - is address of the first byte of the entry in the data
c         nbyt - is the number of bytes per element of data
c         in1  - is the vector of first indices for each dimension,
c                refers to the data in memory
c         in2  - is the vector of last indices for each dimension,
c                refers to the data in memory
c         inn  - is the increment between elements of the data in memory
c                for each dimension (usually 1 or -1 to give direction)
c         ins  - is the byte spacing between elements of the data in memory
c                for each dimension
c         io1  - is the vector of first indices for each dimension,
c                refers to the data file
c         io2  - is the vector of last indices for each dimension,
c                refers to the data file
c         ion  - is the increment between elements of the data file
c                for each dimension
c         ios  - is the byte spacing between elements of the data file
c                for each dimension
c
c               space for current data block for each unit open
c
      common /drsblock/ iblno,ibdirty,isynch,iblock
c
      integer iblno(mxfil)
      integer ibdirty(mxfil)
      integer isynch(mxfil)

#ifdef cray
      integer iblock(ibloclen,mxfil)
#else !cray
      byte iblock(ibloclen,mxfil)
#endif cray


c
c              space for dictionary search entries for each file
c     idirty=1 iff a file has been opened since the last
c     dimension vector was buffered in (cf cllun,getindex)
c
      common /drsdict/ n_rec,n_src,n_nam,n_tit,n_un,n_lun,idirty
c
      integer n_rec(2,mxfil)
      character*120 n_src(mxent)
      character*16  n_nam(mxent)
      character*80  n_tit(mxent)
      character*40  n_un (mxent)
      integer n_lun(mxent)
      integer idirty

c     error reporting info

      common /drserror/ currenterror, curreplevel, ierrun
      integer currenterror,curreplevel

      common /drscerr/ curroutine
      character*8 curroutine
      
c     save buffers for savevdbs,restvdbs

      common /drssave/ cavdbsav,qavdbsav,cuvdbsav,quvdbsav,
     $     cuvd2sav,iuvdbsav,qddbsav,nbufsav

      character cavdbsav(mxdepth,mxbuf)
      integer qavdbsav(mxdepth,mxiabuf)
      character cuvdbsav(mxdepth,mxbuf)
      integer quvdbsav(mxdepth,mxiubuf)
      character cuvd2sav(mxdepth,mxubuf2)
      integer iuvdbsav(mxdepth,mxiuvdb)
      integer qddbsav(mxdepth,mxqddb)

c     save lu for getvdim

      common /drslusav/ isavelu



