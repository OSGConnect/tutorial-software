#!/bin/sh
echo -n FILE1: 
/usr/bin/file /usr/bin/file
echo -n FILE2: 
./file ./file
echo -n FILE3:
file `which file`
echo PATH and WHICH and LS:
echo $PATH
which -a file
ls -al

