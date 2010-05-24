#!/usr/bin/env python

# Copy updated files to ~/install/drs/lib

sources = [
"Makefile.ALPHA",
"Makefile.HP",
"Makefile.IBM",
"Makefile.LINUX.ABSOFT",
"Makefile.LINUX.PGI",
"Makefile.NSL",
"Makefile.SGI",
"Makefile.SOL",
"Makefile.SUN",
"Makefile.UNICOS",
"README",
"Rtag.log",
"aslun.F",
"bdata.F",
"bnsrch.F",
"clavdb.F",
"cllun.F",
"cluvdb.F",
"compnm.F",
"confnm.F",
"ctoi.c",
"cycle.h",
"d_floor.F",
"dictlk.F",
"drsautosync.F",
"drsc.c",
"drscdf.h",
"drscom.h",
"drsdef.H",
"drsdef.IBM",
"drserr.F",
"drsreadb.F",
"drssync.F",
"drstrunc.c",
"getcdim.F",
"getdat.F",
"getdat1.F",
"getdim.F",
"getedim.F",
"getelemd.F",
"getind.F",
"getnam.F",
"getnd.F",
"getpelem.F",
"getrge.F",
"getrge2.F",
"getslab.c",
"gettbuf.F",
"getvdim.F",
"idenc.F",
"iflun.F",
"inqdict.F",
"inqlun.F",
"midate.F",
"mimem.F",
"mvnbc.F",
"prdict.F",
"putdat.F",
"putdat1.F",
"putdic.F",
"putvdm.F",
"rdtrans.F",
"readhd.F",
"redat.F",
"redic.F",
"savdb.F",
"setcdim.F",
"setdat.F",
"setdim.F",
"seterr.F",
"setnam.F",
"setrep.F",
"setvdm.F",
"wrdat.F",
"wrdic.F",
"writehd.F",
"wrtrans.F"
]

def diffit(file,op=0):
    if op==0:
        result = os.system("diff %s ~/install/drs/lib/%s > /dev/null"%(file,file))
    else:
        print "< ~/drs/lib"
        print "> ~/install/drs/lib"
        result = os.system("diff %s ~/install/drs/lib/%s"%(file,file))
    return result

def copyit(file):
    os.system("cp ~/drs/lib/%s ~/install/drs/lib"%(file))

diffsources = []
for file in sources:
    if diffit(file)!=0:
        diffsources.append(file)

print "Copying:",diffsources
for file in diffsources:
    copyit(file)
