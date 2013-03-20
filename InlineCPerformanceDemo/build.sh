#!/bin/bash

CC=`which gcc`
PERL=`which perl`
AR=`which ar`

$CC -I./ -o common.o -c common.c
$AR -rs libdemo.a common.o

$CC -I./ -L./ -ldemo -o c_demo -lm -lc c_demo.c
$PERL -c pl_demo.pl
