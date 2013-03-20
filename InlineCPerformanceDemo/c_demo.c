#include <common.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

static char* parent_memory = "I'm a cat. I'm a kitty cat, and I meow meow meow.";

int main () {
	time_t start = time(NULL);
	run_all(parent_memory, strlen(parent_memory)+1);
	time_t stop = time(NULL);
	
	fprintf(stderr, "That all took about %ld seconds.\n", (long)(stop-start));
	
	return 0;
}