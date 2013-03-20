#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <common.h>

#define DUMMY "/etc/php.ini.default"

void run_all(char *mem, size_t size) {
	int x = 0;
	
	fprintf(stderr, "Iterations are set at %d\n",ITERATIONS_PER_TEST);
	
	for (x = 0; x < ITERATIONS_PER_TEST; x += 1) {
		read_100_bytes_from_dev_random();
		do_some_math();
		play_with_passed_in_memory(mem, size);
	}
	
	return;
}

void read_100_bytes_from_dev_random() {
	FILE *infile = fopen(DUMMY, "r");
	char buffer[101];
	
	memset(buffer, '\0', sizeof(buffer));
	
	srand(time(NULL));
	fseek(infile, rand() % 100, SEEK_CUR);

	fread(buffer, sizeof(char), 100, infile);
	
	if (strlen(buffer) != 100) {
		fprintf(stderr, "WTF?! Not 100 bytes in strlen (%ld)!\n", strlen(buffer));
	}
	memset(buffer, '\0', sizeof(buffer));
	fclose(infile);
}

int subtract_one(int operand) {
	return operand - 1;
}

void do_some_math() {
	int foo = 1234;
	
	while (foo) {
		foo = subtract_one(foo);
	}
	
	return;
}

void play_with_passed_in_memory(char *mem, size_t size) {
	char *foo = mem+(size-2);
	char *dest = malloc(size);
	char *ptr = dest;
	
	memset(dest, '\0', size);
	
	while (foo >= mem && *foo != '\0') {
		*ptr = *foo;
		foo--;
		ptr++;
	}
	
	static int first = 0;
	if (!first++) {
		printf("Passed in '%s' and flipped it to '%s'\n", mem, dest);
	}
}