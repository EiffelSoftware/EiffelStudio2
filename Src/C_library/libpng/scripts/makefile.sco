# makefile for SCO OSr5  ELF and Unixware 7 with Native cc
# Contributed by Mike Hopkirk (hops at sco.com) modified from Makefile.lnx
#   force ELF build dynamic linking, SONAME setting in lib and RPATH in app
# Copyright (C) 2002, 2006, 2010-2014 Glenn Randers-Pehrson
# Copyright (C) 1998 Greg Roelofs
# Copyright (C) 1996, 1997 Andreas Dilger
#
# This code is released under the libpng license.
# For conditions of distribution and use, see the disclaimer
# and license in png.h

# Library name:
LIBNAME = libpng16
PNGMAJ = 16

# Shared library names:
LIBSO=$(LIBNAME).so
LIBSOMAJ=$(LIBNAME).so.$(PNGMAJ)
LIBSOREL=$(LIBSOMAJ).$(RELEASE)
OLDSO=libpng.so

# Utilities:
CC=cc
AR_RC=ar rc
MKDIR_P=mkdir
LN_SF=ln -f -s
RANLIB=echo
CP=cp
RM_F=/bin/rm -f

# where make install puts libpng.a, $(OLDSO)*, and png.h
prefix=/usr/local
exec_prefix=$(prefix)

# Where the zlib library and include files are located
#ZLIBLIB=/usr/local/lib
#ZLIBINC=/usr/local/include
ZLIBLIB=../zlib
ZLIBINC=../zlib

CPPFLAGS=-I$(ZLIBINC)
CFLAGS= -dy -belf -O3
LDFLAGS=-L. -L$(ZLIBLIB) -lpng16 -lz -lm

INCPATH=$(prefix)/include
LIBPATH=$(exec_prefix)/lib
MANPATH=$(prefix)/man
BINPATH=$(exec_prefix)/bin

# override DESTDIR= on the make install command line to easily support
# installing into a temporary location.  Example:
#
#    make install DESTDIR=/tmp/build/libpng
#
# If you're going to install into a temporary location
# via DESTDIR, $(DESTDIR)$(prefix) must already exist before
# you execute make install.
DESTDIR=

DB=$(DESTDIR)$(BINPATH)
DI=$(DESTDIR)$(INCPATH)
DL=$(DESTDIR)$(LIBPATH)
DM=$(DESTDIR)$(MANPATH)

# Pre-built configuration
# See scripts/pnglibconf.mak for more options
PNGLIBCONF_H_PREBUILT = scripts/pnglibconf.h.prebuilt

OBJS = png.o pngset.o pngget.o pngrutil.o pngtrans.o pngwutil.o \
	pngread.o pngrio.o pngwio.o pngwrite.o pngrtran.o \
	pngwtran.o pngmem.o pngerror.o pngpread.o

OBJSDLL = $(OBJS:.o=.pic.o)

.SUFFIXES:      .c .o .pic.o

.c.o:
	$(CC) -c $(CPPFLAGS) $(CFLAGS) -o $@ $<

.c.pic.o:
	$(CC) -c $(CPPFLAGS) $(CFLAGS) -KPIC -o $@ $*.c

all: libpng.a $(LIBSO) pngtest libpng.pc libpng-config

pnglibconf.h: $(PNGLIBCONF_H_PREBUILT)
	$(CP) $(PNGLIBCONF_H_PREBUILT) $@

libpng.a: $(OBJS)
	$(AR_RC) $@ $(OBJS)
	$(RANLIB) $@

libpng.pc:
	cat scripts/libpng.pc.in | sed -e s!@prefix@!$(prefix)! \
	-e s!@exec_prefix@!$(exec_prefix)! \
	-e s!@libdir@!$(LIBPATH)! \
	-e s!@includedir@!$(INCPATH)! \
	-e s!-lpng16!-lpng16\ -lz\ -lm! > libpng.pc

