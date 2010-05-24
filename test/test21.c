/* Test inquiry of similarly named variables */

#include <stdio.h>
#include <strings.h>
#include "drscdf.h"

main()
{

	DRS_SOURCE source;
	DRS_NAME name;
	DRS_TITLE title;
	DRS_UNITS units;
	DRS_DATE date;
	DRS_TIME time;
	DRS_TYPE etype;
	
	int ndim,ierr;

/* 	f_init(); */
	ierr=Aslun(2,"test20",3," ",IDRS_READ);
	ierr=Cluvdb();
	ierr=Prdict(6,2);

	exit(0);
}
