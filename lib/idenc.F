c idenc.F,v 2.2 1995/03/30 00:51:00 drach Exp
c idenc.F,v
c Revision 2.2  1995/03/30  00:51:00  drach
c Added disclaimer
c
c Revision 2.1  1993/07/13  01:13:15  drach
c Merged Sun, Unicos, SGI, and HP versions.
c
c Revision 2.2  1992/10/14  23:16:15  drach
c Corrected a comment.
c
c Revision 2.1  1992/05/21  00:34:00  drach
c Completely rewrote to handle new naming scheme:
c The new version tests for EQUALITY (not similarity) of strings,
c irrespective of blanks. The comparison is case insensitive.
c A blank string continues to match any string.
c
c Revision 2.0  1992/03/07  00:08:14  drach
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
c***********************************************************************
c
c     Routine: 
c     -------
      logical function idenc(x,y,blank)
c
c     Description:
c     -----------
c     Check the equality of ASCII x and y, irrespective of blanks.
c
c     Arguments:
c     ---------
c     x    =:  ASCII character string
c     y    =:  ASCII character string
c     blank := .true. iff all the characters in x are blank
c
c     
c     Function Returns:
c     ----------------
c     .true. iff x and y are equal, irrespective of blanks and case,
c     or either of x and y is blank
c     
c     Author: Bob Drach
c     ------
c
c     Date: 5/4/92
c     ----
c
c     Notes:
c     -----
c
c     Glossary:
c     --------
c     ix    = pointer into x
c     iy    = pointer into y
c     lenxx = length of x + 1
c     lenyy = length of y + 1
c     xeos  = .true. iff at the end of x
c     yeos  = .true. iff at the end of y
c
c**********************************************************************

c     IDRS_CASEDELTA = ichar('a')-ichar('A')
      parameter (IDRS_CASEDELTA=32)

      character*(*) x,y
      character*1 cx,cy,lcx,lcy
      logical blank,xeos,yeos

      blank=.false.
      lenxx=len(x)+1
      lenyy=len(y)+1
      xeos=(lenxx.eq.1)
      yeos=(lenyy.eq.1)
      ix=1
      iy=1

c     -----------------------------------------------------------------
c     check initial blanks, return match if x or y is blank

 100  continue
      if(xeos) then
         blank=.true.
         go to 600
      endif
      if(x(ix:ix).ne.' ') go to 200
      ix=ix+1
      xeos=(ix.eq.lenxx)
      go to 100
      
 200  continue
      if(yeos) go to 600
      if(y(iy:iy).ne.' ') go to 500
      iy=iy+1
      yeos=(iy.eq.lenyy)
      go to 200
      
c     -----------------------------------------------------------------
c     skip internal and trailing blanks
      
 300  continue
      if(xeos) go to 400
      if(x(ix:ix).ne.' ') go to 400
      ix=ix+1
      xeos=(ix.eq.lenxx)
      go to 300
      
 400  continue
      if(yeos) go to 500
      if(y(iy:iy).ne.' ') go to 500
      iy=iy+1
      yeos=(iy.eq.lenyy)
      go to 400

c     -----------------------------------------------------------------
c     convert to lower case and compare non-blanks

 500  continue

c     advance pointers while not(xeos or yeos or cx is blank or cy is blank)
c     and lcx=lcy
      
      if(.not.xeos) cx = x(ix:ix)
      if(.not.yeos) cy = y(iy:iy)
      if(xeos.or.yeos) go to 550
      if(cx.eq.' ' .or. cy.eq.' ') go to 550
      
      if ('A'.le.cx .and. cx.le.'Z') then
         lcx = char(ichar(cx)+IDRS_CASEDELTA)
      else
         lcx = cx
      endif
      if ('A'.le.cy .and. cy.le.'Z') then
         lcy = char(ichar(cy)+IDRS_CASEDELTA)
      else
         lcy = cy
      endif
         
      if(lcx.ne.lcy) go to 700
      
      ix=ix+1
      xeos=(ix.eq.lenxx)
      iy=iy+1
      yeos=(iy.eq.lenyy)
      go to 500

c     if end-of-string on both strings, then matched
c     if end-of-string on one string, and the other is non-blank, no match
c     otherwise, one strings has blanks, go to skip blanks

 550  continue
      if(xeos.and.yeos) go to 600
      if((xeos.and.(cy.ne.' ')).or.
     $     (yeos.and.(cx.ne.' '))) go to 700
      go to 300

c     -----------------------------------------------------------------
c     matched
 600  continue
      idenc=.true.
      return

c     -----------------------------------------------------------------
c     no match
 700  continue
      idenc=.false.
      return

      end
