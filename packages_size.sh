#!/bin/bash
if [ $# -ne 1 ]
then
        echo "usage : $0 <0/1/2/3>"
        exit 0 
fi

if [ $1 -eq 0 ]
then
	aptitude show '~n.*' | awk '\
	/^Package:/ {p = $0};\
	/^State:/ {s = $0};\
	/^Uncompressed Size:/ {print p " " s " " $0};\
	' | grep 'State: installed' | sed 's/: /:/g' | sort -t: -n -k4 | more
fi

if [ $1 -eq 1 ]
then
	dpkg-query -W --showformat='${Installed-Size;10}\t${Package}\n' | sort -k1,1n
fi

if [ $1 -eq 2 ]
then
	dpkg-query --show --showformat='${Package;-50}\t${Installed-Size}\n' | sort -k 2 -n
fi

if [ $1 -eq 3 ]
then
	dpkg-query --show --showformat='${Package;-50}\t${Installed-Size} ${Status}\n' | sort -k 2 -n |grep -v deinstall
fi