libpng-config:
	( cat scripts/libpng-config-head.in; \
	echo prefix=\"$(prefix)\"; \
	echo I_opts=\"-I$(INCPATH)/$(LIBNAME)\"; \
	echo ccopts=\"-belf\"; \
	echo L_opts=\"-L$(LIBPATH)\"; \
	echo libs=\"-lpng16 -lz -lm\"; \
	cat scripts/libpng-config-body.in ) > libpng-config
	chmod +x libpng-config

$(LIBSO): $(LIBSOMAJ)
	$(LN_SF) $(LIBSOMAJ) $(LIBSO)

$(LIBSOMAJ): $(OBJSDLL)
	$(CC) -G  -Wl,-h,$(LIBSOMAJ) -o $(LIBSOMAJ) \
	 $(OBJSDLL)

pngtest: pngtest.o $(LIBSO)
	LD_RUN_PATH=.:$(ZLIBLIB) $(CC) -o pngtest $(CFLAGS) pngtest.o $(LDFLAGS)

test: pngtest
	./pngtest

install-headers: png.h pngconf.h pnglibconf.h
	-@if [ ! -d $(DI) ]; then $(MKDIR_P) $(DI); fi
	-@if [ ! -d $(DI)/$(LIBNAME) ]; then $(MKDIR_P) $(DI)/$(LIBNAME); fi
	-@$(RM_F) $(DI)/png.h
	-@$(RM_F) $(DI)/pngconf.h
	-@$(RM_F) $(DI)/pnglibconf.h
	cp png.h pngconf.h pnglibconf.h $(DI)/$(LIBNAME)
	chmod 644 $(DI)/$(LIBNAME)/png.h $(DI)/$(LIBNAME)/pngconf.h $(DI)/$(LIBNAME)/pnglibconf.h
	-@$(RM_F) $(DI)/png.h $(DI)/pngconf.h $(DI)/pnglibconf.h
	-@$(RM_F) $(DI)/libpng
	(cd $(DI); $(LN_SF) $(LIBNAME) libpng; $(LN_SF) $(LIBNAME)/* .)

install-static: install-headers libpng.a
	-@if [ ! -d $(DL) ]; then $(MKDIR_P) $(DL); fi
	cp libpng.a $(DL)/$(LIBNAME).a
	chmod 644 $(DL)/$(LIBNAME).a
	-@$(RM_F) $(DL)/libpng.a
	(cd $(DL); $(LN_SF) $(LIBNAME).a libpng.a)

install-shared: install-headers $(LIBSOMAJ) libpng.pc
	-@if [ ! -d $(DL) ]; then $(MKDIR_P) $(DL); fi
	-@$(RM_F) $(DL)/$(LIBSO)
	-@$(RM_F) $(DL)/$(LIBSOREL)
	-@$(RM_F) $(DL)/$(OLDSO)
	cp $(LIBSOMAJ) $(DL)/$(LIBSOREL)
	chmod 755 $(DL)/$(LIBSOREL)
	(cd $(DL); \
	$(LN_SF) $(LIBSOREL) $(LIBSO); \
	$(LN_SF) $(LIBSO) $(OLDSO))
	-@if [ ! -d $(DL)/pkgconfig ]; then $(MKDIR_P) $(DL)/pkgconfig; fi
	-@$(RM_F) $(DL)/pkgconfig/$(LIBNAME).pc
	-@$(RM_F) $(DL)/pkgconfig/libpng.pc
	cp libpng.pc $(DL)/pkgconfig/$(LIBNAME).pc
	chmod 644 $(DL)/pkgconfig/$(LIBNAME).pc
	(cd $(DL)/pkgconfig; $(LN_SF) $(LIBNAME).pc libpng.pc)

install-man: libpng.3 libpngpf.3 png.5
	-@if [ ! -d $(DM) ]; then $(MKDIR_P) $(DM); fi
	-@if [ ! -d $(DM)/man3 ]; then $(MKDIR_P) $(DM)/man3; fi
	-@$(RM_F) $(DM)/man3/libpng.3
	-@$(RM_F) $(DM)/man3/libpngpf.3
	cp libpng.3 $(DM)/man3
	cp libpngpf.3 $(DM)/man3
	-@if [ ! -d $(DM)/man5 ]; then $(MKDIR_P) $(DM)/man5; fi
	-@$(RM_F) $(DM)/man5/png.5
	cp png.5 $(DM)/man5

install-config: libpng-config
	-@if [ ! -d $(DB) ]; then $(MKDIR_P) $(DB); fi
	-@$(RM_F) $(DB)/libpng-config
	-@$(RM_F) $(DB)/$(LIBNAME)-config
	cp libpng-config $(DB)/$(LIBNAME)-config
	chmod 755 $(DB)/$(LIBNAME)-config
	(cd $(DB); $(LN_SF) $(LIBNAME)-config libpng-config)

install: install-static install-shared install-man install-config

# If you installed in $(DESTDIR), test-installed won't work until you
# move the library to its final location.  Use test-dd to test it
# before then.

test-dd:
	echo
	echo Testing installed dynamic shared library in $(DL).
	$(CC) -I$(DI) $(CPPFLAGS) \
	   `$(BINPATH)/$(LIBNAME)-config --cflags` pngtest.c \
	   -L$(DL) -L$(ZLIBLIB) \
	   -o pngtestd `$(BINPATH)/$(LIBNAME)-config --ldflags`
	./pngtestd pngtest.png

test-installed:
	$(CC) $(CPPFLAGS) $(CFLAGS) \
	   `$(BINPATH)/$(LIBNAME)-config --cflags` pngtest.c \
	   -L$(ZLIBLIB) \
	   -o pngtesti `$(BINPATH)/$(LIBNAME)-config --ldflags`
	./pngtesti pngtest.png

clean:
	$(RM_F) *.o libpng.a pngtest pngout.png libpng-config \
	$(LIBSO) $(LIBSOMAJ)* pngtest-static pngtesti \
	pnglibconf.h libpng.pc

DOCS = ANNOUNCE CHANGES INSTALL KNOWNBUG LICENSE README TODO Y2KINFO
writelock:
	chmod a-w *.[ch35] $(DOCS) scripts/*

# DO NOT DELETE THIS LINE -- make depend depends on it.

png.o png.pic.o: png.h pngconf.h pnglibconf.h pngpriv.h pngstruct.h pnginfo.h pngdebug.h
pngerror.o pngerror.pic.o: png.h pngconf.h pnglibconf.h pngpriv.h pngstruct.h pnginfo.h pngdebug.h
pngrio.o pngrio.pic.o: png.h pngconf.h pnglibconf.h pngpriv.h pngstruct.h pnginfo.h pngdebug.h
pngwio.o pngwio.pic.o: png.h pngconf.h pnglibconf.h pngpriv.h pngstruct.h pnginfo.h pngdebug.h
pngmem.o pngmem.pic.o: png.h pngconf.h pnglibconf.h pngpriv.h pngstruct.h pnginfo.h pngdebug.h
pngset.o pngset.pic.o: png.h pngconf.h pnglibconf.h pngpriv.h pngstruct.h pnginfo.h pngdebug.h
pngget.o pngget.pic.o: png.h pngconf.h pnglibconf.h pngpriv.h pngstruct.h pnginfo.h pngdebug.h
pngread.o pngread.pic.o: png.h pngconf.h pnglibconf.h pngpriv.h pngstruct.h pnginfo.h pngdebug.h
pngrtran.o pngrtran.pic.o: png.h pngconf.h pnglibconf.h pngpriv.h pngstruct.h pnginfo.h pngdebug.h
pngrutil.o pngrutil.pic.o: png.h pngconf.h pnglibconf.h pngpriv.h pngstruct.h pnginfo.h pngdebug.h
pngtrans.o pngtrans.pic.o: png.h pngconf.h pnglibconf.h pngpriv.h pngstruct.h pnginfo.h pngdebug.h
pngwrite.o pngwrite.pic.o: png.h pngconf.h pnglibconf.h pngpriv.h pngstruct.h pnginfo.h pngdebug.h
pngwtran.o pngwtran.pic.o: png.h pngconf.h pnglibconf.h pngpriv.h pngstruct.h pnginfo.h pngdebug.h
pngwutil.o pngwutil.pic.o: png.h pngconf.h pnglibconf.h pngpriv.h pngstruct.h pnginfo.h pngdebug.h
pngpread.o pngpread.pic.o: png.h pngconf.h pnglibconf.h pngpriv.h pngstruct.h pnginfo.h pngdebug.h

pngtest.o: png.h pngconf.h pnglibconf.h
