#!/bin/sh
#
#    makediffv2.sh
#    Warren Brown 20171006
#    University of Florida Fall 2017 COP4600 Project 1
#
#	This work is licensed under a 
#	Creative Commons Attribution 4.0 International License
#	http://creativecommons.org/licenses/by/4.0/
#
TEMPFILES="sedtemp.txt newfiles.txt newfilestemp.txt existingfilesorig.txt existingfiles.txt existfilediffstub.txt"

if [ -e p1diff.txt ]
then
	rm p1diff.txt
else
	touch p1diff.txt
fi

rmTempFiles()
 {
	for fileName in $TEMPFILES
	do
		if [ -e $fileName ]
		then
			rm $fileName
		fi 
	done
}

rmTempFiles

sed 's/src/src_original/' filelist.txt > sedtemp.txt

while read f; do
	
	if [ -e $f ]
	then
		echo $f >> existingfilesorig.txt 
	else
		echo $f >> newfilestemp.txt
	fi
done <sedtemp.txt

sed 's/src_original/src/' newfilestemp.txt > newfiles.txt
sed 's/src_original/src/' existingfilesorig.txt > existingfiles.txt
paste existingfilesorig.txt existingfiles.txt > existfilediffstub.txt

while read j; do
#	if [ -z $j ]
#	then
#		echo "Skipping empty line."
#	else
		echo "diff -uN $j >> p1diff.txt"
        	diff -uN $j >> p1diff.txt
#	fi
done <existfilediffstub.txt

while read k; do
	if [ -z $k ]
	then
		echo "Skipping empty line."
	else
		echo "diff -u --unidirectional-new-file /dev/null $k >> p1diff.txt"
		diff -u --unidirectional-new-file /dev/null $k >> p1diff.txt
	fi
done <newfiles.txt

rmTempFiles





