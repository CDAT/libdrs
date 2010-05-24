c     read/write character data

#include "drsdef.h"
      character*30 tryc(IDRS_CANNOTWRITEHEADER),
     $     tryc2(IDRS_CANNOTWRITEHEADER)
      integer aslun,cluvdb,setname,setdim,putdat,cllun,
     $     getdat
      integer setdate
      logical drstest
      character*8 date,time
      character*80 drsmsg(IDRS_LASTERROR)

      data drsmsg(IDRS_NOMEMORY)
     $     /'Cannot allocate dynamic memory.'/
      data drsmsg(IDRS_BINFAILED-2000)
     $     /'Data value lookup failed.'/
      data drsmsg(IDRS_BADLEN)
     $/'A vector length was .lt.1 or not large enough for data'/
      data drsmsg(IDRS_NOMONO)
     $     /'No monotonicity specified for a vector of length >1'/
      data drsmsg(IDRS_NOCOMPARISON-2000)
     $     /'Variable names do not compare.'/
      data drsmsg(IDRS_VDBNOTFOUND)
     $     /'Variable not found in dictionary.'/
      data drsmsg(IDRS_BADDIM)
     $     /'An input dimension or dimension limit is incorrect.'/
      data drsmsg(IDRS_NOTMONOTONE)
     $     /'Resulting dimension variable will not be monotone.'/
      data drsmsg(IDRS_DICTREADERROR)
     $     /'Error reading dictionary file.'/
      data drsmsg(IDRS_NODICTFILE)
     $     /'Cannot find dictionary file.'/
      data drsmsg(IDRS_BADLU)
     $     /'Bad logical unit number.'/
      data drsmsg(IDRS_BADTYPE)
     $     /'Data length or data type illegal.'/
      data drsmsg(IDRS_AMBIGUITYEXISTS)
     $     /'An ambiguity exists between user vdb and file data.'/
      data drsmsg(IDRS_CANNOTADDDATA)
     $     /'Cannot add to existing data.'/
      data drsmsg(IDRS_DICTFULL)
     $     /'Dictionary is full.'/
      data drsmsg(IDRS_VERSION1FILE-1000)
     $     /'Warning: version 1 file found.'/
      data drsmsg(IDRS_NEWFILEFORMAT-1000)
     $     /'Warning: File format is newer than code.'/
      data drsmsg(IDRS_CANNOTREADHEADER)
     $     /'Cannot read dictionary file header.'/
      data drsmsg(IDRS_CANNOTREADDATA)
     $     /'Cannot read data file.'/
      data drsmsg(IDRS_BADDIMNAME)
     $     /'Bad dimension name.'/
      data drsmsg(IDRS_TOOMANYFILES)
     $     /'Too many files open.'/
      data drsmsg(IDRS_CANNOTOPENDICT)
     $     /'Cannot open dictionary file.'/
      data drsmsg(IDRS_CANNOTOPENDATA)
     $     /'Cannot open data file.'/
      data drsmsg(IDRS_BADSTATUS)
     $     /'Bad file status specified.'/
      data drsmsg(IDRS_BADDIMTYPE)
     $     /'Bad dimension type specified.'/
      data drsmsg(IDRS_INDEXHIGH-2000)
     $     /'Lookup found index larger than vector length.'/
      data drsmsg(IDRS_INDEXLOW-2000)
     $     /'Lookup returned 0 index.'/
      data drsmsg(IDRS_INDEXBETWEEN-2000)
     $     /'Element is in vector range, but does not match value.'/
      data drsmsg(IDRS_NORANGE)
     $     /'A data range does not overlap file data.'/
      data drsmsg(IDRS_SAVEBUFOVERFLOW)
     $     /'Internal save buffer overflow.'/
      data drsmsg(IDRS_BADERRLEVEL)
     $     /'A bad error report level was specified.'/
      data drsmsg(IDRS_ERROROUTOFRANGE)
     $     /'Error number is out of range.'/
      data drsmsg(IDRS_CANNOTWRITEHEADER)
     $     /'Cannot write dictionary file header.'/
      data drsmsg(IDRS_CANNOTWRITEDATA)
     $     /'Cannot write a data file record.'/
      data drsmsg(IDRS_BADCHARLEN)
     $     /'A Cray variable character length not a multiple of 8.'/
      data drsmsg(IDRS_BADOPER)
     $     /'A bad dictionary file inquiry operator was specified.'/
      data drsmsg(IDRS_NOMOREVARS-1000)
     $     /'Warning: No more matching variables found in search.'/
      data drsmsg(IDRS_DICTALREADYOPEN)
     $     /'Dictionary file is already open on a different unit.'/
      data drsmsg(IDRS_LOOKUPFAILED-2000)
     $     /'Dictionary lookup failed.'/
      data drsmsg(IDRS_DICTWRITEERROR)
     $     /'Error writing to dictionary file.'/
      data drsmsg(IDRS_DICTEXTENDERROR)
     $     /'Error extending dictionary file.'/
      data drsmsg(IDRS_DATEXTENDERROR)
     $     /'Error extending data file.'/
      data drsmsg(IDRS_DICTRUNCATEERR)
     $     /'Error truncating dictionary file.'/
      data drsmsg(IDRS_DATTRUNCATEERR)
     $     /'Error truncating data file.'/
      data drsmsg(IDRS_BADIEEEFP-1000)
     $     /'Bad IEEE floating point number, cannot translate.'/
      data drsmsg(IDRS_BADCRAYFP-1000)
     $     /'Bad CRAY floating point number, cannot translate.'/
      data drsmsg(IDRS_BADCRAYINT-1000)
     $     /'Bad CRAY integer encountered during translation.'/
      data drsmsg(IDRS_CANNOTCONVERT)
     $     /'Cannot convert data as requested.'/
      data drsmsg(IDRS_INEXACTMATCH-1000)
     $     /'Naming info is similar, but names do not match.'/
      data date/' 1/10/90'/,time/'11:05:30'/

