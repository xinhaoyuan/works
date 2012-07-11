#!/bin/sh

wc -l `find . '!' '(' -path './obj/' -or -regex '.*x86emu.*' -or -regex ".*lwip.*" ')' -and -iregex '\(.*\.cpp\|.*\.hpp\|.*\.c\|.*\.h\|.*\.S\)'`
