c Fortran interface to C functions for Macintosh OS X memory mapping
c Call fmapf around the time of opening a file, and funmapf around the time of closing it;
c the calls can be before or after.

      function fmapf( path ) result (ierr)
      implicit none
      character path*(*)
      integer ierr, pathlen, mapf
      pathlen = len_trim(path)
      ierr = mapf( path, pathlen )
      end function fmapf

      function funmapf() result (ierr)
      implicit none
      integer ierr, unmapf
      ierr = unmapf()
      end function funmapf
