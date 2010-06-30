/* Test C interface */

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

	ierr=Aslun(2,"../drsed/ts_Mean_Vmodel2_20c3m_am_xy_EM_r1900_1999.dic",3,"../drsed/ts_Mean_Vmodel2_20c3m_am_xy_EM_r1900_1999.dat",IDRS_READ);
	ierr=Cluvdb();
	if(Inqdict(2,IDRS_GETFIRSTVAR)==IDRS_NOMOREVARS) 
	{
		printf("Error: dvtest1.dic is empty\n");
		exit(1);
	}
	ierr=Getname(source,name,title,units,date,time,etype,&ndim);
	printf("source=%s\nname=%s\ntitle=%s\nunits=%s\n",
	       source,name,title,units);
	printf("date=%s\ntime=%s\ntype=%s\nNumber of dimensions=%d\n",
	       date,time,etype,ndim);
	exit(0);
}