c      ierr=system("rm -f dvtest16.dic")
c      ierr=system("rm -f dvtest16.dat")

      do 10 i=1,IDRS_CANNOTWRITEHEADER
         tryc(i)=drsmsg(i)(1:30)
         tryc2(i)=' '
 10   continue

      lu=2
      lud=3

c      ierr=seterr(6,IDRS_WARNING)
      
      if(drstest(aslun(lu,'dvtest16.dic',lud,
     $    'dvtest16.dat',IDRS_CREATE))) go to 9000

c     write a character array

      if(drstest(cluvdb())) go to 9000
      if(drstest(setname('trial run','tryc','trial character array', 
     $     'none','C*30'))) go to 9000
      if(drstest(setdim(1,'ernum','error number',
     $     IDRS_CANNOTWRITEHEADER,1.0,
     $     real(IDRS_CANNOTWRITEHEADER))))
     $     go to 9000
      ierr=setdate(date,time)      
      if(drstest(putdat(lu,tryc))) go to 9000

c     read character array

      if(drstest(cllun(lu))) go to 9000
      if(drstest(aslun(lu,'dvtest16.dic',lud,
     $    'dvtest16.dat',IDRS_READ))) go to 9000
      if(drstest(cluvdb())) go to 9000
      if(drstest(setname(' ','tryc',' ',' ',' '))) go to 9000
      if(drstest(getdat(lu,tryc2,30*IDRS_CANNOTWRITEHEADER)))
     $     go to 9000

c     see if arrays agree

      do 100 i=1,IDRS_CANNOTWRITEHEADER
         if(tryc(i).ne.tryc2(i)) then
            print *,'tryc = ',tryc(i)
            print *,'tryc2 = ',tryc2(i),', at ',i
            go to 9000
         endif
 100  continue
 9000 continue
c      stop
      ierr=cllun(lu)
      end
