# kst - simple terminal
# See LICENSE file for copyright and license details.
.POSIX:
.SUFFIXES:

include config.mk

SRC = st.c x.c boxdraw.c
OBJ = $(SRC:.c=.o)

all: kst

config.h:
	cp config.def.h config.h

.c.o:
	$(CC) $(STCFLAGS) -c $<

st.o: config.h st.h win.h
x.o: arg.h config.h st.h win.h
boxdraw.o: config.h st.h boxdraw_data.h

$(OBJ): config.h config.mk

kst: $(OBJ)
	$(CC) -o $@ $(OBJ) $(STLDFLAGS)

clean:
	rm -f kst $(OBJ) kst-$(VERSION).tar.gz

dist: clean
	mkdir -p kst-$(VERSION)
	cp -R LICENSE Makefile README.md arg.h config.def.h config.mk kst.info \
		kst.1 st.h st.c x.c boxdraw.c boxdraw_data.h \
		win.h patches kst-$(VERSION)
	tar -cf - kst-$(VERSION) | gzip > kst-$(VERSION).tar.gz
	rm -rf kst-$(VERSION)

install: kst
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f kst $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/kst
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < kst.1 > $(DESTDIR)$(MANPREFIX)/man1/kst.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/kst.1
	tic -sx kst.info
	@echo Please see the README file regarding the terminfo entry of kst.

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/kst
	rm -f $(DESTDIR)$(MANPREFIX)/man1/kst.1

.PHONY: all clean dist install uninstall
