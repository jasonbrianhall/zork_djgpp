# Makefile for dungeon with DJGPP Docker support

# Docker image configuration
DJGPP_IMAGE = djfdyuruiry/djgpp
MINGW_IMAGE = mdashnet/mingw
DOCKER_RUN = docker run --rm -v $(PWD):/src:z -w /src

# Get current user and group IDs for Docker
USER_ID = $(shell id -u)
GROUP_ID = $(shell id -g)

# Output names - using uppercase for DOS convention
DOS_TARGET = ZORK.EXE
WINDOWS_TARGET = zork_windows.exe

TEMP_TARGET = temp_zork.exe  # Temporary target for case-sensitivity handling

# Compiler settings (inside Docker DJGPP environment)
CC = $(DOCKER_RUN) -u $(USER_ID):$(GROUP_ID) $(DJGPP_IMAGE) gcc
MINGW_CC = x86_64-w64-mingw32-gcc
CFLAGS = -Wall

# Terminal handling - using option 4 (no more facility) for DOS
TERMFLAG = -DMORE_NONE
LIBS =

# Debug tool flag
GDTFLAG = -DALLOW_GDT

# Source files
CSRC =	actors.c ballop.c clockr.c demons.c dgame.c dinit.c dmain.c\
	dso1.c dso2.c dso3.c dso4.c dso5.c dso6.c dso7.c dsub.c dverb1.c\
	dverb2.c gdt.c lightp.c local.c nobjs.c np.c np1.c np2.c np3.c\
	nrooms.c objcts.c rooms.c sobjs.c supp.c sverbs.c verbs.c villns.c

# Object files
OBJS =	actors.o ballop.o clockr.o demons.o dgame.o dinit.o dmain.o\
	dso1.o dso2.o dso3.o dso4.o dso5.o dso6.o dso7.o dsub.o dverb1.o\
	dverb2.o gdt.o lightp.o local.o nobjs.o np.o np1.o np2.o np3.o\
	nrooms.o objcts.o rooms.o sobjs.o supp.o sverbs.o verbs.o villns.o

# CSDPMI settings
CSDPMI_URL = http://na.mirror.garr.it/mirrors/djgpp/current/v2misc/csdpmi7b.zip

all: build-all

# Build the DOS executable with case handling
$(DOS_TARGET): $(OBJS) dtextc.dat
	$(CC) $(CFLAGS) -o $(TEMP_TARGET) $(OBJS) $(LIBS)
	rm -f $(DOS_TARGET)
	mv $(TEMP_TARGET) $(DOS_TARGET)

# Data file creation
dtextc.dat:
	$(DOCKER_RUN) -u $(USER_ID):$(GROUP_ID) $(DJGPP_IMAGE) /bin/sh -c "\
		cat dtextc.uu1 dtextc.uu2 dtextc.uu3 dtextc.uu4 | uudecode"

# Special compilation rules
dinit.o: dinit.c funcs.h vars.h
	$(CC) $(CFLAGS) $(GDTFLAG) -DTEXTFILE=\"dtextc.dat\" -c dinit.c

dgame.o: dgame.c funcs.h vars.h
	$(CC) $(CFLAGS) $(GDTFLAG) -c dgame.c

gdt.o: gdt.c funcs.h vars.h
	$(CC) $(CFLAGS) $(GDTFLAG) -c gdt.c

local.o: local.c funcs.h vars.h
	$(CC) $(CFLAGS) $(GDTFLAG) -c local.c

supp.o: supp.c funcs.h vars.h 
	$(CC) $(CFLAGS) $(TERMFLAG) -c supp.c

# Default compilation rule for other object files
%.o: %.c funcs.h vars.h
	$(CC) $(CFLAGS) -c $<

# Clean target
clean:
	rm -f $(OBJS) $(DOS_TARGET) $(TEMP_TARGET) core dsave.dat *~ *.o *.EXE *.exe
	rm -rf csdpmi

# Docker and DJGPP setup targets
pull-djgpp:
	docker pull $(DJGPP_IMAGE)

get-csdpmi:
	wget $(CSDPMI_URL)
	unzip -o csdpmi7b.zip -d csdpmi
	cp csdpmi/bin/CWSDPMI.EXE .

# Complete build target including CSDPMI
msdos: pull-djgpp get-csdpmi $(DOS_TARGET)

unix:
	gcc *.c -o zork

build-all: pull-djgpp pull-mingw dtextc.dat msdos unix windows
	@echo "All builds completed"

windows: pull-mingw dtextc.dat
	@echo "Starting Windows build..."
	$(DOCKER_RUN) -u $(USER_ID):$(GROUP_ID) $(MINGW_IMAGE) /bin/sh -c "cd /src && $(MINGW_CC) $(CSRC) -o $(WINDOWS_TARGET)"
	@echo "Windows Build Complete"

pull-mingw:
	docker pull $(MINGW_IMAGE)

# Run with DOSBox target
run: msdos
	dosbox $(DOS_TARGET)

# Help target
help:
	@echo "Dungeon/Zork Makefile with DJGPP Docker support"
	@echo ""
	@echo "Targets:"
	@echo "  msdos       - Build complete DOS version with CSDPMI (using Docker)"
	@echo "  run         - Build and run in DOSBox"
	@echo "  clean       - Remove built files"
	@echo "  pull-djgpp  - Pull the DJGPP Docker image"
	@echo "  get-csdpmi  - Download CSDPMI runtime"
	@echo "  unix        - Build for UNIX or Linux"
	@echo "  windows     - Build for Windows (using docker)"
	@echo ""
	@echo "Usage:"
	@echo "  make pull-djgpp  # First time setup"
	@echo "  make msdos       # Build complete DOS version"
	@echo "  make run         # Build and run in DOSBox"
	@echo "  make unix        # Build on UNIX or Linux"
	@echo "  make windows     # Build for Windows on Unix or Linux"
	@echo "  make             # Make all"
	@echo "  make clean       # Clean up"

.PHONY: all msdos unix windows clean pull-djgpp get-csdpmi run help
