
# Sanjeev Sariya \
950 New Hamp Ave. 18 March 2016 \
make file

CC=gcc
CFLAGS=-Wall -g -pedantic -std=gnu99

all: Program_rdp

Program_rdp: main.o parse_files.o rep_seq.o
	$(CC) $(FLAGS) main.o parse_files.o rep_seq.o -o Program_rdp

parse_files.o: parse_files.c 
	$(CC) $(CFLAGS) parse_files.c

rep_seq.o: rep_seq.c 
	$(CC) $(CFLAGS) rep_seq.c

#main.o: main.c 
###$(CC) $(CFLAGS) parse_files.o main.c
