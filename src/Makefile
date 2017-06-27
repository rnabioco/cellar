CC = g++
CFLAGS = -ggdb -Wall -O2
LIBS = -lbz2 -lz

all: makeIdxFastq
	mv makeIdxFastq ../bin/
	
makeIdxFastq: makeIdxFastq.cpp
	$(CC) $(CFLAGS) -o $@ $< $(LIBS)
