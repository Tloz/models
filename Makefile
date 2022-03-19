#   Makefile pour PROG
#   Licence : Project licenced under the terms of the 
#	version 1.0.0
#   can compile and link target executable or test executable

# project name (generate executable with this name)
TARGET=projectName
TARGETTESTS=alltests
all: $(TARGET)

CC=g++
# compiling flags here
CFLAGS=--std=c++1z
CFLAGSSTRICT=-W -Wall -Wextra -pedantic
CFLAGSSUPERSTRICT=-Werror
CFLAGSCHEAT=-fpermissive -Wunused-variable
CFLAGSOPT=-O3

DFLAGS=-g -DDEBUG

LINKER=g++ -o
LFLAGS=-Lbin


rm=rm -f
# change these to set the proper directories where each files should be
BINDIR=bin
INCDIR=inc
LIBDIR=lib
OBJDIR=obj
SRCDIR=src
TESTDIR=tests

INCLUDES:=$(wildcard $(INCDIR)/*.h)
SOURCES:=$(wildcard $(SRCDIR)/*.cpp)
OBJECTS:=$(SOURCES:$(SRCDIR)/%.cpp=$(OBJDIR)/%.o)
TESTS:=$(wildcard $(TESTDIR)/*.cpp)
TESTOBJECTS:=$(TESTS:$(TESTDIR)/%.cpp=$(OBJDIR)/%.o)
TESTBIN:=$(TESTOBJECTS:$(OBJDIR)/%.o=$(BINDIR)/%.test)

################ Building target ################
$(TARGET): $(BINDIR)/$(TARGET)


$(BINDIR)/$(TARGET): $(OBJECTS) obj/main.o
	@$(LINKER) $@ $(LFLAGS) $^
	@echo "Linking complete!"

$(OBJECTS): $(OBJDIR)/%.o : $(SRCDIR)/%.cpp
	@$(CC) $(CFLAGS) -c $< -o $@
	@echo "Compiled "$<" successfully!"

obj/main.o: main.cpp
	@$(CC) $(CFLAGS) -c $< -o $@
	@echo "Compiled "$<" successfully!"
#################################################

################ Building tests #################
tests: $(BINDIR)/alltests

$(BINDIR)/$(TARGETTESTS): $(TESTOBJECTS) $(OBJECTS)
	@$(LINKER) $@ $(LFLAGS) $(TESTOBJECTS) $(OBJECTS)
	@echo "Linking complete!"

$(TESTOBJECTS): $(OBJDIR)/%.o : $(TESTDIR)/%.cpp
	@$(CC) $(CFLAGS) -c $< -o $@
	@echo "Compiled "$<" successfully!"
#################################################

.PHONY: clean mrproper

clean:
	@$(rm) obj/main.o
	@$(rm) $(OBJECTS)
	@$(rm) $(TESTOBJECTS)
	@echo "Cleanup complete!"

mrproper: clean
	@$(rm) $(BINDIR)/$(TARGETTESTS)
	@echo "Tests removed!"
	@$(rm) $(BINDIR)/$(TARGET)
	@echo "Executable removed!"
