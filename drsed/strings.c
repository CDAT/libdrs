				/* Trim leading and trailing blanks from s */
/* strings.c,v 2.0 1992/03/02 23:14:59 drach Released
   strings.c,v
 * Revision 2.0  1992/03/02  23:14:59  drach
 * Entered into RCS
 *
*/
char *strtrim(s)
	char *s;
{
	char *t,*u;
				/* Trim leading blanks */
	for(t=u=s; *t==' '; t++);
	while(*u++ = *t++);
				/* Trim trailing blanks */
	for(u-=2; u>=s && *u==' '; u--);
	*++u='\0';
	return(s);
}
