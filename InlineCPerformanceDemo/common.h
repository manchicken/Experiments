#ifndef __INLINE_C_DEMO_COMMON_H__
#define __INLINE_C_DEMO_COMMON_H__

#include <stdlib.h>
#include <string.h>

#define ITERATIONS_PER_TEST	1000000

void run_all(char* mem, size_t size); // This is the test you're looking for!

void read_100_bytes_from_dev_random();
void do_some_math();
void play_with_passed_in_memory(char* mem, size_t size);

#endif /* __INLINE_C_DEMO_COMMON_H__ */