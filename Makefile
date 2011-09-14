all: lowess.so

lowess.o: lowess.c
	gcc -O3 -fPIC -Wall -std=gnu99 -lm -c lowess.c

lowess.so: lowess.o
	gcc -shared -Wl,-soname,liblowess.so -o liblowess.so lowess.o

clean:
	rm -f lowess.o liblowess.so
