# kst - simple terminal
# See LICENSE file for copyright and license details.
.POSIX:
.SUFFIXES:

include config.mk

# Source files
SRC = st.c x.c boxdraw.c
OBJ = $(SRC:.c=.o)

# Targets
all: kst

# Generate config.h from config.def.h if needed
config.h:
	@echo creating $@ from config.def.h
	@cp config.def.h config.h

# Object file compilation rules
.c.o:
	@echo CC $<
	@$(CC) $(STCFLAGS) -c $<

# Dependencies
st.o: config.h st.h win.h
x.o: arg.h config.h st.h win.h
boxdraw.o: config.h st.h boxdraw_data.h

$(OBJ): config.h config.mk

# Link the final executable
kst: $(OBJ)
	@echo LD $@
	@$(CC) -o $@ $(OBJ) $(STLDFLAGS)

# Clean up build artifacts
clean:
	@echo cleaning
	@rm -f kst $(OBJ) kst-$(VERSION).tar.gz

# Create a distribution tarball
dist: clean
	@echo creating dist tarball
	@mkdir -p kst-$(VERSION)
	@cp -R LICENSE Makefile README.md arg.h config.def.h config.mk kst.info \
		kst.1 st.h st.c x.c boxdraw.c boxdraw_data.h \
		win.h patches kst-$(VERSION)
	@tar -cf - kst-$(VERSION) | gzip > kst-$(VERSION).tar.gz
	@rm -rf kst-$(VERSION)

# Install the application
install: kst
	@echo installing executable file to $(DESTDIR)$(PREFIX)/bin
	@mkdir -p $(DESTDIR)$(PREFIX)/bin
	@cp -f kst $(DESTDIR)$(PREFIX)/bin
	@chmod 755 $(DESTDIR)$(PREFIX)/bin/kst
	@echo installing manual page to $(DESTDIR)$(MANPREFIX)/man1
	@mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	@sed "s/VERSION/$(VERSION)/g" < kst.1 > $(DESTDIR)$(MANPREFIX)/man1/kst.1
	@chmod 644 $(DESTDIR)$(MANPREFIX)/man1/kst.1
	@echo installing terminfo entry
	@tic -sx kst.info
	@echo "Please see the README file regarding the terminfo entry of kst."

# Uninstall the application
uninstall:
	@echo removing executable file from $(DESTDIR)$(PREFIX)/bin
	@rm -f $(DESTDIR)$(PREFIX)/bin/kst
	@echo removing manual page from $(DESTDIR)$(MANPREFIX)/man1
	@rm -f $(DESTDIR)$(MANPREFIX)/man1/kst.1

.PHONY: all clean dist install uninstall
