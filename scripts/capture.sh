#!/bin/bash

CASE=$1

if [ ! -d $CASE ] ; then
    echo "no such test case directory: $CASE"
    exit 1;
fi

if [ ! -f $CASE/ghulflags ] ; then
    echo "not a test case directory (no ghulflags): $CASE"
    exit 1;
fi

if [ ! -f $CASE/failed ] ; then
    echo "expected to find failed marker in $CASE - run the test first"
    exit 1
fi

if [ -f $CASE/err.sort ] ; then
    mv $CASE/err.sort $CASE/err.expected
fi

if [ -f $CASE/warn.sort ] ; then
    mv $CASE/warn.sort $CASE/warn.expected
fi

# Deliberately no il.expected: these tasks assert what the program prints, not what the
# compiler emits. A test folder with no il.expected has its IL output ignored.

if [ -f $CASE/run.out ] ; then
    mv $CASE/run.out $CASE/run.expected
    rm -f $CASE/fail.expected
else
    echo >$CASE/fail.expected
fi

exit 0
