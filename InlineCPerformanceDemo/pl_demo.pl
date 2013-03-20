#!/usr/bin/env perl

use Inline C => Config =>
	AUTO_INCLUDE => "#include <stdio.h>\n#include <common.h>\n",
	INC => '-I./',
	FORCE_BUILD => 1,
	CLEAN_AFTER_BUILD => 0,
	LIBS => ['-L'.$ENV{PWD}.' -ldemo'];
use Inline C => 'DATA';
# Inline->init();

sub plmain {
	my $foo = "I'm a cat. I'm a kitty cat, and I meow meow meow.";
	_c_run_all($foo);
	
	return 0;
}

exit &plmain;

__DATA__
__C__

int _c_run_all (SV* in) {
	size_t size = 0;
	char *foo = SvPVbyte_nolen(in);
	size = strlen(foo)+1;
	
	time_t start = time(NULL);
	run_all(foo, size);
	time_t stop = time(NULL);
	
	fprintf(stderr, "That all took about %ld seconds.\n", (long)(stop-start));
}
