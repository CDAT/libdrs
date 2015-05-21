/* Macintosh-only functions in C .  Checked only for 64-bit Macintosh OS X */
/* At the moment, this file only contains memory mapping code, which isn't used by default. */

#include <sys/types.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>

static void * Data;
static size_t DataLen;

/* The following is adapted from
 http://developer.apple.com/library/mac/#documentation/Performance/Conceptual/FileSystem/Articles/MappingFiles.html */

/* usage example: 
  Note that inPathName is input-only, a string.  And dataPtr, dataLength are needed only so that
  munmap can unmap the right part of memory. */
/*
void ProcessFile( char * inPathName )
{
    size_t dataLength;
    void * dataPtr;

    if( MapFile( inPathName, &dataPtr, &dataLength ) == 0 )
    {
        //
        // process the data and unmap the file
        //
        // . . .

        munmap( dataPtr, dataLength );
    }
}
*/

 /* These little functions will let Fortran interface to mmap (through MapFile)
 and munmap.   At the moment, assume that only _one_ file will be mapped.
Later, I will have to relax this by building arrays in place of Data and DataLen.
Even so, in that case I will assume that no file is mapped twice, and all will
be unmapped together. */
int mapf_( char * inPathName, int *PathNameLen ) {
  char PathName[1024];    /* <<<< is there an existing parameter I can use for max path length? <<< */
  strncpy(PathName,inPathName,*PathNameLen);
  PathName[*PathNameLen]='\0';
  return MapFile( PathName, &Data, &DataLen );
}
int unmapf_() {
  munmap( Data, DataLen );
  return 0;
}
 
// MapFile
// Return the contents of the specified file as a read-only pointer.
//
// Enter:inPathName is a UNIX-style "/"-delimited pathname
//
// Exit:    outDataPtra     pointer to the mapped memory region
//          outDataLength   size of the mapped memory region
//          return value    an errno value on error (see sys/errno.h)
//                          or zero for success
//
int MapFile( char * inPathName, void ** outDataPtr, size_t * outDataLength )
{
    int outError;
    int fileDescriptor;
    struct stat statInfo;
 
    // Return safe values on error.
    outError = 0;
    *outDataPtr = NULL;
    *outDataLength = 0;
 
    // Open the file.
    fileDescriptor = open( inPathName, O_RDONLY, 0 );
    if( fileDescriptor < 0 )
    {
       outError = errno;
    }
    else
    {
        // We now know the file exists. Retrieve the file size.
        if( fstat( fileDescriptor, &statInfo ) != 0 )
        {
            outError = errno;
        }
        else
        {
            // Map the file into a read-only memory region.
            *outDataPtr = mmap(NULL,
                                statInfo.st_size,
                                PROT_READ | PROT_WRITE,
                                0,
                                fileDescriptor,
                                0);
            if( *outDataPtr == MAP_FAILED )
            {
                outError = errno;
            }
            else
            {
                // On success, return the size of the mapped file.
                *outDataLength = statInfo.st_size;
            }
        }
 
        // Now close the file. The kernel doesn’t use our file descriptor.
        close( fileDescriptor );
    }
 
    return outError;
}
